-- chunkname: @scripts/ui/hud/elements/mission_objective_popup/hud_element_mission_objective_popup_settings.lua

local hud_element_mission_objective_popup_settings = {
	events = {
		{
			"event_mission_objective_start",
			"event_mission_objective_start",
		},
		{
			"event_mission_objective_update",
			"event_mission_objective_update",
		},
		{
			"event_mission_objective_complete",
			"event_mission_objective_complete",
		},
		{
			"event_show_objective_popup",
			"on_event_show_objective_popup",
		},
	},
}

return settings("HudElementMissionObjectivePopupSettings", hud_element_mission_objective_popup_settings)
