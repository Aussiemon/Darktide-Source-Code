-- chunkname: @content/levels/live_events/plasma_smugglers_props_1_volume_data.lua

local volume_data = {
	{
		height = 3,
		name = "volume",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			0,
			0,
			3,
		},
		alt_min_vector = {
			0,
			0,
			0,
		},
		bottom_points = {
			{
				-0.25,
				-1.125,
				0,
			},
			{
				0.5,
				-0.5,
				0,
			},
			{
				0.875,
				-0.625,
				0,
			},
			{
				1.125,
				0.125,
				0,
			},
			{
				0.375,
				0.375,
				0,
			},
			{
				0.5,
				1.125,
				0,
			},
			{
				-0.375,
				1.375,
				0,
			},
			{
				-0.625,
				0.5,
				0,
			},
			{
				-1.125,
				-0.25,
				0,
			},
		},
		color = {
			255,
			255,
			125,
			0,
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
