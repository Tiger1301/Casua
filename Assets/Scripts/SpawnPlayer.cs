using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnPlayer : MonoBehaviour
{
    public GameObject[] Spaceships;
    // Start is called before the first frame update
    void Start()
    {
        SpawnShip();
    }

    void SpawnShip()
    {
        Vector3 PlayerPosition = new Vector3(0, 0, 0);
        for (int i = 0; i < PersistentScript.Ship; i++)
        {
            if(i==PersistentScript.Ship)
            {
                Instantiate(Spaceships[i].gameObject, PlayerPosition, gameObject.transform.rotation);
            }
        }
    }
}
