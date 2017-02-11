using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class ObjectHighlight_PostPass : MonoBehaviour
{
	private Material material;

	private void OnEnable()
	{
		material = new Material(Shader.Find("Custom/ObjectHighlightComposite"));
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, material);
	}

}
