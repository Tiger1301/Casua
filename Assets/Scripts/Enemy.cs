using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Enemy : MonoBehaviour
{
    public float Speed;
    UIManager UIManager;
    public GameObject VFX_Explosion;
    public GameObject Anim_Explosion;

    // Start is called before the first frame update
    void Start()
    {
        Destroy(gameObject, 10);
        UIManager = FindObjectOfType<UIManager>();
    }

    // Update is called once per frame
    void Update()
    {
        transform.position += Vector3.left * Time.deltaTime * Speed;
        SetSpeed();
    }
    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.CompareTag("Bullet"))
        {
            Destroy(other.gameObject);
            Destroy(this.gameObject);
            
            int oldscore = PlayerPrefs.GetInt("Score", 0);
            PlayerPrefs.SetInt("Score", oldscore + 1);
            print(PlayerPrefs.GetInt("Score", 0));
            UIManager.Points += 10;
            UIManager.KillCount++;
            Instantiate(VFX_Explosion).transform.position = transform.position;
            Instantiate(Anim_Explosion).transform.position = transform.position;
        }
        if (other.gameObject.CompareTag("Player"))
        {
            //print("Game Over");
            //SceneManager.LoadScene(UnityEngine.SceneManagement.SceneManager.GetActiveScene().name);
            Destroy(this.gameObject);
            UIManager.KillCount = 0;
            UIManager.Lifes--;
        }
    }
    public void SetSpeed()
    {
        if(UIManager.Intensity==1)
        {
            Speed = 5;
        }
        else if(UIManager.Intensity==2)
        {
            Speed = 7.5f;
        }
        else if(UIManager.Intensity==3)
        {
            Speed = 10;
        }
    }
}
