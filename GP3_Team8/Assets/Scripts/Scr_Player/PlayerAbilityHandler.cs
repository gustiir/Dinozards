using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAbilityHandler : MonoBehaviour
{
    // Start is called before the first frame update

    #region Fields

    private DashAbility dashAbility;
    public GameObject dashPrefab;

    public float dashDamage = 10f;

    #endregion Fields

    void Start() {
        dashAbility = dashPrefab.GetComponent<DashAbility>();
    }

    // Update is called once per frame
    void Update() {
        
    }

    /*
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.gameObject.tag == "Player")
        {

            if (dashAbility.isDashing)
            {
                Debug.Log("hit");
                GameObject player = collision.collider.gameObject;
                PlayerHit playerHit = player.GetComponent<PlayerHit>();
                HPManager hpManager = player.GetComponent<HPManager>();
              
                playerHit.OnPlayerHit(collision.transform.position - transform.position, 1, 1);
                hpManager.DecreaseHP(dashDamage);
                
            }
        }
    }
    */
}
