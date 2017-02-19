Shader "Custom/ChromaticDispersion" 
{
	Properties 
	{
		[HideInInspector]_MainTex ("", 2D) = "white" {}
		_Intensity ("Intensity", Range(0.0,0.05)) = 0.0
		[HideInInspector]_OffsetRed ("Offset Red", Vector) = (-0.1, -0.1, 0.0, 0.0)
		[HideInInspector]_OffsetGreen ("Offset Green", Vector) = (0.1, -0.1, 0.0, 0.0)
		[HideInInspector]_OffsetBlue ("Offset Blue", Vector) = (-0.1, 0.1, 0.0, 0.0)
	}
 
	SubShader 
	{
		ZTest Always Cull Off ZWrite Off Fog { Mode Off }
 
		Pass
		{
			CGPROGRAM
			#include "UnityCG.cginc" 

			#pragma vertex vert
			#pragma fragment frag
    
			struct v2f 
			{
				float4 pos : POSITION;
				half2 uv : TEXCOORD0;
			};

			float _Intensity;
			float4 _OffsetRed;
			float4 _OffsetGreen;
			float4 _OffsetBlue;
			sampler2D _MainTex;
   
			v2f vert (appdata_img IN)
			{
				v2f OUT;
				OUT.pos = mul(UNITY_MATRIX_MVP, IN.vertex);
				OUT.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, IN.texcoord.xy);
				return OUT; 
			}
    
			fixed4 frag (v2f IN) : COLOR
			{
				//	Get the orginal rendered color 
				fixed4 red = tex2D(_MainTex, IN.uv + (_OffsetRed.xy * _Intensity));
				fixed4 green = tex2D(_MainTex, IN.uv + (_OffsetGreen.xy * _Intensity));
				fixed4 blue = tex2D(_MainTex, IN.uv + (_OffsetBlue.xy * _Intensity));
				return fixed4(red.r, green.g, blue.b, 1.0);
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}