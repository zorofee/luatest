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

ShaderName = "crosszoom"
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
  vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  float offset_3;
  vec2 toCenter_4;
  float total_5;
  vec3 color_6;
  float strength_7;
  float dissolve_8;
  vec2 tmpvar_9;
  tmpvar_9.y = 0.5;
  tmpvar_9.x = ((0.5 * _Progress) + 0.25);
  float time_10;
  time_10 = _Progress;
  bool tmpvar_11;
  tmpvar_11 = bool(1);
  float tmpvar_12;
  if ((_Progress == 0.0)) {
    tmpvar_12 = 0.0;
    tmpvar_11 = bool(0);
  } else {
    if ((_Progress == 1.0)) {
      tmpvar_12 = 1.0;
      tmpvar_11 = bool(0);
    };
  };
  if (tmpvar_11) {
    time_10 = (_Progress / 0.5);
    if ((time_10 < 1.0)) {
      tmpvar_12 = (0.5 * exp2((10.0 * 
        (time_10 - 1.0)
      )));
      tmpvar_11 = bool(0);
    } else {
      tmpvar_12 = (0.5 * (-(
        exp2((-10.0 * (time_10 - 1.0)))
      ) + 2.0));
      tmpvar_11 = bool(0);
    };
  };
  dissolve_8 = tmpvar_12;
  strength_7 = (-0.15 * (cos(
    ((3.141593 * _Progress) / 0.5)
  ) - 1.0));
  color_6 = vec3(0.0, 0.0, 0.0);
  total_5 = 0.0;
  toCenter_4 = (tmpvar_9 - xlv_TEXCOORD0);
  vec3 tmpvar_13;
  tmpvar_13.z = 1.0;
  tmpvar_13.xy = xlv_TEXCOORD0;
  offset_3 = fract((sin(
    dot (tmpvar_13, vec3(12.9898, 78.233, 151.7182))
  ) * 43758.55));
  for (float t_2 = 0.0; t_2 <= 40.0; t_2 += 1.0) {
    float tmpvar_14;
    tmpvar_14 = ((t_2 + offset_3) / 40.0);
    float tmpvar_15;
    tmpvar_15 = (4.0 * (tmpvar_14 - (tmpvar_14 * tmpvar_14)));
    vec2 uv_16;
    uv_16 = (tmpvar_1 + ((toCenter_4 * tmpvar_14) * strength_7));
    color_6 = (color_6 + (mix (texture2D (_PrevTexture, uv_16).xyz, texture2D (_NextTexture, uv_16).xyz, vec3(dissolve_8)) * tmpvar_15));
    total_5 = (total_5 + tmpvar_15);
  };
  vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (color_6 / total_5);
  gl_FragData[0] = tmpvar_17;
}

]===],
	},
}

end
