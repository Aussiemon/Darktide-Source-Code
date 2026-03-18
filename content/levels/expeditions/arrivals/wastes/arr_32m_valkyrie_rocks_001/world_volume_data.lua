-- chunkname: @content/levels/expeditions/arrivals/wastes/arr_32m_valkyrie_rocks_001/world_volume_data.lua

local volume_data = {
	{
		height = 40,
		name = "volume_no_spawn",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			0,
			0,
			20,
		},
		alt_min_vector = {
			0,
			0,
			-20,
		},
		bottom_points = {
			{
				-48,
				0,
				-20,
			},
			{
				-36,
				-36,
				-20,
			},
			{
				0,
				-48,
				-20,
			},
			{
				36,
				-36,
				-20,
			},
			{
				48,
				0,
				-20,
			},
			{
				36,
				36,
				-20,
			},
			{
				0,
				48,
				-20,
			},
			{
				-33,
				36,
				-20,
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
