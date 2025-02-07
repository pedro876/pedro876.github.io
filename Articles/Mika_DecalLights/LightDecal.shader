Shader "Mika/LightDecal"
{
    Properties
    {
        [HDR] _BaseColor ("Color", Color) = (1,1,1,1)
        _ReadMask ("Read Mask", Int) = 15
        _Comparison ("Comparison", Int) = 6
    }
    SubShader
    {
        Tags {
            "LightMode" = "UniversalForward"
            "RenderType"="Transparent"
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Transparent-100"
            "UniversalMaterialType" = "Unlit"
        }
    
        Pass
        {
            Name "passDecalLight"
            ZTest GEqual
            Cull Front
            ZWrite Off
            Blend DstColor One
            
            //In binary, character layer is 1001 and water layer is 0001.
            //Using a ReadMask of 15 (1111) means that only water is excluded.
            //Using a ReadMask of 7 (0111) means that both water and characters are excluded.
            Stencil {
                Ref 1
                ReadMask [_ReadMask]
                Comp [_Comparison]
                Pass Keep
            }
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma multi_compile _ LOD_FADE_CROSSFADE
            
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #include_with_pragmas "Assets/Shaders/Base Mika style/MikaFunctions_Lighting.hlsl"
            
            uniform half4 _BaseColor;
            
            struct Attributes
            {
                float4 positionOS : POSITION;
            };
            
            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float4 screenPos : TEXCOORD0;
            };
            
            Varyings vert (Attributes input)
            {
                Varyings output;
                output.positionHCS = TransformObjectToHClip(input.positionOS.xyz);
                output.screenPos = ComputeScreenPos(output.positionHCS);
                return output;
            }
            
            half4 frag (Varyings input) : SV_Target
            {
                float2 screenUV = input.screenPos.xy / input.screenPos.w;
                float rawDepth = SampleSceneDepth(screenUV);
                float3 positionWS = ComputeWorldSpacePosition(screenUV, rawDepth, UNITY_MATRIX_I_VP);
                half3 positionOS = TransformWorldToObject(positionWS);
                
                half3 dir = positionOS;
                half distSqr = dot(dir, dir);
                clip(1.0-distSqr);
                
                half atten = LightingDistanceAttenuation(distSqr, 1.0);
                
                float4 positionHCS = TransformWorldToHClip(positionWS);
                half fogIntensity = ComputeFogIntensity2(positionHCS.z / positionHCS.w);
                
                half alpha = _BaseColor.a * fogIntensity;
                
                #if LOD_FADE_CROSSFADE
                alpha *= unity_LODFade.x;
                #endif
                
                return half4(_BaseColor.rgb * atten * alpha, 1);
            }
            ENDHLSL
        }
    }
}