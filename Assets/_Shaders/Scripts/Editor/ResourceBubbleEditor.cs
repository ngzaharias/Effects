using UnityEngine;
using UnityEditor;
using System;

public class ResourceBubbleEditor : ShaderGUI
{
	ColorPickerHDRConfig hdrConfig = new ColorPickerHDRConfig(0.0f, 100.0f, 0.0f, 100.0f);

	public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
	{
		Main(materialEditor, properties);

		EditorGUILayout.Space();
		GUILayout.Box("", new GUILayoutOption[] { GUILayout.ExpandWidth(true), GUILayout.Height(1) });
		EditorGUILayout.Space();

		Colour(materialEditor, properties);
		EditorGUILayout.Space();
		Intensity(materialEditor, properties);
		EditorGUILayout.Space();
		Panning(materialEditor, properties);
	}

	void Main(MaterialEditor materialEditor, MaterialProperty[] properties)
	{
		MaterialProperty _MainTex = ShaderGUI.FindProperty("_MainTex", properties);
		MaterialProperty _MainProps = ShaderGUI.FindProperty("_MainProps", properties);
		MaterialProperty _LineProps = ShaderGUI.FindProperty("_LineProps", properties);

		EditorGUILayout.BeginHorizontal();
		materialEditor.TexturePropertySingleLine(new GUIContent("Texture"), _MainTex);
		float mainHeight = EditorGUILayout.Slider(_MainProps.vectorValue.x, 0.0f, 1.0f);
		EditorGUILayout.EndHorizontal();

		EditorGUILayout.BeginVertical();
		EditorGUI.indentLevel++;
		{
			float mainFalloff = EditorGUILayout.Slider(new GUIContent("Main Falloff"), _MainProps.vectorValue.y, 0.0f, 100.0f);
			float lineThickness = EditorGUILayout.Slider(new GUIContent("Line Thickness"), _LineProps.vectorValue.x, 0.0f, 1.0f);
			float lineFalloff = EditorGUILayout.Slider(new GUIContent("Line Falloff"), _LineProps.vectorValue.y, 0.0f, 100.0f);

			_MainProps.vectorValue = new Vector4(mainHeight, mainFalloff, _MainProps.vectorValue.z, _MainProps.vectorValue.w);
			_LineProps.vectorValue = new Vector4(lineThickness, lineFalloff, _LineProps.vectorValue.z, _LineProps.vectorValue.w);
		}
		EditorGUI.indentLevel--;
		EditorGUILayout.EndVertical();
	}

	void Colour(MaterialEditor materialEditor, MaterialProperty[] properties)
	{
		MaterialProperty _BotColour = ShaderGUI.FindProperty("_BotColour", properties);
		MaterialProperty _MidColour = ShaderGUI.FindProperty("_MidColour", properties);
		MaterialProperty _TopColour = ShaderGUI.FindProperty("_TopColour", properties);
		MaterialProperty _LineColour = ShaderGUI.FindProperty("_LineColour", properties);

		EditorGUILayout.LabelField("Colour:", EditorStyles.boldLabel);

		EditorGUILayout.BeginVertical();
		EditorGUI.indentLevel++;
		{
			_BotColour.colorValue = EditorGUILayout.ColorField(new GUIContent("[R] Bottom"), _BotColour.colorValue, true, false, true, hdrConfig);
			_MidColour.colorValue = EditorGUILayout.ColorField(new GUIContent("[G] Middle"), _MidColour.colorValue, true, false, true, hdrConfig);
			_TopColour.colorValue = EditorGUILayout.ColorField(new GUIContent("[B] Top"), _TopColour.colorValue, true, false, true, hdrConfig);
			_LineColour.colorValue = EditorGUILayout.ColorField(new GUIContent("[A] Line"), _LineColour.colorValue, true, false, true, hdrConfig);
		}
		EditorGUI.indentLevel--;
		EditorGUILayout.EndVertical();
	}

	void Intensity(MaterialEditor materialEditor, MaterialProperty[] properties)
	{
		MaterialProperty _BotProps = ShaderGUI.FindProperty("_BotProps", properties);
		MaterialProperty _MidProps = ShaderGUI.FindProperty("_MidProps", properties);
		MaterialProperty _TopProps = ShaderGUI.FindProperty("_TopProps", properties);
		MaterialProperty _LineProps = ShaderGUI.FindProperty("_LineProps", properties);

		EditorGUILayout.LabelField("Intensity:", EditorStyles.boldLabel);

		EditorGUILayout.BeginVertical();
		EditorGUI.indentLevel++;
		{
			float r = EditorGUILayout.Slider(new GUIContent("[R] Bottom"), _BotProps.vectorValue.z, 0.0f, 20.0f);
			float g = EditorGUILayout.Slider(new GUIContent("[G] Middle"), _MidProps.vectorValue.z, 0.0f, 20.0f);
			float b = EditorGUILayout.Slider(new GUIContent("[B] Top"), _TopProps.vectorValue.z, 0.0f, 20.0f);
			float a = EditorGUILayout.Slider(new GUIContent("[A] Line"), _LineProps.vectorValue.z, 0.0f, 20.0f);

			_BotProps.vectorValue = new Vector4(_BotProps.vectorValue.x, _BotProps.vectorValue.y, r, _BotProps.vectorValue.w);
			_MidProps.vectorValue = new Vector4(_MidProps.vectorValue.x, _MidProps.vectorValue.y, g, _MidProps.vectorValue.w);
			_TopProps.vectorValue = new Vector4(_TopProps.vectorValue.x, _TopProps.vectorValue.y, b, _TopProps.vectorValue.w);
			_LineProps.vectorValue = new Vector4(_LineProps.vectorValue.x, _LineProps.vectorValue.y, a, _LineProps.vectorValue.w);
		}
		EditorGUI.indentLevel--;
		EditorGUILayout.EndVertical();
	}

	void Panning(MaterialEditor materialEditor, MaterialProperty[] properties)
	{
		MaterialProperty _BotProps = ShaderGUI.FindProperty("_BotProps", properties);
		MaterialProperty _MidProps = ShaderGUI.FindProperty("_MidProps", properties);
		MaterialProperty _TopProps = ShaderGUI.FindProperty("_TopProps", properties);

		EditorGUILayout.BeginVertical();
		EditorGUILayout.LabelField("Panning:", EditorStyles.boldLabel);

		EditorGUI.indentLevel++;
		{
			Vector2 r = EditorGUILayout.Vector2Field(new GUIContent("[R] Bottom"), _BotProps.vectorValue);
			Vector2 g = EditorGUILayout.Vector2Field(new GUIContent("[G] Middle"), _MidProps.vectorValue);
			Vector2 b = EditorGUILayout.Vector2Field(new GUIContent("[B] Top"), _TopProps.vectorValue);

			_BotProps.vectorValue = new Vector4(r.x, r.y, _BotProps.vectorValue.z, _BotProps.vectorValue.w);
			_MidProps.vectorValue = new Vector4(g.x, g.y, _MidProps.vectorValue.z, _MidProps.vectorValue.w);
			_TopProps.vectorValue = new Vector4(b.x, b.y, _TopProps.vectorValue.z, _TopProps.vectorValue.w);
		}
		EditorGUI.indentLevel--;

		EditorGUILayout.EndVertical();
	}
}
