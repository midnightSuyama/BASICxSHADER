Shader "BASICxSHADER/Fog/Height" {
  Properties {
    _MinHeight ("Min Height", Float) = 0
    _MaxHeight ("Max Height", Float) = 1
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform float _MinHeight;
      uniform float _MaxHeight;

      // Vertex Input
      struct appdata {
        float4 vertex : POSITION;
        float3 normal : NORMAL;
      };

      // Vertex to Fragment
      struct v2f {
        float4 pos      : SV_POSITION;
        float3 normal   : NORMAL;
        float4 posWorld : TEXCOORD0;
      };

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      v2f vert(appdata v) {
        v2f o;
        o.pos      = UnityObjectToClipPos(v.vertex);
        o.normal   = normalize(mul(v.normal, unity_WorldToObject).xyz);
        o.posWorld = mul(unity_ObjectToWorld, v.vertex);
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

        // Fog
        float fogCoord = saturate((i.posWorld.y - _MinHeight) / (_MaxHeight - _MinHeight));

        // Color
        fixed4 color = fixed4(NdotL, NdotL, NdotL, 1.0);
        color.rgb = lerp(unity_FogColor.rgb, color.rgb, fogCoord);

        return color;
      }
      ENDCG
    }
  }
}
