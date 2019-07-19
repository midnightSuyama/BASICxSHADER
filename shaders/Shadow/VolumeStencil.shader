Shader "BASICxSHADER/Shadow/VolumeStencil" {
  Properties {
    _Intensity ("Intensity", Range (0, 1)) = 0.5
  }
  SubShader {
    Cull Off ZWrite Off ZTest Always

    Pass {
      Blend SrcAlpha OneMinusSrcAlpha
      Stencil {
        Ref 0
        Comp NotEqual
      }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform half _Intensity;

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      float4 vert(float4 vertex : POSITION) : SV_POSITION {
        return UnityObjectToClipPos(vertex);
      }

      //------------------------------------------------------------------------
      // Fragment Shader
      //------------------------------------------------------------------------
      fixed4 frag() : SV_Target {
        return fixed4(0, 0, 0, _Intensity);
      }
      ENDCG
    }
  }
}
