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
		_Direction = "Enum(far,1,near,2)", 
	}
	
end




function Init()
	PassNames = 
	{
		"Always"
	}

ShaderName = "Zoom"
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
				varName = "_Direction",
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
uniform highp float _Direction;
uniform sampler2D _PrevTexture;
uniform sampler2D _NextTexture;
uniform highp vec2 _TargetSize;
in highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 fragColor_2;
  highp float tmpvar_3;
  tmpvar_3 = (5.0 / _TargetSize.x);
  highp float tmpvar_4;
  if ((_Progress < 0.5)) {
    highp float tmpvar_5;
    tmpvar_5 = (_Progress * _Progress);
    tmpvar_4 = ((16.0 * _Progress) * (tmpvar_5 * tmpvar_5));
  } else {
    highp float tmpvar_6;
    tmpvar_6 = (_Progress - 1.0);
    tmpvar_4 = (1.0 + ((
      (16.0 * tmpvar_6)
     * 
      (tmpvar_6 * tmpvar_6)
    ) * (tmpvar_6 * tmpvar_6)));
  };
  highp vec2 UV_7;
  UV_7 = vec2(0.0, 0.0);
  highp int tmpvar_8;
  tmpvar_8 = int(_Direction);
  if ((tmpvar_4 < 0.499999)) {
    if ((tmpvar_8 == 1)) {
      UV_7 = (0.5 + ((xlv_TEXCOORD0 - 0.5) * (1.0 + tmpvar_4)));
    } else {
      UV_7 = (0.5 + ((xlv_TEXCOORD0 - 0.5) * (1.0 - tmpvar_4)));
    };
  } else {
    if ((tmpvar_8 == 1)) {
      UV_7 = (0.5 + ((xlv_TEXCOORD0 - 0.5) * tmpvar_4));
    } else {
      UV_7 = (0.5 + ((xlv_TEXCOORD0 - 0.5) * (2.0 - tmpvar_4)));
    };
  };
  if ((tmpvar_4 < 0.5)) {
    highp vec2 uv_9;
    uv_9 = UV_7;
    highp float time_10;
    time_10 = tmpvar_4;
    highp float xlat_varstep_11;
    xlat_varstep_11 = tmpvar_3;
    lowp vec3 color_13;
    highp vec2 dir_14;
    dir_14 = (UV_7 - 0.5);
    color_13 = vec3(0.0, 0.0, 0.0);
    for (highp int i_12 = -10; i_12 <= 10; i_12++) {
      highp vec2 blurCoord_15;
      highp vec2 tmpvar_16;
      tmpvar_16 = abs((uv_9 + (
        (((xlat_varstep_11 * float(i_12)) * 2.0) * time_10)
       * dir_14)));
      blurCoord_15 = tmpvar_16;
      if ((tmpvar_16.x > 1.0)) {
        blurCoord_15.x = (2.0 - tmpvar_16.x);
      };
      if ((tmpvar_16.y > 1.0)) {
        blurCoord_15.y = (2.0 - tmpvar_16.y);
      };
      color_13 = (color_13 + texture (_PrevTexture, blurCoord_15).xyz);
    };
    color_13 = (color_13 / 21.0);
    lowp vec4 tmpvar_17;
    tmpvar_17.w = 1.0;
    tmpvar_17.xyz = color_13;
    fragColor_2 = tmpvar_17;
  } else {
    highp vec2 uv_18;
    uv_18 = UV_7;
    highp float time_19;
    time_19 = (1.0 - tmpvar_4);
    highp float xlat_varstep_20;
    xlat_varstep_20 = tmpvar_3;
    lowp vec3 color_22;
    highp vec2 dir_23;
    dir_23 = (UV_7 - 0.5);
    color_22 = vec3(0.0, 0.0, 0.0);
    for (highp int i_21 = -10; i_21 <= 10; i_21++) {
      highp vec2 blurCoord_24;
      highp vec2 tmpvar_25;
      tmpvar_25 = abs((uv_18 + (
        (((xlat_varstep_20 * float(i_21)) * 2.0) * time_19)
       * dir_23)));
      blurCoord_24 = tmpvar_25;
      if ((tmpvar_25.x > 1.0)) {
        blurCoord_24.x = (2.0 - tmpvar_25.x);
      };
      if ((tmpvar_25.y > 1.0)) {
        blurCoord_24.y = (2.0 - tmpvar_25.y);
      };
      color_22 = (color_22 + texture (_NextTexture, blurCoord_24).xyz);
    };
    color_22 = (color_22 / 21.0);
    lowp vec4 tmpvar_26;
    tmpvar_26.w = 1.0;
    tmpvar_26.xyz = color_22;
    fragColor_2 = tmpvar_26;
  };
  tmpvar_1 = fragColor_2;
  _glesFragData[0] = tmpvar_1;
}

]===],
	},
}

end
