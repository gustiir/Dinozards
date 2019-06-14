using UnityEngine;
using UnityEngine.UI;

public class ChargeManager : MonoBehaviour
{

    [Range(0,5)]
    public int maxCharges = 5;
    public int currentCharges;
    private float elapsedTime;
    public float timeToRecharge = 30f;

    [Header("Charge Bar UI"), Tooltip("Drag the character Charge Bar UI object here.")]
    public Image chargeBar;
    public GameObject chargeSpark_01;
    public GameObject chargeSpark_02;
    public GameObject chargeSpark_03;
    public GameObject reverseSpark_01;
    public GameObject reverseSpark_02;
    public GameObject reverseSpark_03;



    //Properties


    public int CurrentCharges
    {
        get
        {
            return currentCharges;
        }
        set
        {
            if (value < currentCharges)
            {
                PlayParticles();
            }
            if (value > currentCharges)
            {
                Invoke("PlayReverseParticle", 0.8f);
            }
            currentCharges = value;
            UpdateChargeBar();
        }
    }


    //Methods


    void Start()
    {
        currentCharges = maxCharges;
    }

    void Update()
    {
        if(currentCharges < maxCharges)
        {
            elapsedTime += Time.deltaTime;
            if (elapsedTime >= timeToRecharge )
            {
                elapsedTime = 0f;
                CurrentCharges++;
            }
        }
    }

    void UpdateChargeBar()
    {
        chargeBar.fillAmount = (float)currentCharges / (float)maxCharges;
    }
    void PlayParticles()
    {
        if (currentCharges == 1)
        {
            chargeSpark_03.SetActive(true);
        }
        else if (currentCharges == 2)
        {
            chargeSpark_02.SetActive(true);
        }
        else if (currentCharges == 3)
        {
            chargeSpark_01.SetActive(true);
        }
    }

    void PlayReverseParticle()
    {
        if (currentCharges == 0)
        {
            reverseSpark_03.SetActive(true);
        }
        else if (currentCharges == 1)
        {
            reverseSpark_02.SetActive(true);
        }
        else if (currentCharges == 2)
        {
            reverseSpark_01.SetActive(true);
        }
    }
}



