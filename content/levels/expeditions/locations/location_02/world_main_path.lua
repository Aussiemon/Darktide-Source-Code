-- chunkname: @content/levels/expeditions/locations/location_02/world_main_path.lua

local path_markers = {
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker",
		order = 0,
		position = {
			7.454856872558594,
			81,
			-0.14112000167369843,
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
			-49,
			77.99999237060547,
			4,
		},
	},
}
local main_path_segments = {
	{
		path_length = 60.33974075317383,
		nodes = {
			{
				7.454856872558594,
				81,
				-0.14101561903953552,
			},
			{
				2.2799999713897705,
				75.23999786376953,
				-0.14101561903953552,
			},
			{
				0.733688235282898,
				73.73333740234375,
				-0.14101561903953552,
			},
			{
				-4.984941482543945,
				73.51753997802734,
				-0.14101561903953552,
			},
			{
				-22.056047439575195,
				75.25604248046875,
				3.91152286529541,
			},
			{
				-49,
				77.99999237060547,
				3.999648332595825,
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
