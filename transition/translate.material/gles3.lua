function DefineParams()
	Properties = 
	{
		
_PrevTexture = {"prev texture",TEXTURE2D,"prevtex"},
_NextTexture = {"next texture",TEXTURE2D,"nexttex"},
_Progress = {"progress",FLOAT,"1.0"},

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
 
ShaderName = "UVTransform"
RenderQueue = "Transparent"
end

function Always()

COLOR_MASK = COLOR_RGBA
ALPAH_MODE = { ALPAH_BLEND, SRC_ALPHA, ONE_MINUS_SRC_ALPHA, ONE, ONE }
DRAW_MODE = { CULL_FACE_BACK, DEPTH_MASK_OFF, DEPTH_TEST_ON, DEPTH_FUNCTION_LESS }
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
uniform highp float _Direction;
in highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp float compare_1;
  highp vec2 uvNext_2;
  highp vec2 uvPrev_3;
  lowp vec4 fragColor_4;
  highp float tmpvar_5;
  if ((_Progress < 0.5)) {
    highp float tmpvar_6;
    tmpvar_6 = (_Progress * _Progress);
    tmpvar_5 = ((16.0 * _Progress) * (tmpvar_6 * tmpvar_6));
  } else {
    highp float tmpvar_7;
    tmpvar_7 = (_Progress - 1.0);
    tmpvar_5 = (1.0 + ((
      (16.0 * tmpvar_7)
     * 
      (tmpvar_7 * tmpvar_7)
    ) * (tmpvar_7 * tmpvar_7)));
  };
  highp int tmpvar_8;
  tmpvar_8 = int(_Direction);
  if ((tmpvar_8 == 1)) {
    compare_1 = (xlv_TEXCOORD0.y - (1.0 - tmpvar_5));
    highp vec2 tmpvar_9;
    tmpvar_9.x = 0.0;
    tmpvar_9.y = tmpvar_5;
    uvPrev_3 = (xlv_TEXCOORD0 + tmpvar_9);
    highp vec2 tmpvar_10;
    tmpvar_10.x = 0.0;
    tmpvar_10.y = (1.0 - tmpvar_5);
    uvNext_2 = (xlv_TEXCOORD0 - tmpvar_10);
  } else {
    if ((tmpvar_8 == 2)) {
      compare_1 = (tmpvar_5 - xlv_TEXCOORD0.y);
      highp float tmpvar_11;
      if ((_Progress < 0.5)) {
        highp float tmpvar_12;
        tmpvar_12 = (_Progress * _Progress);
        tmpvar_11 = ((16.0 * _Progress) * (tmpvar_12 * tmpvar_12));
      } else {
        highp float tmpvar_13;
        tmpvar_13 = (_Progress - 1.0);
        tmpvar_11 = (1.0 + ((
          (16.0 * tmpvar_13)
         * 
          (tmpvar_13 * tmpvar_13)
        ) * (tmpvar_13 * tmpvar_13)));
      };
      highp vec2 tmpvar_14;
      tmpvar_14.x = 0.0;
      tmpvar_14.y = tmpvar_11;
      uvPrev_3 = (xlv_TEXCOORD0 - tmpvar_14);
      highp vec2 tmpvar_15;
      tmpvar_15.x = 0.0;
      tmpvar_15.y = (1.0 - tmpvar_5);
      uvNext_2 = (xlv_TEXCOORD0 + tmpvar_15);
    } else {
      if ((tmpvar_8 == 3)) {
        compare_1 = (xlv_TEXCOORD0.x - (1.0 - tmpvar_5));
        highp float tmpvar_16;
        if ((_Progress < 0.5)) {
          highp float tmpvar_17;
          tmpvar_17 = (_Progress * _Progress);
          tmpvar_16 = ((16.0 * _Progress) * (tmpvar_17 * tmpvar_17));
        } else {
          highp float tmpvar_18;
          tmpvar_18 = (_Progress - 1.0);
          tmpvar_16 = (1.0 + ((
            (16.0 * tmpvar_18)
           * 
            (tmpvar_18 * tmpvar_18)
          ) * (tmpvar_18 * tmpvar_18)));
        };
        highp vec2 tmpvar_19;
        tmpvar_19.y = 0.0;
        tmpvar_19.x = tmpvar_16;
        uvPrev_3 = (xlv_TEXCOORD0 + tmpvar_19);
        highp vec2 tmpvar_20;
        tmpvar_20.y = 0.0;
        tmpvar_20.x = (1.0 - tmpvar_5);
        uvNext_2 = (xlv_TEXCOORD0 - tmpvar_20);
      } else {
        if ((tmpvar_8 == 4)) {
          compare_1 = (tmpvar_5 - xlv_TEXCOORD0.x);
          highp float tmpvar_21;
          if ((_Progress < 0.5)) {
            highp float tmpvar_22;
            tmpvar_22 = (_Progress * _Progress);
            tmpvar_21 = ((16.0 * _Progress) * (tmpvar_22 * tmpvar_22));
          } else {
            highp float tmpvar_23;
            tmpvar_23 = (_Progress - 1.0);
            tmpvar_21 = (1.0 + ((
              (16.0 * tmpvar_23)
             * 
              (tmpvar_23 * tmpvar_23)
            ) * (tmpvar_23 * tmpvar_23)));
          };
          highp vec2 tmpvar_24;
          tmpvar_24.y = 0.0;
          tmpvar_24.x = tmpvar_21;
          uvPrev_3 = (xlv_TEXCOORD0 - tmpvar_24);
          highp vec2 tmpvar_25;
          tmpvar_25.y = 0.0;
          tmpvar_25.x = (1.0 - tmpvar_5);
          uvNext_2 = (xlv_TEXCOORD0 + tmpvar_25);
        };
      };
    };
  };
  if ((compare_1 > 0.0)) {
    fragColor_4 = texture (_NextTexture, uvNext_2);
  } else {
    fragColor_4 = texture (_PrevTexture, uvPrev_3);
  };
  _glesFragData[0] = fragColor_4;
}

]===],
	},
}

end
