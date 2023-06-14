// UNITY_SHADER_NO_UPGRADE
Shader "Tilia/Vignette"
{
    Properties
    {
            _Color("Color", Color) = (0, 0, 0, 1)
            _Size("Size", Range(0, 1)) = 0.9
            _Feather("Feather", Range(0, 1)) = 0.15
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent+99"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }

        Pass {
            Blend SrcAlpha OneMinusSrcAlpha ZTest Always ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            float4 _Color;
            float _Size;
            float _Feather;

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            UNITY_DECLARE_SCREENSPACE_TEXTURE(_MainTex);

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color = _Color;
                color.w *= saturate((i.uv.y - (0.5 - sqrt(0.25 - ((_Size * _Size) * 0.25)))) / ((_Feather * _Feather + 0.0001)));
                return color;
            }
            ENDCG
        }
    }
}
