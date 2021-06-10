#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
#END


#DEFTAG
ShaderName = "crosszoom"
RenderQueue = "Transparent"
#END

#DEFPASS Always
COLOR_MASK = COLOR_RGBA
ALPAH_MODE = { ALPAH_OFF }
DRAW_MODE = { CULL_FACE_OFF, DEPTH_MASK_OFF, DEPTH_TEST_OFF }
STENCIL_MODE = { STENCIL_OFF }
LIGHT_MODE = { ALWAYS }

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "common.inc"

struct appdata
{
	float4 vertex : POSITION;
	float2 uv : TEXCOORD0;
};

struct v2f
{
	float2 uv : TEXCOORD0; 
	float4 vertex : SV_POSITION;
};

float _Progress;
sampler2D _PrevTexture;
sampler2D _NextTexture;


#define STRENGTH 0.3
#define PI 3.141592653589793

float random(float2 uv,float3 scale, float seed) {
    return frac(sin(dot(float3(uv,1.0) + seed, scale)) * 43758.5453 + seed);
}

float3 crossFade(float2 uv, float dissolve) {
    return lerp(tex2D(_PrevTexture, uv).rgb,
                tex2D(_NextTexture, uv).rgb,
                dissolve);
}

float Linear_ease(float begin, float change, float duration, float time)
{
    return change * time / duration + begin;
}

float Exponential_easeInOut(float begin, float change, float duration, float time)
{
    if (time == 0.0)
        return begin;
    else if (time == duration)
        return begin + change;
    time = time / (duration / 2.0);
    if (time < 1.0)
        return change / 2.0 * pow(2.0, 10.0 * (time - 1.0)) + begin;
    return change / 2.0 * (-pow(2.0, -10.0 * (time - 1.0)) + 2.0) + begin;
}

float Sinusoidal_easeInOut(float begin, float change, float duration, float time)
{
     return -change / 2.0 * (cos(PI * time / duration) - 1.0) + begin;
     //return -0.3 / 2.0 * (cos(3.14 * _Progress / 0.5) - 1.0) + begin;
}
 
v2f vert(appdata v)
{
	v2f o; 
	o.vertex = UniformNDC(v.vertex);
	o.uv = v.uv.xy;
	return o;
}

fixed4 frag(v2f i) : SV_Target
{
    fixed4 finalColor;
    float2 center = float2(Linear_ease(0.25, 0.5, 1.0, _Progress), 0.5);
    float dissolve = Exponential_easeInOut(0.0, 1.0, 1.0, _Progress);
    float strength = Sinusoidal_easeInOut(0.0, STRENGTH, 0.5, _Progress);

    fixed3 color = fixed3(0,0,0);
    float total = 0.0;
    float2 toCenter = center - i.uv;

    float offset = random(i.uv,float3(12.9898, 78.233, 151.7182), 0.0);

    for (float t = 0.0; t <= 40.0; t++) {
        float percent = (t + offset) / 40.0;
        float weight = 4.0 * (percent - percent * percent);
        color += crossFade(i.uv + toCenter * percent * strength, dissolve) * weight;
        total += weight;
    }
    finalColor = fixed4(color / total, 1.0);
    return finalColor;     
}  

ENDCG
#END
