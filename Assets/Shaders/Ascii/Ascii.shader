Shader "Custom/Ascii" 
{
	Properties 
	{
		[HideInInspector]_MainTex ("", 2D) = "white" {}
		_CharTex ("Character Texture", 2D) = "white" {}
		_CharLayout ("Character Layout in Texture", Vector) = (8, 4, 0, 0)
		_PixelSize ("Pixel Size", Vector) = (16, 32, 0, 0)
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
				float4 worldPos : POSITION;
				half2 uv : TEXCOORD0;
			};

			half2 _CharLayout;
			half2 _PixelSize;
			sampler2D _MainTex;
			sampler2D _CharTex;
			
			inline fixed lightness(fixed3 col)
			{
 				return (max(col.r, max(col.g, col.b)) + min(col.r, min(col.g, col.b))) * 0.5f;
			}

			inline fixed average(fixed3 col)
			{
				return (col.r + col. g + col.b) * 0.3333333333f;
			}

			inline fixed luminosity(fixed3 col)
			{
				return (col.r * 0.21f) + (col.g * 0.72f) + (col.b * 0.07f);
			}

			inline fixed2 downscaledUV(float2 fragCoord)
			{
				return floor(fragCoord / _PixelSize) * _PixelSize / _ScreenParams;
			}

			fixed2 characterUV(fixed2 index, fixed2 fragCoord)
			{
				fixed2 charUVSpacing = 1.0f / _CharLayout;
				fixed2 uv = fmod(fragCoord / _PixelSize, 1.0f) / _CharLayout; 
				return uv + (index*charUVSpacing);
			}

			half2 characterIndex(fixed gray)
			{
				half index = floor(gray * _CharLayout.x * _CharLayout.y) - 1;
				return half2(index % _CharLayout.x, floor(index / _CharLayout.x));
			}

			v2f vert (appdata_img IN)
			{
				v2f OUT;
				OUT.worldPos = mul (UNITY_MATRIX_MVP, IN.vertex);
				OUT.uv = MultiplyUV (UNITY_MATRIX_TEXTURE0, IN.texcoord.xy);
				return OUT; 
			}

			fixed3 frag (v2f IN) : COLOR
			{
				float2 fragCoord = IN.uv * _ScreenParams.xy;

				fixed2 mainUV = downscaledUV(fragCoord);
				fixed3 colour = tex2D(_MainTex, mainUV);

				fixed gray = lightness(colour);
				fixed2 index = characterIndex(gray);

				fixed2 charUV = characterUV(index, fragCoord);

				//return tex2D(_CharTex, charUV) * fixed3(0,gray,0);
				return tex2D(_CharTex, charUV) * colour;
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
