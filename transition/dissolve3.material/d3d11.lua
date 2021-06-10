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
		shaderApi = "d3d11",
		keyWords = {},
		vsBufferSize = "1616",
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
		psShader = [===[44584243B182BB41A6501636A5B4F70E8F272D6A010000000C070000030000002C00000084000000B80000004953474E50000000020000000800000038000000000000000000000003000000000000000303000041000000000000000100000003000000010000000F000000544558434F4F52440053565F504F534954494F4E00ABABAB4F53474E2C000000010000000800000020000000000000000000000003000000000000000F00000053565F54617267657400ABAB534845584C06000050000000930100006A08000159000004468E200000000000650000005A00000300601000000000005A0000030060100001000000581800040070100000000000555500005818000400701000010000005555000062100003321010000000000065000003F22010000000000068000002050000000020000912001000000000000A80200000000000640000000A80200000000000640000003200000922001000000000000A0010000000000001400000000000C001400000000040403800000712001000000000000A001000000000000A001000000000003800000712001000000000000A001000000000001A001000000000003200000A22001000000000000A8020000000000064000000014000000000A04101400000000020C11900000522001000000000001A001000000000003800000722001000000000001A00100000000000014000000000003F3200000B42001000000000000A802080410000000000000064000000014000000000A04101400000000020411900000542001000000000002A001000000000003200000A42001000000000002A0010804100000000000000014000000000003F014000000000803F3100000882001000000000000A8020000000000064000000014000000000003F3700000922001000000000003A001000000000001A001000000000002A001000000000001800000BC200100000000000068020000000000064000000024000000000000000000000000000000000803F3C00000742001000000000003A001000000000002A001000000000003700000A22001000000000002A001000000000000A80200000000000640000001A001000000000000000000842001000000000001A0010804100000000000000014000000000803F4500008BC200008043551500F2001000010000004610100000000000467E10000000000000601000000000003200000F3200100002000000460010000100000002400000713D8ABE713D8ABE00000000000000000240000084C04A3E84C04A3E00000000000000003200000932001000020000004600100002000000A60A10000000000046101000000000004500008BC200008043551500F2001000020000004600100002000000467E10000100000000601000010000003800000842001000000000000A802000000000006400000001400000000020C11900000542001000000000002A001000000000000000000842001000000000002A0010804100000000000000014000000000803F3700000942001000000000003A00100000000000014000000000803F2A001000000000004500008BC200008043551500F2001000030000004610100000000000467E10000100000000601000010000003200000F3200100004000000460010000300000002400000285C8FBD285C8FBD000000000000000002400000032B073E032B073E000000000000000032000009C2001000000000000604100004000000A60A10000000000006141000000000004500008BC2000080435515007200100004000000E60A100000000000467E10000000000000601000000000003300000772001000040000004602100002000000460210000400000000000008F200100002000000460E100002000000460E108041000000030000001000000A42001000000000004602100004000000024000008716993EA245163FD578E93D00000000000000077200100004000000A60A100000000000A60A100000000000360000058200100004000000014000000000803F00000008F200100004000000460E10804100000001000000460E10000400000032000009F2001000010000000600100000000000460E100004000000460E1000010000000000000812001000000000000A802000000000006400000001400000000080BF3820000712001000000000000A0010000000000001400000000000C03200000942001000000000000A0010000000000001400000000000C001400000000040403800000712001000000000000A001000000000000A001000000000003800000712001000000000000A001000000000002A0010000000000032000009F2001000020000000600100000000000460E100002000000460E10000300000000000008F200100002000000460E10804100000001000000460E10000200000032000009F2201000000000005605100000000000460E100002000000460E1000010000003E000001]===],
	},
}

end