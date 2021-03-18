using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpawner : MonoBehaviour
{
    public GameObject Enemy;
    public float SpawnRate;
    public float SpawnTimer;
    UIManager UIManager;
    // Start is called before the first frame update
    void Start()
    {
        SpawnRate = 3;
        SpawnEnemy();
        UIManager = FindObjectOfType<UIManager>();
    }

    // Update is called once per frame
    void Update()
    {
        SpawnTimer += Time.deltaTime;
        if(SpawnTimer>SpawnRate)
        {
            SpawnEnemy();
            SpawnTimer = 0;
        }
        SetTimer();
    }

    public void SpawnEnemy()
    {
        Vector3 EnemySpawn = new Vector3(0, Random.Range(-4.5f, 4.5f), 0);
        Instantiate(Enemy.gameObject, EnemySpawn + transform.TransformPoint(0, 0, 0), gameObject.transform.rotation);
    }

    public void SetTimer()
    {
        if(UIManager.Intensity==1)
        {
            SpawnRate = 3;
        }
        else if(UIManager.Intensity ==2)
        {
            SpawnRate = 2.25f;
        }
        else if(UIManager.Intensity ==3)
        {
            SpawnRate = 1.5f;
        }
    }
}
