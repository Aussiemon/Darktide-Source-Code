-- chunkname: @content/levels/watertown_twins/enforcer_elevator/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "volume_001",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-213.781494140625,
			-26.534568786621094,
			25.6182918548584,
		},
		alt_min_vector = {
			-213.781494140625,
			-26.534568786621094,
			21.994853973388672,
		},
		bottom_points = {
			{
				-213.35342407226562,
				-28.800718307495117,
				21.994853973388672,
			},
			{
				-212.2777099609375,
				-24.786054611206055,
				21.994853973388672,
			},
			{
				-214.20956420898438,
				-24.26841926574707,
				21.994853973388672,
			},
			{
				-215.2852783203125,
				-28.283082962036133,
				21.994853973388672,
			},
		},
		color = {
			255,
			255,
			125,
			0,
		},
		up_vector = {
			-0,
			[2] = 0,
			[3] = 1.8117189407348633,
		},
	},
}

return {
	volume_data = volume_data,
}
