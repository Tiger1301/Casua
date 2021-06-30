using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpawner : MonoBehaviour
{
    public GameObject[] Enemy;
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
        Vector3 EnemySpawn = new Vector3(0, Random.Range(-3f, 3.5f), 0);
        int RandEnemy = Random.Range(0, 2);
        Vector3Int quaternion;

        if(RandEnemy==0)
        {
            quaternion = new Vector3Int(0, 90, -90);
        }
        else
        {
            quaternion = new Vector3Int(0, 0, 0);
        }

        Instantiate(Enemy[RandEnemy].gameObject, EnemySpawn + transform.TransformPoint(0, 0, 0), Quaternion.Euler(quaternion.x, quaternion.y, quaternion.z));
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
