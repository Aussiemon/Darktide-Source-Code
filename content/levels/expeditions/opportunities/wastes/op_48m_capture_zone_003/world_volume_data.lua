-- chunkname: @content/levels/expeditions/opportunities/wastes/op_48m_capture_zone_003/world_volume_data.lua

local volume_data = {
	{
		height = 4,
		name = "volume",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-5.5,
			11,
			6,
		},
		alt_min_vector = {
			-5.5,
			11,
			2,
		},
		bottom_points = {
			{
				-7.5,
				13,
				2,
			},
			{
				-7.5,
				9,
				2,
			},
			{
				-3.5,
				9,
				2,
			},
			{
				-3.5,
				13,
				2,
			},
		},
		color = {
			255,
			120,
			120,
			255,
		},
		up_vector = {
			0,
			0,
			1,
		},
	},
	{
		height = 4,
		name = "volume_block_player_002",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-9.847902297973633,
			-9.473222732543945,
			7.579363822937012,
		},
		alt_min_vector = {
			-9.847902297973633,
			-9.473222732543945,
			1.5793639421463013,
		},
		bottom_points = {
			{
				-13.72323226928711,
				-8.363351821899414,
				1.5793639421463013,
			},
			{
				-8.836623191833496,
				-13.375441551208496,
				1.5793639421463013,
			},
			{
				-5.972571849822998,
				-10.583093643188477,
				1.5793639421463013,
			},
			{
				-10.85918140411377,
				-5.5710039138793945,
				1.5793639421463013,
			},
		},
		color = {
			255,
			255,
			125,
			0,
		},
		up_vector = {
			[1] = 0,
			[3] = 1.5,
			[2] = -0,
		},
	},
	{
		height = 4,
		name = "volume_block_player_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			9.49688720703125,
			-7.521275997161865,
			9.828208923339844,
		},
		alt_min_vector = {
			9.49688720703125,
			-7.521275997161865,
			1.8282090425491333,
		},
		bottom_points = {
			{
				4.969505786895752,
				-10.985784530639648,
				1.8282090425491333,
			},
			{
				11.740363121032715,
				-12.762155532836914,
				1.8282090425491333,
			},
			{
				14.024269104003906,
				-4.056767463684082,
				1.8282090425491333,
			},
			{
				7.253411293029785,
				-2.2803964614868164,
				1.8282090425491333,
			},
		},
		color = {
			255,
			255,
			125,
			0,
		},
		up_vector = {
			[1] = 0,
			[3] = 2,
			[2] = -0,
		},
	},
}

return {
	volume_data = volume_data,
}
