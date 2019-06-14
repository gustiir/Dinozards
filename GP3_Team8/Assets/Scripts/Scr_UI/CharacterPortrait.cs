using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XInputDotNetPure;
using UnityEngine.UI;

public class CharacterPortrait : MonoBehaviour
{
    public PlayerIndex playerIndex;
    private GameManager gameManager;
    public bool isJoined;

    public Image prefabPortraitImage;

    public Sprite playerOneOffPortrait;
    public Sprite playerTwoOffPortrait;
    public Sprite playerThreeOffPortrait;
    public Sprite playerFourOffPortrait;

    public Sprite playerOnePortrait;
    public Sprite playerTwoPortrait;
    public Sprite playerThreePortrait;
    public Sprite playerFourPortrait;

    public GameObject join;
    public GameObject leave;



    private void Start()
    {

        if (playerIndex == PlayerIndex.One)
        {
            prefabPortraitImage.sprite = playerOneOffPortrait;
        }
        else if (playerIndex == PlayerIndex.Two)
        {
            prefabPortraitImage.sprite = playerTwoOffPortrait;
        }
        else if (playerIndex == PlayerIndex.Three)
        {
            prefabPortraitImage.sprite = playerThreeOffPortrait;
        }
        else if (playerIndex == PlayerIndex.Four)
        {
            prefabPortraitImage.sprite = playerFourOffPortrait;
        }
    }

    private void Update()
    {
        //gameManager = GameManager.managerInstance;
        //if (playerIndex == PlayerIndex.One)
        //{
        //    isJoined = gameManager.p1Active;
        //}
        //else if (playerIndex == PlayerIndex.Two)
        //{
        //    isJoined = gameManager.p2Active;
        //}
        //else if (playerIndex == PlayerIndex.Three)
        //{
        //    isJoined = gameManager.p3Active;
        //}
        //else if (playerIndex == PlayerIndex.Four)
        //{
        //    isJoined = gameManager.p4Active;
        //}
        //PlayerActive();
    }

    public void PlayerActive()
    {

        join.SetActive(false);
        leave.SetActive(true);

        if (playerIndex == PlayerIndex.One)
        {
            prefabPortraitImage.sprite = playerOnePortrait;
        }
        else if (playerIndex == PlayerIndex.Two)
        {
            prefabPortraitImage.sprite = playerTwoPortrait;
        }
        else if (playerIndex == PlayerIndex.Three)
        {
            prefabPortraitImage.sprite = playerThreePortrait;
        }
        else if (playerIndex == PlayerIndex.Four)
        {
            prefabPortraitImage.sprite = playerFourPortrait;
        }

    }

    public void PlayerDeactivate()
    {
        join.SetActive(true);
        leave.SetActive(false);

        if (playerIndex == PlayerIndex.One)
        {
            prefabPortraitImage.sprite = playerOneOffPortrait;
        }
        else if (playerIndex == PlayerIndex.Two)
        {
            prefabPortraitImage.sprite = playerTwoOffPortrait;
        }
        else if (playerIndex == PlayerIndex.Three)
        {
            prefabPortraitImage.sprite = playerThreeOffPortrait;
        }
        else if (playerIndex == PlayerIndex.Four)
        {
            prefabPortraitImage.sprite = playerFourOffPortrait;
        }

    }


}
