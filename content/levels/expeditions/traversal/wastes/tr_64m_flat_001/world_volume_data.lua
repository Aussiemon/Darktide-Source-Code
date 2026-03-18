-- chunkname: @content/levels/expeditions/traversal/wastes/tr_64m_flat_001/world_volume_data.lua

local volume_data = {
	{
		height = 6,
		name = "volume",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-14,
			-7,
			12,
		},
		alt_min_vector = {
			-14,
			-7,
			6,
		},
		bottom_points = {
			{
				-16,
				-11,
				6,
			},
			{
				-14,
				-10,
				6,
			},
			{
				-14,
				0,
				6,
			},
			{
				-9,
				16,
				6,
			},
			{
				-13,
				17,
				6,
			},
			{
				-17,
				2,
				6,
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
			9.53887939453125,
			-6.017109394073486,
			3.851102352142334,
		},
		alt_min_vector = {
			9.538878440856934,
			-6.700101852416992,
			0.9298830032348633,
		},
		bottom_points = {
			{
				-1.291513442993164,
				-8.811704635620117,
				1.4235862493515015,
			},
			{
				10.639915466308594,
				-7.564329147338867,
				1.1319425106048584,
			},
			{
				10.426412582397461,
				-5.627978324890137,
				0.6792161464691162,
			},
			{
				-1.5050163269042969,
				-6.875354290008545,
				0.9708598852157593,
			},
		},
		color = {
			255,
			255,
			125,
			0,
		},
		up_vector = {
			1.909211277961731e-07,
			0.22766414284706116,
			0.9737396836280823,
		},
	},
}

return {
	volume_data = volume_data,
}
