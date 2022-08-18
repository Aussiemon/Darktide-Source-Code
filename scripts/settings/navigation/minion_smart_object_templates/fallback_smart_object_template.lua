local template = {
	jump_up_anim_thresholds = {
		{
			height_threshold = 1.5,
			edge = {
				jump = {
					anim_events = "jump_up_1m",
					anim_vertical_length = 1
				}
			},
			fence = {
				jump = {
					anim_events = "jump_up_1m",
					anim_vertical_length = 1
				}
			}
		},
		{
			height_threshold = math.huge,
			edge = {
				jump = {
					anim_events = "jump_up_3m",
					anim_vertical_length = 3
				}
			},
			fence = {
				jump = {
					anim_events = "jump_up_3m",
					anim_vertical_length = 3
				}
			}
		}
	},
	jump_down_anim_thresholds = {
		{
			height_threshold = 1.5,
			edge = {
				jump = {
					anim_events = "jump_down",
					anim_vertical_length = 1
				},
				land = {
					anim_events = "jump_down_land"
				}
			},
			fence = {
				jump = {
					anim_vertical_length = 1,
					anim_horizontal_length = 1.5,
					anim_events = "jump_down"
				},
				land = {
					anim_horizontal_length = 0,
					anim_events = "jump_down_land"
				}
			}
		},
		{
			height_threshold = math.huge,
			edge = {
				jump = {
					anim_events = "jump_down",
					anim_vertical_length = 3
				},
				land = {
					anim_events = "jump_down_land"
				}
			},
			fence = {
				jump = {
					anim_vertical_length = 3,
					anim_horizontal_length = 1.1,
					anim_events = "jump_down"
				},
				land = {
					anim_horizontal_length = 0.4,
					anim_events = "jump_down_land"
				}
			}
		}
	},
	jump_across_anim_thresholds = {
		jump = {
			{
				anim_horizontal_length = 4,
				horizontal_threshold = math.huge,
				anim_events = {
					"jump_over_gap_4m",
					"jump_over_gap_4m_2"
				}
			}
		}
	}
}

return template
