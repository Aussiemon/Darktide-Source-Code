local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_prologue_tutorial_objectives_tracker_settings = {
	background_size = {
		500,
		400
	},
	entry_size = {
		500,
		50
	},
	icon_size = {
		50,
		50
	},
	entry_colors = {
		icon = UIHudSettings.color_tint_main_1,
		entry_text = UIHudSettings.color_tint_main_1,
		counter_text = UIHudSettings.color_tint_main_1
	},
	events = {
		{
			"event_player_add_objective_tracker",
			"event_player_add_objective_tracker"
		},
		{
			"event_player_update_objectives_tracker",
			"event_player_update_objectives_tracker"
		},
		{
			"event_player_remove_current_objectives",
			"event_player_remove_current_objectives"
		},
		{
			"event_player_remove_objective",
			"event_player_remove_objective"
		}
	}
}

return settings("HudElementPrologueTutorialObjectivesTrackerSettings", hud_element_prologue_tutorial_objectives_tracker_settings)
