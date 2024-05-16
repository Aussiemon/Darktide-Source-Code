-- chunkname: @content/levels/watertown_twins/enforcer_basement/world_volume_data.lua

local volume_data = {
	{
		height = 6,
		name = "no_spawn",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-225.250732421875,
			-23.68210220336914,
			-16,
		},
		alt_min_vector = {
			-225.250732421875,
			-23.68210220336914,
			-22,
		},
		bottom_points = {
			{
				-265.45281982421875,
				-47.384315490722656,
				-22,
			},
			{
				-202.23501586914062,
				-58.54292678833008,
				-22,
			},
			{
				-187.98516845703125,
				-3.352874755859375,
				-22,
			},
			{
				-247.0164337158203,
				16.01995086669922,
				-22,
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
