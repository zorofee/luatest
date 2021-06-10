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

ShaderName = "Dissolve2"
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
		shaderApi = "gles2",
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
		vsShader = [===[attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp float DEVICE_COORDINATE_Y_FLIP;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xzw = vec3(1.0, 1.0, 1.0);
  tmpvar_1.y = DEVICE_COORDINATE_Y_FLIP;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  gl_Position = (tmpvar_1 * _glesVertex);
}

]===],
		psShader = [===[uniform highp float _Progress;
uniform sampler2D _PrevTexture;
uniform sampler2D _NextTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 fragColor_1;
  highp vec2 offset_2;
  highp vec2 offset2_3;
  highp vec2 offset1_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_PrevTexture, xlv_TEXCOORD0);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_NextTexture, xlv_TEXCOORD0);
  lowp vec2 tmpvar_7;
  tmpvar_7 = ((tmpvar_5.x + tmpvar_5.yz) - 1.0);
  offset1_4 = tmpvar_7;
  lowp vec2 tmpvar_8;
  tmpvar_8 = ((tmpvar_6.x + tmpvar_6.yz) - 1.0);
  offset2_3 = tmpvar_8;
  offset_2 = (((offset1_4 * 0.5) + (offset2_3 * 0.5)) * 0.1);
  lowp vec4 tmpvar_9;
  highp vec2 P_10;
  P_10 = (xlv_TEXCOORD0 + (offset_2 * _Progress));
  tmpvar_9 = texture2D (_PrevTexture, P_10);
  lowp vec4 tmpvar_11;
  highp vec2 P_12;
  P_12 = (xlv_TEXCOORD0 - (offset_2 * (1.0 - _Progress)));
  tmpvar_11 = texture2D (_NextTexture, P_12);
  highp vec4 tmpvar_13;
  tmpvar_13 = mix (tmpvar_9, tmpvar_11, vec4(_Progress));
  fragColor_1 = tmpvar_13;
  gl_FragData[0] = fragColor_1;
}

]===],
	},
}

end
