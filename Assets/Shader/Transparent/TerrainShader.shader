// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TerrainShader"
{
    Properties 
    {
        _Color ("Color", Color) = (1,1,1,1)
        _GradColor ("GradColor", Color) = (1,1,1,1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _MinH ("Min height", Range(-100,100)) = 0
        _MaxH ("Max height", Range(-100,100)) = 10
        _Fade ("Fade size", Range(0.1,10)) = 3
    }

    SubShader 
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass 
        {
            CGPROGRAM

            #pragma vertex vert alpha
            #pragma fragment frag alpha

            #include "UnityCG.cginc"

            struct appdata_t 
            {
                float4 vertex   : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f 
            {
                float4 vertex  : SV_POSITION;
                half2 texcoord : TEXCOORD0;
				float4 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 uv_MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _GradColor;

            half _MinH;
            half _MaxH;
            half _Fade;
            
            float3 worldPos;

            v2f vert (appdata_t v)
            {
                v2f o;

                o.vertex     = UnityObjectToClipPos(v.vertex);
                v.texcoord.x = 1 - v.texcoord.x;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.texcoord   = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float fade = 1/_Fade;
                float coef = clamp((i.worldPos.y + _Fade - _MinH)*fade, 0., 1.)*clamp((_MaxH + _Fade - i.worldPos.y)*fade, 0., 1.);
                fixed4 plane = tex2D (_MainTex, i.texcoord.xy) * (_Color * coef + _GradColor*(1-coef));
                
                return plane;
            }

            ENDCG
        }
    }
}
