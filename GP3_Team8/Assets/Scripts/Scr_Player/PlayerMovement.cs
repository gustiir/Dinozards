using UnityEngine;

[RequireComponent(typeof(PlayerInput))]
public class PlayerMovement : MonoBehaviour
{
    #region Fields

    private PlayerInput playerInput;
    private Rigidbody rigidbody;

    private Animator animController;

    PlayerStates playerState;

    // TODO: Add to options
    public float moveSpeed = 2f;
    [Tooltip("Degrees of rotation per second")] public float rotationRate = 5f;
    public float deadZone = 0.2f;
    // TODO: Add to options

    public Quaternion toRightStick;
    public Quaternion toLeftStick;
    public Quaternion toStick;
    public float angleLeftStick;
    public float angleRightStick;
    public Vector3 movement;

    public float horizontalAxis;
    public float verticalAxis;
    private float turnX;
    private float turnY;

    public GameObject directionOfMovement;

    private DashAbility dash;

    GameManager.eGameState gameState;
    #endregion Fields

    void Start() {
        
        playerInput = GetComponent<PlayerInput>();
        rigidbody = GetComponent<Rigidbody>();
        dash = directionOfMovement.GetComponent<DashAbility>();
        playerState = GetComponent<PlayerStates>();

        animController = GetComponent<Animator>();
    }

    void Update() {

        if (playerInput.state.IsConnected) {

            turnX = playerInput.state.ThumbSticks.Right.X;
            turnY = playerInput.state.ThumbSticks.Right.Y;
            if (GameManager.managerInstance)
            {
                switch (GameManager.managerInstance.gameState)
                {
                    case GameManager.eGameState.PLAYING:
                        Turn(turnX, turnY);
                        break;
                }
            }
            
        }
    }

    void LateUpdate() {

        if (playerInput.state.IsConnected) {

            horizontalAxis = playerInput.state.ThumbSticks.Left.X;
            verticalAxis = playerInput.state.ThumbSticks.Left.Y;

            if (GameManager.managerInstance)
            {
                switch (GameManager.managerInstance.gameState)
                {
                    case GameManager.eGameState.PLAYING:
                        Move(horizontalAxis, verticalAxis);
                        break;
                }
            }            
        }
    }

    public void Move(float xInput, float yInput) {

        Vector3 movement = new Vector3(xInput, Time.deltaTime * Physics.gravity.y, yInput) * moveSpeed;

        rigidbody.MovePosition(transform.position + movement * Time.deltaTime);
        
        // Set Idle / Walk Blend Tree Animation
        if (Mathf.Abs(xInput) > Mathf.Abs(yInput))
            animController.SetFloat("Speed", Mathf.Abs(xInput));
        else
            animController.SetFloat("Speed", Mathf.Abs(yInput));


        // Rotates the Direction Of Movement child under the char which is used to decide the forward vector the player is moving toward
        if (Mathf.Abs(horizontalAxis) > 0.05f || Mathf.Abs(verticalAxis) > 0.05f)
        {

            float angleLeftStick = Mathf.Atan2(horizontalAxis, verticalAxis) * 181 / Mathf.PI;

            Quaternion toLeftStick = Quaternion.Euler(0, angleLeftStick, 0);

            directionOfMovement.transform.rotation = Quaternion.Slerp(directionOfMovement.transform.rotation, toLeftStick, 100);
        }

        else // If no movement input is made then sets the direction of movement to be same as the char
            directionOfMovement.transform.rotation = gameObject.transform.rotation;
    }

    public void Turn(float xInput, float yInput)
    {
        if (Mathf.Abs(horizontalAxis) > deadZone - 0.1f || Mathf.Abs(verticalAxis) > deadZone - 0.1f || Mathf.Abs(xInput) > deadZone || Mathf.Abs(yInput) > deadZone)
        {
            float angleLeftStick = Mathf.Atan2(horizontalAxis, verticalAxis) * 181 / Mathf.PI;
            float angleRightStick = Mathf.Atan2(xInput, yInput) * 181 / Mathf.PI;

            Quaternion toLeftStick = Quaternion.Euler(0, angleLeftStick, 0);
            Quaternion toRightStick = Quaternion.Euler(0, angleRightStick, 0);

            if (Mathf.Abs(xInput) > deadZone || Mathf.Abs(yInput) > deadZone)
            {
                toStick = toRightStick;
            }
            else
            {
                toStick = toLeftStick;
            }

            transform.rotation = Quaternion.Slerp(transform.rotation, toStick, rotationRate * Time.deltaTime);
        }
    }

    public void RightFootDown() {
        
        Debug.Log("Right Foot Down - PlayerMovement.cs Line 141");
    }

    public void LeftFootDown() {

        Debug.Log("Left Foot Down - PlayerMovement.cs Line 146");
    }
}