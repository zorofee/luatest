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

ShaderName = "colortrouble"
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
  lowp vec4 finalColor_1;
  if ((_Progress >= 0.5)) {
    highp vec2 uv_2;
    uv_2 = xlv_TEXCOORD0;
    highp float p_3;
    p_3 = (1.0 - clamp (_Progress, 0.0, 1.0));
    highp float maxOffset_5;
    highp vec3 color_6;
    highp float time_7;
    highp float amount_8;
    highp float tmpvar_9;
    tmpvar_9 = (0.8 * p_3);
    amount_8 = tmpvar_9;
    highp float tmpvar_10;
    tmpvar_10 = ((_Progress * 29.0) * p_3);
    time_7 = tmpvar_10;
    lowp vec4 tmpvar_11;
    tmpvar_11 = texture2D (_NextTexture, xlv_TEXCOORD0);
    highp vec3 tmpvar_12;
    tmpvar_12 = tmpvar_11.xyz;
    color_6 = tmpvar_12;
    maxOffset_5 = (tmpvar_9 / 2.0);
    for (highp float i_4 = 0.0; i_4 <= (10.0 * amount_8); i_4 += 1.0) {
      highp vec2 tmpvar_13;
      tmpvar_13.x = time_7;
      tmpvar_13.y = (5517.0 + i_4);
      highp float tmpvar_14;
      tmpvar_14 = fract((sin(
        dot (tmpvar_13, vec2(12.9898, 4.1414))
      ) * 43758.55));
      highp vec2 tmpvar_15;
      tmpvar_15.x = time_7;
      tmpvar_15.y = (9525.0 + i_4);
      highp float tmpvar_16;
      tmpvar_16 = (float((uv_2.y >= tmpvar_14)) - float((uv_2.y >= 
        fract((tmpvar_14 + (fract(
          (sin(dot (tmpvar_15, vec2(12.9898, 4.1414))) * 43758.55)
        ) * 0.2)))
      )));
      if ((tmpvar_16 == 1.0)) {
        highp vec2 uvOff_17;
        highp vec2 tmpvar_18;
        tmpvar_18.x = time_7;
        tmpvar_18.y = (9177.0 + i_4);
        highp float xlat_varmin_19;
        xlat_varmin_19 = -(maxOffset_5);
        uvOff_17.y = uv_2.y;
        uvOff_17.x = (uv_2.x + (xlat_varmin_19 + (
          fract((sin(dot (tmpvar_18, vec2(12.9898, 4.1414))) * 43758.55))
         * 
          (maxOffset_5 - xlat_varmin_19)
        )));
        highp vec2 tmpvar_20;
        tmpvar_20 = fract(uvOff_17);
        uvOff_17 = tmpvar_20;
        lowp vec4 tmpvar_21;
        tmpvar_21 = texture2D (_NextTexture, tmpvar_20);
        color_6 = tmpvar_21.xyz;
      };
    };
    highp float tmpvar_22;
    tmpvar_22 = (tmpvar_9 / 6.0);
    highp vec2 tmpvar_23;
    tmpvar_23.y = 3515.0;
    tmpvar_23.x = tmpvar_10;
    highp float xlat_varmin_24;
    xlat_varmin_24 = -(tmpvar_22);
    highp vec2 tmpvar_25;
    tmpvar_25.y = 7525.0;
    tmpvar_25.x = floor(tmpvar_10);
    highp float xlat_varmin_26;
    xlat_varmin_26 = -(tmpvar_22);
    highp vec2 tmpvar_27;
    tmpvar_27.x = (xlat_varmin_24 + (fract(
      (sin(dot (tmpvar_23, vec2(12.9898, 4.1414))) * 43758.55)
    ) * (tmpvar_22 - xlat_varmin_24)));
    tmpvar_27.y = (xlat_varmin_26 + (fract(
      (sin(dot (tmpvar_25, vec2(12.9898, 4.1414))) * 43758.55)
    ) * (tmpvar_22 - xlat_varmin_26)));
    highp vec2 tmpvar_28;
    tmpvar_28 = fract((xlv_TEXCOORD0 + tmpvar_27));
    highp vec2 tmpvar_29;
    tmpvar_29.y = 9145.0;
    tmpvar_29.x = tmpvar_10;
    highp float tmpvar_30;
    tmpvar_30 = fract((sin(
      dot (tmpvar_29, vec2(12.9898, 4.1414))
    ) * 43758.55));
    if ((tmpvar_30 < 0.33)) {
      lowp vec4 tmpvar_31;
      tmpvar_31 = texture2D (_NextTexture, tmpvar_28);
      color_6.x = tmpvar_31.x;
    } else {
      if ((tmpvar_30 < 0.66)) {
        lowp vec4 tmpvar_32;
        tmpvar_32 = texture2D (_NextTexture, tmpvar_28);
        color_6.y = tmpvar_32.y;
      } else {
        lowp vec4 tmpvar_33;
        tmpvar_33 = texture2D (_NextTexture, tmpvar_28);
        color_6.z = tmpvar_33.z;
      };
    };
    highp vec4 tmpvar_34;
    tmpvar_34.w = 1.0;
    tmpvar_34.xyz = color_6;
    finalColor_1 = tmpvar_34;
  } else {
    highp float tmpvar_35;
    tmpvar_35 = clamp (_Progress, 0.0, 1.0);
    highp vec2 uv_36;
    uv_36 = xlv_TEXCOORD0;
    highp float maxOffset_38;
    highp vec3 color_39;
    highp float time_40;
    highp float amount_41;
    highp float tmpvar_42;
    tmpvar_42 = (0.8 * tmpvar_35);
    amount_41 = tmpvar_42;
    highp float tmpvar_43;
    tmpvar_43 = ((_Progress * 29.0) * tmpvar_35);
    time_40 = tmpvar_43;
    lowp vec4 tmpvar_44;
    tmpvar_44 = texture2D (_PrevTexture, xlv_TEXCOORD0);
    highp vec3 tmpvar_45;
    tmpvar_45 = tmpvar_44.xyz;
    color_39 = tmpvar_45;
    maxOffset_38 = (tmpvar_42 / 2.0);
    for (highp float i_37 = 0.0; i_37 <= (10.0 * amount_41); i_37 += 1.0) {
      highp vec2 tmpvar_46;
      tmpvar_46.x = time_40;
      tmpvar_46.y = (5517.0 + i_37);
      highp float tmpvar_47;
      tmpvar_47 = fract((sin(
        dot (tmpvar_46, vec2(12.9898, 4.1414))
      ) * 43758.55));
      highp vec2 tmpvar_48;
      tmpvar_48.x = time_40;
      tmpvar_48.y = (9525.0 + i_37);
      highp float tmpvar_49;
      tmpvar_49 = (float((uv_36.y >= tmpvar_47)) - float((uv_36.y >= 
        fract((tmpvar_47 + (fract(
          (sin(dot (tmpvar_48, vec2(12.9898, 4.1414))) * 43758.55)
        ) * 0.2)))
      )));
      if ((tmpvar_49 == 1.0)) {
        highp vec2 uvOff_50;
        highp vec2 tmpvar_51;
        tmpvar_51.x = time_40;
        tmpvar_51.y = (9177.0 + i_37);
        highp float xlat_varmin_52;
        xlat_varmin_52 = -(maxOffset_38);
        uvOff_50.y = uv_36.y;
        uvOff_50.x = (uv_36.x + (xlat_varmin_52 + (
          fract((sin(dot (tmpvar_51, vec2(12.9898, 4.1414))) * 43758.55))
         * 
          (maxOffset_38 - xlat_varmin_52)
        )));
        highp vec2 tmpvar_53;
        tmpvar_53 = fract(uvOff_50);
        uvOff_50 = tmpvar_53;
        lowp vec4 tmpvar_54;
        tmpvar_54 = texture2D (_PrevTexture, tmpvar_53);
        color_39 = tmpvar_54.xyz;
      };
    };
    highp float tmpvar_55;
    tmpvar_55 = (tmpvar_42 / 6.0);
    highp vec2 tmpvar_56;
    tmpvar_56.y = 3515.0;
    tmpvar_56.x = tmpvar_43;
    highp float xlat_varmin_57;
    xlat_varmin_57 = -(tmpvar_55);
    highp vec2 tmpvar_58;
    tmpvar_58.y = 7525.0;
    tmpvar_58.x = floor(tmpvar_43);
    highp float xlat_varmin_59;
    xlat_varmin_59 = -(tmpvar_55);
    highp vec2 tmpvar_60;
    tmpvar_60.x = (xlat_varmin_57 + (fract(
      (sin(dot (tmpvar_56, vec2(12.9898, 4.1414))) * 43758.55)
    ) * (tmpvar_55 - xlat_varmin_57)));
    tmpvar_60.y = (xlat_varmin_59 + (fract(
      (sin(dot (tmpvar_58, vec2(12.9898, 4.1414))) * 43758.55)
    ) * (tmpvar_55 - xlat_varmin_59)));
    highp vec2 tmpvar_61;
    tmpvar_61 = fract((xlv_TEXCOORD0 + tmpvar_60));
    highp vec2 tmpvar_62;
    tmpvar_62.y = 9145.0;
    tmpvar_62.x = tmpvar_43;
    highp float tmpvar_63;
    tmpvar_63 = fract((sin(
      dot (tmpvar_62, vec2(12.9898, 4.1414))
    ) * 43758.55));
    if ((tmpvar_63 < 0.33)) {
      lowp vec4 tmpvar_64;
      tmpvar_64 = texture2D (_PrevTexture, tmpvar_61);
      color_39.x = tmpvar_64.x;
    } else {
      if ((tmpvar_63 < 0.66)) {
        lowp vec4 tmpvar_65;
        tmpvar_65 = texture2D (_PrevTexture, tmpvar_61);
        color_39.y = tmpvar_65.y;
      } else {
        lowp vec4 tmpvar_66;
        tmpvar_66 = texture2D (_PrevTexture, tmpvar_61);
        color_39.z = tmpvar_66.z;
      };
    };
    highp vec4 tmpvar_67;
    tmpvar_67.w = 1.0;
    tmpvar_67.xyz = color_39;
    finalColor_1 = tmpvar_67;
  };
  gl_FragData[0] = finalColor_1;
}

]===],
	},
}

end
