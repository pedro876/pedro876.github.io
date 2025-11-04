TEXTURE2D(_HilbertMap);
uint _HilbertResolution;
int _FrameCountMod64;

int2 ihilbert(int i, int level)
{
    int2 p = int2(0, 0);
    for (int k = 0; k < level; k++)
    {
        int2 r = int2(i >> 1, i ^ (i >> 1)) & 1;
        if (r.y == 0)
        {
            if (r.x == 1)
            {
                p = (1 << k) - 1 - p;
            }
            p = p.yx;
        }
        p += r << k;
        i >>= 2;
    }
    return p;
}

float2 MartinRobertR1Sequence(uint n)
{
    const float g = 1.6180339887498948482;
    const float a1 = 1.0 / g;
    float x = frac(0.5 + a1 * n);
    return x;
}

float2 MartinRobertR2Sequence(uint n)
{
    const float g = 1.32471795724474602596;
    const float a1 = 1.0 / g;
    const float a2 = 1.0 / (g * g);
    float x = frac(0.5 + a1 * n);
    float y = frac(0.5 + a2 * n);
    return float2(x, y);
}

uint Hilbert(uint2 p, uint level)
{
    uint d = 0;
    for (uint k = 0; k < level; k++)
    {
        uint n = level - k - 1;
        uint2 r = (p >> n) & 1;
        d += ((3 * r.x) ^ r.y) << (2 * n);
        if (r.y == 0)
        {
            if (r.x == 1)
            {
                p = (1 << n) - 1 - p;
            }
            p = p.yx;
        }
    }
    return d;
}

float R1Noise(uint2 coord)
{
    uint n = Hilbert(coord, 6);
    n += 288 * _FrameCountMod64;
    return MartinRobertR1Sequence(n);
}

float2 R2Noise(uint2 coord)
{
    uint n = Hilbert(coord, 6);
    n += 288 * _FrameCountMod64;
    return MartinRobertR2Sequence(n);
}

uint GetHilbertLUT(uint2 coord)
{
    coord %= _HilbertResolution;
    float2 encoded = LOAD_TEXTURE2D(_HilbertMap, coord);
    uint r = (uint(encoded.r * 255) & 0xFF);
    uint b = (uint(encoded.g * 255) & 0xFF) << 8;
    uint n = r + b;
    return n;
}

float2 R1NoiseLUT(uint2 coord)
{
    uint n = GetHilbertLUT(coord);
    n += 288 * _FrameCountMod64;
    return MartinRobertR1Sequence(n);
}

float2 R2NoiseLUT(uint2 coord)
{
    uint n = GetHilbertLUT(coord);
    n += 288 * _FrameCountMod64;
    return MartinRobertR2Sequence(n);
}

float2 InterleavedGradientNoise2(uint2 coord)
{
    float ign = InterleavedGradientNoise(coord, _FrameCountMod64);
    float ign2 = frac(ign * 4.854102);
    return float2(ign, ign2);
}