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
  highp vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  highp float offset_3;
  highp vec2 toCenter_4;
  highp float total_5;
  lowp vec3 color_6;
  highp float strength_7;
  highp float dissolve_8;
  lowp vec4 finalColor_9;
  highp vec2 tmpvar_10;
  tmpvar_10.y = 0.5;
  tmpvar_10.x = ((0.5 * _Progress) + 0.25);
  highp float time_11;
  time_11 = _Progress;
  bool tmpvar_12;
  tmpvar_12 = bool(1);
  highp float tmpvar_13;
  if ((_Progress == 0.0)) {
    tmpvar_13 = 0.0;
    tmpvar_12 = bool(0);
  } else {
    if ((_Progress == 1.0)) {
      tmpvar_13 = 1.0;
      tmpvar_12 = bool(0);
    };
  };
  if (tmpvar_12) {
    time_11 = (_Progress / 0.5);
    if ((time_11 < 1.0)) {
      tmpvar_13 = (0.5 * exp2((10.0 * 
        (time_11 - 1.0)
      )));
      tmpvar_12 = bool(0);
    } else {
      tmpvar_13 = (0.5 * (-(
        exp2((-10.0 * (time_11 - 1.0)))
      ) + 2.0));
      tmpvar_12 = bool(0);
    };
  };
  dissolve_8 = tmpvar_13;
  strength_7 = (-0.15 * (cos(
    ((3.141593 * _Progress) / 0.5)
  ) - 1.0));
  color_6 = vec3(0.0, 0.0, 0.0);
  total_5 = 0.0;
  toCenter_4 = (tmpvar_10 - xlv_TEXCOORD0);
  highp vec3 tmpvar_14;
  tmpvar_14.z = 1.0;
  tmpvar_14.xy = xlv_TEXCOORD0;
  offset_3 = fract((sin(
    dot (tmpvar_14, vec3(12.9898, 78.233, 151.7182))
  ) * 43758.55));
  for (highp float t_2 = 0.0; t_2 <= 40.0; t_2 += 1.0) {
    highp float tmpvar_15;
    tmpvar_15 = ((t_2 + offset_3) / 40.0);
    highp float tmpvar_16;
    tmpvar_16 = (4.0 * (tmpvar_15 - (tmpvar_15 * tmpvar_15)));
    highp vec2 uv_17;
    uv_17 = (tmpvar_1 + ((toCenter_4 * tmpvar_15) * strength_7));
    lowp vec4 tmpvar_18;
    tmpvar_18 = texture2D (_PrevTexture, uv_17);
    lowp vec4 tmpvar_19;
    tmpvar_19 = texture2D (_NextTexture, uv_17);
    highp vec3 tmpvar_20;
    tmpvar_20 = mix (tmpvar_18.xyz, tmpvar_19.xyz, vec3(dissolve_8));
    color_6 = (color_6 + (tmpvar_20 * tmpvar_16));
    total_5 = (total_5 + tmpvar_16);
  };
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (color_6 / total_5);
  finalColor_9 = tmpvar_21;
  gl_FragData[0] = finalColor_9;
}

]===],
	},
}

end
