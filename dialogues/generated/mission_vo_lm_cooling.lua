return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_mission_cooling_hacking_event_end",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_mission_cooling_hacking_event_end",
		database = "mission_vo_lm_cooling",
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
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_mission_cooling_hacking_event_start",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_mission_cooling_hacking_event_start",
		database = "mission_vo_lm_cooling",
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
					"sergeant"
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
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_mission_cooling_luggable_event_start",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_mission_cooling_luggable_event_start",
		database = "mission_vo_lm_cooling",
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
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_bypass_mission_cooling",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_bypass_mission_cooling",
		database = "mission_vo_lm_cooling",
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
					"mission_cooling_heat_response_two"
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
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_mission_cooling_coolant_control",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_mission_cooling_coolant_control",
		database = "mission_vo_lm_cooling",
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
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_mission_cooling_demolish",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_mission_cooling_demolish",
		database = "mission_vo_lm_cooling",
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
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0,
				max_failed_tries = 5,
				hold_for = 0
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_mission_cooling_follow_conveyor",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_mission_cooling_follow_conveyor",
		database = "mission_vo_lm_cooling",
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
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_mission_cooling_maintenance",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_mission_cooling_maintenance",
		database = "mission_vo_lm_cooling",
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
				"info_mission_cooling_maintenance"
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
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_mission_cooling_vents",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_mission_cooling_vents",
		database = "mission_vo_lm_cooling",
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
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "info_mission_cooling_vents_response",
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
					"info_mission_cooling_vents"
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
		post_wwise_event = "play_radio_static_end",
		name = "mission_cooling_elevator_conversation_one_line_two",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "mission_cooling_elevator_conversation_one_line_two",
		database = "mission_vo_lm_cooling",
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
		post_wwise_event = "play_radio_static_end",
		name = "mission_cooling_elevator_conversation_three_line_two",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "mission_cooling_elevator_conversation_three_line_two",
		database = "mission_vo_lm_cooling",
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
		name = "mission_cooling_elevator_conversation_two_line_two",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "mission_cooling_elevator_conversation_two_line_two",
		database = "mission_vo_lm_cooling",
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
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_cooling_heat_response",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_cooling_heat_response",
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
					"mission_cooling_heat"
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
				duration = 0.8
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
		name = "mission_cooling_luggable_event_survive",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_cooling_luggable_event_survive",
		database = "mission_vo_lm_cooling",
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
		name = "mission_cooling_production_line",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_cooling_production_line",
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
				"mission_cooling_production_line"
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
				"mission_cooling_production_line",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_production_line",
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
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_cooling_worker_habitation"
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
