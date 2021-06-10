#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
_TargetSize = {"target size", VEC2, "400.0,300.0"},
[Enum(anticlockwise, 1, clockwise, 2)]
_Direction = {"direction",FLOAT,"1.0"},
#END 


#DEFTAG
ShaderName = "rotate"
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
float2 _TargetSize;
float _Direction;
 
#define PI 3.14159265

float easeInOutCubic(float x)
{
	return x < 0.5 ? 4.0 * x * x * x : 1.0 - pow( -2.0 * x + 2.0, 3.0 ) / 2.0;
}

float2 rotate(float2 curCoord, float2 center , float rad)
{
	float2 curCoord_base_center = curCoord - center;

    float c = cos(rad);
    float s = sin(rad);

	int type = (int)_Direction;
 	float2x2 rotateMat;
	if(type == 1)
	{
 	 	rotateMat= float2x2(c, s,
						-s, c) ; 
	}
	else
	{
		rotateMat= float2x2(c, -s,
						 s, c) ; 
	}
    

    float2 updateCoord_base_center = mul(curCoord_base_center,rotateMat) ;

	float2 updateCoord =  updateCoord_base_center + center;

    return updateCoord;
}

fixed3 rotateBlur(sampler2D tex, float2 center, float2 resolution, float2 curCoord, float intensity)
{
	float2 curCoordBaseCenter = curCoord - center;
	float r = length(curCoordBaseCenter);
	float angle = atan2(curCoordBaseCenter.y, curCoordBaseCenter.x);

	int NUM = 12;

	float STEP = 0.01;

	fixed3 color = fixed3(0,0,0);
	for(int i = 0; i < NUM; i++)
	{
	   angle += (STEP * intensity);

	   float  new_x = r * cos(angle) + center.x;
	   float  new_y = r * sin(angle) + center.y;

	   new_x = abs(new_x);
	   if(new_x > resolution.x)
	   		new_x = resolution.x - modf(new_x, resolution.x);

	   new_y = abs(new_y);
	   if(new_y > resolution.y)
	   		new_y = resolution.y - modf(new_y, resolution.y);

	   color += tex2D(tex, float2(new_x, new_y)/resolution).rgb;
	}

	color /= fixed(NUM);

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
	fixed4 finalColor;
	float2 realCoord = i.uv * _TargetSize;
	float2 rotateCenter = _TargetSize * 0.5;

	float p = easeInOutCubic(_Progress);

	fixed3 resultColor = fixed3(0,0,0);

	realCoord = rotate(realCoord, rotateCenter, p * PI * 2.0);

	if(p <= 0.5)
	{
		resultColor = rotateBlur(_PrevTexture, rotateCenter, _TargetSize, realCoord, p * 2.0);
	}
	else if(p > 0.5 && p <= 1.0)
	{
		resultColor = rotateBlur(_NextTexture, rotateCenter, _TargetSize, realCoord, (1.0 - p) * 2.0);
	}
	else
	{
		resultColor = tex2D(_NextTexture, i.uv).rgb;
	}

	finalColor = fixed4(resultColor,1.0); 
    return finalColor;
} 

ENDCG
#END
