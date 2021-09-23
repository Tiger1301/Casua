using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnPlayer : MonoBehaviour
{
    public GameObject[] Spaceships;
    public Player player; 
    // Start is called before the first frame update
    void Start()
    {
        SpawnShip();
        player = FindObjectOfType<Player>();
    }

    void SpawnShip()
    {
        Vector3 PlayerPosition = new Vector3(-7, 0, 0);
        for (int i = 0; i < Spaceships.Length; i++)
        {
            if(i==PersistentScript.Ship)
            {
                Instantiate(Spaceships[i].gameObject, PlayerPosition, Quaternion.Euler(0, 90, -90));
            }
        }
    }

    public void ShootButton()
    {
        player.Shoot();
    }
}
