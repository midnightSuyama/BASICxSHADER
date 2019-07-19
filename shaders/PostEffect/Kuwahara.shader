Shader "BASICxSHADER/PostEffect/Kuwahara" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _Radius ("Radius", Int) = 5
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
      uniform int       _Radius;

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
        // Kuwahara
        int n = (_Radius + 1) * (_Radius + 1);
        half3 m[4] = { half3(0,0,0), half3(0,0,0), half3(0,0,0), half3(0,0,0) };
        half3 s[4] = { half3(0,0,0), half3(0,0,0), half3(0,0,0), half3(0,0,0) };
        for (int v=0; v<=_Radius; v++) {
          for (int h=0; h<=_Radius; h++) {
            half3 c = tex2D(_MainTex, i.uv + _MainTex_TexelSize.xy * float2(h - _Radius, v)).rgb;
            m[0] += c;
            s[0] += c * c;
            c = tex2D(_MainTex, i.uv + _MainTex_TexelSize.xy * float2(h, v)).rgb;
            m[1] += c;
            s[1] += c * c;
            c = tex2D(_MainTex, i.uv + _MainTex_TexelSize.xy * float2(h - _Radius, v - _Radius)).rgb;
            m[2] += c;
            s[2] += c * c;
            c = tex2D(_MainTex, i.uv + _MainTex_TexelSize.xy * float2(h, v - _Radius)).rgb;
            m[3] += c;
            s[3] += c * c;
          }
        }
        m[0] /= n;
        s[0] = s[0] / n - m[0] * m[0];
        m[1] /= n;
        s[1] = s[1] / n - m[1] * m[1];
        m[2] /= n;
        s[2] = s[2] / n - m[2] * m[2];
        m[3] /= n;
        s[3] = s[3] / n - m[3] * m[3];

        // Luminance
        half3 luma = half3(0.30, 0.59, 0.11);
        half y[4];
        y[0] = dot(s[0], luma);
        y[1] = dot(s[1], luma);
        y[2] = dot(s[2], luma);
        y[3] = dot(s[3], luma);
        half yMin = min(min(y[0], y[1]), min(y[2], y[3]));

        // Color
        fixed4 color = fixed4(m[0], 1.0);
        color.rgb = lerp(color.rgb, m[1], step(y[1], yMin));
        color.rgb = lerp(color.rgb, m[2], step(y[2], yMin));
        color.rgb = lerp(color.rgb, m[3], step(y[3], yMin));

        return color;
      }
      ENDCG
    }
  }
}
