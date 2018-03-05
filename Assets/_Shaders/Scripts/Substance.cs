using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
public class Substance : MonoBehaviour
{
	[Range(-1.0f, 1.0f)]
	public float Multiplier = 1.0f;

	public Vector2 Smoke1Speed = new Vector2(0.05f, 0.1f);
	public Vector2 Smoke2Speed = new Vector2(0.1f, 0.1f);
	public float SurfaceSpeed = 0.1f;

	Material material;

	Vector2 smoke1Offset;
	Vector2 smoke2Offset;
	float surfaceOffset;

	void Awake()
	{
		material = GetComponent<MeshRenderer>().sharedMaterial;

		smoke1Offset = Random.Range(0.0f, 1.0f) * Vector2.one;
		smoke2Offset = Random.Range(0.0f, 1.0f) * Vector2.one;
		surfaceOffset = Random.Range(0.0f, 1.0f);
	}

	void Update()
	{
		smoke1Offset += Multiplier * Time.deltaTime * Smoke1Speed;
		smoke2Offset += Multiplier * Time.deltaTime * Smoke2Speed;
		surfaceOffset += Multiplier * Time.deltaTime * SurfaceSpeed;

		material.SetFloat("_Smoke1OffsetX", smoke1Offset.x);
		material.SetFloat("_Smoke1OffsetY", smoke1Offset.y);
		material.SetFloat("_Smoke2OffsetX", smoke2Offset.x);
		material.SetFloat("_Smoke2OffsetY", smoke2Offset.y);
		material.SetFloat("_SurfaceOffsetX", surfaceOffset);
	}
}
