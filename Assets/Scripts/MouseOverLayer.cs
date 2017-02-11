using UnityEngine;
using UnityEngine.EventSystems;

public class MouseOverLayer : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
	public int layer;
	private int newLayer;
	private int oldLayer;

	private void Start()
	{
		oldLayer = gameObject.layer;
		newLayer = layer;
	}

	public void OnPointerEnter(PointerEventData eventData)
	{
		gameObject.layer = newLayer;
	}

	public void OnPointerExit(PointerEventData eventData)
	{
		gameObject.layer = oldLayer;
	}
}
