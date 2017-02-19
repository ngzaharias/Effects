using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class ObjectHighlight_PrePass : MonoBehaviour
{
	public Vector2 blurSize = Vector2.zero;
	[Range(0, 10)]
	public int blurIterations = 0;
	[Range(0,4)]
	public int blurDownscale = 0;

	new private Camera camera;
	private Material blurMaterial;

	private static RenderTexture original;
	private static RenderTexture blurred;

	private void Start()
	{
		camera = GetComponent<Camera>();
		camera.SetReplacementShader(Shader.Find("Custom/UnlitColour"), "RenderType");

		original = new RenderTexture(Screen.width, Screen.height, 0);
		original.Create();

		blurred = new RenderTexture(Screen.width >> blurDownscale, Screen.height >> blurDownscale, 0);
		blurred.enableRandomWrite = true;
		blurred.Create();

		Vector2 size = new Vector2(blurred.texelSize.x * blurSize.x, blurred.texelSize.y * blurSize.y);
		blurMaterial = new Material(Shader.Find("Custom/BlurTexture"));
		blurMaterial.SetVector("_BlurSize", size);

		Shader.SetGlobalTexture("_ObjectHighlightOriginalTex", original);
		Shader.SetGlobalTexture("_ObjectHighlightBlurredTex", blurred);
	}

	private void OnDestroy()
	{
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		//Graphics.Blit(source, destination);

		// original
		Graphics.Blit(source, original);

		Graphics.Blit(source, blurred);

		RenderTexture temp = RenderTexture.GetTemporary(blurred.width, blurred.height);
		for (int i = 0; i < blurIterations; ++i)
		{
			Graphics.Blit(blurred, temp, blurMaterial, 0);
			Graphics.Blit(temp, blurred, blurMaterial, 1);
		}
		RenderTexture.ReleaseTemporary(temp);

		Graphics.Blit(blurred, destination);
	}
}
