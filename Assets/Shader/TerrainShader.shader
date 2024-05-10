Shader "Custom/Terrain"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _MinH ("Min height", Range(-100,100)) = 0
        _MaxH ("Max height", Range(-100,100)) = 10
        _Fade ("Fade size", Range(0.1,10)) = 3
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "RenderType"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Front 
        LOD 100

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
        
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };
        
        struct vs2ps
        {
            float4 Pos : POSITION;
            float4 TexCd : TEXCOORD0;
            float3 PosW : TEXCOORD1;
        };

        half _Glossiness;
        half _Metallic;
        half _MinH;
        half _MaxH;
        half _Fade;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        
 
        void vert (inout appdata_full v, out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input,o);
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 plane = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            float fade = 1/_Fade;
            o.Albedo = plane.rgb*clamp((IN.worldPos.y + _Fade - _MinH)*fade, 0., 1.)*clamp((_MaxH + _Fade - IN.worldPos.y)*fade, 0., 1.);
            o.Alpha = clamp((IN.worldPos.y + _Fade - _MinH)*fade, 0., 1.)*clamp((_MaxH + _Fade - IN.worldPos.y)*fade, 0., 1.);
                //+snow.rgb*clamp((IN.worldPos.y + _Fade - _SnowH)*fade, 0., 1.);
            // Metallic and smoothness come from slider variables
            //o.Albedo = o.Albedo.rgb + snow.rgb*clamp((IN.worldPos.y + _Fade - _SnowH)*fade, 0., 1.);
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
