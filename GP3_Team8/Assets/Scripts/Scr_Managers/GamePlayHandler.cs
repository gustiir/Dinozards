using System.Collections.Generic;
using System.Collections;
using UnityEngine.SceneManagement;
using UnityEngine;

public class GamePlayHandler : MonoBehaviour
{

    #region Fields

    public GameObject player1Prefab;
    public GameObject player2Prefab;
    public GameObject player3Prefab;
    public GameObject player4Prefab;
    public int preGameCounter = 3;
    public int nextGameCounter = 5;
    public GamePlayUI gamePlayUI;
    public float time = 1f;
    [HideInInspector]
    public LavaGround lavaGround;

    #endregion Fields

    #region Variables
    [HideInInspector]
    public List<GameObject> playerCharacters = new List<GameObject>();
    [HideInInspector]
    public List<Transform> playersTransform = new List<Transform>();
    private int numberOfRounds;
    private int currentRound;
    private bool isGameStarted;
    private bool isGameOver;
    private bool isRestartingGame;
    //private int sessionPlayers;
    private int activePlayers;
    //private SpawnCamera myCameraControl;
    [HideInInspector]
    public int playerOneScore;
    [HideInInspector]
    public int playerTwoScore;
    [HideInInspector]
    public int playerThreeScore;
    [HideInInspector]
    public int playerFourScore;
    [HideInInspector]
    private StormBehavior storm;
    private Vector3 p1Position;
    private Vector3 p2Position;
    private Vector3 p3Position;
    private Vector3 p4Position;
    private Quaternion p1Rotation;
    private Quaternion p2Rotation;
    private Quaternion p3Rotation;
    private Quaternion p4Rotation;
    private MultipleTargetCamera newCamera;

    public float player1Damage = 0f;
    public float player2Damage = 0f;
    public float player3Damage = 0f;
    public float player4Damage = 0f;

    #endregion Variables

    #region Awake
    public void AwakeLevel(GameManager currentGameManager)
    {
        InitializeVariables();
        storm = FindObjectOfType<StormBehavior>();
        newCamera = FindObjectOfType<MultipleTargetCamera>();
        GetPlayersInitialLocation();
    }

    private void InitializeVariables()
    {
        numberOfRounds = GameManager.managerInstance.maxNumberOfRounds;
        isGameOver = false;
        isGameStarted = false;
    }

    #endregion Awake

    #region Start
    private void Start()
    {
        DeactivateAllPlayers();
        gamePlayUI.StartPreGame();  //Triggers StartRound() + Trigger UI Panel check GamePlayUI.cs for more details --- 
        PlayerHit.playerDamageInfo += PlayerDamagedHandle;
    }

    void PlayerDamagedHandle(int index, float amount)
    {
        switch (index)
        {
            case 1:
                player1Damage += amount;
                break;
            case 2:
                player2Damage += amount;
                break;
            case 3:
                player3Damage += amount;
                break;
            case 4:
                player4Damage += amount;
                break;

            default:
                break;
        }
    }

    public void StartRound()
    {

        if (GameManager.managerInstance.p1Active)
        {
            player1Prefab.SetActive(true);
        }

        if (GameManager.managerInstance.p2Active)
        {
            player2Prefab.SetActive(true);
        }

        if (GameManager.managerInstance.p3Active)
        {
            player3Prefab.SetActive(true);
        }

        if (GameManager.managerInstance.p4Active)
        {
            player4Prefab.SetActive(true);
        }
        SetPlayersInitialLocation();
        newCamera.StartCamera();
        GetPlayersInSession();
        currentRound++;
            if (currentRound > 1)
            {
                storm.RestartStorm();
            }
        isGameStarted = true;
    }

    private void GetPlayersInSession()
    {
        activePlayers = 0;
        playerCharacters.Clear();
        foreach (var item in GameObject.FindGameObjectsWithTag("Player"))
        {
            playerCharacters.Add(item);
            playersTransform.Add(item.transform);
            activePlayers++;
            //sessionPlayers++;
        }
    }

    #endregion Start       

    private void Update()
    {
        if (isGameStarted && activePlayers <= 1)
        {
            isGameStarted = false;
            EndRound();
        }
    }

    private void EndRound()
    {
        isGameStarted = false;

        if (playerCharacters.Count == 0)
        {
            //TODO DRAW
            Debug.Log("DRAW");
        }

        else if (playerCharacters[0].GetComponent<PlayerInput>().playerIndex.ToString() == "One")
        {
            playerOneScore++;
        }
        else if(playerCharacters[0].GetComponent<PlayerInput>().playerIndex.ToString() == "Two")
        {
            playerTwoScore++;
        }
        else if(playerCharacters[0].GetComponent<PlayerInput>().playerIndex.ToString() == "Three")
        {
            playerThreeScore++;
        }
        else if (playerCharacters[0].GetComponent<PlayerInput>().playerIndex.ToString() == "Four")
        {
            playerFourScore++;
        }

        storm.StopStorm();
        CheckRoundEnd();
        //TODO Restart Round Condition
    }

    private void CheckRoundEnd()
    {
        if (playerOneScore >= GameManager.managerInstance.maxNumberOfRounds)
        {
            EndGame(1);
        }
        else if (playerTwoScore >= GameManager.managerInstance.maxNumberOfRounds)
        {
            EndGame(2);
        }
        else if (playerThreeScore >= GameManager.managerInstance.maxNumberOfRounds)
        {
            EndGame(3);
        }
        else if (playerFourScore >= GameManager.managerInstance.maxNumberOfRounds)
        {
            EndGame(4);
        }
        else
        {
            EndGame(0);    //TODO Draw Match
            DeactivateAllPlayers();
        }
    }

    private void EndGame(int winnerPlayer)
    {
        GameManager.managerInstance.FinishMatch();
        isGameOver = true;
        storm.StopStorm();
        gamePlayUI.StartGameOver(winnerPlayer);
    }

    public void PlayerKilled(GameObject killedPlayer)
    {
        activePlayers--;
        playerCharacters.Remove(killedPlayer);
        killedPlayer.SetActive(false);
        newCamera.RemovePlayer(killedPlayer);
    }

    public void DeactivateAllPlayers()
    {
        player1Prefab.SetActive(false);
        player2Prefab.SetActive(false);
        player3Prefab.SetActive(false);
        player4Prefab.SetActive(false);
    }

    private void GetPlayersInitialLocation()
    {
        p1Position = player1Prefab.transform.position;
        p2Position = player2Prefab.transform.position;
        p3Position = player3Prefab.transform.position;
        p4Position = player4Prefab.transform.position;
        p1Rotation = player1Prefab.transform.rotation;
        p2Rotation = player2Prefab.transform.rotation;
        p3Rotation = player3Prefab.transform.rotation;
        p4Rotation = player4Prefab.transform.rotation;
    }

    private void SetPlayersInitialLocation()
    {
        player1Prefab.transform.position = p1Position;
        player1Prefab.transform.rotation = p1Rotation;
        player2Prefab.transform.position = p2Position;
        player2Prefab.transform.rotation = p2Rotation;
        player3Prefab.transform.position = p3Position;
        player3Prefab.transform.rotation = p3Rotation;
        player4Prefab.transform.position = p4Position;
        player4Prefab.transform.rotation = p4Rotation;
    }
}
