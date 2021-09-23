using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
	public float speed;

	private void Start()
	{
		StartCoroutine(Deactivate());
	}

	private void Update()
	{
		transform.position += Vector3.right * Time.deltaTime * speed;
	}

	IEnumerator Deactivate()
    {
		yield return new WaitForSeconds(5);
		gameObject.SetActive(false);
	}
}
