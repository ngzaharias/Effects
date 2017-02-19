Shader "Custom/Hatching" 
{
	Properties 
	{
		_Sample0Tex ("Sample 0 (RGB)", 2D) = "black" {}
		_Sample1Tex ("Sample 0 (RGB)", 2D) = "black" {}
		_Sample2Tex ("Sample 0 (RGB)", 2D) = "black" {}
		_Sample3Tex ("Sample 0 (RGB)", 2D) = "black" {}
		_Sample4Tex ("Sample 0 (RGB)", 2D) = "black" {}
		_Sample5Tex ("Sample 0 (RGB)", 2D) = "black" {}
	}

    SubShader 
	{
    Tags { "RenderType" = "Opaque" }
    CGPROGRAM
		#pragma surface surf Hatching
        
		struct Input 
		{
			float2 uv_Sample0Tex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo.xy = IN.uv_Sample0Tex;
		}

		sampler2D _Sample0Tex;
		sampler2D _Sample1Tex;
		sampler2D _Sample2Tex;
		sampler2D _Sample3Tex;
		sampler2D _Sample4Tex;
		sampler2D _Sample5Tex;
        
		inline half3 LerpSamples(sampler2D texA, half2 uvA,sampler2D texB, half2 uvB, half delta)
		{
			return lerp(tex2D(texA, uvA).rgb, tex2D(texB, uvB).rgb, delta).rgb;
		}

		half4 LightingHatching(inout SurfaceOutput s, half3 lightDir, half atten)
		{
			half2 uv = s.Albedo.xy;
			half4 colour = half4(0,0,0,0);

			half normalDotLight = dot (s.Normal, lightDir);
			half intensity = (_LightColor0.r + _LightColor0.g + _LightColor0.b) / 3.0f;
			intensity = intensity * normalDotLight * atten * 2.0f;
			intensity = saturate(intensity);

			half part = 1 / 6.0f;
			if(intensity <= part)
			{
				colour.rgb = LerpSamples(_Sample0Tex, uv, _Sample1Tex, uv, (intensity - part * 0) * 6);
				//colour.rgb = lerp(half3(1,0,0), half3(1,1,0), (intensity) * 6);
			}
			else if(intensity > part
			&& intensity <= part * 2)
			{
				colour.rgb = LerpSamples(_Sample1Tex, uv, _Sample2Tex, uv, (intensity - part * 1) * 6);
				//colour.rgb = lerp(half3(1,1,0), half3(0,1,0), (intensity - part) * 6);
			}
			else if(intensity > part * 2
			&& intensity <= part * 3)
			{
				colour.rgb = LerpSamples(_Sample2Tex, uv, _Sample3Tex, uv, (intensity - part * 2) * 6);
			}
			else if(intensity > part * 3
			&& intensity <= part * 4)
			{
				colour.rgb = LerpSamples(_Sample3Tex, uv, _Sample4Tex, uv, (intensity - part * 3) * 6);
			}
			else if(intensity > part * 4
			&& intensity <= part * 5)
			{
				colour.rgb = LerpSamples(_Sample4Tex, uv, _Sample5Tex, uv, (intensity - part * 4) * 6);
			}
			else
			{
				colour.rgb = lerp(tex2D(_Sample5Tex, uv), half4(1,1,1,1), (intensity - part * 5) * 6);
			}
			colour.a = s.Alpha;
			return colour;
		}

    ENDCG
    }
    Fallback "Diffuse"
}
