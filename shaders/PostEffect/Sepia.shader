Shader "BASICxSHADER/PostEffect/Sepia" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
  }
  SubShader {
    Cull Off ZWrite Off ZTest Always

    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform sampler2D _MainTex;

      // Vertex Input
      struct appdata {
        float4 vertex : POSITION;
        float2 uv     : TEXCOORD0;
      };

      // Vertex to Fragment
      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv  : TEXCOORD0;
      };

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      v2f vert(appdata v) {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);
        o.uv  = v.uv;
        return o;
      }

      //------------------------------------------------------------------------
      // Fragment Shader
      //------------------------------------------------------------------------
      fixed4 frag(v2f i) : SV_Target {
        fixed4 color = tex2D(_MainTex, i.uv);

        // Sepia
        half y = dot(color.rgb, half3(0.30, 0.59, 0.11));
        color.rgb = saturate(y + half3(0.19, -0.05, -0.22));

        return color;
      }
      ENDCG
    }
  }
}
