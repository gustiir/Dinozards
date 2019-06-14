using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GamePlayUI : MonoBehaviour
{

    #region Fields
    public GamePlayHandler gamePlayHandler;

    [Header("Pre-Game")]
    public GameObject preCounterPanel;
    public Text preGameCounterText;

    [Header("Round Over Screen")]
    public GameObject nextRoundPanel;
    public Text p1Score;
    public Text p2Score;
    public Text p3Score;
    public Text p4Score;
    public Text nextRoundTimer;

    [Header("Game Over Screen")]
    public GameObject gameOverPanel;
    public Text winner;
    public float timeToShowEndScreen = 3f;

    private bool preGameTimerStarted = false;
    private bool nextRoundTimerStarted = false;
    private float uiPreGameCounter;
    private float uiNextGameCounter;

    [Header("Wizard Warnings")]
    public GameObject wizardWarning;
    public Image wizardArt;
    public List<Sprite> wizardWarnings;

    private int warningsListIndex;
    private int preGameCounterIndex;
    private float soundCounterTimer = 0.9f;
    private bool matchStarted;

    #endregion Fields

    public void StartPreGame() //Set Countdown condition true
    {
        uiPreGameCounter = gamePlayHandler.preGameCounter;
        preCounterPanel.SetActive(true);
        preGameTimerStarted = true;
        AudioManager.instance.Play("GameStart_01");
    }

    public void StartRoundOver()
    {
        uiNextGameCounter = gamePlayHandler.nextGameCounter;
        p1Score.text = gamePlayHandler.playerOneScore.ToString("0");
        p2Score.text = gamePlayHandler.playerTwoScore.ToString("0");
        p3Score.text = gamePlayHandler.playerThreeScore.ToString("0");
        p4Score.text = gamePlayHandler.playerFourScore.ToString("0");
        nextRoundPanel.SetActive(true);
        nextRoundTimerStarted = true;       //Start Timer
    }

    public void StartGameOver(int winnerPlayer)
    {
        winner.text = winnerPlayer.ToString("0");
        Invoke("ShowEndScreen", timeToShowEndScreen);
    }

    private void ShowEndScreen()
    {
        gameOverPanel.SetActive(true);
        GetComponent<GamePlayHandler>().DeactivateAllPlayers();
    }

    private void Update()
    {
        PreGameTimer();
        NextRoundTimer();
    }

    private void PreGameTimer()  //Game Countdown + Start Game
    {

        if (preGameTimerStarted)
        {
            uiPreGameCounter -= Time.deltaTime;
            if (uiPreGameCounter < 0)
            {
                preGameTimerStarted = false;
                preCounterPanel.SetActive(false);
                gamePlayHandler.StartRound();
                matchStarted = true;
                AudioManager.instance.Play("CountdownOver_01");
            }
        }

        soundCounterTimer -= Time.deltaTime;
        if (soundCounterTimer < 0)
        {
            if (!matchStarted)
            {
                preGameCounterText.text = (uiPreGameCounter).ToString("0");
                AudioManager.instance.Play("Countdown_01");
                soundCounterTimer = 1f;
            }
        }
    }

    private void NextRoundTimer()
    {
        if (nextRoundTimerStarted)
        {
            uiNextGameCounter -= Time.deltaTime;
            nextRoundTimer.text = (uiNextGameCounter).ToString("0");
            if (uiNextGameCounter < 0)
            {
                nextRoundTimerStarted = false;
                nextRoundPanel.SetActive(false);
                gamePlayHandler.StartRound();
            }
        }
    }

    public void ShowWizardWarning()
    {

        wizardArt.sprite = wizardWarnings[warningsListIndex];
        warningsListIndex++;
        wizardWarning.SetActive(true);
        GetComponent<Animator>().Play(0);
        Debug.Log("WizardHere");
    }

    public void DeactivateWizard()
    {
        wizardWarning.SetActive(false);
    }

}
