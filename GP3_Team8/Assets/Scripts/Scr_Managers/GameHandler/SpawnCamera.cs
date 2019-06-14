using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnCamera : MonoBehaviour
{
    public GameObject cameraObject;
    private CameraControl cameraScript;


    void Start()
    {
        cameraObject = Instantiate(cameraObject);
        cameraScript = cameraObject.GetComponent<CameraControl>();
        cameraScript.m_Targets = GetComponent<GamePlayHandler>().playersTransform;
    }

    public void RemovePlayer(Transform removedPlayerTransform)
    {
        cameraScript.m_Targets.Remove(removedPlayerTransform);
    }

}
