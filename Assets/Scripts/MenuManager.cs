using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class MenuManager : MonoBehaviour
{
    public Text Score;
    public GameObject MainPanel;
    public GameObject SelectionPanel;
    // Start is called before the first frame update
    void Start()
    {
        Score.text = PersistentScript.HighScore.ToString();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Play()
    {
        SceneManager.LoadScene(1);
    }
    public void Close()
    {
        Application.Quit();
    }
    public void GoToSelection()
    {
        MainPanel.SetActive(false);
        SelectionPanel.SetActive(true);
    }
    public void BackToMenu()
    {
        SelectionPanel.SetActive(false);
        MainPanel.SetActive(true);
    }
}
