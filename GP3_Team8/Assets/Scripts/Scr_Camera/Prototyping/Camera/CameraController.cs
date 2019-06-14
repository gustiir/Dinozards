using UnityEngine;
using System.Collections.Generic;

public class CameraController : MonoBehaviour
{
    public Vector3 offset = Vector3.one;
    public GameObject storm;
    public List<GameObject> players;
    public float smoothTime = 0.5f;
    public float minZoom = 40f;
    public float maxZoom = 10f;
    public float zoomLimiter = 50f;
    private Vector3 velocity;
    private Camera camera;

    private void Start()
    {
        camera = Camera.main;
        players = new List<GameObject>(GameObject.FindGameObjectsWithTag("Player"));
        storm = GameObject.FindGameObjectWithTag("Storm");
        
    }

    private void LateUpdate()
    {
        if (players.Count == 0)
        {
        players = new List<GameObject>(GameObject.FindGameObjectsWithTag("Player"));

            return;
        }

        Bounds bounds = players[0].GetComponentInChildren<Renderer>().bounds;
        for (int i = 1; i < players.Count; i++)
        {
            bounds.Encapsulate(players[i].GetComponentInChildren<Renderer>().bounds);
        }

        Vector3 position = bounds.center;
        camera.transform.position = bounds.center;
        position.y += bounds.extents.y;
        position += offset;
        camera.transform.position = position;

        camera.transform.LookAt(bounds.center);
        transform.position = Vector3.SmoothDamp(transform.position, position, ref velocity, smoothTime);
        // Zoom in out

       

        Zoom();
        GetGreatestDistance();

    }

    void Zoom()
    {
        float newZoom = Mathf.Lerp(maxZoom, minZoom, GetGreatestDistance() / zoomLimiter);
        camera.fieldOfView = Mathf.Lerp(camera.fieldOfView, newZoom, Time.deltaTime);
    }

    float GetGreatestDistance()
    {
        Bounds bounds = new Bounds(players[0].transform.position, Vector3.zero);
        for (int i = 0; i < players.Count; i++)
        {
            bounds.Encapsulate(players[i].transform.position);
        }
        return bounds.size.x;
    }

    private void OnDrawGizmos()
    {
        players = new List<GameObject>(GameObject.FindGameObjectsWithTag("Player"));
        Bounds bounds = players[0].GetComponentInChildren<Renderer>().bounds;
        for (int i = 1; i < players.Count; i++)
        {
            bounds.Encapsulate(players[i].GetComponentInChildren<Renderer>().bounds);
        }

        Gizmos.color = new Color(0f, 1f, 0f, 0.25f);
        Gizmos.DrawCube(bounds.center, bounds.size);
    }
}
