-- chunkname: @content/levels/expeditions/opportunities/wastes/op_32m_jumping_puzzle_003/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "volume",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-4.75,
			-1.5,
			10.968031883239746,
		},
		alt_min_vector = {
			-4.75,
			-1.5,
			5.5,
		},
		bottom_points = {
			{
				-4.5020270347595215,
				-3.3674509525299072,
				5.5,
			},
			{
				-4.5020270347595215,
				0.3674509525299072,
				5.5,
			},
			{
				-4.9979729652404785,
				0.3674509525299072,
				5.5,
			},
			{
				-4.9979729652404785,
				-3.3674509525299072,
				5.5,
			},
		},
		color = {
			255,
			255,
			125,
			0,
		},
		up_vector = {
			-0,
			[2] = 0,
			[3] = 2.734015941619873,
		},
	},
}

return {
	volume_data = volume_data,
}
