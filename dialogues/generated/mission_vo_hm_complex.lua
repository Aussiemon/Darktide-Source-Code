return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_complex_elevator",
		response = "mission_complex_elevator",
		database = "mission_vo_hm_complex",
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
				"mission_complex_elevator"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"explicator"
				}
			},
			{
				"faction_memory",
				"mission_complex_elevator",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_elevator",
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
		name = "mission_complex_elevator_access",
		response = "mission_complex_elevator_access",
		database = "mission_vo_hm_complex",
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
				"mission_complex_elevator_access"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_complex_elevator_access",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_elevator_access",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"info_hacking_mission_almost_done",
				OP.SUB,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_complex_elevator_coming",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_complex_elevator_coming",
		database = "mission_vo_hm_complex",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_complex_elevator_coming"
			},
			{
				"faction_memory",
				"mission_complex_elevator_coming",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_elevator_coming",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_giver_default"
		}
	})
	define_rule({
		name = "mission_complex_elevator_conversation_1_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_complex_elevator_conversation_1_a",
		database = "mission_vo_hm_complex",
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
				"mission_complex_elevator_conversation_1_a"
			},
			{
				"faction_memory",
				"mission_complex_elevator_conversation_1_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_elevator_conversation_1_a",
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
		name = "mission_complex_elevator_conversation_1_b",
		response = "mission_complex_elevator_conversation_1_b",
		database = "mission_vo_hm_complex",
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
					"mission_complex_elevator_conversation_1_a"
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
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_complex_elevator_conversation_1_c",
		wwise_route = 0,
		response = "mission_complex_elevator_conversation_1_c",
		database = "mission_vo_hm_complex",
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
					"mission_complex_elevator_conversation_1_b"
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
		name = "mission_complex_elevator_conversation_2_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_complex_elevator_conversation_2_a",
		database = "mission_vo_hm_complex",
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
				"mission_complex_elevator_conversation_2_a"
			},
			{
				"faction_memory",
				"mission_complex_elevator_conversation_2_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_elevator_conversation_2_a",
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
		name = "mission_complex_elevator_conversation_2_b",
		response = "mission_complex_elevator_conversation_2_b",
		database = "mission_vo_hm_complex",
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
					"mission_complex_elevator_conversation_2_a"
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
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_complex_elevator_conversation_2_c",
		wwise_route = 0,
		response = "mission_complex_elevator_conversation_2_c",
		database = "mission_vo_hm_complex",
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
					"mission_complex_elevator_conversation_2_b"
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
		name = "mission_complex_elevator_conversation_3_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_complex_elevator_conversation_3_a",
		database = "mission_vo_hm_complex",
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
				"mission_complex_elevator_conversation_3_a"
			},
			{
				"faction_memory",
				"mission_complex_elevator_conversation_3_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_elevator_conversation_3_a",
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
		name = "mission_complex_elevator_conversation_3_b",
		response = "mission_complex_elevator_conversation_3_b",
		database = "mission_vo_hm_complex",
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
					"mission_complex_elevator_conversation_3_a"
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
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_complex_elevator_conversation_3_c",
		wwise_route = 0,
		response = "mission_complex_elevator_conversation_3_c",
		database = "mission_vo_hm_complex",
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
					"mission_complex_elevator_conversation_3_b"
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
		name = "mission_complex_elevator_here",
		response = "mission_complex_elevator_here",
		database = "mission_vo_hm_complex",
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
				"mission_complex_elevator_here"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"explicator"
				}
			},
			{
				"faction_memory",
				"mission_complex_elevator_here",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_elevator_here",
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
		name = "mission_complex_first_objective",
		response = "mission_complex_first_objective",
		database = "mission_vo_hm_complex",
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
					"mission_complex_start_banter_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
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
		name = "mission_complex_first_objective_response",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_complex_first_objective_response",
		database = "mission_vo_hm_complex",
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
					"mission_complex_first_objective"
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
		name = "mission_complex_old_shrine_street",
		response = "mission_complex_old_shrine_street",
		database = "mission_vo_hm_complex",
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
				"mission_complex_old_shrine_street"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"explicator"
				}
			},
			{
				"faction_memory",
				"mission_complex_old_shrine_street",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_old_shrine_street",
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
		name = "mission_complex_progress_archivum",
		response = "mission_complex_progress_archivum",
		database = "mission_vo_hm_complex",
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
				"mission_complex_progress_archivum"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"explicator"
				}
			},
			{
				"faction_memory",
				"mission_complex_progress_archivum",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_progress_archivum",
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
		name = "mission_complex_side_entrance",
		response = "mission_complex_side_entrance",
		database = "mission_vo_hm_complex",
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
				"mission_complex_side_entrance"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"explicator"
				}
			},
			{
				"faction_memory",
				"mission_complex_side_entrance",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_side_entrance",
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
		name = "mission_complex_skyfire_cutout",
		response = "mission_complex_skyfire_cutout",
		database = "mission_vo_hm_complex",
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
				"mission_complex_skyfire_cutout"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"explicator"
				}
			},
			{
				"faction_memory",
				"mission_complex_skyfire_cutout",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_skyfire_cutout",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_complex_start_banter_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_complex_start_banter_a",
		database = "mission_vo_hm_complex",
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
				"hm_complex"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled"
			},
			{
				"faction_memory",
				"mission_complex_start_banter_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_start_banter_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"mission_complex_start_banter_a_user",
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
		name = "mission_complex_start_banter_b",
		response = "mission_complex_start_banter_b",
		database = "mission_vo_hm_complex",
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
					"mission_complex_start_banter_a"
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
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_complex_start_banter_c",
		wwise_route = 0,
		response = "mission_complex_start_banter_c",
		database = "mission_vo_hm_complex",
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
					"mission_complex_start_banter_b"
				}
			},
			{
				"user_memory",
				"mission_complex_start_banter_a_user",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"mission_complex_start_banter_c_user",
				OP.ADD,
				1
			}
		},
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
		name = "mission_complex_to_the_roof",
		response = "mission_complex_to_the_roof",
		database = "mission_vo_hm_complex",
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
				"mission_complex_to_the_roof"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"explicator"
				}
			},
			{
				"faction_memory",
				"mission_complex_to_the_roof",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_to_the_roof",
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
		name = "mission_complex_transmission_begun",
		response = "mission_complex_transmission_begun",
		database = "mission_vo_hm_complex",
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
				"mission_complex_transmission_begun"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"explicator"
				}
			},
			{
				"faction_memory",
				"mission_complex_transmission_begun",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_transmission_begun",
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
		name = "mission_complex_transmitter",
		response = "mission_complex_transmitter",
		database = "mission_vo_hm_complex",
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
				"mission_complex_transmitter"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"explicator"
				}
			},
			{
				"faction_memory",
				"mission_complex_transmitter",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_transmitter",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_complex_way_in",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_complex_way_in",
		database = "mission_vo_hm_complex",
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
				"mission_complex_way_in"
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
				31
			},
			{
				"faction_memory",
				"mission_complex_way_in",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_complex_way_in",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
end
