-- chunkname: @content/levels/expeditions/opportunities/wastes/op_32m_hack_chest_002_var_cap/world_volume_data.lua

local volume_data = {
	{
		height = 4,
		name = "volume_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			0,
			-7,
			4.5,
		},
		alt_min_vector = {
			0,
			-7,
			0.5,
		},
		bottom_points = {
			{
				-2,
				-4,
				0.5,
			},
			{
				-2,
				-8,
				0.5,
			},
			{
				2,
				-8,
				0.5,
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
		height = 4,
		name = "volume",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-0.25,
			6.5,
			2.950000047683716,
		},
		alt_min_vector = {
			-0.25,
			6.5,
			-1.0499999523162842,
		},
		bottom_points = {
			{
				-2,
				4.5,
				-1.0499999523162842,
			},
			{
				2,
				4.5,
				-1.0499999523162842,
			},
			{
				2,
				7.5,
				-1.0499999523162842,
			},
			{
				-2,
				7.5,
				-1.0499999523162842,
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
		height = 3,
		name = "volume_002",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			3.75,
			6.5,
			1.9500000476837158,
		},
		alt_min_vector = {
			3.75,
			6.5,
			-1.0499999523162842,
		},
		bottom_points = {
			{
				2,
				3.5,
				-1.0499999523162842,
			},
			{
				5.75,
				3.5,
				-1.0499999523162842,
			},
			{
				5.75,
				7.5,
				-1.0499999523162842,
			},
			{
				2,
				7.5,
				-1.0499999523162842,
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
}

return {
	volume_data = volume_data,
}
