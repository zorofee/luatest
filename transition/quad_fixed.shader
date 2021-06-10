
#DEFPARAMS
_MainTex = { "Main Color", TEXTURE2D, "maintex" },
x = {"X",FLOAT,"1.0"},
y = {"Y",FLOAT,"1.0"}
#END 

#DEFTAG
ShaderName = "FullScreenQuad"
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
#include "commonvar.inc"
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

Texture2D _MainTex;
SamplerState _MainSampler;
float x;
float y;

v2f vert(appdata v)
{
	v2f o;
	float4 pos = v.vertex * (1.0 / v.vertex.w);
	
	float4x4 scaleMat = {
        x,0,0,0,
        0,y,0,0,
        0,0,1,0,
		0,0,0,1
    };
	pos = mul(scaleMat, pos);
	pos = ObjectToClipPos(pos);

    o.vertex = UniformNDC(pos);

	o.uv = v.uv.xy;


	return o;
}

void frag(in v2f i, out float4 mainColor : SV_Target0)
{
	mainColor = _MainTex.Sample(_MainSampler, i.uv);
}
ENDCG
#END
