using System.Collections;
using UnityEngine;

public class DestroyAfterDelay : MonoBehaviour 
{
	public float delay;

	private void Start() 
	{
		Destroy(gameObject, delay);
	}
}
