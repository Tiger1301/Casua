using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PersistentScript : MonoBehaviour
{
    public static int HighScore;
    public static int Ship;
    // Start is called before the first frame update
    void Awake()
    {
        HighScore = PlayerPrefs.GetInt("HighScore");
        Ship = PlayerPrefs.GetInt("Ship");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
