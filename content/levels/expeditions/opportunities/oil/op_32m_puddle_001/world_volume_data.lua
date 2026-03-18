-- chunkname: @content/levels/expeditions/opportunities/oil/op_32m_puddle_001/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "no_spawn",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			0,
			0,
			4,
		},
		alt_min_vector = {
			0,
			0,
			0,
		},
		bottom_points = {
			{
				-2,
				2,
				0,
			},
			{
				-2,
				-2,
				0,
			},
			{
				2,
				-2,
				0,
			},
			{
				2,
				2,
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
}

return {
	volume_data = volume_data,
}
