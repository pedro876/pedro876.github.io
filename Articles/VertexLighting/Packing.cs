static Vector4 EncodeOcclusionLighting(
    float occlusion, 
    Vector3 light, 
    Vector3 light2, 
    float occlusionStrength, 
    float lightingStrength)
{
    Vector4 texcoord = Vector4.zero;
    texcoord.x = occlusion;

    light /= 10.0f;
    light2 /= 10.0f;

    light.x = Mathf.Clamp01(light.x);
    light.y = Mathf.Clamp01(light.y);
    light.z = Mathf.Clamp01(light.z);
    light2.x = Mathf.Clamp01(light2.x);
    light2.y = Mathf.Clamp01(light2.y);
    light2.z = Mathf.Clamp01(light2.z);

    texcoord.y = PackThreeFloats(light.x, light.y, light.z);
    texcoord.z = PackTwoFloats(occlusionStrength, lightingStrength);
    texcoord.w = PackThreeFloats(light2.x, light2.y, light2.z);

    return texcoord;
}

static float PackTwoFloats(float a, float b)
{
    uint ai = (uint)(a * 65535);
    uint bi = (uint)(b * 65535);
    uint packed = (ai << 16) | bi;
    return IntToFloat.Convert(packed);
}

static float PackThreeFloats(float a, float b, float c)
{
    uint ai = (uint)(a * 1023);
    uint bi = (uint)(b * 1023);
    uint ci = (uint)(c * 1023);
    uint packed = (ai << 20) | (bi << 10) | ci;
    return IntToFloat.Convert(packed);
}

[StructLayout(LayoutKind.Explicit)]
struct IntToFloat
{
    [FieldOffset(0)] private float f;
    [FieldOffset(0)] private uint ui;
    public static float Convert(uint value)
    {
        return new IntToFloat { ui = value }.f;
    }
}