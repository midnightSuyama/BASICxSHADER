Shader "BASICxSHADER/Fog/Depth" {
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Vertex Input
      struct appdata {
        float4 vertex : POSITION;
        float3 normal : NORMAL;
      };

      // Vertex to Fragment
      struct v2f {
        float4 pos      : SV_POSITION;
        float3 normal   : NORMAL;
        float  fogCoord : TEXCOORD0;
      };

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      v2f vert(appdata v) {
        v2f o;
        o.pos    = UnityObjectToClipPos(v.vertex);
        o.normal = normalize(mul(v.normal, unity_WorldToObject).xyz);

        // Fog
        #if defined(UNITY_REVERSED_Z)
          float depth = max((1.0 - o.pos.z / _ProjectionParams.y) * _ProjectionParams.z, 0);
        #else
          float depth = o.pos.z;
        #endif
        float density = depth * unity_FogParams.x;
        o.fogCoord = exp2(-density * density);

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
        fixed4 color = fixed4(NdotL, NdotL, NdotL, 1.0);
        color.rgb = lerp(unity_FogColor.rgb, color.rgb, i.fogCoord);

        return color;
      }
      ENDCG
    }
  }
}
