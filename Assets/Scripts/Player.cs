using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
	public float speed;
	float verticalMove = 0f;

	public GameObject highestPoint;
	public GameObject lowestPoint;
	public GameObject Bullet;
	public Joystick Joystick;
	Rigidbody RB;

	public string ShotSound;

	private void Start()
	{
		PlayerPrefs.SetInt("Score", 0);
		RB = GetComponent<Rigidbody>();

		highestPoint = GameObject.Find("Top limit");
		lowestPoint = GameObject.Find("Bottom limit");
		Joystick = FindObjectOfType<FixedJoystick>();
	}

	private void Update()
	{
		JoystickMovement();

		if (Input.GetKey(KeyCode.W))
		{
			MoveUp();
		}
		if (Input.GetKey(KeyCode.S))
		{
			MoveDown();
		}
		if (Input.GetKeyDown(KeyCode.Space))
		{
			Shoot();
		}
	}

	public void MoveUp()
	{
		transform.position += Vector3.up * Time.deltaTime * speed;

		if (transform.position.y > highestPoint.transform.position.y)
		{
			transform.position = new Vector3(transform.position.x, highestPoint.transform.position.y, transform.position.z);
		}
	}

	public void MoveDown()
	{
		transform.position += Vector3.down * Time.deltaTime * speed;

		if (transform.position.y < lowestPoint.transform.position.y)
		{
			transform.position = new Vector3(transform.position.x, lowestPoint.transform.position.y, transform.position.z);
		}
	}

	public void Shoot()
	{
		Vector3 BulletSpawn = new Vector3(1, 0, 0);
		Instantiate(Bullet.gameObject, BulletSpawn+transform.TransformPoint(0, 0, 0), gameObject.transform.rotation);
		FindObjectOfType<AudioManager>().Play(ShotSound);
	}

	public void JoystickMovement()
	{
		verticalMove = Joystick.Vertical * speed;
		RB.velocity = new Vector3(0, verticalMove, 0);

		if (transform.position.y > highestPoint.transform.position.y)
		{
			transform.position = new Vector3(transform.position.x, highestPoint.transform.position.y, transform.position.z);
		}
		if (transform.position.y < lowestPoint.transform.position.y)
		{
			transform.position = new Vector3(transform.position.x, lowestPoint.transform.position.y, transform.position.z);
		}
	}
}
