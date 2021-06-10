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
uniform float _Direction;
uniform sampler2D _PrevTexture;
uniform sampler2D _NextTexture;
uniform vec2 _TargetSize;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  vec4 fragColor_1;
  float tmpvar_2;
  tmpvar_2 = (5.0 / _TargetSize.x);
  float tmpvar_3;
  if ((_Progress < 0.5)) {
    float tmpvar_4;
    tmpvar_4 = (_Progress * _Progress);
    tmpvar_3 = ((16.0 * _Progress) * (tmpvar_4 * tmpvar_4));
  } else {
    float tmpvar_5;
    tmpvar_5 = (_Progress - 1.0);
    tmpvar_3 = (1.0 + ((
      (16.0 * tmpvar_5)
     * 
      (tmpvar_5 * tmpvar_5)
    ) * (tmpvar_5 * tmpvar_5)));
  };
  vec2 UV_6;
  UV_6 = vec2(0.0, 0.0);
  int tmpvar_7;
  tmpvar_7 = int(_Direction);
  if ((tmpvar_3 < 0.499999)) {
    if ((tmpvar_7 == 1)) {
      UV_6 = (0.5 + ((xlv_TEXCOORD0 - 0.5) * (1.0 + tmpvar_3)));
    } else {
      UV_6 = (0.5 + ((xlv_TEXCOORD0 - 0.5) * (1.0 - tmpvar_3)));
    };
  } else {
    if ((tmpvar_7 == 1)) {
      UV_6 = (0.5 + ((xlv_TEXCOORD0 - 0.5) * tmpvar_3));
    } else {
      UV_6 = (0.5 + ((xlv_TEXCOORD0 - 0.5) * (2.0 - tmpvar_3)));
    };
  };
  if ((tmpvar_3 < 0.5)) {
    vec2 uv_8;
    uv_8 = UV_6;
    float time_9;
    time_9 = tmpvar_3;
    float xlat_varstep_10;
    xlat_varstep_10 = tmpvar_2;
    vec3 color_12;
    vec2 dir_13;
    dir_13 = (UV_6 - 0.5);
    color_12 = vec3(0.0, 0.0, 0.0);
    for (int i_11 = -10; i_11 <= 10; i_11++) {
      vec2 blurCoord_14;
      vec2 tmpvar_15;
      tmpvar_15 = abs((uv_8 + (
        (((xlat_varstep_10 * float(i_11)) * 2.0) * time_9)
       * dir_13)));
      blurCoord_14 = tmpvar_15;
      if ((tmpvar_15.x > 1.0)) {
        blurCoord_14.x = (2.0 - tmpvar_15.x);
      };
      if ((tmpvar_15.y > 1.0)) {
        blurCoord_14.y = (2.0 - tmpvar_15.y);
      };
      color_12 = (color_12 + texture2D (_PrevTexture, blurCoord_14).xyz);
    };
    color_12 = (color_12 / 21.0);
    vec4 tmpvar_16;
    tmpvar_16.w = 1.0;
    tmpvar_16.xyz = color_12;
    fragColor_1 = tmpvar_16;
  } else {
    vec2 uv_17;
    uv_17 = UV_6;
    float time_18;
    time_18 = (1.0 - tmpvar_3);
    float xlat_varstep_19;
    xlat_varstep_19 = tmpvar_2;
    vec3 color_21;
    vec2 dir_22;
    dir_22 = (UV_6 - 0.5);
    color_21 = vec3(0.0, 0.0, 0.0);
    for (int i_20 = -10; i_20 <= 10; i_20++) {
      vec2 blurCoord_23;
      vec2 tmpvar_24;
      tmpvar_24 = abs((uv_17 + (
        (((xlat_varstep_19 * float(i_20)) * 2.0) * time_18)
       * dir_22)));
      blurCoord_23 = tmpvar_24;
      if ((tmpvar_24.x > 1.0)) {
        blurCoord_23.x = (2.0 - tmpvar_24.x);
      };
      if ((tmpvar_24.y > 1.0)) {
        blurCoord_23.y = (2.0 - tmpvar_24.y);
      };
      color_21 = (color_21 + texture2D (_NextTexture, blurCoord_23).xyz);
    };
    color_21 = (color_21 / 21.0);
    vec4 tmpvar_25;
    tmpvar_25.w = 1.0;
    tmpvar_25.xyz = color_21;
    fragColor_1 = tmpvar_25;
  };
  gl_FragData[0] = fragColor_1;
}

]===],
	},
}

end
