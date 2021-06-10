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

ShaderName = "Dissolve3"
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
  float gray_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_PrevTexture, xlv_TEXCOORD0);
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_NextTexture, xlv_TEXCOORD0);
  float tmpvar_4;
  if (((_Progress == 0.0) || (_Progress == 1.0))) {
    tmpvar_4 = _Progress;
  } else {
    float tmpvar_5;
    if ((_Progress < 0.5)) {
      tmpvar_5 = (0.5 * exp2((
        (20.0 * _Progress)
       - 10.0)));
    } else {
      tmpvar_5 = (1.0 - (0.5 * exp2(
        (10.0 - (_Progress * 20.0))
      )));
    };
    tmpvar_4 = tmpvar_5;
  };
  float tmpvar_6;
  if ((_Progress == 1.0)) {
    tmpvar_6 = _Progress;
  } else {
    tmpvar_6 = (1.0 - exp2((-10.0 * _Progress)));
  };
  vec4 dis_7;
  vec4 tmpvar_8;
  tmpvar_8 = (((tmpvar_2 * 0.33) - (tmpvar_2 * 0.6)) + 1.0);
  dis_7.zw = tmpvar_8.zw;
  dis_7.xy = ((tmpvar_8.xy - vec2(1.0, 1.0)) + vec2(0.198, 0.198));
  dis_7 = (dis_7 * (1.0 - tmpvar_4));
  vec4 dis_9;
  vec4 tmpvar_10;
  tmpvar_10 = (((tmpvar_3 * 0.33) - (tmpvar_3 * 0.4)) + 1.0);
  dis_9.zw = tmpvar_10.zw;
  dis_9.xy = ((tmpvar_10.xy - vec2(1.0, 1.0)) + vec2(0.132, 0.132));
  dis_9 = (dis_9 * tmpvar_6);
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (_NextTexture, (xlv_TEXCOORD0 + dis_7.xy));
  gray_1 = (dot (min (tmpvar_11, texture2D (_PrevTexture, 
    (xlv_TEXCOORD0 + dis_9.xy)
  )).xyz, vec3(0.299, 0.587, 0.114)) * 2.0);
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = gray_1;
  tmpvar_12.y = gray_1;
  tmpvar_12.z = gray_1;
  float tmpvar_13;
  tmpvar_13 = clamp ((_Progress / 0.5), 0.0, 1.0);
  float tmpvar_14;
  tmpvar_14 = clamp (((_Progress - 1.0) / -0.5), 0.0, 1.0);
  gl_FragData[0] = mix (mix (tmpvar_2, tmpvar_12, vec4((tmpvar_13 * 
    (tmpvar_13 * (3.0 - (2.0 * tmpvar_13)))
  ))), mix (tmpvar_3, tmpvar_11, vec4((tmpvar_14 * 
    (tmpvar_14 * (3.0 - (2.0 * tmpvar_14)))
  ))), vec4(tmpvar_4));
}

]===],
	},
}

end
