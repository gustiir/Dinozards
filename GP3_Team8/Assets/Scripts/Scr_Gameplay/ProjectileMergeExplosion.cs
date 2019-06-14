using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectileMergeExplosion : MonoBehaviour {

    #region Fields

    [SerializeField]
    private float explosionRadius = 2;

    [SerializeField]
    private float minAmountOfKnockback = 4;

    [SerializeField]
    private float maxAmountOfKnockback = 6;

    [SerializeField]
    private float knockbackY = 0;

    [SerializeField]
    private float minAmountOfDamage = 10;

    [SerializeField]
    private float maxAmountOfDamage = 20;

    [SerializeField]
    private GameObject projectileMergedExplosionVFX;
    
    [SerializeField]
    private LayerMask layerToPlayers;

    private ParticleSystem partSystem;

    #endregion Fields

    void Start() {
        
        RaycastHit[] projectileMergeExplosionsphereCastHits = new RaycastHit[0];

        // Sphere Casts and loops through for players, if it then calls PlayerHit on then that knocks them back and deal damage. 
        projectileMergeExplosionsphereCastHits = Physics.SphereCastAll(transform.position, explosionRadius, gameObject.transform.forward, explosionRadius, layerToPlayers);
        
        foreach (RaycastHit explosionHits in projectileMergeExplosionsphereCastHits) {

            if (explosionHits.transform.gameObject.tag == "Player") {

                // Gets distance and sets more knockback and damage the closer you are the centre of the explosion
                float distance = Vector3.Distance(transform.position, explosionHits.transform.position);
                float knockbackToApply = Mathf.Lerp(maxAmountOfKnockback, minAmountOfKnockback, distance);
                float damageToApply = Mathf.Lerp(maxAmountOfDamage, minAmountOfDamage, distance);

                Vector3 dirFromExplosionToPlayer = (explosionHits.transform.position - transform.position).normalized;

                explosionHits.collider.gameObject.GetComponent<PlayerHit>().OnPlayerHit( new Vector3 (dirFromExplosionToPlayer.x, knockbackY, dirFromExplosionToPlayer.z) , knockbackToApply, damageToApply, 0, 0, PlayerHit.HitBy.FireBallMerge);
            }
        }

        // Destroys Object when Particle under it is finished
        partSystem = projectileMergedExplosionVFX.GetComponent<ParticleSystem>();
        float totalDuration = partSystem.main.duration;
        AudioManager.instance.PlayWithRandomPitch("FireballBigExplosion_01");
        Destroy(this.gameObject, totalDuration);
    }

    //--------------------------------------------------
    
    private void OnDrawGizmosSelected() {

        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(gameObject.transform.position, explosionRadius);
    }
}
