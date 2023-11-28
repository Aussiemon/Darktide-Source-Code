-- chunkname: @content/levels/dust/consulate_maintenance/world_volume_data.lua

local volume_data = {
	{
		height = 3,
		type = "content/volume_types/player_mover_blocker",
		name = "volume",
		alt_max_vector = {
			64.75,
			98.75,
			-4.25
		},
		alt_min_vector = {
			64.75,
			98.75,
			-7.25
		},
		bottom_points = {
			{
				63.25,
				97.75,
				-7.25
			},
			{
				66.75,
				97.75,
				-7.25
			},
			{
				66.75,
				99.75,
				-7.25
			},
			{
				63.25,
				99.75,
				-7.25
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
	},
	{
		height = 2,
		type = "core/gwnav/volumes/gwnavexclusivetagvolume",
		name = "volume_block_nav_con_main_002",
		alt_max_vector = {
			48,
			117,
			-6
		},
		alt_min_vector = {
			48,
			117,
			-8
		},
		bottom_points = {
			{
				49,
				118,
				-8
			},
			{
				47,
				118,
				-8
			},
			{
				47,
				116,
				-8
			},
			{
				49,
				116,
				-8
			}
		},
		color = {
			255,
			255,
			0,
			0
		},
		up_vector = {
			0,
			0,
			1
		}
	},
	{
		height = 2,
		type = "core/gwnav/volumes/gwnavexclusivetagvolume",
		name = "volume_block_nav_con_main_001",
		alt_max_vector = {
			34.40117645263672,
			92.25,
			-1.75
		},
		alt_min_vector = {
			34.40117645263672,
			92.25,
			-3.75
		},
		bottom_points = {
			{
				35.40117645263672,
				87.65946197509766,
				-3.75
			},
			{
				35.40117645263672,
				96.84053802490234,
				-3.75
			},
			{
				33.40117645263672,
				96.84053802490234,
				-3.75
			},
			{
				33.40117645263672,
				87.65946197509766,
				-3.75
			}
		},
		color = {
			255,
			255,
			0,
			0
		},
		up_vector = {
			-0,
			[2] = 0,
			[3] = 1
		}
	},
	{
		height = 2,
		type = "content/volume_types/player_instakill",
		name = "volume_001",
		alt_max_vector = {
			79.00000762939453,
			122.24998474121094,
			-20.090139389038086
		},
		alt_min_vector = {
			79.00000762939453,
			122.24998474121094,
			-21.02899932861328
		},
		bottom_points = {
			{
				83.90298461914062,
				136.9709014892578,
				-21.02899932861328
			},
			{
				74.09703063964844,
				136.9709014892578,
				-21.02899932861328
			},
			{
				74.09703063964844,
				107.52906799316406,
				-21.02899932861328
			},
			{
				83.90298461914062,
				107.52906799316406,
				-21.02899932861328
			}
		},
		color = {
			255,
			255,
			64,
			0
		},
		up_vector = {
			0,
			0,
			0.46942999958992004
		}
	}
}

return {
	volume_data = volume_data
}
