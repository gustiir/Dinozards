using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projectile_01 : MonoBehaviour
{
    float speed = 10f;


    void Start()
    {
        
    }

 
    void Update()
    {
        transform.position = transform.position + transform.forward * speed * Time.deltaTime;
       
    }
}
