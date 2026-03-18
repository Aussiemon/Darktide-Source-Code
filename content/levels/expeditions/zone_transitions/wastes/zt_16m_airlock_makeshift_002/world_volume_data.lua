-- chunkname: @content/levels/expeditions/zone_transitions/wastes/zt_16m_airlock_makeshift_002/world_volume_data.lua

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
		name = "volume_003",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-7,
			0.9999989867210388,
			8,
		},
		alt_min_vector = {
			-7,
			0.9999989867210388,
			0,
		},
		bottom_points = {
			{
				-5.999999046325684,
				-1.0000004768371582,
				0,
			},
			{
				-6.000000953674316,
				2.999999523162842,
				0,
			},
			{
				-8.000000953674316,
				2.9999983310699463,
				0,
			},
			{
				-7.999999046325684,
				-1.0000014305114746,
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
			1,
		},
	},
	{
		height = 9,
		name = "volume_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			5.5,
			5.000003814697266,
			8,
		},
		alt_min_vector = {
			5.5,
			5.000003814697266,
			-1,
		},
		bottom_points = {
			{
				4.500000476837158,
				6.000004291534424,
				-1,
			},
			{
				4.499999523162842,
				4.000004291534424,
				-1,
			},
			{
				6.499997138977051,
				0.5000033378601074,
				-1,
			},
			{
				6.500000476837158,
				6.000003337860107,
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
			[1] = 0,
			[3] = 1,
			[2] = -0,
		},
	},
	{
		height = 9,
		name = "volume_002",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-5,
			4,
			8,
		},
		alt_min_vector = {
			-5,
			4,
			-1,
		},
		bottom_points = {
			{
				-3.999999523162842,
				3.000000476837158,
				-1,
			},
			{
				-4.000001430511475,
				6.500000476837158,
				-1,
			},
			{
				-6.000001430511475,
				6.499999523162842,
				-1,
			},
			{
				-5.999999046325684,
				2.499999523162842,
				-1,
			},
			{
				-4.499999046325684,
				2.500000238418579,
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
