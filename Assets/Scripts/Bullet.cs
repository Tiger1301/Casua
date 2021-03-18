using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
	public float speed;

	private void Start()
	{
		Destroy(gameObject, 5);
	}

	private void Update()
	{
		transform.position += Vector3.right * Time.deltaTime * speed;
	}
}
