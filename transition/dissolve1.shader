#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
#END


#DEFTAG
ShaderName = "Dissolve1"
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
	fixed4 prev = tex2D(_PrevTexture, i.uv);
	fixed4 next = tex2D(_NextTexture, i.uv);

	float diff = abs((next.r + next.g + next.b)/3.0 - (prev.r + prev.g + prev.b)/3.0);
	float alpha = clamp((diff-_Progress)/(_Progress + 0.000001), 0.0, 1.0); // alpha 1->0

	fixed4 resultColor = lerp(next, prev, alpha);
	fixed4 fragColor = fixed4(resultColor.rgb, 1.0);
    return fragColor;  
} 
 
ENDCG
#END
