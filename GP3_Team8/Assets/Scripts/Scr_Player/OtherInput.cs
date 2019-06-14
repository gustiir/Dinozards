using UnityEngine;
using XInputDotNetPure;


public class OtherInput : MonoBehaviour
{
    #region Fields   
    [System.NonSerialized] public GamePadState state;
    [System.NonSerialized] public GamePadState prevState;
    public GameManager gameManager;

    GameManager.eGameState gameState;

    public PlayerIndex playerIndex;


    #endregion Fields


    private void Update()
    {
        prevState = state;
        state = GamePad.GetState(playerIndex);

        switch (GameManager.managerInstance.gameState)
        {
            case GameManager.eGameState.CINEMATIC: //Press Start to go to next scene
                if (IsButtonDown(state.Buttons.Start, prevState.Buttons.Start))
                {
                    gameManager.LoadScene(1);
                }
                break;
            case GameManager.eGameState.START: //Press Start to go to next scene
                if (IsButtonDown(state.Buttons.Start, prevState.Buttons.Start))
                {
                    gameManager.LoadScene(2);
                }
                break;

            case GameManager.eGameState.SELECT:
                if (IsButtonDown(state.Buttons.A, prevState.Buttons.A))
                {
                    gameManager.PlayerJoin(playerIndex);
                }

                if (IsButtonDown(state.Buttons.B, prevState.Buttons.B))
                {
                    gameManager.PlayerLeave(playerIndex);
                }
                if (IsButtonDown(state.Buttons.Start, prevState.Buttons.Start))
                {
                    gameManager.PlayerStartMatch(playerIndex);
                }
                if (IsButtonDown(state.Buttons.Guide, prevState.Buttons.Guide))
                {
                    gameManager.PlayerLeave(playerIndex);
                }
                break;

            case GameManager.eGameState.ROUNDOVER:
                if (IsButtonDown(state.Buttons.A, prevState.Buttons.A))
                {
                    //Continue to next round ??do we want 2 players to ok this??
                }
                break;

            case GameManager.eGameState.GAMEOVER:
                if (IsButtonDown(state.Buttons.A, prevState.Buttons.A))
                {
                    //Continue to next round we want 2 players to ok this?

                }
                if (IsButtonDown(state.Buttons.B, prevState.Buttons.B))
                {
                    //Disable The Player
                }


                break;
        }
    }

    private bool IsButtonDown(ButtonState button, ButtonState previousState)
    {
        return previousState == ButtonState.Released && button == ButtonState.Pressed;
    }
}
