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

ShaderName = "Dissolve1"
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
		shaderApi = "opengl",
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
uniform float DEVICE_COORDINATE_Y_FLIP;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xzw = vec3(1.0, 1.0, 1.0);
  tmpvar_1.y = DEVICE_COORDINATE_Y_FLIP;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  gl_Position = (tmpvar_1 * _glesVertex);
}

]===],
		psShader = [===[uniform float _Progress;
uniform sampler2D _PrevTexture;
uniform sampler2D _NextTexture;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_PrevTexture, xlv_TEXCOORD0);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_NextTexture, xlv_TEXCOORD0);
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix (tmpvar_2, tmpvar_1, vec4(clamp ((
    (abs(((
      ((tmpvar_2.x + tmpvar_2.y) + tmpvar_2.z)
     / 3.0) - (
      ((tmpvar_1.x + tmpvar_1.y) + tmpvar_1.z)
     / 3.0))) - _Progress)
   / 
    (_Progress + 1e-6)
  ), 0.0, 1.0))).xyz;
  gl_FragData[0] = tmpvar_3;
}

]===],
	},
}

end
