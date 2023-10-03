return function ()
	define_rule({
		name = "bonding_conversation_crowds_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_crowds_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_crowds_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_veteran_seen_killstreak_zealot_user",
				OP.TIMEDIFF,
				OP.LT,
				45
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_crowds_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_crowds_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_crowds_b",
		wwise_route = 0,
		response = "bonding_conversation_crowds_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_crowds_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_crowds_b_user",
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
		name = "bonding_conversation_crowds_c",
		wwise_route = 0,
		response = "bonding_conversation_crowds_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_crowds_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_crowds_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_crowds_d",
		wwise_route = 0,
		response = "bonding_conversation_crowds_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_crowds_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_crowds_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_faith_renewed_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_faith_renewed_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_faith_renewed_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_veteran_seen_killstreak_zealot_user",
				OP.TIMEDIFF,
				OP.LT,
				45
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_faith_renewed_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_faith_renewed_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_faith_renewed_b",
		wwise_route = 0,
		response = "bonding_conversation_faith_renewed_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_faith_renewed_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_faith_renewed_b_user",
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
		name = "bonding_conversation_faith_renewed_c",
		wwise_route = 0,
		response = "bonding_conversation_faith_renewed_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_faith_renewed_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_faith_renewed_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_faith_renewed_d",
		wwise_route = 0,
		response = "bonding_conversation_faith_renewed_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_faith_renewed_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_faith_renewed_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_heavy_injury_05_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_05_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_05_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_05_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_05_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_05_b",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_05_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_heavy_injury_05_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.LT,
				75
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_heavy_injury_05_b_user",
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
		name = "bonding_conversation_heavy_injury_05_c",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_05_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_heavy_injury_05_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_05_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_heavy_injury_05_d",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_05_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_heavy_injury_05_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_05_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_heavy_injury_06_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_06_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_06_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_06_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_06_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_06_b",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_06_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_heavy_injury_06_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.LT,
				75
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_heavy_injury_06_b_user",
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
		name = "bonding_conversation_heavy_injury_06_c",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_06_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_heavy_injury_06_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_06_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_heavy_injury_06_d",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_06_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_heavy_injury_06_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_06_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_heavy_injury_07_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_07_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_07_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_07_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_07_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_07_b",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_07_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_heavy_injury_07_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.LT,
				75
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_heavy_injury_07_b_user",
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
		name = "bonding_conversation_heavy_injury_07_c",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_07_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_heavy_injury_07_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_07_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_heavy_injury_07_d",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_07_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_heavy_injury_07_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_07_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_heavy_injury_08_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_08_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_08_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_08_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_08_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_08_b",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_08_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_heavy_injury_08_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.LT,
				75
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_heavy_injury_08_b_user",
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
		name = "bonding_conversation_heavy_injury_08_c",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_08_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_heavy_injury_08_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_08_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_heavy_injury_08_d",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_08_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_heavy_injury_08_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_08_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_lessons_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_lessons_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_lessons_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"time_since_friendly_fire_from_psyker_to_veteran",
				OP.TIMEDIFF,
				OP.LT,
				35
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_lessons_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_lessons_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_lessons_b",
		wwise_route = 0,
		response = "bonding_conversation_lessons_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_lessons_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_lessons_b_user",
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
		name = "bonding_conversation_lessons_c",
		wwise_route = 0,
		response = "bonding_conversation_lessons_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_lessons_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_lessons_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_lessons_d",
		wwise_route = 0,
		response = "bonding_conversation_lessons_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_lessons_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_lessons_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_chance_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_chance_a",
		database = "veteran_female_a",
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
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_chance_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_chance_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_chance_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_chance_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_chance_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_chance_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_chance_b_user",
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
		name = "bonding_conversation_metropolitan_chance_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_chance_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_chance_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_chance_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_chance_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_chance_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_chance_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_chance_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_charm_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_charm_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_charm_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_charm_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_charm_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_charm_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_charm_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_charm_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_charm_b_user",
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
		name = "bonding_conversation_metropolitan_charm_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_charm_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_charm_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_charm_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_charm_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_charm_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_charm_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_charm_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_compliment_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_compliment_a",
		database = "veteran_female_a",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_ogryn_a__combat_pause_quirk_trial_b_01",
					"loc_ogryn_a__combat_pause_limited_veteran_a_16_b_02",
					"loc_ogryn_a__combat_pause_limited_veteran_a_14_b_01",
					"loc_ogryn_a__combat_pause_limited_veteran_a_14_b_02",
					"loc_ogryn_a__combat_pause_one_liner_09"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_compliment_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_compliment_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_compliment_a_user",
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
		name = "bonding_conversation_metropolitan_compliment_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_compliment_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_compliment_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_compliment_b_user",
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
		name = "bonding_conversation_metropolitan_compliment_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_compliment_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_compliment_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_compliment_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_compliment_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_compliment_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_compliment_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_compliment_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_compliment_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_compliment_e",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_compliment_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_compliment_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_compliment_f",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_compliment_f",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_compliment_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_compliment_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_contest_vet_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_contest_vet_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_contest_vet_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_contest_vet_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_contest_vet_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_contest_vet_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_contest_vet_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_contest_vet_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_contest_vet_b_user",
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
		name = "bonding_conversation_metropolitan_contest_vet_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_contest_vet_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_contest_vet_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_contest_vet_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_contest_vet_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_contest_vet_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_contest_vet_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_contest_vet_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_energy_vet_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_energy_vet_a",
		database = "veteran_female_a",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_zealot_female_b__combat_pause_one_liner_02",
					"loc_zealot_female_b__combat_pause_one_liner_04",
					"loc_zealot_female_b__combat_pause_one_liner_07",
					"loc_zealot_female_b__combat_pause_one_liner_08"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_energy_vet_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_energy_vet_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_energy_vet_a_user",
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
		name = "bonding_conversation_metropolitan_energy_vet_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_energy_vet_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_energy_vet_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_energy_vet_b_user",
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
		name = "bonding_conversation_metropolitan_energy_vet_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_energy_vet_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_energy_vet_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_energy_vet_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_energy_vet_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_energy_vet_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_energy_vet_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_energy_vet_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_following_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_following_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.LT,
				450
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_following_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_following_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_following_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_following_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_following_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_following_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_following_b_user",
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
		name = "bonding_conversation_metropolitan_following_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_following_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_following_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_following_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_following_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_following_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_following_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_following_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_following_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_following_e",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_following_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_following_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_following_f",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_following_f",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_following_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_following_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_friends_vet_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_friends_vet_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_friends_vet_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_friends_vet_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_friends_vet_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_friends_vet_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_friends_vet_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_friends_vet_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_friends_vet_b_user",
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
		name = "bonding_conversation_metropolitan_friends_vet_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_friends_vet_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_friends_vet_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_friends_vet_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_friends_vet_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_friends_vet_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_friends_vet_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_friends_vet_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_going_to_hel_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_going_to_hel_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_going_to_hel_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_going_to_hel_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_going_to_hel_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_going_to_hel_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_going_to_hel_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_going_to_hel_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_going_to_hel_b_user",
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
		name = "bonding_conversation_metropolitan_going_to_hel_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_going_to_hel_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_going_to_hel_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_going_to_hel_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_going_to_hel_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_going_to_hel_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_going_to_hel_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_going_to_hel_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_going_to_hel_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_going_to_hel_e",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_going_to_hel_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_going_to_hel_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_grave_mystery_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_grave_mystery_a",
		database = "veteran_female_a",
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
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_grave_mystery_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_grave_mystery_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_grave_mystery_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_grave_mystery_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_grave_mystery_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_grave_mystery_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_grave_mystery_b_user",
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
		name = "bonding_conversation_metropolitan_grave_mystery_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_grave_mystery_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_grave_mystery_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_grave_mystery_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_grave_mystery_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_grave_mystery_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_grave_mystery_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_grave_mystery_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_grave_mystery_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_grave_mystery_e",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_grave_mystery_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_grave_mystery_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_grave_mystery_f",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_grave_mystery_f",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_grave_mystery_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_grave_mystery_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_leaders_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_leaders_a",
		database = "veteran_female_a",
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
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_leaders_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_leaders_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_leaders_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_leaders_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_leaders_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_leaders_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_leaders_b_user",
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
		name = "bonding_conversation_metropolitan_leaders_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_leaders_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_leaders_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_leaders_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_leaders_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_leaders_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_leaders_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_leaders_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_leaders_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_leaders_e",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_leaders_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_leaders_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_mood_vet_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_mood_vet_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_mood_vet_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_mood_vet_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_mood_vet_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_mood_vet_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_mood_vet_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_mood_vet_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_mood_vet_b_user",
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
		name = "bonding_conversation_metropolitan_mood_vet_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_mood_vet_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_mood_vet_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_mood_vet_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_mood_vet_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_mood_vet_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_mood_vet_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_mood_vet_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_politics_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_politics_a",
		database = "veteran_female_a",
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
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_politics_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_politics_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_politics_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_politics_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_politics_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_politics_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_politics_b_user",
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
		name = "bonding_conversation_metropolitan_politics_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_politics_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_politics_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_politics_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_politics_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_politics_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_politics_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_politics_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_premonition_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_premonition_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_premonition_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_premonition_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_premonition_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_premonition_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_premonition_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_premonition_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_premonition_b_user",
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
		name = "bonding_conversation_metropolitan_premonition_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_premonition_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_premonition_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_premonition_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_premonition_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_premonition_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_premonition_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_premonition_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_shot_at_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_shot_at_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_shot_at_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_shot_at_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_shot_at_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_shot_at_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_shot_at_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_shot_at_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_shot_at_b_user",
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
		name = "bonding_conversation_metropolitan_shot_at_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_shot_at_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_shot_at_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_shot_at_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_shot_at_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_shot_at_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_shot_at_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_shot_at_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_shot_at_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_shot_at_e",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_shot_at_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_shot_at_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_spelling_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_spelling_a",
		database = "veteran_female_a",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_ogryn_a__combat_pause_one_liner_01",
					"loc_ogryn_a__combat_pause_one_liner_02",
					"loc_ogryn_a__combat_pause_one_liner_04"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_spelling_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_spelling_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_spelling_a_user",
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
		name = "bonding_conversation_metropolitan_spelling_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_spelling_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_spelling_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_spelling_b_user",
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
		name = "bonding_conversation_metropolitan_spelling_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_spelling_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_spelling_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_spelling_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_spelling_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_spelling_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_spelling_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_spelling_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_vigilance_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_vigilance_a",
		database = "veteran_female_a",
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
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_vigilance_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_vigilance_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_vigilance_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_vigilance_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_vigilance_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_vigilance_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_vigilance_b_user",
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
		name = "bonding_conversation_metropolitan_vigilance_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_vigilance_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_vigilance_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_vigilance_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_vigilance_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_vigilance_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_vigilance_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_vigilance_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_vigilance_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_vigilance_e",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_vigilance_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_vigilance_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_worse_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_worse_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_worse_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_worse_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_worse_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_worse_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_worse_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_worse_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_worse_b_user",
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
		name = "bonding_conversation_metropolitan_worse_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_worse_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_worse_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_worse_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_metropolitan_worse_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_worse_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_metropolitan_worse_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_worse_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_round_three_attention_a",
		wwise_route = 0,
		response = "bonding_conversation_round_three_attention_a",
		database = "veteran_female_a",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_psyker_female_a__away_from_squad_01",
					"loc_psyker_female_a__away_from_squad_02",
					"loc_psyker_female_a__away_from_squad_03",
					"loc_psyker_female_a__away_from_squad_04",
					"loc_psyker_female_a__away_from_squad_05"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_attention_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"dummy_memory_to_evaluate_above_come_back_to_squad",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"dummy_memory_to_evaluate_above_come_back_to_squad_2",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_attention_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_round_three_attention_a_user",
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
		name = "bonding_conversation_round_three_attention_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_attention_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_round_three_attention_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_round_three_attention_b_user",
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
		name = "bonding_conversation_round_three_attention_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_attention_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_round_three_attention_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_round_three_attention_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_round_three_attention_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_attention_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_round_three_attention_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_round_three_attention_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_round_three_head_down_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_round_three_head_down_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_head_down_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_shot_psyker_user",
				OP.TIMEDIFF,
				OP.LT,
				30
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_head_down_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_round_three_head_down_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_round_three_head_down_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_head_down_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_round_three_head_down_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_round_three_head_down_b_user",
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
		name = "bonding_conversation_round_three_head_down_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_head_down_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_round_three_head_down_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_round_three_head_down_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_round_three_head_down_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_head_down_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_round_three_head_down_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_round_three_head_down_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_round_three_old_days_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_round_three_old_days_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_old_days_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_old_days_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_round_three_old_days_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_round_three_old_days_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_old_days_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_round_three_old_days_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_round_three_old_days_b_user",
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
		name = "bonding_conversation_round_three_old_days_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_old_days_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_round_three_old_days_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_round_three_old_days_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_round_three_old_days_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_old_days_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_round_three_old_days_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_round_three_old_days_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_round_three_spiders_a",
		wwise_route = 0,
		response = "bonding_conversation_round_three_spiders_a",
		database = "veteran_female_a",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_psyker_female_a__away_from_squad_06",
					"loc_psyker_female_a__away_from_squad_07",
					"loc_psyker_female_a__away_from_squad_08",
					"loc_psyker_female_a__away_from_squad_09",
					"loc_psyker_female_a__away_from_squad_10"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_spiders_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"dummy_memory_to_evaluate_above_come_back_to_squad",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"dummy_memory_to_evaluate_above_come_back_to_squad_2",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_spiders_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_round_three_spiders_a_user",
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
		name = "bonding_conversation_round_three_spiders_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_spiders_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_round_three_spiders_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_round_three_spiders_b_user",
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
		name = "bonding_conversation_round_three_spiders_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_spiders_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_round_three_spiders_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_round_three_spiders_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_round_three_spiders_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_spiders_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_round_three_spiders_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_round_three_spiders_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_shooting_back_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_shooting_back_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_shooting_back_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_shooting_back_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_shooting_back_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_shooting_back_b",
		wwise_route = 0,
		response = "bonding_conversation_shooting_back_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_shooting_back_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_shooting_back_b_user",
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
		name = "bonding_conversation_shooting_back_c",
		wwise_route = 0,
		response = "bonding_conversation_shooting_back_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_shooting_back_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_shooting_back_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_shooting_back_d",
		wwise_route = 0,
		response = "bonding_conversation_shooting_back_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_shooting_back_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_shooting_back_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_smear_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_smear_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_smear_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"response_for_pinned_by_enemies_zealot",
				OP.TIMEDIFF,
				OP.LT,
				45
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_smear_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_smear_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_smear_b",
		wwise_route = 0,
		response = "bonding_conversation_smear_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_smear_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_smear_b_user",
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
		name = "bonding_conversation_smear_c",
		wwise_route = 0,
		response = "bonding_conversation_smear_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_smear_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_smear_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_smear_d",
		wwise_route = 0,
		response = "bonding_conversation_smear_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_smear_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_smear_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_spy_proof_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_spy_proof_a",
		database = "veteran_female_a",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
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
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_spy_proof_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_spy_proof_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_spy_proof_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_spy_proof_b",
		wwise_route = 0,
		response = "bonding_conversation_spy_proof_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_spy_proof_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_spy_proof_b_user",
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
		name = "bonding_conversation_spy_proof_c",
		wwise_route = 0,
		response = "bonding_conversation_spy_proof_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_spy_proof_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_spy_proof_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_spy_proof_d",
		wwise_route = 0,
		response = "bonding_conversation_spy_proof_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_spy_proof_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_spy_proof_b_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_toadies_three_a",
		wwise_route = 0,
		response = "bonding_conversation_toadies_three_a",
		database = "veteran_female_a",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_ogryn_d__combat_pause_limited_veteran_a_15_b_01",
					"loc_ogryn_d__combat_pause_limited_veteran_a_16_b_02",
					"loc_ogryn_d__combat_pause_quirk_discipline_b_02",
					"loc_ogryn_d__combat_pause_quirk_nostalgia_b_01"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_toadies_three_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_toadies_three_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_toadies_three_a_user",
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
		name = "bonding_conversation_toadies_three_b",
		wwise_route = 0,
		response = "bonding_conversation_toadies_three_b",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_toadies_three_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_toadies_three_b_user",
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
		name = "bonding_conversation_toadies_three_c",
		wwise_route = 0,
		response = "bonding_conversation_toadies_three_c",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_toadies_three_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_toadies_three_a_user",
				OP.EQ,
				1
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
		name = "bonding_conversation_toadies_three_d",
		wwise_route = 0,
		response = "bonding_conversation_toadies_three_d",
		database = "veteran_female_a",
		category = "conversations_prio_1",
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
					"bonding_conversation_toadies_three_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			},
			{
				"user_memory",
				"bonding_conversation_toadies_three_b_user",
				OP.EQ,
				1
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
end
