
static public class FilePathExtensions
{
	static public string GetFileName(string assetPath)
	{
		string[] splitPath = assetPath.Split('/');
		if (splitPath.Length == 0)
			return "";

		string[] splitExtension = splitPath[splitPath.Length - 1].Split('.');
		if (splitExtension.Length == 0)
			return splitPath[splitPath.Length - 1];

		return splitExtension[splitExtension.Length - 1];
	}

	static public string GetFileExtension(string assetPath)
	{
		string[] split = assetPath.Split('.');
		if (split.Length == 0)
			return "";
		return split[split.Length - 1];
	}
}
