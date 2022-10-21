return function ()
	define_rule({
		name = "nurgle_circumstance_conversation_five_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "nurgle_circumstance_conversation_five_a",
		database = "circumstance_vo_nurgle_rot",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk"
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
				30
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_nurgle_rot"
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low, medium"
			},
			{
				"user_context",
				"pacing_state",
				OP.SET_INCLUDES,
				args = {
					"tension_peak_fade",
					"relax",
					"build_up_tension_low",
					"build_up_tension_no_trickle"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				120
			},
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
				"0"
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
		name = "nurgle_circumstance_conversation_five_b",
		response = "nurgle_circumstance_conversation_five_b",
		database = "circumstance_vo_nurgle_rot",
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
					"nurgle_circumstance_conversation_five_a"
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
		name = "nurgle_circumstance_conversation_five_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "nurgle_circumstance_conversation_five_c",
		database = "circumstance_vo_nurgle_rot",
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
					"nurgle_circumstance_conversation_five_b"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "nurgle_circumstance_conversation_four_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "nurgle_circumstance_conversation_four_a",
		database = "circumstance_vo_nurgle_rot",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk"
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
				30
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_nurgle_rot"
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low, medium"
			},
			{
				"user_context",
				"pacing_state",
				OP.SET_INCLUDES,
				args = {
					"tension_peak_fade",
					"relax",
					"build_up_tension_low",
					"build_up_tension_no_trickle"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				120
			},
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
				"0"
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
		name = "nurgle_circumstance_conversation_four_b",
		response = "nurgle_circumstance_conversation_four_b",
		database = "circumstance_vo_nurgle_rot",
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
					"nurgle_circumstance_conversation_four_a"
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
		name = "nurgle_circumstance_conversation_four_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "nurgle_circumstance_conversation_four_c",
		database = "circumstance_vo_nurgle_rot",
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
					"nurgle_circumstance_conversation_four_b"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "nurgle_circumstance_conversation_one_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "nurgle_circumstance_conversation_one_a",
		database = "circumstance_vo_nurgle_rot",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk"
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
				30
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_nurgle_rot"
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low, medium"
			},
			{
				"user_context",
				"pacing_state",
				OP.SET_INCLUDES,
				args = {
					"tension_peak_fade",
					"relax",
					"build_up_tension_low",
					"build_up_tension_no_trickle"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				120
			},
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
				"0"
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
		name = "nurgle_circumstance_conversation_one_b",
		response = "nurgle_circumstance_conversation_one_b",
		database = "circumstance_vo_nurgle_rot",
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
					"nurgle_circumstance_conversation_one_a"
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
		name = "nurgle_circumstance_conversation_one_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "nurgle_circumstance_conversation_one_c",
		database = "circumstance_vo_nurgle_rot",
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
					"nurgle_circumstance_conversation_one_b"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "nurgle_circumstance_conversation_three_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "nurgle_circumstance_conversation_three_a",
		database = "circumstance_vo_nurgle_rot",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk"
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
				30
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_nurgle_rot"
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low"
			},
			{
				"user_context",
				"pacing_state",
				OP.SET_INCLUDES,
				args = {
					"tension_peak_fade",
					"relax",
					"build_up_tension_low",
					"build_up_tension_no_trickle"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				120
			},
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
				"0"
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
		name = "nurgle_circumstance_conversation_three_b",
		response = "nurgle_circumstance_conversation_three_b",
		database = "circumstance_vo_nurgle_rot",
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
					"nurgle_circumstance_conversation_three_a"
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
		name = "nurgle_circumstance_conversation_three_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "nurgle_circumstance_conversation_three_c",
		database = "circumstance_vo_nurgle_rot",
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
					"nurgle_circumstance_conversation_three_b"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "nurgle_circumstance_conversation_two_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "nurgle_circumstance_conversation_two_a",
		database = "circumstance_vo_nurgle_rot",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk"
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
				30
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_nurgle_rot"
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low, medium"
			},
			{
				"user_context",
				"pacing_state",
				OP.SET_INCLUDES,
				args = {
					"tension_peak_fade",
					"relax",
					"build_up_tension_low",
					"build_up_tension_no_trickle"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				120
			},
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
				"0"
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
		name = "nurgle_circumstance_conversation_two_b",
		response = "nurgle_circumstance_conversation_two_b",
		database = "circumstance_vo_nurgle_rot",
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
					"nurgle_circumstance_conversation_two_a"
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
		name = "nurgle_circumstance_conversation_two_c",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "nurgle_circumstance_conversation_two_c",
		database = "circumstance_vo_nurgle_rot",
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
					"nurgle_circumstance_conversation_two_b"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "nurgle_circumstance_prop_alive",
		category = "player_prio_2",
		wwise_route = 0,
		response = "nurgle_circumstance_prop_alive",
		database = "circumstance_vo_nurgle_rot",
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
				"nurgle_circumstance_prop_alive"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				40
			},
			{
				"faction_memory",
				"nurgle_circumstance_prop",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_prop",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "nurgle_circumstance_prop_growth",
		category = "player_prio_2",
		wwise_route = 0,
		response = "nurgle_circumstance_prop_growth",
		database = "circumstance_vo_nurgle_rot",
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
				"nurgle_circumstance_prop_growth"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				40
			},
			{
				"faction_memory",
				"nurgle_circumstance_prop",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_prop",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "nurgle_circumstance_prop_shrine",
		category = "player_prio_2",
		wwise_route = 0,
		response = "nurgle_circumstance_prop_shrine",
		database = "circumstance_vo_nurgle_rot",
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
				"nurgle_circumstance_prop_shrine"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				40
			},
			{
				"faction_memory",
				"nurgle_circumstance_prop",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_prop",
				OP.TIMESET
			}
		}
	})
	define_rule({
		concurrent_wwise_event = "play_vox_static_loop",
		wwise_route = 1,
		name = "nurgle_circumstance_start_a",
		response = "nurgle_circumstance_start_a",
		database = "circumstance_vo_nurgle_rot",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"start_banter"
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_nurgle_rot"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"pilot",
					"tech_priest",
					"explicator"
				}
			},
			{
				"faction_memory",
				"start_banter",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"start_banter",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "nurgle_circumstance_start_b",
		wwise_route = 0,
		response = "nurgle_circumstance_start_b",
		database = "circumstance_vo_nurgle_rot",
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
					"nurgle_circumstance_start_a"
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
		name = "nurgle_circumstance_start_c",
		response = "nurgle_circumstance_start_c",
		database = "circumstance_vo_nurgle_rot",
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
					"nurgle_circumstance_start_b"
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
end
