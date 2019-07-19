Shader "BASICxSHADER/Texturing/Parallax" {
  Properties {
    _MainTex ("Main Texture", 2D) = "white" {}
    _SpecTex ("Specular Texture", 2D) = "black" {}
    _Shininess ("Shininess", Float) = 20
    _NormalTex ("Normal Texture", 2D) = "bump" {}
    _HeightTex ("Height Texture", 2D) = "gray" {}
    _Parallax ("Parallax", Range(0.01, 0.1)) = 0.01
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
      uniform sampler2D _SpecTex;
      uniform float4    _SpecTex_ST;
      uniform half      _Shininess;
      uniform sampler2D _NormalTex;
      uniform float4    _NormalTex_ST;
      uniform sampler2D _HeightTex;
      uniform float4    _HeightTex_ST;
      uniform half      _Parallax;

      // Vertex Input
      struct appdata {
        float4 vertex  : POSITION;
        float3 normal  : NORMAL;
        float2 uv      : TEXCOORD0;
        float4 tangent : TANGENT;
      };

      // Vertex to Fragment
      struct v2f {
        float4 pos         : SV_POSITION;
        float3 normal      : NORMAL;
        float2 uv          : TEXCOORD0;
        float4 posWorld    : TEXCOORD1;
        float3 tangent     : TEXCOORD2;
        float3 binormal    : TEXCOORD3;
        float3 tangentView : TEXCOORD4;
      };

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      v2f vert(appdata v) {
        v2f o;
        o.pos      = UnityObjectToClipPos(v.vertex);
        o.normal   = normalize(mul(v.normal, unity_WorldToObject).xyz);
        o.uv       = v.uv;
        o.posWorld = mul(unity_ObjectToWorld, v.vertex);
        o.tangent  = normalize(mul(unity_ObjectToWorld, v.tangent).xyz);
        o.binormal = cross(o.normal, o.tangent) * v.tangent.w;

        // Tangent Space
        float3 binormal   = cross(v.normal, v.tangent.xyz) * v.tangent.w;
        float3 objectView = mul(unity_WorldToObject, _WorldSpaceCameraPos).xyz - v.vertex.xyz;
        o.tangentView = mul(float3x3(v.tangent.xyz, binormal, v.normal), objectView);

        return o;
      }

      //------------------------------------------------------------------------
      // Fragment Shader
      //------------------------------------------------------------------------
      fixed4 frag(v2f i) : SV_Target {
        // Height Map
        half heightTex = tex2D(_HeightTex, i.uv * _HeightTex_ST.xy + _HeightTex_ST.zw).r;
        float2 uv = i.uv + (i.tangentView.xy / i.tangentView.z) * (heightTex - 0.5) * _Parallax;

        // Normal Map
        half4 normalTex = tex2D(_NormalTex, uv * _NormalTex_ST.xy + _NormalTex_ST.zw);
        #if defined(UNITY_NO_DXT5nm)
          half3 tangentCoord = normalTex.rgb * 2.0 - 1.0;
        #else
          half3 tangentCoord = float3(normalTex.ag * 2.0 - 1.0, 0);
          tangentCoord.z = sqrt(1 - dot(tangentCoord.xy, tangentCoord.xy));
        #endif
        half3 normal = normalize(mul(tangentCoord, float3x3(i.tangent, i.binormal, i.normal)));

        // Vector
        half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
        half3 viewDir  = normalize(_WorldSpaceCameraPos.xyz - i.posWorld);
        half3 halfDir  = normalize(lightDir + viewDir);

        // Dot
        half NdotL = saturate(dot(normal, lightDir));
        half NdotH = saturate(dot(normal, halfDir));

        // Color Map
        fixed4 mainTex = tex2D(_MainTex, uv * _MainTex_ST.xy + _MainTex_ST.zw);
        fixed3 diffuse = _LightColor0.rgb * mainTex.rgb * NdotL;

        // Gloss Map
        fixed4 specTex  = tex2D(_SpecTex, uv * _SpecTex_ST.xy + _SpecTex_ST.zw);
        fixed3 specular = _LightColor0.rgb * specTex.rgb * pow(NdotH, _Shininess) * specTex.a;

        // Color
        fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * mainTex.rgb;
        fixed4 color = fixed4(ambient + diffuse + specular, 1.0);

        return color;
      }
      ENDCG
    }
  }
}
