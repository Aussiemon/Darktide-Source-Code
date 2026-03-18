-- chunkname: @content/levels/expeditions/safe_zones/wastes/sz_cave_tunnels_001/missions/mission_sz_cave_tunnels_001_main_path.lua

local path_markers = {
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker",
		order = 0,
		position = {
			1,
			38,
			20,
		},
	},
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker_001",
		order = 1,
		position = {
			-8.779674530029297,
			-21.188255310058594,
			19.999998092651367,
		},
	},
}
local main_path_segments = {
	{
		path_length = 68.5485610961914,
		nodes = {
			{
				1,
				38,
				20.012344360351562,
			},
			{
				3.286928415298462,
				27.95210075378418,
				20.089534759521484,
			},
			{
				4.81126070022583,
				24.18314552307129,
				20.012344360351562,
			},
			{
				5.564874649047852,
				22.97337532043457,
				20.012344360351562,
			},
			{
				5.850330352783203,
				22.057804107666016,
				20.094738006591797,
			},
			{
				6.004974365234375,
				16.644975662231445,
				20.990819931030273,
			},
			{
				6.427175045013428,
				1.8671751022338867,
				17.2677059173584,
			},
			{
				6.654541969299316,
				-6.091078281402588,
				16.928714752197266,
			},
			{
				6.234066486358643,
				-8.588376998901367,
				17.490930557250977,
			},
			{
				5.406145095825195,
				-10.977283477783203,
				18.415847778320312,
			},
			{
				4.433549404144287,
				-12.0475435256958,
				19.108797073364258,
			},
			{
				1.366440773010254,
				-14.169322967529297,
				20.09992218017578,
			},
			{
				-8.779674530029297,
				-21.188255310058594,
				20.015031814575195,
			},
		},
	},
}
local crossroads = {}
local main_path_version = "1.00"

return {
	version = main_path_version,
	path_markers = path_markers,
	main_path_segments = main_path_segments,
	crossroads = crossroads,
}
