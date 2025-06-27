// TANGENT AND TEXTURE SPACE
float3x3 GetTBN(float3 normal, float4 tangent)
{
    float3 bitangent = cross(normal, tangent.xyz) * tangent.w;
    float3x3 tbn = float3x3(tangent.xyz, bitangent, normal);
    return tbn;
}

float3 ToTangentSpace(float3 v, float3x3 tbn)
{
    return mul(tbn, v);
}

float3 FromTangentSpace(float3 v, float3x3 tbn)
{
    return mul(transpose(tbn), v);
}

float3 ToTextureSpace(float3 v, float3 textureScale)
{
    return v / textureScale;
}

float3 FromTextureSpace(float3 v, float3 textureScale)
{
    return v * textureScale;
}