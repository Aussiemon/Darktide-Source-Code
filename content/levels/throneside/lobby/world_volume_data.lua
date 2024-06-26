-- chunkname: @content/levels/throneside/lobby/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "volume_no_spawn",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-245.75,
			80,
			-20.51904296875,
		},
		alt_min_vector = {
			-245.75,
			80,
			-22.51904296875,
		},
		bottom_points = {
			{
				-250.75,
				73,
				-22.51904296875,
			},
			{
				-239.75,
				73,
				-22.51904296875,
			},
			{
				-239.75,
				83,
				-22.51904296875,
			},
			{
				-250.75,
				83,
				-22.51904296875,
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
		height = 37.25,
		name = "volume_no_spawn_lobby_elevator",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-284.375,
			64.375,
			9.75,
		},
		alt_min_vector = {
			-284.375,
			64.375,
			-27.5,
		},
		bottom_points = {
			{
				-275.375,
				66.875,
				-27.5,
			},
			{
				-281.75,
				73,
				-27.5,
			},
			{
				-293.5,
				61.5,
				-27.5,
			},
			{
				-286.375,
				54.875,
				-27.5,
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
