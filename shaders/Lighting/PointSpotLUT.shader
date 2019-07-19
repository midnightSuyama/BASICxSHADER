Shader "BASICxSHADER/Lighting/PointSpotLUT" {
  Properties {
    _DiffuseColor ("Diffuse Color", Color) = (1, 1, 1, 1)
  }
  SubShader {
    CGINCLUDE
    // Properties
    uniform fixed4    _LightColor0;
    uniform fixed4    _DiffuseColor;
    uniform sampler2D _LightTexture0;
    uniform sampler2D _LightTextureB0;
    uniform float4x4  unity_WorldToLight;

    // Vertex Input
    struct appdata {
      float4 vertex : POSITION;
      float3 normal : NORMAL;
    };

    // Vertex to Fragment
    struct v2f {
      float4 pos        : SV_POSITION;
      float3 normal     : NORMAL;
      float4 posWorld   : TEXCOORD0;
      float4 lightCoord : TEXCOORD1;
    };

    //--------------------------------------------------------------------------
    // Vertex Shader
    //--------------------------------------------------------------------------
    v2f vert(appdata v) {
      v2f o;
      o.pos        = UnityObjectToClipPos(v.vertex);
      o.normal     = normalize(mul(v.normal, unity_WorldToObject).xyz);
      o.posWorld   = mul(unity_ObjectToWorld, v.vertex);
      o.lightCoord = mul(unity_WorldToLight, o.posWorld);
      return o;
    }

    //--------------------------------------------------------------------------
    // Fragment Shader
    //--------------------------------------------------------------------------
    fixed4 frag(v2f i) : SV_Target {
      // Attenuation
      float3 toLight = _WorldSpaceLightPos0.xyz - i.posWorld.xyz * _WorldSpaceLightPos0.w;
      #if defined(POINT)
        half atten = tex2D(_LightTexture0, dot(i.lightCoord.xyz, i.lightCoord.xyz).xx).UNITY_ATTEN_CHANNEL;
      #elif defined(SPOT)
        half atten = tex2D(_LightTexture0, i.lightCoord.xy / i.lightCoord.w + 0.5).a * tex2D(_LightTextureB0, dot(i.lightCoord.xyz, i.lightCoord.xyz).xx).UNITY_ATTEN_CHANNEL;
      #else
        half atten = 1.0;
      #endif

      // Vector
      half3 normal = normalize(i.normal);
      half3 lightDir = normalize(toLight);

      // Dot
      half NdotL = saturate(dot(normal, lightDir));

      // Color
      fixed3 ambient = lerp(UNITY_LIGHTMODEL_AMBIENT.rgb * _DiffuseColor.rgb, 0, _WorldSpaceLightPos0.w);
      fixed3 diffuse = _LightColor0.rgb * _DiffuseColor.rgb * NdotL * atten;
      fixed4 color = fixed4(ambient + diffuse, 1.0);

      return color;
    }
    ENDCG

    // 0: ForwardBase
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      ENDCG
    }

    // 1: ForwardAdd
    Pass {
      Tags { "LightMode" = "ForwardAdd" }
      Blend One One

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #pragma multi_compile POINT SPOT
      ENDCG
    }
  }
}
