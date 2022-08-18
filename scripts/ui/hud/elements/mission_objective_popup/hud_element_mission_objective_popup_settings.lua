local hud_element_mission_objective_popup_settings = {
	events = {
		{
			"event_mission_objective_start",
			"event_mission_objective_start"
		},
		{
			"event_mission_objective_update",
			"event_mission_objective_update"
		},
		{
			"event_mission_objective_complete",
			"event_mission_objective_complete"
		}
	}
}

return settings("HudElementMissionObjectivePopupSettings", hud_element_mission_objective_popup_settings)
