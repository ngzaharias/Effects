Shader "Examples/ColourMath_v20"
{
	Properties
	{
		[NoScaleOffset]_Main("Main", 2D) = "black" {}

		[Space(10)]

		_ColourA("Colour A", Color) = (1, 1, 1, 1)
		_ColourB("Colour B", Color) = (1, 1, 1, 1)
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent" "IgnoreProjector" = "True" "Queue" = "Transparent" }
		ZWrite Off
		Blend One OneMinusSrcAlpha
		Cull Off
		Lighting Off

		Pass
		{
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
				fixed2 uv_a : TEXCOORD1;
				fixed2 uv_b : TEXCOORD2;
			};

			sampler2D _Main;

			float4 _ColourA;
			float4 _ColourB;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv_a = (v.uv + _Time * half2(0.0,0.1)) * 1.0;
				o.uv_b = (v.uv + _Time * half2(1.0,0.0)) * 1.0;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 channelA = tex2D(_Main, i.uv_a);
				fixed4 channelB = tex2D(_Main, i.uv_b);

				float4 colourA = channelA.r * _ColourA;
				float4 colourB = channelB.r * _ColourB;

				fixed4 colour;
				colour.r = colourA.r > colourB.r ? colourA.r - colourB.r : colourB.r - colourA.r;
				colour.r = colourA.g > colourB.g ? colourA.g - colourB.g : colourB.g - colourA.g;
				colour.r = colourA.b > colourB.b ? colourA.b - colourB.b : colourB.b - colourA.b;
				colour.a = 1.0;
				return colour;
			}

			ENDCG
		}
	}
}
