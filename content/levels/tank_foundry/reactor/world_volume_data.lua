﻿-- chunkname: @content/levels/tank_foundry/reactor/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "volume_blocker",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-84.7559814453125,
			-74.7181167602539,
			-109.20106506347656,
		},
		alt_min_vector = {
			-84.7559814453125,
			-74.7181167602539,
			-117.93899536132812,
		},
		bottom_points = {
			{
				-81.77224731445312,
				-77.58619689941406,
				-117.93899536132812,
			},
			{
				-86.04639434814453,
				-70.7857666015625,
				-117.93899536132812,
			},
			{
				-87.73971557617188,
				-71.85003662109375,
				-117.93899536132812,
			},
			{
				-83.46556854248047,
				-78.65046691894531,
				-117.93899536132812,
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
			4.368967056274414,
		},
	},
}

return {
	volume_data = volume_data,
}
