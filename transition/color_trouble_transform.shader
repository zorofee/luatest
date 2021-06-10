#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
#END


#DEFTAG
ShaderName = "colortrouble"
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


float random1d(float n)
{
    return frac(sin(n) * 43758.5453);
}

float random2d(float2 n)
{
    return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453);
}

float random2dRange(in float2 seed, in float min, in float max)
{
    return min + random2d(seed) * (max - min);
}

//  bottom <= v < top 返回1
float isInRange(float v, float bottom, float top) 
{
    return step(bottom, v) - step(top, v);
}

 
float4 colorful(sampler2D m_texture,float2 uv, float p )
{
    float speed  = 0.2 * p ;  // 0.2 -> 0
    float amount = 0.8 * p;   // 0.8 -> 0
    float time =  _Progress * speed * 145.0 ;
    float3 color = tex2D(m_texture, uv).rgb;
    float maxOffset = amount / 2.0;

    for (float i = 0.0; i <= 10.0 * amount ; i += 1.0)
    {
        float sliceY = random2d(float2(time , 5517.0 + float(i)));
        float sliceH = random2d(float2(time , 9525.0 + float(i))) * 0.20;
        if (isInRange(uv.y, sliceY, frac(sliceY + sliceH)) == 1.0)
        {
            float hOffset = random2dRange(float2(time , 9177.0 + float(i)), -maxOffset, maxOffset);
            float2 uvOff = uv;
            uvOff.x += hOffset; //  left of right on x axis
            uvOff = frac(uvOff); // make it 0~1
            color = tex2D(m_texture, uvOff).rgb;
        } 
    }

    float maxColOffset = amount / 6.0;
    float2 colOffset = float2(
                        random2dRange(float2(time, 3515.0), -maxColOffset, maxColOffset),
                        random2dRange(float2(floor(time), 7525.0), -maxColOffset, maxColOffset));
    float2 coluv = frac(uv + colOffset);

    float which = random2d(float2(time, 9145.0));
    if (which < 0.33) {
        color.r = tex2D(m_texture, coluv).r;
    } else if (which < 0.66) {
        color.g = tex2D(m_texture, coluv).g;
    } else {
        color.b = tex2D(m_texture, coluv).b;
    } 
    return float4(color, 1.0);
}

 
v2f vert(appdata v)
{
	v2f o;
	float4 pos = v.vertex * (1.0 / v.vertex.w);
	pos = mul(LOCALWORLD_TRANSFORM, pos);
	pos.w = 1.0;
	pos.x = pos.x + WORLD_POSITION.x;
	pos.y = pos.y + WORLD_POSITION.y;
	o.vertex = pos;
  o.vertex = UniformNDC(o.vertex);
	//o.vertex = v.vertex;
	o.uv = v.uv.xy;


	return o;
}

fixed4 frag(v2f i) : SV_Target
{
    fixed4 finalColor;
    if (_Progress >= 0.5){
        finalColor = colorful(_NextTexture,i.uv, 1.0 - clamp(_Progress, 0.0, 1.0));
    }else{
        finalColor = colorful(_PrevTexture,i.uv,clamp(_Progress, 0.0, 1.0));
    }
    return finalColor;     
} 

ENDCG
#END
