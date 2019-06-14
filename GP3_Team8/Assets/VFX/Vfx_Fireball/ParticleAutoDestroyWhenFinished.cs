using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleAutoDestroyWhenFinished : MonoBehaviour {

    private ParticleSystem partSystem;

    [SerializeField]
    private bool automaticallyDestroyWhenFinished = true;
    
    void Start() {

        partSystem = GetComponent<ParticleSystem>();

        if (automaticallyDestroyWhenFinished) {

            float totalDuration = partSystem.main.duration;

            Destroy(this.gameObject, totalDuration);
        }
    }
}
