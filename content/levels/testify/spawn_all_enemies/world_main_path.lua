-- chunkname: @content/levels/testify/spawn_all_enemies/world_main_path.lua

local path_markers = {
	{
		crossroads = "",
		name = "path_marker_001",
		main_path_segment_index = 1,
		kind = "good",
		marker_type = "normal",
		order = 1,
		position = {
			0,
			5,
			0
		}
	},
	{
		crossroads = "",
		name = "path_marker_002",
		main_path_segment_index = 1,
		kind = "good",
		marker_type = "normal",
		order = 2,
		position = {
			5,
			0,
			0
		}
	},
	{
		crossroads = "",
		name = "path_marker_003",
		main_path_segment_index = 1,
		kind = "good",
		marker_type = "normal",
		order = 3,
		position = {
			0,
			-5,
			0
		}
	},
	{
		crossroads = "",
		name = "path_marker_004",
		main_path_segment_index = 1,
		kind = "good",
		marker_type = "normal",
		order = 4,
		position = {
			-5,
			0,
			0
		}
	}
}
local main_path_segments = {
	{
		path_length = 21.21320343017578,
		nodes = {
			{
				0,
				5,
				0
			},
			{
				5,
				0,
				0
			},
			{
				0,
				-5,
				0
			},
			{
				-5,
				0,
				0
			}
		}
	}
}
local crossroads = {}
local main_path_version = "1.00"

return {
	version = main_path_version,
	path_markers = path_markers,
	main_path_segments = main_path_segments,
	crossroads = crossroads
}
