using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnerWithForce : Spawner 
{
	public float forceMultiplier;
	public Vector3 forceDirection;

	protected override void Refresh()
	{
		target.transform.position = transform.position;
		target.transform.rotation = transform.rotation;

		Rigidbody rigidbody = target.GetComponent<Rigidbody>();
		rigidbody.velocity = Vector3.zero;
		rigidbody.angularVelocity = Vector3.zero;
		rigidbody.AddForce(forceDirection * forceMultiplier);
	}
}
