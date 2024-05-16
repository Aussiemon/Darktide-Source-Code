-- chunkname: @content/levels/testify/spawn_all_enemies/world_main_path.lua

local path_markers = {
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker_001",
		order = 1,
		position = {
			0,
			5,
			0,
		},
	},
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker_002",
		order = 2,
		position = {
			5,
			0,
			0,
		},
	},
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker_003",
		order = 3,
		position = {
			0,
			-5,
			0,
		},
	},
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker_004",
		order = 4,
		position = {
			-5,
			0,
			0,
		},
	},
}
local main_path_segments = {
	{
		path_length = 21.21320343017578,
		nodes = {
			{
				0,
				5,
				0,
			},
			{
				5,
				0,
				0,
			},
			{
				0,
				-5,
				0,
			},
			{
				-5,
				0,
				0,
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
