Shader "Custom/PixelArt" 
{
	Properties 
	{
		[HideInInspector]_MainTex ("", 2D) = "white" {}
		_PixelSize ("PixelSize", Vector) = (16, 16, 0, 0)
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

			float2 _PixelSize;
			sampler2D _MainTex;

			inline fixed2 downscaledUV(fixed2 fragCoord, fixed2 pixelSize)
			{
				return floor(fragCoord / pixelSize) * pixelSize / _ScreenParams;
			}
   
			v2f vert (appdata_img IN)
			{
				v2f OUT;
				OUT.pos = mul (UNITY_MATRIX_MVP, IN.vertex);
				OUT.uv = MultiplyUV (UNITY_MATRIX_TEXTURE0, IN.texcoord.xy);
				return OUT; 
			}
    
			fixed4 frag (v2f IN) : COLOR
			{
				fixed2 fragCoord = IN.uv * _ScreenParams.xy;
				return tex2D(_MainTex, downscaledUV(fragCoord, _PixelSize));
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
