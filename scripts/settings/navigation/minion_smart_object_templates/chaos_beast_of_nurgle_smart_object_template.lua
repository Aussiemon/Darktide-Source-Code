﻿-- chunkname: @scripts/settings/navigation/minion_smart_object_templates/chaos_beast_of_nurgle_smart_object_template.lua

local template = {
	jump_up_anim_thresholds = {
		{
			height_threshold = 1.5,
			edge = {
				jump = {
					anim_events = "jump_up_1m",
					anim_vertical_length = 1,
				},
			},
			fence = {
				jump = {
					anim_events = "jump_up_fence_1m",
					anim_vertical_length = 1,
				},
			},
		},
		{
			height_threshold = 2.5,
			edge = {
				jump = {
					anim_events = "jump_up_2m",
					anim_vertical_length = 2,
				},
			},
			fence = {
				jump = {
					anim_events = "jump_up_fence_2m",
					anim_vertical_length = 2,
				},
			},
		},
		{
			height_threshold = 3.5,
			edge = {
				jump = {
					anim_events = "jump_up_3m",
					anim_vertical_length = 3,
				},
			},
			fence = {
				jump = {
					anim_events = "jump_up_fence_3m",
					anim_vertical_length = 3,
				},
			},
		},
		{
			height_threshold = math.huge,
			edge = {
				jump = {
					anim_events = "jump_up_5m",
					anim_vertical_length = 5,
				},
			},
			fence = {
				jump = {
					anim_events = "jump_up_fence_5m",
					anim_vertical_length = 5,
				},
			},
		},
	},
	jump_down_anim_thresholds = {
		{
			height_threshold = 1,
			edge = {
				jump = {
					anim_events = "jump_down_1m",
					anim_vertical_length = 1,
				},
				land = {
					anim_events = "jump_down_land_1m",
				},
			},
			fence = {
				jump = {
					anim_events = "jump_down_fence_1m",
					anim_horizontal_length = 1.5,
					anim_vertical_length = 1,
				},
				land = {
					anim_events = "jump_down_fence_land_1m",
					anim_horizontal_length = 0,
				},
			},
		},
		{
			height_threshold = 2,
			edge = {
				jump = {
					anim_events = "jump_down_1m",
					anim_vertical_length = 2,
				},
				land = {
					anim_events = "jump_down_land_1m",
				},
			},
			fence = {
				jump = {
					anim_events = "jump_down_fence_2m",
					anim_horizontal_length = 1.5,
					anim_vertical_length = 2,
				},
				land = {
					anim_events = "jump_down_fence_land_2m",
					anim_horizontal_length = 0,
				},
			},
		},
		{
			height_threshold = 4,
			edge = {
				jump = {
					anim_events = "jump_down_3m",
					anim_vertical_length = 3,
				},
				land = {
					anim_events = "jump_down_land_3m",
				},
			},
			fence = {
				jump = {
					anim_events = "jump_down_fence_3m",
					anim_horizontal_length = 1.5,
					anim_vertical_length = 3,
				},
				land = {
					anim_events = "jump_down_fence_land_3m",
					anim_horizontal_length = 0,
				},
			},
		},
		{
			height_threshold = math.huge,
			edge = {
				jump = {
					anim_events = "jump_down_3m",
					anim_vertical_length = 5,
				},
				land = {
					anim_events = "jump_down_land_3m",
				},
			},
			fence = {
				jump = {
					anim_events = "jump_down_fence_5m",
					anim_horizontal_length = 1.5,
					anim_vertical_length = 5,
				},
				land = {
					anim_events = "jump_down_fence_land_5m",
					anim_horizontal_length = 0,
				},
			},
		},
	},
	jump_across_anim_thresholds = {
		jump = {
			{
				anim_horizontal_length = 4,
				horizontal_threshold = math.huge,
				anim_events = {
					"jump_over_gap_4m",
				},
			},
		},
		cover_vaults = {
			{
				horizontal_threshold = math.huge,
				anim_horizontal_lengths = {
					jump_over_cover = 9.1091,
				},
				anim_events = {
					"jump_over_cover",
				},
			},
		},
	},
}

return template
