-- chunkname: @scripts/settings/mission/templates/depths_mission_templates.lua

local mission_templates = {
	spillway = {
		face_state_machine_key = "state_machine_missions",
		forced_faction = "renegade",
		game_mode_name = "coop_complete_objective",
		level = "content/levels/depths/missions/mission_spillway",
		mechanism_name = "adventure",
		mission_brief_material = "content/environment/cinematic/mission_briefing/mission_briefing_hologram_spillway_01",
		mission_description = "loc_mission_board_main_objective_spillway_description",
		mission_intro_minimum_time = 5,
		mission_name = "loc_mission_name_spillway",
		mission_type = "assassination",
		objectives = "spillway",
		texture_big = "content/ui/textures/missions/spillway_big",
		texture_medium = "content/ui/textures/missions/spillway_medium",
		texture_small = "content/ui/textures/missions/spillway_small",
		wwise_state = "zone_2_depths",
		zone_id = "depths",
		testify_flags = {
			cutscenes = false,
		},
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
			spillway_wizard_intro = {
				"traitor_captain_intro",
			},
		},
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4,
		},
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_spillway",
		},
		health_station = {},
		mission_brief_vo = {
			vo_profile = "boon_vendor_a",
			wwise_route_key = 1,
			vo_events = {
				"mission_spillway_briefing_a",
				"mission_spillway_briefing_b",
				"mission_spillway_briefing_c",
				"mission_spillway_briefing_d",
			},
			mission_giver_packs = {
				boon_vendor_a = {
					"boon_vendor",
					"armourer",
					"ragged_king",
					"fx",
					skip_voices = {
						armourer_b = true,
						ragged_king_b = true,
					},
				},
				armourer_b = {
					"armourer",
					"ragged_king",
					skip_voices = {
						armourer_a = true,
						ragged_king_a = true,
					},
					briefing_voice_order = {
						"armourer_b",
						"armourer_b",
						"ragged_king_b",
						"armourer_b",
					},
				},
			},
		},
		dialogue_settings = {
			short_story_ticker_enabled = true,
			story_ticker_enabled = true,
		},
		controllable_object_set_prefixes = {
			"flow",
		},
	},
}

return mission_templates
