-- chunkname: @content/levels/throneside/admin_office/world_volume_data.lua

local volume_data = {
	{
		height = 2,
		type = "content/volume_types/nav_tag_volumes/no_spawn",
		name = "volume_nospawn_monsterwall_001",
		alt_max_vector = {
			-160.26303100585938,
			-29.131254196166992,
			6.844242095947266
		},
		alt_min_vector = {
			-160.26303100585938,
			-29.131254196166992,
			2.3874759674072266
		},
		bottom_points = {
			{
				-154.79498291015625,
				-28.439956665039062,
				2.3874759674072266
			},
			{
				-159.57171630859375,
				-23.6632080078125,
				2.3874759674072266
			},
			{
				-165.7310791015625,
				-29.822551727294922,
				2.3874759674072266
			},
			{
				-160.954345703125,
				-34.599300384521484,
				2.3874759674072266
			}
		},
		color = {
			255,
			120,
			120,
			255
		},
		up_vector = {
			0,
			0,
			2.2283830642700195
		}
	},
	{
		height = 5,
		type = "content/volume_types/player_instakill",
		name = "dz_001",
		alt_max_vector = {
			-181,
			-8.25,
			-1.8831868171691895
		},
		alt_min_vector = {
			-181,
			-8.25,
			-6.8831868171691895
		},
		bottom_points = {
			{
				-226.75,
				-33.25,
				-6.8831868171691895
			},
			{
				-170.5,
				-33.24999237060547,
				-6.8831868171691895
			},
			{
				-170.5,
				7.500005722045898,
				-6.8831868171691895
			},
			{
				-226.75,
				7.5,
				-6.8831868171691895
			}
		},
		color = {
			255,
			255,
			64,
			0
		},
		up_vector = {
			0,
			0,
			1
		}
	}
}

return {
	volume_data = volume_data
}
