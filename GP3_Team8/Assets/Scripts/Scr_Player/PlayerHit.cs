using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XInputDotNetPure;

public class PlayerHit : MonoBehaviour {
    #region Fields

    public enum HitBy { FireBall, FireBallMerge, Dash, Reflect, Storm, Lava, Tick};

    GamePadState state;
    public PlayerIndex playerIndex;
    public float vibrationTime = 0.5f;

    public delegate void PlayerDamaged(int index, float amount);
    public static event PlayerDamaged playerDamageInfo;

    private MultipleTargetCamera cameraShake;
    private MultipleTargetCamera camera;

    HPManager playerHp;
    PlayerStates states;
    Rigidbody rigidbody;

    Vector3 direction;

    //Knockback
    public float forceAmount;
    private float knockbackMultiplier;

    //Vibration
    public float VibA;
    public float VibB;

    

    public float delayBeforeReturningToNormalStateAfterHit = 0.5f;

    private bool isVibrating = false;

    //tick damage
    private float tickDamageTimer = 0.5f;
    public float tickDamageRate = 1;

    private bool tickDamageIsEnabled = false;
    private float tickDamage = 0;

    private float dashLightningTickDamageDivider = 3;
    private float dashLightningTickIntervalls = .5f;

    public List<string> hitAudioNames;

    #endregion Fields

    void Start()
    {
        playerHp = GetComponent<HPManager>();
        rigidbody = GetComponent<Rigidbody>();
        states = GetComponent<PlayerStates>();

        camera = GameObject.FindWithTag("Camera").GetComponent<MultipleTargetCamera>();
    }

    private void OnDisable() {

        GamePad.SetVibration(playerIndex, 0f, 0f);
    }

    public IEnumerator WaitToDisableVibrations() {

        isVibrating = true;
        GamePad.SetVibration(playerIndex, VibA, VibB);
        yield return new WaitForSecondsRealtime(vibrationTime);
        GamePad.SetVibration(playerIndex, 0f, 0f);
        isVibrating = false;
    }
    private void Update()
    {
        if (tickDamageIsEnabled)
        {
            TickDamage();
        }
    }

    void FixedUpdate()
    {

    }
    void TickDamage()
    {
        if (tickDamageTimer <= 0.0f)
        {
            OnPlayerHit(Vector3.zero, 1.0f, tickDamage, 0, 0, PlayerHit.HitBy.Storm);
            tickDamageTimer = tickDamageRate;
        }
        else
        {
            tickDamageTimer -= Time.deltaTime;
        }
    }
    public void EnableTickDamage(float damageAmount)
    {
        tickDamage = damageAmount;
        tickDamageIsEnabled = true;
    }
    public void DisableTickDamage()
    {
        tickDamageIsEnabled = false;
        //tickDamageTimer = 0.5f;
    }
    //---------------------------------------------

    // Called by an ability when it hits the player. 
    public void OnPlayerHit(Vector3 hitDirection, float multiplier, float damage, float cameraShakeDuration, float cameraShakeIntensity, HitBy hitBy) {
        
        playerHp.DecreaseHP(damage);
        int pIndex = (int) playerIndex; 
        playerDamageInfo(pIndex, damage);

        int listIndex = Random.Range(0, hitAudioNames.Count);
        AudioManager.instance.PlayWithRandomPitch(hitAudioNames[listIndex]);

        if (!isVibrating) {

            if (this.gameObject.activeInHierarchy) //To prevent it ffrom being called after players "die"
            {
                StartCoroutine(WaitToDisableVibrations());
            }
            
        }

        if (hitBy != HitBy.Storm || hitBy != HitBy.Tick) {

            direction = hitDirection;
            knockbackMultiplier = multiplier;

            camera.ShakeCamera(cameraShakeDuration, cameraShakeIntensity);
            ApplyKnockback(direction, forceAmount, multiplier);

            states.SetStateTo(PlayerStates.PossibleStates.GotHit);
            StartCoroutine(RestoredFromHit());
        }
        
        if (hitBy == HitBy.Dash) 
            StartCoroutine(LightningDamageTick(damage));

    }

    IEnumerator LightningDamageTick(float damage) {

        float tickDamage = damage / dashLightningTickDamageDivider;

        yield return new WaitForSeconds(dashLightningTickIntervalls);

        OnPlayerHit(new Vector3(0,0,0), 0, tickDamage, 0, 0, HitBy.Tick);

        yield return new WaitForSeconds(dashLightningTickIntervalls);

        OnPlayerHit(new Vector3(0, 0, 0), 0, tickDamage, 0, 0, HitBy.Tick);
        
        yield return null;
    }
        
    
    //---------------------------------------------

    void ApplyKnockback(Vector3 direction, float force, float multiplier)
    {
        
        direction.Normalize();

        rigidbody.AddForce(direction * force * multiplier);
    }

    IEnumerator RestoredFromHit()
    {

        yield return new WaitForSeconds(delayBeforeReturningToNormalStateAfterHit);

        states.SetStateTo(PlayerStates.PossibleStates.IsNormal);

        yield return null;
    }
}
