Shader "BASICxSHADER/PostEffect/ZoomBlur" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _ZoomBlur ("Zoom Blur", Range (0, 1)) = 0.5
  }
  SubShader {
    Cull Off ZWrite Off ZTest Always

    Pass{
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform sampler2D _MainTex;
      uniform float4    _MainTex_TexelSize;
      uniform half      _ZoomBlur;

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
        half4 color = half4(0, 0, 0, 1.0);

        // Zoom Blur
        int n = 10;
        for (int j=0; j<n; j++) {
          float  scale = 1.0 + (float(j + 1) / n) * _ZoomBlur;
          float2 uv    = (i.uv - 0.5) * scale + 0.5;
          color.rgb += tex2D(_MainTex, uv).rgb;
        }
        color.rgb /= n;

        return color;
      }
      ENDCG
    }
  }
}
