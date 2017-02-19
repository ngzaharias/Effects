Shader "Custom/ObscuredReveal" 
{
	Properties 
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TranTex ("Transparent Overlay", 2D) = "bump" {}
		_Intensity ("Intensity", Range(0.0, 0.1)) = 0.075
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		//Cull Off
		
		CGPROGRAM
		#pragma surface surf Lambert 

		float _Intensity;
		sampler2D _MainTex;
		sampler2D _TranTex;

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_TranTex;
			float3 worldPos;
			float4 screenPos;
		};

		void surf(Input IN, inout SurfaceOutput o) 
		{
			// calculate the screenSpace UV
			float2 worldUV = IN.worldPos.xy / IN.screenPos.w;
			float2 screenUV = IN.screenPos.xy / IN.screenPos.w;
			half4 trans = tex2D(_TranTex, IN.uv_TranTex);

			//	get the average colour of the texture
			//	add half so that the texture lerps between 100% revelead and obscured
			half clipping = (trans.r + trans.g + trans.b) / 3 + 0.5;
			//	distance between the vertex and the camera
			//	multiply by how intense we want the effect to be
			clipping *= distance(IN.worldPos.xz, _WorldSpaceCameraPos.xz) * _Intensity;

			//	* 2 - 1 adjusts it from '0 to 1' to '-1 to 1'
			clipping = (clipping * 2) - 1;
			clip(clipping);

			// texture and lighting crap
			half4 colour = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = colour.rgb;
			o.Alpha = colour.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
