using UnityEngine;

[RequireComponent(typeof(Camera)), ExecuteInEditMode]
public class LightCamera : MonoBehaviour
{
  void Update() {
    // _LightVPMatrix
    var camera = GetComponent<Camera>();
    var lightVPMatrix = camera.projectionMatrix * camera.worldToCameraMatrix;
    Shader.SetGlobalMatrix("_LightVPMatrix", lightVPMatrix);
  }
}
