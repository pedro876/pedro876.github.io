float3 rayPosOS = FromTextureSpace(rayPosTS - rayOriginTS, textureScale);
positionWS += FromTangentSpace(rayPosOS, tbn);
uv = rayPosTS.xy;