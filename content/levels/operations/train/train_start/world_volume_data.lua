﻿-- chunkname: @content/levels/operations/train/train_start/world_volume_data.lua

local volume_data = {
	{
		height = 28,
		name = "volume",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-7.000000096013537e-06,
			208.9999542236328,
			21,
		},
		alt_min_vector = {
			-7.000000096013537e-06,
			208.9999542236328,
			-7,
		},
		bottom_points = {
			{
				-10.000006675720215,
				205.9999542236328,
				-7,
			},
			{
				9.999993324279785,
				205.9999542236328,
				-7,
			},
			{
				12.999993324279785,
				215.99996948242188,
				-7,
			},
			{
				-13.000006675720215,
				216.9999542236328,
				-7,
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
		height = 3,
		name = "volume_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			2.0003271102905273,
			147.99993896484375,
			4.000000953674316,
		},
		alt_min_vector = {
			2.0003271102905273,
			147.99993896484375,
			1.0000009536743164,
		},
		bottom_points = {
			{
				4.000327110290527,
				148.49993896484375,
				1.0000009536743164,
			},
			{
				3.7503271102905273,
				148.74993896484375,
				1.0000009536743164,
			},
			{
				0.25032711029052734,
				148.74993896484375,
				1.0000009536743164,
			},
			{
				0.00032711029052734375,
				148.49993896484375,
				1.0000009536743164,
			},
			{
				0.00032711029052734375,
				146.99993896484375,
				1.0000009536743164,
			},
			{
				4.000327110290527,
				146.99993896484375,
				1.0000009536743164,
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
}

return {
	volume_data = volume_data,
}
