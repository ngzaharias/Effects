using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(TargetedLineRenderer))]
public class TargetedLineRendererEditor : Editor
{
	public override void OnInspectorGUI()
	{
		base.OnInspectorGUI();

		TargetedLineRenderer lineRenderer = target as TargetedLineRenderer;

		if (GUILayout.Button("Debug: Reset") == true)
			lineRenderer.ResetPoints();
	}
}
