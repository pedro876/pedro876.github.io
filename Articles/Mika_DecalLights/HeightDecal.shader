Shader "Mika/HeightDecal"
{
    Properties
    {
        _BaseColor ("Color", Color) = (1,1,1,1)
        _FadingUnits ("Fading Units", Float) = 1
        [KeywordEnum(CUBE, CYLINDER)]
        MASK_SHAPE("Mask Shape", Float) = 0
    }
    SubShader
    {
        Tags {
            "LightMode" = "UniversalForward"
            "RenderType"="Transparent"
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Transparent-99"
            "UniversalMaterialType" = "Unlit"
        }
    
        Pass
        {
            Name "passDecalHeight"
            ZTest GEqual
            Cull Front
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            Stencil {
                Ref 1
                Comp NotEqual
                Pass Keep
            }
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma multi_compile _ LOD_FADE_CROSSFADE
            #pragma multi_compile MASK_SHAPE_CUBE MASK_SHAPE_CYLINDER
            
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #include_with_pragmas "Assets/Shaders/Base Mika style/MikaFunctions_Lighting.hlsl"
            
            uniform half4 _BaseColor;
            uniform float _FadingUnitsXPositive;
            uniform float _FadingUnitsXNegative;
            uniform float _FadingUnitsZPositive;
            uniform float _FadingUnitsZNegative;
            uniform float _Edge0;
            uniform float _Edge1;
        
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
            
            SamplerState point_clamp_sampler;
            float4 _CameraDepthTexture_TexelSize;
            
            half4 frag (Varyings input) : SV_Target
            {
                float2 screenUV = input.screenPos.xy / input.screenPos.w;
                float rawDepth =  SampleSceneDepth(screenUV);
                float3 positionWS = ComputeWorldSpacePosition(screenUV, rawDepth, UNITY_MATRIX_I_VP);
                half3 positionOS = TransformWorldToObject(positionWS);
                
                half3 absPositionOS = abs(positionOS);
            
                #ifdef MASK_SHAPE_CUBE
                half maxCoord = max(absPositionOS.x, max(absPositionOS.y, absPositionOS.z));
                clip(-maxCoord+0.5);
                #elif MASK_SHAPE_CYLINDER
                clip(-absPositionOS.z+0.5);
                half distToCenter = length(absPositionOS.xy);
                clip(-distToCenter+0.5);
                #endif
            
                float3 cubeScale = float3(
                    length(float3(
                        unity_ObjectToWorld[0].x,
                        unity_ObjectToWorld[1].x,
                        unity_ObjectToWorld[2].x)
                    ), // scale x axis
                    length(float3(
                        unity_ObjectToWorld[0].y,
                        unity_ObjectToWorld[1].y,
                        unity_ObjectToWorld[2].y)
                    ), // scale y axis
                    length(float3(
                        unity_ObjectToWorld[0].z,
                        unity_ObjectToWorld[1].z,
                        unity_ObjectToWorld[2].z)
                    )  // scale z axis
                );
            
                float height = positionOS.y + 0.5;
                float heightFade = smoothstep(_Edge0,_Edge1,height);
                
                float2 lateralFadeXZ = (absPositionOS.xz * cubeScale.xz);
                lateralFadeXZ *= 2;
                
                float2 fadingUnits = float2(
                    positionOS.x > 0 ? _FadingUnitsXPositive : _FadingUnitsXNegative, 
                    positionOS.z > 0 ? _FadingUnitsZPositive : _FadingUnitsZNegative
                );
                float2 fadingSpan = fadingUnits*2;
                float2 lateralFadeStart = cubeScale.xz - fadingSpan;
                
                lateralFadeXZ -= lateralFadeStart;
                lateralFadeXZ /= fadingSpan;
                
                lateralFadeXZ = 1.0 - saturate(lateralFadeXZ);
                float lateralFade = lateralFadeXZ.x * lateralFadeXZ.y;
                
                float4 positionHCS = TransformWorldToHClip(positionWS);
                half fogIntensity = ComputeFogIntensity2(positionHCS.z / positionHCS.w);
                
                half alpha = _BaseColor.a * fogIntensity * heightFade * lateralFade;
                
                #if LOD_FADE_CROSSFADE
                alpha *= unity_LODFade.x;
                #endif
            
                return half4(_BaseColor.rgb, alpha);
            }
            ENDHLSL
        }
    }
}