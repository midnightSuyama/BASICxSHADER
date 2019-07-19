Shader "BASICxSHADER/Lighting/Toon" {
  Properties {
    _ToonLightColor ("Toon Light Color", Color) = (1, 1, 1, 1)
    _ToonDarkColor ("Toon Dark Color", Color) = (0.5, 0.5, 0.5, 1)
    _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
    _OutlineWidth ("Outline Width", Range (0.01, 0.1)) = 0.01
  }
  SubShader {
    // 0: Outline
    Pass {
      Cull Front

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform fixed4 _OutlineColor;
      uniform half   _OutlineWidth;

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      float4 vert(float4 vertex : POSITION, float3 normal : NORMAL) : SV_POSITION {
        vertex.xyz += normal * _OutlineWidth;
        return UnityObjectToClipPos(vertex);
      }

      //------------------------------------------------------------------------
      // Fragment Shader
      //------------------------------------------------------------------------
      fixed4 frag() : SV_Target {
        return _OutlineColor;
      }
      ENDCG
    }

    // 1: Cel
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform fixed4 _ToonLightColor;
      uniform fixed4 _ToonDarkColor;

      // Vertex Input
      struct appdata {
        float4 vertex : POSITION;
        float3 normal : NORMAL;
      };

      // Vertex to Fragment
      struct v2f {
        float4 pos    : SV_POSITION;
        float3 normal : NORMAL;
      };

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      v2f vert(appdata v) {
        v2f o;
        o.pos    = UnityObjectToClipPos(v.vertex);
        o.normal = normalize(mul(v.normal, unity_WorldToObject).xyz);
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

        // Color
        fixed3 toon = lerp(_ToonLightColor.rgb, _ToonDarkColor.rgb, step(NdotL, 0));
        fixed4 color = fixed4(toon, 1.0);

        return color;
      }
      ENDCG
    }
  }
}
