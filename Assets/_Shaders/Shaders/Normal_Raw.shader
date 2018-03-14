Shader "_Utility/Normal_Raw"
{
	Properties
	{
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque" "IgnoreProjector" = "True" "Queue" = "Geometry" }
		ZWrite On
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
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 colour = fixed4(1,1,1,1);
				colour.rgb = i.normal;
				return colour;
			}

			ENDCG
		}
	}
}
