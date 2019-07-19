Shader "BASICxSHADER/Lighting/Ambient" {
  SubShader {
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Vertex Input
      struct appdata {
        float4 vertex : POSITION;
      };

      // Vertex to Fragment
      struct v2f {
        float4 pos : SV_POSITION;
      };

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      v2f vert(appdata v) {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);
        return o;
      }

      //------------------------------------------------------------------------
      // Fragment Shader
      //------------------------------------------------------------------------
      fixed4 frag(v2f i) : SV_Target {
        return UNITY_LIGHTMODEL_AMBIENT;
      }
      ENDCG
    }
  }
}
