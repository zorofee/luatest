#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
#END


#DEFTAG
ShaderName = "Dissolve2"
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
	fixed4 base1 = tex2D(_PrevTexture, i.uv);
	fixed4 base2 = tex2D(_NextTexture, i.uv);

	float2 offset1 = (((base1.r+base1.gb) *0.5) * 2.0 - 1.0);
	float2 offset2 = (((base2.r+base2.gb) *0.5) * 2.0 - 1.0); 
	float2 offset = offset1 * 0.5 + offset2 * 0.5 ;
	offset = offset * 0.1; // -1~1 -> -0.1~+0.1

	float p0 = _Progress;
	float p1 = 1.0 - p0;
	fixed4 prev = tex2D(_PrevTexture, i.uv + offset * p0) ;
	fixed4 next = tex2D(_NextTexture, i.uv - offset * p1);
	fixed4 fragColor = lerp(prev, next, _Progress);
    return fragColor;  
} 
 
ENDCG
#END
