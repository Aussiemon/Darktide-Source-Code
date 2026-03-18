-- chunkname: @content/levels/expeditions/zone_transitions/wastes/zt_16m_airlock_makeshift_003/world_volume_data.lua

local volume_data = {
	{
		height = 11.0000009536743,
		name = "volume",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			0,
			0,
			10.000000953674316,
		},
		alt_min_vector = {
			0,
			0,
			-1,
		},
		bottom_points = {
			{
				-8,
				-8,
				-1,
			},
			{
				8,
				-8,
				-1,
			},
			{
				8,
				8,
				-1,
			},
			{
				-8,
				8,
				-1,
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
		height = 8,
		name = "volume_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			6.75,
			2.9999990463256836,
			8,
		},
		alt_min_vector = {
			6.75,
			2.9999990463256836,
			0,
		},
		bottom_points = {
			{
				5.75,
				4.999999046325684,
				0,
			},
			{
				5.75,
				0.9999990463256836,
				0,
			},
			{
				7.75,
				0.9999990463256836,
				0,
			},
			{
				7.75,
				4.999999046325684,
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
			[1] = 0,
			[3] = 1,
			[2] = -0,
		},
	},
	{
		height = 8.25,
		name = "transition_area",
		type = "default",
		alt_max_vector = {
			0,
			0,
			8,
		},
		alt_min_vector = {
			0,
			0,
			-0.25,
		},
		bottom_points = {
			{
				5.5,
				-7.5,
				-0.25,
			},
			{
				5.5,
				-7.5,
				-0.25,
			},
			{
				5.5,
				7.25,
				-0.25,
			},
			{
				-5.75,
				7.25,
				-0.25,
			},
			{
				-5.75,
				-7.5,
				-0.25,
			},
		},
		color = {
			255,
			0,
			64,
			153,
		},
		up_vector = {
			0,
			0,
			1,
		},
	},
}

return {
	volume_data = volume_data,
}
