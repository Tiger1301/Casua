using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class GameOver : MonoBehaviour
{
    public Text LastScore;
    public Text Record;
    // Start is called before the first frame update
    void Start()
    {
        if (UIManager.PointsToMaintain > PersistentScript.HighScore)
        {
            LastScore.text = "New record: " + UIManager.PointsToMaintain.ToString();
            Record.text = "Previous record: " + PersistentScript.HighScore.ToString();
        }
        else
        {
            LastScore.text = UIManager.PointsToMaintain.ToString();
            Record.text = "Previous record: " + PersistentScript.HighScore.ToString();
        }
        FindObjectOfType<AudioManager>().Play("GameOver");
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void GoToGame()
    {
        if (UIManager.PointsToMaintain > PersistentScript.HighScore)
        {
            PersistentScript.HighScore = UIManager.PointsToMaintain;
            PlayerPrefs.SetInt("HighScore", PersistentScript.HighScore);
        }
        SceneManager.LoadScene(1);
    }

    public void CloseGame()
    {
        if (UIManager.PointsToMaintain > PersistentScript.HighScore)
        {
            PersistentScript.HighScore = UIManager.PointsToMaintain;
            PlayerPrefs.SetInt("HighScore", PersistentScript.HighScore);
        }
        Application.Quit();
    }

    public void BackToMenu()
    {
        if (UIManager.PointsToMaintain > PersistentScript.HighScore)
        {
            PersistentScript.HighScore = UIManager.PointsToMaintain;
            PlayerPrefs.SetInt("HighScore", PersistentScript.HighScore);
        }
        SceneManager.LoadScene(0);
    }
}
