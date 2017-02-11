using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextureCompare : MonoBehaviour 
{
	public ComputeShader shader;

	public RenderTexture textureA;
	public RenderTexture textureB;

	public Material materialOut;

	private RenderTexture textureOut;

	private void Start() 
	{
		textureOut = new RenderTexture(textureA.width, textureA.height, 0);
		textureOut.enableRandomWrite = true;
		//textureOut.filterMode = FilterMode.Point;
		textureOut.Create();
	}

	private void Update() 
	{
		int kernel = shader.FindKernel("CSMain");
		shader.SetTexture(kernel, "TextureA", textureA);
		shader.SetTexture(kernel, "TextureB", textureB);
		shader.SetTexture(kernel, "TextureOut", textureOut);
		shader.Dispatch(kernel, 16, 16, 1);

		materialOut.SetTexture("_MainTex", textureOut);
	}

	public IEnumerator Evaluate(Texture2D Texture)
	{
		string bg = "";
		string fg = "";
		string ol = "";
		string od = "";

		int target = 0;
		int overlap = 0;
		int overdraw = 0;
		for (int y = Texture.height - 1; y >= 0; --y)
		{
			for (int x = 0; x < Texture.width; ++x)
			{
				Color ColourA = Texture.GetPixel(x, y);

				bool isBackground = ColourA.r > 0.5f;
				bool isForeground = ColourA.r > 0.5f;

				if (isBackground)
					++target;
				if (isBackground == true && isForeground == true)
					++overlap;
				if (isBackground == false && isForeground == true)
					++overdraw;

				bg += (isBackground) ? " x " : " _ ";
				fg += (isForeground) ? " x " : " _ ";
				ol += (isBackground == true && isForeground == true) ? " x " : " _ ";
				od += (isBackground == false && isForeground == true) ? " x " : " _ ";
				yield return false;
			}
			bg += "\n";
			fg += "\n";
			ol += "\n";
			od += "\n";
		}

		Debug.Log(bg);
		Debug.Log(fg);
		Debug.Log(ol);
		Debug.Log(od);
		yield return true;
	}
}
