Shader "Custom/ObjectHighlightComposite"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Cull Off
		ZWrite Off
		ZTest Always

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
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _ObjectHighlightOriginalTex;
			sampler2D _ObjectHighlightBlurredTex;
			float4 _MainTex_ST;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 original = tex2D(_ObjectHighlightOriginalTex, i.uv);
				fixed4 blurred = tex2D(_ObjectHighlightBlurredTex, i.uv);
				fixed4 main = tex2D(_MainTex, i.uv);
				return main + (max(0, blurred - original) * 2.0f);
				//return main + (max(0, blurred) * 2.0f);
				//return (max(0, blurred - original) * 2.0f);
				//return main;
			}
			ENDCG
		}
	}
}
