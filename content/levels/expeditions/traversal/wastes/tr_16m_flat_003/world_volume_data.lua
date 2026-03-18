-- chunkname: @content/levels/expeditions/traversal/wastes/tr_16m_flat_003/world_volume_data.lua

local volume_data = {
	{
		height = 5,
		name = "volume",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			0.7082160115242004,
			-1.6990950107574463,
			5.875,
		},
		alt_min_vector = {
			0.7082160115242004,
			-1.6990950107574463,
			0.875,
		},
		bottom_points = {
			{
				-1.3298852443695068,
				1.5174472332000732,
				0.875,
			},
			{
				-3.0265910625457764,
				-0.9566563367843628,
				0.875,
			},
			{
				0.6845641732215881,
				-3.5017154216766357,
				0.875,
			},
			{
				2.239877939224243,
				-1.233787178993225,
				0.875,
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
}

return {
	volume_data = volume_data,
}
