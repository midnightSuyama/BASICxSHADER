using UnityEngine;

[RequireComponent(typeof(Camera)), ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class BloomImageEffect : MonoBehaviour {
  public Material material;

  private int _Direction;
  private int _BloomTex;

  void Awake() {
    _Direction = Shader.PropertyToID("_Direction");
    _BloomTex  = Shader.PropertyToID("_BloomTex");
  }

  void OnRenderImage (RenderTexture src, RenderTexture dest) {
    var rt1 = RenderTexture.GetTemporary(src.width / 2, src.height / 2);
    var rt2 = RenderTexture.GetTemporary(src.width / 2, src.height / 2);
    var h = new Vector2(1, 0);
    var v = new Vector2(0, 1);

    // 0: High Luminance
    Graphics.Blit(src, rt1, material, 0);

    // 1: Gaussian Blur
    for (int i=0; i<3; i++) {
      material.SetVector(_Direction, h);
      Graphics.Blit(rt1, rt2, material, 1);
      material.SetVector(_Direction, v);
      Graphics.Blit(rt2, rt1, material, 1);
    }

    // 2: Bloom
    material.SetTexture(_BloomTex, rt1);
    Graphics.Blit(src, dest, material, 2);

    RenderTexture.ReleaseTemporary(rt2);
    RenderTexture.ReleaseTemporary(rt1);
  }
}
