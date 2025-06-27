float mip = CalculateMipLevel(uv, textureSize);
float3 lastRayPosTS = rayPosTS;
float lastHeight = rayPosTS.z;
bool hit = false;
    
for (int i = 0; i < samples && !hit; i++)
{
    float height = -(1.0 - SAMPLE_TEXTURE2D_LOD(heightMap, heightSampler, rayPosTS.xy, mip).r);
    height += heightDirection * 0.5 + 0.5;
    if (height > rayPosTS.z)
    {
        #if defined(POM_LINEAR_INTERPOLATION)
            float diffAC = abs(lastRayPosTS.z - lastHeight);
            float diffDB = abs(rayPosTS.z - height);
            float t = diffAC / (diffAC + diffDB);
            rayPosTS = lerp(lastRayPosTS, rayPosTS, t);
        #else
            rayPosTS.z = height;
        #endif
            
        hit = true;
    }
    else
    {
        lastRayPosTS = rayPosTS;
        lastHeight = height;
        rayPosTS += rayStepTS;
    }
}
    
if (isShadowCaster)
{
    // Prevent precision errors by adding an offset bias in shadow caster passes
    rayPosTS += viewDirTS * POM_SHADOW_OFFSET; //I found an offset of 0.08 to be good in practice.
}