-- chunkname: @content/levels/expeditions/locations/wastes/location_256m_ravine_001/missions/mission_location_256m_ravine_001_main_path.lua

local path_markers = {
	{
		crossroads = "",
		kind = "good",
		main_path_segment_index = 1,
		marker_type = "normal",
		name = "path_marker",
		order = 0,
		position = {
			-0.4728429913520813,
			57.2995719909668,
			-0.460999995470047,
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
			7,
			-28,
			0.26100000739097595,
		},
	},
}
local main_path_segments = {
	{
		path_length = 104.54882049560547,
		nodes = {
			{
				-0.4728429913520813,
				57.2995719909668,
				-0.42327821254730225,
			},
			{
				-6.27490234375,
				47.89283752441406,
				0.10316406935453415,
			},
			{
				-5.6871185302734375,
				43.80463790893555,
				0.12846730649471283,
			},
			{
				-4.309804916381836,
				39.18064498901367,
				0.04171194136142731,
			},
			{
				7.685890197753906,
				23.421911239624023,
				0.2693195939064026,
			},
			{
				8.333107948303223,
				21.343393325805664,
				0.2756820321083069,
			},
			{
				10.821870803833008,
				9.119999885559082,
				0.06438624858856201,
			},
			{
				12.59304141998291,
				0.42101287841796875,
				1.4748764038085938,
			},
			{
				17.479999542236328,
				-12.15999984741211,
				3.0798301696777344,
			},
			{
				21.21076011657715,
				-22.386192321777344,
				0.6710204482078552,
			},
			{
				21.232500076293945,
				-23.67519760131836,
				0.35964831709861755,
			},
			{
				18.758445739746094,
				-25.265226364135742,
				0.38148435950279236,
			},
			{
				7,
				-28,
				0.3814713954925537,
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
