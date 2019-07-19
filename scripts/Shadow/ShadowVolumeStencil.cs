using UnityEngine;
using UnityEngine.Rendering;

[RequireComponent(typeof(Camera)), ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class ShadowVolumeStencil : MonoBehaviour {
  public Material material;

  void Start() {
    // Shadow Volume
    var cmdBuffer = new CommandBuffer();
    cmdBuffer.Blit(null, BuiltinRenderTextureType.CameraTarget, material);
    GetComponent<Camera>().AddCommandBuffer(CameraEvent.BeforeImageEffects, cmdBuffer);
  }
}
