Shader "Custom/CRT" 
{
	Properties 
	{
		[HideInInspector]_MainTex ("", 2D) = "white" {}
	}
 
	SubShader 
	{
		ZTest Always Cull Off ZWrite Off Fog { Mode Off }
 
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc" 
			//#define X_ONLY
			//#define Y_ONLY
			#define X_AND_Y
    
			struct v2f 
			{
				float4 worldPos : POSITION;
				half2 uv : TEXCOORD0;
				float4 screenPos : TEXCOORD1;
			};

			sampler2D _MainTex; //Reference in Pass is necessary to let us use this variable in shaders
   
			v2f vert (appdata_img v)
			{
				v2f OUT;
				OUT.worldPos = mul (UNITY_MATRIX_MVP, v.vertex);
				OUT.uv = MultiplyUV (UNITY_MATRIX_TEXTURE0, v.texcoord.xy);
				OUT.screenPos = ComputeScreenPos(OUT.worldPos);
				return OUT; 
			}
    
			// Will return a value of 1 if the 'x' is < 'value'
			float Less(float x, float value)
			{
				return 1.0 - step(value, x);
			}

			// Will return a value of 1 if the 'x' is >= 'lower' && < 'upper'
			float Between(float x, float  lower, float upper)
			{
				return step(lower, x) * (1.0 - step(upper, x));
			}

			//	Will return a value of 1 if 'x' is >= value
			float GEqual(float x, float value)
			{
				return step(value, x);
			}

			fixed4 frag (v2f IN) : COLOR
			{
				float brightness = 1.25f;
				//IN.uv = IN.uv * 0.1f;
    
				half2 uvStep;
				uvStep.x = IN.uv.x / (1.0 / _ScreenParams.x);
				uvStep.x = fmod(uvStep.x, 3.0);
				uvStep.y = IN.uv.y / (1.0 / _ScreenParams.y);
				uvStep.y = fmod(uvStep.y, 3.0);
    
				fixed4 newColour = tex2D(_MainTex, IN.uv);
    
			#ifdef X_ONLY
				newColour.r = newColour.r * Less(uvStep.x, 1.0);
				newColour.g = newColour.g * Between(uvStep.x, 1.0, 2.0);
				newColour.b = newColour.b * GEqual(uvStep.x, 2.0);
			#endif
    
			#ifdef Y_ONLY
				newColour.r = newColour.r * Less(uvStep.y, 1.0);
				newColour.g = newColour.g * Between(uvStep.y, 1.0, 2.0);
				newColour.b = newColour.b * GEqual(uvStep.y, 2.0);
			#endif
    
			#ifdef X_AND_Y
				newColour.r = newColour.r * step(1.0, (Less(uvStep.x, 1.0) + Less(uvStep.y, 1.0)));
				newColour.g = newColour.g * step(1.0, (Between(uvStep.x, 1.0, 2.0) + Between(uvStep.y, 1.0, 2.0)));
				newColour.b = newColour.b * step(1.0, (GEqual(uvStep.x, 2.0) + GEqual(uvStep.y, 2.0)));
			#endif
    
				return newColour * brightness;
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}