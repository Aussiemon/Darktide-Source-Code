-- chunkname: @scripts/settings/navigation/minion_smart_object_templates/renegade_smart_object_template.lua

local template = {
	jump_up_anim_thresholds = {
		{
			height_threshold = 1.5,
			edge = {
				jump = {
					anim_vertical_length = 1,
					anim_events = {
						"jump_up_1m",
						"jump_up_1m_2",
					},
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
			height_threshold = 4,
			edge = {
				jump = {
					anim_vertical_length = 3,
					anim_events = {
						"jump_up_3m",
						"jump_up_3m_2",
					},
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
			height_threshold = 1.5,
			edge = {
				jump = {
					anim_vertical_length = 1,
					anim_events = {
						"jump_down_1m",
						"jump_down_1m_2",
					},
				},
				land = {
					anim_events = "jump_down_land",
				},
			},
			fence = {
				jump = {
					anim_events = "jump_down_fence_1m",
					anim_horizontal_length = 1.2,
					anim_vertical_length = 1,
				},
				land = {
					anim_events = "jump_down_land",
					anim_horizontal_length = 0.3,
				},
			},
		},
		{
			height_threshold = 4,
			edge = {
				jump = {
					anim_vertical_length = 3,
					anim_events = {
						"jump_down_3m",
						"jump_down_3m_2",
					},
				},
				land = {
					anim_events = "jump_down_land",
				},
			},
			fence = {
				jump = {
					anim_events = "jump_down_fence_3m",
					anim_horizontal_length = 1.2,
					anim_vertical_length = 3,
				},
				land = {
					anim_events = "jump_down_land",
					anim_horizontal_length = 0.3,
				},
			},
		},
		{
			height_threshold = math.huge,
			edge = {
				jump = {
					anim_vertical_length = 5,
					anim_events = {
						"jump_down_3m",
						"jump_down_3m_2",
					},
				},
				land = {
					anim_events = "jump_down_land",
				},
			},
			fence = {
				jump = {
					anim_events = "jump_down_fence_5m",
					anim_horizontal_length = 1.2,
					anim_vertical_length = 5,
				},
				land = {
					anim_events = "jump_down_land",
					anim_horizontal_length = 0.3,
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
					"jump_over_gap_4m_2",
				},
			},
		},
	},
}

return template
