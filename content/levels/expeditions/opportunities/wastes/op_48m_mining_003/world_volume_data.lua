-- chunkname: @content/levels/expeditions/opportunities/wastes/op_48m_mining_003/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "move_blocker",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			0,
			-1,
			3.5,
		},
		alt_min_vector = {
			0,
			-1,
			1.5,
		},
		bottom_points = {
			{
				-4,
				-3,
				1.5,
			},
			{
				4,
				-3,
				1.5,
			},
			{
				4,
				1,
				1.5,
			},
			{
				-4,
				1,
				1.5,
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
