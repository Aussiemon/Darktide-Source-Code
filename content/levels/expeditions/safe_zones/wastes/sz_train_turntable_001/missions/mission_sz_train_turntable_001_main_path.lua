-- chunkname: @content/levels/expeditions/safe_zones/wastes/sz_train_turntable_001/missions/mission_sz_train_turntable_001_main_path.lua

local path_markers = {
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker",
		order = 0,
		position = {
			0,
			-14,
			0,
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
			0,
			14,
			0,
		},
	},
}
local main_path_segments = {
	{
		path_length = 28,
		nodes = {
			{
				0,
				-14,
				0,
			},
			{
				0,
				14,
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
