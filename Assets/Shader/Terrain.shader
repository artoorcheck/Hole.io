Shader "Custom/Terrain"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _LayerN1Tex ("Holes", 2D) = "white" {}
        _MainTex ("Plane", 2D) = "white" {}
        _Layer1Tex ("Mountains", 2D) = "white" {}
        _Layer2Tex ("Rocks", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _PlainH ("Plain height", Range(0,300)) = 0
        _MountainH ("Mountain height", Range(0,300)) = 10
        _RockH ("Rock height", Range(0,300)) = 100
        _Fade ("Fade size", Range(0.1,10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
        
        sampler2D _LayerN1Tex;
        sampler2D _MainTex;
        sampler2D _Layer1Tex;
        sampler2D _Layer2Tex;

        struct Input
        {
            float2 uv_LayerN1Tex;
            float2 uv_MainTex;
            float2 uv_Layer1Tex;
            float2 uv_Layer2Tex;
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
        half _PlainH;
        half _MountainH;
        half _RockH;
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
            fixed4 hole = tex2D (_LayerN1Tex, IN.uv_LayerN1Tex) * _Color;
            fixed4 plane = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 mountain = tex2D (_Layer1Tex, IN.uv_Layer1Tex) * _Color;
            fixed4 rock = tex2D (_Layer2Tex, IN.uv_Layer2Tex) * _Color;
            float fade = 1/_Fade;
            o.Albedo = hole.rgb*clamp((_PlainH + _Fade - IN.worldPos.y)*fade, 0., 1.)
                + plane.rgb*clamp((IN.worldPos.y + _Fade - _PlainH)*fade, 0., 1.)*clamp((_MountainH + _Fade - IN.worldPos.y)*fade, 0., 1.)+
                + mountain.rgb*clamp((IN.worldPos.y + _Fade - _MountainH)*fade, 0., 1.)*clamp((_RockH + _Fade - IN.worldPos.y)*fade, 0., 1.)+
                + rock.rgb*clamp((IN.worldPos.y + _Fade - _RockH)*fade, 0., 1.);
                //+snow.rgb*clamp((IN.worldPos.y + _Fade - _SnowH)*fade, 0., 1.);
            // Metallic and smoothness come from slider variables
            //o.Albedo = o.Albedo.rgb + snow.rgb*clamp((IN.worldPos.y + _Fade - _SnowH)*fade, 0., 1.);
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = plane.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
