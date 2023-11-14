return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "event_fortification_disable_the_skyfire_resurgence",
		wwise_route = 1,
		response = "event_fortification_disable_the_skyfire_resurgence",
		database = "mission_vo_fm_resurgence",
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
					"mission_resurgence_secure_the_aegis_disabled"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
				duration = 0.24
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "info_get_out_resurgence",
		response = "info_get_out_resurgence",
		database = "mission_vo_fm_resurgence",
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
				"info_get_out_resurgence"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest",
					"pilot"
				}
			},
			{
				"user_memory",
				"info_get_out",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_get_out",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "luggable_mission_pick_up_fm_resurgence",
		wwise_route = 0,
		response = "luggable_mission_pick_up_fm_resurgence",
		database = "mission_vo_fm_resurgence",
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
				"luggable_wield_battery"
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"fm_resurgence"
			},
			{
				"faction_memory",
				"luggable_mission_pick_up",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"mission_resurgence_bridges_up_b",
				OP.EQ,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"luggable_mission_pick_up",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_giver_default_class"
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
		name = "mission_resurgence_archive_a",
		response = "mission_resurgence_archive_a",
		database = "mission_vo_fm_resurgence",
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
				"mission_resurgence_archive_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_resurgence_archive_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_archive_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_resurgence_boulevard",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_resurgence_boulevard",
		database = "mission_vo_fm_resurgence",
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
				"mission_resurgence_boulevard"
			},
			{
				"faction_memory",
				"mission_resurgence_boulevard",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_boulevard",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "mission_resurgence_boulevard_response",
		wwise_route = 0,
		response = "mission_resurgence_boulevard_response",
		database = "mission_vo_fm_resurgence",
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
					"mission_resurgence_boulevard"
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
		name = "mission_resurgence_bridge_down",
		response = "mission_resurgence_bridge_down",
		database = "mission_vo_fm_resurgence",
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
				"mission_resurgence_bridge_down"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_resurgence_bridge_down",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_bridge_down",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_resurgence_bridge_hurry_up",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_resurgence_bridge_hurry_up",
		database = "mission_vo_fm_resurgence",
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
				"mission_resurgence_bridge_hurry_up"
			},
			{
				"faction_memory",
				"mission_resurgence_bridge_hurry_up",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_bridge_hurry_up",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_resurgence_bridge_of_martyrs_a",
		response = "mission_resurgence_bridge_of_martyrs_a",
		database = "mission_vo_fm_resurgence",
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
				"mission_resurgence_bridge_of_martyrs_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_resurgence_bridge_of_martyrs_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_bridge_of_martyrs_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_resurgence_bridge_of_martyrs_b",
		wwise_route = 0,
		response = "mission_resurgence_bridge_of_martyrs_b",
		database = "mission_vo_fm_resurgence",
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
					"mission_resurgence_bridge_of_martyrs_a"
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
		name = "mission_resurgence_bridges_up_a",
		response = "mission_resurgence_bridges_up_a",
		database = "mission_vo_fm_resurgence",
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
				"mission_resurgence_bridges_up_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_resurgence_bridges_up_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_bridges_up_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_resurgence_bridges_up_b",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_resurgence_bridges_up_b",
		database = "mission_vo_fm_resurgence",
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
					"mission_resurgence_bridges_up_a"
				}
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_bridges_up_b",
				OP.ADD,
				1
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_resurgence_defence_conversation_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_resurgence_defence_conversation_a",
		database = "mission_vo_fm_resurgence",
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
				"mission_resurgence_defence_conversation_a"
			},
			{
				"faction_memory",
				"mission_resurgence_defence_conversation_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_defence_conversation_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_resurgence_defence_conversation_b",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_resurgence_defence_conversation_b",
		database = "mission_vo_fm_resurgence",
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
					"mission_resurgence_defence_conversation_a"
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
		name = "mission_resurgence_first_objective",
		response = "mission_resurgence_first_objective",
		database = "mission_vo_fm_resurgence",
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
					"mission_resurgence_start_banter_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
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
		name = "mission_resurgence_first_objective_response",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_resurgence_first_objective_response",
		database = "mission_vo_fm_resurgence",
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
					"mission_resurgence_first_objective"
				}
			},
			{
				"user_memory",
				"mission_resurgence_start_banter_c_user",
				OP.EQ,
				0
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
		name = "mission_resurgence_keep_moving",
		response = "mission_resurgence_keep_moving",
		database = "mission_vo_fm_resurgence",
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
				"mission_resurgence_keep_moving"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_resurgence_keep_moving",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_keep_moving",
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
		name = "mission_resurgence_power_bridge",
		response = "mission_resurgence_power_bridge",
		database = "mission_vo_fm_resurgence",
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
				"mission_resurgence_power_bridge"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_resurgence_power_bridge",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_power_bridge",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_resurgence_pulpit_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "mission_resurgence_pulpit_a",
		database = "mission_vo_fm_resurgence",
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
				"mission_resurgence_pulpit_a"
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
				"mission_resurgence_pulpit_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_pulpit_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "mission_resurgence_pulpit_b",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_resurgence_pulpit_b",
		database = "mission_vo_fm_resurgence",
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
					"mission_resurgence_pulpit_a"
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
		name = "mission_resurgence_secure_the_aegis",
		response = "mission_resurgence_secure_the_aegis",
		database = "mission_vo_fm_resurgence",
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
				"mission_resurgence_secure_the_aegis"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_resurgence_secure_the_aegis",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_secure_the_aegis",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "self"
		}
	})
	define_rule({
		name = "mission_resurgence_start_banter_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "mission_resurgence_start_banter_a",
		database = "mission_vo_fm_resurgence",
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
				"fm_resurgence"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled"
			}
		},
		on_done = {
			{
				"user_memory",
				"mission_resurgence_start_banter_a_user",
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
		name = "mission_resurgence_start_banter_b",
		response = "mission_resurgence_start_banter_b",
		database = "mission_vo_fm_resurgence",
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
					"mission_resurgence_start_banter_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
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
		name = "mission_resurgence_start_banter_c",
		wwise_route = 0,
		response = "mission_resurgence_start_banter_c",
		database = "mission_vo_fm_resurgence",
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
					"mission_resurgence_start_banter_b"
				}
			},
			{
				"user_memory",
				"mission_resurgence_start_banter_a_user",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"mission_resurgence_start_banter_c_user",
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
		name = "mission_resurgence_statue_baross",
		response = "mission_resurgence_statue_baross",
		database = "mission_vo_fm_resurgence",
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
				"mission_resurgence_statue_baross"
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
				26
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_resurgence_statue_baross",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_resurgence_statue_baross",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
end
