using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DistanceToScale : MonoBehaviour
{
	[System.Flags]
	public enum VectorAxis
	{
		X = 1 << 0,
		Y = 1 << 1,
		Z = 1 << 2,
		//W = 1 << 3,
	};

	public Transform target;

	[SerializeField][EnumFlagsAttribute]
	private VectorAxis axis;

	private Material material;

	private void OnEnable()
	{
		MeshRenderer renderer = GetComponentInChildren<MeshRenderer>();
		material = renderer.sharedMaterial;
	}

	private void Update()
	{
		float distance = Vector3.Distance(transform.position, target.position);
		transform.localScale = new Vector3(transform.localScale.x, -distance, transform.localScale.z);
		material.mainTextureScale = new Vector2(distance, 1.0f);
	}
}
