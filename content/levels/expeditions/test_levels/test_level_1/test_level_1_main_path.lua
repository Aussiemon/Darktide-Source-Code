-- chunkname: @content/levels/expeditions/test_levels/test_level_1/test_level_1_main_path.lua

local path_markers = {
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker",
		order = 0,
		position = {
			-12.659303665161133,
			26.653987884521484,
			0.12400099635124207,
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
			13.597223281860352,
			0.4278300106525421,
			0.12400099635124207,
		},
	},
}
local main_path_segments = {
	{
		path_length = 37.11086654663086,
		nodes = {
			{
				-12.659303665161133,
				26.653987884521484,
				0.12394531071186066,
			},
			{
				13.597223281860352,
				0.4278300106525421,
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
