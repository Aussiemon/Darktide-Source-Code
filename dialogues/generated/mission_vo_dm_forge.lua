return function ()
	define_rule({
		name = "mission_forge_alive",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_forge_alive",
		database = "mission_vo_dm_forge",
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
				"mission_forge_alive"
			},
			{
				"faction_memory",
				"mission_forge_alive",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_alive",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_forge_assembly_line",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_assembly_line",
		database = "mission_vo_dm_forge",
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
				"mission_forge_assembly_line"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_forge_assembly_line",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_assembly_line",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_forge_call_elevator",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_call_elevator",
		database = "mission_vo_dm_forge",
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
				"mission_forge_call_elevator"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_forge_call_elevator",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_call_elevator",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_forge_elevator_conversation_one_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_forge_elevator_conversation_one_a",
		database = "mission_vo_dm_forge",
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
				"mission_forge_elevator_conversation_one_a"
			},
			{
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
			},
			{
				"faction_memory",
				"mission_forge_elevator_conversation_one_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_elevator_conversation_one_a",
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
		name = "mission_forge_elevator_conversation_one_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "mission_forge_elevator_conversation_one_b",
		database = "mission_vo_dm_forge",
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
					"mission_forge_elevator_conversation_one_a"
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
		name = "mission_forge_elevator_conversation_one_c",
		wwise_route = 0,
		response = "mission_forge_elevator_conversation_one_c",
		database = "mission_vo_dm_forge",
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
					"mission_forge_elevator_conversation_one_b"
				}
			},
			{
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
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
		name = "mission_forge_elevator_conversation_three_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_forge_elevator_conversation_three_a",
		database = "mission_vo_dm_forge",
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
				"mission_forge_elevator_conversation_three_a"
			},
			{
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
			},
			{
				"faction_memory",
				"mission_forge_elevator_conversation_three_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_elevator_conversation_three_a",
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
		name = "mission_forge_elevator_conversation_three_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "mission_forge_elevator_conversation_three_b",
		database = "mission_vo_dm_forge",
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
					"mission_forge_elevator_conversation_three_a"
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
		name = "mission_forge_elevator_conversation_three_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_forge_elevator_conversation_three_c",
		database = "mission_vo_dm_forge",
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
					"mission_forge_elevator_conversation_three_b"
				}
			},
			{
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
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
		name = "mission_forge_elevator_conversation_two_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_forge_elevator_conversation_two_a",
		database = "mission_vo_dm_forge",
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
				"mission_forge_elevator_conversation_two_a"
			},
			{
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
			},
			{
				"faction_memory",
				"mission_forge_elevator_conversation_two_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_elevator_conversation_two_a",
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
		name = "mission_forge_elevator_conversation_two_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "mission_forge_elevator_conversation_two_b",
		database = "mission_vo_dm_forge",
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
					"mission_forge_elevator_conversation_two_a"
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
		name = "mission_forge_elevator_conversation_two_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_forge_elevator_conversation_two_c",
		database = "mission_vo_dm_forge",
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
					"mission_forge_elevator_conversation_two_b"
				}
			},
			{
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
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
		name = "mission_forge_find_smelter",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_forge_find_smelter",
		database = "mission_vo_dm_forge",
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
				"mission_forge_find_smelter"
			},
			{
				"faction_memory",
				"mission_forge_find_smelter",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_find_smelter",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_forge_first_objective",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_first_objective",
		database = "mission_vo_dm_forge",
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
				"mission_forge_first_objective"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_forge_first_objective",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_first_objective",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_forge_first_objective_response",
		wwise_route = 0,
		response = "mission_forge_first_objective_response",
		database = "mission_vo_dm_forge",
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
					"mission_forge_first_objective"
				}
			},
			{
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "mission_forge_hellhole",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_forge_hellhole",
		database = "mission_vo_dm_forge",
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
					"mission_forge_job_done"
				}
			},
			{
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
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
		name = "mission_forge_job_done",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_job_done",
		database = "mission_vo_dm_forge",
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
				"mission_forge_job_done"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_forge_job_done",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_job_done",
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
		name = "mission_forge_labour_oversight",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_labour_oversight",
		database = "mission_vo_dm_forge",
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
				"mission_forge_labour_oversight"
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
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_forge_labour_oversight",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_labour_oversight",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_forge_lifeless",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_forge_lifeless",
		database = "mission_vo_dm_forge",
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
				"mission_forge_lifeless"
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
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
			},
			{
				"faction_memory",
				"mission_forge_lifeless",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_lifeless",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_forge_main_entrance",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_forge_main_entrance",
		database = "mission_vo_dm_forge",
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
				"mission_forge_main_entrance"
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
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
			},
			{
				"faction_memory",
				"mission_forge_main_entrance",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_main_entrance",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_forge_main_entrance_response",
		wwise_route = 0,
		response = "mission_forge_main_entrance_response",
		database = "mission_vo_dm_forge",
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
					"mission_forge_main_entrance"
				}
			},
			{
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_forge_propaganda",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_forge_propaganda",
		database = "mission_vo_dm_forge",
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
				"mission_forge_propaganda"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				0
			},
			{
				"query_context",
				"distance",
				OP.LT,
				17
			},
			{
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
			},
			{
				"faction_memory",
				"mission_forge_propaganda",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_propaganda",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_forge_purge_infestation",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_purge_infestation",
		database = "mission_vo_dm_forge",
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
				"mission_forge_purge_infestation"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_forge_purge_infestation",
				OP.LT,
				2
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_purge_infestation",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_forge_smelter",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_smelter",
		database = "mission_vo_dm_forge",
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
				"mission_forge_smelter"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"sergeant",
					"explicator"
				}
			},
			{
				"faction_memory",
				"mission_forge_smelter",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_smelter",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_forge_smelter_working",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_smelter_working",
		database = "mission_vo_dm_forge",
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
				"mission_forge_smelter_working"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_forge_smelter_working",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_smelter_working",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_forge_stand_ground",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_forge_stand_ground",
		database = "mission_vo_dm_forge",
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
				"mission_forge_stand_ground"
			},
			{
				"faction_memory",
				"mission_forge_stand_ground",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_stand_ground",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_forge_start_banter_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_forge_start_banter_a",
		database = "mission_vo_dm_forge",
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
				"dm_forge"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"default"
			},
			{
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
			},
			{
				"faction_memory",
				"mission_forge_start_banter_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_start_banter_a",
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
		name = "mission_forge_start_banter_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_start_banter_b",
		database = "mission_vo_dm_forge",
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
					"mission_forge_start_banter_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_forge_strategic_asset",
		wwise_route = 0,
		response = "mission_forge_strategic_asset",
		database = "mission_vo_dm_forge",
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
					"mission_forge_start_banter_b"
				}
			},
			{
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_forge_superstructure",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_superstructure",
		database = "mission_vo_dm_forge",
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
				"mission_forge_superstructure"
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
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_forge_superstructure",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_superstructure",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_forge_tutorial_corruptor",
		wwise_route = 0,
		response = "mission_forge_tutorial_corruptor",
		database = "mission_vo_dm_forge",
		category = "player_prio_0",
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
				"mission_forge_tutorial_corruptor"
			},
			{
				"faction_memory",
				"mission_forge_tutorial_corruptor",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_tutorial_corruptor",
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
		post_wwise_event = "play_radio_static_end",
		name = "mission_forge_tutorial_corruptor_done",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_tutorial_corruptor_done",
		database = "mission_vo_dm_forge",
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
				"mission_forge_tutorial_corruptor_done"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2.5
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_forge_tutorial_corruptor_response",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_tutorial_corruptor_response",
		database = "mission_vo_dm_forge",
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
					"mission_forge_tutorial_corruptor"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
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
		name = "mission_forge_use_elevator",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_use_elevator",
		database = "mission_vo_dm_forge",
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
				"mission_forge_use_elevator"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_forge_use_elevator",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_forge_use_elevator",
				OP.ADD,
				1
			}
		}
	})
end
