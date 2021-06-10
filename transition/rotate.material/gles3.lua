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
		_Direction = "Enum(anticlockwise,1,clockwise,2)", 
	}
	
end
 



function Init()
	PassNames = 
	{
		"Always"
	}

ShaderName = "rotate"
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
  lowp vec3 resultColor_1;
  highp vec2 tmpvar_2;
  tmpvar_2 = (xlv_TEXCOORD0 * _TargetSize);
  highp vec2 tmpvar_3;
  tmpvar_3 = (_TargetSize * 0.5);
  highp float tmpvar_4;
  if ((_Progress < 0.5)) {
    tmpvar_4 = ((4.0 * _Progress) * (_Progress * _Progress));
  } else {
    tmpvar_4 = (1.0 - (pow (
      ((-2.0 * _Progress) + 2.0)
    , 3.0) / 2.0));
  };
  resultColor_1 = vec3(0.0, 0.0, 0.0);
  highp float rad_5;
  rad_5 = (6.283186 * tmpvar_4);
  highp mat2 rotateMat_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (tmpvar_2 - tmpvar_3);
  highp float tmpvar_8;
  tmpvar_8 = cos(rad_5);
  highp float tmpvar_9;
  tmpvar_9 = sin(rad_5);
  highp int tmpvar_10;
  tmpvar_10 = int(_Direction);
  if ((tmpvar_10 == 1)) {
    highp mat2 tmpvar_11;
    tmpvar_11[uint(0)].x = tmpvar_8;
    tmpvar_11[uint(0)].y = -(tmpvar_9);
    tmpvar_11[1u].x = tmpvar_9;
    tmpvar_11[1u].y = tmpvar_8;
    rotateMat_6 = tmpvar_11;
  } else {
    highp mat2 tmpvar_12;
    tmpvar_12[uint(0)].x = tmpvar_8;
    tmpvar_12[uint(0)].y = tmpvar_9;
    tmpvar_12[1u].x = -(tmpvar_9);
    tmpvar_12[1u].y = tmpvar_8;
    rotateMat_6 = tmpvar_12;
  };
  highp vec2 tmpvar_13;
  tmpvar_13 = ((tmpvar_7 * rotateMat_6) + tmpvar_3);
  if ((tmpvar_4 <= 0.5)) {
    highp vec2 center_14;
    center_14 = tmpvar_3;
    highp vec2 resolution_15;
    resolution_15 = _TargetSize;
    highp float intensity_16;
    intensity_16 = (tmpvar_4 * 2.0);
    lowp vec3 color_18;
    highp float angle_19;
    highp float r_20;
    highp vec2 tmpvar_21;
    tmpvar_21 = (tmpvar_13 - tmpvar_3);
    r_20 = sqrt(dot (tmpvar_21, tmpvar_21));
    highp float tmpvar_22;
    highp float tmpvar_23;
    tmpvar_23 = (min (abs(
      (tmpvar_21.y / tmpvar_21.x)
    ), 1.0) / max (abs(
      (tmpvar_21.y / tmpvar_21.x)
    ), 1.0));
    highp float tmpvar_24;
    tmpvar_24 = (tmpvar_23 * tmpvar_23);
    tmpvar_24 = (((
      ((((
        ((((-0.01213232 * tmpvar_24) + 0.05368138) * tmpvar_24) - 0.1173503)
       * tmpvar_24) + 0.1938925) * tmpvar_24) - 0.3326756)
     * tmpvar_24) + 0.9999793) * tmpvar_23);
    tmpvar_24 = (tmpvar_24 + (float(
      (abs((tmpvar_21.y / tmpvar_21.x)) > 1.0)
    ) * (
      (tmpvar_24 * -2.0)
     + 1.570796)));
    tmpvar_22 = (tmpvar_24 * sign((tmpvar_21.y / tmpvar_21.x)));
    if ((abs(tmpvar_21.x) > (1e-8 * abs(tmpvar_21.y)))) {
      if ((tmpvar_21.x < 0.0)) {
        if ((tmpvar_21.y >= 0.0)) {
          tmpvar_22 += 3.141593;
        } else {
          tmpvar_22 = (tmpvar_22 - 3.141593);
        };
      };
    } else {
      tmpvar_22 = (sign(tmpvar_21.y) * 1.570796);
    };
    angle_19 = tmpvar_22;
    color_18 = vec3(0.0, 0.0, 0.0);
    for (highp int i_17 = 0; i_17 < 12; i_17++) {
      highp float new_y_25;
      highp float new_x_26;
      angle_19 = (angle_19 + (0.01 * intensity_16));
      highp float tmpvar_27;
      tmpvar_27 = ((r_20 * sin(angle_19)) + center_14.y);
      new_y_25 = tmpvar_27;
      highp float tmpvar_28;
      tmpvar_28 = abs(((r_20 * 
        cos(angle_19)
      ) + center_14.x));
      new_x_26 = tmpvar_28;
      if ((tmpvar_28 > resolution_15.x)) {
        highp float ip_29;
        ip_29 = float(int(tmpvar_28));
        resolution_15.x = ip_29;
        new_x_26 = (ip_29 - (tmpvar_28 - ip_29));
      };
      highp float tmpvar_30;
      tmpvar_30 = abs(tmpvar_27);
      new_y_25 = tmpvar_30;
      if ((tmpvar_30 > resolution_15.y)) {
        highp float ip_31;
        ip_31 = float(int(tmpvar_30));
        resolution_15.y = ip_31;
        new_y_25 = (ip_31 - (tmpvar_30 - ip_31));
      };
      highp vec2 tmpvar_32;
      tmpvar_32.x = new_x_26;
      tmpvar_32.y = new_y_25;
      highp vec2 P_33;
      P_33 = (tmpvar_32 / resolution_15);
      color_18 = (color_18 + texture (_PrevTexture, P_33).xyz);
    };
    color_18 = (color_18 / 12.0);
    resultColor_1 = color_18;
  } else {
    if (((tmpvar_4 > 0.5) && (tmpvar_4 <= 1.0))) {
      highp vec2 center_34;
      center_34 = tmpvar_3;
      highp vec2 resolution_35;
      resolution_35 = _TargetSize;
      highp float intensity_36;
      intensity_36 = ((1.0 - tmpvar_4) * 2.0);
      lowp vec3 color_38;
      highp float angle_39;
      highp float r_40;
      highp vec2 tmpvar_41;
      tmpvar_41 = (tmpvar_13 - tmpvar_3);
      r_40 = sqrt(dot (tmpvar_41, tmpvar_41));
      highp float tmpvar_42;
      highp float tmpvar_43;
      tmpvar_43 = (min (abs(
        (tmpvar_41.y / tmpvar_41.x)
      ), 1.0) / max (abs(
        (tmpvar_41.y / tmpvar_41.x)
      ), 1.0));
      highp float tmpvar_44;
      tmpvar_44 = (tmpvar_43 * tmpvar_43);
      tmpvar_44 = (((
        ((((
          ((((-0.01213232 * tmpvar_44) + 0.05368138) * tmpvar_44) - 0.1173503)
         * tmpvar_44) + 0.1938925) * tmpvar_44) - 0.3326756)
       * tmpvar_44) + 0.9999793) * tmpvar_43);
      tmpvar_44 = (tmpvar_44 + (float(
        (abs((tmpvar_41.y / tmpvar_41.x)) > 1.0)
      ) * (
        (tmpvar_44 * -2.0)
       + 1.570796)));
      tmpvar_42 = (tmpvar_44 * sign((tmpvar_41.y / tmpvar_41.x)));
      if ((abs(tmpvar_41.x) > (1e-8 * abs(tmpvar_41.y)))) {
        if ((tmpvar_41.x < 0.0)) {
          if ((tmpvar_41.y >= 0.0)) {
            tmpvar_42 += 3.141593;
          } else {
            tmpvar_42 = (tmpvar_42 - 3.141593);
          };
        };
      } else {
        tmpvar_42 = (sign(tmpvar_41.y) * 1.570796);
      };
      angle_39 = tmpvar_42;
      color_38 = vec3(0.0, 0.0, 0.0);
      for (highp int i_37 = 0; i_37 < 12; i_37++) {
        highp float new_y_45;
        highp float new_x_46;
        angle_39 = (angle_39 + (0.01 * intensity_36));
        highp float tmpvar_47;
        tmpvar_47 = ((r_40 * sin(angle_39)) + center_34.y);
        new_y_45 = tmpvar_47;
        highp float tmpvar_48;
        tmpvar_48 = abs(((r_40 * 
          cos(angle_39)
        ) + center_34.x));
        new_x_46 = tmpvar_48;
        if ((tmpvar_48 > resolution_35.x)) {
          highp float ip_49;
          ip_49 = float(int(tmpvar_48));
          resolution_35.x = ip_49;
          new_x_46 = (ip_49 - (tmpvar_48 - ip_49));
        };
        highp float tmpvar_50;
        tmpvar_50 = abs(tmpvar_47);
        new_y_45 = tmpvar_50;
        if ((tmpvar_50 > resolution_35.y)) {
          highp float ip_51;
          ip_51 = float(int(tmpvar_50));
          resolution_35.y = ip_51;
          new_y_45 = (ip_51 - (tmpvar_50 - ip_51));
        };
        highp vec2 tmpvar_52;
        tmpvar_52.x = new_x_46;
        tmpvar_52.y = new_y_45;
        highp vec2 P_53;
        P_53 = (tmpvar_52 / resolution_35);
        color_38 = (color_38 + texture (_NextTexture, P_53).xyz);
      };
      color_38 = (color_38 / 12.0);
      resultColor_1 = color_38;
    } else {
      resultColor_1 = texture (_NextTexture, xlv_TEXCOORD0).xyz;
    };
  };
  lowp vec4 tmpvar_54;
  tmpvar_54.w = 1.0;
  tmpvar_54.xyz = resultColor_1;
  _glesFragData[0] = tmpvar_54;
}

]===],
	},
}

end
