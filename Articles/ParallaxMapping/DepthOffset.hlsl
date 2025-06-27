float GetOutputDepthFromWorldPosition(float3 positionWS)
{
    float4 positionCS = TransformWorldToHClip(positionWS);
    float z = positionCS.z / positionCS.w;
    return z;
}