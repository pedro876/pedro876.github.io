int _AO_DenoiseRadius;
float2 _AO_DenoiseDirection;
float3 _AO_FarParams; // start, end, range

float GetDepthRange(float eyeDepth, float viewAngle, float targetResolutionHeight, float farStart, float farRange)
{
    const float _DENOISE_SMOOTHNESS = 0.02;
    const float _DENOISE_MAX_SMOOTHNESS = 2.0;
    const float _DENOISE_FAR_SMOOTHNESS = 5.0;
	
    float farness = saturate((eyeDepth - farStart) / farRange);
    float depthRange = min(_DENOISE_SMOOTHNESS / viewAngle / (targetResolutionHeight / 1080.0), _DENOISE_MAX_SMOOTHNESS);
    depthRange = lerp(depthRange, _DENOISE_FAR_SMOOTHNESS, farness);
    return depthRange;
}

OcclusionOutput DenoiseAO(Texture2D tex, float4 texelSize, float2 screenUV)
{
    int2 coord = screenUV * texelSize.zw;
	
    float2 depths;
    bool layer2;
    SampleSceneDepth(screenUV, depths, layer2);
	
    float eyeDepth = LinearEyeDepth(depths.x);
    float3 normal = DecodeNormal(SampleSceneNormals(screenUV, false).zw);
    float3 position = ReconstructWorldPosition(screenUV, depths.x);
    float3 viewDirection = GetViewDirection(position);
    float angle = Square(max(0.0001, abs(dot(viewDirection, normal))));
    float depthRange = GetDepthRange(eyeDepth, angle, texelSize.w, _AO_FarParams.x, _AO_FarParams.z);
    float avgOcclusion = 0.0;
    float totalWeight = 0.0;
	
    #ifdef _MULTI_LAYER_DEPTH
        float eyeDepth2 = LinearEyeDepth(depths.y);
        float3 normal2 = DecodeNormal(SampleSceneNormals(screenUV, true).zw);
        float3 position2 = ReconstructWorldPosition(screenUV, depths.y);
        float3 viewDirection2 = GetViewDirection(position2);
        float angle2 = Square(max(0.0001, abs(dot(viewDirection2, normal2))));
        float depthRange2 = GetDepthRange(eyeDepth2, angle2, texelSize.w, _AO_FarParams.x, _AO_FarParams.z);
        float avgOcclusion2 = 0.0;
        float totalWeight2 = 0.0;
    #endif
	
    for (int i = -_AO_DenoiseRadius; i <= _AO_DenoiseRadius; i++)
    {
        float2 otherUV = screenUV + _AO_DenoiseDirection * i * texelSize.xy;
        float3 occlusionSample = SAMPLE_TEXTURE2D_LOD(tex, point_clamp_sampler, otherUV, 0).rgb;
        float2 otherDepths = SampleSceneDepths(otherUV);
		
        #ifdef _MULTI_LAYER_DEPTH
            float occlusion = occlusionSample.g;
            float occlusion2 = occlusionSample.b;
            float otherDepth = otherDepths.x;
            float otherDepth2 = otherDepths.y;
        #else
            float occlusion = occlusionSample.r;
            float otherDepth = otherDepths.x;
        #endif
		
        float otherEyeDepth = LinearEyeDepth(otherDepth);
        float weight = 1.0 - saturate(abs(eyeDepth - otherEyeDepth) / depthRange);
        avgOcclusion += occlusion * weight;
        totalWeight += weight;
		
        #ifdef _MULTI_LAYER_DEPTH
            float otherEyeDepth2 = LinearEyeDepth(otherDepth2);
            float weight2 = 1.0 - saturate(abs(eyeDepth2 - otherEyeDepth2) / depthRange);
            avgOcclusion2 += occlusion2 * weight2;
            totalWeight2 += weight2;
        #endif
    }
	
    avgOcclusion /= totalWeight;
    if (DepthIsSkybox(depths.x)) avgOcclusion = 1.0;
	
    #ifdef _MULTI_LAYER_DEPTH
        avgOcclusion2 /= totalWeight2;
        if (DepthIsSkybox(depths.y)) avgOcclusion2 = 1.0;
        return OcclusionOutput(layer2 ? avgOcclusion2 : avgOcclusion, avgOcclusion, avgOcclusion2);
    #else
        return avgOcclusion;
    #endif
}