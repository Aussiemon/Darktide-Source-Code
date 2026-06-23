-- chunkname: @content/levels/live_events/leftover/live_event_leftover_loot_point_volume_data.lua

local volume_data = {
	{
		height = 3,
		name = "volume_001",
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
				-1.125,
				-0.375,
				0,
			},
			{
				1.125,
				-0.375,
				0,
			},
			{
				1.125,
				0.375,
				0,
			},
			{
				-1.125,
				0.375,
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
