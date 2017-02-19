Shader "Custom/Hatching2" 
{
	Properties 
	{
		_Samples ("Sample Count", Float) = 6
		_SampleTex ("Sample Texture", 2D) = "white" {}
	}

    SubShader 
	{
    Tags { "RenderType" = "Opaque" }
    CGPROGRAM
		#pragma surface surf Hatching
        
		struct Input 
		{
			float2 uv_SampleTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo.xy = IN.uv_SampleTex;
		}

		half _Samples;
		sampler2D _SampleTex;
        
		inline half3 LerpSamples(sampler2D tex, half2 uvA, half2 uvB, half delta)
		{
			return lerp(tex2D(tex, uvA).rgb, tex2D(tex, uvB).rgb, delta).rgb;
		}

		half4 LightingHatching(inout SurfaceOutput s, half3 lightDir, half atten)
		{
			half2 uv = s.Albedo.xy;
			half2 uv0 = uv, uv1 = uv, uv2 = uv, uv3 = uv, uv4 = uv, uv5 = uv;
			uv.x = uv.x / _Samples;

			uv0.x = uv.x * 1.0f;
			uv1.x = uv.x * 2.0f;
			uv2.x = uv.x * 3.0f;
			uv3.x = uv.x * 4.0f;
			uv4.x = uv.x * 5.0f;
			uv5.x = uv.x * 6.0f;

			half4 colour = half4(0,0,0,0);

			half normalDotLight = dot (s.Normal, lightDir);
			half intensity = (_LightColor0.r + _LightColor0.g + _LightColor0.b) / 3.0f;
			intensity = intensity * normalDotLight * atten * 2.0f;
			intensity = saturate(intensity);

			half part = 1 / _Samples;
			if(intensity <= part)
			{
				colour.rgb = LerpSamples(_SampleTex, uv0, uv1, (intensity - part * 0) * 6);
			}
			else if(intensity > part
			&& intensity <= part * 2)
			{
				colour.rgb = LerpSamples(_SampleTex, uv1, uv2, (intensity - part * 1) * 6);
			}
			else if(intensity > part * 2
			&& intensity <= part * 3)
			{
				colour.rgb = LerpSamples(_SampleTex, uv2, uv3, (intensity - part * 2) * 6);
			}
			else if(intensity > part * 3
			&& intensity <= part * 4)
			{
				colour.rgb = LerpSamples(_SampleTex, uv3, uv4, (intensity - part * 3) * 6);
			}
			else if(intensity > part * 4
			&& intensity <= part * 5)
			{
				colour.rgb = LerpSamples(_SampleTex, uv4, uv5, (intensity - part * 4) * 6);
			}
			else if(intensity > part * 5)
			{
				colour.rgb = lerp(tex2D(_SampleTex, uv5), half4(1,1,1,1), (intensity - part * 5) * 6);
			}
			colour.a = s.Alpha;
			return colour;
		}

    ENDCG
    }
    Fallback "Diffuse"
}
