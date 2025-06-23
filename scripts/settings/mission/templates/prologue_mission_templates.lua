-- chunkname: @scripts/settings/mission/templates/prologue_mission_templates.lua

local mission_templates = {
	prologue = {
		game_mode_name = "prologue",
		mission_name = "loc_mission_name_prologue",
		hud_elements = "scripts/ui/hud/hud_elements_player_onboarding",
		objectives = "prologue",
		zone_id = "prologue",
		wwise_state = "prologue",
		mechanism_name = "onboarding",
		face_state_machine_key = "state_machine_prologue",
		not_needed_for_penance = true,
		level = "content/levels/prologue/missions/prologue",
		gameplay_modifiers = {
			"unkillable",
			"infinite_ammo_reserve"
		},
		terror_event_templates = {
			"terror_events_prologue"
		},
		testify_flags = {
			run_through_mission = false,
			validate_minion_pathing_on_mission = false,
			mission_server = false
		},
		cinematics = {
			cutscene_1 = {
				"cs_intro"
			},
			cutscene_2 = {
				"cs_02_part_1",
				"cs_02_part_2",
				"cs_02_part_3"
			},
			cutscene_3 = {
				"cs_03"
			},
			cutscene_4 = {
				"cs_04"
			},
			cutscene_5 = {
				"cs_05",
				"cs_05_exterior"
			}
		}
	}
}

return mission_templates
