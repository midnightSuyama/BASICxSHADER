Shader "BASICxSHADER/PostEffect/Scanline" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _Scanline ("Scanline", Range (0, 1)) = 0.5
  }
  SubShader {
    Cull Off ZWrite Off ZTest Always

    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform sampler2D _MainTex;
      uniform float4    _MainTex_TexelSize;
      uniform half      _Scanline;

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

        // Scanline
        float  theta    = i.uv.y * _MainTex_TexelSize.w;
        float3 scanline = float2(sin(theta), cos(theta)).xyx * 0.5 + 0.5;
        color.rgb = lerp(color.rgb, color.rgb * scanline, _Scanline);

        return color;
      }
      ENDCG
    }
  }
}
