-- chunkname: @content/levels/transit/shaft_transition/world_volume_data.lua

local volume_data = {
	{
		height = 5,
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		name = "end_event_elevator_no_spawn_volume",
		alt_max_vector = {
			6,
			268.5,
			-13
		},
		alt_min_vector = {
			6,
			268.5,
			-18
		},
		bottom_points = {
			{
				2,
				264,
				-18
			},
			{
				10,
				264,
				-18
			},
			{
				10,
				273,
				-18
			},
			{
				2,
				273,
				-18
			}
		},
		color = {
			255,
			120,
			120,
			255
		},
		up_vector = {
			0,
			0,
			1
		}
	},
	{
		height = 4,
		type = "content/volume_types/player_mover_blocker",
		name = "volume",
		alt_max_vector = {
			44.71894454956055,
			239.98939514160156,
			-34.00000762939453
		},
		alt_min_vector = {
			44.71894454956055,
			239.98939514160156,
			-38.00000762939453
		},
		bottom_points = {
			{
				42.3529167175293,
				242.0874786376953,
				-38.00000762939453
			},
			{
				45.35292053222656,
				236.8913116455078,
				-38.00000762939453
			},
			{
				47.0849723815918,
				237.8913116455078,
				-38.00000762939453
			},
			{
				44.08496856689453,
				243.0874786376953,
				-38.00000762939453
			}
		},
		color = {
			255,
			255,
			125,
			0
		},
		up_vector = {
			0,
			0,
			1
		}
	}
}

return {
	volume_data = volume_data
}
