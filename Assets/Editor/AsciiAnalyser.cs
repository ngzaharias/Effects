using UnityEngine;
using UnityEditor;

public class AsciiAnalyser : EditorWindow 
{
    static bool m_showSettings = true;
    static Vector2 m_gridField = default(Vector2);
    static Texture2D m_textureField = null;

    [MenuItem("Window/Ascii Analyser")]
    static void Initalise()
    {
        // Get existing open window or if none, make a new one:
        AsciiAnalyser window = (AsciiAnalyser)EditorWindow.GetWindow(typeof(AsciiAnalyser), true, "Ascii Analyser");
        window.minSize = new Vector2(200, 128);
    }

    void OnGUI()
    {
        Rect settingsRect = Settings();
        PreviewTexture(settingsRect);
    }

    Rect Settings()
    {
        Rect rect = EditorGUILayout.BeginVertical();
        {
            m_showSettings = EditorGUILayout.Foldout(m_showSettings, "Settings");
            if (m_showSettings == false)
                return rect;
        
            //  Texture Field
            GUILayout.Space(2);
            EditorGUILayout.BeginHorizontal();
            {
                GUILayout.Space(16);
                GUILayout.Label("Texture");
                m_textureField = (Texture2D)EditorGUILayout.ObjectField(m_textureField, typeof(Object), false);
            }
            EditorGUILayout.EndHorizontal();

            //  Grid Field
            GUILayout.Space(2);
            EditorGUILayout.BeginHorizontal();
            {
                GUILayout.Space(16);
                GUILayout.Label("Grid Size");
                m_gridField = EditorGUILayout.Vector2Field(GUIContent.none, m_gridField, GUILayout.MinWidth(96));
            }
            EditorGUILayout.EndHorizontal();
        }
        EditorGUILayout.EndVertical();

        return rect;
    }

    Rect PreviewTexture(Rect previousRect)
    {
        Rect rect = EditorGUILayout.BeginVertical();
        {
            if (m_textureField == null)
                return rect;

            float spacing = position.width * 0.01f;
            float width = position.width / 2;
            Rect textureRect = new Rect(0 + spacing, previousRect.y + previousRect.height, width - spacing*2, width);
            EditorGUI.DrawPreviewTexture(textureRect, m_textureField);

            textureRect = new Rect(width + spacing, previousRect.y + previousRect.height, width - spacing*2, width);
            EditorGUI.DrawPreviewTexture(textureRect, m_textureField);
        }
        EditorGUILayout.EndVertical();

        return rect;
    }
}
