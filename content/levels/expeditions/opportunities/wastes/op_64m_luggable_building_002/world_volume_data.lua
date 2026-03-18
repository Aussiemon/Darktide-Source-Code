-- chunkname: @content/levels/expeditions/opportunities/wastes/op_64m_luggable_building_002/world_volume_data.lua

local volume_data = {
	{
		height = 4,
		name = "volume_block_player_002",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-8.5,
			10.5,
			12.39799976348877,
		},
		alt_min_vector = {
			-8.5,
			10.5,
			4.3979997634887695,
		},
		bottom_points = {
			{
				-9.5,
				9.5,
				4.3979997634887695,
			},
			{
				-7.5,
				9.5,
				4.3979997634887695,
			},
			{
				-7.5,
				11.5,
				4.3979997634887695,
			},
			{
				-9.5,
				11.5,
				4.3979997634887695,
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
			2,
		},
	},
	{
		height = 2,
		name = "no_spawn",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-11,
			7,
			4,
		},
		alt_min_vector = {
			-11,
			7,
			0,
		},
		bottom_points = {
			{
				-14,
				9,
				0,
			},
			{
				-14,
				4.5,
				0,
			},
			{
				-12,
				4.5,
				0,
			},
			{
				-13,
				-5,
				0,
			},
			{
				-8,
				-5,
				0,
			},
			{
				-8,
				9,
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
			0,
			0,
			2,
		},
	},
	{
		height = 4,
		name = "volume_block_player_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-1.9884179830551147,
			13.304176330566406,
			8.761774063110352,
		},
		alt_min_vector = {
			-1.9884179830551147,
			13.304176330566406,
			0.7617740035057068,
		},
		bottom_points = {
			{
				-5.488418102264404,
				11.467463493347168,
				0.7617740035057068,
			},
			{
				1.5115820169448853,
				11.467463493347168,
				0.7617740035057068,
			},
			{
				1.5115820169448853,
				15.140889167785645,
				0.7617740035057068,
			},
			{
				-5.488418102264404,
				15.140889167785645,
				0.7617740035057068,
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
			2,
		},
	},
}

return {
	volume_data = volume_data,
}
