-- chunkname: @content/levels/expeditions/opportunities/wastes/op_32m_capture_zone_001/world_volume_data.lua

local volume_data = {
	{
		height = 4,
		name = "no_spawn",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			0,
			0,
			5,
		},
		alt_min_vector = {
			0,
			0,
			-3,
		},
		bottom_points = {
			{
				-6,
				4,
				-3,
			},
			{
				-6,
				-4,
				-3,
			},
			{
				6,
				-4,
				-3,
			},
			{
				6,
				4,
				-3,
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
