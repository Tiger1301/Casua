using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class UIManager : MonoBehaviour
{
    public Text Score;
    public int Points;
    public static int PointsToMaintain;
    public int KillCount;
    public int Intensity;
    public int Lifes = 3;
    public Text RemainingLifes;
    // Start is called before the first frame update
    void Start()
    {
        KillCount = 0;
        Lifes = 3;
    }

    // Update is called once per frame
    void Update()
    {
        Score.text = Points.ToString();
        RemainingLifes.text = Lifes.ToString();
        PointsToMaintain = Points;
        SetIntensity();
        if(Lifes==0)
        {
            SceneManager.LoadScene(2);
        }
    }

    public void SetIntensity()
    {
        if(KillCount<15)
        {
            Intensity = 1;
        }
        else if(KillCount>15&&KillCount<25)
        {
            Intensity = 2;
        }
        else if(KillCount>25)
        {
            Intensity = 3;
        }
    }
}
