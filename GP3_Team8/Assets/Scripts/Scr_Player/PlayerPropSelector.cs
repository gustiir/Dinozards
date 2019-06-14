using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XInputDotNetPure;

public class PlayerPropSelector : MonoBehaviour
{
    public GameObject p1Prop;
    public GameObject p2Prop;
    public GameObject p3Prop;
    public GameObject p4Prop;

    private PlayerInput playerInput;

    private void Start()
    {
        playerInput = GetComponentInParent<PlayerInput>();

        if (playerInput.playerIndex == PlayerIndex.One)
        {
            p1Prop.SetActive(true);
        }
        else if (playerInput.playerIndex == PlayerIndex.Two)
        {
            p2Prop.SetActive(true);
        }
        else if (playerInput.playerIndex == PlayerIndex.Three)
        {
            p3Prop.SetActive(true);
        }
        else if (playerInput.playerIndex == PlayerIndex.Four)
        {
            p4Prop.SetActive(true);
        }
    }
}
