-- chunkname: @content/levels/expeditions/safe_zones/wastes/sz_stronghold_ruin_003/missions/mission_sz_stronghold_ruin_003_main_path.lua

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
			20,
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
			-20,
			0,
		},
	},
}
local main_path_segments = {
	{
		path_length = 40.27579879760742,
		nodes = {
			{
				0,
				20,
				0.08781520277261734,
			},
			{
				0.6710405349731445,
				10.472238540649414,
				1.0123437643051147,
			},
			{
				1.4754157066345215,
				-0.9486731886863708,
				0.2752133011817932,
			},
			{
				1.4703876972198486,
				-2.985450267791748,
				0.2501171827316284,
			},
			{
				0.7445428967475891,
				-11.384542465209961,
				1.0123437643051147,
			},
			{
				0,
				-20,
				0.012617187574505806,
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
