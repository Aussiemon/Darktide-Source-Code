local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_prologue_tutorial_objectives_tracker_settings = {
	icon = "content/ui/materials/icons/mission_type/default",
	background_size = {
		500,
		400
	},
	entry_size = {
		500,
		60
	},
	icon_size = {
		50,
		50
	},
	entry_colors = {
		icon = UIHudSettings.color_tint_main_1,
		description_text = UIHudSettings.color_tint_main_1
	},
	description_text_style = {
		vertical_alignment = "center",
		drop_shadow = false,
		font_size = 25,
		text_vertical_alignment = "center",
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "right",
		offset = {
			75,
			0,
			4
		},
		size = {
			400,
			50
		}
	},
	events = {
		{
			"event_player_add_step_tracker",
			"event_player_add_step_tracker"
		},
		{
			"event_player_remove_tracker",
			"event_player_remove_tracker"
		}
	}
}

return settings("HudElementPrologueTutorialObjectivesTrackerSettings", hud_element_prologue_tutorial_objectives_tracker_settings)
