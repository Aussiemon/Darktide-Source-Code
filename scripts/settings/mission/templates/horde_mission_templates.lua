-- chunkname: @scripts/settings/mission/templates/horde_mission_templates.lua

local mission_templates = {
	psykhanium = {
		coordinates = "loc_mission_coordinates_psykhanium",
		face_state_machine_key = "state_machine_missions",
		game_mode_name = "survival",
		level = "content/levels/horde_new_island/missions/mission_psykhanium",
		mechanism_name = "adventure",
		mission_description = "loc_horde_mission_breifing_desc",
		mission_intro_minimum_time = 5,
		mission_name = "loc_horde_title",
		mission_type = "horde",
		not_needed_for_penance = true,
		objectives = "psykhanium",
		pacing_template = "terror_events_only",
		path_type = "open",
		pickup_pool = "empty_distribution_pool",
		texture_big = "content/ui/textures/pj_missions/psykhanium_big",
		texture_medium = "content/ui/textures/pj_missions/psykhanium_medium",
		texture_small = "content/ui/textures/pj_missions/psykhanium_small",
		wwise_state = "horde_mode",
		zone_id = "horde",
		testify_flags = {},
		cinematics = {
			intro_abc = {
				"c_cam",
			},
			outro_fail = {
				"outro_fail",
			},
			outro_win = {
				"outro_win",
			},
		},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4,
		},
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_psykhanium_new",
		},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "training_ground_psyker_a",
			wwise_route_key = 1,
			vo_events = {
				"hub_horde_briefing_a",
				"hub_horde_briefing_b",
				"hub_horde_briefing_c",
			},
			mission_giver_packs = {
				training_ground_psyker_a = {
					"training_ground_psyker",
					"past",
				},
			},
		},
		dialogue_settings = {
			npc_story_ticker_enabled = false,
			short_story_ticker_enabled = false,
			story_ticker_enabled = false,
		},
	},
}

return mission_templates
