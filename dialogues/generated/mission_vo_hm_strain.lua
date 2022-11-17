return function ()
	define_rule({
		name = "event_demolition_first_corruptor_destroyed_strain_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "event_demolition_first_corruptor_destroyed_strain_a",
		database = "mission_vo_hm_strain",
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
				"event_demolition_first_corruptor_destroyed_strain_a"
			},
			{
				"faction_memory",
				"event_demolition_first_corruptor_destroyed_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_demolition_first_corruptor_destroyed_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_giver_default"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "event_demolition_first_corruptor_destroyed_strain_b",
		response = "event_demolition_first_corruptor_destroyed_strain_b",
		database = "mission_vo_hm_strain",
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
					"event_demolition_first_corruptor_destroyed_strain_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
					"tech_priest"
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
		name = "info_get_out_strain",
		wwise_route = 1,
		response = "info_get_out_strain",
		database = "mission_vo_hm_strain",
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
					"mission_strain_job_done"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest",
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
				duration = 0.24
			}
		}
	})
	define_rule({
		name = "mission_strain_atmosphere_shield",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_strain_atmosphere_shield",
		database = "mission_vo_hm_strain",
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
				"mission_strain_atmosphere_shield"
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
				"mission_strain_atmosphere_shield",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_atmosphere_shield",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_strain_cross_hangar",
		response = "mission_strain_cross_hangar",
		database = "mission_vo_hm_strain",
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
				"mission_strain_cross_hangar"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_cross_hangar",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_cross_hangar",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_strain_crossroads",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_strain_crossroads",
		database = "mission_vo_hm_strain",
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
				"mission_strain_crossroads"
			},
			{
				"faction_memory",
				"mission_strain_crossroads",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_crossroads",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_giver_default"
		}
	})
	define_rule({
		name = "mission_strain_daemonic_overgrowth_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_strain_daemonic_overgrowth_a",
		database = "mission_vo_hm_strain",
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
				"mission_strain_daemonic_overgrowth_a"
			},
			{
				"faction_memory",
				"mission_strain_daemonic_overgrowth_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_daemonic_overgrowth_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_giver_default"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_strain_daemonic_overgrowth_b",
		response = "mission_strain_daemonic_overgrowth_b",
		database = "mission_vo_hm_strain",
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
					"mission_strain_daemonic_overgrowth_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_strain_demolish_door",
		response = "mission_strain_demolish_door",
		database = "mission_vo_hm_strain",
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
				"mission_strain_demolish_door"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_demolish_door",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_demolish_door",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_strain_elevator_found",
		response = "mission_strain_elevator_found",
		database = "mission_vo_hm_strain",
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
				"mission_strain_elevator_found"
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
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_elevator_found",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_elevator_found",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_strain_elevator_use",
		response = "mission_strain_elevator_use",
		database = "mission_vo_hm_strain",
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
				"mission_strain_elevator_use"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_elevator_use",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_elevator_use",
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
		name = "mission_strain_end_event_start",
		wwise_route = 1,
		response = "mission_strain_end_event_start",
		database = "mission_vo_hm_strain",
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
				"mission_strain_end_event_start"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_end_event_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_end_event_start",
				OP.ADD,
				1
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.24
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_strain_first_objective",
		response = "mission_strain_first_objective",
		database = "mission_vo_hm_strain",
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
					"mission_strain_start_banter_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		name = "mission_strain_first_objective_response",
		wwise_route = 0,
		response = "mission_strain_first_objective_response",
		database = "mission_vo_hm_strain",
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
					"mission_strain_first_objective"
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
		name = "mission_strain_follow_pipes",
		response = "mission_strain_follow_pipes",
		database = "mission_vo_hm_strain",
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
					"mission_strain_crossroads"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
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
		name = "mission_strain_inert_tanks",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_strain_inert_tanks",
		database = "mission_vo_hm_strain",
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
				"mission_strain_inert_tanks"
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
				30
			},
			{
				"faction_memory",
				"mission_strain_inert_tanks",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_inert_tanks",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		pre_wwise_event = "play_radio_static_start",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "mission_strain_job_done",
		wwise_route = 1,
		response = "mission_strain_job_done",
		database = "mission_vo_hm_strain",
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
				"mission_strain_job_done"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_job_done",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_job_done",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "self"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_strain_keep_following_pipes",
		response = "mission_strain_keep_following_pipes",
		database = "mission_vo_hm_strain",
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
				"mission_strain_keep_following_pipes"
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
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_keep_following_pipes",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_keep_following_pipes",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_strain_mid_elevator_conversation_one_a",
		response = "mission_strain_mid_elevator_conversation_one_a",
		database = "mission_vo_hm_strain",
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
				"mission_strain_mid_elevator_conversation_one_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_mid_elevator_conversation_one_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_mid_elevator_conversation_one_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_strain_mid_elevator_conversation_one_b",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_strain_mid_elevator_conversation_one_b",
		database = "mission_vo_hm_strain",
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
					"mission_strain_mid_elevator_conversation_one_a"
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
		name = "mission_strain_mid_elevator_conversation_three_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_strain_mid_elevator_conversation_three_a",
		database = "mission_vo_hm_strain",
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
				"mission_strain_mid_elevator_conversation_three_a"
			},
			{
				"faction_memory",
				"mission_strain_mid_elevator_conversation_three_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_mid_elevator_conversation_three_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_strain_mid_elevator_conversation_three_b",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_strain_mid_elevator_conversation_three_b",
		database = "mission_vo_hm_strain",
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
					"mission_strain_mid_elevator_conversation_three_a"
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
		name = "mission_strain_mid_elevator_conversation_two_a",
		response = "mission_strain_mid_elevator_conversation_two_a",
		database = "mission_vo_hm_strain",
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
				"mission_strain_mid_elevator_conversation_two_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_mid_elevator_conversation_two_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_mid_elevator_conversation_two_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_strain_mid_elevator_conversation_two_b",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_strain_mid_elevator_conversation_two_b",
		database = "mission_vo_hm_strain",
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
					"mission_strain_mid_elevator_conversation_two_a"
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
		name = "mission_strain_mid_event_complete",
		response = "mission_strain_mid_event_complete",
		database = "mission_vo_hm_strain",
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
				"mission_strain_mid_event_complete"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_mid_event_complete",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_mid_event_complete",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_strain_mid_event_conversation_one_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_strain_mid_event_conversation_one_a",
		database = "mission_vo_hm_strain",
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
				"mission_strain_mid_event_conversation_one_a"
			},
			{
				"faction_memory",
				"mission_strain_mid_event_conversation_one_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_mid_event_conversation_one_a",
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
		name = "mission_strain_mid_event_conversation_one_b",
		response = "mission_strain_mid_event_conversation_one_b",
		database = "mission_vo_hm_strain",
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
					"mission_strain_mid_event_conversation_one_a"
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
		name = "mission_strain_mid_event_conversation_one_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_strain_mid_event_conversation_one_c",
		database = "mission_vo_hm_strain",
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
					"mission_strain_mid_event_conversation_one_b"
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
		name = "mission_strain_mid_event_conversation_three_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_strain_mid_event_conversation_three_a",
		database = "mission_vo_hm_strain",
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
				"mission_strain_mid_event_conversation_three_a"
			},
			{
				"faction_memory",
				"mission_strain_mid_event_conversation_three_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_mid_event_conversation_three_a",
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
		name = "mission_strain_mid_event_conversation_three_b",
		response = "mission_strain_mid_event_conversation_three_b",
		database = "mission_vo_hm_strain",
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
					"mission_strain_mid_event_conversation_three_a"
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
		name = "mission_strain_mid_event_conversation_three_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_strain_mid_event_conversation_three_c",
		database = "mission_vo_hm_strain",
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
					"mission_strain_mid_event_conversation_three_b"
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
		name = "mission_strain_mid_event_conversation_two_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_strain_mid_event_conversation_two_a",
		database = "mission_vo_hm_strain",
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
				"mission_strain_mid_event_conversation_two_a"
			},
			{
				"faction_memory",
				"mission_strain_mid_event_conversation_two_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_mid_event_conversation_two_a",
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
		name = "mission_strain_mid_event_conversation_two_b",
		response = "mission_strain_mid_event_conversation_two_b",
		database = "mission_vo_hm_strain",
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
					"mission_strain_mid_event_conversation_two_a"
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
		name = "mission_strain_mid_event_conversation_two_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_strain_mid_event_conversation_two_c",
		database = "mission_vo_hm_strain",
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
					"mission_strain_mid_event_conversation_two_b"
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
		name = "mission_strain_mid_event_start",
		response = "mission_strain_mid_event_start",
		database = "mission_vo_hm_strain",
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
				"mission_strain_mid_event_start"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_mid_event_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_mid_event_start",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_strain_reach_flow_control",
		response = "mission_strain_reach_flow_control",
		database = "mission_vo_hm_strain",
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
				"mission_strain_reach_flow_control"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_reach_flow_control",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_reach_flow_control",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_strain_reach_hangar",
		response = "mission_strain_reach_hangar",
		database = "mission_vo_hm_strain",
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
				"mission_strain_reach_hangar"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_strain_reach_hangar",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_reach_hangar",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_strain_start_banter_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_strain_start_banter_a",
		database = "mission_vo_hm_strain",
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
				"hm_strain"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled"
			},
			{
				"faction_memory",
				"mission_strain_start_banter_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_strain_start_banter_a",
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
		name = "mission_strain_start_banter_b",
		response = "mission_strain_start_banter_b",
		database = "mission_vo_hm_strain",
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
					"mission_strain_start_banter_a"
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
		name = "mission_strain_start_banter_c",
		wwise_route = 0,
		response = "mission_strain_start_banter_c",
		database = "mission_vo_hm_strain",
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
					"mission_strain_start_banter_b"
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
end
