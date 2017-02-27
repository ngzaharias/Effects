Shader "_Shader/SinWave"
{
	Properties
	{
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

			half SinWave(fixed Position)
			{
				float x = (Position*10.0) + (_Time*10.0);
				return (sin(x) + sin((2.2*x) + 5.52) + sin((2.9*x) + 0.93) + sin((4.6*x) + 8.94)) * 0.01;
			}

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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.uv.y += SinWave(o.uv.x);

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// debug so we can visual it
				fixed4 colour = fixed4(1,1,1,1);
				colour.a = step(i.uv.y, 0.5);

				return colour;
			}
			ENDCG
		}
	}
}
