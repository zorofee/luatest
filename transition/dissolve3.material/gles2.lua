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
  lowp vec4 fragColor_1;
  highp float gray_2;
  lowp vec4 dColor2_3;
  lowp vec4 sColor2_4;
  lowp vec4 sColor1_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_PrevTexture, xlv_TEXCOORD0);
  sColor1_5 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_NextTexture, xlv_TEXCOORD0);
  sColor2_4 = tmpvar_7;
  highp float tmpvar_8;
  if (((_Progress == 0.0) || (_Progress == 1.0))) {
    tmpvar_8 = _Progress;
  } else {
    highp float tmpvar_9;
    if ((_Progress < 0.5)) {
      tmpvar_9 = (0.5 * exp2((
        (20.0 * _Progress)
       - 10.0)));
    } else {
      tmpvar_9 = (1.0 - (0.5 * exp2(
        (10.0 - (_Progress * 20.0))
      )));
    };
    tmpvar_8 = tmpvar_9;
  };
  highp float tmpvar_10;
  if ((_Progress == 1.0)) {
    tmpvar_10 = _Progress;
  } else {
    tmpvar_10 = (1.0 - exp2((-10.0 * _Progress)));
  };
  highp vec4 texColor_11;
  texColor_11 = tmpvar_6;
  highp vec2 res_uv_12;
  highp vec4 dis_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (((texColor_11 * 0.33) - (texColor_11 * 0.6)) + 1.0);
  dis_13.zw = tmpvar_14.zw;
  dis_13.xy = ((tmpvar_14.xy - vec2(1.0, 1.0)) + vec2(0.198, 0.198));
  dis_13 = (dis_13 * (1.0 - tmpvar_8));
  res_uv_12 = (xlv_TEXCOORD0 + dis_13.xy);
  highp vec4 texColor_15;
  texColor_15 = tmpvar_7;
  highp vec2 res_uv_16;
  highp vec4 dis_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (((texColor_15 * 0.33) - (texColor_15 * 0.4)) + 1.0);
  dis_17.zw = tmpvar_18.zw;
  dis_17.xy = ((tmpvar_18.xy - vec2(1.0, 1.0)) + vec2(0.132, 0.132));
  dis_17 = (dis_17 * tmpvar_10);
  res_uv_16 = (xlv_TEXCOORD0 + dis_17.xy);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_NextTexture, res_uv_12);
  lowp float tmpvar_20;
  tmpvar_20 = dot (min (tmpvar_19, texture2D (_PrevTexture, res_uv_16)).xyz, vec3(0.299, 0.587, 0.114));
  gray_2 = tmpvar_20;
  gray_2 = (gray_2 * 2.0);
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.x = gray_2;
  tmpvar_21.y = gray_2;
  tmpvar_21.z = gray_2;
  dColor2_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp ((_Progress / 0.5), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23 = mix (tmpvar_6, dColor2_3, vec4((tmpvar_22 * (tmpvar_22 * 
    (3.0 - (2.0 * tmpvar_22))
  ))));
  sColor1_5 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (((_Progress - 1.0) / -0.5), 0.0, 1.0);
  highp vec4 tmpvar_25;
  tmpvar_25 = mix (tmpvar_7, tmpvar_19, vec4((tmpvar_24 * (tmpvar_24 * 
    (3.0 - (2.0 * tmpvar_24))
  ))));
  sColor2_4 = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = mix (sColor1_5, sColor2_4, vec4(tmpvar_8));
  fragColor_1 = tmpvar_26;
  gl_FragData[0] = fragColor_1;
}

]===],
	},
}

end
