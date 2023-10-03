return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_stockpile_bridge",
		response = "mission_stockpile_bridge",
		database = "mission_vo_dm_stockpile",
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
				"mission_stockpile_bridge"
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
				"mission_stockpile_bridge",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_bridge",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_stockpile_cartel_habs",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_stockpile_cartel_habs",
		database = "mission_vo_dm_stockpile",
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
				"mission_stockpile_cartel_habs"
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
				"mission_stockpile_cartel_habs",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_cartel_habs",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_stockpile_cartel_hq",
		response = "mission_stockpile_cartel_hq",
		database = "mission_vo_dm_stockpile",
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
				"mission_stockpile_cartel_hq"
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
				"mission_stockpile_cartel_hq",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_cartel_hq",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		pre_wwise_event = "play_radio_static_start",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "mission_stockpile_clean_water",
		wwise_route = 1,
		response = "mission_stockpile_clean_water",
		database = "mission_vo_dm_stockpile",
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
				"mission_stockpile_clean_water"
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
				"mission_stockpile_clean_water",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_clean_water",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "self"
		}
	})
	define_rule({
		name = "mission_stockpile_elevator_conversation_one_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_stockpile_elevator_conversation_one_a",
		database = "mission_vo_dm_stockpile",
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
				0
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
				"mission_stockpile_elevator_conversation_one_a"
			},
			{
				"faction_memory",
				"mission_stockpile_elevator_conversation_one_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_elevator_conversation_one_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_stockpile_elevator_conversation_one_b",
		response = "mission_stockpile_elevator_conversation_one_b",
		database = "mission_vo_dm_stockpile",
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
					"mission_stockpile_elevator_conversation_one_a"
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
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "mission_stockpile_elevator_conversation_one_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_stockpile_elevator_conversation_one_c",
		database = "mission_vo_dm_stockpile",
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
					"mission_stockpile_elevator_conversation_one_b"
				}
			}
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "mission_stockpile_elevator_conversation_three_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_stockpile_elevator_conversation_three_a",
		database = "mission_vo_dm_stockpile",
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
				0
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
				"mission_stockpile_elevator_conversation_three_a"
			},
			{
				"faction_memory",
				"mission_stockpile_elevator_conversation_three_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_elevator_conversation_three_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_stockpile_elevator_conversation_three_b",
		response = "mission_stockpile_elevator_conversation_three_b",
		database = "mission_vo_dm_stockpile",
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
					"mission_stockpile_elevator_conversation_three_a"
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
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "mission_stockpile_elevator_conversation_three_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_stockpile_elevator_conversation_three_c",
		database = "mission_vo_dm_stockpile",
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
					"mission_stockpile_elevator_conversation_three_b"
				}
			}
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "mission_stockpile_elevator_conversation_two_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_stockpile_elevator_conversation_two_a",
		database = "mission_vo_dm_stockpile",
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
				0
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
				"mission_stockpile_elevator_conversation_two_a"
			},
			{
				"faction_memory",
				"mission_stockpile_elevator_conversation_two_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_elevator_conversation_two_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_stockpile_elevator_conversation_two_b",
		response = "mission_stockpile_elevator_conversation_two_b",
		database = "mission_vo_dm_stockpile",
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
					"mission_stockpile_elevator_conversation_two_a"
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
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "mission_stockpile_elevator_conversation_two_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_stockpile_elevator_conversation_two_c",
		database = "mission_vo_dm_stockpile",
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
					"mission_stockpile_elevator_conversation_two_b"
				}
			}
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_stockpile_end_event_start",
		response = "mission_stockpile_end_event_start",
		database = "mission_vo_dm_stockpile",
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
				"mission_stockpile_end_event_start"
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
				"mission_stockpile_end_event_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_end_event_start",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_stockpile_first_objective",
		response = "mission_stockpile_first_objective",
		database = "mission_vo_dm_stockpile",
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
					"mission_stockpile_start_banter_c"
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
		name = "mission_stockpile_first_objective_response",
		wwise_route = 0,
		response = "mission_stockpile_first_objective_response",
		database = "mission_vo_dm_stockpile",
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
					"mission_stockpile_first_objective"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
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
		name = "mission_stockpile_flush",
		response = "mission_stockpile_flush",
		database = "mission_vo_dm_stockpile",
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
				"mission_stockpile_flush"
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
				"mission_stockpile_flush",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_flush",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_stockpile_holo_statue",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_stockpile_holo_statue",
		database = "mission_vo_dm_stockpile",
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
				"mission_stockpile_holo_statue"
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
				51
			},
			{
				"faction_memory",
				"mission_stockpile_holo_statue",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_holo_statue",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "mission_stockpile_info_get_out_simple",
		wwise_route = 1,
		response = "mission_stockpile_info_get_out_simple",
		database = "mission_vo_dm_stockpile",
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
					"mission_stockpile_clean_water"
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
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_stockpile_main_access",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_stockpile_main_access",
		database = "mission_vo_dm_stockpile",
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
				"mission_stockpile_main_access"
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
				25
			},
			{
				"faction_memory",
				"mission_stockpile_main_access",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_main_access",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_stockpile_ruined_hab",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_stockpile_ruined_hab",
		database = "mission_vo_dm_stockpile",
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
				"mission_stockpile_ruined_hab"
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
				25
			},
			{
				"faction_memory",
				"mission_stockpile_ruined_hab",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_ruined_hab",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_stockpile_start_banter_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_stockpile_start_banter_a",
		database = "mission_vo_dm_stockpile",
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
				"dm_stockpile"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled"
			},
			{
				"faction_memory",
				"mission_stockpile_start_banter_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_start_banter_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"mission_stockpile_start_banter_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_stockpile_start_banter_b",
		response = "mission_stockpile_start_banter_b",
		database = "mission_vo_dm_stockpile",
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
					"mission_stockpile_start_banter_a"
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
		name = "mission_stockpile_start_banter_c",
		wwise_route = 0,
		response = "mission_stockpile_start_banter_c",
		database = "mission_vo_dm_stockpile",
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
					"mission_stockpile_start_banter_b"
				}
			},
			{
				"user_memory",
				"mission_stockpile_start_banter_a_user",
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
		name = "mission_stockpile_survive_event_end",
		response = "mission_stockpile_survive_event_end",
		database = "mission_vo_dm_stockpile",
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
				"mission_stockpile_survive_event_end"
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
				"mission_stockpile_survive_event_end",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_survive_event_end",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_stockpile_survive_event_start",
		response = "mission_stockpile_survive_event_start",
		database = "mission_vo_dm_stockpile",
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
				"mission_stockpile_survive_event_start"
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
				"mission_stockpile_survive_event_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_survive_event_start",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		pre_wwise_event = "play_radio_static_start",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "mission_stockpile_tarp_town",
		wwise_route = 1,
		response = "mission_stockpile_tarp_town",
		database = "mission_vo_dm_stockpile",
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
					"mission_stockpile_start_banter_c_disabled"
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
			target = "self"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_stockpile_through_to_silo",
		response = "mission_stockpile_through_to_silo",
		database = "mission_vo_dm_stockpile",
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
				"mission_stockpile_through_to_silo"
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
				"mission_stockpile_through_to_silo",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_through_to_silo",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
end
