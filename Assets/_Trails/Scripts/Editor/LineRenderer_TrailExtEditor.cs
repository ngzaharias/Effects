using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(LineRenderer_TrailExt))]
public class LineRenderer_TrailExtEditor : Editor
{
	public override void OnInspectorGUI()
	{
		base.OnInspectorGUI();

		LineRenderer_TrailExt lineRenderer = target as LineRenderer_TrailExt;

		if (GUILayout.Button("Debug: Reset Points") == true)
			lineRenderer.Reset();
		if (GUILayout.Button("Debug: Finite Distance") == true)
			lineRenderer.SetIsInfinite(false);
		if (GUILayout.Button("Debug: Infinite Distance") == true)
			lineRenderer.SetIsInfinite(true);

		lineRenderer.DistancePercentage = EditorGUILayout.Slider(lineRenderer.DistancePercentage, 0.0f, 1.0f);
	}
}
