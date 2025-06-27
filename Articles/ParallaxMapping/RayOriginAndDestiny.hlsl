// WS: World Space
// OS: Object-Tangent Space
// TS: Texture Space
float3 viewDirWS = GetViewDirection(positionWS, true);
float3 viewDirOS = ToTangentSpace(viewDirWS, tbn);
float3 viewDirTS = ToTextureSpace(viewDirOS, textureScale);
float tMax = FindTMax(viewDirTS);
float3 rayOriginTS = float3(uv, 0.0);
float3 rayPosTS = rayOriginTS - viewDirTS * tMax * (heightDirection * 0.5 + 0.5);
float3 rayStepTS = (viewDirTS * tMax) / (samples - 1);
rayPosTS += rayStepTS * noise; //Helps reducing banding when using a low sample count.