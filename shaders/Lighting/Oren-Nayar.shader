Shader "BASICxSHADER/Lighting/Oren-Nayar" {
  Properties {
    _Albedo ("Albedo", Color) = (1, 1, 1, 1)
    _Roughness ("Roughness", Range(0, 1)) = 0.5
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform fixed4 _LightColor0;
      uniform fixed4 _Albedo;
      uniform half   _Roughness;

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
        half3 viewDir  = normalize(_WorldSpaceCameraPos.xyz - i.posWorld);

        // Dot
        half NdotL = saturate(dot(normal, lightDir));
        half NdotV = saturate(dot(normal, viewDir));

        // Roughness
        half roughness    = _Roughness * _Roughness;
        half roughnessSqr = roughness * roughness;

        // Oren-Nayar
        half A = 1.0 - 0.5 * roughnessSqr / (roughnessSqr + 0.33);
        half B = 0.45 * roughnessSqr / (roughnessSqr + 0.09);
        half C = saturate(dot(normalize(viewDir - normal * NdotV), normalize(lightDir - normal * NdotL)));
        half angleL = acos(NdotL);
        half angleV = acos(NdotV);
        half alpha  = max(angleL, angleV);
        half beta   = min(angleL, angleV);
        fixed3 diffuse = _Albedo.rgb * (A + B * C * sin(alpha) * tan(beta)) * _LightColor0.rgb * NdotL;

        // Color
        fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * _Albedo.rgb;
        fixed4 color = fixed4(ambient + diffuse, 1.0);

        return color;
      }
      ENDCG
    }
  }
}
