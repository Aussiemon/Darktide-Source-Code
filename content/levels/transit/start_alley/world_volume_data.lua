﻿-- chunkname: @content/levels/transit/start_alley/world_volume_data.lua

local volume_data = {
	{
		height = 3.49999189376831,
		name = "death_zone",
		type = "content/volume_types/player_instakill",
		alt_max_vector = {
			274.06585693359375,
			-202.817138671875,
			-5.250011920928955,
		},
		alt_min_vector = {
			274.06585693359375,
			-202.817138671875,
			-8.750003814697266,
		},
		bottom_points = {
			{
				281.31573486328125,
				-266.067138671875,
				-8.750003814697266,
			},
			{
				283.8158264160156,
				-229.06716918945312,
				-8.750003814697266,
			},
			{
				254.06590270996094,
				-173.56710815429688,
				-8.750003814697266,
			},
			{
				236.56588745117188,
				-180.5670928955078,
				-8.750003814697266,
			},
			{
				243.81578063964844,
				-263.0671081542969,
				-8.750003814697266,
			},
		},
		color = {
			255,
			255,
			64,
			0,
		},
		up_vector = {
			-0,
			[2] = 0,
			[3] = 1,
		},
	},
	{
		height = 15,
		name = "volume_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			249.4810791015625,
			-264.2350158691406,
			10.853421211242676,
		},
		alt_min_vector = {
			249.4810791015625,
			-264.2350158691406,
			-4.146578788757324,
		},
		bottom_points = {
			{
				249.82562255859375,
				-259.22674560546875,
				-4.146578788757324,
			},
			{
				253.18560791015625,
				-256.4339904785156,
				-4.146578788757324,
			},
			{
				247.2476806640625,
				-250.1472625732422,
				-4.146578788757324,
			},
			{
				245.4927978515625,
				-250.19168090820312,
				-4.146578788757324,
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
		height = 15,
		name = "volume",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			254,
			-235.5,
			10.85342025756836,
		},
		alt_min_vector = {
			254,
			-235.5,
			-4.146580219268799,
		},
		bottom_points = {
			{
				247.22055053710938,
				-238.12017822265625,
				-4.146580219268799,
			},
			{
				253.08714294433594,
				-231.9586181640625,
				-4.146580219268799,
			},
			{
				257.22552490234375,
				-232.1235809326172,
				-4.146580219268799,
			},
			{
				257.20452880859375,
				-230.68350219726562,
				-4.146580219268799,
			},
			{
				252.93380737304688,
				-226.4598388671875,
				-4.146580219268799,
			},
			{
				251.9090576171875,
				-226.47021484375,
				-4.146580219268799,
			},
			{
				251.9084014892578,
				-224.51641845703125,
				-4.146580219268799,
			},
			{
				247.49375915527344,
				-224.4820098876953,
				-4.146580219268799,
			},
			{
				246.31878662109375,
				-238.13400268554688,
				-4.146580219268799,
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
