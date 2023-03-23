return function ()
	define_rule({
		name = "combat_pause_limited_psyker_c_02_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_02_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"zealot_female_a",
					"zealot_male_a"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_02_a",
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
				"combat_pause_limited_psyker_c_02_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_02_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_02_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_02_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"zealot_female_a",
					"zealot_male_a"
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
		name = "combat_pause_limited_psyker_c_04_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_04_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_a",
					"psyker_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_04_a",
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
				"combat_pause_limited_psyker_c_04_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_04_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_04_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_04_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
					"psyker_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c"
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
		name = "combat_pause_limited_psyker_c_05_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_05_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_c",
					"psyker_female_b",
					"psyker_male_b",
					"zealot_female_a",
					"zealot_male_a"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_05_a",
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
				"combat_pause_limited_psyker_c_05_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_05_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_05_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_05_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_c",
					"psyker_female_b",
					"psyker_male_b",
					"zealot_female_a",
					"zealot_male_a"
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
		name = "combat_pause_limited_psyker_c_07_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_07_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_b",
					"veteran_male_b",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_07_a",
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
				"combat_pause_limited_psyker_c_07_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_07_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_07_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_07_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b",
					"veteran_male_b",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c"
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
		name = "combat_pause_limited_psyker_c_08_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_08_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_b",
					"psyker_female_a",
					"psyker_male_a",
					"veteran_female_c",
					"veteran_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_08_a",
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
				"combat_pause_limited_psyker_c_08_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_08_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_08_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_08_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b",
					"psyker_female_a",
					"psyker_male_a",
					"veteran_female_c",
					"veteran_male_c"
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
		name = "combat_pause_limited_psyker_c_09_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_09_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_c",
					"psyker_female_a",
					"psyker_male_a",
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_09_a",
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
				"combat_pause_limited_psyker_c_09_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_09_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_09_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_09_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_c",
					"psyker_female_a",
					"psyker_male_a",
					"zealot_female_b",
					"zealot_male_b"
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
		name = "combat_pause_limited_psyker_c_10_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_10_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"psyker_female_b",
					"psyker_male_b"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_10_a",
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
				"combat_pause_limited_psyker_c_10_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_10_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_10_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_10_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
					"psyker_male_c",
					"ogryn_a",
					"psyker_female_b",
					"psyker_male_b"
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
		name = "combat_pause_limited_psyker_c_11_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_11_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"veteran_female_a",
					"veteran_male_a",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_11_a",
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
				"combat_pause_limited_psyker_c_11_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_11_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_11_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_11_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"veteran_female_a",
					"veteran_male_a",
					"zealot_female_c",
					"zealot_male_c"
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
		name = "combat_pause_limited_psyker_c_12_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_12_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_a",
					"veteran_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_12_a",
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
				"combat_pause_limited_psyker_c_12_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_12_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_12_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_12_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a",
					"veteran_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c"
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
		name = "combat_pause_limited_psyker_c_13_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_13_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_c",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_13_a",
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
				"combat_pause_limited_psyker_c_13_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_13_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_13_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_13_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_c",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_b",
					"zealot_male_b"
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
		name = "combat_pause_limited_psyker_c_14_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_14_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_14_a",
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
				"combat_pause_limited_psyker_c_14_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_14_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_14_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_14_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
					"psyker_male_c",
					"ogryn_a",
					"zealot_female_b",
					"zealot_male_b"
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
		name = "combat_pause_limited_psyker_c_15_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_15_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_a",
					"psyker_male_a",
					"veteran_female_a",
					"veteran_male_a",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_15_a",
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
				"combat_pause_limited_psyker_c_15_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_15_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_15_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_15_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
					"psyker_male_a",
					"veteran_female_a",
					"veteran_male_a",
					"zealot_female_c",
					"zealot_male_c"
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
		name = "combat_pause_limited_psyker_c_16_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_16_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_16_a",
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
				"combat_pause_limited_psyker_c_16_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_16_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_16_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_16_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c"
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
		name = "combat_pause_limited_psyker_c_17_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_17_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_c",
					"veteran_female_b",
					"veteran_male_b",
					"zealot_female_a",
					"zealot_male_a"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_17_a",
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
				"combat_pause_limited_psyker_c_17_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_17_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_17_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_17_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_c",
					"veteran_female_b",
					"veteran_male_b",
					"zealot_female_a",
					"zealot_male_a"
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
		name = "combat_pause_limited_psyker_c_18_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_18_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_b",
					"veteran_female_a",
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_18_a",
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
				"combat_pause_limited_psyker_c_18_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_18_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_18_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_18_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
					"psyker_male_c",
					"ogryn_b",
					"veteran_female_a",
					"veteran_male_a"
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
		name = "combat_pause_limited_psyker_c_19_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_19_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_a",
					"psyker_male_a",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_19_a",
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
				"combat_pause_limited_psyker_c_19_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_19_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_19_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_19_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
					"psyker_male_a",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_c",
					"zealot_male_c"
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
		name = "combat_pause_limited_psyker_c_20_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_20_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_b",
					"psyker_female_b",
					"psyker_male_b",
					"veteran_female_c",
					"veteran_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_20_a",
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
				"combat_pause_limited_psyker_c_20_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_psyker_c_20_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_20_b",
		database = "psyker_c",
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
					"combat_pause_limited_psyker_c_20_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b",
					"psyker_female_b",
					"psyker_male_b",
					"veteran_female_c",
					"veteran_male_c"
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
		name = "combat_pause_quirk_concerning_enforcers_a",
		wwise_route = 0,
		response = "combat_pause_quirk_concerning_enforcers_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_male_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_quirk_concerning_enforcers_a",
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
				"combat_pause_quirk_concerning_enforcers_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_quirk_concerning_enforcers_b",
		wwise_route = 0,
		response = "combat_pause_quirk_concerning_enforcers_b",
		database = "psyker_c",
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
					"combat_pause_quirk_concerning_enforcers_a"
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
		name = "combat_pause_quirk_local_knowledge_a",
		wwise_route = 0,
		response = "combat_pause_quirk_local_knowledge_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_male_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_quirk_local_knowledge_a",
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
				"combat_pause_quirk_local_knowledge_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_quirk_local_knowledge_b",
		wwise_route = 0,
		response = "combat_pause_quirk_local_knowledge_b",
		database = "psyker_c",
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
					"combat_pause_quirk_local_knowledge_a"
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
		name = "combat_pause_quirk_messelina_a",
		wwise_route = 0,
		response = "combat_pause_quirk_messelina_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_male_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_quirk_messelina_a",
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
				"combat_pause_quirk_messelina_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_quirk_messelina_b",
		wwise_route = 0,
		response = "combat_pause_quirk_messelina_b",
		database = "psyker_c",
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
					"combat_pause_quirk_messelina_a"
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
		name = "combat_pause_quirk_tertium_splendour_a",
		wwise_route = 0,
		response = "combat_pause_quirk_tertium_splendour_a",
		database = "psyker_c",
		category = "conversations_prio_1",
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
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_male_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_quirk_tertium_splendour_a",
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
				"combat_pause_quirk_tertium_splendour_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "combat_pause_quirk_tertium_splendour_b",
		wwise_route = 0,
		response = "combat_pause_quirk_tertium_splendour_b",
		database = "psyker_c",
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
					"combat_pause_quirk_tertium_splendour_a"
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
end
