-- chunkname: @content/levels/expeditions/opportunities/oil/op_64m_pit_001/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "no_spawn",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-13.118305206298828,
			0.14324699342250824,
			9.5,
		},
		alt_min_vector = {
			-13.118305206298828,
			0.14324699342250824,
			5.5,
		},
		bottom_points = {
			{
				-15.118305206298828,
				2.14324688911438,
				5.5,
			},
			{
				-15.118305206298828,
				-1.8567529916763306,
				5.5,
			},
			{
				-11.118305206298828,
				-1.8567529916763306,
				5.5,
			},
			{
				-11.118305206298828,
				2.14324688911438,
				5.5,
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
		height = 2,
		name = "dz_volume_01",
		type = "content/volume_types/nav_tag_volumes/minion_instakill_high_cost",
		alt_max_vector = {
			0.5,
			1,
			2,
		},
		alt_min_vector = {
			0.5,
			1,
			-2,
		},
		bottom_points = {
			{
				-7.5,
				-7,
				-2,
			},
			{
				8.5,
				-7,
				-2,
			},
			{
				8.5,
				9,
				-2,
			},
			{
				-7.5,
				9,
				-2,
			},
		},
		color = {
			255,
			255,
			0,
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
