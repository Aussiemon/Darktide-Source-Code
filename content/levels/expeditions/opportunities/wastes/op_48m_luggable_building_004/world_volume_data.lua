-- chunkname: @content/levels/expeditions/opportunities/wastes/op_48m_luggable_building_004/world_volume_data.lua

local volume_data = {
	{
		height = 4,
		name = "volume_001",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-8.26212215423584,
			3.6962039470672607,
			12,
		},
		alt_min_vector = {
			-8.26212215423584,
			3.6962039470672607,
			0,
		},
		bottom_points = {
			{
				-14.26212215423584,
				9.69620418548584,
				0,
			},
			{
				-14.26212215423584,
				-2.3037960529327393,
				0,
			},
			{
				-2.26212215423584,
				-2.3037960529327393,
				0,
			},
			{
				-2.26212215423584,
				9.69620418548584,
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
			3,
		},
	},
	{
		height = 4,
		name = "volume",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			10,
			-10,
			7,
		},
		alt_min_vector = {
			10,
			-10,
			-1,
		},
		bottom_points = {
			{
				6,
				-6,
				-1,
			},
			{
				6,
				-14,
				-1,
			},
			{
				14,
				-14,
				-1,
			},
			{
				14,
				-6,
				-1,
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
}

return {
	volume_data = volume_data,
}
