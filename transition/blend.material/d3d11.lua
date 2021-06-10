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

ShaderName = "Blend"
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
		psShader = [===[44584243E52FDF83E5F580EF1D4D1C4D156C1B3901000000EC010000030000002C00000084000000B80000004953474E50000000020000000800000038000000000000000000000003000000000000000303000041000000000000000100000003000000010000000F000000544558434F4F52440053565F504F534954494F4E00ABABAB4F53474E2C000000010000000800000020000000000000000000000003000000000000000F00000053565F54617267657400ABAB534845582C010000500000004B0000006A08000159000004468E200000000000650000005A00000300601000000000005A0000030060100001000000581800040070100000000000555500005818000400701000010000005555000062100003321010000000000065000003F22010000000000068000002020000004500008BC20000804355150072001000000000004610100000000000467E10000100000000601000010000004500008BC20000804355150072001000010000004610100000000000467E100000000000006010000000000000000008720010000000000046021000000000004602108041000000010000003200000A722010000000000006802000000000006400000046021000000000004602100001000000360000058220100000000000014000000000803F3E000001]===],
	},
}

end
