-- chunkname: @content/levels/expeditions/test_levels/test_level_2/test_level_2_main_path.lua

local path_markers = {
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker",
		order = 0,
		position = {
			-10,
			2.5290000438690186,
			0.10000000149011612,
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
			10.94715690612793,
			24.989179611206055,
			0.12400099635124207,
		},
	},
}
local main_path_segments = {
	{
		path_length = 30.82265281677246,
		nodes = {
			{
				-10,
				2.5290000438690186,
				0.12394531071186066,
			},
			{
				-8.649253845214844,
				3.169565439224243,
				0.12394531816244125,
			},
			{
				10.94715690612793,
				24.989179611206055,
				0.12394531071186066,
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
