using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamagingZoneBehaviour : MonoBehaviour
{
    // Start is called before the first frame update

    #region Fields


    [SerializeField] private static bool isActive = false;
    public float damageAmount = 10f;
    public float decreasedSpeed = 2f;

    #endregion Fields


    void Start()
    {
        GetComponent<MeshCollider>().enabled = true;
    }

    void Update()
    {
        
    }
    public static void EnableZone()
    {
        isActive = true;
        //Raise lava
    }
    public static void DisableZone()
    {
        //Lower lava

        isActive = false;       
    }


    private void OnTriggerEnter(Collider coll)
    {
        if (isActive)
        {
            
            if (coll.gameObject.tag == "Player")
            {
                PlayerHit playerHit = coll.gameObject.GetComponent<PlayerHit>();
                playerHit.GetComponent<PlayerMovement>().moveSpeed = decreasedSpeed;
                playerHit.EnableTickDamage(damageAmount);
            }
            
        }
    }
    private void OnTriggerExit(Collider coll)
    {
        if (isActive)
        {
            if (coll.gameObject.tag == "Player")
            {
                PlayerHit playerHit = coll.gameObject.GetComponent<PlayerHit>();
                playerHit.GetComponent<PlayerMovement>().moveSpeed = 5f;
                playerHit.DisableTickDamage();
            }
        }
    }
}
