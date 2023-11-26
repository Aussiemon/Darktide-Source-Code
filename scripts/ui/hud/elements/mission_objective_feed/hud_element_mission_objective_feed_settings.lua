-- chunkname: @scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_mission_objective_feed_settings = {
	entry_spacing = 0,
	description_text_height_offset = 5,
	scan_delay = 0.25,
	header_size = {
		460,
		40
	},
	events = {
		event_add_mission_objective = "event_add_objective",
		event_remove_mission_objective = "_remove_objective"
	},
	entry_spacing_by_mission_type = {
		default = 10,
		side_mission = 0
	},
	colors_by_mission_type = {
		default = {
			bar = UIHudSettings.color_tint_main_1,
			bar_frame = UIHudSettings.color_tint_main_1,
			bar_background = UIHudSettings.color_tint_main_2,
			icon = UIHudSettings.color_tint_main_1,
			header_text = UIHudSettings.color_tint_main_1,
			distance_text = UIHudSettings.color_tint_main_1
		},
		side_mission = {
			bar = UIHudSettings.color_tint_6,
			bar_frame = UIHudSettings.color_tint_6,
			bar_background = UIHudSettings.color_tint_main_3,
			icon = UIHudSettings.color_tint_6,
			header_text = UIHudSettings.color_tint_6,
			distance_text = UIHudSettings.color_tint_6
		}
	},
	size_by_mission_type = {
		default = {
			icon = {
				32,
				32
			}
		},
		side_mission = {
			icon = {
				20,
				20
			}
		}
	},
	offsets_by_mission_type = {
		default = {
			icon = {
				10,
				0,
				6
			}
		},
		side_mission = {
			icon = {
				16,
				0,
				6
			}
		}
	}
}

return settings("HudElementMissionObjectiveFeedSettings", hud_element_mission_objective_feed_settings)
