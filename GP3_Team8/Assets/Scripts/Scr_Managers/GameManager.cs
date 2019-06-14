using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.SceneManagement;
using XInputDotNetPure;


public class GameManager : MonoBehaviour
{

    // Public
    public static GameManager managerInstance;
    #region Fields    
    public enum eGameState
    {
        CINEMATIC,
        START,
        SELECT,
        PLAYING,
        WAITING,
        DEAD,
        ROUNDOVER,
        GAMEOVER,
        NULL
    }

    public eGameState gameState;

    //[HideInInspector]
    public bool p1Active = true;
    //[HideInInspector]
    public bool p2Active = true;
    //[HideInInspector]
    public bool p3Active = true;
    //[HideInInspector]
    public bool p4Active = true;

    [Header("Character Selection Settings")]
    public float characterSelectionCountdownTimer = 5f;

    [Header("Match Settings")]
    public float roundCountdownTimer = 3f;
    public int maxNumberOfRounds = 3;

    [Header("Audio")]
    public List<string> playerJoinedAudioNames;


    //Private

    private int numberOfPlayersJoined;

    private CharacterSelectionTimer charSelectionTimer;
    private GamePlayHandler gamePlayHandler;

    private CharacterPortrait p1Portrait;
    private CharacterPortrait p2Portrait;
    private CharacterPortrait p3Portrait;
    private CharacterPortrait p4Portrait;

    #endregion Fields


    private void Awake()
    {

        DontDestroyOnLoad(gameObject);
        if (managerInstance == null)
        {
            managerInstance = this;
            OnLevelWasLoaded(SceneManager.GetActiveScene().buildIndex);
            return;
        }
        else
        {
            Destroy(gameObject);
        }

    }

    public void InitiateVariables()
    {
        p1Active = false;
        p2Active = false;
        p3Active = false;
        p4Active = false;
        numberOfPlayersJoined = 0;
    }

    #region Character Selection
    public void PlayerJoin(PlayerIndex playerIndex)
    {
        if (playerIndex == PlayerIndex.One)
        {
            if (!p1Active)
            {
                p1Active = true;
                CheckNumberOfPlayers(true);
                p1Portrait = GameObject.FindGameObjectWithTag("Player_01_Portrait").GetComponent<CharacterPortrait>();
                p1Portrait.PlayerActive();
                //Player is Ready Add visual animation
            }
            else
            {
                //Add visual animation
                return;
            }
        }

        else if (playerIndex == PlayerIndex.Two)
        {
            if (!p2Active)
            {
                p2Active = true;
                CheckNumberOfPlayers(true);
                p2Portrait = GameObject.FindGameObjectWithTag("Player_02_Portrait").GetComponent<CharacterPortrait>();
                p2Portrait.PlayerActive();
                //Player is Ready Add visual animation
            }
            else
            {
                //Add visual animation
                return;
            }
        }

        else if (playerIndex == PlayerIndex.Three)
        {
            if (!p3Active)
            {
                p3Active = true;
                CheckNumberOfPlayers(true);
                p3Portrait = GameObject.FindGameObjectWithTag("Player_03_Portrait").GetComponent<CharacterPortrait>();
                p3Portrait.PlayerActive();
                //Player is Ready Add visual animation
            }
            else
            {
                //Add visual animation
                return;
            }
        }

        else if (playerIndex == PlayerIndex.Four)
        {
            if (!p4Active)
            {
                p4Active = true;
                CheckNumberOfPlayers(true);
                p4Portrait = GameObject.FindGameObjectWithTag("Player_04_Portrait").GetComponent<CharacterPortrait>();
                p4Portrait.PlayerActive();
                //Player is Ready Add visual animation
            }
            else
            {
                //Add visual animation
                return;
            }
        }
    }

    public void PlayerLeave(PlayerIndex playerIndex)
    {
        if (numberOfPlayersJoined == 0)
        {
            LoadScene(1);
        }
        else if (playerIndex == PlayerIndex.One)
        {
            if (p1Active)
            {
                p1Active = false;
                CheckNumberOfPlayers(false);
                p1Portrait.PlayerDeactivate();
                //Player Left, add Visual update
            }
        }

        else if (playerIndex == PlayerIndex.Two)
        {
            if (p2Active)
            {
                p2Active = false;
                CheckNumberOfPlayers(false);
                p2Portrait.PlayerDeactivate();
                //Player is Ready Add visual animation
            }
        }

        else if (playerIndex == PlayerIndex.Three)
        {
            if (p3Active)
            {
                p3Active = false;
                CheckNumberOfPlayers(false);
                p3Portrait.PlayerDeactivate();
                //Player is Ready Add visual animation
            }
        }

        else if (playerIndex == PlayerIndex.Four)
        {
            if (p4Active)
            {
                p4Active = false;
                CheckNumberOfPlayers(false);
                p4Portrait.PlayerDeactivate();
                //Player is Ready Add visual animation
            }
        }

    }

    private void CheckNumberOfPlayers(bool isPlayerActive)
    {
        if (isPlayerActive)
        {
            numberOfPlayersJoined++;
            int listIndex = Random.Range(0, playerJoinedAudioNames.Count);
            AudioManager.instance.Play(playerJoinedAudioNames[listIndex]);
            AudioManager.instance.Play("PlayerJoined_01");
        }
        else
        {
            numberOfPlayersJoined--;
        }

        if (charSelectionTimer)
        {
            charSelectionTimer.CheckActivePlayers(numberOfPlayersJoined);
        }
        else
        {
            Debug.Log("charSelectionTimer is NULL");
        }
    }

    public void PlayerStartMatch(PlayerIndex playerIndex)
    {
        if (playerIndex == PlayerIndex.One)
        {
            if (p1Active)
            {
                StartMatch();
            }
            else
            {
                //TODO Add visual animation???
                return;
            }
        }

        else if (playerIndex == PlayerIndex.Two)
        {
            if (p2Active)
            {
                StartMatch();
            }
            else
            {
                //TODO Add visual animation???
                return;
            }
        }

        else if (playerIndex == PlayerIndex.Three)
        {
            if (p3Active)
            {
                StartMatch();
            }
            else
            {
                //TODO Add visual animation???
                return;
            }
        }

        else if (playerIndex == PlayerIndex.Four)
        {
            if (p4Active)
            {
                StartMatch();
            }
            else
            {
                //TODO Add visual animation???
                return;
            }
        }
    }

    public void StartMatch()
    {
        if (numberOfPlayersJoined >= 2)
        {
            AudioManager.instance.Play("PressStart_01");
            LoadScene(3);
        }
    }

    #endregion Character Selection

    #region GameOver

    public void FinishMatch()
    {
        AudioManager.instance.Stop("GamePlay_01");
        AudioManager.instance.Play("GameOver_01");
    }

    public void RestartGame()
    {
        LoadScene(2);
    }


    #endregion GameOver
    public void LoadScene(int sceneIndex)
    {
        SceneManager.LoadScene(sceneIndex);
    }

    private void OnLevelWasLoaded(int level)
    {
        if (level == 0)
        {
            gameState = eGameState.CINEMATIC;
        }
        else if (level == 1)
        {
            gameState = eGameState.START;
        }
        else if (level == 2)
        {
            gameState = eGameState.SELECT;
        }
        else if (level == 3)
        {
            gameState = eGameState.PLAYING;
        }
        OnGameStateSet();
        //Debug.Log(SceneManager.GetActiveScene().buildIndex);
    }

    public void OnGameStateSet()
    {
        switch (gameState)
        {
            case eGameState.CINEMATIC:
                InitiateVariables();
                //TODO Play Cinematic
                //TODO Add skip option
                break;
            case eGameState.START:
                InitiateVariables();
                break;
            case eGameState.SELECT:
                InitiateVariables();
                charSelectionTimer = FindObjectOfType<CharacterSelectionTimer>();
                charSelectionTimer.matchStartTimer = characterSelectionCountdownTimer;
                charSelectionTimer.ResetCounter();
                AudioManager.instance.Play("PressStart_01");
                break;
            case eGameState.PLAYING:
                gamePlayHandler = FindObjectOfType<GamePlayHandler>();
                gamePlayHandler.AwakeLevel(this);
                AudioManager.instance.Play("GamePlay_01");
                break;
            case eGameState.ROUNDOVER:
                break;
            case eGameState.GAMEOVER:

                break;
            case eGameState.NULL:
                break;
            default:
                break;
        }

    }
    public void QuitGame()
    {
        Application.Quit();
    }

}
