using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RotateTowards : MonoBehaviour
{
	public Transform target;

	void Update ()
	{
		Vector3 direction = target.position - transform.position;
		transform.up = direction;
	}
}
