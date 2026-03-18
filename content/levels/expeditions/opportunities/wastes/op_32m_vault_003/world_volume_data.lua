-- chunkname: @content/levels/expeditions/opportunities/wastes/op_32m_vault_003/world_volume_data.lua

local volume_data = {
	{
		height = 5,
		name = "volume",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			1.0535320043563843,
			-1.5216870307922363,
			5.621758937835693,
		},
		alt_min_vector = {
			1.0535320043563843,
			-1.5216870307922363,
			0.6217590570449829,
		},
		bottom_points = {
			{
				-0.36067163944244385,
				-8.592756271362305,
				0.6217590570449829,
			},
			{
				8.124597549438477,
				-0.10746335983276367,
				0.6217590570449829,
			},
			{
				2.467735767364502,
				5.54938268661499,
				0.6217590570449829,
			},
			{
				-6.017532825469971,
				-2.935910224914551,
				0.6217590570449829,
			},
		},
		color = {
			255,
			120,
			120,
			255,
		},
		up_vector = {
			-0,
			[2] = 0,
			[3] = 1,
		},
	},
}

return {
	volume_data = volume_data,
}
