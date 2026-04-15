-- chunkname: @content/levels/expeditions/zone_transitions/wastes/zt_16m_airlock_makeshift_001/world_volume_data.lua

local volume_data = {
	{
		height = 11.0000009536743,
		name = "volume",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			0,
			0,
			10.000000953674316,
		},
		alt_min_vector = {
			0,
			0,
			-1,
		},
		bottom_points = {
			{
				-8,
				-8,
				-1,
			},
			{
				8,
				-8,
				-1,
			},
			{
				8,
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
		height = 6,
		name = "volume_001",
		type = "core/gwnav/volumes/gwnavexclusivetagvolume",
		alt_max_vector = {
			-5,
			-2,
			5,
		},
		alt_min_vector = {
			-5,
			-2,
			-1,
		},
		bottom_points = {
			{
				-3.999997615814209,
				-5.999999523162842,
				-1,
			},
			{
				-4.000002384185791,
				2.000000476837158,
				-1,
			},
			{
				-6.000002384185791,
				1.9999995231628418,
				-1,
			},
			{
				-5.999997615814209,
				-6.000000476837158,
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
	{
		height = 7,
		name = "volume_002",
		type = "core/gwnav/volumes/gwnavexclusivetagvolume",
		alt_max_vector = {
			4.999986171722412,
			3.999998092651367,
			6,
		},
		alt_min_vector = {
			4.999986171722412,
			3.999998092651367,
			-1,
		},
		bottom_points = {
			{
				3.9999873638153076,
				5.999998569488525,
				-1,
			},
			{
				3.9999849796295166,
				1.999998688697815,
				-1,
			},
			{
				5.9999847412109375,
				1.999997615814209,
				-1,
			},
			{
				5.999987602233887,
				5.999997615814209,
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
			[1] = 0,
			[3] = 1,
			[2] = -0,
		},
	},
	{
		height = 8.25,
		name = "transition_area",
		type = "default",
		alt_max_vector = {
			0,
			0,
			8,
		},
		alt_min_vector = {
			0,
			0,
			-0.25,
		},
		bottom_points = {
			{
				5.5,
				-7.5,
				-0.25,
			},
			{
				5.5,
				-7.5,
				-0.25,
			},
			{
				5.5,
				7.25,
				-0.25,
			},
			{
				-5.75,
				7.25,
				-0.25,
			},
			{
				-5.75,
				-7.5,
				-0.25,
			},
		},
		color = {
			255,
			0,
			64,
			153,
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
