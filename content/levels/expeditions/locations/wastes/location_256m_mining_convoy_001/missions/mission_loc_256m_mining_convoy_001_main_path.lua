-- chunkname: @content/levels/expeditions/locations/wastes/location_256m_mining_convoy_001/missions/mission_loc_256m_mining_convoy_001_main_path.lua

local path_markers = {
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker",
		order = 0,
		position = {
			56.501922607421875,
			107.13369750976562,
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
			-15.855377197265625,
			-102.6602554321289,
			0,
		},
	},
}
local main_path_segments = {
	{
		path_length = 225.97738647460938,
		nodes = {
			{
				56.501922607421875,
				107.13369750976562,
				0,
			},
			{
				40.934288024902344,
				16.855188369750977,
				0.29984375834465027,
			},
			{
				11.616999626159668,
				-19.029794692993164,
				0.29984375834465027,
			},
			{
				-15.855377197265625,
				-102.6602554321289,
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
