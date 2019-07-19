Shader "BASICxSHADER/PostEffect/Sobel" {
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
      uniform float4    _MainTex_TexelSize;

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

        // Luminance
        half3  luma   = half3(0.30, 0.59, 0.11);
        float4 offset = float4(_MainTex_TexelSize.xy, -_MainTex_TexelSize.xy);
        half yNW = dot(tex2D(_MainTex, i.uv + offset.zy).rgb,           luma);
        half yN  = dot(tex2D(_MainTex, i.uv + float2(0, offset.y)).rgb, luma);
        half yNE = dot(tex2D(_MainTex, i.uv + offset.xy).rgb,           luma);
        half yW  = dot(tex2D(_MainTex, i.uv + float2(offset.z, 0)).rgb, luma);
        half yM  = dot(color.rgb, luma);
        half yE  = dot(tex2D(_MainTex, i.uv + float2(offset.x, 0)).rgb, luma);
        half ySW = dot(tex2D(_MainTex, i.uv + offset.zw).rgb,           luma);
        half yS  = dot(tex2D(_MainTex, i.uv + float2(0, offset.w)).rgb, luma);
        half ySE = dot(tex2D(_MainTex, i.uv + offset.xw).rgb,           luma);

        // Sobel
        half2 hv = half2(
          (yNE - yNW) + (yE - yW) * 2.0 + (ySE - ySW),
          (yNW - ySW) + (yN - yS) * 2.0 + (yNE - ySE)
        );
        half sobel = sqrt(dot(hv, hv)) / yM;
        color.rgb = 1.0 - sobel;

        return color;
      }
      ENDCG
    }
  }
}
