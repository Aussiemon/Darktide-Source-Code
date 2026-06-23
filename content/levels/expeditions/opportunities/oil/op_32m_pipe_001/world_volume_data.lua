-- chunkname: @content/levels/expeditions/opportunities/oil/op_32m_pipe_001/world_volume_data.lua

local volume_data = {
	{
		height = 2.5,
		name = "volume_001",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-6.25,
			3.25,
			4.349234104156494,
		},
		alt_min_vector = {
			-6.25,
			3.25,
			1.8492339849472046,
		},
		bottom_points = {
			{
				-5,
				6.5,
				1.8492339849472046,
			},
			{
				-7.5,
				6.5,
				1.8492339849472046,
			},
			{
				-7.5,
				0,
				1.8492339849472046,
			},
			{
				-5,
				0,
				1.8492339849472046,
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
		height = 2,
		name = "volume",
		type = "content/volume_types/nav_tag_volumes/generic_001",
		alt_max_vector = {
			0,
			-6.25,
			3.5,
		},
		alt_min_vector = {
			0,
			-6.25,
			1.5,
		},
		bottom_points = {
			{
				-2.5,
				-7,
				1.5,
			},
			{
				2.5,
				-7,
				1.5,
			},
			{
				2.5,
				-5.5,
				1.5,
			},
			{
				-2.5,
				-5.5,
				1.5,
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
		height = 5,
		name = "volume_002",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-0.25,
			6.5,
			6.5,
		},
		alt_min_vector = {
			-0.25,
			6.5,
			1.5,
		},
		bottom_points = {
			{
				4.3944268226623535,
				4.5,
				1.5,
			},
			{
				4.444211959838867,
				6.148397922515869,
				1.5,
			},
			{
				5.8833088874816895,
				6.089637756347656,
				1.5,
			},
			{
				5.894659996032715,
				4.5,
				1.5,
			},
			{
				8.87472152709961,
				4.776084899902344,
				1.5,
			},
			{
				6.75,
				7.820252895355225,
				1.5,
			},
			{
				4,
				8.5,
				1.5,
			},
			{
				-4.5,
				8.5,
				1.5,
			},
			{
				-4.5,
				4.5,
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
