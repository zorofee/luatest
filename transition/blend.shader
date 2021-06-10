#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
#END


#DEFTAG
ShaderName = "Blend"
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
Texture2D _PrevTexture;
Texture2D _NextTexture;
SamplerState _PrevTexture_Sampler;
SamplerState _NextTexture_Sampler;
 
v2f vert(appdata v)
{
	v2f o;
	o.vertex = UniformNDC(v.vertex);
	o.uv = v.uv.xy;
	return o;
}

void frag(in v2f i, out float4 mainColor : SV_Target0)
{
    //fixed4 prev = tex2D(_PrevTexture, i.uv);
    //fixed4 next = tex2D(_NextTexture,  i.uv);
    //fixed4 result = lerp(prev, next, _Progress);
	//mainColor = fixed4(result.rgb, 1.0);
	float3 prev = _PrevTexture.Sample(_PrevTexture_Sampler, i.uv).xyz;
	float3 next = _NextTexture.Sample(_NextTexture_Sampler, i.uv).xyz;
	float3 result = lerp(prev, next, _Progress);
	mainColor = float4(result.xyz, 1.0);
} 

ENDCG
#END
