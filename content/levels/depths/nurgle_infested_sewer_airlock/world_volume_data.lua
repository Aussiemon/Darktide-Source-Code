-- chunkname: @content/levels/depths/nurgle_infested_sewer_airlock/world_volume_data.lua

local volume_data = {
	{
		height = 5,
		name = "volume_no_spawn",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-215.75,
			-97.75,
			19,
		},
		alt_min_vector = {
			-215.75,
			-97.75,
			14,
		},
		bottom_points = {
			{
				-220.25,
				-102.25,
				14,
			},
			{
				-211.75,
				-102.25,
				14,
			},
			{
				-211.75,
				-94,
				14,
			},
			{
				-220.25,
				-94,
				14,
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
