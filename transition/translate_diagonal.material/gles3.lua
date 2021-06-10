function DefineParams()
	Properties = 
	{
		
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},
_TargetSize = {"target size", VEC2, "400.0,300.0"},

_Direction = {"direction",FLOAT,"1.0"},

	}
	Attributes = 
	{
		_Direction = "Enum(leftdown,1,leftup,2,rightdown,3,rightup,4)", 
	}
	
end




function Init()
	PassNames = 
	{
		"Always"
	}

ShaderName = "UvTranslateDiagonal"
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
			{
				varName = "_TargetSize",
				varType = "float2",
				varSit = "",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
			{
				varName = "_Direction",
				varType = "float",
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
uniform highp vec2 _TargetSize;
uniform highp float _Direction;
in highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec2 direction_1;
  lowp vec3 result_2;
  highp vec2 realCoord_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = (xlv_TEXCOORD0 * _TargetSize);
  realCoord_3 = tmpvar_4;
  highp float tmpvar_5;
  if ((_Progress < 0.5)) {
    tmpvar_5 = ((4.0 * _Progress) * (_Progress * _Progress));
  } else {
    tmpvar_5 = (1.0 - (pow (
      ((-2.0 * _Progress) + 2.0)
    , 3.0) / 2.0));
  };
  highp vec2 tmpvar_6;
  tmpvar_6.x = (_TargetSize.x * float(int(
    -(sign((_Direction - 2.5)))
  )));
  tmpvar_6.y = (_TargetSize.y * float(int(
    -(sign(((
      (float(mod (float(int(_Direction)), 2.0)))
     * 2.0) - 1.0)))
  )));
  direction_1 = tmpvar_6;
  if ((tmpvar_5 <= 0.5)) {
    highp vec2 maxMoveDirection_7;
    maxMoveDirection_7 = direction_1;
    highp vec2 tmpvar_8;
    tmpvar_8 = (tmpvar_4 + (maxMoveDirection_7 * (tmpvar_5 * 2.0)));
    realCoord_3 = tmpvar_8;
    highp vec2 uv_9;
    uv_9 = (tmpvar_8 / _TargetSize);
    highp vec2 directionOfBlur_10;
    directionOfBlur_10 = direction_1;
    lowp vec3 color_12;
    highp vec2 pixelStep_13;
    pixelStep_13 = (((
      normalize(directionOfBlur_10)
     * 3.0) * (tmpvar_5 * 2.0)) / _TargetSize);
    for (highp int i_11 = -8; i_11 <= 8; i_11++) {
      highp vec2 newCoord_14;
      highp vec2 tmpvar_15;
      tmpvar_15 = abs((uv_9 + (pixelStep_13 * 
        float(i_11)
      )));
      newCoord_14 = tmpvar_15;
      if ((tmpvar_15.x > 1.0)) {
        newCoord_14.x = (1.0 - fract(tmpvar_15.x));
      };
      if ((tmpvar_15.y > 1.0)) {
        newCoord_14.y = (1.0 - fract(tmpvar_15.y));
      };
      color_12 = (color_12 + texture (_PrevTexture, newCoord_14).xyz);
    };
    color_12 = (color_12 / 17.0);
    result_2 = color_12;
  } else {
    if (((tmpvar_5 > 0.5) && (tmpvar_5 <= 1.0))) {
      realCoord_3 = (realCoord_3 - _TargetSize);
      highp vec2 maxMoveDirection_16;
      maxMoveDirection_16 = direction_1;
      highp vec2 tmpvar_17;
      tmpvar_17 = (realCoord_3 + (maxMoveDirection_16 * (
        (tmpvar_5 - 0.5)
       * 2.0)));
      realCoord_3 = tmpvar_17;
      highp vec2 uv_18;
      uv_18 = (tmpvar_17 / _TargetSize);
      highp vec2 directionOfBlur_19;
      directionOfBlur_19 = direction_1;
      lowp vec3 color_21;
      highp vec2 pixelStep_22;
      pixelStep_22 = (((
        normalize(directionOfBlur_19)
       * 3.0) * (
        (1.0 - tmpvar_5)
       * 2.0)) / _TargetSize);
      for (highp int i_20 = -8; i_20 <= 8; i_20++) {
        highp vec2 newCoord_23;
        highp vec2 tmpvar_24;
        tmpvar_24 = abs((uv_18 + (pixelStep_22 * 
          float(i_20)
        )));
        newCoord_23 = tmpvar_24;
        if ((tmpvar_24.x > 1.0)) {
          newCoord_23.x = (1.0 - fract(tmpvar_24.x));
        };
        if ((tmpvar_24.y > 1.0)) {
          newCoord_23.y = (1.0 - fract(tmpvar_24.y));
        };
        color_21 = (color_21 + texture (_NextTexture, newCoord_23).xyz);
      };
      color_21 = (color_21 / 17.0);
      result_2 = color_21;
    } else {
      if ((tmpvar_5 > 1.0)) {
        result_2 = texture (_NextTexture, xlv_TEXCOORD0).xyz;
      };
    };
  };
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = result_2;
  _glesFragData[0] = tmpvar_25;
}

]===],
	},
}

end
