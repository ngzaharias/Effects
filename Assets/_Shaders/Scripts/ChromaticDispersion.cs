using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class ChromaticDispersion : MonoBehaviour 
{
    public Material material;
    public AnimationCurve curve = AnimationCurve.Linear(0.0f, 0.0f, 1.0f, 0.05f);

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        float rndA = Random.Range(0.0f, 1.0f) * 2.0f - 1.0f;
        float rndB = Random.Range(0.0f, 1.0f) * 2.0f - 1.0f;

        Vector4 offsetRed = new Vector4(rndA, rndB, 0, 0);
        Vector4 offsetGreen = new Vector4(-rndA, -rndB, 0, 0);
        Vector4 offsetBlue = new Vector4(rndB, rndA, 0, 0);

        material.SetFloat("_Intensity", curve.Evaluate(Time.time));
        material.SetVector("_OffsetRed", offsetRed);
        material.SetVector("_OffsetGreen", offsetGreen);
        material.SetVector("_OffsetBlue", offsetBlue);
        Graphics.Blit(source, destination, material);
    }
}
