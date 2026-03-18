-- chunkname: @content/levels/expeditions/zone_transitions/wastes/zt_16m_airlock_makeshift_001/world_volume_data.lua

local volume_data = {
	{
		height = 7,
		name = "volume_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-4.5,
			-1.5,
			6,
		},
		alt_min_vector = {
			-4.5,
			-1.5,
			-1,
		},
		bottom_points = {
			{
				-3.99999737739563,
				-5.999999523162842,
				-1,
			},
			{
				-3.5,
				-1.4999994039535522,
				-1,
			},
			{
				-3.500002145767212,
				2.000000476837158,
				-1,
			},
			{
				-4.000002384185791,
				2.500000476837158,
				-1,
			},
			{
				-5.500002384185791,
				2.499999523162842,
				-1,
			},
			{
				-5.499997138977051,
				-6.000000476837158,
				-1,
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
			1,
		},
	},
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
