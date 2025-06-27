float FindTMax(float3 viewDirTS)
{
    //float tMax = IntersectLinePlane(float3(0.0, 0.0, 0.0), viewDirTS, float3(0, 0, -1), float3(0, 0, 1));
    float tMax = -rcp(viewDirTS.z); //Simplified intersection of line to plane
    return tMax;
}