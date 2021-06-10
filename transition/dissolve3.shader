#DEFPARAMS
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
#END


#DEFTAG
ShaderName = "Dissolve3"
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

 
float ease20(float t) 
{
	return t == 0.0 || t == 1.0 ? t
			: t < 0.5 ? 0.5 * pow(2.0, (20.0 * t) - 10.0)
			: 1.0 - 0.5 * pow(2.0, 10.0 - (t * 20.0)) ;
}

float ease10(float t)
{
	return t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);
}

float2 displace(float4 texColor, float2 texCoord, float dotDepth, float depth, float strength)
{
	float4 dis = texColor * dotDepth - texColor * depth + 1.0 ;
	dis.x = dis.x - 1.0 + depth * dotDepth;
	dis.y = dis.y - 1.0 + depth * dotDepth;
	dis = dis * strength ;
	float2 res_uv = texCoord ; 
	res_uv.x = res_uv.x + dis.x ;
	res_uv.y = res_uv.y + dis.y ;
	return res_uv;
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
	fixed4 sColor1 = tex2D(_PrevTexture, i.uv);
	fixed4 sColor2 = tex2D(_NextTexture, i.uv);

	float p1 = ease20(_Progress);
	float p2 = ease10(_Progress);

	float2 texCoord1 = displace(sColor1, i.uv, 0.33, 0.6, 1.0 - p1);
	float2 texCoord2 = displace(sColor2, i.uv, 0.33, 0.4, p2 );

	fixed4 dColor1 = tex2D(_NextTexture, texCoord1); // prev
	fixed4 dColor2 = tex2D(_PrevTexture, texCoord2); // next

	fixed3 temp = min(dColor1, dColor2).rgb ;
	float gray =  dot(temp, fixed3(0.299, 0.587, 0.114)) ;
	gray *= 2.0 ;
	dColor2 = fixed4(gray, gray, gray,  1.0);

	sColor1 = lerp(sColor1, dColor2, smoothstep(0.0, 0.5, _Progress));
	sColor2 = lerp(sColor2, dColor1, smoothstep(1.0, 0.5, _Progress));
	fixed4 fragColor = lerp(sColor1, sColor2, p1);
    return fragColor;  
} 
 
ENDCG
#END
