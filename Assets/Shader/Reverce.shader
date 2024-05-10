Shader "Unlit/Reverce"
{
     Properties{
        [HideInInspector] _Textures("Textures", 2DArray) = "" {}
    }
 
    SubShader{
        Tags { "Queue"="Geometry" "RenderType"="Opaque" }
        Lighting Off
        Cull Off
 
        Pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
 
            struct vertexInput{
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };
 
            struct vertexOutput{
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };
 
            UNITY_DECLARE_TEX2DARRAY(_Textures);
 
            UNITY_INSTANCING_BUFFER_START(MPB)
                UNITY_DEFINE_INSTANCED_PROP(float4, _UVs)
                UNITY_DEFINE_INSTANCED_PROP(float, _TextureIndex)
                UNITY_DEFINE_INSTANCED_PROP(float, _Normal)
            UNITY_INSTANCING_BUFFER_END(MPB)
 
            vertexOutput vert(vertexInput input){
                vertexOutput output;
 
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);
 
                output.vertex = UnityObjectToClipPos(input.vertex);
                output.uv = input.uv;
 
                return output;
            }
 
            fixed4 frag(vertexOutput output, fixed facing : VFACE) : SV_Target{
                UNITY_SETUP_INSTANCE_ID(output);
 
                float normal = UNITY_ACCESS_INSTANCED_PROP(MPB, _Normal);
                if(normal == 2) clip(-1);
                else clip(facing * normal);
 
                float4 uniqueUV = UNITY_ACCESS_INSTANCED_PROP(MPB, _UVs);
                float2 finalUV = output.uv * uniqueUV.xy + uniqueUV.zw;
               
                return UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(finalUV, UNITY_ACCESS_INSTANCED_PROP(MPB, _TextureIndex)));
            }
 
            ENDCG
        }
    }
}