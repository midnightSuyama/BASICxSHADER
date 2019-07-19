Shader "BASICxSHADER/Shadow/MapCaster" {
  SubShader {
    // 0: Shade
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform sampler2D _ShadowMapTexture;

      // Vertex Input
      struct appdata {
        float4 vertex : POSITION;
        float3 normal : NORMAL;
      };

      // Vertex to Fragment
      struct v2f {
        float4 pos         : SV_POSITION;
        float3 normal      : NORMAL;
        float4 shadowCoord : TEXCOORD0;
      };

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      v2f vert(appdata v) {
        v2f o;
        o.pos    = UnityObjectToClipPos(v.vertex);
        o.normal = normalize(mul(v.normal, unity_WorldToObject).xyz);

        // Shadow Map
        float2 posScreen = (float2(o.pos.x, o.pos.y * _ProjectionParams.x) + o.pos.w) * 0.5;
        o.shadowCoord = float4(posScreen, o.pos.zw);

        return o;
      }

      //------------------------------------------------------------------------
      // Fragment Shader
      //------------------------------------------------------------------------
      fixed4 frag(v2f i) : SV_Target {
        // Vector
        half3 normal   = normalize(i.normal);
        half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

        // Dot
        half NdotL = saturate(dot(normal, lightDir));

        // Shadow Map
        fixed shadow = tex2Dproj(_ShadowMapTexture, i.shadowCoord).r;

        // Color
        fixed4 color = fixed4(NdotL, NdotL, NdotL, 1.0);
        color.rgb *= shadow;

        return color;
      }
      ENDCG
    }

    // 1: ShadowCaster
    UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
  }
}
