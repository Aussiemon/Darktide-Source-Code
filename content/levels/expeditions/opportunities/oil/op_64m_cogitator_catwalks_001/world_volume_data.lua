-- chunkname: @content/levels/expeditions/opportunities/oil/op_64m_cogitator_catwalks_001/world_volume_data.lua

local volume_data = {
	{
		height = 4.13477993011475,
		name = "volume_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-0.5323219895362854,
			10.5,
			8.134779930114746,
		},
		alt_min_vector = {
			-0.5323219895362854,
			10.5,
			4,
		},
		bottom_points = {
			{
				0.7176780104637146,
				13,
				4,
			},
			{
				-1.7823219299316406,
				13,
				4,
			},
			{
				-1.7823219299316406,
				5.360827922821045,
				4,
			},
			{
				0.7176780104637146,
				5.360827922821045,
				4,
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
		height = 4.5,
		name = "volume",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-6.5,
			9,
			8,
		},
		alt_min_vector = {
			-6.5,
			9,
			3.5,
		},
		bottom_points = {
			{
				-2.5,
				5.5,
				3.5,
			},
			{
				-2.5,
				12.732780456542969,
				3.5,
			},
			{
				-10.5,
				12.732780456542969,
				3.5,
			},
			{
				-10.5,
				5.5,
				3.5,
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
}

return {
	volume_data = volume_data,
}
