using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CanvasLookAtCamera : MonoBehaviour
{

    // Make sure the canvas always face the camera when players move or rotate

    public float multiplier = .1f;
    public float minimumScaleSize = 8f;
    public float maxScaleSize = 16f;
    private float myDistance;
    public MultipleTargetCamera myCameraController;

    void LateUpdate()
    {
        Camera camera = Camera.main;
        float uiFloatScaler = Mathf.Clamp(myCameraController.boundLerp, minimumScaleSize, maxScaleSize);
        transform.LookAt(transform.position + camera.transform.rotation * Vector3.forward, camera.transform.rotation * Vector3.up);
        transform.localScale = new Vector3(uiFloatScaler * multiplier, uiFloatScaler * multiplier, uiFloatScaler * multiplier);
    }
}
