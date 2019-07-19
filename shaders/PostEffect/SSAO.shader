Shader "BASICxSHADER/PostEffect/SSAO" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _Radius ("Radius", Range (0, 1)) = 0.1
    _Intensity ("Intensity", Range (0, 1)) = 0.5
  }

  CGINCLUDE
  // Vertex Input
  struct appdata {
    float4 vertex : POSITION;
    float2 uv     : TEXCOORD0;
  };

  // Vertex to Fragment
  struct v2f {
    float4 pos : SV_POSITION;
    float2 uv  : TEXCOORD0;
  };

  //----------------------------------------------------------------------------
  // Vertex Shader
  //----------------------------------------------------------------------------
  v2f vert(appdata v) {
    v2f o;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv  = v.uv;
    return o;
  }
  ENDCG

  SubShader {
    Cull Off ZWrite Off ZTest Always

    // 0: Ambient Occlusion
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      #define PI 3.14159265359f

      // Properties
      uniform half      _Radius;
      uniform half      _Intensity;
      uniform sampler2D _CameraDepthNormalsTexture;

      //------------------------------------------------------------------------
      // Fragment Shader
      //------------------------------------------------------------------------
      fixed4 frag(v2f i) : SV_Target {
        // Depth, Normal
        half4 depthNormals = tex2D(_CameraDepthNormalsTexture, i.uv);
        half3 nn = half3((depthNormals.rg * 2.0 - 1.0) * 1.7777, 1.0);
        half  g  = 2.0 / dot(nn, nn);
        half3 normal = half3(nn.xy * g, -(g - 1.0));
        half  depth  = dot(depthNormals.ba, half2(1.0, 1.0 / 255.0));

        // View Space
        float3 pos = float3(i.uv * 2.0 - 1.0, depth * _ProjectionParams.z);
        pos.xy = ((pos.xy - unity_CameraProjection._13_31) / unity_CameraProjection._11_22) * pos.z;

        // Hemispheric Distribution
        float gn    = frac(52.9829189 * frac(dot(i.uv * _ScreenParams.xy, float2(0.06711056, 0.00583715))));
        float theta = gn * 2.0 * PI;
        float u     = gn * 2.0 - 1.0;
        float3 rand = float3(float2(cos(theta), sin(theta)) * sqrt(1.0 - u * u), u);
        rand = faceforward(rand, -normal, rand);

        // Ambient Occlusion
        half ao = 0;
        int n = 4;
        for (int j=0; j<n; j++) {
          float3 randPos = pos + rand * (float(j + 1) / n) * _Radius;
          float2 sampleUv = (mul(unity_CameraProjection, randPos).xy / randPos.z) * 0.5 + 0.5;

          half4 sampleDepthNormals = tex2D(_CameraDepthNormalsTexture, sampleUv);
          half sampleDepth = dot(sampleDepthNormals.ba, half2(1.0, 1.0 / 255.0));

          float3 samplePos = float3(sampleUv * 2.0 - 1.0, sampleDepth * _ProjectionParams.z);
          samplePos.xy = ((samplePos.xy - unity_CameraProjection._13_31) / unity_CameraProjection._11_22) * samplePos.z;
          float3 v = samplePos - pos;
          ao += max(dot(normal, v) - (_ProjectionParams.z / 65536.0), 0) / (dot(v, v) + 1e-4);
        }
        ao = max(1.0 - ao / n * _Intensity, 0);

        return fixed4(ao, ao, ao, 1.0);
      }
      ENDCG
    }

    // 1: Bilateral Filter
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform sampler2D _MainTex;
      uniform float4    _MainTex_TexelSize;
      uniform float2    _Direction;
      uniform sampler2D _CameraDepthNormalsTexture;

      //------------------------------------------------------------------------
      // Fragment Shader
      //------------------------------------------------------------------------
      fixed4 frag(v2f i) : SV_Target {
        fixed4 color = tex2D(_MainTex, i.uv);

        // Bilateral Filter
        float weights[5] = { 0.22702702702, 0.19459459459, 0.12162162162, 0.05405405405, 0.01621621621 };
        float2 offset = _Direction * _MainTex_TexelSize.xy;
        half   depth  = dot(tex2D(_CameraDepthNormalsTexture, i.uv).ba, half2(1.0, 1.0 / 255.0));

        half3 totalColor  = color.rgb * weights[0];
        float totalWeight = weights[0];
        for (int j=1; j<5; j++) {
          float2 uv1 = i.uv + offset * j;
          float2 uv2 = i.uv - offset * j;
          half   d1  = dot(tex2D(_CameraDepthNormalsTexture, uv1).ba, half2(1.0, 1.0 / 255.0));
          half   d2  = dot(tex2D(_CameraDepthNormalsTexture, uv2).ba, half2(1.0, 1.0 / 255.0));
          float  w1  = weights[j] * (1.0 - step(0.2, abs(d1 - depth) * _ProjectionParams.z));
          float  w2  = weights[j] * (1.0 - step(0.2, abs(d2 - depth) * _ProjectionParams.z));
          totalColor  += tex2D(_MainTex, uv1).rgb * w1 + tex2D(_MainTex, uv2).rgb * w2;
          totalWeight += w1 + w2;
        }
        color.rgb = totalColor / totalWeight;

        return color;
      }
      ENDCG
    }

    // 2: SSAO
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform sampler2D _MainTex;
      uniform sampler2D _SSAOTex;

      //------------------------------------------------------------------------
      // Fragment Shader
      //------------------------------------------------------------------------
      fixed4 frag(v2f i) : SV_Target {
        fixed4 color = tex2D(_MainTex, i.uv);

        // SSAO
        color.rgb *= tex2D(_SSAOTex, i.uv).rgb;

        return color;
      }
      ENDCG
    }
  }
}
