Shader "_Shader/ResourceBubble"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}

		_Height("Height", Range(0.0, 1.0)) = 0.5

		_FillFalloff("Fill Falloff", Range(0.0, 100.0)) = 40.0

		_LineThickness("Line Thickness", Range(0.0, 1.0)) = 0.01
		_LineFalloff ("Line Falloff", Range (0.0, 100.0) ) = 20.0
		_LineIntensity ("Line Intensity", Range (0.0, 5.0) ) = 1.5

		_BotSpeed ("Speed", Vector) = (-0.1, -0.1, 0.0, 0.0)
		_MidSpeed ("Speed", Vector) = (0.1, -0.1, 0.0, 0.0)
		_TopSpeed ("Speed", Vector) = (0.0, -0.1, 0.0, 0.0)
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

			fixed LineMask(fixed Position, fixed Height, float Thickness, float Steepness)
			{
				fixed val = (1.0 - abs(Height - Position)) + Thickness;
				return clamp(pow(val, Steepness), 0.0, 1.0);
			}

			fixed FillMask(fixed Position, fixed Height, float Steepness)
			{
				return pow((1.0 - Position) + Height, Steepness);
			}

			fixed Logistic(fixed Position, fixed Height, float Steepness)
			{
				// https://en.wikipedia.org/wiki/Logistic_function
				// https://en.wikipedia.org/wiki/E_(mathematical_constant)
				return 1.0 / (1.0 + pow(2.71828, -Steepness*((1.0 - Position) - (1.0 - Height))));
			}

			half SinWave(fixed Position)
			{
				float x = (Position*10.0) + (_Time*10.0);
				return (sin(x) + sin((2.2*x) + 5.52) + sin((2.9*x) + 0.93) + sin((4.6*x) + 8.94)) * 0.01;
			}

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv1 : TEXCOORD0;
				float2 uv2 : TEXCOORD2;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed2 uv : TEXCOORD0;
				fixed2 uv_a : TEXCOORD1;
				fixed2 uv_b : TEXCOORD2;
				fixed2 uv_c : TEXCOORD3;
				fixed2 uv2 : TEXCOORD5;
			};

			sampler2D _MainTex;

			fixed _Height;
			fixed _FillFalloff;
			fixed _LineThickness;
			fixed _LineFalloff;
			fixed _LineIntensity;

			float2 _BotSpeed;
			float2 _MidSpeed;
			float2 _TopSpeed;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv1;

				o.uv_a = (o.uv + _Time * _BotSpeed) * 1.0f;
				o.uv_b = (o.uv + _Time * _MidSpeed) * 0.5f;
				o.uv_c = (o.uv + _Time * _TopSpeed) * 2.0f;
				o.uv2 = v.uv2 + SinWave(v.uv2.x);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 colourA = tex2D(_MainTex, i.uv_a);
				fixed4 colourB = tex2D(_MainTex, i.uv_b);
				fixed4 colourC = tex2D(_MainTex, i.uv_c);
				fixed4 colour = (colourA * colourB * 2.0) * colourC * 2.0;

				colour += colourA * LineMask(i.uv2.y, _Height, _LineThickness, _LineFalloff) * _LineIntensity;
				colour.a = FillMask(i.uv2.y, _Height, _FillFalloff);

				return colour;
			}
			ENDCG
		}
	}
}
