using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleSystemBehaviour : MonoBehaviour
{

    public Vector3 direction = new Vector3(0, 0, 100);
    ParticleSystem particleSystem;
    StormBehavior storm;

    [Tooltip("To minimize storm particle lag, the particle system is faster at the start of every round. This is the duration of the 'faster state'.")]
    public float windUpDuration = 3f;

    Color color;
    float baseSimulationSpeed;

    public GameObject stormPrefab;

    void Awake()
    {
        particleSystem = GetComponent<ParticleSystem>();
        storm = stormPrefab.GetComponent<StormBehavior>();
        ParticleSystem.ShapeModule systemShape = particleSystem.shape;
        systemShape.radius = storm.stormRadius * 0.5f;
        transform.position = storm.transform.position;
    }
    void Start()
    {
        StartCoroutine(ParticleWindUp());
    }

    void Update()
    {
        transform.Rotate(direction * Time.deltaTime);
        transform.position = storm.transform.position;

        ParticleSystem.ShapeModule shapeModule = particleSystem.shape;
        shapeModule.radius = storm.stormCurrentRadius * 0.5f;

        ParticleSystem.EmissionModule emissionModule = particleSystem.emission;
        emissionModule.rateOverTime = shapeModule.radius * 4f;

    }
    public void PlayStormParticles()
    {
        particleSystem.Play();
        StartCoroutine(ParticleWindUp());
    }
    
    IEnumerator ParticleWindUp()
    {

        ParticleSystem.MainModule stormMain = particleSystem.main;

        baseSimulationSpeed = stormMain.simulationSpeed;
        stormMain.simulationSpeed *= 3;

        ParticleSystem.TrailModule stormTrail = particleSystem.trails;
        GradientAlphaKey[] alphaKey;
        GradientColorKey[] colorKey;

        color = stormTrail.colorOverLifetime.color;

        Gradient newGradient = new Gradient();

        alphaKey = new GradientAlphaKey[2];
        alphaKey[0].alpha = 0.0f;
        alphaKey[0].time = 0.0f;
        alphaKey[1].alpha = 0.0f;
        alphaKey[1].time = 1.0f;

        colorKey = new GradientColorKey[2];
        colorKey[0].color = Color.red;
        colorKey[0].time = 0.0f;
        colorKey[1].color = Color.blue;
        colorKey[1].time = 1.0f;

        newGradient.SetKeys(colorKey, alphaKey);     

        stormTrail.colorOverLifetime = newGradient;    

        yield return new WaitForSeconds(windUpDuration);

        stormTrail.colorOverLifetime = color;
        stormMain.simulationSpeed = baseSimulationSpeed;

        yield return null;
    }
    public void StopStormParticles()
    {
        particleSystem.Stop();
    }
}
