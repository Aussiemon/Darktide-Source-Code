﻿-- chunkname: @content/levels/horde/missions/mission_psykhanium_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "volume_002",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-14.3726167678833,
			-283.9205322265625,
			19.721540451049805,
		},
		alt_min_vector = {
			-14.3726167678833,
			-283.9205322265625,
			13,
		},
		bottom_points = {
			{
				-13.722617149353027,
				-283.2705383300781,
				13,
			},
			{
				-15.022616386413574,
				-283.2705383300781,
				13,
			},
			{
				-15.022616386413574,
				-284.5705261230469,
				13,
			},
			{
				-13.722617149353027,
				-284.5705261230469,
				13,
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
			[3] = 3.3607699871063232,
			[2] = -0,
		},
	},
	{
		height = 56,
		name = "volume_no_spawn",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-20,
			-103,
			41,
		},
		alt_min_vector = {
			-20,
			-103,
			-15,
		},
		bottom_points = {
			{
				56,
				37.693084716796875,
				-15,
			},
			{
				-95,
				37.693084716796875,
				-15,
			},
			{
				-95,
				-165.53025817871094,
				-15,
			},
			{
				56,
				-165.53025817871094,
				-15,
			},
		},
		color = {
			255,
			120,
			120,
			255,
		},
		up_vector = {
			0,
			0,
			1,
		},
	},
	{
		height = 2,
		name = "volume",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-10.083789825439453,
			-275.0094299316406,
			19.721540451049805,
		},
		alt_min_vector = {
			-10.083789825439453,
			-275.0094299316406,
			13,
		},
		bottom_points = {
			{
				-9.168048858642578,
				-275.08953857421875,
				13,
			},
			{
				-10.003673553466797,
				-274.09368896484375,
				13,
			},
			{
				-10.999530792236328,
				-274.9293212890625,
				13,
			},
			{
				-10.16390609741211,
				-275.9251708984375,
				13,
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
			3.3607699871063232,
		},
	},
	{
		height = 1.17085897922516,
		name = "volume_003",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-14.3726167678833,
			-278.3927917480469,
			14.170859336853027,
		},
		alt_min_vector = {
			-14.3726167678833,
			-278.3927917480469,
			13,
		},
		bottom_points = {
			{
				-11.259944915771484,
				-275.9720764160156,
				13,
			},
			{
				-17.49411392211914,
				-275.9411315917969,
				13,
			},
			{
				-14.366046905517578,
				-282.1558837890625,
				13,
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
		height = 2,
		name = "volume_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-18.67581558227539,
			-275.01019287109375,
			19.721540451049805,
		},
		alt_min_vector = {
			-18.67581558227539,
			-275.01019287109375,
			13,
		},
		bottom_points = {
			{
				-17.760074615478516,
				-274.9300842285156,
				13,
			},
			{
				-18.75593376159668,
				-274.0944519042969,
				13,
			},
			{
				-19.591556549072266,
				-275.0903015136719,
				13,
			},
			{
				-18.5956974029541,
				-275.9259338378906,
				13,
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
			3.3607699871063232,
		},
	},
}

return {
	volume_data = volume_data,
}
