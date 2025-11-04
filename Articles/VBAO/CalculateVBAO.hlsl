float _AO_OuterRadius;
float _AO_InnerRadius;
float3 _AO_FarParams; // start, end, range
float _AO_FarRadius;
float _VBAO_Thickness;

#define _AO_Radius (lerp(_AO_OuterRadius, _AO_FarRadius, farness))

#if defined(_VBAO_QUALITY_MEDIUM)
    #define _VBAO_SLICES 1
    #define _VBAO_SAMPLES_PER_SLICE 16
#elif defined(_VBAO_QUALITY_HIGH)
    #define _VBAO_SLICES 1
    #define _VBAO_SAMPLES_PER_SLICE 24
#elif defined(_VBAO_QUALITY_ULTRA)
    #define _VBAO_SLICES 2
    #define _VBAO_SAMPLES_PER_SLICE 32
#else
    #define _VBAO_SLICES 1
    #define _VBAO_SAMPLES_PER_SLICE 12
#endif

float2 SampleAONoise(float2 screenUV)
{
    uint2 coord = screenUV * GetCameraTexelSize().zw;
    return InterleavedGradientNoise2(coord);
}

float CalculateVBAO(float2 screenUV, float depth, float3 normalWS, float2 noise)
{
    if (DepthIsSkybox(depth))
        return 1.0;
	
    float hemisphereAngle = noise.x * PI;
    float cos_hemisphereAngle = cos(hemisphereAngle);
    float sin_hemisphereAngle = sin(hemisphereAngle);
	
    float eyeDepth = LinearEyeDepth(depth);
    float farness = saturate((eyeDepth - _AO_FarParams.x) / _AO_FarParams.z);
    float normalBias = lerp(_SSAO_NORMAL_MIN_BIAS, _SSAO_NORMAL_MAX_BIAS, farness);
    float3 normal = TransformWorldToViewNormal(normalWS);
    float3 position = ReconstructViewPosition(screenUV, depth) + normal * normalBias;
    float3 viewDir = -FastNormalize(position);
	
    float3x3 tbn = GetTBN(viewDir, GetSafeTangent(viewDir));
	
    const int Nd = _GTAO_SLICES;
    const int m = _GTAO_SAMPLES_PER_SLICE;
    const int mDiv2 = m / 2;
    const int ring = 0;
    float radius = _AO_Radius;
    float thickness = _VBAO_Thickness;
    float maxThickness = radius * 0.75;
	
    const float sliceRotation = PI / Nd;
    const float cos_sliceRotation = cos(sliceRotation);
    const float sin_sliceRotation = sin(sliceRotation);
    float2 direction = float2(0, 1);
	
    float occlusion = 0.0;
    float totalWeight = 0.0;
    for (int d = 0; d < Nd; d++)
    {
        direction = Rotate2D(direction, cos_sliceRotation, sin_sliceRotation);
        float3 directionTS = float3(Rotate2D(direction, cos_hemisphereAngle, sin_hemisphereAngle), 0.0);
        float3 sliceDirection = FromTangentSpace(directionTS, tbn);
        float3 sliceNormal = FromTangentSpace(float3(-directionTS.y, directionTS.x, 0.0), tbn);
        float3 normalProjected = ProjectPointOnPlane(normal, float3(0, 0, 0), sliceNormal);
        float normalProjectedLength = FastLength(normalProjected);
        normalProjected /= normalProjectedLength;
		
        float n = FastAcos(dot(normalProjected, sliceDirection)) - PI / 2.0;
        float h1 = -1.0;
        float h2 = -1.0;
        uint bi = 0;
		
        #define VBAO_SLICE_ITER(h, otherDepth, otherThickness, sign)\
        {\
            float3 otherPos = ReconstructViewPosition(sampleUV, otherDepth);\
            float3 otherPosBack = otherPos - viewDir * min(maxThickness, otherThickness) * _VBAO_Thickness;\
            float3 otherDir = otherPos - position;\
            float3 otherDirBack = otherPosBack - position;\
            float otherDirLength = FastLength(otherDir);\
            float otherDirBackLength = FastLength(otherDirBack);\
            float cos_angle = dot(otherDir, viewDir) / otherDirLength;\
            float cos_angle_back = dot(otherDirBack, viewDir) / otherDirBackLength;\
            float angle = FastAcos(cos_angle);\
            float angleBack = FastAcos(cos_angle_back);\
            float2 minmax = saturate((sign * -float2(angle, angleBack) - n + 1.5707) / PI);\
            minmax = minmax.x > minmax.y ? minmax.yx : minmax;\
            uint2 ab = clamp(round(32.0 * float2(minmax.x, minmax.y - minmax.x)), 0, 32);\
            uint bj = ((1u << ab.y) - 1u) << ab.x;\	
            bi = bi | bj;\
        }
		
        #ifdef _MULTI_LAYER_DEPTH
            #define VBAO_SLICE_LAYERS(h, sign)\
            {\
                float4 otherDepths = SampleRawSceneDepthData(sampleUV);\
                VBAO_SLICE_ITER(h, otherDepths.r, otherDepths.b, sign)\
                VBAO_SLICE_ITER(h, otherDepths.g, otherDepths.a, sign)\
            }
        #else
            #define VBAO_SLICE_LAYERS(h, sign)\
            {\
                float otherDepth = SampleSceneDepth(sampleUV);\
                VBAO_SLICE_ITER(h, otherDepth, 1.0, sign)\
            }
        #endif
		
        #define VBAO_SLICE_DIR(h, sign) \
        {\
            for (int i = 1; i <= mDiv2; i++)\
            {\
                float fi = ((float)i-noise.y)/mDiv2;\		
                fi = fi * fi;\
                float3 samplePos = position + sliceDirection * fi * radius * sign;\
                float2 sampleUV = TransformViewToScreenUV(samplePos);\
                if (!IsSaturated(sampleUV))
                    continue;\
                VBAO_SLICE_LAYERS(h, sign)\
            }\

        }
		
        VBAO_SLICE_DIR(h1, 1.0)
        VBAO_SLICE_DIR(h2, -1.0)
			
        occlusion += (1.0 - countbits(bi) / 32.0) * normalProjectedLength;
        totalWeight += normalProjectedLength;
    }
	
    occlusion /= totalWeight;
	
    return occlusion;
}