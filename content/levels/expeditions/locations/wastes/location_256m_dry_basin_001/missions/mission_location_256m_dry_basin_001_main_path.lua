-- chunkname: @content/levels/expeditions/locations/wastes/location_256m_dry_basin_001/missions/mission_location_256m_dry_basin_001_main_path.lua

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
			32,
			0.0010000000474974513,
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
			-32,
			0.0010000000474974513,
		},
	},
}
local main_path_segments = {
	{
		path_length = 64,
		nodes = {
			{
				0,
				32,
				0.0007421874906867743,
			},
			{
				0,
				-32,
				0.0007421874906867743,
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
