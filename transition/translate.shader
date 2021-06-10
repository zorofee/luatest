#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
[Enum(up, 1, down, 2, left, 3, right, 4)]
_Direction = {"direction",FLOAT,"1.0"},
#END


#DEFTAG 
ShaderName = "UVTransform"
RenderQueue = "Transparent"
#END

#DEFPASS Always
COLOR_MASK = COLOR_RGBA
ALPAH_MODE = { ALPAH_BLEND, SRC_ALPHA, ONE_MINUS_SRC_ALPHA, ONE, ONE }
DRAW_MODE = { CULL_FACE_BACK, DEPTH_MASK_OFF, DEPTH_TEST_ON, DEPTH_FUNCTION_LESS }
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
float2 TARGETSIZE;
float _Direction;

float getProgress(float t)
{
    return t<0.5 ? 16.0*t*t*t*t*t : 1.0+16.0*(--t)*t*t*t*t;
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
	fixed4 fragColor; 
    float2 uvPrev,uvNext;
    float compare,p = getProgress(_Progress);
    int type = (int)_Direction;
    if(type == 1)
    {
        //up
        compare = i.uv.y - (1.0 -p);
        uvPrev = i.uv + float2(0,p);
        uvNext =  i.uv - float2(0,1.0 -p);
    }
    else if(type == 2)
    {
        //down
        compare = p - i.uv.y;
        uvPrev = i.uv - float2(0,getProgress(_Progress));
        uvNext = i.uv + float2(0,(1.0 -p));
    }
    else if(type == 3)
    {
        //left
        compare = i.uv.x - (1.0 - p);
        uvPrev = i.uv + float2(getProgress(_Progress),0);
        uvNext =  i.uv - float2(1.0 -p,0);
    }
    else if(type == 4)
    {
        //right
        compare = p - i.uv.x;
        uvPrev = i.uv - float2(getProgress(_Progress),0);
        uvNext = i.uv + float2((1.0 -p),0);
    }

    if(compare>0)
    {
        fragColor = tex2D(_NextTexture, uvNext); 
    }
    else
    {
        fragColor = tex2D(_PrevTexture,  uvPrev);
    }
	return fragColor; 
}
 
ENDCG
#END
