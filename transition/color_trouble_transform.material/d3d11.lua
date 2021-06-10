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
		shaderApi = "d3d11",
		keyWords = {},
		vsBufferSize = "1696",
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
				varName = "LOCALWORLD_TRANSFORM",
				varType = "float4x4",
				varSit = "",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "4",
			},
			{
				varName = "WORLD_POSITION",
				varType = "float3",
				varSit = "",
				varNum = "1",
				varRegIndex = "64",
				varRegCount = "1",
			},
			{
				varName = "DEVICE_COORDINATE_Y_FLIP",
				varType = "float",
				varSit = "",
				varNum = "1",
				varRegIndex = "1680",
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
				varName = "_NextTexture",
				varType = "sampler2D",
				varSit = "0",
				varNum = "1",
				varRegIndex = "0",
				varRegCount = "1",
			},
			{
				varName = "_PrevTexture",
				varType = "sampler2D",
				varSit = "0",
				varNum = "1",
				varRegIndex = "1",
				varRegCount = "1",
			},
			},
		vsShader = [===[445842434DA24CCCD969971CB891F4E0688A0C1901000000C4020000030000002C00000080000000D80000004953474E4C000000020000000800000038000000000000000000000003000000000000000F0F0000410000000000000000000000030000000100000003030000504F534954494F4E00544558434F4F524400ABAB4F53474E5000000002000000080000003800000000000000000000000300000000000000030C000041000000000000000100000003000000010000000F000000544558434F4F52440053565F504F534954494F4E00ABABAB53484558E401000050000100790000006A08000159000004468E2000000000006A0000005F000003F2101000000000005F000003321010000100000065000003322010000000000067000004F22010000100000001000000680000020200000036000005322010000000000046101000010000000E00000A1200100000000000024000000000803F0000803F0000803F0000803F3A101000000000003800000772001000000000000600100000000000461210000000000038000008720010000100000056051000000000004682200000000000010000003200000AB200100000000000468820000000000000000000060010000000000046081000010000003200000A7200100000000000468220000000000002000000A60A1000000000004603100000000000000000087200100000000000460210000000000046822000000000000300000000000008320010000000000046001000000000004680200000000000040000003800000822001000000000001A001000000000000A802000000000006900000036000005322010000100000046001000000000000000000712001000000000002A00100000000000014000000000803F3800000742201000010000000A00100000000000014000000000003F360000058220100001000000014000000000803F3E000001]===],
		psShader = [===[44584243F91EC0EECD457402A0383AAC510170CB010000000C100000030000002C00000084000000B80000004953474E50000000020000000800000038000000000000000000000003000000000000000303000041000000000000000100000003000000010000000F000000544558434F4F52440053565F504F534954494F4E00ABABAB4F53474E2C000000010000000800000020000000000000000000000003000000000000000F00000053565F54617267657400ABAB534845584C0F000050000000D30300006A08000159000004468E200000000000650000005A00000300601000000000005A0000030060100001000000581800040070100000000000555500005818000400701000010000005555000062100003321010000000000065000003F22010000000000068000002050000001D00000812001000000000000A8020000000000064000000014000000000003F1F0004030A001000000000003620000612001000000000000A80200000000000640000000000000812001000000000000A0010804100000000000000014000000000803F3800000822001000000000000A001000000000000A80200000000000640000003800000712001000010000001A00100000000000014000000000E8414500008BC200008043551500E2001000000000004610100000000000367910000000000000601000010000003800000AF200100002000000060010000000000002400000CDCCCC3E00000041CDCC4C3F8988083E1A00000522001000030000001A1010000000000036000005720010000400000096071000000000003600000582001000040000000140000000000000300000013100000742001000030000001A001000020000003A00100004000000030004032A001000030000000000000AE200100001000000F60F10000400000002400000000000000068AC4500D414460000803F0F00000A420010000300000046001000010000000240000039D64F415986844000000000000000004D000006420010000300000000D000002A001000030000003800000742001000030000002A00100003000000014000008CEE2A470F00000A820010000300000086001000010000000240000039D64F415986844000000000000000004D000006820010000300000000D000003A001000030000003800000782001000030000003A00100003000000014000008CEE2A471A000005C200100003000000A60E1000030000003200000982001000030000003A0010000300000001400000CDCC4C3E2A001000030000001A00000582001000030000003A001000030000001D000007C2001000030000005615100000000000A60E1000030000000100000742001000030000002A00100003000000014000000000803F3700000982001000030000003A0010000300000001400000000080BF01400000000000800000000742001000030000003A001000030000002A001000030000001800000742001000030000002A00100003000000014000000000803F1F0004032A001000030000000000000722001000010000003A001000040000000140000000640F460F00000A420010000300000046001000010000000240000039D64F415986844000000000000000004D000006420010000300000000D000002A001000030000003800000742001000030000002A00100003000000014000008CEE2A471A00000542001000030000002A001000030000003200000A42001000030000002A001000030000002A001000020000000A00108041000000020000000000000742001000030000002A001000030000000A101000000000001A00000512001000030000002A001000030000004500008BC20000804355150072001000040000004600100003000000467E1000000000000060100001000000150000013600000582001000040000003A0010000100000016000001360000086200100001000000024000000000000000B05B4500E40E46000000000F00000A220010000000000046001000010000000240000039D64F415986844000000000000000004D000006220010000000000000D000001A001000000000003800000A32001000000000004600100000000000024000008988883E8CEE2A4700000000000000001A00000522001000000000001A001000000000003200000A12001000020000001A001000000000000A001000000000003A00108041000000020000004100000512001000030000000A00100001000000360000052200100003000000014000000028EB450F00000A220010000000000046001000030000000240000039D64F415986844000000000000000004D000006220010000000000000D000001A001000000000003800000722001000000000001A00100000000000014000008CEE2A471A00000522001000000000001A001000000000003200000A22001000020000001A001000000000000A001000000000003A0010804100000002000000000000073200100000000000460010000200000046101000000000000F00000A420010000000000086001000010000000240000039D64F415986844000000000000000004D000006420010000000000000D000002A001000000000003800000742001000000000002A00100000000000014000008CEE2A471A000005720010000000000046021000000000003100000782001000000000002A0010000000000001400000C3F5A83E1F0004033A001000000000004500008BC20000804355150012001000040000004600100000000000467E10000000000000601000010000003600000582001000040000002A001000040000003600000572001000040000004603100004000000120000013100000742001000000000002A0010000000000001400000C3F5283F1F0004032A001000000000004500008BC20000804355150022001000040000004600100000000000667C1000000000000060100001000000120000014500008BC20000804355150042001000040000004600100000000000167E10000000000000601000010000001500000115000001120000013620000612001000000000000A80200000000000640000003800000822001000000000000A001000000000000A80200000000000640000003800000712001000010000001A00100000000000014000000000E8414500008BC200008043551500E2001000000000004610100000000000367910000100000000601000000000003800000AF200100002000000060010000000000002400000CDCCCC3E00000041CDCC4C3F8988083E1A00000522001000030000001A1010000000000036000005720010000400000096071000000000003600000582001000040000000140000000000000300000013100000742001000030000001A001000020000003A00100004000000030004032A001000030000000000000AE200100001000000F60F10000400000002400000000000000068AC4500D414460000803F0F00000A420010000300000046001000010000000240000039D64F415986844000000000000000004D000006420010000300000000D000002A001000030000003800000742001000030000002A00100003000000014000008CEE2A470F00000A820010000300000086001000010000000240000039D64F415986844000000000000000004D000006820010000300000000D000003A001000030000003800000782001000030000003A00100003000000014000008CEE2A471A000005C200100003000000A60E1000030000003200000982001000030000003A0010000300000001400000CDCC4C3E2A001000030000001A00000582001000030000003A001000030000001D000007C2001000030000005615100000000000A60E1000030000000100000742001000030000002A00100003000000014000000000803F3700000982001000030000003A0010000300000001400000000080BF01400000000000800000000742001000030000003A001000030000002A001000030000001800000742001000030000002A00100003000000014000000000803F1F0004032A001000030000000000000722001000010000003A001000040000000140000000640F460F00000A420010000300000046001000010000000240000039D64F415986844000000000000000004D000006420010000300000000D000002A001000030000003800000742001000030000002A00100003000000014000008CEE2A471A00000542001000030000002A001000030000003200000A42001000030000002A001000030000002A001000020000000A00108041000000020000000000000742001000030000002A001000030000000A101000000000001A00000512001000030000002A001000030000004500008BC20000804355150072001000040000004600100003000000467E1000010000000060100000000000150000013600000582001000040000003A0010000100000016000001360000086200100001000000024000000000000000B05B4500E40E46000000000F00000A220010000000000046001000010000000240000039D64F415986844000000000000000004D000006220010000000000000D000001A001000000000003800000722001000000000001A00100000000000014000008CEE2A471A00000522001000000000001A001000000000003800000712001000000000000A00100000000000014000008988883E3200000A12001000020000001A001000000000000A001000000000003A00108041000000020000004100000512001000030000000A00100001000000360000052200100003000000014000000028EB450F00000A220010000000000046001000030000000240000039D64F415986844000000000000000004D000006220010000000000000D000001A001000000000003800000722001000000000001A00100000000000014000008CEE2A471A00000522001000000000001A001000000000003200000A22001000020000001A001000000000000A001000000000003A0010804100000002000000000000073200100000000000460010000200000046101000000000000F00000A420010000000000086001000010000000240000039D64F415986844000000000000000004D000006420010000000000000D000002A001000000000003800000742001000000000002A00100000000000014000008CEE2A471A000005720010000000000046021000000000003100000782001000000000002A0010000000000001400000C3F5A83E1F0004033A001000000000004500008BC20000804355150012001000040000004600100000000000467E10000100000000601000000000003600000582001000040000002A001000040000003600000572001000040000004603100004000000120000013100000742001000000000002A0010000000000001400000C3F5283F1F0004032A001000000000004500008BC20000804355150022001000040000004600100000000000667C1000010000000060100000000000120000014500008BC20000804355150042001000040000004600100000000000167E10000100000000601000000000001500000115000001150000013600000572201000000000004602100004000000360000058220100000000000014000000000803F3E000001]===],
	},
}

end