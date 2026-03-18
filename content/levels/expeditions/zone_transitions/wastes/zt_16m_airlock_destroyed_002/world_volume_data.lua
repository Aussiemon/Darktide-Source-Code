-- chunkname: @content/levels/expeditions/zone_transitions/wastes/zt_16m_airlock_destroyed_002/world_volume_data.lua

local volume_data = {
	{
		height = 9,
		name = "volume_002",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			5,
			1,
			8,
		},
		alt_min_vector = {
			5,
			1,
			-1,
		},
		bottom_points = {
			{
				1.0000028610229492,
				6.000002384185791,
				-1,
			},
			{
				4.000000476837158,
				2.000000476837158,
				-1,
			},
			{
				3.999995708465576,
				-5.999999523162842,
				-1,
			},
			{
				5.999995708465576,
				-6.000000476837158,
				-1,
			},
			{
				6.000002861022949,
				5.999999523162842,
				-1,
			},
		},
		color = {
			255,
			255,
			125,
			0,
		},
		up_vector = {
			[1] = 0,
			[3] = 1,
			[2] = -0,
		},
	},
	{
		height = 9,
		name = "volume_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-4.999999046325684,
			-2.9999899864196777,
			8,
		},
		alt_min_vector = {
			-4.999999046325684,
			-2.9999899864196777,
			-1,
		},
		bottom_points = {
			{
				-3.999997138977051,
				-5.9999895095825195,
				-1,
			},
			{
				-4.000000953674316,
				1.049041748046875e-05,
				-1,
			},
			{
				-6.000002861022949,
				3.000009536743164,
				-1,
			},
			{
				-5.999997138977051,
				-5.999990463256836,
				-1,
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
