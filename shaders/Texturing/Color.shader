Shader "BASICxSHADER/Texturing/Color" {
  Properties {
    _MainTex ("Main Texture", 2D) = "white" {}
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform fixed4    _LightColor0;
      uniform sampler2D _MainTex;
      uniform float4    _MainTex_ST;

      // Vertex Input
      struct appdata {
        float4 vertex : POSITION;
        float3 normal : NORMAL;
        float2 uv     : TEXCOORD0;
      };

      // Vertex to Fragment
      struct v2f {
        float4 pos    : SV_POSITION;
        float3 normal : NORMAL;
        float2 uv     : TEXCOORD0;
      };

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      v2f vert(appdata v) {
        v2f o;
        o.pos    = UnityObjectToClipPos(v.vertex);
        o.normal = normalize(mul(v.normal, unity_WorldToObject).xyz);
        o.uv     = v.uv;
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

        // Color Map
        fixed4 mainTex = tex2D(_MainTex, i.uv * _MainTex_ST.xy + _MainTex_ST.zw);
        fixed3 diffuse = _LightColor0.rgb * mainTex.rgb * NdotL;

        // Color
        fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * mainTex.rgb;
        fixed4 color = fixed4(ambient + diffuse, 1.0);

        return color;
      }
      ENDCG
    }
  }
}
