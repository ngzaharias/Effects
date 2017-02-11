Shader "Custom/BlurTexture"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BlurSize ("BlurSize", Vector) = (0,0,0,0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Cull Off
		ZWrite Off
		ZTest Always

		// horizontal
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
			float4 _MainTex_ST;
			float2 _BlurSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv) * 0.38774;
				col += tex2D(_MainTex, i.uv + float2(_BlurSize.x * -2, 0)) * 0.06136;
				col += tex2D(_MainTex, i.uv + float2(_BlurSize.x * -1, 0)) * 0.24477;
				col += tex2D(_MainTex, i.uv + float2(_BlurSize.x *  1, 0)) * 0.24477;
				col += tex2D(_MainTex, i.uv + float2(_BlurSize.x *  2, 0)) * 0.06136;
				return col;
			}
			ENDCG
		}

		// vertical
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
			float4 _MainTex_ST;
			float2 _BlurSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv) * 0.38774;
				col += tex2D(_MainTex, i.uv + float2(0, _BlurSize.y * -2)) * 0.06136;
				col += tex2D(_MainTex, i.uv + float2(0, _BlurSize.y * -1)) * 0.24477;
				col += tex2D(_MainTex, i.uv + float2(0, _BlurSize.y *  1)) * 0.24477;
				col += tex2D(_MainTex, i.uv + float2(0, _BlurSize.y *  2)) * 0.06136;
				return col;
			}
			ENDCG
		}
	}
}
