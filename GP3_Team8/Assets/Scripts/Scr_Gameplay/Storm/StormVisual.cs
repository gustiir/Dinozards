using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StormVisual : MonoBehaviour
{

    public Transform stormTransform;
    public float stormHeight;

    // Update is called once per frame
    void Update()
    {
        transform.localScale = new Vector3(transform.localScale.x, stormHeight, transform.localScale.z);
    }
}
