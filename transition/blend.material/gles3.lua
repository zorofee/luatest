function DefineParams()
	Properties = 
	{
		
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},

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

ShaderName = "Blend"
RenderQueue = "Transparent"
end

function Always()

COLOR_MASK = COLOR_RGBA
ALPAH_MODE = { ALPAH_OFF }
DRAW_MODE = { CULL_FACE_OFF, DEPTH_MASK_OFF, DEPTH_TEST_OFF }
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
				varName = "DEVICE_COORDINATE_Y_FLIP",
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
				varName = "_Progress",
				varType = "float",
				varSit = "",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
			{
				varName = "_PrevTexture",
				varType = "sampler2D",
				varSit = "",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
			{
				varName = "_NextTexture",
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
uniform highp float DEVICE_COORDINATE_Y_FLIP;
out highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xzw = vec3(1.0, 1.0, 1.0);
  tmpvar_1.y = DEVICE_COORDINATE_Y_FLIP;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  gl_Position = (tmpvar_1 * _glesVertex);
}

]===],
		psShader = [===[#version 300 es
layout(location=0) out mediump vec4 _glesFragData[1];
uniform highp float _Progress;
uniform sampler2D _PrevTexture;
uniform sampler2D _NextTexture;
in highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 result_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture (_PrevTexture, xlv_TEXCOORD0);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture (_NextTexture, xlv_TEXCOORD0);
  highp vec4 tmpvar_4;
  tmpvar_4 = mix (tmpvar_2, tmpvar_3, vec4(_Progress));
  result_1 = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = result_1.xyz;
  _glesFragData[0] = tmpvar_5;
}

]===],
	},
}

end
