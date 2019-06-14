using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MultipleTargetCamera : MonoBehaviour
{

    public List<GameObject> targets;
    public float smoothTime = .5f;
    public float camMinZoom = 9f;
    public float camAngle = 75f;
    private Vector3 velocity;
    public Camera myCamera;
    private Vector3 centerPoint;
    private float playersBoundSize;
    Vector3 originalPos;
    public float zoomOutMultiplier;
    [HideInInspector]
    public float boundLerp;

    public void StartCamera()
    {
        targets.Clear();

        foreach (var item in GameObject.FindGameObjectsWithTag("Player"))
        {
            targets.Add(item);
        }

        centerPoint = GetCenterPoint();
    }

    public void RemovePlayer(GameObject killedPlayer)
    {
        targets.Remove(killedPlayer);
        
    }

   
    private void LateUpdate()
    {
        if (targets.Count == 0)
        {
            return;
        }
        centerPoint = GetCenterPoint();
        playersBoundSize = GetPlayersBoundSize();

        transform.rotation = Quaternion.Euler(camAngle, 0f, 0f);
        transform.position = Vector3.SmoothDamp(transform.position, centerPoint, ref velocity, smoothTime);
        boundLerp = Mathf.Clamp(Mathf.SmoothStep(boundLerp, playersBoundSize, smoothTime), camMinZoom, 999f);
        myCamera.transform.localPosition = new Vector3(0, 1f, 0) * (boundLerp + 5f) * zoomOutMultiplier;
    }

    private Vector3 GetCenterPoint()
    {
        if (targets.Count == 1)
        {
            return targets[0].transform.position;
        }

        Bounds bounds = new Bounds(targets[0].transform.position, Vector3.zero);
        for (int i = 0; i < targets.Count; i++)
        {
            bounds.Encapsulate(targets[i].transform.position);
        }

        return bounds.center;
    }

    private float GetPlayersBoundSize()
    {
        if (targets.Count == 1)
        {
            return camMinZoom;
        }

        Bounds bounds = new Bounds(targets[0].transform.position, Vector3.zero);
        for (int i = 0; i < targets.Count; i++)
        {
            bounds.Encapsulate(targets[i].transform.position);
        }

        if (bounds.size.x >= bounds.size.z)
        {
            return bounds.size.x;
        }
        else
        {
            return bounds.size.z;
        }

    }


    //----------------------------------------------------

    public void ShakeCamera(float duration, float magnitude)
    {

        StartCoroutine(Shake(duration, magnitude));
    }

    ////----------------------------------------------------
    ///
    public bool isShaking = false;
    
    public IEnumerator Shake(float duration, float magnitude)
    {

        isShaking = true;

        Quaternion originalPos = transform.localRotation;

        //float elapsed = 1.0f;

        float startTime = Time.realtimeSinceStartup;
        while (Time.realtimeSinceStartup < startTime + duration)
        {
           
            transform.localPosition = new Vector3(transform.position.x + Random.Range(-magnitude, magnitude), transform.position.y + Random.Range(-magnitude, magnitude), transform.position.z);
            //(Random.Range(-0.1f, 0.1f), Random.Range(0.1f, -0.1f), originalPos.z)
            //float x = Random.Range(-0.1f, 0.1f) * magnitude;
            //float y = Random.Range(-0.1f, 0.1f) * magnitude;

            transform.localRotation = new Quaternion(transform.position.x, transform.position.y, originalPos.z, 0.1f);

            //elapsed += Time.deltaTime;
            yield return null;
        }

        //   // tempUglyFix = false;
        transform.localRotation = originalPos;
        isShaking = false;
    }

}

