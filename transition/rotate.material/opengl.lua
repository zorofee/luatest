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
uniform vec2 _TargetSize;
uniform float _Direction;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  vec3 resultColor_1;
  vec2 tmpvar_2;
  tmpvar_2 = (xlv_TEXCOORD0 * _TargetSize);
  vec2 tmpvar_3;
  tmpvar_3 = (_TargetSize * 0.5);
  float tmpvar_4;
  if ((_Progress < 0.5)) {
    tmpvar_4 = ((4.0 * _Progress) * (_Progress * _Progress));
  } else {
    tmpvar_4 = (1.0 - (pow (
      ((-2.0 * _Progress) + 2.0)
    , 3.0) / 2.0));
  };
  resultColor_1 = vec3(0.0, 0.0, 0.0);
  float rad_5;
  rad_5 = (6.283186 * tmpvar_4);
  mat2 rotateMat_6;
  vec2 tmpvar_7;
  tmpvar_7 = (tmpvar_2 - tmpvar_3);
  float tmpvar_8;
  tmpvar_8 = cos(rad_5);
  float tmpvar_9;
  tmpvar_9 = sin(rad_5);
  int tmpvar_10;
  tmpvar_10 = int(_Direction);
  if ((tmpvar_10 == 1)) {
    mat2 tmpvar_11;
    tmpvar_11[0].x = tmpvar_8;
    tmpvar_11[0].y = -(tmpvar_9);
    tmpvar_11[1].x = tmpvar_9;
    tmpvar_11[1].y = tmpvar_8;
    rotateMat_6 = tmpvar_11;
  } else {
    mat2 tmpvar_12;
    tmpvar_12[0].x = tmpvar_8;
    tmpvar_12[0].y = tmpvar_9;
    tmpvar_12[1].x = -(tmpvar_9);
    tmpvar_12[1].y = tmpvar_8;
    rotateMat_6 = tmpvar_12;
  };
  vec2 tmpvar_13;
  tmpvar_13 = ((tmpvar_7 * rotateMat_6) + tmpvar_3);
  if ((tmpvar_4 <= 0.5)) {
    vec2 center_14;
    center_14 = tmpvar_3;
    vec2 resolution_15;
    resolution_15 = _TargetSize;
    float intensity_16;
    intensity_16 = (tmpvar_4 * 2.0);
    vec3 color_18;
    float angle_19;
    float r_20;
    vec2 tmpvar_21;
    tmpvar_21 = (tmpvar_13 - tmpvar_3);
    r_20 = sqrt(dot (tmpvar_21, tmpvar_21));
    float tmpvar_22;
    float tmpvar_23;
    tmpvar_23 = (min (abs(
      (tmpvar_21.y / tmpvar_21.x)
    ), 1.0) / max (abs(
      (tmpvar_21.y / tmpvar_21.x)
    ), 1.0));
    float tmpvar_24;
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
    for (int i_17 = 0; i_17 < 12; i_17++) {
      float new_y_25;
      float new_x_26;
      angle_19 = (angle_19 + (0.01 * intensity_16));
      float tmpvar_27;
      tmpvar_27 = ((r_20 * sin(angle_19)) + center_14.y);
      new_y_25 = tmpvar_27;
      float tmpvar_28;
      tmpvar_28 = abs(((r_20 * 
        cos(angle_19)
      ) + center_14.x));
      new_x_26 = tmpvar_28;
      if ((tmpvar_28 > resolution_15.x)) {
        float ip_29;
        ip_29 = float(int(tmpvar_28));
        resolution_15.x = ip_29;
        new_x_26 = (ip_29 - (tmpvar_28 - ip_29));
      };
      float tmpvar_30;
      tmpvar_30 = abs(tmpvar_27);
      new_y_25 = tmpvar_30;
      if ((tmpvar_30 > resolution_15.y)) {
        float ip_31;
        ip_31 = float(int(tmpvar_30));
        resolution_15.y = ip_31;
        new_y_25 = (ip_31 - (tmpvar_30 - ip_31));
      };
      vec2 tmpvar_32;
      tmpvar_32.x = new_x_26;
      tmpvar_32.y = new_y_25;
      color_18 = (color_18 + texture2D (_PrevTexture, (tmpvar_32 / resolution_15)).xyz);
    };
    color_18 = (color_18 / 12.0);
    resultColor_1 = color_18;
  } else {
    if (((tmpvar_4 > 0.5) && (tmpvar_4 <= 1.0))) {
      vec2 center_33;
      center_33 = tmpvar_3;
      vec2 resolution_34;
      resolution_34 = _TargetSize;
      float intensity_35;
      intensity_35 = ((1.0 - tmpvar_4) * 2.0);
      vec3 color_37;
      float angle_38;
      float r_39;
      vec2 tmpvar_40;
      tmpvar_40 = (tmpvar_13 - tmpvar_3);
      r_39 = sqrt(dot (tmpvar_40, tmpvar_40));
      float tmpvar_41;
      float tmpvar_42;
      tmpvar_42 = (min (abs(
        (tmpvar_40.y / tmpvar_40.x)
      ), 1.0) / max (abs(
        (tmpvar_40.y / tmpvar_40.x)
      ), 1.0));
      float tmpvar_43;
      tmpvar_43 = (tmpvar_42 * tmpvar_42);
      tmpvar_43 = (((
        ((((
          ((((-0.01213232 * tmpvar_43) + 0.05368138) * tmpvar_43) - 0.1173503)
         * tmpvar_43) + 0.1938925) * tmpvar_43) - 0.3326756)
       * tmpvar_43) + 0.9999793) * tmpvar_42);
      tmpvar_43 = (tmpvar_43 + (float(
        (abs((tmpvar_40.y / tmpvar_40.x)) > 1.0)
      ) * (
        (tmpvar_43 * -2.0)
       + 1.570796)));
      tmpvar_41 = (tmpvar_43 * sign((tmpvar_40.y / tmpvar_40.x)));
      if ((abs(tmpvar_40.x) > (1e-8 * abs(tmpvar_40.y)))) {
        if ((tmpvar_40.x < 0.0)) {
          if ((tmpvar_40.y >= 0.0)) {
            tmpvar_41 += 3.141593;
          } else {
            tmpvar_41 = (tmpvar_41 - 3.141593);
          };
        };
      } else {
        tmpvar_41 = (sign(tmpvar_40.y) * 1.570796);
      };
      angle_38 = tmpvar_41;
      color_37 = vec3(0.0, 0.0, 0.0);
      for (int i_36 = 0; i_36 < 12; i_36++) {
        float new_y_44;
        float new_x_45;
        angle_38 = (angle_38 + (0.01 * intensity_35));
        float tmpvar_46;
        tmpvar_46 = ((r_39 * sin(angle_38)) + center_33.y);
        new_y_44 = tmpvar_46;
        float tmpvar_47;
        tmpvar_47 = abs(((r_39 * 
          cos(angle_38)
        ) + center_33.x));
        new_x_45 = tmpvar_47;
        if ((tmpvar_47 > resolution_34.x)) {
          float ip_48;
          ip_48 = float(int(tmpvar_47));
          resolution_34.x = ip_48;
          new_x_45 = (ip_48 - (tmpvar_47 - ip_48));
        };
        float tmpvar_49;
        tmpvar_49 = abs(tmpvar_46);
        new_y_44 = tmpvar_49;
        if ((tmpvar_49 > resolution_34.y)) {
          float ip_50;
          ip_50 = float(int(tmpvar_49));
          resolution_34.y = ip_50;
          new_y_44 = (ip_50 - (tmpvar_49 - ip_50));
        };
        vec2 tmpvar_51;
        tmpvar_51.x = new_x_45;
        tmpvar_51.y = new_y_44;
        color_37 = (color_37 + texture2D (_NextTexture, (tmpvar_51 / resolution_34)).xyz);
      };
      color_37 = (color_37 / 12.0);
      resultColor_1 = color_37;
    } else {
      resultColor_1 = texture2D (_NextTexture, xlv_TEXCOORD0).xyz;
    };
  };
  vec4 tmpvar_52;
  tmpvar_52.w = 1.0;
  tmpvar_52.xyz = resultColor_1;
  gl_FragData[0] = tmpvar_52;
}

]===],
	},
}

end
