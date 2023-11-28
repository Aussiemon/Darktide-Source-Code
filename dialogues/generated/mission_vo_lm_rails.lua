-- chunkname: @dialogues/generated/mission_vo_lm_rails.lua

return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rails_descend_shaft",
		response = "mission_rails_descend_shaft",
		database = "mission_vo_lm_rails",
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
				"mission_rails_descend_shaft"
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
				"mission_rails_descend_shaft",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_descend_shaft",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_rails_disable_skyfire_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_rails_disable_skyfire_a",
		database = "mission_vo_lm_rails",
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
				"mission_rails_disable_skyfire_a"
			},
			{
				"faction_memory",
				"mission_rails_disable_skyfire_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_disable_skyfire_a",
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
		name = "mission_rails_disable_skyfire_b",
		response = "mission_rails_disable_skyfire_b",
		database = "mission_vo_lm_rails",
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
					"mission_rails_disable_skyfire_a"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rails_disable_skyfire_backup",
		response = "mission_rails_disable_skyfire_backup",
		database = "mission_vo_lm_rails",
		wwise_route = 1,
		category = "vox_prio_1",
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
				"mission_rails_disable_skyfire_backup"
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
				"mission_rails_disable_skyfire_backup",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_disable_skyfire_backup",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_rails_district_gate",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_rails_district_gate",
		database = "mission_vo_lm_rails",
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
				"mission_rails_district_gate"
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
				41
			},
			{
				"faction_memory",
				"mission_rails_district_gate",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_district_gate",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_rails_end_event_conversation_one_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_rails_end_event_conversation_one_a",
		database = "mission_vo_lm_rails",
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
				"mission_rails_end_event_conversation_one_a"
			},
			{
				"faction_memory",
				"mission_rails_end_event_conversation_one_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_end_event_conversation_one_a",
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
		name = "mission_rails_end_event_conversation_one_b",
		wwise_route = 1,
		response = "mission_rails_end_event_conversation_one_b",
		database = "mission_vo_lm_rails",
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
					"mission_rails_end_event_conversation_one_a"
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
		name = "mission_rails_end_event_conversation_one_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_rails_end_event_conversation_one_c",
		database = "mission_vo_lm_rails",
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
					"mission_rails_end_event_conversation_one_b"
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
		name = "mission_rails_end_event_conversation_three_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_rails_end_event_conversation_three_a",
		database = "mission_vo_lm_rails",
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
				"mission_rails_end_event_conversation_three_a"
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
				"mission_rails_end_event_conversation_three_a",
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
		name = "mission_rails_end_event_conversation_three_b",
		wwise_route = 1,
		response = "mission_rails_end_event_conversation_three_b",
		database = "mission_vo_lm_rails",
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
					"mission_rails_end_event_conversation_three_a"
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
		name = "mission_rails_end_event_conversation_three_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_rails_end_event_conversation_three_c",
		database = "mission_vo_lm_rails",
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
					"mission_rails_end_event_conversation_three_b"
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
		name = "mission_rails_end_event_conversation_two_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_rails_end_event_conversation_two_a",
		database = "mission_vo_lm_rails",
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
				"mission_rails_end_event_conversation_two_a"
			},
			{
				"faction_memory",
				"mission_rails_end_event_conversation_two_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_end_event_conversation_two_a",
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
		name = "mission_rails_end_event_conversation_two_b",
		wwise_route = 1,
		response = "mission_rails_end_event_conversation_two_b",
		database = "mission_vo_lm_rails",
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
					"mission_rails_end_event_conversation_two_a"
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
		name = "mission_rails_end_event_conversation_two_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_rails_end_event_conversation_two_c",
		database = "mission_vo_lm_rails",
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
					"mission_rails_end_event_conversation_two_b"
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
		name = "mission_rails_event_grab_supplies",
		response = "mission_rails_event_grab_supplies",
		database = "mission_vo_lm_rails",
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
				"mission_rails_event_grab_supplies"
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
				"mission_rails_event_grab_supplies",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_event_grab_supplies",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rails_first_objective",
		response = "mission_rails_first_objective",
		database = "mission_vo_lm_rails",
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
					"mission_rails_start_banter_c"
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
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "mission_rails_first_objective_response",
		wwise_route = 0,
		response = "mission_rails_first_objective_response",
		database = "mission_vo_lm_rails",
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
					"mission_rails_first_objective"
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
		name = "mission_rails_hab_block_dreyko",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_rails_hab_block_dreyko",
		database = "mission_vo_lm_rails",
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
				"mission_rails_hab_block_dreyko"
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
				"mission_rails_hab_block_dreyko",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_hab_block_dreyko",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rails_hack_access_door",
		response = "mission_rails_hack_access_door",
		database = "mission_vo_lm_rails",
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
				"mission_rails_hack_access_door"
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
				"mission_rails_hack_access_door",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_hack_access_door",
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
		name = "mission_rails_logistratum",
		response = "mission_rails_logistratum",
		database = "mission_vo_lm_rails",
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
				"mission_rails_logistratum"
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
				"mission_rails_logistratum",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_logistratum",
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
		name = "mission_rails_lower_track",
		response = "mission_rails_lower_track",
		database = "mission_vo_lm_rails",
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
				"mission_rails_lower_track"
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
				"mission_rails_lower_track",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_lower_track",
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
		name = "mission_rails_maintenance_bay",
		response = "mission_rails_maintenance_bay",
		database = "mission_vo_lm_rails",
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
				"mission_rails_maintenance_bay"
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
				"mission_rails_maintenance_bay",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_maintenance_bay",
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
		name = "mission_rails_refectory",
		response = "mission_rails_refectory",
		database = "mission_vo_lm_rails",
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
				"mission_rails_refectory"
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
				"mission_rails_refectory",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_refectory",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_rails_refectory_response",
		wwise_route = 0,
		response = "mission_rails_refectory_response",
		database = "mission_vo_lm_rails",
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
					"mission_rails_refectory"
				}
			},
			{
				"user_memory",
				"mission_rails_start_banter_c_user",
				OP.EQ,
				0
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
		name = "mission_rails_start_banter_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_rails_start_banter_a",
		database = "mission_vo_lm_rails",
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
				"lm_rails"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled"
			},
			{
				"faction_memory",
				"mission_rails_start_banter_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_start_banter_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"mission_rails_start_banter_a_user",
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
		name = "mission_rails_start_banter_b",
		response = "mission_rails_start_banter_b",
		database = "mission_vo_lm_rails",
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
					"mission_rails_start_banter_a"
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
		name = "mission_rails_start_banter_c",
		wwise_route = 0,
		response = "mission_rails_start_banter_c",
		database = "mission_vo_lm_rails",
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
					"mission_rails_start_banter_b"
				}
			},
			{
				"user_memory",
				"mission_rails_start_banter_a_user",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"mission_rails_start_banter_c_user",
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
		name = "mission_rails_station_approach",
		response = "mission_rails_station_approach",
		database = "mission_vo_lm_rails",
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
				"mission_rails_station_approach"
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
				"mission_rails_station_approach",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_station_approach",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_rails_trains",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_rails_trains",
		database = "mission_vo_lm_rails",
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
				"mission_rails_trains"
			},
			{
				"faction_memory",
				"mission_rails_trains",
				OP.EQ,
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rails_trains",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
end
