return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_propaganda_bypass_security",
		response = "mission_propaganda_bypass_security",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_bypass_security"
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
				"mission_propaganda_bypass_security",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_bypass_security",
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
		name = "mission_propaganda_complex_heart",
		wwise_route = 1,
		response = "mission_propaganda_complex_heart",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_complex_heart"
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
				"mission_propaganda_complex_heart",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_complex_heart",
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
		name = "mission_propaganda_consulate",
		response = "mission_propaganda_consulate",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_consulate"
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
				"mission_propaganda_consulate",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_consulate",
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
		name = "mission_propaganda_corruptor_event_align_bridges",
		wwise_route = 1,
		response = "mission_propaganda_corruptor_event_align_bridges",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_corruptor_event_align_bridges"
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
				"mission_propaganda_corruptor_event_align_bridges",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_corruptor_event_align_bridges",
				OP.ADD,
				1
			}
		},
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
		name = "mission_propaganda_corruptor_event_next_bridge",
		response = "mission_propaganda_corruptor_event_next_bridge",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_corruptor_event_next_bridge"
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
				"mission_propaganda_corruptor_event_next_bridge",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_corruptor_event_next_bridge",
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
		name = "mission_propaganda_corruptor_event_stop_signal_end",
		response = "mission_propaganda_corruptor_event_stop_signal_end",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_corruptor_event_stop_signal_end"
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
				"mission_propaganda_corruptor_event_stop_signal_end",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_corruptor_event_stop_signal_end",
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
		name = "mission_propaganda_corruptor_event_stop_signal_start",
		response = "mission_propaganda_corruptor_event_stop_signal_start",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_corruptor_event_stop_signal_start"
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
				"mission_propaganda_corruptor_event_stop_signal_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_corruptor_event_stop_signal_start",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_propaganda_cultist_town",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_propaganda_cultist_town",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_cultist_town"
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
				"mission_propaganda_cultist_town",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_cultist_town",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_propaganda_elevator_conversation_one_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_propaganda_elevator_conversation_one_a",
		database = "mission_vo_dm_propaganda",
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
				4
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_propaganda_elevator_conversation_one_a"
			},
			{
				"faction_memory",
				"mission_propaganda_elevator_conversation_one_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_elevator_conversation_one_a",
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
		name = "mission_propaganda_elevator_conversation_one_b",
		response = "mission_propaganda_elevator_conversation_one_b",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_elevator_conversation_one_a"
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
		name = "mission_propaganda_elevator_conversation_one_c",
		wwise_route = 0,
		response = "mission_propaganda_elevator_conversation_one_c",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_elevator_conversation_one_b"
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
		name = "mission_propaganda_elevator_conversation_three_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_propaganda_elevator_conversation_three_a",
		database = "mission_vo_dm_propaganda",
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
				4
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_propaganda_elevator_conversation_three_a"
			},
			{
				"faction_memory",
				"mission_propaganda_elevator_conversation_three_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_elevator_conversation_three_a",
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
		name = "mission_propaganda_elevator_conversation_three_b",
		response = "mission_propaganda_elevator_conversation_three_b",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_elevator_conversation_three_a"
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
		name = "mission_propaganda_elevator_conversation_three_c",
		wwise_route = 0,
		response = "mission_propaganda_elevator_conversation_three_c",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_elevator_conversation_three_b"
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
		name = "mission_propaganda_elevator_conversation_two_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_propaganda_elevator_conversation_two_a",
		database = "mission_vo_dm_propaganda",
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
				4
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_propaganda_elevator_conversation_two_a"
			},
			{
				"faction_memory",
				"mission_propaganda_elevator_conversation_two_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_elevator_conversation_two_a",
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
		name = "mission_propaganda_elevator_conversation_two_b",
		response = "mission_propaganda_elevator_conversation_two_b",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_elevator_conversation_two_a"
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
		name = "mission_propaganda_elevator_conversation_two_c",
		wwise_route = 0,
		response = "mission_propaganda_elevator_conversation_two_c",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_elevator_conversation_two_b"
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
		name = "mission_propaganda_first_objective",
		response = "mission_propaganda_first_objective",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_short_elevator_conversation_one_b",
					"mission_propaganda_short_elevator_conversation_two_b",
					"mission_propaganda_short_elevator_conversation_three_b"
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
		name = "mission_propaganda_first_objective_response",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_propaganda_first_objective_response",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_first_objective"
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
		name = "mission_propaganda_infested_elevator",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_propaganda_infested_elevator",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_infested_elevator"
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
				"mission_propaganda_infested_elevator",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_infested_elevator",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_propaganda_luggable_event_end",
		response = "mission_propaganda_luggable_event_end",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_luggable_event_end"
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
				"mission_propaganda_luggable_event_end",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_luggable_event_end",
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
		name = "mission_propaganda_luggable_event_start",
		response = "mission_propaganda_luggable_event_start",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_luggable_event_start"
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
				"mission_propaganda_luggable_event_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_luggable_event_start",
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
		name = "mission_propaganda_nearing_transmission_complex",
		response = "mission_propaganda_nearing_transmission_complex",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_nearing_transmission_complex"
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
				"mission_propaganda_nearing_transmission_complex",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_nearing_transmission_complex",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_propaganda_short_elevator_conversation_one_a",
		wwise_route = 0,
		response = "mission_propaganda_short_elevator_conversation_one_a",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_start_banter_c"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers"
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
		name = "mission_propaganda_short_elevator_conversation_one_b",
		response = "mission_propaganda_short_elevator_conversation_one_b",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_short_elevator_conversation_one_a"
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
			target = "mission_giver_default"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_propaganda_short_elevator_conversation_three_a",
		wwise_route = 0,
		response = "mission_propaganda_short_elevator_conversation_three_a",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_start_banter_c"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers"
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
		name = "mission_propaganda_short_elevator_conversation_three_b",
		response = "mission_propaganda_short_elevator_conversation_three_b",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_short_elevator_conversation_three_a"
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
			target = "mission_giver_default"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_propaganda_short_elevator_conversation_two_a",
		wwise_route = 0,
		response = "mission_propaganda_short_elevator_conversation_two_a",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_start_banter_c"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers"
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
		name = "mission_propaganda_short_elevator_conversation_two_b",
		response = "mission_propaganda_short_elevator_conversation_two_b",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_short_elevator_conversation_two_a"
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
			target = "mission_giver_default"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_propaganda_start_banter_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_propaganda_start_banter_a",
		database = "mission_vo_dm_propaganda",
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
				"dm_propaganda"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled"
			},
			{
				"faction_memory",
				"mission_propaganda_start_banter_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_start_banter_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"mission_propaganda_start_banter_a_user",
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
		name = "mission_propaganda_start_banter_b",
		response = "mission_propaganda_start_banter_b",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_start_banter_a"
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
		name = "mission_propaganda_start_banter_c",
		wwise_route = 0,
		response = "mission_propaganda_start_banter_c",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_start_banter_b"
				}
			},
			{
				"user_memory",
				"mission_propaganda_start_banter_a_user",
				OP.EQ,
				0
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
		name = "mission_propaganda_transmission_dish",
		response = "mission_propaganda_transmission_dish",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_transmission_dish"
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
				"mission_propaganda_transmission_dish",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_transmission_dish",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_propaganda_view_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_propaganda_view_a",
		database = "mission_vo_dm_propaganda",
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
				"mission_propaganda_view_a"
			},
			{
				"faction_memory",
				"mission_propaganda_view_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_propaganda_view_a",
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
		name = "mission_propaganda_view_b",
		response = "mission_propaganda_view_b",
		database = "mission_vo_dm_propaganda",
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
					"mission_propaganda_view_a"
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
end
