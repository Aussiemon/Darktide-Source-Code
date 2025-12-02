-- chunkname: @scripts/settings/mission/templates/hub_mission_templates.lua

local mission_templates = {
	hub_ship = {
		force_third_person_mode = true,
		game_mode_name = "hub",
		hud_elements = "scripts/ui/hud/hud_elements_player_hub",
		is_hub = true,
		level = "content/levels/hub/hub_ship/missions/hub_ship",
		mechanism_name = "hub",
		mission_name = "loc_mission_name_hub_ship",
		not_available_on_mission_board = true,
		objectives = "hub",
		wwise_state = "hub",
		zone_id = "hub",
		gameplay_modifiers = {
			"unkillable",
			"invulnerable",
		},
		cinematics = {
			cutscene_9 = {
				"cs_09",
			},
			traitor_captain_intro = {
				"traitor_captain_intro",
			},
			path_of_trust_01 = {
				"path_of_trust_01_part_01",
				"path_of_trust_01_corridor_01",
				"path_of_trust_01_part_02",
			},
			path_of_trust_02 = {
				"path_of_trust_02_part_01",
				"path_of_trust_02_barracks",
				"path_of_trust_02_part_02",
			},
			path_of_trust_03 = {
				"path_of_trust_03_part_01",
				"path_of_trust_03_crafting_station",
				"path_of_trust_03_part_02",
			},
			path_of_trust_04 = {
				"path_of_trust_04_part_01",
				"path_of_trust_04_corridor_02",
				"path_of_trust_04_part_02",
			},
			path_of_trust_05 = {
				"path_of_trust_05_part_01",
				"path_of_trust_05_bar",
				"path_of_trust_05_part_02",
			},
			path_of_trust_06 = {
				"path_of_trust_06_hangar",
			},
			path_of_trust_07 = {
				"path_of_trust_07_part_01",
				"path_of_trust_07_barracks",
				"path_of_trust_07_part_02",
			},
			path_of_trust_08 = {
				"path_of_trust_08_part_01",
				"path_of_trust_08_corridor_01",
				"path_of_trust_08_part_02",
			},
			path_of_trust_09 = {
				"path_of_trust_09_office",
			},
			hub_location_intro_barber = {
				"hub_location_intro_barber",
			},
			hub_location_intro_mission_board = {
				"hub_location_intro_mission_board_part_01",
				"hub_location_intro_mission_board_part_02",
			},
			hub_location_intro_training_grounds = {
				"hub_location_intro_training_grounds",
			},
		},
		testify_flags = {
			mission_server = false,
			run_through_mission = false,
			validate_minion_pathing_on_mission = false,
		},
		dialogue_settings = {
			npc_story_ticker_enabled = true,
			npc_story_ticker_start_delay = 240,
			short_story_ticker_enabled = false,
			story_start_delay = 10,
			story_ticker_enabled = false,
		},
	},
}

return mission_templates
