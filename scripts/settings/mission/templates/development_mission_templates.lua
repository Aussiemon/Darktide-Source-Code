local mission_templates = {
	multi_mission_1 = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/zone_multi_mission/missions/mission_1/mission_1",
		pickup_settings = {},
		health_station = {
			charges_to_distribute = 10
		}
	},
	multi_mission_2 = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/zone_multi_mission/missions/mission_2/mission_2"
	},
	multi_mission_3 = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/zone_multi_mission/missions/mission_3/mission_3"
	},
	empty = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		wwise_state = "None",
		objectives = "debug",
		zone_id = "placeholder",
		game_mode_name = "default",
		is_dev_mission = true,
		level = "content/levels/debug/empty/world"
	},
	doors = {
		mission_name = "loc_mission_name_placeholder",
		wwise_state = "None",
		zone_id = "placeholder",
		game_mode_name = "default",
		is_dev_mission = true,
		mechanism_name = "adventure",
		level = "content/levels/debug/doors/world",
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_debug_doors"
		}
	},
	moveable_platforms = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		wwise_state = "None",
		zone_id = "placeholder",
		mission_name = "loc_mission_name_placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/moveable_platforms/world"
	},
	triggers = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		wwise_state = "None",
		zone_id = "placeholder",
		mission_name = "loc_mission_name_placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/triggers/world"
	},
	mission_objectives = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		wwise_state = "None",
		zone_id = "placeholder",
		mission_name = "loc_mission_name_placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/mission_objectives/world",
		terror_event_templates = {
			"terror_events_mission_objectives"
		}
	},
	side_objectives = {
		mission_name = "loc_mission_name_placeholder",
		wwise_state = "None",
		zone_id = "placeholder",
		game_mode_name = "default",
		is_dev_mission = true,
		mechanism_name = "adventure",
		level = "content/levels/debug/side_objectives/world",
		pickup_settings = {},
		terror_event_templates = {
			"terror_events_side_objectives"
		}
	},
	destructibles = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		wwise_state = "None",
		zone_id = "placeholder",
		mission_name = "loc_mission_name_placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/destructibles/world",
		hazard_prop_settings = {
			explosion = 0.3,
			fire = 0.2,
			none = 0.4
		}
	},
	player_mechanics = {
		mission_name = "loc_mission_name_placeholder",
		wwise_state = "zone_1",
		zone_id = "placeholder",
		game_mode_name = "coop_complete_objective",
		mechanism_name = "adventure",
		is_dev_mission = true,
		level = "content/levels/debug/player_mechanics/world",
		health_station = {
			charges_to_distribute = 3
		},
		hazard_prop_settings = {
			explosion = 1,
			none = 1
		}
	},
	trigger_volumes = {
		mission_name = "loc_mission_name_placeholder",
		wwise_state = "zone_1",
		zone_id = "placeholder",
		game_mode_name = "coop_complete_objective",
		mechanism_name = "adventure",
		is_dev_mission = true,
		level = "content/levels/debug/trigger_volumes/world",
		health_station = {
			charges_to_distribute = 3
		},
		hazard_prop_settings = {
			explosion = 1,
			none = 1
		}
	},
	player_interactables = {
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		game_mode_name = "default",
		music = "zone_1",
		is_dev_mission = true,
		mechanism_name = "adventure",
		level = "content/levels/debug/player_interactables/world",
		hazard_prop_settings = {
			explosion = 1,
			none = 0
		},
		terror_event_templates = {
			"terror_events_player_interactables"
		}
	},
	arvid_artreview = {
		game_mode_name = "default",
		wwise_state = "zone_1",
		zone_id = "placeholder",
		mission_name = "loc_mission_name_placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/art_approval/arvid/world",
		hazard_prop_settings = {
			explosion = 1,
			fire = 1,
			none = 1,
			gas = 1
		},
		health_station = {
			charges_to_distribute = 3
		}
	},
	bjorn_g_artreview = {
		game_mode_name = "default",
		wwise_state = "zone_1",
		zone_id = "placeholder",
		mission_name = "loc_mission_name_placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/art_approval/bjorn_g/world",
		hazard_prop_settings = {
			explosion = 1,
			fire = 1,
			none = 1,
			gas = 1
		},
		health_station = {
			charges_to_distribute = 3
		}
	},
	lighting_reference_combat = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		wwise_state = "zone_1",
		zone_id = "placeholder",
		mission_name = "loc_mission_name_placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/lighting_reference/lighting_reference_combat/world",
		health_station = {
			charges_to_distribute = 3
		}
	},
	fx_default_lighting_01 = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/fx/fx_default_lighting_01",
		hazard_prop_settings = {
			explosion = 1
		}
	},
	fx_destructibles = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/fx/fx_destructibles",
		hazard_prop_settings = {
			explosion = 1
		}
	},
	fx_debug_bridge_wobe = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/fx/fx_debug_bridge_wobe"
	},
	whitebox_ta = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/whitebox_ta/world"
	},
	level_scripdata_tester = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/level_scripdata_tester/world"
	},
	bridge_test = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/bridge_test/world"
	},
	combat = {
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		game_mode_name = "coop_complete_objective",
		mechanism_name = "adventure",
		is_dev_mission = true,
		face_state_machine_key = "state_machine_missions",
		level = "content/levels/debug/combat_zone/missions/mission_combat_zone",
		pickup_settings = {},
		health_station = {
			charges_to_distribute = 10
		},
		hazard_prop_settings = {
			explosion = 1,
			fire = 1,
			none = 0
		},
		terror_event_templates = {
			"terror_events_combat"
		}
	},
	Sewers = {
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		game_mode_name = "default",
		mechanism_name = "adventure",
		is_dev_mission = true,
		level = "content/levels/debug/jacopo/missions/Sewers",
		pickup_settings = {},
		health_station = {
			charges_to_distribute = 10
		},
		terror_event_templates = {
			"terror_events_Sewers"
		}
	},
	combat_zone_new = {
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		game_mode_name = "default",
		mechanism_name = "adventure",
		is_dev_mission = true,
		level = "content/levels/debug/combat_zone_new/missions/mission_combat_zone_new",
		pickup_settings = {},
		health_station = {
			charges_to_distribute = 10
		},
		hazard_prop_settings = {
			explosion = 1,
			fire = 0,
			none = 2,
			gas = 0
		}
	},
	minion_mechanics = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/minion_mechanics/world"
	},
	sound = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/sound/world",
		pickup_settings = {}
	},
	sound_performance = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/sound_performance/world",
		pickup_settings = {}
	},
	station_inside_sound = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/sound/station_inside_sound/world"
	},
	vo = {
		mission_name = "loc_mission_name_placeholder",
		is_dev_mission = true,
		zone_id = "placeholder",
		game_mode_name = "default",
		mechanism_name = "adventure",
		face_state_machine_key = "state_machine_missions",
		level = "content/levels/debug/vo/world",
		hazard_prop_settings = {
			explosion = 1
		},
		dialogue_settings = {
			short_story_start_delay = 500,
			story_start_delay = 600,
			npc_story_ticker_start_delay = 60,
			enable_short_conversations = false,
			enable_conversations = false,
			npc_story_ticker_enabled = false,
			on_start_dialogue_modifier = "radioactive"
		}
	},
	briefing = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/menus/briefing/world"
	},
	editor_simulation_without_mission = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		is_dev_mission = true,
		zone_id = "placeholder"
	},
	terror_events_test = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/terror_events_test/world",
		terror_event_templates = {
			"terror_events_test"
		}
	},
	mission_board = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/mission_board/world",
		pickup_settings = {}
	},
	network = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/network/missions/mission_1"
	},
	audio_tech_test = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		zone_id = "placeholder",
		mission_name = "loc_mission_name_placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/audio_tech_test/audio_tech_test",
		dialogue_settings = {
			on_start_dialogue_modifier = "audio_tech_test_modifier"
		}
	},
	test_single_level_base = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/debug/quality_assurance/test_levels/test_single_level_base/world"
	},
	test_multi_level_base = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/debug/quality_assurance/test_levels/test_multi_level_base/Mission_test_mission_01"
	},
	art_test_scene = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/art_test_scene/world"
	},
	lighting_materials_camera_setup = {
		mechanism_name = "adventure",
		game_mode_name = "default",
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		is_dev_mission = true,
		level = "content/levels/debug/lighting_materials_camera_setup/world"
	},
	perf_breeds_poxwalker = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_poxwalker/world",
		testify_flags = {}
	},
	perf_breeds_newly_infected = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_newly_infected/world",
		testify_flags = {}
	},
	perf_breeds_traitor_guard_assaulter = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_traitor_guard_assaulter/world",
		testify_flags = {}
	},
	perf_breeds_traitor_guard_melee = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_traitor_guard_melee/world",
		testify_flags = {}
	},
	perf_breeds_traitor_guard_rifleman = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_traitor_guard_rifleman/world",
		testify_flags = {}
	},
	perf_breeds_cultist_assaulter = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_cultist_assaulter/world",
		testify_flags = {}
	},
	perf_breeds_cultist_melee = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_cultist_melee/world",
		testify_flags = {}
	},
	perf_breeds_traitor_guard_executor = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_traitor_guard_executor/world",
		testify_flags = {}
	},
	perf_breeds_traitor_guard_shocktrooper = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_traitor_guard_shocktrooper/world",
		testify_flags = {}
	},
	perf_breeds_traitor_guard_gunner = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_traitor_guard_gunner/world",
		testify_flags = {}
	},
	perf_breeds_cultist_gunner = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_cultist_gunner/world",
		testify_flags = {}
	},
	perf_breeds_cultist_shocktrooper = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_cultist_shocktrooper/world",
		testify_flags = {}
	},
	perf_breeds_cultist_berzerker = {
		mechanism_name = "adventure",
		mission_name = "loc_mission_name_placeholder",
		game_mode_name = "default",
		objectives = "debug",
		is_dev_mission = true,
		zone_id = "placeholder",
		level = "content/levels/debug/breeds_performance/perf_breeds_cultist_berzerker/world",
		testify_flags = {}
	},
	cooling_arena = {
		mission_name = "loc_mission_name_placeholder",
		zone_id = "placeholder",
		game_mode_name = "default",
		mechanism_name = "adventure",
		is_dev_mission = true,
		level = "content/levels/debug/cooling_arena/world",
		pickup_settings = {},
		health_station = {
			charges_to_distribute = 4
		},
		hazard_prop_settings = {
			explosion = 1,
			fire = 1,
			none = 0
		},
		terror_event_templates = {
			"terror_events_cooling_arena"
		}
	},
	ship_port_arena = {
		mission_name = "loc_mission_name_arena_dust_ship_port",
		zone_id = "placeholder",
		game_mode_name = "default",
		mechanism_name = "adventure",
		is_dev_mission = true,
		level = "content/levels/debug/arenas/ship_port_arena/world",
		pickup_settings = {},
		health_station = {
			charges_to_distribute = 4
		},
		hazard_prop_settings = {
			explosion = 1,
			fire = 1,
			none = 0
		},
		terror_event_templates = {
			"terror_events_ship_port_arena"
		}
	}
}

return mission_templates
