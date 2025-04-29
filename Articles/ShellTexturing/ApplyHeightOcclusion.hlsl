void ApplyHeightOcclusion(
    inout float3 color, inout float occlusion,
    float fragHeight, float strength, float power)
{
    fragHeight = pow(fragHeight, power);
    color *= lerp(1.0, fragHeight, strength);
    occlusion *= lerp(1.0, fragHeight, strength);
}