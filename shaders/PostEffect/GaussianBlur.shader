Shader "BASICxSHADER/PostEffect/GaussianBlur" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _Radius ("Radius", Float) = 3
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
      uniform half2     _Direction;
      uniform half      _Radius;

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
        half4 color = tex2D(_MainTex, i.uv);

        // Gaussian Blur
        float weights[5] = { 0.22702702702, 0.19459459459, 0.12162162162, 0.05405405405, 0.01621621621 };
        float2 offset = _Direction * _MainTex_TexelSize.xy * _Radius;
        color.rgb *= weights[0];
        color.rgb += tex2D(_MainTex, i.uv + offset      ).rgb * weights[1];
        color.rgb += tex2D(_MainTex, i.uv - offset      ).rgb * weights[1];
        color.rgb += tex2D(_MainTex, i.uv + offset * 2.0).rgb * weights[2];
        color.rgb += tex2D(_MainTex, i.uv - offset * 2.0).rgb * weights[2];
        color.rgb += tex2D(_MainTex, i.uv + offset * 3.0).rgb * weights[3];
        color.rgb += tex2D(_MainTex, i.uv - offset * 3.0).rgb * weights[3];
        color.rgb += tex2D(_MainTex, i.uv + offset * 4.0).rgb * weights[4];
        color.rgb += tex2D(_MainTex, i.uv - offset * 4.0).rgb * weights[4];

        return color;
      }
      ENDCG
    }
  }
}
