
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
		shaderApi = "opengl",
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
		vsShader = [===[attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform mat4 LOCALWORLD_TRANSFORM;
uniform vec3 WORLD_POSITION;
uniform float DEVICE_COORDINATE_Y_FLIP;
uniform float x;
uniform float y;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  vec4 pos_1;
  mat4 tmpvar_2;
  tmpvar_2[0].x = x;
  tmpvar_2[0].y = 0.0;
  tmpvar_2[0].z = 0.0;
  tmpvar_2[0].w = 0.0;
  tmpvar_2[1].x = 0.0;
  tmpvar_2[1].y = y;
  tmpvar_2[1].z = 0.0;
  tmpvar_2[1].w = 0.0;
  tmpvar_2[2].x = 0.0;
  tmpvar_2[2].y = 0.0;
  tmpvar_2[2].z = 1.0;
  tmpvar_2[2].w = 0.0;
  tmpvar_2[3].x = 0.0;
  tmpvar_2[3].y = 0.0;
  tmpvar_2[3].z = 0.0;
  tmpvar_2[3].w = 1.0;
  pos_1 = (tmpvar_2 * (_glesVertex * (1.0/(_glesVertex.w))));
  pos_1.xyz = (LOCALWORLD_TRANSFORM * pos_1).xyz;
  pos_1.w = 1.0;
  pos_1.xy = (pos_1.xy + WORLD_POSITION.xy);
  vec4 tmpvar_3;
  tmpvar_3.xzw = vec3(1.0, 1.0, 1.0);
  tmpvar_3.y = DEVICE_COORDINATE_Y_FLIP;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  gl_Position = (tmpvar_3 * pos_1);
}

]===],
		psShader = [===[uniform sampler2D _MainTex;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  gl_FragData[0] = texture2D (_MainTex, xlv_TEXCOORD0);
}

]===],
	},
}

end
