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
		shaderApi = "d3d11",
		keyWords = {},
		vsBufferSize = "1632",
		vsAttributes = {
			{
				attName = "POSITION",
				attID = "1",
			},
			{
				attName = "TEXCOORD",
				attID = "16",
			},
		},
		vsUniforms = {
			{
				varName = "DEVICE_COORDINATE_Y_FLIP",
				varType = "float",
				varSit = "",
				varNum = "1",
				varRegIndex = "1600",
				varRegCount = "1",
			},
			},
		psBufferSize = "1616",
		psUniforms = {
			{
				varName = "_Progress",
				varType = "float",
				varSit = "",
				varNum = "1",
				varRegIndex = "1600",
				varRegCount = "1",
			},
			{
				varName = "_Direction",
				varType = "float",
				varSit = "",
				varNum = "1",
				varRegIndex = "1604",
				varRegCount = "1",
			},
			{
				varName = "_TargetSize",
				varType = "float2",
				varSit = "",
				varNum = "1",
				varRegIndex = "1608",
				varRegCount = "1",
			},
			{
				varName = "_PrevTexture",
				varType = "sampler2D",
				varSit = "0",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
			{
				varName = "_NextTexture",
				varType = "sampler2D",
				varSit = "0",
				varNum = "1",
				varRegIndex = "1",
				varRegCount = "1",
			},
			},
		vsShader = [===[44584243067AA7F443808C789A819F1FF150BB3F01000000D0010000030000002C00000080000000D80000004953474E4C000000020000000800000038000000000000000000000003000000000000000F0F0000410000000000000000000000030000000100000003030000504F534954494F4E00544558434F4F524400ABAB4F53474E5000000002000000080000003800000000000000000000000300000000000000030C000041000000000000000100000003000000010000000F000000544558434F4F52440053565F504F534954494F4E00ABABAB53484558F0000000500001003C0000006A08000159000004468E200000000000650000005F000003F2101000000000005F000003321010000100000065000003322010000000000067000004F220100001000000010000006800000201000000360000053220100000000000461010000100000036000005D200100000000000061E1000000000000000000742001000000000003A001000000000002A001000000000003800000742201000010000002A00100000000000014000000000003F3800000822001000000000001A101000000000000A802000000000006400000036000005B220100001000000460C1000000000003E000001]===],
		psShader = [===[44584243A987DA9F6A5CF8633A4CC60E176E1EB201000000C4080000030000002C00000084000000B80000004953474E50000000020000000800000038000000000000000000000003000000000000000303000041000000000000000100000003000000010000000F000000544558434F4F52440053565F504F534954494F4E00ABABAB4F53474E2C000000010000000800000020000000000000000000000003000000000000000F00000053565F54617267657400ABAB534845580408000050000000010200006A08000159000004468E200000000000650000005A00000300601000000000005A0000030060100001000000581800040070100000000000555500005818000400701000010000005555000062100003321010000000000065000003F22010000000000068000002050000000E0000081200100000000000014000000000A0402A80200000000000640000003100000822001000000000000A8020000000000064000000014000000000003F3800000942001000000000000A80200000000000640000000A80200000000000640000003800000742001000000000002A001000000000002A001000000000003800000842001000000000002A001000000000000A80200000000000640000003800000742001000000000002A0010000000000001400000000080410000000882001000000000000A802000000000006400000001400000000080BF3800000712001000010000003A001000000000003A001000000000003800000712001000010000000A001000010000000A001000010000003800000782001000000000003A001000000000000A001000010000003200000982001000000000003A001000000000000140000000008041014000000000803F3700000922001000000000001A001000000000002A001000000000003A001000000000001B00000642001000000000001A80200000000000640000003100000A3200100001000000560510000000000002400000DEFFFF3E0000003F00000000000000002000000742001000000000002A0010000000000001400000010000000000000AC2001000010000000614100000000000024000000000000000000000000000BF000000BF0000000782001000000000001A00100000000000014000000000803F3200000C3200100002000000E60A100001000000F60F100000000000024000000000003F0000003F00000000000000000000000BF200100003000000560510804100000000000000024000000000803F0000803F00000040000000403200000CF200100004000000E60E100001000000460E100003000000024000000000003F0000003F0000003F0000003F370000093200100002000000A60A100000000000460010000200000046001000040000003200000CC200100001000000A60E10000100000056051000000000000240000000000000000000000000003F0000003F37000009C200100000000000A60A100000000000A60E100001000000A60E10000400000037000009C20010000000000006001000010000000604100002000000A60E1000000000001F0004031A001000010000000000000A3200100001000000E60A10000000000002400000000000BF000000BF0000000000000000360000087200100002000000024000000000000000000000000000000000000036000005420010000100000001400000F6FFFFFF30000001220000078200100001000000014000000A0000002A00100001000000030004033A001000010000002B00000582001000010000002A001000010000003800000782001000010000000A001000000000003A001000010000000F0000078200100001000000F60F1000010000005605100000000000320000095200100003000000F60F1000010000000601100001000000A60B1000000000003100000B3200100004000000024000000000803F0000803F00000000000000008600108081000000030000000000000BC20010000400000006081080C10000000300000002400000000000000000000000000040000000403700000A52001000030000000601100004000000A60B1000040000000602108081000000030000004500008BC200008043551500D2001000030000008600100003000000C6791000000000000060100000000000000000077200100002000000460210000200000086031000030000001E00000742001000010000002A001000010000000140000001000000160000013800000A7200100001000000460210000200000002400000310C433D310C433D310C433D00000000120000010000000A3200100002000000E60A10000000000002400000000000BF000000BF000000000000000036000008D200100003000000024000000000000000000000000000000000000036000005220010000000000001400000F6FFFFFF30000001220000078200100001000000014000000A0000001A00100000000000030004033A001000010000002B00000582001000010000001A001000000000003800000782001000010000000A001000000000003A001000010000000F0000078200100001000000F60F100001000000560510000300000032000009C200100002000000F60F1000010000000604100002000000A60E1000000000003100000B3200100004000000024000000000803F0000803F0000000000000000E60A108081000000020000000000000BC200100004000000A60E1080C10000000200000002400000000000000000000000000040000000403700000AC2001000020000000604100004000000A60E100004000000A60E108081000000020000004500008BC2000080435515007200100004000000E60A100002000000467E100001000000006010000100000000000007D200100003000000060E10000300000006091000040000001E00000722001000000000001A001000000000000140000001000000160000013800000A7200100001000000860310000300000002400000310C433D310C433D310C433D00000000150000013600000572201000000000004602100001000000360000058220100000000000014000000000803F3E000001]===],
	},
}

end
