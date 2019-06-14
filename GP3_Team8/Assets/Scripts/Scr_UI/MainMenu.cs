using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{

    public void StartGameButton()
    {
        SceneManager.LoadScene("CharacterSelection");

    }

    public void BeginButton()
    {
        SceneManager.LoadScene("Gameplay");
    }
    
    public void BackButton()
    {
        SceneManager.LoadScene("MainMenu");
    }



    public void OptionButton()
    {
        SceneManager.LoadScene("OptionScene");
    }

    public void CreditButton()
    {
        SceneManager.LoadScene("CreditScene");
    }

    public void QuitButton()
    {
        Application.Quit();
    }

}
