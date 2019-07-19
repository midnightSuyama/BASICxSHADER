using UnityEngine;

[RequireComponent(typeof(Camera)), ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class SSAOImageEffect : MonoBehaviour {
  public Material material;

  private int _Direction;
  private int _SSAOTex;

  void Awake() {
    GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;

    _Direction = Shader.PropertyToID("_Direction");
    _SSAOTex   = Shader.PropertyToID("_SSAOTex");
  }

  void OnRenderImage(RenderTexture src, RenderTexture dest) {
    var rt1 = RenderTexture.GetTemporary(src.width, src.height);
    var rt2 = RenderTexture.GetTemporary(src.width, src.height);
    var h = new Vector2(1, 0);
    var v = new Vector2(0, 1);

    // 0: Ambient Occlusion
    Graphics.Blit(src, rt1, material, 0);

    // 1: Bilateral Filter
    for (int i=0; i<3; i++) {
      material.SetVector(_Direction, h);
      Graphics.Blit(rt1, rt2, material, 1);
      material.SetVector(_Direction, v);
      Graphics.Blit(rt2, rt1, material, 1);
    }

    // 2: SSAO
    material.SetTexture(_SSAOTex, rt1);
    Graphics.Blit(src, dest, material, 2);

    RenderTexture.ReleaseTemporary(rt2);
    RenderTexture.ReleaseTemporary(rt1);
  }
}
