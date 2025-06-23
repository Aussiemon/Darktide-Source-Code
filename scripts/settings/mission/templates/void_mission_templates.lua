-- chunkname: @scripts/settings/mission/templates/void_mission_templates.lua

local mission_templates = {
	core_research = {
		mission_name = "loc_mission_name_core_research",
		mission_type = "repair",
		mission_description = "loc_mission_board_main_objective_core_research_description",
		texture_small = "content/ui/textures/pj_missions/core_research_small",
		texture_medium = "content/ui/textures/pj_missions/core_research_medium",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		coordinates = "loc_mission_coordinates_core_research",
		texture_big = "content/ui/textures/pj_missions/core_research_big",
		zone_id = "void",
		wwise_state = "zone_8",
		level = "content/levels/void/missions/mission_core_research",
		game_mode_name = "coop_complete_objective",
		mission_intro_minimum_time = 5,
		objectives = "core_research",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_core_research_01",
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
			explosion = 0.1,
			fire = 0.08,
			none = 0.45
		},
		terror_event_templates = {
			"terror_events_core_research"
		},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "tech_priest_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_core_briefing_a",
				"mission_core_briefing_b",
				"mission_core_briefing_c"
			},
			mission_giver_packs = {
				tech_priest_a = {
					"tech_priest"
				},
				interrogator_a = {
					"interrogator"
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
