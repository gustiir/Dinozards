using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

public class ProjectileAbility : MonoBehaviour, IAbility {

    #region Fields

    public int manaCost = 1;

    [SerializeField]
    private float fireBallDamage = 15f;

    [SerializeField]
    private float fireBallKnockback = 3f;

    [SerializeField]
    private float fireBallSpeed = 10f;

    [SerializeField]
    private float fireBallStartingTurnSpeed = 5f;

    [SerializeField]
    private float fireBallTargetTurnSpeed = .3f;

    [SerializeField]
    private float timeToLerpFromStartingToTargetTurnSpeed = 1f;

    [SerializeField]
    private GameObject projectileToSpawe;

    [SerializeField]
    private float lengthInFrontOfPlayerProjectileShouldSpawn = .75f;

    public List<GameObject> spawnedProjectiles;

    [SerializeField]
    private GameObject projectileSpawnVFX;

    [SerializeField]
    private float delayAfterPressingShootAndProjectileGetsShoot = .025f;

    [SerializeField]
    private float delayAfterShootingProjectileAndGoingBackToNormal = 0.15f;
    
    private GameObject player;

    private PlayerStates playerState;

    #endregion Fields


    void Start() {

        player = transform.root.gameObject; // Player Ref

        playerState = this.GetComponentInParent<PlayerStates>(); // State Ref

        Assert.IsNotNull(player, "PlayerState was not found."); 
    }
    
    //-------------------------------

    IEnumerator ShootProjecilet() {

        // Delay when pressing Shoot and being in the state where the animation is playing, to when the actual shoot is being spawned
        yield return new WaitForSeconds(delayAfterPressingShootAndProjectileGetsShoot);

        // Checks if still in the IsShooting state after the delay incase player has gotten hit or something
        if (playerState.IsState(PlayerStates.PossibleStates.IsShooting)) {

            Vector3 projectileSpawnLocation = (player.transform.position + player.transform.forward * lengthInFrontOfPlayerProjectileShouldSpawn);

            GameObject spawnedProjectile = Instantiate(projectileToSpawe, projectileSpawnLocation, player.gameObject.transform.rotation) as GameObject;

            spawnedProjectiles.Add(spawnedProjectile);

            spawnedProjectile.GetComponent<Projectile>().currentProjectileDamage = fireBallDamage;
            spawnedProjectile.GetComponent<Projectile>().minimumKnockback = fireBallKnockback;
            spawnedProjectile.GetComponent<Projectile>().minimumSpeed = fireBallSpeed;
            spawnedProjectile.GetComponent<Projectile>().startingTurnSpeed = fireBallStartingTurnSpeed;
            spawnedProjectile.GetComponent<Projectile>().targetTurnSpeed = fireBallTargetTurnSpeed;
            spawnedProjectile.GetComponent<Projectile>().timeToLerpFromStartingToTargetTurnSpeed = timeToLerpFromStartingToTargetTurnSpeed;

            GameObject spawnedProjectileVFX = Instantiate(projectileSpawnVFX, projectileSpawnLocation, player.transform.rotation) as GameObject;
            
            spawnedProjectile.GetComponent<Projectile>().owner = player;
        }

        // Delay after shooting and going back to normal
        yield return new WaitForSeconds(delayAfterShootingProjectileAndGoingBackToNormal);

        if (playerState.IsState(PlayerStates.PossibleStates.IsShooting))
            playerState.SetStateTo(PlayerStates.PossibleStates.IsNormal);

        yield return null;
    }

    //-----------------------------------

    public int ManaCost() {
        return manaCost;
    }

    //-----------------------------------

    public bool CanActivate() {
        
        if (playerState.IsState(PlayerStates.PossibleStates.IsNormal) || playerState.IsState(PlayerStates.PossibleStates.IsDashing)) {

            playerState.SetStateTo(PlayerStates.PossibleStates.IsShooting);

            return true;
        }
        else
            return false;
    }

    //-----------------------------------

    public int OnActivate(GameObject instigator) {

        StartCoroutine (ShootProjecilet());
        return manaCost;
    }
}
