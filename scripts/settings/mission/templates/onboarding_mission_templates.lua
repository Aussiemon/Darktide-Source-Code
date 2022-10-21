local mission_templates = {
	om_basic_combat_01 = {
		use_prologue_profile = false,
		mission_name = "loc_mission_name_tg_basic_combat_01",
		objectives = "training_grounds",
		zone_id = "training_grounds",
		game_mode_name = "training_grounds",
		mechanism_name = "onboarding",
		level = "content/levels/training_grounds/missions/mission_tg_basic_combat_01",
		terror_event_templates = {
			"terror_events_training_ground"
		},
		testify_flags = {
			run_through_mission = false,
			performance = false,
			cutscenes = false,
			mission_server = false
		}
	}
}

return mission_templates
