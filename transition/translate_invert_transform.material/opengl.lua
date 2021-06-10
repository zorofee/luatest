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
		shaderApi = "opengl",
		keyWords = {},
		vsBufferSize = "0",
		vsAttributes = {
		},
		vsUniforms = {
			{
				varName = "LOCALWORLD_TRANSFORM",
				varType = "float4x4",
				varSit = "",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
			{
				varName = "WORLD_POSITION",
				varType = "float3",
				varSit = "",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
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
uniform mat4 LOCALWORLD_TRANSFORM;
uniform vec3 WORLD_POSITION;
uniform float DEVICE_COORDINATE_Y_FLIP;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  vec4 pos_1;
  pos_1.xyz = (LOCALWORLD_TRANSFORM * (_glesVertex * (1.0/(_glesVertex.w)))).xyz;
  pos_1.w = 1.0;
  pos_1.xy = (pos_1.xy + WORLD_POSITION.xy);
  vec4 tmpvar_2;
  tmpvar_2.xzw = vec3(1.0, 1.0, 1.0);
  tmpvar_2.y = DEVICE_COORDINATE_Y_FLIP;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  gl_Position = (tmpvar_2 * pos_1);
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
  float p1_1;
  float y_2;
  float x_3;
  vec4 fragColor_4;
  x_3 = xlv_TEXCOORD0.x;
  y_2 = xlv_TEXCOORD0.y;
  int tmpvar_5;
  tmpvar_5 = int(_Direction);
  float tmpvar_6;
  if ((_Progress < 0.5)) {
    float tmpvar_7;
    tmpvar_7 = (_Progress * _Progress);
    tmpvar_6 = ((16.0 * _Progress) * (tmpvar_7 * tmpvar_7));
  } else {
    float tmpvar_8;
    tmpvar_8 = (_Progress - 1.0);
    tmpvar_6 = (1.0 + ((
      (16.0 * tmpvar_8)
     * 
      (tmpvar_8 * tmpvar_8)
    ) * (tmpvar_8 * tmpvar_8)));
  };
  p1_1 = 0.0;
  if ((tmpvar_6 < 0.5)) {
    float tmpvar_9;
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
    vec2 tmpvar_10;
    tmpvar_10.x = x_3;
    tmpvar_10.y = y_2;
    vec2 uv_11;
    uv_11 = tmpvar_10;
    float sum_weight_13;
    vec2 unit_uv_14;
    vec3 result_15;
    vec3 sum_16;
    float half_gaussian_weight_18[16];
    for (int i_17 = 0; i_17 <= 15; i_17++) {
      float dist_19;
      dist_19 = float(i_17);
      half_gaussian_weight_18[i_17] = exp(((
        -(dist_19)
       * dist_19) / 400.0));
    };
    sum_16 = vec3(0.0, 0.0, 0.0);
    result_15 = vec3(0.0, 0.0, 0.0);
    unit_uv_14 = (((1.0/(_TargetSize)) * 1.25) * tmpvar_9);
    vec3 tmpvar_20;
    tmpvar_20 = (texture2D (_PrevTexture, tmpvar_10).xyz * half_gaussian_weight_18[0]);
    sum_weight_13 = half_gaussian_weight_18[0];
    for (int i_1_12 = 1; i_1_12 <= 15; i_1_12++) {
      vec2 tmpvar_21;
      tmpvar_21.x = 0.0;
      tmpvar_21.y = float(i_1_12);
      vec2 tmpvar_22;
      tmpvar_22.x = 0.0;
      tmpvar_22.y = float(-(i_1_12));
      sum_16 = (sum_16 + (texture2D (_PrevTexture, (uv_11 + 
        (tmpvar_21 * unit_uv_14)
      )).xyz * half_gaussian_weight_18[i_1_12]));
      sum_16 = (sum_16 + (texture2D (_PrevTexture, (uv_11 + 
        (tmpvar_22 * unit_uv_14)
      )).xyz * half_gaussian_weight_18[i_1_12]));
      sum_weight_13 = (sum_weight_13 + (half_gaussian_weight_18[i_1_12] * 2.0));
    };
    result_15 = ((sum_16 + tmpvar_20) / sum_weight_13);
    vec4 tmpvar_23;
    tmpvar_23.w = 1.0;
    tmpvar_23.xyz = result_15;
    fragColor_4 = tmpvar_23;
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
    vec2 tmpvar_24;
    tmpvar_24.x = x_3;
    tmpvar_24.y = y_2;
    vec2 uv_25;
    uv_25 = tmpvar_24;
    float p1_26;
    p1_26 = (1.0 - p1_1);
    float sum_weight_28;
    vec2 unit_uv_29;
    vec3 result_30;
    vec3 sum_31;
    float half_gaussian_weight_33[16];
    for (int i_32 = 0; i_32 <= 15; i_32++) {
      float dist_34;
      dist_34 = float(i_32);
      half_gaussian_weight_33[i_32] = exp(((
        -(dist_34)
       * dist_34) / 400.0));
    };
    sum_31 = vec3(0.0, 0.0, 0.0);
    result_30 = vec3(0.0, 0.0, 0.0);
    unit_uv_29 = (((1.0/(_TargetSize)) * 1.25) * p1_26);
    vec3 tmpvar_35;
    tmpvar_35 = (texture2D (_NextTexture, tmpvar_24).xyz * half_gaussian_weight_33[0]);
    sum_weight_28 = half_gaussian_weight_33[0];
    for (int i_1_27 = 1; i_1_27 <= 15; i_1_27++) {
      vec2 tmpvar_36;
      tmpvar_36.x = 0.0;
      tmpvar_36.y = float(i_1_27);
      vec2 tmpvar_37;
      tmpvar_37.x = 0.0;
      tmpvar_37.y = float(-(i_1_27));
      sum_31 = (sum_31 + (texture2D (_NextTexture, (uv_25 + 
        (tmpvar_36 * unit_uv_29)
      )).xyz * half_gaussian_weight_33[i_1_27]));
      sum_31 = (sum_31 + (texture2D (_NextTexture, (uv_25 + 
        (tmpvar_37 * unit_uv_29)
      )).xyz * half_gaussian_weight_33[i_1_27]));
      sum_weight_28 = (sum_weight_28 + (half_gaussian_weight_33[i_1_27] * 2.0));
    };
    result_30 = ((sum_31 + tmpvar_35) / sum_weight_28);
    vec4 tmpvar_38;
    tmpvar_38.w = 1.0;
    tmpvar_38.xyz = result_30;
    fragColor_4 = tmpvar_38;
  };
  gl_FragData[0] = fragColor_4;
}

]===],
	},
}
 
end