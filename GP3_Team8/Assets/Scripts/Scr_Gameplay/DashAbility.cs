using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;


public class DashAbility : MonoBehaviour, IAbility {

    #region Fields

    [SerializeField]
    private bool drawDebugDashTargetAndHitRadius = true;

    [SerializeField]
    private bool useJoystickCancelDash = false;

    public int manaCost = 1;

    public float dashDamage = 5;

    [SerializeField]
    private float dashMinLength = 1.5f;

    [SerializeField]
    private float dashMaxLength = 6f;

    [SerializeField]
    private float dashMinDuration = .2f;

    [SerializeField]
    private float dashMaxDuration = .5f;

    [SerializeField]
    private AnimationCurve dashSpeedCurve;

    [SerializeField]
    private float dashHitRadius = .45f;

    [SerializeField]
    private float dashMoveCancelTreshHold = .5f;

    [SerializeField]
    private LayerMask dashTraceFor;

    public List<GameObject> enemiesDashedInto;

    [SerializeField]
    private float dashMinKnockback = 1.5f;

    [SerializeField]
    private float dashMaxKnockback = 4f;

    [SerializeField]
    private float knockbackWhenDashingIntoEachother = 3f;

    [SerializeField]
    private float knockbackY = 0;

    [SerializeField]
    private float delayBeforeStartingDash = 0.01f;

    [SerializeField]
    private float delayAfterDashBeforeReturningToNormal = 0;

    [SerializeField]
    private float dashOnDashSlowDownTimeScale = 0.05f;

    [SerializeField]
    private float dashOnDashSlowDownDuration = .35f;

    [SerializeField]
    private float dashOnDashCameraShakeDuration = 0.2f;

    [SerializeField]
    private float dashOnDashCameraShakeIntensity = 0.1f;

    [SerializeField]
    private GameObject dashOnDashVFX;

    [SerializeField]
    private GameObject dashVFX1;

    [SerializeField]
    private GameObject dashVFX2;
    
    private PlayerMovement playerMovement;

    private GameObject player;

    private PlayerStates playerState;

    private TimeManager timeManager;

    #endregion Fields

    //-----------------------------------

    void Start() {

        timeManager = GameObject.FindGameObjectWithTag("GamePlayHandler").GetComponent<TimeManager>();

       // dashTraceFor = LayerMask.GetMask("Everything"); // This sets it to nothing instead of Everything for osme reason

        player = transform.root.gameObject; // Player Ref

        playerMovement = player.GetComponent<PlayerMovement>();

        playerState = this.GetComponentInParent<PlayerStates>(); // State Ref

        Assert.IsNotNull(player, "PlayerState was not found."); 
    }

    //-----------------------------------
    // Dash Lerp and Casts for hits

    IEnumerator Dash() {
        
        float leftJoystickInput;

        float initialDashVerticalAxis = playerMovement.verticalAxis;

        float initialDashHorizontalAxis = playerMovement.horizontalAxis;

        // Sets the leftJoystickInput to be the highest value that is coming from the left joystick
        if (Mathf.Abs(playerMovement.horizontalAxis) > Mathf.Abs(playerMovement.verticalAxis))
            leftJoystickInput = Mathf.Abs(playerMovement.horizontalAxis);
        else
            leftJoystickInput = Mathf.Abs(playerMovement.verticalAxis);

        // Sets Length to dash depending on how much you press the left joystick. 
        float lengthToDash = Mathf.Lerp(dashMinLength, dashMaxLength, leftJoystickInput);

        float dashDuration = Mathf.Lerp(dashMinDuration, dashMaxDuration, leftJoystickInput);

        float knockbackToApply = Mathf.Lerp(dashMinKnockback, dashMaxKnockback, leftJoystickInput);

        dashDuration = 1 / dashDuration;

        float dashCounter = 0;

        RaycastHit[] dashSphereCastHits;

        // Delay before starting dash, could be like 0.1 sek
        yield return new WaitForSeconds(delayBeforeStartingDash);

        // If Still in the Dash State after delay then continues with the coroutine, otherwise breaks it. 
        if (playerState.IsState(PlayerStates.PossibleStates.IsDashing) == false)
            yield break;

        // Dash Start Location
        Vector3 dashStartLocation = gameObject.transform.position;

        // Dash Target Location
        Vector3 dashTargetLocation = (dashStartLocation + gameObject.transform.forward * lengthToDash);

        if (drawDebugDashTargetAndHitRadius)
            Debug.DrawLine(dashStartLocation, dashTargetLocation, Color.red, 60);

        // Spawns Particle Effects
        GameObject dashVFXTemp1 = Instantiate(dashVFX1, player.transform.position, Quaternion.identity) as GameObject;
        GameObject dashVFXTemp2 = Instantiate(dashVFX2, player.transform.position, Quaternion.identity) as GameObject;

        // Set Dash VFX Parent
        dashVFXTemp1.transform.SetParent(gameObject.transform.root.transform, true);
        dashVFXTemp2.transform.SetParent(gameObject.transform.root.transform, true);

        // While player is 0.1 meters away from the dash target location
        while (Vector3.Distance (player.transform.position, dashTargetLocation) > 0.1f) {

            Vector3 dirFromEnemyToPlayer;
            Vector3 dirFromPlayerToEnemy;

            // If Still Dashing then lerps the player
            if (playerState.IsState(PlayerStates.PossibleStates.IsDashing)) {

                if (useJoystickCancelDash) {

                    // If players Move Left stick to much to another direction from where they started the dash then cancels it
                    if (playerMovement.horizontalAxis >= initialDashHorizontalAxis + dashMoveCancelTreshHold || playerMovement.horizontalAxis <= initialDashHorizontalAxis - dashMoveCancelTreshHold) {

                        playerState.SetStateTo(PlayerStates.PossibleStates.IsNormal);
                        StopDash();
                        yield break;
                    }


                    // If players Move Left stick to much to another direction from where they started the dash then cancels it
                    else if (playerMovement.verticalAxis >= initialDashVerticalAxis + dashMoveCancelTreshHold || playerMovement.verticalAxis <= initialDashVerticalAxis - dashMoveCancelTreshHold) {

                        playerState.SetStateTo(PlayerStates.PossibleStates.IsNormal);
                        StopDash();
                        yield break;
                    }
                }
                
                // Lerps the player toward from start locaation to dash location, casting for hits along the way. 
                player.transform.position = Vector3.Lerp(dashStartLocation, dashTargetLocation, dashSpeedCurve.Evaluate(dashCounter));
                
                dashCounter += dashDuration * Time.deltaTime;
                
                // Sphere cast for enemies and obstacles, if 2 hit eachother and are both dashing then both should get stunned. 
                dashSphereCastHits = Physics.SphereCastAll(player.transform.position, dashHitRadius, gameObject.transform.forward, dashHitRadius, dashTraceFor);
            
                // If got a Hit when dashing then lerps through them and checks what it was
                if (dashSphereCastHits.Length > 0) {

                    foreach (RaycastHit dashHits in dashSphereCastHits) {
                        
                        if (dashHits.transform.gameObject.tag == "Player" && dashHits.transform.gameObject != player) {
                            
                            // If Dashing into Enemy that is also dashing
                            if (dashHits.transform.gameObject.GetComponent<PlayerStates>().IsState(PlayerStates.PossibleStates.IsDashing) && !enemiesDashedInto.Contains(dashHits.transform.gameObject)) {

                                enemiesDashedInto.Add(dashHits.transform.gameObject);

                                // Calls Hit on Self when dashing into eachother
                                dirFromEnemyToPlayer = (transform.position - dashHits.collider.gameObject.transform.position).normalized;
                                player.GetComponent<PlayerHit>().OnPlayerHit(new Vector3(dirFromEnemyToPlayer.x, knockbackY, dirFromEnemyToPlayer.z), knockbackWhenDashingIntoEachother, dashDamage, dashOnDashCameraShakeDuration, dashOnDashCameraShakeIntensity, PlayerHit.HitBy.Dash);
                                
                                // Calls Hit on Enemy when dashing into eachother
                                dirFromPlayerToEnemy = (dashHits.collider.gameObject.transform.position - transform.position).normalized;
                                dashHits.collider.gameObject.GetComponent<PlayerHit>().OnPlayerHit(new Vector3(dirFromPlayerToEnemy.x, knockbackY, dirFromPlayerToEnemy.z), knockbackWhenDashingIntoEachother, dashDamage, 0, 0, PlayerHit.HitBy.Dash);

                                // Get Middle point between two players that have dashed into eachother
                                Vector3 locationBetweenPlayers = (transform.position + dashHits.collider.gameObject.transform.position) / 2;
                                
                                // Spawn dashingIntoEachotherFX in that location
                                GameObject spawnedProjectileFX = Instantiate(dashOnDashVFX, locationBetweenPlayers, Quaternion.identity) as GameObject;
                                
                                timeManager.SlowDownTime(dashOnDashSlowDownTimeScale, dashOnDashSlowDownDuration);
                            }
                            
                            // If Dashing into player that is not dashing
                            else if (!dashHits.transform.gameObject.GetComponent<PlayerStates>().IsState(PlayerStates.PossibleStates.IsDashing) && !enemiesDashedInto.Contains(dashHits.transform.gameObject)) {
                                
                                enemiesDashedInto.Add(dashHits.transform.gameObject);

                                // Get Direction Vector Hit Player and Calls Hit
                                dirFromPlayerToEnemy = (dashHits.collider.gameObject.transform.position - transform.position).normalized;
                                dashHits.collider.gameObject.GetComponent<PlayerHit>().OnPlayerHit(new Vector3(dirFromPlayerToEnemy.x, knockbackY, dirFromPlayerToEnemy.z), knockbackToApply, dashDamage, 0, 0, PlayerHit.HitBy.Dash);
                                
                                // Spawns the Dash VFX this player uses on the enemy that it hit
                                GameObject enemyDashedIntoVFXTemp1 = Instantiate(dashVFX1, dashHits.transform.gameObject.transform.position, Quaternion.identity) as GameObject;
                                GameObject enemyDashedIntoVFXTemp2 = Instantiate(dashVFX2, dashHits.transform.gameObject.transform.position, Quaternion.identity) as GameObject;

                                // Set Dash VFX Parent
                                enemyDashedIntoVFXTemp1.transform.SetParent(dashHits.transform.gameObject.transform, true);
                                enemyDashedIntoVFXTemp2.transform.SetParent(dashHits.transform.gameObject.transform, true);


                                // TODO If only 2 players left, always slow down time when hitting with dash
                                // timeManager.SlowDownTime(dashSlowDownTimeScale, dashSlowDownDuration);
                            }

                        }

                        // If Dashed into Wall
                        else if (dashHits.transform.gameObject.tag == "Wall") {

                            // If Hit Wall then returns to Normal State and Stops Dash
                            playerState.SetStateTo(PlayerStates.PossibleStates.IsNormal);
                            
                            StopDash();

                            yield break;
                        }
                    }
                }
                
                // If no hit and still in Dash State then returns null so while loop runs again
                yield return null;
            }

            // If No longer in Dashing state then Stops Dash without changing State back to normal
            else {

                StopDash();
                
                yield break;
            }
        }

        StopDash();
        

        // If Dash Complete, can have delay DashEndTime before going back to Normal
        yield return new WaitForSeconds(delayAfterDashBeforeReturningToNormal);

        // If still in dash state after delay then sets it to be normal, otherwise just returns null
        if (playerState.IsState(PlayerStates.PossibleStates.IsDashing))
            playerState.SetStateTo(PlayerStates.PossibleStates.IsNormal);

        yield return null;
    }

    //-----------------------------------
    // Called when dashed finished or hitting wall

    private void StopDash() {

        // Clears players dashed into when finished so new one can be added next time you're dashing. 
        enemiesDashedInto.Clear();
    }

    //-----------------------------------
    // Draw Debug Sphere around Player 

    private void OnDrawGizmosSelected() {

        if (drawDebugDashTargetAndHitRadius) { 

            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(gameObject.transform.position, dashHitRadius);
        }
    }

    //-----------------------------------

    public int ManaCost() {

        return manaCost;
    }

    //-----------------------------------

    public bool CanActivate() {
        
        if (playerState.IsState(PlayerStates.PossibleStates.IsNormal) || playerState.IsState(PlayerStates.PossibleStates.IsShooting )) {

            playerState.SetStateTo( PlayerStates.PossibleStates.IsDashing );
            return true;
        }
        
        else 
            return false;
    }

    //-----------------------------------

    public int OnActivate(GameObject instigator) {

        StartCoroutine(Dash());
        return manaCost;
    }
}
