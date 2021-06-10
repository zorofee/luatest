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
		_Direction = "Enum(up,1,down,2,left,3,right,4)", 
	}
	
end




function Init()
	PassNames = 
	{
		"Always"
	}

ShaderName = "UvTranslateInvert"
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
				varName = "_TargetSize",
				varType = "float2",
				varSit = "",
				varNum = "1",
				varRegIndex = "1604",
				varRegCount = "1",
			},
			{
				varName = "_Direction",
				varType = "float",
				varSit = "",
				varNum = "1",
				varRegIndex = "1612",
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
		psShader = [===[445842430ECF50E9FBA05CFCE07AD6C129B8F34E01000000D8230000030000002C00000084000000B80000004953474E50000000020000000800000038000000000000000000000003000000000000000303000041000000000000000100000003000000010000000F000000544558434F4F52440053565F504F534954494F4E00ABABAB4F53474E2C000000010000000800000020000000000000000000000003000000000000000F00000053565F54617267657400ABAB534845581823000050000000C60800006A08000159000004468E200000000000650000005A00000300601000000000005A0000030060100001000000581800040070100000000000555500005818000400701000010000005555000062100003321010000000000065000003F22010000000000068000002070000001B00000612001000000000003A80200000000000640000003100000822001000000000000A8020000000000064000000014000000000003F3800000942001000000000000A80200000000000640000000A80200000000000640000003800000742001000000000002A001000000000002A001000000000003800000842001000000000002A001000000000000A80200000000000640000003800000742001000000000002A0010000000000001400000000080410000000882001000000000000A802000000000006400000001400000000080BF3800000712001000010000003A001000000000003A001000000000003800000712001000010000000A001000010000000A001000010000003800000782001000000000003A001000000000000A001000010000003200000982001000000000003A001000000000000140000000008041014000000000803F3700000922001000000000001A001000000000002A001000000000003A001000000000003100000742001000000000001A00100000000000014000000000003F1F0004032A001000000000000020000742001000000000001A001000000000001A00100000000000000000073200100001000000A60A10000000000016151000000000003100000AC2001000010000000240000000000000000000000000803F0000803F06041000010000000000000B3200100002000000460010804100000001000000024000000000004000000040000000000000000000000008C200100002000000A60A108041000000000000005611100000000000370000093200100001000000E60A100001000000460010000200000046001000010000002000000AF20010000300000006001000000000000240000001000000020000000300000004000000360000063200100002000000E60A108081000000020000003700000982001000000000003A001000030000001A001000020000000A10100000000000370000095200100004000000A60A1000030000005605100001000000F60F1000000000003600000542001000020000000A1010000000000036000005A200100004000000561510000000000037000009F20010000200000056051000030000002602100002000000460E1000040000003600000542001000010000000A1010000000000037000009F20010000100000006001000030000002602100001000000460E1000020000000E00000BF200100002000000024000000000803F0000803F0000803F0000803F96892000000000006400000038000007F200100002000000A60A100000000000460E1000020000004500008BC2000080435515007200100003000000E60A100001000000467E10000000000000601000000000003200000CF200100004000000E60E10000200000002400000000000000000A03F000000000000A0BFE60E1000010000004500008BC20000804355150072001000050000004600100004000000467E10000000000000601000000000004500008BC2000080435515007200100004000000E60A100004000000467E10000000000000601000000000003800000A72001000040000004602100004000000024000005D5C7F3F5D5C7F3F5D5C7F3F000000003200000C72001000040000004602100005000000024000005D5C7F3F5D5C7F3F5D5C7F3F0000000046021000040000003200000CF200100005000000E60E10000200000002400000000000000000204000000000000020C0E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C7200100004000000460210000600000002400000E8737D3FE8737D3FE8737D3F0000000046021000040000003200000C7200100004000000460210000500000002400000E8737D3FE8737D3FE8737D3F0000000046021000040000003200000CF200100005000000E60E10000200000002400000000000000000704000000000000070C0E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C7200100004000000460210000600000002400000E84D7A3FE84D7A3FE84D7A3F0000000046021000040000003200000C7200100004000000460210000500000002400000E84D7A3FE84D7A3FE84D7A3F0000000046021000040000003200000CF200100005000000E60E10000200000002400000000000000000A040000000000000A0C0E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C72001000040000004602100006000000024000004CF6753F4CF6753F4CF6753F0000000046021000040000003200000C72001000040000004602100005000000024000004CF6753F4CF6753F4CF6753F0000000046021000040000003200000CF200100005000000E60E10000200000002400000000000000000C840000000000000C8C0E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C7200100004000000460210000600000002400000607D703F607D703F607D703F0000000046021000040000003200000C7200100004000000460210000500000002400000607D703F607D703F607D703F0000000046021000040000003200000CF200100005000000E60E10000200000002400000000000000000F040000000000000F0C0E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C720010000400000046021000060000000240000065F7693F65F7693F65F7693F0000000046021000040000003200000C720010000400000046021000050000000240000065F7693F65F7693F65F7693F0000000046021000040000003200000CF200100005000000E60E100002000000024000000000000000000C410000000000000CC1E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C7200100004000000460210000600000002400000167C623F167C623F167C623F0000000046021000040000003200000C7200100004000000460210000500000002400000167C623F167C623F167C623F0000000046021000040000003200000CF200100005000000E60E10000200000002400000000000000000204100000000000020C1E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C720010000400000046021000060000000240000018265A3F18265A3F18265A3F0000000046021000040000003200000C720010000400000046021000050000000240000018265A3F18265A3F18265A3F0000000046021000040000003200000CF200100005000000E60E10000200000002400000000000000000344100000000000034C1E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C72001000040000004602100006000000024000005D12513F5D12513F5D12513F0000000046021000040000003200000C72001000040000004602100005000000024000005D12513F5D12513F5D12513F0000000046021000040000003200000CF200100005000000E60E10000200000002400000000000000000484100000000000048C1E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C72001000040000004602100006000000024000007D5F473F7D5F473F7D5F473F0000000046021000040000003200000C72001000040000004602100005000000024000007D5F473F7D5F473F7D5F473F0000000046021000040000003200000CF200100005000000E60E100002000000024000000000000000005C410000000000005CC1E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C72001000040000004602100006000000024000000A2D3D3F0A2D3D3F0A2D3D3F0000000046021000040000003200000C72001000040000004602100005000000024000000A2D3D3F0A2D3D3F0A2D3D3F0000000046021000040000003200000CF200100005000000E60E10000200000002400000000000000000704100000000000070C1E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C7200100004000000460210000600000002400000EA9A323FEA9A323FEA9A323F0000000046021000040000003200000C7200100004000000460210000500000002400000EA9A323FEA9A323FEA9A323F0000000046021000040000003200000CF200100005000000E60E10000200000002400000000000000000824100000000000082C1E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C7200100004000000460210000600000002400000B4C8273FB4C8273FB4C8273F0000000046021000040000003200000C7200100004000000460210000500000002400000B4C8273FB4C8273FB4C8273F0000000046021000040000003200000CF200100005000000E60E100002000000024000000000000000008C410000000000008CC1E60E1000010000004500008BC20000804355150072001000060000004600100005000000467E10000000000000601000000000004500008BC2000080435515007200100005000000E60A100005000000467E10000000000000601000000000003200000C720010000400000046021000060000000240000015D51C3F15D51C3F15D51C3F0000000046021000040000003200000C720010000400000046021000050000000240000015D51C3F15D51C3F15D51C3F0000000046021000040000003200000CF200100001000000460E10000200000002400000000000000000964100000000000096C1460E1000010000004500008BC20000804355150072001000020000004600100001000000467E10000000000000601000000000004500008BC2000080435515007200100001000000E60A100001000000467E10000000000000601000000000003200000C720010000200000046021000020000000240000049DD113F49DD113F49DD113F0000000046021000040000003200000C720010000100000046021000010000000240000049DD113F49DD113F49DD113F000000004602100002000000000000077200100001000000460210000300000046021000010000003800000A7200100001000000460210000100000002400000E4ED1E3DE4ED1E3DE4ED1E3D00000000120000010000000722001000000000001A0010000000000001400000000000BF3200000CC2001000000000005605100000000000024000000000000000000000000000400000004056111000000000003100000A3200100002000000024000000000803F0000803F0000000000000000E60A1000000000000000000BC200100002000000A60E10804100000000000000024000000000000000000000000000400000004037000009C2001000000000000604100002000000A60E100002000000A60E1000000000003200000D3200100002000000560510804100000000000000024000000000004000000040000000000000000016151000000000000000000B3200100003000000E60A10804100000000000000024000000000803F0000803F00000000000000002000000AF200100004000000060010000000000002400000010000000200000003000000040000000000000B320010000200000046001080C100000002000000024000000000803F0000803F00000000000000003700000912001000000000003A001000040000001A001000020000000A10100000000000370000095200100005000000A60A100004000000560510000300000006001000000000003600000542001000020000000A1010000000000036000005A200100005000000561510000000000037000009F20010000200000056051000040000002602100002000000460E1000050000003600000542001000030000000A1010000000000037000009F20010000200000006001000040000002602100003000000460E1000020000003200000A12001000000000001A00108041000000000000000140000000000040014000000000803F0E00000BF200100003000000024000000000803F0000803F0000803F0000803F96892000000000006400000038000007F2001000000000000600100000000000460E1000030000004500008BC2000080435515007200100003000000E60A100002000000467E10000100000000601000010000003200000CF200100004000000E60E10000000000002400000000000000000A03F000000000000A0BFE60E1000020000004500008BC20000804355150072001000050000004600100004000000467E10000100000000601000010000004500008BC2000080435515007200100004000000E60A100004000000467E10000100000000601000010000003800000A72001000040000004602100004000000024000005D5C7F3F5D5C7F3F5D5C7F3F000000003200000C72001000040000004602100005000000024000005D5C7F3F5D5C7F3F5D5C7F3F0000000046021000040000003200000CF200100005000000E60E10000000000002400000000000000000204000000000000020C0E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C7200100004000000460210000600000002400000E8737D3FE8737D3FE8737D3F0000000046021000040000003200000C7200100004000000460210000500000002400000E8737D3FE8737D3FE8737D3F0000000046021000040000003200000CF200100005000000E60E10000000000002400000000000000000704000000000000070C0E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C7200100004000000460210000600000002400000E84D7A3FE84D7A3FE84D7A3F0000000046021000040000003200000C7200100004000000460210000500000002400000E84D7A3FE84D7A3FE84D7A3F0000000046021000040000003200000CF200100005000000E60E10000000000002400000000000000000A040000000000000A0C0E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C72001000040000004602100006000000024000004CF6753F4CF6753F4CF6753F0000000046021000040000003200000C72001000040000004602100005000000024000004CF6753F4CF6753F4CF6753F0000000046021000040000003200000CF200100005000000E60E10000000000002400000000000000000C840000000000000C8C0E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C7200100004000000460210000600000002400000607D703F607D703F607D703F0000000046021000040000003200000C7200100004000000460210000500000002400000607D703F607D703F607D703F0000000046021000040000003200000CF200100005000000E60E10000000000002400000000000000000F040000000000000F0C0E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C720010000400000046021000060000000240000065F7693F65F7693F65F7693F0000000046021000040000003200000C720010000400000046021000050000000240000065F7693F65F7693F65F7693F0000000046021000040000003200000CF200100005000000E60E100000000000024000000000000000000C410000000000000CC1E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C7200100004000000460210000600000002400000167C623F167C623F167C623F0000000046021000040000003200000C7200100004000000460210000500000002400000167C623F167C623F167C623F0000000046021000040000003200000CF200100005000000E60E10000000000002400000000000000000204100000000000020C1E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C720010000400000046021000060000000240000018265A3F18265A3F18265A3F0000000046021000040000003200000C720010000400000046021000050000000240000018265A3F18265A3F18265A3F0000000046021000040000003200000CF200100005000000E60E10000000000002400000000000000000344100000000000034C1E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C72001000040000004602100006000000024000005D12513F5D12513F5D12513F0000000046021000040000003200000C72001000040000004602100005000000024000005D12513F5D12513F5D12513F0000000046021000040000003200000CF200100005000000E60E10000000000002400000000000000000484100000000000048C1E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C72001000040000004602100006000000024000007D5F473F7D5F473F7D5F473F0000000046021000040000003200000C72001000040000004602100005000000024000007D5F473F7D5F473F7D5F473F0000000046021000040000003200000CF200100005000000E60E100000000000024000000000000000005C410000000000005CC1E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C72001000040000004602100006000000024000000A2D3D3F0A2D3D3F0A2D3D3F0000000046021000040000003200000C72001000040000004602100005000000024000000A2D3D3F0A2D3D3F0A2D3D3F0000000046021000040000003200000CF200100005000000E60E10000000000002400000000000000000704100000000000070C1E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C7200100004000000460210000600000002400000EA9A323FEA9A323FEA9A323F0000000046021000040000003200000C7200100004000000460210000500000002400000EA9A323FEA9A323FEA9A323F0000000046021000040000003200000CF200100005000000E60E10000000000002400000000000000000824100000000000082C1E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C7200100004000000460210000600000002400000B4C8273FB4C8273FB4C8273F0000000046021000040000003200000C7200100004000000460210000500000002400000B4C8273FB4C8273FB4C8273F0000000046021000040000003200000CF200100005000000E60E100000000000024000000000000000008C410000000000008CC1E60E1000020000004500008BC20000804355150072001000060000004600100005000000467E10000100000000601000010000004500008BC2000080435515007200100005000000E60A100005000000467E10000100000000601000010000003200000C720010000400000046021000060000000240000015D51C3F15D51C3F15D51C3F0000000046021000040000003200000C720010000400000046021000050000000240000015D51C3F15D51C3F15D51C3F0000000046021000040000003200000CF200100000000000460E10000000000002400000000000000000964100000000000096C1460E1000020000004500008BC20000804355150072001000020000004600100000000000467E10000100000000601000010000004500008BC2000080435515007200100000000000E60A100000000000467E10000100000000601000010000003200000C720010000200000046021000020000000240000049DD113F49DD113F49DD113F0000000046021000040000003200000C720010000000000046021000000000000240000049DD113F49DD113F49DD113F000000004602100002000000000000077200100000000000460210000300000046021000000000003800000A7200100001000000460210000000000002400000E4ED1E3DE4ED1E3DE4ED1E3D00000000150000013600000572201000000000004602100001000000360000058220100000000000014000000000803F3E000001]===],
	},
}
 
end
