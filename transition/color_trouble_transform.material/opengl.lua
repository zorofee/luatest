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
varying vec2 xlv_TEXCOORD0;
void main ()
{
  vec4 finalColor_1;
  if ((_Progress >= 0.5)) {
    vec2 uv_2;
    uv_2 = xlv_TEXCOORD0;
    float p_3;
    p_3 = (1.0 - clamp (_Progress, 0.0, 1.0));
    float maxOffset_5;
    vec3 color_6;
    float time_7;
    float amount_8;
    float tmpvar_9;
    tmpvar_9 = (0.8 * p_3);
    amount_8 = tmpvar_9;
    float tmpvar_10;
    tmpvar_10 = ((_Progress * 29.0) * p_3);
    time_7 = tmpvar_10;
    color_6 = texture2D (_NextTexture, xlv_TEXCOORD0).xyz;
    maxOffset_5 = (tmpvar_9 / 2.0);
    for (float i_4 = 0.0; i_4 <= (10.0 * amount_8); i_4 += 1.0) {
      vec2 tmpvar_11;
      tmpvar_11.x = time_7;
      tmpvar_11.y = (5517.0 + i_4);
      float tmpvar_12;
      tmpvar_12 = fract((sin(
        dot (tmpvar_11, vec2(12.9898, 4.1414))
      ) * 43758.55));
      vec2 tmpvar_13;
      tmpvar_13.x = time_7;
      tmpvar_13.y = (9525.0 + i_4);
      float tmpvar_14;
      tmpvar_14 = (float((uv_2.y >= tmpvar_12)) - float((uv_2.y >= 
        fract((tmpvar_12 + (fract(
          (sin(dot (tmpvar_13, vec2(12.9898, 4.1414))) * 43758.55)
        ) * 0.2)))
      )));
      if ((tmpvar_14 == 1.0)) {
        vec2 uvOff_15;
        vec2 tmpvar_16;
        tmpvar_16.x = time_7;
        tmpvar_16.y = (9177.0 + i_4);
        float xlat_varmin_17;
        xlat_varmin_17 = -(maxOffset_5);
        uvOff_15.y = uv_2.y;
        uvOff_15.x = (uv_2.x + (xlat_varmin_17 + (
          fract((sin(dot (tmpvar_16, vec2(12.9898, 4.1414))) * 43758.55))
         * 
          (maxOffset_5 - xlat_varmin_17)
        )));
        vec2 tmpvar_18;
        tmpvar_18 = fract(uvOff_15);
        uvOff_15 = tmpvar_18;
        color_6 = texture2D (_NextTexture, tmpvar_18).xyz;
      };
    };
    float tmpvar_19;
    tmpvar_19 = (tmpvar_9 / 6.0);
    vec2 tmpvar_20;
    tmpvar_20.y = 3515.0;
    tmpvar_20.x = tmpvar_10;
    float xlat_varmin_21;
    xlat_varmin_21 = -(tmpvar_19);
    vec2 tmpvar_22;
    tmpvar_22.y = 7525.0;
    tmpvar_22.x = floor(tmpvar_10);
    float xlat_varmin_23;
    xlat_varmin_23 = -(tmpvar_19);
    vec2 tmpvar_24;
    tmpvar_24.x = (xlat_varmin_21 + (fract(
      (sin(dot (tmpvar_20, vec2(12.9898, 4.1414))) * 43758.55)
    ) * (tmpvar_19 - xlat_varmin_21)));
    tmpvar_24.y = (xlat_varmin_23 + (fract(
      (sin(dot (tmpvar_22, vec2(12.9898, 4.1414))) * 43758.55)
    ) * (tmpvar_19 - xlat_varmin_23)));
    vec2 tmpvar_25;
    tmpvar_25 = fract((xlv_TEXCOORD0 + tmpvar_24));
    vec2 tmpvar_26;
    tmpvar_26.y = 9145.0;
    tmpvar_26.x = tmpvar_10;
    float tmpvar_27;
    tmpvar_27 = fract((sin(
      dot (tmpvar_26, vec2(12.9898, 4.1414))
    ) * 43758.55));
    if ((tmpvar_27 < 0.33)) {
      color_6.x = texture2D (_NextTexture, tmpvar_25).x;
    } else {
      if ((tmpvar_27 < 0.66)) {
        color_6.y = texture2D (_NextTexture, tmpvar_25).y;
      } else {
        color_6.z = texture2D (_NextTexture, tmpvar_25).z;
      };
    };
    vec4 tmpvar_28;
    tmpvar_28.w = 1.0;
    tmpvar_28.xyz = color_6;
    finalColor_1 = tmpvar_28;
  } else {
    float tmpvar_29;
    tmpvar_29 = clamp (_Progress, 0.0, 1.0);
    vec2 uv_30;
    uv_30 = xlv_TEXCOORD0;
    float maxOffset_32;
    vec3 color_33;
    float time_34;
    float amount_35;
    float tmpvar_36;
    tmpvar_36 = (0.8 * tmpvar_29);
    amount_35 = tmpvar_36;
    float tmpvar_37;
    tmpvar_37 = ((_Progress * 29.0) * tmpvar_29);
    time_34 = tmpvar_37;
    color_33 = texture2D (_PrevTexture, xlv_TEXCOORD0).xyz;
    maxOffset_32 = (tmpvar_36 / 2.0);
    for (float i_31 = 0.0; i_31 <= (10.0 * amount_35); i_31 += 1.0) {
      vec2 tmpvar_38;
      tmpvar_38.x = time_34;
      tmpvar_38.y = (5517.0 + i_31);
      float tmpvar_39;
      tmpvar_39 = fract((sin(
        dot (tmpvar_38, vec2(12.9898, 4.1414))
      ) * 43758.55));
      vec2 tmpvar_40;
      tmpvar_40.x = time_34;
      tmpvar_40.y = (9525.0 + i_31);
      float tmpvar_41;
      tmpvar_41 = (float((uv_30.y >= tmpvar_39)) - float((uv_30.y >= 
        fract((tmpvar_39 + (fract(
          (sin(dot (tmpvar_40, vec2(12.9898, 4.1414))) * 43758.55)
        ) * 0.2)))
      )));
      if ((tmpvar_41 == 1.0)) {
        vec2 uvOff_42;
        vec2 tmpvar_43;
        tmpvar_43.x = time_34;
        tmpvar_43.y = (9177.0 + i_31);
        float xlat_varmin_44;
        xlat_varmin_44 = -(maxOffset_32);
        uvOff_42.y = uv_30.y;
        uvOff_42.x = (uv_30.x + (xlat_varmin_44 + (
          fract((sin(dot (tmpvar_43, vec2(12.9898, 4.1414))) * 43758.55))
         * 
          (maxOffset_32 - xlat_varmin_44)
        )));
        vec2 tmpvar_45;
        tmpvar_45 = fract(uvOff_42);
        uvOff_42 = tmpvar_45;
        color_33 = texture2D (_PrevTexture, tmpvar_45).xyz;
      };
    };
    float tmpvar_46;
    tmpvar_46 = (tmpvar_36 / 6.0);
    vec2 tmpvar_47;
    tmpvar_47.y = 3515.0;
    tmpvar_47.x = tmpvar_37;
    float xlat_varmin_48;
    xlat_varmin_48 = -(tmpvar_46);
    vec2 tmpvar_49;
    tmpvar_49.y = 7525.0;
    tmpvar_49.x = floor(tmpvar_37);
    float xlat_varmin_50;
    xlat_varmin_50 = -(tmpvar_46);
    vec2 tmpvar_51;
    tmpvar_51.x = (xlat_varmin_48 + (fract(
      (sin(dot (tmpvar_47, vec2(12.9898, 4.1414))) * 43758.55)
    ) * (tmpvar_46 - xlat_varmin_48)));
    tmpvar_51.y = (xlat_varmin_50 + (fract(
      (sin(dot (tmpvar_49, vec2(12.9898, 4.1414))) * 43758.55)
    ) * (tmpvar_46 - xlat_varmin_50)));
    vec2 tmpvar_52;
    tmpvar_52 = fract((xlv_TEXCOORD0 + tmpvar_51));
    vec2 tmpvar_53;
    tmpvar_53.y = 9145.0;
    tmpvar_53.x = tmpvar_37;
    float tmpvar_54;
    tmpvar_54 = fract((sin(
      dot (tmpvar_53, vec2(12.9898, 4.1414))
    ) * 43758.55));
    if ((tmpvar_54 < 0.33)) {
      color_33.x = texture2D (_PrevTexture, tmpvar_52).x;
    } else {
      if ((tmpvar_54 < 0.66)) {
        color_33.y = texture2D (_PrevTexture, tmpvar_52).y;
      } else {
        color_33.z = texture2D (_PrevTexture, tmpvar_52).z;
      };
    };
    vec4 tmpvar_55;
    tmpvar_55.w = 1.0;
    tmpvar_55.xyz = color_33;
    finalColor_1 = tmpvar_55;
  };
  gl_FragData[0] = finalColor_1;
}

]===],
	},
}

end
