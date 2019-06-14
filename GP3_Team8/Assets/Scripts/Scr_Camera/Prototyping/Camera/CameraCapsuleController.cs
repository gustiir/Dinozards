using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.Assertions;

[RequireComponent(typeof(NavMeshAgent))]
public class CameraCapsuleController : MonoBehaviour
{
    // Start is called before the first frame update
    public LayerMask navigationLayerMask;

    private NavMeshAgent agent;
    private Camera camera;

    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        Assert.IsNotNull(agent, "<color=#FF0000><b>Error</b></color>Error: Failed to locate NavMeshAgent");

        agent.updateRotation = false;

        camera = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {

            RaycastHit hit;
            Ray ray = camera.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out hit, float.MaxValue/*, navigationLayerMask, QueryTriggerInteraction.Ignore*/))
            {
                //if (Vector3.Distance(transform.position, hit.point) < 2f)
                //{
                //    hit.transform.GetComponent<IInteractable>()?.OnClick(gameObject);
                //}
                Debug.Log(hit.point, hit.collider.gameObject);

                agent.SetDestination(hit.point);
            }
        }
    }
}

