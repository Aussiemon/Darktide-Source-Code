return function ()
	define_rule({
		name = "hab_block_void_response_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "hab_block_void_response_b",
		database = "mission_vo_cm_habs",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
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
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"level_hab_block_void_response"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "info_get_out_habs",
		response = "info_get_out_habs",
		database = "mission_vo_cm_habs",
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
					"level_hab_block_scan_complete"
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
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "level_hab_block_apartments",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "level_hab_block_apartments",
		database = "mission_vo_cm_habs",
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
				"hab_block_apartment"
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
				50
			},
			{
				"faction_memory",
				"",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"level_hab_block_apartments",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"",
				OP.TIMESET
			},
			{
				"faction_memory",
				"level_hab_block_apartments",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "level_hab_block_apartments_response",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "level_hab_block_apartments_response",
		database = "mission_vo_cm_habs",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
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
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"level_hab_block_apartments"
				}
			},
			{
				"faction_memory",
				"level_hab_block_apartments_response",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_apartments_response",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "level_hab_block_atrium",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "level_hab_block_atrium",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_atrium"
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
				"level_hab_block_atrium",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"level_hab_block_atrium",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_atrium",
				OP.TIMESET
			},
			{
				"faction_memory",
				"level_hab_block_atrium",
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
		name = "level_hab_block_b",
		response = "level_hab_block_b",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_b"
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
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"level_hab_block_b",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_b",
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
		name = "level_hab_block_b_response_a",
		response = "level_hab_block_b_response_a",
		database = "mission_vo_cm_habs",
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
					"level_hab_block_b"
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
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "level_hab_block_b_response_b",
		wwise_route = 0,
		response = "level_hab_block_b_response_b",
		database = "mission_vo_cm_habs",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
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
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"level_hab_block_b_response_a"
				}
			},
			{
				"faction_memory",
				"level_hab_block_b_response_b",
				OP.TIMEDIFF,
				OP.GT,
				240
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_b_response_b",
				OP.TIMESET
			}
		},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "level_hab_block_b_response_c",
		response = "level_hab_block_b_response_c",
		database = "mission_vo_cm_habs",
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
					""
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
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "level_hab_block_collapse",
		category = "player_prio_0",
		wwise_route = 0,
		response = "level_hab_block_collapse",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_collapse"
			},
			{
				"faction_memory",
				"level_hab_block_collapse",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_collapse",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "level_hab_block_corpse",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "level_hab_block_corpse",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_corpse"
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
				50
			},
			{
				"faction_memory",
				"level_hab_block_corpse",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"level_hab_block_corpse",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_corpse",
				OP.TIMESET
			},
			{
				"faction_memory",
				"level_hab_block_corpse",
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
		name = "level_hab_block_corpse_response",
		response = "level_hab_block_corpse_response",
		database = "mission_vo_cm_habs",
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
					"level_hab_block_corpse"
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
		name = "level_hab_block_entrance",
		response = "level_hab_block_entrance",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_entrance"
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
				"level_hab_block_entrance",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_entrance",
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
		name = "level_hab_block_final_event_scan_two",
		response = "level_hab_block_final_event_scan_two",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_final_event_scan_two"
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
				"level_hab_block_final_event_scan_two",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_final_event_scan_two",
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
		name = "level_hab_block_first_objective",
		response = "level_hab_block_first_objective",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_first_objective"
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
				"level_hab_block_first_objective",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_first_objective",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "level_hab_block_first_objective_response",
		wwise_route = 0,
		response = "level_hab_block_first_objective_response",
		database = "mission_vo_cm_habs",
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
					"level_hab_block_first_objective"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default"
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
		name = "level_hab_block_market",
		response = "level_hab_block_market",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_market"
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
				"level_hab_block_market",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_market",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "level_hab_block_market_response",
		wwise_route = 0,
		response = "level_hab_block_market_response",
		database = "mission_vo_cm_habs",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
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
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"level_hab_block_market"
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
		name = "level_hab_block_quarantine",
		response = "level_hab_block_quarantine",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_quarantine"
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
				"level_hab_block_quarantine",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_quarantine",
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
		name = "level_hab_block_roof",
		response = "level_hab_block_roof",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_roof"
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
				"level_hab_block_roof",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_roof",
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
		name = "level_hab_block_scan_complete",
		response = "level_hab_block_scan_complete",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_scan_complete"
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
				"user_memory",
				"level_hab_block_scan_complete",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"level_hab_block_scan_complete",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_giver_default"
		}
	})
	define_rule({
		name = "level_hab_block_security",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "level_hab_block_security",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_security"
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
				"level_hab_block_security_last_seen",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"level_hab_block_security",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_security_last_seen",
				OP.TIMESET
			},
			{
				"faction_memory",
				"level_hab_block_security",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "level_hab_block_start_banter_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "level_hab_block_start_banter_a",
		database = "mission_vo_cm_habs",
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
				"cm_habs"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled"
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "level_hab_block_start_banter_b",
		response = "level_hab_block_start_banter_b",
		database = "mission_vo_cm_habs",
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
					"level_hab_block_start_banter_a"
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
		name = "level_hab_block_start_banter_c",
		wwise_route = 0,
		response = "level_hab_block_start_banter_c",
		database = "mission_vo_cm_habs",
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
					"level_hab_block_start_banter_b"
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
		name = "level_hab_block_temple",
		category = "player_prio_0",
		wwise_route = 0,
		response = "level_hab_block_temple",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_temple"
			},
			{
				"faction_memory",
				"level_hab_block_temple",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_temple",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "level_hab_block_temple_response",
		wwise_route = 0,
		response = "level_hab_block_temple_response",
		database = "mission_vo_cm_habs",
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
					"level_hab_block_temple"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "level_hab_block_trapped_response",
		response = "level_hab_block_trapped_response",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_trapped_response"
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
				"level_hab_block_trapped_response",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_trapped_response",
				OP.ADD,
				1
			}
		},
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
		name = "level_hab_block_vista",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "level_hab_block_vista",
		database = "mission_vo_cm_habs",
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
				"level_hab_block_vista"
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
				25
			},
			{
				"faction_memory",
				"level_hab_block_vista",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"level_hab_block_vista_count",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"level_hab_block_vista",
				OP.TIMESET
			},
			{
				"faction_memory",
				"level_hab_block_vista_count",
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
		name = "mission_scan_complete",
		response = "mission_scan_complete",
		database = "mission_vo_cm_habs",
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
				"mission_scan_complete"
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
				"user_memory",
				"mission_scan_complete",
				OP.GTEQ,
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
			target = "players"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_scan_final",
		response = "mission_scan_final",
		database = "mission_vo_cm_habs",
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
					"level_hab_block_temple_response"
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
		on_done = {
			{
				"faction_memory",
				"mission_scan_final",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3
			}
		}
	})
end
