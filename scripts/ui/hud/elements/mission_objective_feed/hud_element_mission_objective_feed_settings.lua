local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_mission_objective_feed_settings = {
	description_text_height_offset = 5,
	entry_spacing = 0,
	scan_delay = 0.25,
	header_size = {
		460,
		40
	},
	events = {
		event_add_mission_objective = "event_add_objective",
		event_remove_mission_objective = "_remove_objective"
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
			bar = UIHudSettings.color_tint_main_2,
			bar_frame = UIHudSettings.color_tint_main_2,
			bar_background = UIHudSettings.color_tint_main_3,
			icon = UIHudSettings.color_tint_main_2,
			header_text = UIHudSettings.color_tint_main_2,
			distance_text = UIHudSettings.color_tint_main_2
		}
	}
}

return settings("HudElementMissionObjectiveFeedSettings", hud_element_mission_objective_feed_settings)
