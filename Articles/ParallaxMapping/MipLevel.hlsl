float CalculateMipLevel(float2 uv, float2 textureSize)
{
    float2 dx = ddx(uv * textureSize);
    float2 dy = ddy(uv * textureSize);
    
    float lenX = dot(dx, dx);
    float lenY = dot(dy, dy);
    
    float rho = max(lenX, lenY);
    
    float mipLevel = 0.5 * log2(rho);

    return max(mipLevel, 0.0);
}