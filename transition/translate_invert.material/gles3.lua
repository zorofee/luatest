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
		_Direction = "Enum(up,1,down,2,left,3,right,4)", 
	}
	
end




function Init()
	PassNames = 
	{
		"Always"
	}

ShaderName = "UvTranslateInvert"
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
  highp float p1_1;
  highp float y_2;
  highp float x_3;
  lowp vec4 fragColor_4;
  x_3 = xlv_TEXCOORD0.x;
  y_2 = xlv_TEXCOORD0.y;
  highp int tmpvar_5;
  tmpvar_5 = int(_Direction);
  highp float tmpvar_6;
  if ((_Progress < 0.5)) {
    highp float tmpvar_7;
    tmpvar_7 = (_Progress * _Progress);
    tmpvar_6 = ((16.0 * _Progress) * (tmpvar_7 * tmpvar_7));
  } else {
    highp float tmpvar_8;
    tmpvar_8 = (_Progress - 1.0);
    tmpvar_6 = (1.0 + ((
      (16.0 * tmpvar_8)
     * 
      (tmpvar_8 * tmpvar_8)
    ) * (tmpvar_8 * tmpvar_8)));
  };
  p1_1 = 0.0;
  if ((tmpvar_6 < 0.5)) {
    highp float tmpvar_9;
    tmpvar_9 = clamp ((tmpvar_6 * 2.0), 0.0, 1.0);
    p1_1 = tmpvar_9;
    if ((tmpvar_5 == 1)) {
      y_2 = (xlv_TEXCOORD0.y + tmpvar_9);
      if ((y_2 > 1.0)) {
        y_2 = (2.0 - y_2);
      };
    } else {
      if ((tmpvar_5 == 2)) {
        y_2 = (y_2 - tmpvar_9);
        y_2 = abs(y_2);
      } else {
        if ((tmpvar_5 == 3)) {
          x_3 = (xlv_TEXCOORD0.x + tmpvar_9);
          if ((x_3 > 1.0)) {
            x_3 = (2.0 - x_3);
          };
        } else {
          if ((tmpvar_5 == 4)) {
            x_3 = (x_3 - tmpvar_9);
            x_3 = abs(x_3);
          };
        };
      };
    };
    highp vec2 tmpvar_10;
    tmpvar_10.x = x_3;
    tmpvar_10.y = y_2;
    highp vec2 uv_11;
    uv_11 = tmpvar_10;
    lowp float sum_weight_13;
    highp vec2 unit_uv_14;
    lowp vec3 result_15;
    lowp vec3 sum_16;
    lowp float half_gaussian_weight_18[16];
    for (highp int i_17 = 0; i_17 <= 15; i_17++) {
      lowp float dist_19;
      dist_19 = float(i_17);
      half_gaussian_weight_18[i_17] = exp(((
        -(dist_19)
       * dist_19) / 400.0));
    };
    sum_16 = vec3(0.0, 0.0, 0.0);
    result_15 = vec3(0.0, 0.0, 0.0);
    unit_uv_14 = (((1.0/(_TargetSize)) * 1.25) * tmpvar_9);
    lowp vec3 tmpvar_20;
    tmpvar_20 = (texture (_PrevTexture, tmpvar_10).xyz * half_gaussian_weight_18[0]);
    sum_weight_13 = half_gaussian_weight_18[0];
    for (highp int i_1_12 = 1; i_1_12 <= 15; i_1_12++) {
      highp vec2 tmpvar_21;
      tmpvar_21.x = 0.0;
      tmpvar_21.y = float(i_1_12);
      highp vec2 tmpvar_22;
      tmpvar_22 = (uv_11 + (tmpvar_21 * unit_uv_14));
      highp vec2 tmpvar_23;
      tmpvar_23.x = 0.0;
      tmpvar_23.y = float(-(i_1_12));
      highp vec2 tmpvar_24;
      tmpvar_24 = (uv_11 + (tmpvar_23 * unit_uv_14));
      sum_16 = (sum_16 + (texture (_PrevTexture, tmpvar_22).xyz * half_gaussian_weight_18[i_1_12]));
      sum_16 = (sum_16 + (texture (_PrevTexture, tmpvar_24).xyz * half_gaussian_weight_18[i_1_12]));
      sum_weight_13 = (sum_weight_13 + (half_gaussian_weight_18[i_1_12] * 2.0));
    };
    result_15 = ((sum_16 + tmpvar_20) / sum_weight_13);
    lowp vec4 tmpvar_25;
    tmpvar_25.w = 1.0;
    tmpvar_25.xyz = result_15;
    fragColor_4 = tmpvar_25;
  } else {
    p1_1 = ((tmpvar_6 - 0.5) * 2.0);
    if ((tmpvar_5 == 1)) {
      y_2 = (y_2 + p1_1);
      if ((y_2 > 1.0)) {
        y_2 = (2.0 - y_2);
      };
      y_2 = (1.0 - y_2);
    } else {
      if ((tmpvar_5 == 2)) {
        y_2 = (y_2 - p1_1);
        y_2 = (1.0 - abs(y_2));
      } else {
        if ((tmpvar_5 == 3)) {
          x_3 = (x_3 + p1_1);
          if ((x_3 > 1.0)) {
            x_3 = (2.0 - x_3);
          };
          x_3 = (1.0 - x_3);
        } else {
          if ((tmpvar_5 == 4)) {
            x_3 = (x_3 - p1_1);
            x_3 = (1.0 - abs(x_3));
          };
        };
      };
    };
    highp vec2 tmpvar_26;
    tmpvar_26.x = x_3;
    tmpvar_26.y = y_2;
    highp vec2 uv_27;
    uv_27 = tmpvar_26;
    highp float p1_28;
    p1_28 = (1.0 - p1_1);
    lowp float sum_weight_30;
    highp vec2 unit_uv_31;
    lowp vec3 result_32;
    lowp vec3 sum_33;
    lowp float half_gaussian_weight_35[16];
    for (highp int i_34 = 0; i_34 <= 15; i_34++) {
      lowp float dist_36;
      dist_36 = float(i_34);
      half_gaussian_weight_35[i_34] = exp(((
        -(dist_36)
       * dist_36) / 400.0));
    };
    sum_33 = vec3(0.0, 0.0, 0.0);
    result_32 = vec3(0.0, 0.0, 0.0);
    unit_uv_31 = (((1.0/(_TargetSize)) * 1.25) * p1_28);
    lowp vec3 tmpvar_37;
    tmpvar_37 = (texture (_NextTexture, tmpvar_26).xyz * half_gaussian_weight_35[0]);
    sum_weight_30 = half_gaussian_weight_35[0];
    for (highp int i_1_29 = 1; i_1_29 <= 15; i_1_29++) {
      highp vec2 tmpvar_38;
      tmpvar_38.x = 0.0;
      tmpvar_38.y = float(i_1_29);
      highp vec2 tmpvar_39;
      tmpvar_39 = (uv_27 + (tmpvar_38 * unit_uv_31));
      highp vec2 tmpvar_40;
      tmpvar_40.x = 0.0;
      tmpvar_40.y = float(-(i_1_29));
      highp vec2 tmpvar_41;
      tmpvar_41 = (uv_27 + (tmpvar_40 * unit_uv_31));
      sum_33 = (sum_33 + (texture (_NextTexture, tmpvar_39).xyz * half_gaussian_weight_35[i_1_29]));
      sum_33 = (sum_33 + (texture (_NextTexture, tmpvar_41).xyz * half_gaussian_weight_35[i_1_29]));
      sum_weight_30 = (sum_weight_30 + (half_gaussian_weight_35[i_1_29] * 2.0));
    };
    result_32 = ((sum_33 + tmpvar_37) / sum_weight_30);
    lowp vec4 tmpvar_42;
    tmpvar_42.w = 1.0;
    tmpvar_42.xyz = result_32;
    fragColor_4 = tmpvar_42;
  };
  _glesFragData[0] = fragColor_4;
}

]===],
	},
}
 
end
