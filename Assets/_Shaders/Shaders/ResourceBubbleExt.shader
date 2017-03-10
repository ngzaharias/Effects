Shader "_Shader/ResourceBubbleExt"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainProps("Properties: Height | Falloff", Vector) = (0.5, 40.0, 0.0, 0.0)

		_LineColour ("Line Colour", Color) = (1, 1, 1, 1)
		_BotColour ("Bottom Colour", Color) = (1, 0, 0, 1)
		_MidColour ("Middle Colour", Color) = (0, 1, 0, 1)
		_TopColour ("Top Colour", Color) = (0, 0, 1, 1)

		_LineProps("Line Properties: Thickness | Falloff", Vector) = (0.01, 20.0, 1.0, 0.0)
		_BotProps("Bottom Properties: Speed X | Speed Y", Vector) = (-0.1, -0.1, 1.0, 0.0)
		_MidProps("Middle Properties: Speed X | Speed Y", Vector) = ( 0.1, -0.1, 1.0, 0.0)
		_TopProps("Top Properties: Speed X | Speed Y", Vector) = ( 0.0, -0.1, 1.0, 0.0)
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
				fixed2 uv_r : TEXCOORD1;
				fixed2 uv_g : TEXCOORD2;
				fixed2 uv_b : TEXCOORD3;
				fixed2 uv2 : TEXCOORD4;
			};

			sampler2D _MainTex;
			float4 _MainProps;

			float4 _LineColour;
			float4 _BotColour;
			float4 _MidColour;
			float4 _TopColour;

			float4 _LineProps;
			float4 _BotProps;
			float4 _MidProps;
			float4 _TopProps;
			 
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv1;

				o.uv_r = (o.uv + _Time * _BotProps.xy) * 1.0f;
				o.uv_g = (o.uv + _Time * _MidProps.xy) * 0.5f;
				o.uv_b = (o.uv + _Time * _TopProps.xy) * 2.0f;
				o.uv2 = v.uv2 + SinWave(v.uv2.x);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 botTexture = tex2D(_MainTex, i.uv_r);
				float4 midTexture = tex2D(_MainTex, i.uv_g);
				float4 topTexture = tex2D(_MainTex, i.uv_b);

				float4 botColour = botTexture.r * _BotColour * _BotProps.z;
				float4 midColour = midTexture.g * _MidColour * _MidProps.z;
				float4 topColour = topTexture.b * _TopColour * _TopProps.z;
				float4 colour = (botColour + midColour) * topColour;

				colour += botTexture.a * LineMask(i.uv2.y, _MainProps.x, _LineProps.x, _LineProps.y) * _LineProps.z * _LineColour;
				colour.a = FillMask(i.uv2.y, _MainProps.x, _MainProps.y);

				return colour;
			}
			ENDCG
		}
	}
	CustomEditor "ResourceBubbleEditor"
}
