-- chunkname: @content/levels/expeditions/opportunities/wastes/op_48m_fort_generator_001_var_scan/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "volume_no_spawn_001",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-1.25,
			1.25,
			3,
		},
		alt_min_vector = {
			-1.25,
			1.25,
			1,
		},
		bottom_points = {
			{
				-5.184521675109863,
				-2.6845219135284424,
				1,
			},
			{
				2.6845219135284424,
				-2.6845219135284424,
				1,
			},
			{
				2.6845219135284424,
				5.184521675109863,
				1,
			},
			{
				-5.184521675109863,
				5.184521675109863,
				1,
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
		height = 4,
		name = "volume",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			1.6851890087127686,
			0.060777001082897186,
			10.100000381469727,
		},
		alt_min_vector = {
			1.6851890087127686,
			0.060777001082897186,
			6.099999904632568,
		},
		bottom_points = {
			{
				2.7008399963378906,
				2.914083957672119,
				6.099999904632568,
			},
			{
				0.6695380210876465,
				2.914083957672119,
				6.099999904632568,
			},
			{
				0.6695380210876465,
				-2.792530059814453,
				6.099999904632568,
			},
			{
				2.7008399963378906,
				-2.792530059814453,
				6.099999904632568,
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
