Shader "_Shader/FillMask"
{
	Properties
	{
		_Fill("Fill Height", Range(0.0, 1.0)) = 0.5
		_Steepness("Steepness", Range(0, 100)) = 100
	}
	SubShader
	{
		Tags 
		{
			"Queue"="Transparent"
			"RenderType"="Transparent" 
		}
		LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			fixed _Fill;
			fixed _Steepness;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed FillMask(fixed Position, fixed Height, float Steepness)
			{
				return pow((1.0 - Position) + Height, Steepness);
			}

			// https://en.wikipedia.org/wiki/Logistic_function
			// https://en.wikipedia.org/wiki/E_(mathematical_constant)
			fixed Logistic(fixed Position, fixed Height, float Steepness)
			{
				return 1.0 / (1.0 + pow(2.71828, -Steepness*((1.0 - Position) - (1.0 - Height))));
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 colour = fixed4(1,1,1,1);
				//colour.a = Logistic(i.uv.y, _Fill, _Steepness);
				colour.a = FillMask(i.uv.y, _Fill, _Steepness);

				return colour;
			}
			ENDCG
		}
	}
}
