-- chunkname: @content/levels/expeditions/opportunities/wastes/op_32m_vault_003_var_cap/world_volume_data.lua

local volume_data = {
	{
		height = 5,
		name = "mover_blocker",
		type = "content/volume_types/player_mover_blocker",
		alt_max_vector = {
			-5.653234004974365,
			-8.200512886047363,
			10.656904220581055,
		},
		alt_min_vector = {
			-5.653234004974365,
			-8.200512886047363,
			5.656904220581055,
		},
		bottom_points = {
			{
				-8.128105163574219,
				-5.018530368804932,
				5.656904220581055,
			},
			{
				-8.835212707519531,
				-5.7256364822387695,
				5.656904220581055,
			},
			{
				-3.1783626079559326,
				-11.382495880126953,
				5.656904220581055,
			},
			{
				-2.47125506401062,
				-10.675389289855957,
				5.656904220581055,
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
		height = 2,
		name = "no_spawn",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-0.3535490036010742,
			-3.18198299407959,
			5.5,
		},
		alt_min_vector = {
			-0.3535490036010742,
			-3.18198299407959,
			-0.5,
		},
		bottom_points = {
			{
				-3.181985378265381,
				-11.667261123657227,
				-0.5,
			},
			{
				8.131735801696777,
				-0.3535652160644531,
				-0.5,
			},
			{
				2.4748873710632324,
				5.303295135498047,
				-0.5,
			},
			{
				-8.838833808898926,
				-6.010400772094727,
				-0.5,
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
			3,
		},
	},
}

return {
	volume_data = volume_data,
}
