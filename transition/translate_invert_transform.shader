#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
_TargetSize = {"target size", VEC2, "400.0,300.0"},
[Enum(up, 1, down, 2, left, 3, right, 4)]
_Direction = {"direction",FLOAT,"1.0"},
#END


#DEFTAG
ShaderName = "UvTranslateInvert"
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

float easeInOutQuint(float t)
{
    return t<0.5 ? 16.0*t*t*t*t*t : 1.0+16.0*(--t)*t*t*t*t;
}

fixed GuassWeight(fixed dist)
{
    return exp(-dist*dist/400.0);
}

fixed4 colorful(sampler2D tex, float2 uv , float p1)
{
    const int RADIUS = 15;
    float STEP_SIZE = 1.250;

    fixed half_gaussian_weight[RADIUS + 1];

    for(int i=0; i<= RADIUS; i++)
    {
        half_gaussian_weight[i] = GuassWeight(fixed(i));
    }

    fixed3 sum            = fixed3(0,0,0);
    fixed3 result         = fixed3(0,0,0);

    float2 unit_uv = float2(1.0/_TargetSize.x, 1.0/_TargetSize.y) * STEP_SIZE * p1;


    fixed3 centerColor = tex2D(tex, uv).rgb ;
    fixed3 centerPixel = centerColor * half_gaussian_weight[0];
    fixed sum_weight = half_gaussian_weight[0];

    for(int i = 1; i <= RADIUS; i++)
    {
        float2 topCoord    = uv + float2(0.0, float(i))  * unit_uv;
        float2 bottomCoord  = uv + float2(0.0, float(-i)) * unit_uv;

        fixed3 topColor = tex2D(tex, topCoord).rgb ;
        fixed3 bottomColor = tex2D(tex, bottomCoord).rgb ;

        sum += topColor * half_gaussian_weight[i];
        sum += bottomColor * half_gaussian_weight[i];

        sum_weight += half_gaussian_weight[i] * 2.0;
    }

    result = (sum + centerPixel)/sum_weight;


    return fixed4(result, 1.0);
}

v2f vert(appdata v)
{
	v2f o;
	float4 pos = v.vertex * (1.0 / v.vertex.w);
	pos = mul(LOCALWORLD_TRANSFORM, pos);
	pos.w = 1.0;
	pos.x = pos.x + WORLD_POSITION.x;
	pos.y = pos.y + WORLD_POSITION.y;
	o.vertex = pos;
  o.vertex = UniformNDC(o.vertex);
	//o.vertex = v.vertex;
	o.uv = v.uv.xy;


	return o;
}
 
 //UP,DOWN,LEFT,RIGHT
fixed4 frag(v2f i) : SV_Target
{
	fixed4 fragColor;
    float x = i.uv.x;
    float y = i.uv.y;
    int type = (int)_Direction;
    float p = easeInOutQuint(_Progress);
    float p1 = 0;
    if (p < 0.5)
    {
        p1 = clamp(p * 2.0,  0.0,  1.0);
        if(type == 1)
        {
            //up 
            y += p1 ;
            if (y > 1.0) {
                y = 2.0 - y;
            }
        }
        else if(type == 2)
        {
            //down
            y -= p1 ;
            y = abs(y);
        }
        else if(type == 3)
        {
            //left
            x += p1 ;
            if (x > 1.0) {
                x = 2.0 - x  ;
            }
        }
        else if(type == 4)
        {
            //right
            x -= p1 ;
            x = abs(x);
        }

        fragColor = colorful(_PrevTexture, float2(x,y), p1);
    }
    else
    {
        p1 = (p - 0.5) * 2.0;
        if(type == 1)
        {
            //up
            y += p1 ;
            if (y > 1.0) {
                y = 2.0 - y ;
            }
            y = 1.0 -  y ;
        }
        else if(type ==2)
        {
            //down
            y -= p1 ;
            y = abs(y);
            y = 1.0 -  y;
        }
        else if(type == 3) 
        {
            //left 
            x += p1 ;
            if (x > 1.0) {
                x = 2.0 - x ;
            }
            x = 1.0 - x ;
        }
        else if(type == 4)
        {
            //right
            x -= p1 ;
            x = abs(x);
            x = 1.0 - x ;
        }
      
        fragColor = colorful(_NextTexture, float2(x,y), (1.0-p1)); 
    }
    return fragColor;  
} 
ENDCG 
#END
