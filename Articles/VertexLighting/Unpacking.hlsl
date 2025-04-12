float4 _GlobalVertexOcclusionColor = 1;
float _GlobalVertexOcclusionStrength = 1;
float _GlobalVertexLightingStrength = 1;
float _GlobalVertexLightingTransition = 0;

void UnpackTwoFloats(float packed, 
    out float a, out float b)
{
    uint packedInt = asuint(packed);
    a = float((packedInt >> 16) & 0xFFFF) / 65535.0;
    b = float(packedInt & 0xFFFF) / 65535.0;
}

void UnpackThreeFloats(float packed, 
    out float a, out float b, out float c)
{
    uint packedInt = asuint(packed);
    a = float((packedInt >> 20) & 0x3FF) / 1023.0;
    b = float((packedInt >> 10) & 0x3FF) / 1023.0;
    c = float(packedInt & 0x3FF) / 1023.0;
}

void UnpackBakedVertexData_float(float4 uv, 
    out float3 ao, out float3 lighting, 
    out float aoStrength, out float lightingStrength)
{
    ao = lerp(_GlobalVertexOcclusionColor.rgb, float3(1, 1, 1), uv.x);
    float lightR, lightG, lightB;
    float light2R, light2G, light2B;
    UnpackThreeFloats(uv.y, lightR, lightG, lightB);
    UnpackTwoFloats(uv.z, aoStrength, lightingStrength);
    UnpackThreeFloats(uv.w, light2R, light2G, light2B);
    
    float3 light1 = float3(lightR, lightG, lightB) * 10.0;
    float3 light2 = float3(light2R, light2G, light2B) * 10.0;

    lighting = lerp(light1, light2, _GlobalVertexLightingTransition);
    aoStrength *= _GlobalVertexOcclusionStrength;
    lightingStrength *= _GlobalVertexLightingStrength;

}