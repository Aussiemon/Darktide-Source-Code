-- chunkname: @content/levels/expeditions/safe_zones/wastes/sz_stronghold_ruin_002/missions/mission_sz_stronghold_ruin_002_main_path.lua

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
			39,
			0.5,
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
			-45,
			0.25,
		},
	},
}
local main_path_segments = {
	{
		path_length = 89.94554138183594,
		nodes = {
			{
				0,
				39,
				0.22785155475139618,
			},
			{
				-0.5317366719245911,
				25.30826187133789,
				-0.35002994537353516,
			},
			{
				-1.1572188138961792,
				9.20266056060791,
				0.05961088463664055,
			},
			{
				-5.332457065582275,
				-1.2921733856201172,
				0.5108575820922852,
			},
			{
				-10.351614952087402,
				-6.703711032867432,
				1.1486303806304932,
			},
			{
				-10.821240425109863,
				-8.098810195922852,
				0.7760853171348572,
			},
			{
				-11.503957748413086,
				-23.270597457885742,
				0.5854130387306213,
			},
			{
				-11.089895248413086,
				-24.332740783691406,
				0.5631853342056274,
			},
			{
				-6.795166015625,
				-30.349763870239258,
				0.6871394515037537,
			},
			{
				0,
				-45,
				0.24046874046325684,
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
