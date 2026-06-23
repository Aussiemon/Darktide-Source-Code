-- chunkname: @content/levels/expeditions/opportunities/oil/op_32m_cogitator_puzzle_001/world_volume_data.lua

local volume_data = {
	{
		height = 3.5,
		name = "volume",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-2.5,
			-2,
			4.5,
		},
		alt_min_vector = {
			-2.5,
			-2,
			1,
		},
		bottom_points = {
			{
				5.5,
				-4,
				1,
			},
			{
				5.5,
				4,
				1,
			},
			{
				-2.5,
				4,
				1,
			},
			{
				-2.5,
				0,
				1,
			},
			{
				-6.5,
				0,
				1,
			},
			{
				-6.5,
				-4,
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
}

return {
	volume_data = volume_data,
}
