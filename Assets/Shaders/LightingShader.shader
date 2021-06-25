// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/LightingShader"
{
    Properties
    {
        _MainTex ("Albedo", 2D) = "white" {}
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
        _DetailTex ("Detail Texture", 2D) = "grey"{}
        [Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
    }
    SubShader
    {
        Pass
        {
            Tags 
            { 
                "RenderType"="Opaque"
                "LightMode" = "ForwardBase"
            }
            LOD 100

            CGPROGRAM

            #pragma target 3.0

            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            #define POINT

            #include "UnityPBSLighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };
            
            sampler2D _MainTex, _DetailTex;
            float4 _MainTex_ST, _DetailTex_ST;
            float4 _Tint;
            float _Smoothness;
            float _Metallic;
            
            struct VertexData 
            {
				float4 position : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};
			
			struct Interpolators 
            {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
			};
            
			Interpolators MyVertexProgram (VertexData v) 
            {
				Interpolators i;
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.position = UnityObjectToClipPos(v.position);
                i.worldPos = mul(unity_ObjectToWorld, v.position);
				i.normal = UnityObjectToWorldNormal(v.normal);
				return i;
			}
            
            UnityLight CreateLight (Interpolators i) 
            {
                UnityLight light;
                light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
                UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPos);
                light.color = _LightColor0.rgb * attenuation;
                light.ndotl = DotClamped(i.normal, light.dir);
                return light;
            }

            float4 MyFragmentProgram (Interpolators i) : SV_TARGET 
            {
                i.normal = normalize(i.normal);
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
                float3 specularTint;
                float oneMinusReflectivity;
                albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, specularTint, oneMinusReflectivity);
            
                UnityIndirect indirectLight;
				indirectLight.diffuse = 0;
				indirectLight.specular = 0;
            
                return UNITY_BRDF_PBS(albedo, specularTint, oneMinusReflectivity, _Smoothness, i.normal, viewDir, CreateLight(i), indirectLight);
			}
            ENDCG
        }

        Pass
        {
            Tags 
            { 
                "RenderType"="Opaque"
                "LightMode" = "ForwardAdd"
            }
            LOD 100

            Blend One One
            ZWrite Off

            CGPROGRAM

            #pragma target 3.0

            #pragma multi_compile_fwdadd
            //#pragma multi_compile DIRECTIONAL DIRECTIONAL_COOKIE POINT SPOT

            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            #include "UnityPBSLighting.cginc"
            #include "AutoLight.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };
            
            sampler2D _MainTex, _DetailTex;
            float4 _MainTex_ST, _DetailTex_ST;
            float4 _Tint;
            float _Smoothness;
            float _Metallic;
            
            
            struct VertexData 
            {
				float4 position : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};
			
			struct Interpolators 
            {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
			};
            
			Interpolators MyVertexProgram (VertexData v) 
            {
				Interpolators i;
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.position = UnityObjectToClipPos(v.position);
                i.worldPos = mul(unity_ObjectToWorld, v.position);
				i.normal = UnityObjectToWorldNormal(v.normal);
				return i;
			}
            
            UnityLight CreateLight (Interpolators i) 
            {
                UnityLight light;
                #if defined(POINT) || defined(POINT_COOKIE) || defined(SPOT)
                light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
                #else
		        light.dir = _WorldSpaceLightPos0.xyz;
	            #endif
                UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPos);
                light.color = _LightColor0.rgb * attenuation;
                light.ndotl = DotClamped(i.normal, light.dir);
                return light;
            }

            float4 MyFragmentProgram (Interpolators i) : SV_TARGET 
            {
                i.normal = normalize(i.normal);
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
                float3 specularTint;
                float oneMinusReflectivity;
                albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, specularTint, oneMinusReflectivity);
            
                UnityIndirect indirectLight;
				indirectLight.diffuse = 0;
				indirectLight.specular = 0;
            
                return UNITY_BRDF_PBS(albedo, specularTint, oneMinusReflectivity, _Smoothness, i.normal, viewDir, CreateLight(i), indirectLight);
			}

            ENDCG
        }
    }
}
