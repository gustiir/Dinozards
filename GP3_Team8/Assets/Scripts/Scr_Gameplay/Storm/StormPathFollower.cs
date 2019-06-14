using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using PathCreation;

public class StormPathFollower : MonoBehaviour
{
    public List<PathCreator> pathCreatorList;
    private float speed;
    public bool alignRotation = false;
    private StormBehavior stormInstance;

    public PathCreator pathCreator;


    public float distanceTraveled;

    public void SetPath()
    {
        int myInt = Random.Range(0, pathCreatorList.Count);
        pathCreator = pathCreatorList[myInt];
    }

    private void Awake()
    {
        stormInstance = FindObjectOfType<StormBehavior>();
        speed = stormInstance.stormSpeed;
    }

    private void Update()
    {
        if(stormInstance.isMoving)
        distanceTraveled += speed * Time.deltaTime;
        transform.position = pathCreator.path.GetPointAtDistance(distanceTraveled); //Follows the path
        if(alignRotation)
        {
            transform.rotation = pathCreator.path.GetRotationAtDistance(distanceTraveled); //Rotates toward the path
        }


    }
}
