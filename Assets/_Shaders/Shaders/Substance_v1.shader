Shader "_Shader/Substance_v1"
{
	Properties
	{
		[NoScaleOffset]_Main("Main", 2D) = "black" {}

		[Space(10)]

		_ColourBase("Base Colour", Color) = (1, 1, 1, 1)
		_ColourAccent("Accent Colour", Color) = (1, 1, 1, 1)
		_ColourParticlesA("Particles A Colour", Color) = (1, 1, 1, 1)
		_ColourParticlesB("Particles B Colour", Color) = (1, 1, 1, 1)
		_ColourLine("Line Colour", Color) = (1, 1, 1, 1)

		[Space(10)]

		_DataA("Sample A Data", Vector) = (0.0, 0.0, 1.0, 1.0)
		_DataB("Sample B Data", Vector) = (0.0, 0.0, 0.5, 1.0)
		_DataC("Sample C Data", Vector) = (0.0, 0.0, 2.0, 1.0)
		_DataD("Sample D Data", Vector) = (0.0, 0.0, 1.0, 1.0)

		[Space(10)]

		_ShadowExponent("Shadow Exponent", Range(0.0, 10.0)) = 2.0
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
				float4 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				fixed2 uv : TEXCOORD0;
				fixed2 uv_a : TEXCOORD1;
				fixed2 uv_b : TEXCOORD2;
				fixed2 uv_c : TEXCOORD3;
				fixed2 uv_d : TEXCOORD4;
			};

			sampler2D _Main;

			float4 _ColourBase;
			float4 _ColourSurface;
			float4 _ColourAccent;
			float4 _ColourParticlesA;
			float4 _ColourParticlesB;
			float4 _DataA;
			float4 _DataB;
			float4 _DataC;
			float4 _DataD;
			float _ShadowExponent;

			half Fresnel(float3 viewDir, float3 normal, float exponent)
			{
				return pow(dot(viewDir, normal), exponent);
			}

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.uv = v.uv;

				// xy	= direction & speed
				// z	= scale

				// positive xy = bottom left
				o.uv_a = (o.uv + _Time * -_DataA.xy) * _DataA.z;
				o.uv_b = (o.uv + _Time * -_DataB.xy) * _DataB.z;
				o.uv_c = (o.uv + _Time * -_DataC.xy) * _DataC.z;
				o.uv_d = (o.uv + _Time * -_DataD.xy) * _DataD.z;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// red		= noise a
				// green	= noise b
				// blue		= particles a
				// alpha	= particles b

				// channels
				fixed4 channelA = tex2D(_Main, i.uv_a);
				fixed4 channelB = tex2D(_Main, i.uv_b);
				fixed4 channelC = tex2D(_Main, i.uv_c);
				fixed4 channelD = tex2D(_Main, i.uv_d);

				// base colour
				fixed4 colour = _ColourBase;

				colour.rgb += channelA.r * channelB.r * _DataA.w;
				colour.rgb -= channelA.g * channelB.g * _DataB.w;
				colour.rgb += 0.2;

				// accent
				colour.rgb *= _ColourAccent.rgb;

				// particle colours
				colour.rgb += _ColourParticlesA * channelC.b * channelC.b * _DataC.w;
				colour.rgb += _ColourParticlesB * channelD.a * channelD.a * _DataD.w;

				// shadow
				float3 viewDir = -UNITY_MATRIX_V[2].xyz;
				colour.rgb *= Fresnel(-viewDir, i.normal, _ShadowExponent);

				return colour;
			}

			ENDCG
		}
	}
}
