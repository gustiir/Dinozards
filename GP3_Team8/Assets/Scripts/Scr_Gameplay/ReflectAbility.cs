using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReflectAbility : MonoBehaviour, IAbility {

    #region Fields

    [SerializeField]
    private bool drawDebugReflectRadius;

    [SerializeField]
    private bool debugShowReflectCollision;

    public int manaCost = 1;

    [SerializeField]
    private float reflectDuration = .3f;

    [SerializeField]
    private float reflectRadius = .6f;

    [SerializeField]
    private float reflectRadiusFrom = .6f;

    [SerializeField]
    private float reflectRadiusTo = 1.1f;

    [SerializeField]
    private LayerMask reflectTraceFor;

    /* Reflect Move Forward Related Variables. It is Currently not in use anymore
     
     [SerializeField]
     private bool ShouldMoveForwardWhenReflecting;

     public float reflectLengthToMoveForward = 0.5f;

     public float reflectSpeedToMoveForward = 4f;

     [SerializeField]
     private float reflectMoveForwardCastRadius = .3f;

     [SerializeField]
     private LayerMask reflectMoveForwardTraceFor;
    */

    [SerializeField]
    private float reflectHitAngle = 60f;

    [SerializeField]
    private float reflectDamage = 0f;

    [SerializeField]
    private float reflectKnockback = 3.5f;

    [SerializeField]
    private float reflectKnockbackY = 0;

    [SerializeField]
    private float reflectOnReflectKnockback = 3f;

    [SerializeField]
    private float reflectOnReflectSlowDownTimeScale = 0.05f;

    [SerializeField]
    private float reflectOnReflectSlowDownDuration = 0.3f;

    [SerializeField]
    private float delayFromVFXSpawnToReflectStart = 0f;

    [SerializeField]
    private float delayAfterVFXDissapearingAndReflectOff = .3f;
    
    PlayerStates playerState;

    [SerializeField]
    private GameObject reflectFX;

    [SerializeField]
    private GameObject playerHitWithReflectVFX;

    [SerializeField]
    private GameObject projectileReflectedVFX;
    
    [SerializeField]
    private float reflectedProjectileSlowDownTimeScale = 0.05f;

    [SerializeField]
    private float reflectedProjectileSlowDownDuration = .35f;
    
    public List<GameObject> playersReflected;

    private ParticleSystem reflectFXParticle;

    private TimeManager timeManager;

    private bool haveReflectedProjectile;

    private GameObject player;

    #endregion Fields

    //-----------------------------------

    void Start() {

        timeManager = GameObject.FindGameObjectWithTag("GamePlayHandler").GetComponent<TimeManager>();

        player = transform.root.gameObject; // Gets the root ref

        reflectFXParticle = reflectFX.GetComponent<ParticleSystem>();

        playerState = this.GetComponentInParent<PlayerStates>();
    }

    //-----------------------------------

    public void ReflectedProjectile(Vector3 reflectProjectileLocation) {

        haveReflectedProjectile = true;

        GameObject projectileReflectedFXTemp = Instantiate(projectileReflectedVFX, reflectProjectileLocation, Quaternion.identity) as GameObject;

        timeManager.SlowDownTime(reflectedProjectileSlowDownTimeScale, reflectedProjectileSlowDownDuration);
    }
    
    //-----------------------------------

    IEnumerator Reflecting() {
        
        float counter = 0;

        float scaleRadiusCounter = 1 / reflectDuration;

        RaycastHit[] reflectCastHits;

        // float reflectMoveForwardCounter = 0;

        // RaycastHit[] reflectMoveForwardCastHits;

        // Plays Reflect FX
        reflectFXParticle.Play(true);

        // Small Delay After FX Started and Collision is Actually Enabled. Good if it takes a few frames for FX to kick in. 
        yield return new WaitForSeconds(delayFromVFXSpawnToReflectStart);

        // Check is still reflecting, if not then returns. Exchange for real state later
        if (!playerState.IsState(PlayerStates.PossibleStates.IsReflecting))
            yield break;

        /* Related to Reflect Move Forward which is not in use anymore
        // Reflect Start Location
        Vector3 reflectStartMoveLocation = player.transform.gameObject.transform.position;
        
        // Reflect Target Location
        Vector3 reflectTargetMoveLocation = (reflectStartMoveLocation + player.transform.gameObject.transform.forward * reflectLengthToMoveForward);
        */

        while (counter <= reflectDuration) {

            if (playerState.IsState(PlayerStates.PossibleStates.IsReflecting)) {
                
                reflectRadius = Mathf.Lerp(reflectRadiusFrom, reflectRadiusTo, counter * scaleRadiusCounter);
                
                counter += Time.deltaTime;

                // Sphere cast for enemies and obstacles, if 2 hit eachother and are both dashing then both should get stunned. 
                reflectCastHits = Physics.SphereCastAll(player.transform.position, reflectRadius, gameObject.transform.forward, reflectRadius, reflectTraceFor);


                if (reflectCastHits.Length > 0) {

                    foreach (RaycastHit reflectHits in reflectCastHits) {

                        // Calculates the Angle Hit
                        Vector3 direction = reflectHits.transform.gameObject.transform.root.gameObject.transform.position - transform.root.transform.position;
                        float angle = Vector3.Angle(direction, gameObject.transform.forward);

                        // If Collide with Player
                        if (reflectHits.transform.gameObject.tag == "Player" && reflectHits.transform.gameObject != player && !playersReflected.Contains(reflectHits.transform.gameObject) && angle < reflectHitAngle && !reflectHits.transform.gameObject.GetComponent<PlayerStates>().IsState(PlayerStates.PossibleStates.IsReflecting)) {
                            
                            playersReflected.Add(reflectHits.transform.gameObject);

                            Vector3 dirFromPlayerToEnemy = (reflectHits.transform.gameObject.transform.position - transform.position).normalized;

                            // Spawns VFX when reflected player
                            GameObject reflectedPlayerTemp = Instantiate(playerHitWithReflectVFX, reflectHits.transform.gameObject.transform.position, Quaternion.identity) as GameObject;

                            // Call Hit On Play with 0 damage and Knockback
                            reflectHits.transform.gameObject.GetComponent<PlayerHit>().OnPlayerHit(new Vector3(dirFromPlayerToEnemy.x, reflectKnockbackY, dirFromPlayerToEnemy.z), reflectKnockback, reflectDamage, 0, 0, PlayerHit.HitBy.Reflect);
                        }

                        // If Two Reflects Hit Eachother
                        else if (reflectHits.transform.gameObject.tag == "Player" && reflectHits.transform.gameObject != player && !playersReflected.Contains(reflectHits.transform.gameObject) && angle < reflectHitAngle && reflectHits.transform.gameObject.GetComponent<PlayerStates>().IsState(PlayerStates.PossibleStates.IsReflecting)) {
                            
                            playersReflected.Add(reflectHits.transform.gameObject);

                            Vector3 positionBetweenPlayers = (reflectHits.transform.gameObject.transform.position + transform.position) / 2;

                            Vector3 dirFromEnemyToPlayer = (transform.position - reflectHits.transform.gameObject.transform.root.gameObject.transform.position).normalized;

                            Vector3 dirFromPlayerToEnemy = (reflectHits.transform.gameObject.transform.root.gameObject.transform.position - transform.position).normalized;

                            // Calls Player Hit on enemy
                            reflectHits.transform.gameObject.GetComponent<PlayerHit>().OnPlayerHit(new Vector3(dirFromPlayerToEnemy.x, reflectKnockbackY, dirFromPlayerToEnemy.z), reflectOnReflectKnockback, reflectDamage, 0.1f, 0.05f, PlayerHit.HitBy.Reflect);

                            // Calls Player Hit on self
                            player.GetComponent<PlayerHit>().OnPlayerHit(new Vector3(dirFromEnemyToPlayer.x, reflectKnockbackY, dirFromEnemyToPlayer.z), reflectOnReflectKnockback, reflectDamage, 0.1f, 0.05f, PlayerHit.HitBy.Reflect);
                            
                            // Spawns Sparks at reflect on reflect point
                            GameObject projectileReflectedFXTemp = Instantiate(projectileReflectedVFX, positionBetweenPlayers, Quaternion.identity) as GameObject;

                            // Slows Down time a bit
                            timeManager.SlowDownTime(reflectOnReflectSlowDownTimeScale, reflectOnReflectSlowDownDuration);
                        }

                        // If Reflect Hit a Projectile and its not the players own projectile
                        else if (reflectHits.transform.gameObject.tag == "Projectile" && !player.GetComponentInChildren<ProjectileAbility>().spawnedProjectiles.Contains(reflectHits.transform.gameObject.transform.root.gameObject) && angle < reflectHitAngle) {

                            // Calls Got Reflected on the Projectile
                            reflectHits.transform.gameObject.GetComponent<Projectile>().GotReflected(transform.root.gameObject, reflectHits.point);

                            ReflectedProjectile(reflectHits.point);
                        }
                    }
                }
                
                /* Related to Reflect Move Forward which is not in use anymore
                 * 
                 * if (ShouldMoveForwardWhenReflecting) {
                 *      // Moves player forward a bit when reflecting
                            player.transform.position = Vector3.Lerp(reflectStartMoveLocation, reflectTargetMoveLocation, reflectMoveForwardCounter);

                            reflectMoveForwardCastHits = Physics.SphereCastAll(player.transform.position, reflectMoveForwardCastRadius, gameObject.transform.forward, reflectMoveForwardCastRadius, reflectMoveForwardTraceFor);

                            // If not hitting Wall, then lerps forward
                            if (reflectMoveForwardCastHits.Length == 0) {

                                reflectMoveForwardCounter = counter * reflectSpeedToMoveForward;
                            }
                        }
                */
                
                // When reflected a Projectile
                if (haveReflectedProjectile) {

                    // Stops Emitting the FX, making it dissapear faster
                    reflectFXParticle.Stop(true, ParticleSystemStopBehavior.StopEmitting);

                    haveReflectedProjectile = false;

                    // Small delay for when VFX is gone
                    yield return new WaitForSeconds(delayAfterVFXDissapearingAndReflectOff);

                    playersReflected.Clear();

                    reflectRadius = reflectRadiusFrom;

                    // If still IsReflecting after the small delay, then resets it to normal
                    if (playerState.IsState(PlayerStates.PossibleStates.IsReflecting)) {

                        playerState.SetStateTo(PlayerStates.PossibleStates.IsNormal);
                    }
                    
                    yield break;
                }
            }

            else {

                reflectFXParticle.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);

                playersReflected.Clear();
                reflectRadius = reflectRadiusFrom;

                yield break;
            }
            
            yield return null;
        }

        // If Reflect is Finished without get abrubted then sets state to Normal
        playerState.SetStateTo(PlayerStates.PossibleStates.IsNormal);

        playersReflected.Clear();
        reflectRadius = reflectRadiusFrom;
    }

    //-----------------------------------
    // Draw Debug Reflect Sphere around Player 

    private void OnDrawGizmosSelected() {

        if (drawDebugReflectRadius) {

            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(gameObject.transform.position, reflectRadius);
        }
    }

    //-----------------------------------

    public int ManaCost() {
        return manaCost;
    }

    //-----------------------------------

    public bool CanActivate() {

        if (playerState.IsState(PlayerStates.PossibleStates.IsNormal) || playerState.IsState(PlayerStates.PossibleStates.IsDashing)) {

            playerState.SetStateTo(PlayerStates.PossibleStates.IsReflecting);

            return true;
        }

        else
            return false;
    }

    //-----------------------------------

    public int OnActivate(GameObject instigator) {

        StartCoroutine(Reflecting());
        return manaCost;
    }
}
