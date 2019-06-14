using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StormBehavior : MonoBehaviour
{
    private static StormBehavior instance;
    private Transform circleTransform;
    private Vector3 circleCurrentSize;
    private Vector3 circleCurrentPosition;
    private bool isStormFollowingPath;
    public float stormCurrentRadius;
    private float shrinkingSpeed;
    [HideInInspector]
    public bool enableDamage;
    private int listIndex;
    [HideInInspector]
    public bool isShrinking = false;
    private int shrinkIntervalsLength;

    [Header("Storm Visual Reference")]

    public bool showVisualReference = true;
    public GameObject stormVR;
    public GameObject stormCenter;
    public GameObject stormStencil;
    public GameObject stormTop;
    public GameObject stormBottom;
    public GameObject stormRight;
    public GameObject stormLeft;

    [Header("Rain")]
    public GameObject rain;

    [Space]

    [Header("Storm General")]
    [Tooltip("How many seconds to enable the storm.")]
    public float stormStartTimer = 0f;
    public float stormTargetRadius = 25f;
    public float stormRadius = 25f;
    public float minimumRadius = 5f;
    public float newTargetRadius = 50f;
    public bool isMoving;
    [Range(0f,10f)]
    public float stormSpeed = 2f;
    public float movementStopInterval;
    [Tooltip("This will only be used if the intervals list is empty. The higher this value, fast will be.")]
    public float defautShrinkingSpeed = 3f;
    public float stormHeight = 10f;

    [Space]

    [Header("Storm Damage")]
    public float stormDamageValue = 0.1f;
    [Range(0.1f,5f)]
    public float timerDuration = 1f;

    [Space]

    [Header("Shrinking Intervals")]
    public IntervalRangeClass[] shrinkIntervals;

    private StormPathFollower stormFollower;

    public LavaGround lavaGround;
    public float timeToRaiseLava = 3f;


    private void Awake()
    {
        instance = this;

        stormFollower = FindObjectOfType<StormPathFollower>();
    }

    private void Start()
    {
        stormFollower.SetPath();
        circleTransform = transform;
        stormCurrentRadius = stormRadius;
        circleCurrentSize = new Vector3(stormCurrentRadius, stormCurrentRadius, stormCurrentRadius);
        newTargetRadius = stormRadius;
        listIndex = 0;
        shrinkIntervalsLength = shrinkIntervals.Length;
        stormVR.SetActive(showVisualReference);
        Invoke("StartStorm", stormStartTimer);
    }

    private void StartStorm()
    {
        enableDamage = true;
        StartShrinkInterval();
        FindObjectOfType<GamePlayUI>().ShowWizardWarning();
        if (movementStopInterval != 0)
        {
            Invoke("ToggleMoving", movementStopInterval);
        }

    }

    private void Update()
    {
        
        SetCircleSizeAndPosition(circleCurrentSize);
        StormShrinking(newTargetRadius, shrinkingSpeed);
        if (isShrinking && stormCurrentRadius - newTargetRadius < 0.01)
        {
            isShrinking = false;
            NextShrinkInterval();
        }

    }

    private void SetCircleSizeAndPosition(Vector3 size) 
    {
        circleTransform.localScale = size;
    }

    private bool IsOutsideCircle(Vector3 position)
    {
        return Vector3.Distance(position, transform.position) > circleCurrentSize.x * .5f;
    }

    public static bool IsOutsideCircle_Static(Vector3 position)
    {
        return instance.IsOutsideCircle(position);
    }


    //Lerp the Storm Radius circle values
    private void StormShrinking(float targetSize, float speed)
    {
        if (stormCurrentRadius != targetSize)
        {
            stormCurrentRadius = Mathf.Lerp(stormCurrentRadius, targetSize, Time.deltaTime * speed/10);
            circleCurrentSize = new Vector3(stormCurrentRadius, stormCurrentRadius, stormHeight);
        }
    }

    private void ToggleMoving()
    {
        if (isMoving)
        {
            isMoving = false;
            Invoke("ToggleMoving", movementStopInterval);
        }
        else
        {
            isMoving = true;
            Invoke("ToggleMoving", movementStopInterval);
        }
    }

    private void StartShrinkInterval()
    {
        if (shrinkIntervals.Length != 0) //Use the list parameters
        {
            float intervalTimer;
            intervalTimer = shrinkIntervals[listIndex].preCounter;
            Invoke("ShrinkInterval", intervalTimer);
        }
        else  //Set default shrinking settings
        {
            //shrinkingSpeed = defautShrinkingSpeed;
            //newTargetRadius = minimumRadius;

        }
    }

    private void ShrinkInterval()
    {
        shrinkingSpeed = shrinkIntervals[listIndex].shrinkSpeed;
        newTargetRadius = stormCurrentRadius - shrinkIntervals[listIndex].units;
        isShrinking = true;
        isMoving = shrinkIntervals[listIndex].moveStorm;
        if (shrinkIntervals[listIndex].raiseLava)
        {
            Invoke("EnableLava", timeToRaiseLava);
        }
        if (shrinkIntervals[listIndex].thunderWeak)
        {
            AudioManager.instance.Play("Thunderstorm_02");
        }
        if (shrinkIntervals[listIndex].thunderStrong)
        {
            AudioManager.instance.Play("Thunderstorm_01");
            AudioManager.instance.Play("ThunderstormAmbience_01");
            AudioManager.instance.Play("Rain_01");
            rain.SetActive(true);
        }
    }

    private void EnableLava()
    {
        lavaGround.enabled = true;
        DamagingZoneBehaviour.EnableZone();
        AudioManager.instance.Play("LavaRaising_01");
    }

    private void NextShrinkInterval()
    {
        if (stormCurrentRadius >= minimumRadius)
        {
            listIndex++;
            StartShrinkInterval();
        }
    }

    public void RestartStorm()
    {
        stormFollower.distanceTraveled = 0f;
        Start();
    }

    public void StopStorm()
    {
        enableDamage = false;
        isMoving = false;
        isShrinking = false;
        AudioManager.instance.Stop("ThunderstormAmbience_01");
        AudioManager.instance.Stop("Rain_01");
    }
}
