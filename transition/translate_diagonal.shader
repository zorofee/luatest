#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
_TargetSize = {"target size", VEC2, "400.0,300.0"},
[Enum(leftdown, 1, leftup, 2, rightdown, 3, rightup, 4)]
_Direction = {"direction",FLOAT,"1.0"},
#END


#DEFTAG
ShaderName = "UvTranslateDiagonal"
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

float2 DirectionMove(float2 startCoord, float2 maxMoveDirection, float percent)
{
	float2 targetCoord = startCoord + maxMoveDirection * percent;
    return targetCoord;
}


fixed3 directionBlur(sampler2D tex, float2 resolution, float2 uv, float2 directionOfBlur, float percent)
{
	const float MAX_STEP = 3.0 ;

	float2 normalDirect = normalize(directionOfBlur);

	float2 pixelStepReal = normalDirect * MAX_STEP * percent;

    float2 pixelStep = pixelStepReal / resolution ;

	fixed3 color;

	int NUM = 8 ;

	for(int i = -NUM; i <= NUM; i++)
	{  
		float2 newCoord = uv + pixelStep * float(i) ; 

		newCoord = abs(newCoord);
		if(newCoord.x > 1.0)
			newCoord.x = 1.0 - frac(newCoord.x);
		if(newCoord.y > 1.0)
	   		newCoord.y = 1.0 - frac(newCoord.y);

	   	color += tex2D(tex, newCoord).rgb;
	}

	color /= fixed(2 * NUM + 1); 

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
	float2 realCoord = i.uv * _TargetSize; 

	float t = easeInOutCubic(_Progress);

	fixed3 result;

	fixed2 direction = fixed2(0,0);

	int signX = -sign(_Direction-2.5 );  //1,2取 1，3,4取-1
	int signY = -sign(int(_Direction)%2 * 2 -1); //1,3 取 -1 ；2,4取1

	direction = fixed2(_TargetSize.x *signX, _TargetSize.y * signY);

	if(t <= 0.5) 
	{
		realCoord = DirectionMove(realCoord, direction, t * 2.0 );
		float2 uv = realCoord / _TargetSize;
		result = directionBlur(_PrevTexture, _TargetSize, uv, direction, t * 2.0 );
	}
	else if(t > 0.5 && t <= 1.0)
	{
		realCoord = realCoord - _TargetSize;
		realCoord = DirectionMove(realCoord, direction,  (t - 0.5) * 2.0 );
		float2 uv = realCoord / _TargetSize;
		result = directionBlur(_NextTexture, _TargetSize, uv, direction, (1.0 - t) * 2.0);
	}
	else if(t > 1.0)
	{
		result = tex2D(_NextTexture, i.uv).rgb;
	}

    return fixed4(result,1.0);
} 
 
ENDCG
#END
