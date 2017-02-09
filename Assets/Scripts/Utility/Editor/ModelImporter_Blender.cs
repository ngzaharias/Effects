using UnityEngine;
using UnityEditor;

public class ModelImporter_Blender : AssetPostprocessor
{
	private void OnPreprocessModel()
	{
		ModelImporter modelImporter = assetImporter as ModelImporter;

		string name = FilePathExtensions.GetFileName(assetImporter.assetPath);
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
		ModelImporter modelImporter = assetImporter as ModelImporter;

		string name = FilePathExtensions.GetFileName(assetImporter.assetPath);
		string extension = FilePathExtensions.GetFileExtension(assetImporter.assetPath);
		if (string.Compare(extension, "fbx") == 0)
		{
			MeshFilter filter = prefab.GetComponent<MeshFilter>();
			MeshRenderer renderer = prefab.GetComponent<MeshRenderer>();

			prefab.transform.localPosition = Vector3.one;
			prefab.transform.localScale = Vector3.one;
			prefab.transform.localRotation = Quaternion.identity;
		}
	}
}
