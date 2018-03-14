using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColourWarp : MonoBehaviour
{
    private MeshRenderer meshRenderer;
    private TextMesh textMesh;
    private float hueA = 0.0f;
    private float hueB = 0.0f;
    private float timeA = 1.0f;
    private float timeB = 1.0f;
    private float dirA = 1.0f;
    private float dirB = 1.0f;

    public float durationA = 1.0f;
    public float durationB = 10.0f;

    public bool DontUpdateColours = false;
    public Color out_ColourA;
    public Color out_ColourB;

    void Start ()
    {
        meshRenderer = GetComponentInChildren<MeshRenderer>();
        textMesh = GetComponentInChildren<TextMesh>();
        StartCoroutine("LoopA");
        StartCoroutine("LoopB");
    }

    IEnumerator LoopA()
    {
        while (true)
        {
            timeA += (Time.deltaTime / durationA) * dirA;
            hueA = Mathf.Lerp(0.0f, 1.0f, timeA);

            if (timeA > 1.0f)
            {
                dirA *= -1.0f;
                timeA = 1.0f;
            }
            else if (timeA < 0.0f)
            {
                dirA *= -1.0f;
                timeA = 0.0f;
            }
            yield return false;
        }

        yield return null;
    }

    IEnumerator LoopB()
    {
        while (true)
        {
            timeB += (Time.deltaTime / durationB) * dirB;
            hueB= Mathf.Lerp(0.0f, 1.0f, timeB);

            if (timeB > 1.0f)
            {
                dirB *= -1.0f;
                timeB = 1.0f;
            }
            else if (timeB < 0.0f)
            {
                dirB *= -1.0f;
                timeB = 0.0f;
            }

            UpdateData();

            yield return false;
        }
        yield return null;
    }

    void UpdateData()
    {
        if (!DontUpdateColours)
        {
            out_ColourA = Color.HSVToRGB(hueA, 1.0f, 1.0f);
            out_ColourB = Color.HSVToRGB(hueB, 1.0f, 1.0f);
        }
        meshRenderer.sharedMaterial.SetColor("_ColourA", out_ColourA);
        meshRenderer.sharedMaterial.SetColor("_ColourB", out_ColourB);

        textMesh.text = gameObject.name + "\n";
        textMesh.text += "<color=#" + ColorUtility.ToHtmlStringRGBA(out_ColourA) + ">";
        textMesh.text += "ColourA";
        textMesh.text += "</color>\n";
        textMesh.text += "<color=#" + ColorUtility.ToHtmlStringRGBA(out_ColourB) + ">";
        textMesh.text += "ColourB";
        textMesh.text += "</color>";
    }
}
