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
  vec3 result_1;
  vec2 realCoord_2;
  vec2 tmpvar_3;
  tmpvar_3 = (xlv_TEXCOORD0 * _TargetSize);
  realCoord_2 = tmpvar_3;
  float tmpvar_4;
  if ((_Progress < 0.5)) {
    tmpvar_4 = ((4.0 * _Progress) * (_Progress * _Progress));
  } else {
    tmpvar_4 = (1.0 - (pow (
      ((-2.0 * _Progress) + 2.0)
    , 3.0) / 2.0));
  };
  vec2 tmpvar_5;
  tmpvar_5.x = (_TargetSize.x * float(int(
    -(sign((_Direction - 2.5)))
  )));
  tmpvar_5.y = (_TargetSize.y * float(int(
    -(sign(((
      (float(mod (float(int(_Direction)), 2.0)))
     * 2.0) - 1.0)))
  )));
  if ((tmpvar_4 <= 0.5)) {
    vec2 tmpvar_6;
    tmpvar_6 = (tmpvar_3 + (tmpvar_5 * (tmpvar_4 * 2.0)));
    realCoord_2 = tmpvar_6;
    vec2 uv_7;
    uv_7 = (tmpvar_6 / _TargetSize);
    vec3 color_9;
    vec2 pixelStep_10;
    pixelStep_10 = (((
      normalize(tmpvar_5)
     * 3.0) * (tmpvar_4 * 2.0)) / _TargetSize);
    for (int i_8 = -8; i_8 <= 8; i_8++) {
      vec2 newCoord_11;
      vec2 tmpvar_12;
      tmpvar_12 = abs((uv_7 + (pixelStep_10 * 
        float(i_8)
      )));
      newCoord_11 = tmpvar_12;
      if ((tmpvar_12.x > 1.0)) {
        newCoord_11.x = (1.0 - fract(tmpvar_12.x));
      };
      if ((tmpvar_12.y > 1.0)) {
        newCoord_11.y = (1.0 - fract(tmpvar_12.y));
      };
      color_9 = (color_9 + texture2D (_PrevTexture, newCoord_11).xyz);
    };
    color_9 = (color_9 / 17.0);
    result_1 = color_9;
  } else {
    if (((tmpvar_4 > 0.5) && (tmpvar_4 <= 1.0))) {
      realCoord_2 = (realCoord_2 - _TargetSize);
      vec2 tmpvar_13;
      tmpvar_13 = (realCoord_2 + (tmpvar_5 * (
        (tmpvar_4 - 0.5)
       * 2.0)));
      realCoord_2 = tmpvar_13;
      vec2 uv_14;
      uv_14 = (tmpvar_13 / _TargetSize);
      vec3 color_16;
      vec2 pixelStep_17;
      pixelStep_17 = (((
        normalize(tmpvar_5)
       * 3.0) * (
        (1.0 - tmpvar_4)
       * 2.0)) / _TargetSize);
      for (int i_15 = -8; i_15 <= 8; i_15++) {
        vec2 newCoord_18;
        vec2 tmpvar_19;
        tmpvar_19 = abs((uv_14 + (pixelStep_17 * 
          float(i_15)
        )));
        newCoord_18 = tmpvar_19;
        if ((tmpvar_19.x > 1.0)) {
          newCoord_18.x = (1.0 - fract(tmpvar_19.x));
        };
        if ((tmpvar_19.y > 1.0)) {
          newCoord_18.y = (1.0 - fract(tmpvar_19.y));
        };
        color_16 = (color_16 + texture2D (_NextTexture, newCoord_18).xyz);
      };
      color_16 = (color_16 / 17.0);
      result_1 = color_16;
    } else {
      if ((tmpvar_4 > 1.0)) {
        result_1 = texture2D (_NextTexture, xlv_TEXCOORD0).xyz;
      };
    };
  };
  vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = result_1;
  gl_FragData[0] = tmpvar_20;
}

]===],
	},
}

end
