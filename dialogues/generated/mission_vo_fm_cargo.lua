return function ()
	define_rule({
		name = "mission_cargo_armor_plating",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cargo_armor_plating",
		database = "mission_vo_fm_cargo",
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
				"mission_cargo_armor_plating"
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
				"mission_cargo_armor_plating",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_armor_plating",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_cargo_consignment_yard",
		response = "mission_cargo_consignment_yard",
		database = "mission_vo_fm_cargo",
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
				"mission_cargo_consignment_yard"
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
				"",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"",
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
		name = "mission_cargo_coolant_control",
		response = "mission_cargo_coolant_control",
		database = "mission_vo_fm_cargo",
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
				"mission_cargo_coolant_control"
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
				"mission_cargo_coolant_control",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_coolant_control",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_cargo_end_event_conversation_one_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cargo_end_event_conversation_one_a",
		database = "mission_vo_fm_cargo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"environmental_story"
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_cargo_end_event_conversation_one_a"
			},
			{
				"faction_memory",
				"mission_cargo_end_event_conversation",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_end_event_conversation",
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
		name = "mission_cargo_end_event_conversation_one_b",
		response = "mission_cargo_end_event_conversation_one_b",
		database = "mission_vo_fm_cargo",
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
					"mission_cargo_end_event_conversation_one_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
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
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "mission_cargo_end_event_conversation_one_c",
		wwise_route = 0,
		response = "mission_cargo_end_event_conversation_one_c",
		database = "mission_vo_fm_cargo",
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
					"mission_cargo_end_event_conversation_one_b"
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
		name = "mission_cargo_end_event_conversation_three_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cargo_end_event_conversation_three_a",
		database = "mission_vo_fm_cargo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"environmental_story"
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_cargo_end_event_conversation_three_a"
			},
			{
				"faction_memory",
				"mission_cargo_end_event_conversation",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_end_event_conversation",
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
		name = "mission_cargo_end_event_conversation_three_b",
		response = "mission_cargo_end_event_conversation_three_b",
		database = "mission_vo_fm_cargo",
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
					"mission_cargo_end_event_conversation_three_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
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
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "mission_cargo_end_event_conversation_three_c",
		wwise_route = 0,
		response = "mission_cargo_end_event_conversation_three_c",
		database = "mission_vo_fm_cargo",
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
					"mission_cargo_end_event_conversation_three_b"
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
		name = "mission_cargo_end_event_conversation_two_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cargo_end_event_conversation_two_a",
		database = "mission_vo_fm_cargo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"environmental_story"
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_cargo_end_event_conversation_two_a"
			},
			{
				"faction_memory",
				"mission_cargo_end_event_conversation",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_end_event_conversation",
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
		name = "mission_cargo_end_event_conversation_two_b",
		response = "mission_cargo_end_event_conversation_two_b",
		database = "mission_vo_fm_cargo",
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
					"mission_cargo_end_event_conversation_two_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
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
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "mission_cargo_end_event_conversation_two_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cargo_end_event_conversation_two_c",
		database = "mission_vo_fm_cargo",
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
					"mission_cargo_end_event_conversation_two_b"
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
		name = "mission_cargo_first_objective",
		response = "mission_cargo_first_objective",
		database = "mission_vo_fm_cargo",
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
					"mission_cargo_start_banter_d"
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
		name = "mission_cargo_first_objective_response",
		wwise_route = 0,
		response = "mission_cargo_first_objective_response",
		database = "mission_vo_fm_cargo",
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
					"mission_cargo_first_objective"
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
		name = "mission_cargo_hab_feed_lines",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cargo_hab_feed_lines",
		database = "mission_vo_fm_cargo",
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
				"mission_cargo_hab_feed_lines"
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
				"mission_cargo_hab_feed_lines",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_hab_feed_lines",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_cargo_labyrinth",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_cargo_labyrinth",
		database = "mission_vo_fm_cargo",
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
				"mission_cargo_labyrinth"
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
				"mission_cargo_labyrinth",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_labyrinth",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_cargo_mid_event_end",
		response = "mission_cargo_mid_event_end",
		database = "mission_vo_fm_cargo",
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
				"mission_cargo_mid_event_end"
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
				"mission_cargo_mid_event_end",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_mid_event_end",
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
		name = "mission_cargo_mid_event_start",
		response = "mission_cargo_mid_event_start",
		database = "mission_vo_fm_cargo",
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
				"mission_cargo_mid_event_start"
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
				"mission_cargo_mid_event_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_mid_event_start",
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
		name = "mission_cargo_production_line",
		response = "mission_cargo_production_line",
		database = "mission_vo_fm_cargo",
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
				"mission_cargo_production_line"
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
				"mission_cargo_production_line",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_production_line",
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
		name = "mission_cargo_reinforcements",
		response = "mission_cargo_reinforcements",
		database = "mission_vo_fm_cargo",
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
				"mission_cargo_reinforcements"
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
				"mission_cargo_reinforcements",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_reinforcements",
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
		name = "mission_cargo_reinforcements_response",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_cargo_reinforcements_response",
		database = "mission_vo_fm_cargo",
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
					"mission_cargo_reinforcements"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot"
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
		name = "mission_cargo_something_big",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_cargo_something_big",
		database = "mission_vo_fm_cargo",
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
				"mission_cargo_something_big"
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
				"mission_cargo_something_big",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_something_big",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_cargo_start_banter_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cargo_start_banter_a",
		database = "mission_vo_fm_cargo",
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
				"fm_cargo"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled"
			},
			{
				"faction_memory",
				"mission_cargo_start_banter_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_start_banter_a",
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
		name = "mission_cargo_start_banter_b",
		response = "mission_cargo_start_banter_b",
		database = "mission_vo_fm_cargo",
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
					"mission_cargo_start_banter_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
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
		name = "mission_cargo_start_banter_c",
		wwise_route = 0,
		response = "mission_cargo_start_banter_c",
		database = "mission_vo_fm_cargo",
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
					"mission_cargo_start_banter_b"
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
		name = "mission_cargo_start_banter_d",
		wwise_route = 0,
		response = "mission_cargo_start_banter_d",
		database = "mission_vo_fm_cargo",
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
					"mission_cargo_start_banter_c"
				}
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
		name = "mission_cargo_worker_cloister",
		response = "mission_cargo_worker_cloister",
		database = "mission_vo_fm_cargo",
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
				"mission_cargo_worker_cloister"
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
				"mission_cargo_worker_cloister",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cargo_worker_cloister",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
end
