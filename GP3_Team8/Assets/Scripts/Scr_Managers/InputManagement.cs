using UnityEngine;

public class InputManagement : MonoBehaviour
{
    #region Fields

    [Tooltip("")] public string playerTag = "Player";

    #endregion Fields

    void Start()
    {
        FindPlayers();
    }
    void FindPlayers()
    {
        GameObject[] playerArray = GameObject.FindGameObjectsWithTag(playerTag);

        for (int i = 0; i < playerArray.Length; i++)
        {
            PlayerInput playerInput = playerArray[i].GetComponent<PlayerInput>();
            playerInput.SetPlayerIndex(i);

        }
    }
}
