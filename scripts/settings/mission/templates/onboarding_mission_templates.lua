local mission_templates = {
	om_hub_01 = {
		zone_id = "hub",
		mission_name = "loc_mission_name_om_hub_01",
		wwise_state = "hub",
		objectives = "onboarding",
		game_mode_name = "hub_singleplay",
		hud_elements = "scripts/ui/hud/hud_elements_player_hub",
		mechanism_name = "onboarding",
		level = "content/levels/hub/hub_ship/missions/mission_om_hub_01",
		cinematics = {
			cutscene_5_hub = {
				"cs_05_hub"
			},
			cutscene_7 = {
				"cs_07"
			}
		},
		testify_flags = {
			run_through_mission = false,
			mission_server = false
		}
	},
	om_hub_02 = {
		zone_id = "hub",
		mission_name = "loc_mission_name_om_hub_02",
		wwise_state = "hub",
		objectives = "onboarding",
		game_mode_name = "hub_singleplay",
		hud_elements = "scripts/ui/hud/hud_elements_player_hub",
		mechanism_name = "onboarding",
		level = "content/levels/hub/hub_ship/missions/mission_om_hub_02",
		testify_flags = {
			run_through_mission = false,
			mission_server = false
		}
	}
}

return mission_templates
