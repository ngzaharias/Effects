using System.Collections;
using UnityEngine;

public class Spawner : MonoBehaviour 
{
	public enum Mode
	{
		CREATE,
		REFRESH,
	}
	public Mode mode;

	public GameObject prefab;
	public GameObject target;

	public float duration = -1.0f;
	public float delay = 1.0f;

	private void Start() 
	{
		StartCoroutine( Loop() );
	}

	protected virtual void Create()
	{
		GameObject gameObject = Instantiate(prefab);
		gameObject.transform.position = transform.position;
	}

	protected virtual void Refresh()
	{
		target.transform.position = transform.position;
	}

	protected virtual IEnumerator Loop()
	{
		WaitForSeconds wait = new WaitForSeconds(delay);
		while (duration <= 0.0f || Time.time < duration)
		{
			switch (mode)
			{
				case Mode.CREATE: Create(); break;
				case Mode.REFRESH: Refresh(); break;
			}
			yield return wait;
		}
	}
}
