Shader "BASICxSHADER/Lighting/Specular" {
  Properties {
    _DiffuseColor ("Diffuse Color", Color) = (1, 1, 1, 1)
    _SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
    _Shininess ("Shininess", Float) = 20
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform fixed4 _LightColor0;
      uniform fixed4 _DiffuseColor;
      uniform fixed4 _SpecularColor;
      uniform half   _Shininess;

      // Vertex Input
      struct appdata {
        float4 vertex : POSITION;
        float3 normal : NORMAL;
      };

      // Vertex to Fragment
      struct v2f {
        float4 pos   : SV_POSITION;
        fixed4 color : COLOR0;
      };

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      v2f vert(appdata v) {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);

        // Vector
        half3  normal     = normalize(mul(v.normal, unity_WorldToObject).xyz);
        half3  lightDir   = normalize(_WorldSpaceLightPos0.xyz);
        float4 posWorld   = mul(unity_ObjectToWorld, v.vertex);
        half3  viewDir    = normalize(_WorldSpaceCameraPos.xyz - posWorld.xyz);
        half3  reflectDir = reflect(-lightDir, normal);

        // Dot
        half NdotL = saturate(dot(normal, lightDir));
        half RdotV = saturate(dot(reflectDir, viewDir));

        // Color
        fixed3 ambient  = UNITY_LIGHTMODEL_AMBIENT.rgb * _DiffuseColor.rgb;
        fixed3 diffuse  = _LightColor0.rgb * _DiffuseColor.rgb * NdotL;
        fixed3 specular = _LightColor0.rgb * _SpecularColor.rgb * pow(RdotV, _Shininess);
        o.color = fixed4(ambient + diffuse + specular, 1.0);

        return o;
      }

      //------------------------------------------------------------------------
      // Fragment Shader
      //------------------------------------------------------------------------
      fixed4 frag(v2f i) : SV_Target {
        return i.color;
      }
      ENDCG
    }
  }
}
