using UnityEngine;

public class Rotate : MonoBehaviour 
{
	public Vector3 axis = Vector3.zero;
	public float speed = 1.0f;

	private void Update() 
	{
		transform.Rotate(axis * speed);
	}
}
