Shader "BASICxSHADER/Shadow/Map" {
  Properties {
    _ShadowMap ("ShadowMap", 2D) = "" {}
    _Intensity ("Intensity", Range (0, 1)) = 0.5
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform sampler2D _ShadowMap;
      uniform half      _Intensity;
      uniform float4x4  _LightVPMatrix;

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
        float4 posShadow = mul(_LightVPMatrix, mul(unity_ObjectToWorld, v.vertex));
        o.shadowCoord = float4(posShadow.xyz * 0.5 + 0.5, posShadow.w);

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
        half depth = tex2D(_ShadowMap, i.shadowCoord.xy).r;
        #if defined(UNITY_REVERSED_Z)
          depth = 1.0 - depth;
        #endif
        fixed shadow = 1.0 - step(depth, i.shadowCoord.z - 1e-4) * _Intensity;

        // Color
        fixed4 color = fixed4(NdotL, NdotL, NdotL, 1.0);
        color.rgb *= shadow;

        return color;
      }
      ENDCG
    }
  }
}
