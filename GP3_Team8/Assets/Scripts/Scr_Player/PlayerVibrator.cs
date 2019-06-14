using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XInputDotNetPure;


public class PlayerVibrator : MonoBehaviour
{
    public PlayerIndex playerIndex;
    public float VibA;
    public float VibB;
    public float vibrationTime = 3f;
    private float elapsedTime;
   
    public void Vibrator()
    {
        GamePad.SetVibration(playerIndex, VibA, VibB);

        elapsedTime += Time.deltaTime;
        if (elapsedTime >= vibrationTime)
        {
            GamePad.SetVibration(playerIndex, 0f, 0f);
        }
    }

    private void OnDisable()
    {

        GamePad.SetVibration(playerIndex, 0f, 0f);
    }
}
