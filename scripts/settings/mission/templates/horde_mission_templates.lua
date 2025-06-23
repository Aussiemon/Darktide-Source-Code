-- chunkname: @scripts/settings/mission/templates/horde_mission_templates.lua

local mission_templates = {
	psykhanium = {
		mission_name = "loc_horde_title",
		wwise_state = "horde_mode",
		mission_type = "horde",
		texture_small = "content/ui/textures/pj_missions/psykhanium_small",
		zone_id = "horde",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		texture_medium = "content/ui/textures/pj_missions/psykhanium_medium",
		texture_big = "content/ui/textures/pj_missions/psykhanium_big",
		not_needed_for_penance = true,
		pacing_template = "terror_events_only",
		level = "content/levels/horde/missions/mission_psykhanium",
		game_mode_name = "survival",
		mission_intro_minimum_time = 5,
		objectives = "psykhanium",
		coordinates = "loc_mission_coordinates_psykhanium",
		path_type = "open",
		mission_description = "loc_horde_mission_breifing_desc",
		pickup_pool = "empty_distribution_pool",
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
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4
		},
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_psykhanium"
		},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "training_ground_psyker_a",
			wwise_route_key = 1,
			vo_events = {
				"hub_horde_briefing_a",
				"hub_horde_briefing_b",
				"hub_horde_briefing_c"
			},
			mission_giver_packs = {
				training_ground_psyker_a = {
					"training_ground_psyker",
					"past"
				}
			}
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = false,
			story_ticker_enabled = false
		}
	}
}

return mission_templates
