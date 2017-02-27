Shader "_Shader/ResourceBu"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}

		_SpeedA ("Speed", Vector) = (-0.1, -0.1, 0.0, 0.0)
		_SpeedB ("Speed", Vector) = (0.1, -0.1, 0.0, 0.0)
		_SpeedC ("Speed", Vector) = (0.0, -0.1, 0.0, 0.0)
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
			};

			sampler2D _MainTex;

			float2 _SpeedA;
			float2 _SpeedB;
			float2 _SpeedC;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv1;

				o.uv_a = (v.uv1 + _Time * _SpeedA) * 1.0f;
				o.uv_b = (v.uv1 + _Time * _SpeedB) * 0.5f;
				o.uv_c = (v.uv1 + _Time * _SpeedC) * 2.0f;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 colourA = tex2D(_MainTex, i.uv_a); //.r * _ColourA;
				fixed4 colourB = tex2D(_MainTex, i.uv_b); //.g * _ColourB;
				fixed4 colourC = tex2D(_MainTex, i.uv_c); //.b * _ColourC;

				// colour
				fixed4 colour = (colourA * colourB * 2.0) * colourC * 2.0;
				colour.a = 1.0f;

				return colour;
			}
			ENDCG
		}
	}
}
