using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XInputDotNetPure;
using UnityEngine.Assertions;



public class LavaGround : MonoBehaviour
{

    private Vector3 velocity;
    private float smoothTime;
    private Vector3 raisedLocation;

    private PlayerVibrator player1Vibrator;
    private PlayerVibrator player2Vibrator;
    private PlayerVibrator player3Vibrator;
    private PlayerVibrator player4Vibrator;
    public GameObject Player1;
    public GameObject Player2;
    public GameObject Player3;
    public GameObject Player4;

    private MultipleTargetCamera camera;
    [Tooltip("This values is not really needed and doesn't really do much, blame Gusten")]
    public float cameraShakeDuration = 0.1f;
    public float cameraShakeIntensity = 0.015f;

    private bool doTheShake = false;

    public float lavaRaisedY = 0.05f;


    private void OnEnable()
    {
        player1Vibrator = Player1.GetComponent<PlayerVibrator>();
        Assert.IsNotNull(player1Vibrator, "PlayerVibrator1 was not found.");

        player2Vibrator = Player2.GetComponent<PlayerVibrator>();
        Assert.IsNotNull(player2Vibrator, "PlayerVibrator2 was not found.");

        player3Vibrator = Player3.GetComponent<PlayerVibrator>();
        Assert.IsNotNull(player3Vibrator, "PlayerVibrator3 was not found.");

        player4Vibrator = Player4.GetComponent<PlayerVibrator>();
        Assert.IsNotNull(player4Vibrator, "PlayerVibrator4 was not found.");
    }

    private void Awake()
    {
    }
    private void Start()
    {
        raisedLocation = transform.position + new Vector3(0, lavaRaisedY, 0);
        smoothTime = 0.5f;
        camera = GameObject.FindWithTag("Camera").GetComponent<MultipleTargetCamera>();   
    }

    void Update()
    {
        if (transform.position != raisedLocation)
        {
            doTheShake = true;
            RaiseLava();
        }
        else doTheShake = false;

        if (doTheShake)
        {
            Shaker();
        }

    }
    
    void Shaker()
    {
        camera.ShakeCamera(cameraShakeDuration, cameraShakeIntensity);
    }
   

    public void RaiseLava()
    {
        transform.position = Vector3.SmoothDamp(transform.position, raisedLocation, ref velocity, smoothTime);
        player1Vibrator.Vibrator();
        player2Vibrator.Vibrator();
        player3Vibrator.Vibrator();
        player4Vibrator.Vibrator();
    }
}
