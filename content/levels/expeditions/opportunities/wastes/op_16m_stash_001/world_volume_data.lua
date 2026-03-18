-- chunkname: @content/levels/expeditions/opportunities/wastes/op_16m_stash_001/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "no_spawn",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-2.1639859676361084,
			-0.3355660140514374,
			3.3427159786224365,
		},
		alt_min_vector = {
			-2.1639859676361084,
			-0.3355660140514374,
			-0.6572840213775635,
		},
		bottom_points = {
			{
				0.6621789932250977,
				-0.22246119379997253,
				-0.6572840213775635,
			},
			{
				-2.2770907878875732,
				2.4905989170074463,
				-0.6572840213775635,
			},
			{
				-4.9901509284973145,
				-0.4486708343029022,
				-0.6572840213775635,
			},
			{
				-2.0508811473846436,
				-3.161731004714966,
				-0.6572840213775635,
			},
		},
		color = {
			255,
			120,
			120,
			255,
		},
		up_vector = {
			[1] = 0,
			[3] = 2,
			[2] = -0,
		},
	},
}

return {
	volume_data = volume_data,
}
