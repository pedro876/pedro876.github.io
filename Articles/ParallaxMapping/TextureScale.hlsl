// EDITOR ONLY
// This code runs in a compute shader when a mesh is imported

float2 CalculateTriangleTiling(
    float2 uv0, float2 uv1, float2 uv2,
    float3 p0, float3 p1, float3 p2,
    float3x3 tbn)
{
    
    float2 t0 = mul(tbn, p0).xy;
    float2 t1 = mul(tbn, p1).xy;
    float2 t2 = mul(tbn, p2).xy;
    
    float uv_min_x;
    float uv_max_x;
    float pos_min_x;
    float pos_max_x;
    
    if (t0.x > t1.x && t0.x > t2.x) //t0 is right
    {
        uv_max_x = uv0.x;
        uv_min_x = t1.x < t2.x ? uv1.x : uv2.x;
        pos_max_x = t0.x;
        pos_min_x = t1.x < t2.x ? t1.x : t2.x;

    }
    else if (t1.x > t2.x) //t1 is right
    {
        uv_max_x = uv1.x;
        uv_min_x = t0.x < t2.x ? uv0.x : uv2.x;
        pos_max_x = t1.x;
        pos_min_x = t0.x < t2.x ? t0.x : t2.x;
    }
    else //t2 is right
    {
        uv_max_x = uv2.x;
        uv_min_x = t0.x < t1.x ? uv0.x : uv1.x;
        pos_max_x = t2.x;
        pos_min_x = t0.x < t1.x ? t0.x : t1.x;
    }
    
    float uv_diff_x = uv_max_x - uv_min_x;
    float pos_diff_x = pos_max_x - pos_min_x;
    
    float uv_min_y;
    float uv_max_y;
    float pos_min_y;
    float pos_max_y;
    
    if (t0.y > t1.y && t0.y > t2.y) //t0 is up
    {
        uv_max_y = uv0.y;
        uv_min_y = t1.y < t2.y ? uv1.y : uv2.y;
        pos_max_y = t0.y;
        pos_min_y = t1.y < t2.y ? t1.y : t2.y;

    }
    else if (t1.y > t2.y) //t1 is up
    {
        uv_max_y = uv1.y;
        uv_min_y = t0.y < t2.y ? uv0.y : uv2.y;
        pos_max_y = t1.y;
        pos_min_y = t0.y < t2.y ? t0.y : t2.y;
    }
    else //t2 is up
    {
        uv_max_y = uv2.y;
        uv_min_y = t0.y < t1.y ? uv0.y : uv1.y;
        pos_max_y = t2.y;
        pos_min_y = t0.y < t1.y ? t0.y : t1.y;
    }
    float uv_diff_y = uv_max_y - uv_min_y;
    float pos_diff_y = pos_max_y - pos_min_y;
    
    float2 tiling = float2(uv_diff_x, uv_diff_y) / float2(pos_diff_x, pos_diff_y);
    
    return tiling;
}

float2 CalculateAvgWorldTiling(uint i) // i = vertex index
{
    float3x3 tbn = GetTBN(i);
    float2 avgTiling = float2(0, 0);
    int triangleCount = 0;
    
    [loop]
    for (uint j = 0; j < _TriangleCount; j += 3)
    {
        uint a = _Triangles[j + 0];
        uint b = _Triangles[j + 1];
        uint c = _Triangles[j + 2];
        
        if (i == a || i == b || i == c)
        {
            // AVG TILING
            float2 uv0 = _Texcoord0[a];
            float2 uv1 = _Texcoord0[b];
            float2 uv2 = _Texcoord0[c];
            
            float3 p0 = _Vertices[a];
            float3 p1 = _Vertices[b];
            float3 p2 = _Vertices[c];
            
            float2 tiling = CalculateTriangleTiling(uv0, uv1, uv2, p0, p1, p2, tbn);
            avgTiling += tiling;
            triangleCount++;
        }
    }
    
    // AVG TILING
    if (triangleCount > 0)
    {
        avgTiling /= triangleCount;
    }
    
    return avgTiling;
}