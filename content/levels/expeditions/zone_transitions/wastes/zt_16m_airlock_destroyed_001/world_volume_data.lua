-- chunkname: @content/levels/expeditions/zone_transitions/wastes/zt_16m_airlock_destroyed_001/world_volume_data.lua

local volume_data = {
	{
		height = 13,
		name = "volume",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			0,
			0,
			12,
		},
		alt_min_vector = {
			0,
			0,
			-1,
		},
		bottom_points = {
			{
				-6,
				-7,
				-1,
			},
			{
				6,
				-7,
				-1,
			},
			{
				6,
				8,
				-1,
			},
			{
				-6,
				8,
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
	{
		height = 11,
		name = "volume_001",
		type = "core/gwnav/volumes/gwnavexclusivetagvolume",
		alt_max_vector = {
			0,
			0,
			10,
		},
		alt_min_vector = {
			0,
			0,
			-1,
		},
		bottom_points = {
			{
				-8,
				-7,
				-1,
			},
			{
				6,
				-7,
				-1,
			},
			{
				6,
				8,
				-1,
			},
			{
				-8,
				8,
				-1,
			},
		},
		color = {
			255,
			255,
			0,
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
