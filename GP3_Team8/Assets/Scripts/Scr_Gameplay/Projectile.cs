using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

public class Projectile : MonoBehaviour {

    #region Fields

    [SerializeField]
    private bool drawDebugHitRadius;

    public GameObject owner;
    
    [SerializeField]
    private float projectileHitRadius = 0.35f;

    public float currentProjectileDamage = 15;

    [SerializeField]
    private float currentKnockback;

    [SerializeField]
    private float currentSpeed;
    
    public float minimumSpeed = 10;

    [SerializeField]
    private float maximumSpeed = 15;

    [SerializeField]
    private float speedReflectedMultiplier = .5f;

    public float startingTurnSpeed = 5;
    
    public float targetTurnSpeed = .3f;

    public float timeToLerpFromStartingToTargetTurnSpeed = 1;

    [SerializeField]
    private float currentTurnSpeed;

    public float minimumKnockback = 3f;

    [SerializeField]
    private float maximumKnockback = 5f;

    [SerializeField]
    private float knockbackY = 0;

    private float timesReflected = 1;

    [SerializeField]
    private float reflectedKnockbackMultiplier = 1.5f;
    
    private Vector3 directionToTarget;

    private RaycastHit rayCastHitResult;

    [SerializeField]
    private float heightDistanceAboveGround = 0.5f;

    [SerializeField]
    private LayerMask groundTraceFor;

    [SerializeField]
    private GameObject projectileDestroyedVFX;

    [SerializeField]
    private GameObject projectileMergeExplosionVFX;

    [SerializeField]
    private LayerMask projectileHitTraceFor;

    [SerializeField]
    private float targetCapsuleSearchLength = 15f;

    [SerializeField]
    private float targetCapsuleSearchRadius = 10f;

    [SerializeField]
    private LayerMask targetLayerToSearchFor;

    [SerializeField]
    private GameObject target;

    [SerializeField]
    private float projectileMergeCameraShakeDuration = .25f;

    [SerializeField]
    private float projectileMergeCameraShakeIntensity = .25f;

    [Header("Audio List Names")]
    public List<string> fireballAudioNames;
    
    #endregion Fields
    

    //------------------------------------

    void Start() {

        currentKnockback = minimumKnockback;

        currentSpeed = minimumSpeed;
        
        GetsAndSetsTarget();

        if (target)
           directionToTarget = target.transform.position - transform.position;

        StartCoroutine(StartingTurnSpeed(currentTurnSpeed));
    }

    //------------------------------------
    // Projectile has higher turn speed in the beginning that lerps down

    IEnumerator StartingTurnSpeed(float originalTurnSpeed) {
        
        float counter = 0;

        float turnSpeedCounter = 0;

        while (counter < timeToLerpFromStartingToTargetTurnSpeed) {

            currentTurnSpeed = Mathf.Lerp(startingTurnSpeed, targetTurnSpeed, turnSpeedCounter);

            counter += Time.deltaTime;

            turnSpeedCounter = counter / timeToLerpFromStartingToTargetTurnSpeed;

            yield return null;
        }
        
        yield return null;
    }

    //---------------------------
    // Checks Players in front of projectile and gets the one with the lowest angle from the projectile
    
    void GetsAndSetsTarget() {
        
        Vector3 capsuleStart = transform.position + (transform.forward * (targetCapsuleSearchLength * .75f));

        Vector3 capsuleEnd = transform.position + (transform.forward * targetCapsuleSearchLength);

        Collider[] temp = Physics.OverlapCapsule(capsuleStart, capsuleEnd, targetCapsuleSearchRadius, targetLayerToSearchFor, QueryTriggerInteraction.Collide);
        
        float lowestAngle = 1000f;

        Vector3 direction;

        float angle;

        int targetWithLowestAngle = 0;
        
        // Loops through them and checks the angle to the player. Saves the index of the lowest one . 
        for (int i = 0; i < temp.Length; i++) {

            if (temp[i].gameObject.tag == "Player") {

                // Checks Angle
                direction = temp[i].transform.position - transform.position;
                angle = Vector3.Angle(direction, transform.forward);

                if (angle < lowestAngle) {

                    lowestAngle = angle;
                    targetWithLowestAngle = i;
                }
            }
        }
        
        // If no player was in front of projectile then sets target to null
        if (temp[targetWithLowestAngle].gameObject.tag != "Player")
            target = null;

        else
            target = temp[targetWithLowestAngle].gameObject;
    }

    //------------------------------------
    // Transform Translates toward target, SphereCasts for Walls and raycasts to the ground and sets height distance

    void Update() {

        if (target) {

            directionToTarget = target.transform.position - transform.position;

            Quaternion rotation = Quaternion.LookRotation(directionToTarget);

            transform.rotation = Quaternion.Lerp(transform.rotation, rotation, currentTurnSpeed * Time.deltaTime);

            transform.rotation = new Quaternion(0, transform.rotation.y, 0, transform.rotation.w);
        }
        
        
        transform.Translate(transform.forward * currentSpeed * Time.deltaTime, Space.World);
        
        // Line Traces and sets distance to ground so its always a set distance when going down slopes. 
        if (Physics.Raycast(transform.position, -gameObject.transform.up, out rayCastHitResult, 5f, groundTraceFor))
            transform.position = new Vector3(transform.position.x, rayCastHitResult.point.y + heightDistanceAboveGround, transform.position.z);
        

        // Sphere Trace for Walls as they don't seem to register with normal collider. Prolly since its being translated
        RaycastHit[] projectilephereCastHits = new RaycastHit[0];
        projectilephereCastHits = Physics.SphereCastAll(transform.position, projectileHitRadius, gameObject.transform.forward, projectileHitRadius, projectileHitTraceFor);

        // If Hit on Wall then Destroys self
        if (projectilephereCastHits.Length > 0) {
            foreach (RaycastHit projectileHits in projectilephereCastHits) {

                if (projectileHits.transform.gameObject.tag == "Wall") {

                    AudioManager.instance.PlayWithPitch("FireballHitWall_01", 3f);

                    DestroyProjectile(true);
                }

                // If Projectile Hit Projectile
                else if (projectileHits.transform.root.gameObject.tag == "Projectile" && projectileHits.transform.root.gameObject != gameObject) {
                    
                    Vector3 positionBetweenTheHitProjectiles = (transform.position + projectileHits.transform.position) / 2;

                    GameObject projectileMergedExplosion = Instantiate(projectileMergeExplosionVFX, positionBetweenTheHitProjectiles, Quaternion.identity) as GameObject;

                    owner.GetComponent<PlayerHit>().OnPlayerHit(new Vector3(0, 0, 0), 0, 0, projectileMergeCameraShakeDuration, projectileMergeCameraShakeIntensity, PlayerHit.HitBy.FireBall);

                    projectileHits.transform.root.gameObject.GetComponent<Projectile>().DestroyProjectile(false);

                    AudioManager.instance.PlayWithRandomPitch("FireballBigExplosion_01");

                    DestroyProjectile(false);
                }
            }
        }
    }
    
    //------------------------------------
    // Checks collision with Player

    void OnCollisionEnter (Collision collision) {
        
        foreach (ContactPoint contactPoint in collision.contacts) {
            
            if (contactPoint.otherCollider.gameObject.tag == "Player" && contactPoint.otherCollider.gameObject != owner) {

                // Get Direction Vector Hit Player and Calls Hit
                Vector3 dirFromPlayerToEnemy = (collision.gameObject.transform.position - transform.position).normalized;
                collision.gameObject.GetComponent<PlayerHit>().OnPlayerHit(new Vector3(dirFromPlayerToEnemy.x, knockbackY, dirFromPlayerToEnemy.z), currentKnockback, currentProjectileDamage, 0, 0, PlayerHit.HitBy.FireBall);

                //Plays Fireball hit Audio
                int listIndex = Random.Range(0, fireballAudioNames.Count);
                AudioManager.instance.PlayWithRandomPitch(fireballAudioNames[listIndex]);

                DestroyProjectile(true);
            }

            // If Hit by Owner that is Dashing
            else if (contactPoint.otherCollider.gameObject.tag == "Player" && contactPoint.otherCollider.gameObject == owner && contactPoint.otherCollider.gameObject.GetComponent<PlayerStates>().IsState(PlayerStates.PossibleStates.IsDashing)) {



                Debug.Log("DASHED INTO OWN FIREBALL. Projectile.cs Line 222");
            }
        }
    }

    //------------------------------------

    private void DestroyProjectile(bool spawnExplosion) {

        // Whether you want it to explode and make sounds when destroyed
        if (spawnExplosion) {

            GameObject explosionTemp = Instantiate(projectileDestroyedVFX, transform.position, Quaternion.identity) as GameObject;
        }

        // Removes this projectile from its owners Projectiles List
        owner.GetComponentInChildren<ProjectileAbility>().spawnedProjectiles.Remove(gameObject);
        
        Destroy(this.gameObject);
    }
    
    //------------------------------------
    // Got Reflected by a player. Gets Called from ReflectAbility

    public void GotReflected(GameObject newOwner, Vector3 reflectedLocation) {
        
        owner.GetComponentInChildren<ProjectileAbility>().spawnedProjectiles.Remove(gameObject);

        // Replaces owner with the one it got reflected by and target to its old Owner
        target = owner;
        owner = newOwner;

        owner.GetComponentInChildren<ProjectileAbility>().spawnedProjectiles.Add(gameObject);

        // Bounce Back toward the owner
        directionToTarget = target.transform.position - transform.position;
        Quaternion rotation = Quaternion.LookRotation(directionToTarget);
        transform.rotation = Quaternion.RotateTowards(transform.rotation, rotation, 10000);
        transform.rotation = new Quaternion(0, transform.rotation.y, 0, transform.rotation.w);

        // Increase Max Speed
        currentSpeed += minimumSpeed * speedReflectedMultiplier;
        currentSpeed = Mathf.Clamp(currentSpeed, minimumSpeed, maximumSpeed);

        // Increase Knockback
        currentKnockback += (minimumKnockback * reflectedKnockbackMultiplier);
        currentKnockback = Mathf.Clamp(currentKnockback, minimumKnockback, maximumKnockback);

        //Plays Reflect Sound
        AudioManager.instance.PlayWithRandomPitch("FireballReflect_01");
    }

    //------------------------------------

    private void OnDrawGizmosSelected() {

        if (drawDebugHitRadius) {

            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(transform.position, projectileHitRadius);
        }
    }
}
