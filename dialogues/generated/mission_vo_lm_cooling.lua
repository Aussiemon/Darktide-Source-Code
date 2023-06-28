return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "cmd_mission_cooling_hacking_event_end",
		response = "cmd_mission_cooling_hacking_event_end",
		database = "mission_vo_lm_cooling",
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
				"cmd_mission_cooling_hacking_event_end"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest",
					"explicator"
				}
			},
			{
				"user_memory",
				"cmd_mission_cooling_hacking_event_end",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_mission_cooling_hacking_event_end",
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
		name = "cmd_mission_cooling_hacking_event_start",
		response = "cmd_mission_cooling_hacking_event_start",
		database = "mission_vo_lm_cooling",
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
				"cmd_mission_cooling_hacking_event_start"
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
				"cmd_mission_cooling_hacking_event_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"cmd_mission_cooling_hacking_event_start",
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
		name = "cmd_mission_cooling_luggable_event_start",
		response = "cmd_mission_cooling_luggable_event_start",
		database = "mission_vo_lm_cooling",
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
				"cmd_mission_cooling_luggable_event_start"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest"
				}
			},
			{
				"user_memory",
				"cmd_mission_cooling_luggable_event_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_mission_cooling_luggable_event_start",
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
		name = "info_mission_cooling_coolant_control",
		response = "info_mission_cooling_coolant_control",
		database = "mission_vo_lm_cooling",
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
				"info_mission_cooling_coolant_control"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest",
					"explicator"
				}
			},
			{
				"faction_memory",
				"info_mission_cooling_coolant_control",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_mission_cooling_coolant_control",
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
		name = "info_mission_cooling_demolish",
		response = "info_mission_cooling_demolish",
		database = "mission_vo_lm_cooling",
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
				"info_mission_cooling_demolish"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest"
				}
			},
			{
				"user_memory",
				"info_mission_cooling_demolish",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_mission_cooling_demolish",
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
		name = "info_mission_cooling_follow_conveyor",
		response = "info_mission_cooling_follow_conveyor",
		database = "mission_vo_lm_cooling",
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
				"info_mission_cooling_follow_conveyor"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest"
				}
			},
			{
				"user_memory",
				"",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
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
		name = "info_mission_cooling_maintenance",
		response = "info_mission_cooling_maintenance",
		database = "mission_vo_lm_cooling",
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
				"info_mission_cooling_maintenance"
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
				"info_mission_cooling_maintenance",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_mission_cooling_maintenance",
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
		name = "info_mission_cooling_vents",
		response = "info_mission_cooling_vents",
		database = "mission_vo_lm_cooling",
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
				"info_mission_cooling_vents"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest"
				}
			},
			{
				"user_memory",
				"info_mission_cooling_vents",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_mission_cooling_vents",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "info_mission_cooling_vents_response",
		wwise_route = 0,
		response = "info_mission_cooling_vents_response",
		database = "mission_vo_lm_cooling",
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
					"info_mission_cooling_vents"
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
		name = "mission_cooling_cmd_load_coolant",
		response = "mission_cooling_cmd_load_coolant",
		database = "mission_vo_lm_cooling",
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
					"luggable_mission_pick_up_lm_cooling"
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
				duration = 0.3
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_cooling_cmd_stabilise",
		response = "mission_cooling_cmd_stabilise",
		database = "mission_vo_lm_cooling",
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
				"cmd_stabilise"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest"
				}
			},
			{
				"user_memory",
				"cmd_stabilise",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_stabilise",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_cooling_elevator_conversation_one_line_one",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cooling_elevator_conversation_one_line_one",
		database = "mission_vo_lm_cooling",
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
				"mission_cooling_elevator_conversation_one_line_one"
			},
			{
				"faction_memory",
				"mission_cooling_elevator_conversation_one_line_one",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_elevator_conversation_one_line_one",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		name = "mission_cooling_elevator_conversation_one_line_three",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cooling_elevator_conversation_one_line_three",
		database = "mission_vo_lm_cooling",
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
					"mission_cooling_elevator_conversation_one_line_two"
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
		name = "mission_cooling_elevator_conversation_one_line_two",
		response = "mission_cooling_elevator_conversation_one_line_two",
		database = "mission_vo_lm_cooling",
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
					"mission_cooling_elevator_conversation_one_line_one"
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
		name = "mission_cooling_elevator_conversation_three_line_one",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cooling_elevator_conversation_three_line_one",
		database = "mission_vo_lm_cooling",
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
				"mission_cooling_elevator_conversation_three_line_one"
			},
			{
				"faction_memory",
				"mission_cooling_elevator_conversation_three_line_one",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_elevator_conversation_three_line_one",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		name = "mission_cooling_elevator_conversation_three_line_three",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cooling_elevator_conversation_three_line_three",
		database = "mission_vo_lm_cooling",
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
					"mission_cooling_elevator_conversation_three_line_two"
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
		name = "mission_cooling_elevator_conversation_three_line_two",
		response = "mission_cooling_elevator_conversation_three_line_two",
		database = "mission_vo_lm_cooling",
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
					"mission_cooling_elevator_conversation_three_line_one"
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
		name = "mission_cooling_elevator_conversation_two_line_one",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cooling_elevator_conversation_two_line_one",
		database = "mission_vo_lm_cooling",
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
				"mission_cooling_elevator_conversation_two_line_one"
			},
			{
				"faction_memory",
				"mission_cooling_elevator_conversation_two_line_one",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_elevator_conversation_two_line_one",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		name = "mission_cooling_elevator_conversation_two_line_three",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cooling_elevator_conversation_two_line_three",
		database = "mission_vo_lm_cooling",
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
					"mission_cooling_elevator_conversation_two_line_two"
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
		name = "mission_cooling_elevator_conversation_two_line_two",
		response = "mission_cooling_elevator_conversation_two_line_two",
		database = "mission_vo_lm_cooling",
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
					"mission_cooling_elevator_conversation_two_line_one"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_cooling_first_objective",
		response = "mission_cooling_first_objective",
		database = "mission_vo_lm_cooling",
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
					"info_mission_cooling_vents_response"
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
		name = "mission_cooling_first_objective_response",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cooling_first_objective_response",
		database = "mission_vo_lm_cooling",
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
					"mission_cooling_first_objective"
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
		name = "mission_cooling_heat",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cooling_heat",
		database = "mission_vo_lm_cooling",
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
				"lm_cooling"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled"
			},
			{
				"faction_memory",
				"mission_cooling_heat",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_heat",
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
		name = "mission_cooling_heat_response",
		response = "mission_cooling_heat_response",
		database = "mission_vo_lm_cooling",
		wwise_route = 1,
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
					"mission_cooling_heat"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_cooling_heat_response_three",
		response = "mission_cooling_heat_response_three",
		database = "mission_vo_lm_cooling",
		wwise_route = 1,
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
					"mission_cooling_heat_response_two"
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
		name = "mission_cooling_heat_response_two",
		wwise_route = 0,
		response = "mission_cooling_heat_response_two",
		database = "mission_vo_lm_cooling",
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
					"mission_cooling_heat_response"
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
		name = "mission_cooling_leaving",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_cooling_leaving",
		database = "mission_vo_lm_cooling",
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
				"mission_cooling_leaving"
			},
			{
				"faction_memory",
				"mission_cooling_leaving",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_leaving",
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
		name = "mission_cooling_leaving_response",
		response = "mission_cooling_leaving_response",
		database = "mission_vo_lm_cooling",
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
					"mission_cooling_leaving"
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
		name = "mission_cooling_long_way_down",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_cooling_long_way_down",
		database = "mission_vo_lm_cooling",
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
				"mission_cooling_long_way_down"
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
				"mission_cooling_long_way_down",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_long_way_down",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_cooling_luggable_event_survive",
		response = "mission_cooling_luggable_event_survive",
		database = "mission_vo_lm_cooling",
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
				"mission_cooling_luggable_event_survive"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest"
				}
			},
			{
				"user_memory",
				"mission_cooling_luggable_event_survive",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"mission_cooling_luggable_event_survive",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_cooling_overseer_office",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cooling_overseer_office",
		database = "mission_vo_lm_cooling",
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
				"mission_cooling_overseer_office"
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
				"mission_cooling_overseer_office",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_overseer_office",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_cooling_worker_habitation",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_cooling_worker_habitation",
		database = "mission_vo_lm_cooling",
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
				"mission_cooling_worker_habitation"
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
				"mission_cooling_worker_habitation",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_worker_habitation",
				OP.ADD,
				1
			}
		}
	})
end
