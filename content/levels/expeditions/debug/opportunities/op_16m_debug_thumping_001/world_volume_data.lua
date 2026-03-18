-- chunkname: @content/levels/expeditions/debug/opportunities/op_16m_debug_thumping_001/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "volume_player_blocker_thumper_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			0,
			0,
			11.648940086364746,
		},
		alt_min_vector = {
			0,
			0,
			0,
		},
		bottom_points = {
			{
				-1.3090269565582275,
				-1.3090269565582275,
				0,
			},
			{
				1.3090269565582275,
				-1.3090269565582275,
				0,
			},
			{
				1.3090269565582275,
				1.3090269565582275,
				0,
			},
			{
				-1.3090269565582275,
				1.3090269565582275,
				0,
			},
		},
		color = {
			255,
			255,
			125,
			0,
		},
		up_vector = {
			0,
			0,
			5.824470043182373,
		},
	},
	{
		height = 2,
		name = "volume_no_spawn_thumper_16m",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			5.5,
			0,
			2,
		},
		alt_min_vector = {
			5.5,
			0,
			0,
		},
		bottom_points = {
			{
				3.690325975418091,
				2.3109030723571777,
				0,
			},
			{
				3.690325975418091,
				-2.3109030723571777,
				0,
			},
			{
				7.309674263000488,
				-2.3109030723571777,
				0,
			},
			{
				7.309674263000488,
				2.3109030723571777,
				0,
			},
		},
		color = {
			255,
			120,
			120,
			255,
		},
		up_vector = {
			[1] = 0,
			[3] = 1,
			[2] = -0,
		},
	},
}

return {
	volume_data = volume_data,
}
