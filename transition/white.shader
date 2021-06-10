#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
#END 


#DEFTAG
ShaderName = "White"
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
    fixed4 white = fixed4(1.0, 1.0, 1.0, 1.0);
    fixed4 color;
    float p;
    if (_Progress < 0.5)
    {
        color = tex2D(_PrevTexture, i.uv) ;
        p = _Progress * 2.0 ;
    }
    else
    {
        color = tex2D(_NextTexture, i.uv) ;
        p = (1.0 - _Progress) * 2.0 ;
    }

    finalColor = lerp(color, white, p);
    return finalColor;  
} 

ENDCG
#END
