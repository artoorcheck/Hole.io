Shader "DepthMask"
{
    SubShader
    {
        Tags {"Queue" = "Geometry-1" }
        Lighting Off
        Pass
        {
            ZWrite On
            ZTest Always
            ColorMask 0    
        }
    }
}