return function ()
	define_rule({
		name = "combat_pause_limited_psyker_c_01_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_01_a",
		database = "conversations_disabled",
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
					"veteran_female_b",
					"veteran_male_b"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_01_a",
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
				"combat_pause_limited_psyker_c_01_a",
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
		name = "combat_pause_limited_psyker_c_01_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_01_b",
		database = "conversations_disabled",
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
					"combat_pause_limited_psyker_c_01_a"
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
					"veteran_female_b",
					"veteran_male_b"
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
		name = "combat_pause_limited_psyker_c_03_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_03_a",
		database = "conversations_disabled",
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
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_03_a",
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
				"combat_pause_limited_psyker_c_03_a",
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
		name = "combat_pause_limited_psyker_c_03_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_03_b",
		database = "conversations_disabled",
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
					"combat_pause_limited_psyker_c_03_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a",
					"veteran_male_a",
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
		name = "combat_pause_limited_psyker_c_06_a",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_06_a",
		database = "conversations_disabled",
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
					"zealot_female_b",
					"zealot_male_b"
				}
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_06_a",
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
				"combat_pause_limited_psyker_c_06_a",
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
		name = "combat_pause_limited_psyker_c_06_b",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "combat_pause_limited_psyker_c_06_b",
		database = "conversations_disabled",
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
					"combat_pause_limited_psyker_c_06_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
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
		name = "lore_brunt_four_a",
		wwise_route = 0,
		response = "lore_brunt_four_a",
		database = "conversations_disabled",
		category = "conversations_prio_1",
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
				"user_context",
				"player_level",
				OP.GTEQ,
				10
			},
			{
				"user_context",
				"player_level",
				OP.LTEQ,
				23
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
				240
			},
			{
				"global_context",
				"team_lowest_player_level",
				OP.GTEQ,
				10
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"faction_memory",
				"lore_brunt",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				240
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"lore_brunt",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
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
		name = "lore_brunt_four_b",
		wwise_route = 0,
		response = "lore_brunt_four_b",
		database = "conversations_disabled",
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
				15
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"lore_brunt_four_a"
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
		name = "lore_brunt_four_c",
		wwise_route = 0,
		response = "lore_brunt_four_c",
		database = "conversations_disabled",
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
				15
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"lore_brunt_four_b"
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
		name = "lore_brunt_one_a",
		wwise_route = 0,
		response = "lore_brunt_one_a",
		database = "conversations_disabled",
		category = "conversations_prio_1",
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
				"user_context",
				"player_level",
				OP.GTEQ,
				1
			},
			{
				"user_context",
				"player_level",
				OP.LTEQ,
				15
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
				240
			},
			{
				"global_context",
				"team_lowest_player_level",
				OP.GTEQ,
				1
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"faction_memory",
				"lore_brunt",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				240
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"lore_brunt",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
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
		name = "lore_brunt_one_b",
		wwise_route = 0,
		response = "lore_brunt_one_b",
		database = "conversations_disabled",
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
				15
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"lore_brunt_one_a"
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
		name = "lore_brunt_one_c",
		wwise_route = 0,
		response = "lore_brunt_one_c",
		database = "conversations_disabled",
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
				15
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"lore_brunt_one_b"
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
		name = "lore_brunt_three_a",
		wwise_route = 0,
		response = "lore_brunt_three_a",
		database = "conversations_disabled",
		category = "conversations_prio_1",
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
				"user_context",
				"player_level",
				OP.GTEQ,
				10
			},
			{
				"user_context",
				"player_level",
				OP.LTEQ,
				23
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
				240
			},
			{
				"global_context",
				"team_lowest_player_level",
				OP.GTEQ,
				10
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"faction_memory",
				"lore_brunt",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				240
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"lore_brunt",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
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
		name = "lore_brunt_three_b",
		wwise_route = 0,
		response = "lore_brunt_three_b",
		database = "conversations_disabled",
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
				15
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"lore_brunt_three_a"
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
		name = "lore_brunt_three_c",
		wwise_route = 0,
		response = "lore_brunt_three_c",
		database = "conversations_disabled",
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
				15
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"lore_brunt_three_b"
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
		name = "lore_brunt_two_a",
		wwise_route = 0,
		response = "lore_brunt_two_a",
		database = "conversations_disabled",
		category = "conversations_prio_1",
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
				"user_context",
				"player_level",
				OP.GTEQ,
				7
			},
			{
				"user_context",
				"player_level",
				OP.LTEQ,
				23
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
				240
			},
			{
				"global_context",
				"team_lowest_player_level",
				OP.GTEQ,
				7
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
				"faction_memory",
				"lore_brunt_two",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				240
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"lore_brunt_two",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
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
		name = "lore_brunt_two_b",
		wwise_route = 0,
		response = "lore_brunt_two_b",
		database = "conversations_disabled",
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
				15
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"lore_brunt_two_a"
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
		name = "lore_brunt_two_c",
		wwise_route = 0,
		response = "lore_brunt_two_c",
		database = "conversations_disabled",
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
				15
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"lore_brunt_two_b"
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
end
