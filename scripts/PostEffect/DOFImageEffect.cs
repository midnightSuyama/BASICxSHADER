using UnityEngine;

[RequireComponent(typeof(Camera)), ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class DOFImageEffect : MonoBehaviour {
  public Material material;

  private int _Direction;
  private int _BlurTex;

  void Awake() {
    GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;

    _Direction = Shader.PropertyToID("_Direction");
    _BlurTex   = Shader.PropertyToID("_BlurTex");
  }

  void OnRenderImage(RenderTexture src, RenderTexture dest) {
    var rt1 = RenderTexture.GetTemporary(src.width / 2, src.height / 2);
    var rt2 = RenderTexture.GetTemporary(src.width / 2, src.height / 2);
    var h = new Vector2(1, 0);
    var v = new Vector2(0, 1);

    // Scale Down
    Graphics.Blit(src, rt1);

    // 0: Gaussian Blur
    for (int i=0; i<3; i++) {
      material.SetVector(_Direction, h);
      Graphics.Blit(rt1, rt2, material, 0);
      material.SetVector(_Direction, v);
      Graphics.Blit(rt2, rt1, material, 0);
    }

    // 1: DOF
    material.SetTexture(_BlurTex, rt1);
    Graphics.Blit(src, dest, material, 1);

    RenderTexture.ReleaseTemporary(rt2);
    RenderTexture.ReleaseTemporary(rt1);
  }
}
