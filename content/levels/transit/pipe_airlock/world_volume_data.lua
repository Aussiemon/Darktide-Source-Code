-- chunkname: @content/levels/transit/pipe_airlock/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "volume_no_spawn",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			52.58163833618164,
			-196.39190673828125,
			6.453489780426025,
		},
		alt_min_vector = {
			52.581634521484375,
			-196.39190673828125,
			4.453489780426025,
		},
		bottom_points = {
			{
				52.58161163330078,
				-189.78834533691406,
				4.45347261428833,
			},
			{
				45.97807312011719,
				-196.3919219970703,
				4.453496932983398,
			},
			{
				52.58165740966797,
				-202.99546813964844,
				4.453506946563721,
			},
			{
				59.18519592285156,
				-196.3918914794922,
				4.453482627868652,
			},
		},
		color = {
			255,
			120,
			120,
			255,
		},
		up_vector = {
			1.082387598216883e-06,
			2.6131274353247136e-06,
			1,
		},
	},
}

return {
	volume_data = volume_data,
}
