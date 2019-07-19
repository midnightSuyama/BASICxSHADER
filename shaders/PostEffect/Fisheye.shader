Shader "BASICxSHADER/PostEffect/Fisheye" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _Fisheye ("Fisheye", Range (0, 1)) = 1
  }
  SubShader {
    Cull Off ZWrite Off ZTest Always

    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      #define INV_PI 0.31830988618f

      // Properties
      uniform sampler2D _MainTex;
      uniform half      _Fisheye;

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
        // Fisheye
        float2 uv    = i.uv * 2.0 - 1.0;
        float  d     = length(uv);
        float  z     = sqrt(1.0 - d * d);
        float  r     = atan2(d, z) * INV_PI;
        float  theta = atan2(uv.y, uv.x);
        uv = r * float2(cos(theta), sin(theta)) * _Fisheye + 0.5;

        // Mask
        fixed4 color = tex2D(_MainTex, uv);
        color.rgb *= step(d, 1.0);

        return color;
      }
      ENDCG
    }
  }
}
