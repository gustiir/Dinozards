using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameOver : MonoBehaviour
{
    public float gameRestartTimer;
    private float currentGameRestartTimer;

    public Text gameRestartCounterText;

    private void Start()
    {
        ResetCounter();
    }

    public void ResetCounter()
    {
        currentGameRestartTimer = gameRestartTimer;
    }

    private void Update()
    {
         GameRestartCounter();
    }

    void GameRestartCounter()
    {
        currentGameRestartTimer -= Time.deltaTime;
        if (currentGameRestartTimer < 0)
        {
            GameManager.managerInstance.RestartGame();
        }
        else
        {
            gameRestartCounterText.text = "The match will start in " + currentGameRestartTimer.ToString("0");
        }


    }
}
