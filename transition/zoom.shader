#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
_TargetSize = {"target size", VEC2, "400.0,300.0"},
[Enum(far, 1, near,2)]
_Direction = {"direction",FLOAT,"1.0"},
#END


#DEFTAG
ShaderName = "Zoom"
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
float _Direction;
sampler2D _PrevTexture;
sampler2D _NextTexture;
float2 _TargetSize;

#define EPSILON 0.000001

float2 zoomFar(float2 uv, float amount){
    float2 UV = float2(0,0);
    int type = (int)_Direction;
    if (amount < 0.5 - EPSILON)
    {
        if(type == 1)
        {
            //far
            UV = 0.5 + ((uv - 0.5)*(1.0 + amount));
        }
        else
        {
            //near
            UV = 0.5 + ((uv - 0.5)*(1.0 - amount));
        }

    }else{
        if(type == 1)
        {
            //far
            UV = 0.5 + ((uv - 0.5)*(amount));
        }
        else
        {
            //near
            UV = 0.5 + ((uv - 0.5)*(2.0 - amount));
        } 
    }
    return UV;
}

float easeInOutQuint(float t)
{
    return t < 0.5 ? 16.0*t*t*t*t*t : 1.0 + 16.0*(--t)*t*t*t*t;
}


fixed3 blur(sampler2D tex, float2 uv, float time, float step){

    float2 dir = uv - 0.5;
    fixed3 color = fixed3(0,0,0);
    const int len = 10;

    for(int i= -len; i <= len; i++)
    {
        float2 blurCoord = uv + step * float(i) * 2.0 * time * dir ;
        blurCoord = abs(blurCoord);
        if(blurCoord.x > 1.0){
            blurCoord.x = 2.0 - blurCoord.x; 
        }
        if(blurCoord.y > 1.0){
            blurCoord.y = 2.0 - blurCoord.y;
        }
        color += tex2D(tex, blurCoord).rgb;
    }
    color /= fixed( 2 * len + 1);

    return color;
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
	float4 fragColor;
    float pixelStep = 5.0 / float(_TargetSize.x) ;
    float p = easeInOutQuint(_Progress);

    float2 uv = zoomFar(i.uv, p);

    if (p < 0.5)
    {
        fixed3 colorA = blur(_PrevTexture, uv, p, pixelStep).rgb;
        fragColor = fixed4(colorA, 1.0);
    }
    else
    {
        fixed3 colorB = blur(_NextTexture, uv, 1.0 - p, pixelStep).rgb; 
        fragColor = fixed4(colorB, 1.0);
    }
	return fragColor; 
} 

ENDCG
#END
