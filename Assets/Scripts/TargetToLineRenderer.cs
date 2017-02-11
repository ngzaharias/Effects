using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TargetToLineRenderer : MonoBehaviour
{
	public Transform[] targets;
	new private LineRenderer renderer;

	private void OnEnable()
	{
		renderer = GetComponent<LineRenderer>();
	}

	void Update ()
	{
		renderer.numPositions = targets.Length;
		for (int i = 0; i < targets.Length; ++i)
		{
			if (targets[i] != null)
			{
				renderer.SetPosition(i, targets[i].position);
			}
		}
	}
}
