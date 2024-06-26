-- chunkname: @scripts/settings/mission/templates/prologue_mission_templates.lua

local mission_templates = {
	prologue = {
		face_state_machine_key = "state_machine_prologue",
		game_mode_name = "prologue",
		hud_elements = "scripts/ui/hud/hud_elements_player_onboarding",
		level = "content/levels/prologue/missions/prologue",
		mechanism_name = "onboarding",
		mission_name = "loc_mission_name_prologue",
		not_needed_for_penance = true,
		objectives = "prologue",
		wwise_state = "prologue",
		zone_id = "prologue",
		gameplay_modifiers = {
			"unkillable",
			"infinite_ammo_reserve",
		},
		terror_event_templates = {
			"terror_events_prologue",
		},
		testify_flags = {
			mission_server = false,
			run_through_mission = false,
			validate_minion_pathing_on_mission = false,
		},
		cinematics = {
			cutscene_1 = {
				"cs_intro",
			},
			cutscene_2 = {
				"cs_02_part_1",
				"cs_02_part_2",
				"cs_02_part_3",
			},
			cutscene_3 = {
				"cs_03",
			},
			cutscene_4 = {
				"cs_04",
			},
			cutscene_5 = {
				"cs_05",
				"cs_05_exterior",
			},
		},
	},
}

return mission_templates
