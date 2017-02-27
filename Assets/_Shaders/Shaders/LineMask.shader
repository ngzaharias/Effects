Shader "_Shader/LineMask"
{
	Properties
	{
		_Mask ("Mask", 2D) = "white" {}

		_Line("Line Height", Range(0.0, 1.0)) = 0.5
		_Thickness("Thickness", Range(0.0, 1.0)) = 0.01
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

			fixed LineMask(fixed Position, fixed Height, float Thickness, float Steepness)
			{
				fixed val = (1.0 - abs(Height - Position)) + Thickness;
				return pow(val, Steepness);
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

			sampler2D _Mask;
			fixed _Line;
			fixed _Thickness;
			fixed _Steepness;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.uv.y -= _Line;

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 colour = fixed4(1,1,1,1);
				colour.a = LineMask(i.uv.y, _Line, _Thickness, _Steepness);
				//fixed4 colour = tex2D(_Mask, i.uv);

				return colour;
			}
			ENDCG
		}
	}
}
