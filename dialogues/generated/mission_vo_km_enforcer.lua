return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_enforcer_activate_stair",
		response = "mission_enforcer_activate_stair",
		database = "mission_vo_km_enforcer",
		wwise_route = 1,
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_enforcer_activate_stair"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_enforcer_activate_stair",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_activate_stair",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_enforcer_courtroom",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_enforcer_courtroom",
		database = "mission_vo_km_enforcer",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"mission_enforcer_courtroom"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				17
			},
			{
				"faction_memory",
				"mission_enforcer_courtroom",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_courtroom",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_enforcer_courtroom_waypoint",
		response = "mission_enforcer_courtroom_waypoint",
		database = "mission_vo_km_enforcer",
		wwise_route = 1,
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_enforcer_courtroom_waypoint"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_enforcer_courtroom_waypoint",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_courtroom_waypoint",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_enforcer_end_event_conversation_one_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_enforcer_end_event_conversation_one_a",
		database = "mission_vo_km_enforcer",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"environmental_story"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				1
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				50
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_enforcer_end_event_conversation_one_a"
			},
			{
				"faction_memory",
				"mission_enforcer_end_event_conversation_one_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_end_event_conversation_one_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		name = "mission_enforcer_end_event_conversation_one_c",
		wwise_route = 0,
		response = "mission_enforcer_end_event_conversation_one_c",
		database = "mission_vo_km_enforcer",
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_end_event_conversation_one_b"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_enforcer_end_event_conversation_three_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_enforcer_end_event_conversation_three_a",
		database = "mission_vo_km_enforcer",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"environmental_story"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				1
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				50
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_enforcer_end_event_conversation_three_a"
			},
			{
				"faction_memory",
				"mission_enforcer_end_event_conversation_three_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_end_event_conversation_three_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_enforcer_end_event_conversation_three_b",
		response = "mission_enforcer_end_event_conversation_three_b",
		database = "mission_vo_km_enforcer",
		wwise_route = 1,
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_end_event_conversation_three_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_enforcer_end_event_conversation_three_c",
		wwise_route = 0,
		response = "mission_enforcer_end_event_conversation_three_c",
		database = "mission_vo_km_enforcer",
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_end_event_conversation_three_b"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_enforcer_end_event_conversation_two_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_enforcer_end_event_conversation_two_a",
		database = "mission_vo_km_enforcer",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"environmental_story"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				1
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				50
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_enforcer_end_event_conversation_two_a"
			},
			{
				"faction_memory",
				"mission_enforcer_end_event_conversation_two_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_end_event_conversation_two_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_enforcer_end_event_conversation_two_b",
		response = "mission_enforcer_end_event_conversation_two_b",
		database = "mission_vo_km_enforcer",
		wwise_route = 1,
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_end_event_conversation_two_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_enforcer_end_event_conversation_two_c",
		wwise_route = 0,
		response = "mission_enforcer_end_event_conversation_two_c",
		database = "mission_vo_km_enforcer",
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_end_event_conversation_two_b"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_enforcer_enforcer_station",
		response = "mission_enforcer_enforcer_station",
		database = "mission_vo_km_enforcer",
		wwise_route = 1,
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"mission_enforcer_enforcer_station"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				17
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_enforcer_enforcer_station",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_enforcer_station",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_enforcer_event_survive",
		response = "mission_enforcer_event_survive",
		database = "mission_vo_km_enforcer",
		wwise_route = 1,
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_enforcer_event_survive"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_enforcer_event_survive",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_activate_stair",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_enforcer_first_objective",
		response = "mission_enforcer_first_objective",
		database = "mission_vo_km_enforcer",
		wwise_route = 1,
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_start_banter_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_enforcer_first_objective_response",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_enforcer_first_objective_response",
		database = "mission_vo_km_enforcer",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_first_objective"
				}
			}
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_enforcer_hab_support",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_enforcer_hab_support",
		database = "mission_vo_km_enforcer",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"mission_enforcer_hab_support"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				17
			},
			{
				"faction_memory",
				"mission_enforcer_hab_support",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_hab_support",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_enforcer_infrastructure",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_enforcer_infrastructure",
		database = "mission_vo_km_enforcer",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_hab_support"
				}
			}
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_enforcer_maintenance_area",
		response = "mission_enforcer_maintenance_area",
		database = "mission_vo_km_enforcer",
		wwise_route = 1,
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_enforcer_maintenance_area"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_enforcer_maintenance_area",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_maintenance_area",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_enforcer_reach_cells",
		response = "mission_enforcer_reach_cells",
		database = "mission_vo_km_enforcer",
		wwise_route = 1,
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_enforcer_reach_cells"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_enforcer_reach_cells",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_reach_cells",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_enforcer_stairs_arrived",
		response = "mission_enforcer_stairs_arrived",
		database = "mission_vo_km_enforcer",
		wwise_route = 1,
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_enforcer_stairs_arrived"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_enforcer_stairs_arrived",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_stairs_arrived",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_enforcer_start_banter_a",
		wwise_route = 0,
		response = "mission_enforcer_start_banter_a",
		database = "mission_vo_km_enforcer",
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"start_banter"
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"km_enforcer"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled"
			},
			{
				"faction_memory",
				"mission_enforcer_start_banter_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_start_banter_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"mission_enforcer_start_banter_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_enforcer_start_banter_b",
		response = "mission_enforcer_start_banter_b",
		database = "mission_vo_km_enforcer",
		wwise_route = 1,
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_start_banter_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_enforcer_start_banter_c",
		wwise_route = 0,
		response = "mission_enforcer_start_banter_c",
		database = "mission_vo_km_enforcer",
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_start_banter_b"
				}
			},
			{
				"user_memory",
				"mission_enforcer_start_banter_a",
				OP.EQ,
				0
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_enforcer_through_hab",
		response = "mission_enforcer_through_hab",
		database = "mission_vo_km_enforcer",
		wwise_route = 1,
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_enforcer_through_hab"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_enforcer_through_hab",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_through_hab",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "mission_enforcer_traders_row",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_enforcer_traders_row",
		database = "mission_vo_km_enforcer",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"mission_enforcer_traders_row"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				17
			},
			{
				"faction_memory",
				"mission_enforcer_traders_row",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_traders_row",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_enforcer_wonky_hab",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_enforcer_wonky_hab",
		database = "mission_vo_km_enforcer",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			}
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
end
