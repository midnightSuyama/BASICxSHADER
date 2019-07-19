Shader "BASICxSHADER/Shadow/Volume" {
  Properties {
    _Volume ("Volume", Float) = 10
  }
  SubShader {
    // 0: Shade
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

        return fixed4(NdotL, NdotL, NdotL, 1.0);
      }
      ENDCG
    }

    // 1: Shadow
    Pass {
      Tags { "LightMode" = "ForwardBase" }
      Cull Off
      ZWrite Off
      Offset 1, 1
      ColorMask 0
      Stencil {
        Comp Always
        ZFailFront DecrWrap
        ZFailBack IncrWrap
      }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform float _Volume;

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      float4 vert(float4 vertex : POSITION, float3 normal : NORMAL) : SV_POSITION {
        // Shadow Volume
        float4 posWorld = mul(unity_ObjectToWorld, vertex);
        normal = normalize(mul(normal, unity_WorldToObject).xyz);
        half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
        posWorld.xyz += -lightDir * step(dot(normal, lightDir), 0) * _Volume;

        return mul(UNITY_MATRIX_VP, posWorld);
      }

      //------------------------------------------------------------------------
      // Fragment Shader
      //------------------------------------------------------------------------
      fixed4 frag() : SV_Target {
        return fixed4(0, 0, 0, 0);
      }
      ENDCG
    }
  }
}
