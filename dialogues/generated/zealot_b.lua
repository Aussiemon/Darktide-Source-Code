return function ()
	define_rule({
		name = "combat_pause_limited_zealot_b_01_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_01_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
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
				"combat_pause_limited_zealot_b_01_a",
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
				"combat_pause_limited_zealot_b_01_a",
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
		name = "combat_pause_limited_zealot_b_01_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_01_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_01_a"
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
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_zealot_b_02_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_02_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_02_a",
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
				"combat_pause_limited_zealot_b_02_a",
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
		name = "combat_pause_limited_zealot_b_02_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_02_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_02_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
					"zealot_male_b",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"zealot_female_c",
					"zealot_male_c"
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
		name = "combat_pause_limited_zealot_b_03_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_03_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_03_a",
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
				"combat_pause_limited_zealot_b_03_a",
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
		name = "combat_pause_limited_zealot_b_03_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_03_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_03_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a"
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
		name = "combat_pause_limited_zealot_b_04_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_04_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
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
					"veteran_female_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_04_a",
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
				"combat_pause_limited_zealot_b_04_a",
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
		name = "combat_pause_limited_zealot_b_04_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_04_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_04_a"
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
					"veteran_female_c"
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
		name = "combat_pause_limited_zealot_b_05_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_05_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"zealot_female_a",
					"zealot_male_a"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_05_a",
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
				"combat_pause_limited_zealot_b_05_a",
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
		name = "combat_pause_limited_zealot_b_05_b",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_05_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_05_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"zealot_female_a",
					"zealot_male_a"
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
		name = "combat_pause_limited_zealot_b_06_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_06_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_a",
					"veteran_male_a",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_06_a",
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
				"combat_pause_limited_zealot_b_06_a",
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
		name = "combat_pause_limited_zealot_b_06_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_06_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_06_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
					"zealot_male_b",
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
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_zealot_b_07_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_07_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_07_a",
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
				"combat_pause_limited_zealot_b_07_a",
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
		name = "combat_pause_limited_zealot_b_07_b",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_07_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_07_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
					"zealot_male_b",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_c",
					"zealot_male_c"
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
		name = "combat_pause_limited_zealot_b_08_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_08_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"psyker_female_a",
					"psyker_male_a"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_08_a",
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
				"combat_pause_limited_zealot_b_08_a",
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
		name = "combat_pause_limited_zealot_b_08_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_08_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_08_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"psyker_female_a",
					"psyker_male_a"
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
		name = "combat_pause_limited_zealot_b_09_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_09_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_a",
					"psyker_male_a",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_09_a",
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
				"combat_pause_limited_zealot_b_09_a",
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
		name = "combat_pause_limited_zealot_b_09_b",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_09_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_09_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
					"zealot_male_b",
					"psyker_female_a",
					"psyker_male_a",
					"zealot_female_c",
					"zealot_male_c"
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
		name = "combat_pause_limited_zealot_b_10_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_10_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_10_a",
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
				"combat_pause_limited_zealot_b_10_a",
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
		name = "combat_pause_limited_zealot_b_10_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_10_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_10_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c"
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
		name = "combat_pause_limited_zealot_b_11_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_11_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_11_a",
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
				"combat_pause_limited_zealot_b_11_a",
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
		name = "combat_pause_limited_zealot_b_11_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_11_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_11_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a"
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
		name = "combat_pause_limited_zealot_b_12_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_12_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_a",
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_12_a",
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
				"combat_pause_limited_zealot_b_12_a",
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
		name = "combat_pause_limited_zealot_b_12_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_12_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_12_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a",
					"veteran_male_a"
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
		name = "combat_pause_limited_zealot_b_13_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_13_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_13_a",
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
				"combat_pause_limited_zealot_b_13_a",
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
		name = "combat_pause_limited_zealot_b_13_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_13_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_13_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
					"zealot_male_b",
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
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_zealot_b_14_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_14_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_b",
					"ogryn_c",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_14_a",
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
				"combat_pause_limited_zealot_b_14_a",
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
		name = "combat_pause_limited_zealot_b_14_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_14_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_14_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
					"zealot_male_b",
					"ogryn_b",
					"ogryn_c",
					"zealot_female_c",
					"zealot_male_c"
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
		name = "combat_pause_limited_zealot_b_15_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_15_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_a",
					"psyker_male_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_15_a",
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
				"combat_pause_limited_zealot_b_15_a",
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
		name = "combat_pause_limited_zealot_b_15_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_15_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_15_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
					"psyker_male_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c"
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
		name = "combat_pause_limited_zealot_b_16_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_16_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_b",
					"ogryn_c",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_16_a",
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
				"combat_pause_limited_zealot_b_16_a",
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
		name = "combat_pause_limited_zealot_b_16_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_16_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_16_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b",
					"ogryn_c",
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
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "combat_pause_limited_zealot_b_17_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_17_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_17_a",
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
				"combat_pause_limited_zealot_b_17_a",
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
		name = "combat_pause_limited_zealot_b_17_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_17_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_17_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a"
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
		name = "combat_pause_limited_zealot_b_18_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_18_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_18_a",
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
				"combat_pause_limited_zealot_b_18_a",
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
		name = "combat_pause_limited_zealot_b_18_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_18_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_18_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a"
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
		name = "combat_pause_limited_zealot_b_19_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_19_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
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
					"zealot_male_a"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_19_a",
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
				"combat_pause_limited_zealot_b_19_a",
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
		name = "combat_pause_limited_zealot_b_19_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_19_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_19_a"
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
					"zealot_male_a"
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
		name = "combat_pause_limited_zealot_b_20_a",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_20_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_zealot_b_20_a",
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
				"combat_pause_limited_zealot_b_20_a",
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
		name = "combat_pause_limited_zealot_b_20_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_zealot_b_20_b",
		database = "zealot_b",
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
					"combat_pause_limited_zealot_b_20_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c"
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
		name = "combat_pause_quirk_ammo_a",
		wwise_route = 0,
		response = "combat_pause_quirk_ammo_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
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
				"user_context",
				"total_ammo_percentage",
				OP.LT,
				0.1
			},
			{
				"faction_memory",
				"combat_pause_quirk_ammo_a",
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
				"combat_pause_quirk_ammo_a",
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
		name = "combat_pause_quirk_ammo_b",
		wwise_route = 0,
		response = "combat_pause_quirk_ammo_b",
		database = "zealot_b",
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
					"combat_pause_quirk_ammo_a"
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
		name = "combat_pause_quirk_anger_a",
		wwise_route = 0,
		response = "combat_pause_quirk_anger_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
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
				"combat_pause_quirk_anger_a",
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
				"combat_pause_quirk_anger_a",
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
		name = "combat_pause_quirk_anger_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_quirk_anger_b",
		database = "zealot_b",
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
					"combat_pause_quirk_anger_a"
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
		name = "combat_pause_quirk_defend_a",
		wwise_route = 0,
		response = "combat_pause_quirk_defend_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
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
				"combat_pause_quirk_defend_a",
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
				"combat_pause_quirk_defend_a",
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
		name = "combat_pause_quirk_defend_b",
		wwise_route = 0,
		response = "combat_pause_quirk_defend_b",
		database = "zealot_b",
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
					"combat_pause_quirk_defend_a"
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
		name = "combat_pause_quirk_drink_a",
		wwise_route = 0,
		response = "combat_pause_quirk_drink_a",
		database = "zealot_b",
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
				180
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
					"zealot_female_b",
					"zealot_male_b"
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
				"combat_pause_quirk_drink_a",
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
				"combat_pause_quirk_drink_a",
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
		name = "combat_pause_quirk_drink_b",
		wwise_route = 0,
		response = "combat_pause_quirk_drink_b",
		database = "zealot_b",
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
					"combat_pause_quirk_drink_a"
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
		name = "combat_pause_quirk_endless_a",
		wwise_route = 0,
		response = "combat_pause_quirk_endless_a",
		database = "zealot_b",
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
				600
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
					"zealot_female_b",
					"zealot_male_b"
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
				"combat_pause_quirk_endless_a",
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
				"combat_pause_quirk_endless_a",
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
		name = "combat_pause_quirk_endless_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_quirk_endless_b",
		database = "zealot_b",
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
					"combat_pause_quirk_endless_a"
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
		name = "combat_pause_quirk_flame_a",
		wwise_route = 0,
		response = "combat_pause_quirk_flame_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
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
				"combat_pause_quirk_flame_a",
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
				"combat_pause_quirk_flame_a",
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
		name = "combat_pause_quirk_flame_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_quirk_flame_b",
		database = "zealot_b",
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
					"combat_pause_quirk_flame_a"
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
		name = "combat_pause_quirk_speed_a",
		wwise_route = 0,
		response = "combat_pause_quirk_speed_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
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
				"combat_pause_quirk_speed_a",
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
				"combat_pause_quirk_speed_a",
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
		name = "combat_pause_quirk_speed_b",
		wwise_route = 0,
		response = "combat_pause_quirk_speed_b",
		database = "zealot_b",
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
					"combat_pause_quirk_speed_a"
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
		name = "combat_pause_quirk_trial_a",
		wwise_route = 0,
		response = "combat_pause_quirk_trial_a",
		database = "zealot_b",
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
					"zealot_female_b",
					"zealot_male_b"
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
				"combat_pause_quirk_trial_a",
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
				"combat_pause_quirk_trial_a",
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
		name = "combat_pause_quirk_trial_b",
		wwise_route = 0,
		response = "combat_pause_quirk_trial_b",
		database = "zealot_b",
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
					"combat_pause_quirk_trial_a"
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
		name = "flamer_kill_spree_self_a",
		category = "player_prio_1",
		wwise_route = 0,
		response = "flamer_kill_spree_self_a",
		database = "zealot_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"kill_spree_self"
			},
			{
				"user_context",
				"weapon_type",
				OP.SET_INCLUDES,
				args = {
					"flamer_p1_m1"
				}
			},
			{
				"user_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				3
			},
			{
				"user_memory",
				"last_kill_spree",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"user_memory",
				"last_kill_spree",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
end
