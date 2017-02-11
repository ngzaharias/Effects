using UnityEngine;
using UnityEditor;

public class ModelImporter_Blender : AssetPostprocessor
{
	private void OnPreprocessModel()
	{
		ModelImporter modelImporter = assetImporter as ModelImporter;

		string extension = FilePathExtensions.GetFileExtension(assetImporter.assetPath);
		if (string.Compare(extension, "fbx") == 0)
		{
			modelImporter.animationType = ModelImporterAnimationType.None;
			modelImporter.globalScale = 100;
			modelImporter.importBlendShapes = false;
			modelImporter.importAnimation = false;
			modelImporter.importMaterials = false;
		}
	}

	private void OnPostprocessModel(GameObject prefab)
	{
		string extension = FilePathExtensions.GetFileExtension(assetImporter.assetPath);
		if (string.Compare(extension, "fbx") == 0)
		{
			prefab.transform.localPosition = Vector3.one;
			prefab.transform.localScale = Vector3.one;
			prefab.transform.localRotation = Quaternion.identity;
		}
	}
}
