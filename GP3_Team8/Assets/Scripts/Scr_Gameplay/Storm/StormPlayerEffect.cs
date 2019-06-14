using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StormPlayerEffect : MonoBehaviour
{

    private PlayerHit myHitComponent;
    private StormBehavior gameStorm;
    private float initialStormTimer;
    private float currentStormTimer;


    private void Awake()
    {
        myHitComponent = GetComponent<PlayerHit>();
        gameStorm = FindObjectOfType<StormBehavior>();
        if (gameStorm != null)
        {
            initialStormTimer = gameStorm.timerDuration;
            currentStormTimer = initialStormTimer;
        }

    }

    private void Update()
    {
        if (gameStorm != null)
        {
            StormTimer();
        }
    }

    private void StormTimer()
    {
        currentStormTimer -= Time.deltaTime;

        if (currentStormTimer <= 0.0f)
        {
            MakeDamage();
            currentStormTimer = initialStormTimer;
        }
    }

    void MakeDamage()
    {
        if (StormBehavior.IsOutsideCircle_Static(transform.position))
        {
            if (myHitComponent)
            {
                myHitComponent.OnPlayerHit(Vector3.zero, 0, gameStorm.stormDamageValue, 0, 0, PlayerHit.HitBy.Storm);
            }
        }
    }


}

