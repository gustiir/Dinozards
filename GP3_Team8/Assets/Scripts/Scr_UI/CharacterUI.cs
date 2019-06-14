using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using XInputDotNetPure;

public class CharacterUI : MonoBehaviour
{
    public Sprite p1Icon;
    public Sprite p2Icon;
    public Sprite p3Icon;
    public Sprite p4Icon;
    public Sprite p1EmptyBar;
    public Sprite p2EmptyBar;
    public Sprite p3EmptyBar;
    public Sprite p4EmptyBar;
    public Sprite p1FullBar;
    public Sprite p2FullBar;
    public Sprite p3FullBar;
    public Sprite p4FullBar;
    public Sprite energyBar;

    public Image icon;
    public Image energy;
    public Image fullBar;
    public Image emptyBar;

    private PlayerInput playerInput;

    private void Start()
    {
        playerInput = GetComponentInParent<PlayerInput>();
        energy.sprite = energyBar;

        if (playerInput.playerIndex == PlayerIndex.One)
        {
            icon.sprite = p1Icon;
            emptyBar.sprite = p1EmptyBar;
            fullBar.sprite = p1FullBar;
        }
        else if (playerInput.playerIndex == PlayerIndex.Two)
        {
            icon.sprite = p2Icon;
            emptyBar.sprite = p2EmptyBar;
            fullBar.sprite = p2FullBar;
        }
        else if (playerInput.playerIndex == PlayerIndex.Three)
        {
            icon.sprite = p3Icon;
            emptyBar.sprite = p3EmptyBar;
            fullBar.sprite = p3FullBar;
        }
        else if (playerInput.playerIndex == PlayerIndex.Four)
        {
            icon.sprite = p4Icon;
            emptyBar.sprite = p4EmptyBar;
            fullBar.sprite = p4FullBar;
        }
    }

}
