#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_MaskTexture = {"mask texture",TEXTURE2D,"nexttex"},

#END

#DEFTAG
ShaderName = "MaskBlend"
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

sampler2D _PrevTexture;
sampler2D _NextTexture;
sampler2D _MaskTexture;
 
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
    finalColor = tex2D(_PrevTexture,i.uv)*(1-tex2D(_MaskTexture,i.uv).r) + 
                    tex2D(_NextTexture,i.uv)*tex2D(_MaskTexture,i.uv).r;
    return finalColor;
} 
ENDCG 
#END 
