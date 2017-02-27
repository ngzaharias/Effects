using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
	public float speed = 1.0f;
	public Vector3 axis = Vector3.up;

	void Update ()
	{
		transform.Rotate(axis * speed);
	}
}
