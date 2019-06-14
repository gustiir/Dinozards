using UnityEngine;
using UnityEngine.UI;

public class CharacterSelectionTimer : MonoBehaviour
{
    [HideInInspector]
    public float matchStartTimer;
    private float currentMatchStartTimer;
    private int numberOfActivePlayers = 0;

    public Text preMatchCounterText;
    public GameObject minimumPlayersRequiredText;
    public GameObject preCounterText;

    public void ResetCounter()
    {
        currentMatchStartTimer = matchStartTimer;
    }

    public void CheckActivePlayers(int numberOfPlayers)
    {
        numberOfActivePlayers = numberOfPlayers;
        ResetCounter();
        if (numberOfActivePlayers >= 2)
        {
            minimumPlayersRequiredText.SetActive(false);
            preCounterText.SetActive(true);
        }
        else
        {
            minimumPlayersRequiredText.SetActive(true);
            preCounterText.SetActive(false);
        }
    }

    private void Update()
    {
        if (numberOfActivePlayers >= 2)
        {
            PreMatchCounter();
        }
    }

    void PreMatchCounter()
    {
        currentMatchStartTimer -= Time.deltaTime;
        if (currentMatchStartTimer < 0)
        {
            GameManager.managerInstance.StartMatch();
        }
        else
        {
            preMatchCounterText.text = currentMatchStartTimer.ToString("0");
        }
            

    }
}
