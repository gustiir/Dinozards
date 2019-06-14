using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace CAMFG
{
    [RequireComponent(typeof(Camera))]
    public class CameraProt : MonoBehaviour
    {
        public GameObject[] targets;
        public Vector3 someCameraOffsets;
        public Camera camera;
        public float zoomFactor = 10f;
        public float followTimeDelta = 0.8f;
        public float zoomMinValue;
        public float zoomMaxValue;


        private void Start()
        {
            camera = GetComponent<Camera>();
            for (int i = 0; i < GameObject.FindGameObjectsWithTag("Player").Length; i++)
            {
                if (GameObject.FindGameObjectsWithTag("Player")[i])
                {
                    targets[i] = GameObject.FindGameObjectsWithTag("Player")[i];
                   
                }
            }
           
        }

        public void CameraPositin()
        {
            Vector3 min = targets[0].transform.position;
            Vector3 max = targets[0].transform.position;
            for (int i = 0; i < targets.Length; ++i)
            {
                if (targets[i] == null)
                {
                    continue;
                }
                Vector3 loc = targets[i].transform.position;

                if (loc.x < min.x) min.x = loc.x;
                if (loc.y < min.y) min.y = loc.y;
                if (loc.z < min.z) min.z = loc.z;

                if (loc.x > max.x) max.x = loc.x;
                if (loc.y > max.y) max.y = loc.y;
                if (loc.z > max.z) max.z = loc.z;
            }
            Vector3 middle = (min + max) / 2.0f;
            float width = max.x - min.x;
            float height = max.z - min.z;

            float zoom = Mathf.Max(width, height) / 3f;
            zoom = Mathf.Clamp(zoom, zoomMinValue, zoomMaxValue);
            camera.fieldOfView = zoom;


            //camera.transform.position = middle + someCameraOffsets;
        }
        // break = breakar loops
        // return = går ur en function
        // continue = hoppar till nästa iteration
        private void Update()
        {
            

            CameraPositin();

            //Vector3 finalposition = Vector3.zero;
            //for (int i = 0; i < targets.Length; i++)
            //{

            //    finalposition += targets[i].transform.position;
            //}
            //finalposition /= targets.Length;

        }

        //public void CameraFollowSmooth(Camera camera, Transform t1, Transform t2, Transform t3, Transform t4)
        //{
        //    Vector3 midPoint = (t1.position + t2.position - t3.position + t4.position) / 4f;
        //    float distance = (t1.position - t2.position + t3.position - t4.position).magnitude;

        //    Vector3 cameraDestination = midPoint - camera.transform.forward * distance * zoomFactor;
        //    if (camera.orthographic)
        //    {
        //        camera.orthographicSize = distance;

        //    }

        //    camera.transform.position = Vector3.Slerp(camera.transform.position, cameraDestination, followTimeDelta);

        //    if ((cameraDestination - camera.transform.position).magnitude <= 0.05f) camera.transform.position = cameraDestination;


        //}

    }

}


