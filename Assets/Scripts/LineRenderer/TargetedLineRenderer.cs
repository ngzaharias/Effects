using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(LineRenderer))]
public class TargetedLineRenderer : MonoBehaviour
{
	public enum Mode
	{
		DISTANCE_FULL,
		DISTANCE_USER,
	}

	public Transform origin;
	public Transform target;
	public float minPointDistance = 1.0f;

	private Mode mode = Mode.DISTANCE_FULL;
	private bool isDirty = true;
	private bool isWorldSpace = true;
	private float visualDistance = float.MaxValue;
	private float visualDistanceLast = float.MaxValue;
	private List<float> distances = new List<float>();
	private List<Vector3> positions = new List<Vector3>();

	private LineRenderer cached_lineRenderer;

	private Vector3 originPos
	{
		get
		{
			return (isWorldSpace) ? origin.position : origin.localPosition;
		}
		set
		{
			if (isWorldSpace)
				origin.position = value;
			else
				origin.localPosition = value;
		}
	}
	private Vector3 targetPos
	{
		get
		{
			return (isWorldSpace) ? target.position : target.localPosition;
		}
		set
		{
			if (isWorldSpace)
				target.position = value;
			else
				target.localPosition = value;
		}
	}

	private void Awake()
	{
		if (origin == null)
		{
			origin = transform;
		}

		cached_lineRenderer = GetComponent<LineRenderer>();
		isWorldSpace = cached_lineRenderer.useWorldSpace;
	}

	private void Start()
	{
		StartCoroutine( Test() );
	}

	IEnumerator Test()
	{
		yield return new WaitForSeconds(2.0f);

		float max = GetDistanceMax();

		visualDistance = max;
		SetMode(Mode.DISTANCE_USER);

		float time = 0.0f;
		while (time < 1.0f)
		{
			time += Time.deltaTime;
			visualDistance = Mathf.Lerp(max, 0.0f, time);
			yield return false;
		}

		yield return new WaitForSeconds(1.0f);

		time = 0.0f;
		while (time < 1.0f)
		{
			time += Time.deltaTime;
			visualDistance = Mathf.Lerp(0.0f, max, time);
			yield return false;
		}

		SetMode(Mode.DISTANCE_FULL);

		yield return true;
	}

	private void Update()
	{
		CheckForNewPoints();

		if (isDirty == true)
		{
			Sync();
		}

		switch (mode)
		{
			case Mode.DISTANCE_FULL: break;
			case Mode.DISTANCE_USER: Update_User(); break;
		}
	}

	private void Update_User()
	{
		if (visualDistance != visualDistanceLast)
		{
			CullPointsToVisualRange();
		}
	}

	public float GetDistanceMax()
	{
		return (distances.Count > 0) ? distances[distances.Count - 1] : 0.0f;
	}

	public void SetMode(Mode value)
	{
		if (value != mode)
		{
			switch (value)
			{
				case Mode.DISTANCE_FULL:
					Sync_Points();
					break;
				case Mode.DISTANCE_USER:
					break;
			}
		}
		mode = value;
	}

	public void AddPoint(float distance, Vector3 position)
	{
		distances.Add(distance);
		positions.Add(position);
		isDirty = true;
	}

	public void UndoPoint(int index)
	{
		if (index < 0 || index >= positions.Count)
			return;

		distances.RemoveAt(index);
		positions.RemoveAt(index);
		isDirty = true;
	}

	public void ResetPoints()
	{
		distances.Clear();
		positions.Clear();
		originPos = Vector3.zero;
		targetPos = Vector3.zero;
		isDirty = true;
	}

	private int GetIndexOfDistance(float distance)
	{
		Debug.Assert(distances != null);
		Debug.Assert(distances.Count > 0);

		for (int i = distances.Count - 1; i >= 0; --i)
		{
			if (distance >= distances[i])
			{
				return i;
			}
		}
		return -1;
	}

	private void CheckForNewPoints()
	{
		int numPositions = positions.Count;
		Vector3 pointPos = (numPositions > 0) ? positions[numPositions - 1] : originPos;

		Vector3 vector = targetPos - pointPos;
		float magnitude = Vector3.Magnitude(vector);
		Vector3 normal = vector / magnitude;
		if (magnitude >= minPointDistance)
		{
			float previousDistance = distances.Count > 0 ? distances[distances.Count - 1] : 0.0f;
			AddPoint(previousDistance + magnitude, targetPos);
		}
	}

	private void CullPointsToVisualRange()
	{
		//TODO: Account for the targetPos ??

		// if there isn't another position to lerp between we don't need 
		// to bother at all as the visualDistance is already at its maximum
		int index = GetIndexOfDistance(visualDistance);
		if (index + 1 >= 0 && index + 1 < positions.Count)
		{
			Vector3 first = (index >= 0) ? positions[index] : originPos;
			Vector3 second = positions[index + 1];

			float firstDistance = (index >= 0) ? distances[index] : 0.0f;
			float t = visualDistance - firstDistance;
			Vector3 position = Vector3.Lerp(first, second, t);

			cached_lineRenderer.numPositions = index + 2;
			cached_lineRenderer.SetPosition(index + 1, position);
		}
		visualDistanceLast = visualDistance;
	}

	private void Sync()
	{
		Sync_Points();

		isDirty = false;
	}

	private void Sync_Points()
	{
		cached_lineRenderer.numPositions = positions.Count;
		cached_lineRenderer.SetPositions(positions.ToArray());
	}
}
