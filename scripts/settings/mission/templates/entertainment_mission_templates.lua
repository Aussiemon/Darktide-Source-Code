local mission_templates = {
	fm_armoury = {
		mission_name = "loc_mission_name_fm_armoury",
		wwise_state = "zone_6",
		mechanism_name = "adventure",
		texture_small = "content/ui/textures/missions/fm_armoury_small",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_fm_armoury_01",
		texture_medium = "content/ui/textures/missions/fm_armoury_medium",
		face_state_machine_key = "state_machine_missions",
		zone_id = "entertainment",
		texture_big = "content/ui/textures/missions/fm_armoury_big",
		coordinates = "loc_mission_coordinates_fm_armoury",
		mission_type = "01",
		level = "content/levels/entertainment/missions/mission_fm_armoury",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "fm_armoury",
		mission_description = "loc_mission_board_main_objective_armoury_description",
		testify_flags = {},
		cinematics = {
			intro_abc = {
				"c_cam"
			},
			outro_fail = {
				"outro_fail"
			},
			outro_win = {
				"outro_win"
			}
		},
		pickup_settings = {},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4
		},
		terror_event_templates = {
			"terror_events_fm_armoury"
		},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "sergeant_b",
			wwise_route_key = 1,
			vo_events = {
				"mission_armoury_briefing_a",
				"mission_armoury_briefing_b",
				"mission_armoury_briefing_c"
			},
			mission_giver_packs = {
				sergeant_b = {
					"sergeant",
					"enemy_nemesis_wolfer",
					"enemy_wolfer_adjutant"
				},
				explicator_a = {
					"explicator",
					"purser",
					"contract_vendor"
				},
				tech_priest_a = {
					"tech_priest",
					"shipmistress"
				}
			}
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = true,
			story_ticker_enabled = true
		},
		spawn_settings = {
			next_mission = "recent_mission"
		}
	}
}

return mission_templates
