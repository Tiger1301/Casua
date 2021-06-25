Shader "Unlit/GeometryShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
        _DetailTex ("Detail Texture", 2D) = "grey"{}
        _Factor("Factor", Range(0, 1)) = 0
        [NoScaleOffset] _HeightMap ("Heights", 2D) = "gray" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
            
            struct GeometryToPixel
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float4 col : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                //UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex, _DetailTex;
            float4 _MainTex_ST, _DetailTex_ST;
            float4 _Color;
            float _Factor;
            //float4 TransormObjectToHClip
            sampler2D _HeightMap;

            v2f vert (appdata IN)
            {
                v2f OUT;
                OUT.vertex = IN.vertex;
                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
                OUT.normal = IN.normal;
                return OUT;
                //v2f o;
                //o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //UNITY_TRANSFER_FOG(o,o.vertex);
                //return o;
            }

            float rand(float3 co)
            {
                return frac(sin(dot(co.xyz, float3(12.9898, 78.233, 45.5432))) * 43758.5453);
            }

            [maxvertexcount(12)]
            void geom(triangle v2f IN[3], inout TriangleStream<GeometryToPixel> tristream)
            {
                GeometryToPixel o;

                //for (int i = 0; i < 3; i++)
                //{
                //    o.pos = UnityObjectToClipPos(IN[i].vertex);
                //    o.uv = TRANSFORM_TEX(IN[i].uv, _MainTex);
                //    tristream.Append(o);
                //}

                float3 EdgeA = IN[1].vertex - IN[0].vertex;
                float3 EdgeB = IN[2].vertex - IN[0].vertex;
                float3 NormalFace = normalize(cross(EdgeA, EdgeB));
                
                float3 CentrePos = (IN[0].vertex + IN[1].vertex + IN[2].vertex) / 3;
                float2 CentreTex = (IN[0].uv + IN[1].uv + IN[2].uv) / 3;
                CentrePos += float4(NormalFace, 0) * _Factor;
                
                for (int i = 0; i < 3; i++)
                {
                    o.pos = UnityObjectToClipPos(IN[i].vertex);
                    o.uv = IN[i].uv;
                    o.col = float4(0., 0., 0., 1.);
                    tristream.Append(o);
                
                    int iNext = (i + 1) % 3;
                    o.pos = UnityObjectToClipPos(IN[iNext].vertex);
                    o.uv = IN[iNext].uv;
                    o.col = float4(0., 0., 0., 1.);
                    tristream.Append(o);
                
                    o.pos = UnityObjectToClipPos(float4(CentrePos, 1));
                    o.uv = CentreTex;
                    o.col = float4(1.0, 1.0, 1.0, 1.);
                    tristream.Append(o);
                
                    tristream.RestartStrip();
                }
                
                o.pos = UnityObjectToClipPos(IN[0].vertex);
                o.uv = IN[0].uv;
                o.col = _Color;
                tristream.Append(o);
                
                o.pos = UnityObjectToClipPos(IN[1].vertex);
                o.uv = IN[1].uv;
                o.col = _Color;
                tristream.Append(o);
                
                o.pos = UnityObjectToClipPos(IN[2].vertex);
                o.uv = IN[2].uv;

                tristream.RestartStrip();
            }

            half4 frag(GeometryToPixel IN) : SV_Target
            {
                half4 color = tex2D(_MainTex, IN.uv) * _Color;
                return color;
            }
            ENDCG
        }
    }
}
