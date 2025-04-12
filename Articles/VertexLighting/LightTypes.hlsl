#define LIGHTTYPE_DIRECTIONAL 0
#define LIGHTTYPE_POINT 1
#define LIGHTTYPE_SPOT 2

struct Light
{
    int type;
    float3 position;
    float3 direction;
    int castShadows;
    int allowBouncing;
    float3 color;
    float intensity;
    float indirectIntensity;
    float range;
    float2 spotAngle;
    float angleStrength;
    float shadowStrength;
};

StructuredBuffer<Light> _Lights;
int _LightCount;

float GetLightAttenuation(float3 positionWS, float3 normalWS, int lightType, 
    Light light, float3 lightPosition, float3 lightDirection)
{
    float distanceAtten = 1.0;
    if (lightType != LIGHTTYPE_DIRECTIONAL)
    {
        float3 dir = positionWS - light.position;
        float distanceSqr = SqrMagnitude(dir);
        distanceAtten = 1.0 - pow(distanceSqr / (light.range * light.range), 2.0);
        distanceAtten = max(0.0, distanceAtten);
        distanceAtten *= distanceAtten;
    }

    float angleAttenuation = saturate(dot(normalWS, lightDirection));
    angleAttenuation = lerp(1.0, angleAttenuation, light.angleStrength);


    if (lightType == LIGHTTYPE_SPOT)
    {
        float outerAngle = light.spotAngle.y;
        float innerAngle = light.spotAngle.x;
        float cosOuter = cos(DEG2RAD * outerAngle * 0.5);
        float cosInner = cos(DEG2RAD * innerAngle * 0.5);
        float angle = dot(normalize(positionWS - lightPosition), light.direction);
        float spotAtten = saturate((angle - cosOuter) / (cosInner - cosOuter));
        spotAtten *= spotAtten;
        angleAttenuation *= spotAtten;
    }

    return angleAttenuation * distanceAtten;
}