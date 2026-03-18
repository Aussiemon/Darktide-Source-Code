-- chunkname: @content/levels/expeditions/opportunities/oil/op_32m_revolve_001/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		name = "volume_no_spawn_001",
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		alt_max_vector = {
			-6.989137172698975,
			1.2754230499267578,
			2.7084529399871826,
		},
		alt_min_vector = {
			-6.989137172698975,
			1.2754230499267578,
			0.7084529995918274,
		},
		bottom_points = {
			{
				-4.209941864013672,
				-2.517915964126587,
				0.7084529995918274,
			},
			{
				-4.209941864013672,
				5.068761825561523,
				0.7084529995918274,
			},
			{
				-9.768332481384277,
				5.068761825561523,
				0.7084529995918274,
			},
			{
				-9.768332481384277,
				-2.517915964126587,
				0.7084529995918274,
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
