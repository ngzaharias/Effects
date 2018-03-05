Shader "_Shader/Fresnel"
{
	Properties
	{
		[NoScaleOffset]_Main("Main Texture", 2D) = "white" {}
		_Exponent("Exponent", Range(0, 10)) = 3
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
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
			};

			sampler2D _Main;
			float _Exponent;

			half Fresnel(float3 viewDir, float3 normal, float exponent)
			{
				return pow(dot(viewDir, normal), exponent);
			}

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = normalize(ObjSpaceViewDir(v.vertex));
				o.uv = v.uv;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 colour = tex2D(_Main, i.uv);

				colour.a *= Fresnel(i.viewDir, i.normal, _Exponent);
				return colour;
			}

			ENDCG
		}
	}
}
