// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/SplashMap"
{
    Properties
    {
        _MainTex ("Splat Map", 2D) = "white" {}
        _DetailTex ("Detail Texture", 2D) = "grey"{}
        [NoScaleOffset] _FirText ("First Texture", 2D) = "white" {}
        [NoScaleOffset] _SecText ("Second Texture", 2D) = "white" {}
        [NoScaleOffset] _ThiText ("Third Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram
            // make fog work
            //#pragma multi_compile_fog

            #include "UnityCG.cginc"

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
            sampler2D _FirText, _SecText, _ThiText;
            float4 _MainTex_ST, _DetailTex_ST;

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
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uvSplat : TEXCOORD1;
            };

            Interpolators MyVertexProgram(VertexData v_in)
            {
                Interpolators to_ps;

                to_ps.position = UnityObjectToClipPos(v_in.position);
                to_ps.uv = v_in.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                to_ps.uvSplat = v_in.uv;

                return to_ps;
            }

            float4 MyFragmentProgram(Interpolators p_in) : SV_TARGET
            {
                float4 splat = tex2D(_MainTex, p_in.uvSplat);

                return tex2D(_FirText, p_in.uv) * splat.r + tex2D(_SecText, p_in.uv) * (1 - splat.r) + tex2D(_ThiText,p_in.uv) * (2-splat.r);
            }

            ENDHLSL
        }
    }
}
