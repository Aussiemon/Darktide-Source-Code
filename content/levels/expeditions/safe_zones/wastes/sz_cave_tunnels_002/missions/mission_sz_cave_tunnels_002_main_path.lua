-- chunkname: @content/levels/expeditions/safe_zones/wastes/sz_cave_tunnels_002/missions/mission_sz_cave_tunnels_002_main_path.lua

local path_markers = {
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker",
		order = 0,
		position = {
			0.9367899894714355,
			-40.036407470703125,
			12,
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
			20,
			46,
			10.999998092651367,
		},
	},
}
local main_path_segments = {
	{
		path_length = 90.66062927246094,
		nodes = {
			{
				0.9367899894714355,
				-40.036407470703125,
				12.120787620544434,
			},
			{
				1.9950000047683716,
				-35.814998626708984,
				12.262422561645508,
			},
			{
				6.079999923706055,
				-22.03999900817871,
				11.206047058105469,
			},
			{
				6.695579528808594,
				-18.744083404541016,
				11.000914573669434,
			},
			{
				6.821156024932861,
				-5.301156520843506,
				11.271414756774902,
			},
			{
				6.927271842956543,
				6.058481693267822,
				14.187139511108398,
			},
			{
				8.237968444824219,
				9.119999885559082,
				15.438629150390625,
			},
			{
				9.721393585205078,
				12.584977149963379,
				14.450075149536133,
			},
			{
				13.47708797454834,
				17.89720916748047,
				12.794081687927246,
			},
			{
				15.914149284362793,
				27.360000610351562,
				10.288578033447266,
			},
			{
				17.29045295715332,
				32.704010009765625,
				10.261362075805664,
			},
			{
				20,
				46,
				11.049537658691406,
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
