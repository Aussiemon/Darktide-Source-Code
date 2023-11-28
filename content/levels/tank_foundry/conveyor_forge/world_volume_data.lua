-- chunkname: @content/levels/tank_foundry/conveyor_forge/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		type = "content/volume_types/player_mover_blocker",
		name = "volume_005",
		alt_max_vector = {
			77.4910888671875,
			-205.8894500732422,
			-22.75
		},
		alt_min_vector = {
			77.4910888671875,
			-205.8894500732422,
			-24.75
		},
		bottom_points = {
			{
				76.9317855834961,
				-206.8894500732422,
				-24.75
			},
			{
				78.0503921508789,
				-206.8894500732422,
				-24.75
			},
			{
				78.0503921508789,
				-204.8894500732422,
				-24.75
			},
			{
				76.9317855834961,
				-204.8894500732422,
				-24.75
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
