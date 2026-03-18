-- chunkname: @content/levels/expeditions/opportunities/wastes/op_16m_destructible_test_001/world_volume_data.lua

local volume_data = {
	{
		height = 3,
		name = "volume_block_nav_16m_dest_test",
		type = "content/volume_types/nav_tag_volumes/generic_010",
		alt_max_vector = {
			0.25,
			0,
			3.4403738975524902,
		},
		alt_min_vector = {
			0.25,
			0,
			0.4403739869594574,
		},
		bottom_points = {
			{
				4.313148021697998,
				3.0694780349731445,
				0.4403739869594574,
			},
			{
				-3.813148021697998,
				3.0694780349731445,
				0.4403739869594574,
			},
			{
				-3.813148021697998,
				-3.0694780349731445,
				0.4403739869594574,
			},
			{
				4.313148021697998,
				-3.0694780349731445,
				0.4403739869594574,
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
	{
		height = 4,
		name = "volume_block_players_16m_dest_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			3.3000121116638184,
			-1.2000069618225098,
			4.500000953674316,
		},
		alt_min_vector = {
			3.3000121116638184,
			-1.2000069618225098,
			0.5000010132789612,
		},
		bottom_points = {
			{
				4.065654754638672,
				-2.2000086307525635,
				0.5000010132789612,
			},
			{
				4.065659523010254,
				-0.20000863075256348,
				0.5000010132789612,
			},
			{
				2.5343692302703857,
				-0.20000529289245605,
				0.5000010132789612,
			},
			{
				2.534364938735962,
				-2.200005292892456,
				0.5000010132789612,
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
