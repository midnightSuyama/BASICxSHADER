using UnityEngine;

[RequireComponent(typeof(Camera)), ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class MotionBlurImageEffect : MonoBehaviour {
  public Material material;

  private RenderTexture accumBuffer;

  void OnRenderImage(RenderTexture src, RenderTexture dest) {
    // Motion Blur
    if (accumBuffer == null) {
      accumBuffer = new RenderTexture(src.width, src.height, 0);
      Graphics.Blit(src, accumBuffer);
    }
    accumBuffer.MarkRestoreExpected();
    Graphics.Blit(src, accumBuffer, material);
    Graphics.Blit(accumBuffer, dest);
  }
}
