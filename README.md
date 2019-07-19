# ![BASIC×SHADER](images/title.png)

Unity Shader Code with “BASIC×SHADER”

![Frames](images/frames.gif)

* [Getting Started](#getting-started)
* [#3 Lighting](#3-lighting)
    * [#3.1 Ambient](#31-ambient)
    * [#3.2 Diffuse](#32-diffuse)
    * [#3.3 Specular](#33-specular)
    * [#3.4 Phong](#34-phong)
    * [#3.5 Blinn-Phong](#35-blinn-phong)
    * [#3.6 Rim](#36-rim)
    * [#3.7 Toon](#37-toon)
    * [#3.8 Oren-Nayar](#38-oren-nayar)
    * [#3.9 Cook-Torrance](#39-cook-torrance)
    * [#3.10 SH](#310-sh)
    * [#3.11 Point/Spot](#311-pointspot)
* [#4 Texturing](#4-texturing)
    * [#4.1 Color](#41-color)
    * [#4.2 Gloss](#42-gloss)
    * [#4.3 Bump](#43-bump)
    * [#4.4 Parallax](#44-parallax)
    * [#4.5 Reflection](#45-reflection)
    * [#4.6 Refraction](#46-refraction)
* [#5 Shadow](#5-shadow)
    * [#5.1 Projection](#51-projection)
    * [#5.2 Volume](#52-volume)
    * [#5.3 Map](#53-map)
* [#6 Fog](#6-fog)
    * [#6.1 Depth](#61-depth)
    * [#6.2 Distance](#62-distance)
    * [#6.3 Height](#63-height)
* [#7 PostEffect](#7-posteffect)
    * [#7.1 Original](#71-original)
    * [#7.2 Negaposi](#72-negaposi)
    * [#7.3 Grayscale](#73-grayscale)
    * [#7.4 Sepia](#74-sepia)
    * [#7.5 Threshold](#75-threshold)
    * [#7.6 Mosaic](#76-mosaic)
    * [#7.7 LED](#77-led)
    * [#7.8 Noise](#78-noise)
    * [#7.9 Scanline](#79-scanline)
    * [#7.10 Twirl](#710-twirl)
    * [#7.11 Fisheye](#711-fisheye)
    * [#7.12 Sobel](#712-sobel)
    * [#7.13 Kuwahara](#713-kuwahara)
    * [#7.14 FXAA](#714-fxaa)
    * [#7.15 ZoomBlur](#715-zoomblur)
    * [#7.16 MotionBlur](#716-motionblur)
    * [#7.17 GaussianBlur](#717-gaussianblur)
    * [#7.18 Bloom](#718-bloom)
    * [#7.19 DOF](#719-dof)
    * [#7.20 SSAO](#720-ssao)

## Getting Started

![Unlit Shader](images/1_2_1.png)

To set a shader to Unity object, assign through a material. Let's create **object** for display, **material** for the object, and **shader** for the material.

### Object

Create a sphere object via `GameObject > 3D Object > Sphere` from the Unity Editor menu.

![Object (Wireframe)](images/1_2_2.png)

### Material

Create a material file via `Assets > Create > Material` from the Unity Editor menu. Assign the material to the object.

![Inspector (Object)](images/1_2_3.png)

### Shader

Create a shader file via `Assets > Create > Shader > Unlit Shader` from the Unity Editor menu. Replace the contents of shader with the code below and assign the shader to the material.

![Inspector (Material)](images/1_2_4.png)

```shader
Shader "BASICxSHADER/Unlit" {
  SubShader {
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      float4 vert(float4 vertex : POSITION) : SV_POSITION {
        return UnityObjectToClipPos(vertex);
      }

      fixed4 frag() : SV_Target {
        return fixed4(1.0, 0, 0, 1.0);
      }
      ENDCG
    }
  }
}
```

## #3 Lighting

### #3.1 Ambient

* [Ambient.shader](shaders/Lighting/Ambient.shader)

![Ambient](images/3_1_1.png)

### #3.2 Diffuse

* [Diffuse.shader](shaders/Lighting/Diffuse.shader)

![Diffuse](images/3_2_1.png)

### #3.3 Specular

* [Specular.shader](shaders/Lighting/Specular.shader)

![Specular](images/3_3_1.png)

### #3.4 Phong

* [Phong.shader](shaders/Lighting/Phong.shader)

![Phong](images/3_4_1.png)

### #3.5 Blinn-Phong

* [Blinn-Phong.shader](shaders/Lighting/Blinn-Phong.shader)

![Blinn-Phong](images/3_5_1.png)

### #3.6 Rim

* [Rim.shader](shaders/Lighting/Rim.shader)

![Rim](images/3_6_1.png)

### #3.7 Toon

* [Toon.shader](shaders/Lighting/Toon.shader)

![Toon](images/3_7_1.png)

### #3.8 Oren-Nayar

* [Oren-Nayar.shader](shaders/Lighting/Oren-Nayar.shader)

![Oren-Nayar](images/3_8_1.png)

### #3.9 Cook-Torrance

* [Cook-Torrance.shader](shaders/Lighting/Cook-Torrance.shader)

![Cook-Torrance](images/3_9_1.png)

### #3.10 SH

* [SH.shader](shaders/Lighting/SH.shader)

![SH](images/3_10_1.png)

### #3.11 Point/Spot

* [PointSpot.shader](shaders/Lighting/PointSpot.shader)
* [PointSpotLUT.shader](shaders/Lighting/PointSpotLUT.shader)

![Point/Spot](images/3_11_1.png)

## #4 Texturing

### #4.1 Color

* [Color.shader](shaders/Texturing/Color.shader)

![Color](images/4_1_1.png)

### #4.2 Gloss

* [Gloss.shader](shaders/Texturing/Gloss.shader)

![Gloss](images/4_2_1.png)

### #4.3 Bump

* [Bump.shader](shaders/Texturing/Bump.shader)

![Bump](images/4_3_1.png)

### #4.4 Parallax

* [Parallax.shader](shaders/Texturing/Parallax.shader)

![Parallax](images/4_4_1.png)

### #4.5 Reflection

* [Reflection.shader](shaders/Texturing/Reflection.shader)

![Reflection](images/4_5_1.png)

### #4.6 Refraction

* [Refraction.shader](shaders/Texturing/Refraction.shader)

![Refraction](images/4_6_1.png)

## #5 Shadow

### #5.1 Projection

* [Projection.shader](shaders/Shadow/Projection.shader)

![Projection](images/5_1_1.png)

### #5.2 Volume

* [ShadowVolumeStencil.cs](scripts/Shadow/ShadowVolumeStencil.cs)
* [VolumeStencil.shader](shaders/Shadow/VolumeStencil.shader)
* [Volume.shader](shaders/Shadow/Volume.shader)

![Volume](images/5_2_1.png)

### #5.3 Map

* [LightCamera.cs](scripts/Shadow/LightCamera.cs)
* [Map.shader](shaders/Shadow/Map.shader)
* [MapCaster.shader](shaders/Shadow/MapCaster.shader)

![Map](images/5_3_1.png)

## #6 Fog

### #6.1 Depth

* [Depth.shader](shaders/Fog/Depth.shader)

![Depth](images/6_1_1.png)

### #6.2 Distance

* [Distance.shader](shaders/Fog/Distance.shader)

![Distance](images/6_2_1.png)

### #6.3 Height

* [Height.shader](shaders/Fog/Height.shader)

![Height](images/6_3_1.png)

## #7 PostEffect

### #7.1 Original

* [ImageEffect.cs](scripts/PostEffect/ImageEffect.cs)
* [Original.shader](shaders/PostEffect/Original.shader)

![Original](images/7_1_1.png)

### #7.2 Negaposi

* [Negaposi.shader](shaders/PostEffect/Negaposi.shader)

![Negaposi](images/7_2_1.png)

### #7.3 Grayscale

* [Grayscale.shader](shaders/PostEffect/Grayscale.shader)

![Grayscale](images/7_3_1.png)

### #7.4 Sepia

* [Sepia.shader](shaders/PostEffect/Sepia.shader)

![Sepia](images/7_4_1.png)

### #7.5 Threshold

* [Threshold.shader](shaders/PostEffect/Threshold.shader)

![Threshold](images/7_5_1.png)

### #7.6 Mosaic

* [Mosaic.shader](shaders/PostEffect/Mosaic.shader)

![Mosaic](images/7_6_1.png)

### #7.7 LED

* [LED.shader](shaders/PostEffect/LED.shader)

![LED](images/7_7_1.png)

### #7.8 Noise

* [Noise.shader](shaders/PostEffect/Noise.shader)

![Noise](images/7_8_1.png)

### #7.9 Scanline

* [Scanline.shader](shaders/PostEffect/Scanline.shader)

![Scanline](images/7_9_1.png)

### #7.10 Twirl

* [Twirl.shader](shaders/PostEffect/Twirl.shader)

![Twirl](images/7_10_1.png)

### #7.11 Fisheye

* [Fisheye.shader](shaders/PostEffect/Fisheye.shader)

![Fisheye](images/7_11_1.png)

### #7.12 Sobel

* [Sobel.shader](shaders/PostEffect/Sobel.shader)

![Sobel](images/7_12_1.png)

### #7.13 Kuwahara

* [Kuwahara.shader](shaders/PostEffect/Kuwahara.shader)

![Kuwahara](images/7_13_1.png)

### #7.14 FXAA

* [FXAA.shader](shaders/PostEffect/FXAA.shader)

![FXAA](images/7_14_1.png)

### #7.15 ZoomBlur

* [ZoomBlur.shader](shaders/PostEffect/ZoomBlur.shader)

![ZoomBlur](images/7_15_1.png)

### #7.16 MotionBlur

* [MotionBlurImageEffect.cs](scripts/PostEffect/MotionBlurImageEffect.cs)
* [MotionBlur.shader](shaders/PostEffect/MotionBlur.shader)

![MotionBlur](images/7_16_1.png)

### #7.17 GaussianBlur

* [GaussianBlurImageEffect.cs](scripts/PostEffect/GaussianBlurImageEffect.cs)
* [GaussianBlur.shader](shaders/PostEffect/GaussianBlur.shader)

![GaussianBlur](images/7_17_1.png)

### #7.18 Bloom

* [BloomImageEffect.cs](scripts/PostEffect/BloomImageEffect.cs)
* [Bloom.shader](shaders/PostEffect/Bloom.shader)

![Bloom](images/7_18_1.png)

### #7.19 DOF

* [DOFImageEffect.cs](scripts/PostEffect/DOFImageEffect.cs)
* [DOF.shader](shaders/PostEffect/DOF.shader)

![DOF](images/7_19_1.png)

### #7.20 SSAO

* [SSAOImageEffect.cs](scripts/PostEffect/SSAOImageEffect.cs)
* [SSAO.shader](shaders/PostEffect/SSAO.shader)

![SSAO](images/7_20_1.png)
