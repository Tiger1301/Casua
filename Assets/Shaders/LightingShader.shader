// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/LightingShader"
{
    Properties
    {
        _MainTex ("Albedo", 2D) = "white" {}
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
        //_SpecularTint ("Specular", Color) = (0.5, 0.5, 0.5)
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

            //#include "Lighting2.cginc"
            //#include "UnityCG.cginc"
            //#include "UnityStandardBRDF.cginc"
            //#include "UnityStandardUtils.cginc"
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
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Tint;
            float _Smoothness;
            //float4 _SpecularTint;
            float _Metallic;
            
            //v2f vert (appdata v)
            //{
            //    v2f o;
            //    o.vertex = UnityObjectToClipPos(v.vertex);
            //    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            //    UNITY_TRANSFER_FOG(o,o.vertex);
            //    return o;
            //}
            //
            //fixed4 frag (v2f i) : SV_Target
            //{
            //    // sample the texture
            //    fixed4 col = tex2D(_MainTex, i.uv);
            //    // apply fog
            //    UNITY_APPLY_FOG(i.fogCoord, col);
            //    return col;
            //}
            
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
                //float3 lightVec = _WorldSpaceLightPos0.xyz - i.worldPos;
	            //float attenuation = 1 / (1 + dot(lightVec, lightVec));
                UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPos);
                light.color = _LightColor0.rgb * attenuation;
                light.ndotl = DotClamped(i.normal, light.dir);
                return light;
            }

            float4 MyFragmentProgram (Interpolators i) : SV_TARGET 
            {
                i.normal = normalize(i.normal);
                //float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                //float3 lightColor = _LightColor0.rgb;
                float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
                //albedo *= max(_SpecularTint.r, max(_SpecularTint.g, _SpecularTint.b));
                float3 specularTint /*= albedo * _Metallic*/;
                float oneMinusReflectivity /*= 1 - _Metallic*/;
				//albedo = EnergyConservationBetweenDiffuseAndSpecular(albedo, _SpecularTint.rgb, oneMinusReflectivity);
                //albedo *= oneMinusReflectivity;
                albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, specularTint, oneMinusReflectivity);
				//float3 diffuse = albedo * lightColor * DotClamped(lightDir, i.normal);
                //float3 reflectionDir = reflect(-lightDir, i.normal);
                //float3 halfVector = normalize(lightDir + viewDir);
                //return float4(diffuse, 1);
                //return float4(reflectionDir * 0.5 + 0.5, 1);
                //float3 specular = specularTint * lightColor * pow(DotClamped(/*viewDir, reflectionDir*/halfVector, i.normal),_Smoothness * 10);
            
                //UnityLight light;
				//light.color = lightColor;
				//light.dir = lightDir;
				//light.ndotl = DotClamped(i.normal, lightDir);
            
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

            //#include "Lighting2.cginc"
            //#include "UnityCG.cginc"
            //#include "UnityStandardBRDF.cginc"
            //#include "UnityStandardUtils.cginc"
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
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Tint;
            float _Smoothness;
            //float4 _SpecularTint;
            float _Metallic;
            
            //v2f vert (appdata v)
            //{
            //    v2f o;
            //    o.vertex = UnityObjectToClipPos(v.vertex);
            //    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            //    UNITY_TRANSFER_FOG(o,o.vertex);
            //    return o;
            //}
            //
            //fixed4 frag (v2f i) : SV_Target
            //{
            //    // sample the texture
            //    fixed4 col = tex2D(_MainTex, i.uv);
            //    // apply fog
            //    UNITY_APPLY_FOG(i.fogCoord, col);
            //    return col;
            //}
            
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
                //float3 lightVec = _WorldSpaceLightPos0.xyz - i.worldPos;
	            //float attenuation = 1 / (1 + dot(lightVec, lightVec));
                UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPos);
                light.color = _LightColor0.rgb * attenuation;
                light.ndotl = DotClamped(i.normal, light.dir);
                return light;
            }

            float4 MyFragmentProgram (Interpolators i) : SV_TARGET 
            {
                i.normal = normalize(i.normal);
                //  float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                //float3 lightColor = _LightColor0.rgb;
                float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
                //albedo *= max(_SpecularTint.r, max(_SpecularTint.g, _SpecularTint.b));
                float3 specularTint /*= albedo * _Metallic*/;
                float oneMinusReflectivity /*= 1 - _Metallic*/;
				//albedo = EnergyConservationBetweenDiffuseAndSpecular(albedo, _SpecularTint.rgb, oneMinusReflectivity);
                //albedo *= oneMinusReflectivity;
                albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, specularTint, oneMinusReflectivity);
				//float3 diffuse = albedo * lightColor * DotClamped(lightDir, i.normal);
                //float3 reflectionDir = reflect(-lightDir, i.normal);
                //float3 halfVector = normalize(lightDir + viewDir);
                //return float4(diffuse, 1);
                //return float4(reflectionDir * 0.5 + 0.5, 1);
                //float3 specular = specularTint * lightColor * pow(DotClamped(/*viewDir, reflectionDir*/halfVector, i.normal),_Smoothness * 10);
            
                //UnityLight light;
				//light.color = lightColor;
				//light.dir = lightDir;
				//light.ndotl = DotClamped(i.normal, lightDir);
            
                UnityIndirect indirectLight;
				indirectLight.diffuse = 0;
				indirectLight.specular = 0;
            
                return UNITY_BRDF_PBS(albedo, specularTint, oneMinusReflectivity, _Smoothness, i.normal, viewDir, CreateLight(i), indirectLight);
			}

            ENDCG
        }
    }
}
