
function DefineParams()
	Properties = 
	{
		
_MainTex = { "Main Color", TEXTURE2D, "maintex" },
x = {"X",FLOAT,"1.0"},
y = {"Y",FLOAT,"1.0"}

	}
	Attributes = 
	{
	}
	
end
 


function Init()
	PassNames = 
	{
		"Always"
	}

ShaderName = "FullScreenQuad"
RenderQueue = "Transparent"
end

function Always()

COLOR_MASK = COLOR_RGBA
ALPAH_MODE = { ALPAH_BLEND, SRC_ALPHA, ONE_MINUS_SRC_ALPHA, ONE, ONE }
DRAW_MODE = { CULL_FACE_BACK, DEPTH_MASK_OFF, DEPTH_TEST_ON, DEPTH_FUNCTION_LESS }
STENCIL_MODE = { STENCIL_OFF }
LIGHT_MODE = { ALWAYS }


Programs =
{
	{
		shaderApi = "gles3",
		keyWords = {},
		vsBufferSize = "0",
		vsAttributes = {
		},
		vsUniforms = {
			{
				varName = "LOCALWORLD_TRANSFORM",
				varType = "float4x4",
				varSit = "",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
			{
				varName = "WORLD_POSITION",
				varType = "float3",
				varSit = "",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
			{
				varName = "DEVICE_COORDINATE_Y_FLIP",
				varType = "float",
				varSit = "",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
			{
				varName = "x",
				varType = "float",
				varSit = "",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
			{
				varName = "y",
				varType = "float",
				varSit = "",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
			},
		psBufferSize = "0",
		psUniforms = {
			{
				varName = "_MainTex",
				varType = "sampler2D",
				varSit = "",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
			},
		vsShader = [===[#version 300 es
in vec4 _glesVertex;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 LOCALWORLD_TRANSFORM;
uniform highp vec3 WORLD_POSITION;
uniform highp float DEVICE_COORDINATE_Y_FLIP;
uniform highp float x;
uniform highp float y;
out highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 pos_1;
  highp mat4 tmpvar_2;
  tmpvar_2[uint(0)].x = x;
  tmpvar_2[uint(0)].y = 0.0;
  tmpvar_2[uint(0)].z = 0.0;
  tmpvar_2[uint(0)].w = 0.0;
  tmpvar_2[1u].x = 0.0;
  tmpvar_2[1u].y = y;
  tmpvar_2[1u].z = 0.0;
  tmpvar_2[1u].w = 0.0;
  tmpvar_2[2u].x = 0.0;
  tmpvar_2[2u].y = 0.0;
  tmpvar_2[2u].z = 1.0;
  tmpvar_2[2u].w = 0.0;
  tmpvar_2[3u].x = 0.0;
  tmpvar_2[3u].y = 0.0;
  tmpvar_2[3u].z = 0.0;
  tmpvar_2[3u].w = 1.0;
  pos_1 = (tmpvar_2 * (_glesVertex * (1.0/(_glesVertex.w))));
  pos_1.xyz = (LOCALWORLD_TRANSFORM * pos_1).xyz;
  pos_1.w = 1.0;
  pos_1.xy = (pos_1.xy + WORLD_POSITION.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.xzw = vec3(1.0, 1.0, 1.0);
  tmpvar_3.y = DEVICE_COORDINATE_Y_FLIP;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  gl_Position = (tmpvar_3 * pos_1);
}

]===],
		psShader = [===[#version 300 es
layout(location=0) out mediump vec4 _glesFragData[1];
uniform sampler2D _MainTex;
in highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 mainColor_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture (_MainTex, xlv_TEXCOORD0);
  mainColor_1 = tmpvar_2;
  _glesFragData[0] = mainColor_1;
}

]===],
	},
}

end
