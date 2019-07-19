using UnityEngine;

[RequireComponent(typeof(Camera)), ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class ImageEffect : MonoBehaviour {
  public Material material;

  void OnRenderImage(RenderTexture src, RenderTexture dest) {
    Graphics.Blit(src, dest, material);
  }
}
