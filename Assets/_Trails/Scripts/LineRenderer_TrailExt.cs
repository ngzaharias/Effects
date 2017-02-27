using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(LineRenderer))]
public class LineRenderer_TrailExt : MonoBehaviour
{
	// public
	public Transform origin;
	public Transform target;
	public float minPointDistance = 1.0f;

	public Vector3 OriginPosition
	{
		get
		{
			return (m_isWorldSpace) ? origin.position : origin.localPosition;
		}
	}
	public Vector3 TargetPosition
	{
		get
		{
			return (m_isWorldSpace) ? target.position : target.localPosition;
		}
	}

	public float DistanceCurrent
	{
		get { return m_distance; }
		set { m_isDirty = true; m_distance = value; }
	}
	public float DistanceMax
	{
		get { return (m_distances.Count > 0) ? m_distances[m_distances.Count - 1] : 0.0f; }
	}
	public float DistancePercentage
	{
		get { return (DistanceMax != 0.0f) ? DistanceCurrent / DistanceMax : 0.0f; }
		set { DistanceCurrent = DistanceMax * value; }
	}

	// protected

	// private
	private bool m_isDirty = false;
	private bool m_isDistanceInfinite = true;
	private bool m_isWorldSpace = false;
	private float m_distance = 0.0f;

	private List<float> m_distances = new List<float>();
	private List<Vector3> m_positions = new List<Vector3>();

	// cached
	private LineRenderer cached_lineRenderer;
	private Coroutine cached_coroutine;

	private void Awake()
	{
		Debug.AssertFormat(origin != null, this, "{0}_LineRenderer_TrailExt Origin is null!", gameObject);
		Debug.AssertFormat(target != null, this, "{0}_LineRenderer_TrailExt Target is null!", gameObject);

		cached_lineRenderer = GetComponent<LineRenderer>();
		m_isWorldSpace = cached_lineRenderer.useWorldSpace;
	}

	private void Update()
	{
		CheckForNewPoints();

		if (m_isDirty == true)
		{
			Sync();
		}
	}

	public void SetIsInfinite(bool isInfinite)
	{
		m_isDistanceInfinite = isInfinite;
		m_isDirty = true;
	}

	public void Reset()
	{
		m_distances.Clear();
		m_positions.Clear();
		m_distance = 0.0f;

		if (cached_coroutine != null)
		{
			StopCoroutine(cached_coroutine);
		}

		m_isDirty = true;
	}

	public Coroutine LerpDistance(float to, float duration)
	{
		if (cached_coroutine != null)
		{
			StopCoroutine(cached_coroutine);
		}

		float from = (m_isDistanceInfinite) ? 1.0f : DistanceCurrent;

		SetIsInfinite(false);
		cached_coroutine = StartCoroutine(LerpDistance_Coroutine(from, to, duration));
		return cached_coroutine;
	}

	public Coroutine LerpDistance(float from, float to, float duration)
	{
		if (cached_coroutine != null)
		{
			StopCoroutine(cached_coroutine);
		}

		SetIsInfinite(false);
		cached_coroutine = StartCoroutine(LerpDistance_Coroutine(from, to, duration));
		return cached_coroutine;
	}

	public Coroutine LerpPercentage(float to, float duration)
	{
		if (cached_coroutine != null)
		{
			StopCoroutine(cached_coroutine);
		}

		float from = (m_isDistanceInfinite) ? 1.0f : DistanceCurrent / DistanceMax;

		SetIsInfinite(false);
		cached_coroutine = StartCoroutine(LerpPercentage_Coroutine(from, to, duration));
		return cached_coroutine;
	}

	public Coroutine LerpPercentage(float from, float to, float duration)
	{
		if (cached_coroutine != null)
		{
			StopCoroutine(cached_coroutine);
		}

		cached_coroutine = StartCoroutine(LerpPercentage_Coroutine(from, to, duration));
		return cached_coroutine;
	}

	private int GetDistanceIndex(float distance)
	{
		for (int i = m_distances.Count - 1; i >= 0; --i)
		{
			if (distance >= m_distances[i])
			{
				return i;
			}
		}
		return -1;
	}

	private void CheckForNewPoints()
	{
		int positionsCount = m_positions.Count;
		Vector3 pointPosition = (positionsCount > 0) ? m_positions[positionsCount - 1] : OriginPosition;

		float distance = Vector3.Distance(pointPosition, TargetPosition);
		if (distance >= minPointDistance)
		{
			float distancePrevious = m_distances.Count > 0 ? m_distances[m_distances.Count - 1] : 0.0f;
			m_distances.Add(distancePrevious + distance);
			m_positions.Add(TargetPosition);
			m_isDirty = true;
		}
	}

	private void CullPointsToDistance()
	{
		// if there isn't another position to lerp between we don't need 
		// to bother at all as the distance is already at its maximum
		int index = GetDistanceIndex(m_distance);
		if (index + 1 < m_positions.Count)
		{
			Vector3 first = (index >= 0) ? m_positions[index] : OriginPosition;
			Vector3 second = m_positions[index + 1];
			float distanceBetween = Vector3.Distance(first, second);

			float firstDistance = (index >= 0) ? m_distances[index] : 0.0f;
			float t = (m_distance - firstDistance) / distanceBetween;
			Vector3 position = Vector3.Lerp(first, second, t);

			cached_lineRenderer.numPositions = index + 2;
			cached_lineRenderer.SetPosition(index + 1, position);
		}
	}

	private void Sync()
	{
		m_distance = (m_isDistanceInfinite) ? float.MaxValue : m_distance;

		cached_lineRenderer.numPositions = m_positions.Count;
		cached_lineRenderer.SetPositions(m_positions.ToArray());

		CullPointsToDistance();

		m_isDirty = false;
	}

	private IEnumerator LerpDistance_Coroutine(float from, float to, float duration)
	{
		if (duration <= 0.0f)
		{
			DistancePercentage = to;
			yield break;
		}

		float timer = duration;
		do
		{
			timer -= Time.deltaTime;

			float t = 1.0f - (timer / duration);
			DistanceCurrent = Mathf.Lerp(from, to, t);
			yield return true;
		}
		while (timer > 0.0f);

		yield return true;
	}

	private IEnumerator LerpPercentage_Coroutine(float from, float to, float duration)
	{
		if (duration <= 0.0f)
		{
			DistancePercentage = to;
			yield break;
		}

		float timer = duration;
		do
		{
			timer -= Time.deltaTime;

			float t = 1.0f - (timer / duration);
			DistancePercentage = Mathf.Lerp(from, to, t);
			yield return true;
		}
		while (timer > 0.0f);

		yield return true;
	}
}
