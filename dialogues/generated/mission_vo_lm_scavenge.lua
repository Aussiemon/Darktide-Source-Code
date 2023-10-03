return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "cmd_mission_scavenge_entering_ship_port",
		response = "cmd_mission_scavenge_entering_ship_port",
		database = "mission_vo_lm_scavenge",
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
				"cmd_mission_scavenge_entering_ship_port"
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
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"cmd_mission_scavenge_entering_ship_port",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"cmd_mission_scavenge_entering_ship_port",
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
		name = "cmd_mission_scavenge_hacking_event_end",
		response = "cmd_mission_scavenge_hacking_event_end",
		database = "mission_vo_lm_scavenge",
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
				"cmd_mission_scavenge_hacking_event_end"
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
				"user_memory",
				"cmd_mission_scavenge_hacking_event_end",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_mission_scavenge_hacking_event_end",
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
		name = "cmd_mission_scavenge_hacking_event_start",
		response = "cmd_mission_scavenge_hacking_event_start",
		database = "mission_vo_lm_scavenge",
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
					"mission_scavenge_servitors"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "cmd_mission_scavenge_luggable_event_end",
		response = "cmd_mission_scavenge_luggable_event_end",
		database = "mission_vo_lm_scavenge",
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
				"cmd_mission_scavenge_luggable_event_end"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"mission_scavenge_luggable_event_end",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_luggable_event_end",
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
		name = "cmd_mission_scavenge_luggable_event_start",
		response = "cmd_mission_scavenge_luggable_event_start",
		database = "mission_vo_lm_scavenge",
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
				"cmd_mission_scavenge_luggable_event_start"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"cmd_mission_scavenge_luggable_event_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"cmd_mission_scavenge_luggable_event_start",
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
		name = "cmd_mission_scavenge_vault_access",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_mission_scavenge_vault_access",
		database = "mission_vo_lm_scavenge",
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
				"cmd_mission_scavenge_vault_access"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"cmd_mission_scavenge_vault_access",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"cmd_mission_scavenge_vault_access",
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
		name = "info_mission_scavenge_hangar_guidance_one",
		response = "info_mission_scavenge_hangar_guidance_one",
		database = "mission_vo_lm_scavenge",
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
				"info_mission_scavenge_hangar_guidance_one"
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
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"info_mission_scavenge_hangar_guidance_one",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_mission_scavenge_hangar_guidance_one",
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
		name = "info_mission_scavenge_hangar_guidance_two",
		response = "info_mission_scavenge_hangar_guidance_two",
		database = "mission_vo_lm_scavenge",
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
				"info_mission_scavenge_hangar_guidance_two"
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
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"info_mission_scavenge_hangar_guidance_two",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_mission_scavenge_hangar_guidance_two",
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
		name = "info_mission_scavenge_ship_elevator_vista",
		response = "info_mission_scavenge_ship_elevator_vista",
		database = "mission_vo_lm_scavenge",
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
				"info_mission_scavenge_ship_elevator_vista"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"info_mission_scavenge_ship_elevator_vista",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_mission_scavenge_ship_elevator_vista",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_scavenge_atmosphere_shield",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_scavenge_atmosphere_shield",
		database = "mission_vo_lm_scavenge",
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
				"lm_scavenge"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled"
			},
			{
				"faction_memory",
				"mission_scavenge_start_banter",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_start_banter",
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
		name = "mission_scavenge_cmd_load_pneumatic",
		response = "mission_scavenge_cmd_load_pneumatic",
		database = "mission_vo_lm_scavenge",
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
					"luggable_mission_pick_up_lm_scavenge"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_scavenge_daylight",
		wwise_route = 0,
		response = "mission_scavenge_daylight",
		database = "mission_vo_lm_scavenge",
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
					"mission_scavenge_atmosphere_shield"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"mission_scavenge_daylight_user",
				OP.ADD,
				1
			}
		},
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
		name = "mission_scavenge_daylight_response",
		response = "mission_scavenge_daylight_response",
		database = "mission_vo_lm_scavenge",
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
					"mission_scavenge_daylight"
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
		name = "mission_scavenge_daylight_response_b",
		wwise_route = 0,
		response = "mission_scavenge_daylight_response_b",
		database = "mission_vo_lm_scavenge",
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
					"mission_scavenge_daylight_response"
				}
			},
			{
				"user_memory",
				"mission_scavenge_daylight_user",
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
		name = "mission_scavenge_elevator_conversation_one_line_one",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_scavenge_elevator_conversation_one_line_one",
		database = "mission_vo_lm_scavenge",
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
				20
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_scavenge_elevator_conversation_one_line_one"
			},
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_one_line_one",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_one_line_one",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		name = "mission_scavenge_elevator_conversation_one_line_three",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_scavenge_elevator_conversation_one_line_three",
		database = "mission_vo_lm_scavenge",
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
					"mission_scavenge_elevator_conversation_one_line_two"
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
		name = "mission_scavenge_elevator_conversation_one_line_two",
		response = "mission_scavenge_elevator_conversation_one_line_two",
		database = "mission_vo_lm_scavenge",
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
					"mission_scavenge_elevator_conversation_one_line_one"
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
		name = "mission_scavenge_elevator_conversation_three_line_one",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_scavenge_elevator_conversation_three_line_one",
		database = "mission_vo_lm_scavenge",
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
				20
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_scavenge_elevator_conversation_three_line_one"
			},
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_three_line_one",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_three_line_one",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		name = "mission_scavenge_elevator_conversation_three_line_three",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_scavenge_elevator_conversation_three_line_three",
		database = "mission_vo_lm_scavenge",
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
					"mission_scavenge_elevator_conversation_three_line_two"
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
		name = "mission_scavenge_elevator_conversation_three_line_two",
		response = "mission_scavenge_elevator_conversation_three_line_two",
		database = "mission_vo_lm_scavenge",
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
					"mission_scavenge_elevator_conversation_three_line_one"
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
		name = "mission_scavenge_elevator_conversation_two_line_one",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_scavenge_elevator_conversation_two_line_one",
		database = "mission_vo_lm_scavenge",
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
				20
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_scavenge_elevator_conversation_two_line_one"
			},
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_two_line_one",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_two_line_one",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		name = "mission_scavenge_elevator_conversation_two_line_three",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_scavenge_elevator_conversation_two_line_three",
		database = "mission_vo_lm_scavenge",
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
					"mission_scavenge_elevator_conversation_two_line_two"
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
		name = "mission_scavenge_elevator_conversation_two_line_two",
		response = "mission_scavenge_elevator_conversation_two_line_two",
		database = "mission_vo_lm_scavenge",
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
					"mission_scavenge_elevator_conversation_two_line_one"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_scavenge_first_objective",
		response = "mission_scavenge_first_objective",
		database = "mission_vo_lm_scavenge",
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
					"mission_scavenge_daylight_response_b"
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
		name = "mission_scavenge_first_objective_response",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_scavenge_first_objective_response",
		database = "mission_vo_lm_scavenge",
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
					"mission_scavenge_first_objective"
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
		name = "mission_scavenge_interior",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "mission_scavenge_interior",
		database = "mission_vo_lm_scavenge",
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
				"mission_scavenge_interior"
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low"
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
				"enemies_close",
				OP.LT,
				10
			},
			{
				"faction_memory",
				"mission_scavenge_interior",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"mission_scavenge_interior",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_interior",
				OP.TIMESET
			},
			{
				"faction_memory",
				"mission_scavenge_interior",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_scavenge_pneumatic_press",
		response = "mission_scavenge_pneumatic_press",
		database = "mission_vo_lm_scavenge",
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
				"mission_scavenge_pneumatic_press"
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
				"mission_scavenge_pneumatic_press",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_pneumatic_press",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_scavenge_servitors",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_scavenge_servitors",
		database = "mission_vo_lm_scavenge",
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
				"mission_scavenge_servitors"
			},
			{
				"faction_memory",
				"mission_scavenge_servitors",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_servitors",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_giver_default"
		}
	})
	define_rule({
		name = "mission_scavenge_ship_elevator_end",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_scavenge_ship_elevator_end",
		database = "mission_vo_lm_scavenge",
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
				"mission_scavenge_ship_elevator_end"
			},
			{
				"faction_memory",
				"mission_scavenge_ship_elevator_end",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_ship_elevator_end",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_scavenge_underhalls",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "mission_scavenge_underhalls",
		database = "mission_vo_lm_scavenge",
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
				"mission_scavenge_underhalls"
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
				"mission_scavenge_underhalls",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_underhalls",
				OP.ADD,
				1
			}
		}
	})
end
