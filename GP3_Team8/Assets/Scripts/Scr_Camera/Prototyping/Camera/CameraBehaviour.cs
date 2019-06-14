using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraBehaviour : MonoBehaviour
{
    // Start is called before the first frame update
    public string zoomAxis = "Mouse ScrollWheel";
    public string zoomAxisOut = "CameraZoomOut";

    public float zoomSpeed = 20f;

    Vector3 zoom;

    void Start()
    {
        
    }

    // Update is called once per frame
    
    private void FixedUpdate()
    {
        zoom = new Vector3(0, 1, -2) * Input.GetAxis(zoomAxis)* zoomSpeed * Time.deltaTime;
    }
    void Update()
    {       
        if (zoom != Vector3.zero)
        {
            transform.Translate(zoom);
        }        
    }
}
