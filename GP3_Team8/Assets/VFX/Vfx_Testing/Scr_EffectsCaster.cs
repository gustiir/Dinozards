using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EffectsCaster : MonoBehaviour
{
    public GameObject effectTospawn;


    private void Update()
    {
       if(Input.GetKeyUp(KeyCode.Space)) { 
            Instantiate(effectTospawn, transform.position, transform.rotation);
        }
    }
}
