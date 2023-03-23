return function ()
	define_rule({
		name = "bonding_conversation_confess_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_confess_a",
		database = "veteran_male_a",
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
					"veteran_male_a"
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
				"bonding_conversation_confess_a",
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
				"bonding_conversation_confess_a",
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
				"bonding_conversation_confess_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_confess_b",
		wwise_route = 0,
		response = "bonding_conversation_confess_b",
		database = "veteran_male_a",
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
					"bonding_conversation_confess_a"
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
				"bonding_conversation_confess_b_user",
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
		name = "bonding_conversation_confess_c",
		wwise_route = 0,
		response = "bonding_conversation_confess_c",
		database = "veteran_male_a",
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
					"bonding_conversation_confess_b"
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
				"bonding_conversation_confess_a_user",
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
		name = "bonding_conversation_confess_d",
		wwise_route = 0,
		response = "bonding_conversation_confess_d",
		database = "veteran_male_a",
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
					"bonding_conversation_confess_c"
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
				"bonding_conversation_confess_b_user",
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
		name = "bonding_conversation_confess_e",
		wwise_route = 0,
		response = "bonding_conversation_confess_e",
		database = "veteran_male_a",
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
					"bonding_conversation_confess_d"
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
				"bonding_conversation_confess_a_user",
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
		name = "bonding_conversation_good_soldier_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_good_soldier_a",
		database = "veteran_male_a",
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
					"veteran_male_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_good_soldier_a",
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
				"bonding_conversation_good_soldier_a",
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
				"bonding_conversation_good_soldier_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_good_soldier_b",
		wwise_route = 0,
		response = "bonding_conversation_good_soldier_b",
		database = "veteran_male_a",
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
					"bonding_conversation_good_soldier_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_c"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_good_soldier_b_user",
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
		name = "bonding_conversation_good_soldier_c",
		wwise_route = 0,
		response = "bonding_conversation_good_soldier_c",
		database = "veteran_male_a",
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
					"bonding_conversation_good_soldier_b"
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
				"bonding_conversation_good_soldier_a_user",
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
		name = "bonding_conversation_good_soldier_d",
		wwise_route = 0,
		response = "bonding_conversation_good_soldier_d",
		database = "veteran_male_a",
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
					"bonding_conversation_good_soldier_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_good_soldier_b_user",
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
		name = "bonding_conversation_good_soldier_e",
		wwise_route = 0,
		response = "bonding_conversation_good_soldier_e",
		database = "veteran_male_a",
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
					"bonding_conversation_good_soldier_d"
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
				"bonding_conversation_good_soldier_a_user",
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
		name = "bonding_conversation_good_soldier_two_a",
		wwise_route = 0,
		response = "bonding_conversation_good_soldier_two_a",
		database = "veteran_male_a",
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
					"loc_psyker_male_c__combat_pause_limited_psyker_b_05_b_01",
					"loc_psyker_male_c__combat_pause_limited_ogryn_a_15_b_01",
					"loc_psyker_male_c__combat_pause_quirk_discipline_b_01",
					"loc_psyker_male_c__combat_pause_one_liner_10",
					"loc_psyker_male_c__combat_pause_quirk_desert_b_02",
					"loc_psyker_male_c__combat_pause_quirk_accuracy_b_01",
					"loc_psyker_male_c__combat_pause_limited_zealot_b_05_b_01"
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
				"faction_memory",
				"bonding_conversation_good_soldier_two_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_good_soldier_two_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_good_soldier_two_a_user",
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
		name = "bonding_conversation_good_soldier_two_b",
		wwise_route = 0,
		response = "bonding_conversation_good_soldier_two_b",
		database = "veteran_male_a",
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
					"bonding_conversation_good_soldier_two_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_good_soldier_two_b_user",
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
		name = "bonding_conversation_good_soldier_two_c",
		wwise_route = 0,
		response = "bonding_conversation_good_soldier_two_c",
		database = "veteran_male_a",
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
					"bonding_conversation_good_soldier_two_b"
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
				"bonding_conversation_good_soldier_two_a_user",
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
		name = "bonding_conversation_good_soldier_two_d",
		wwise_route = 0,
		response = "bonding_conversation_good_soldier_two_d",
		database = "veteran_male_a",
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
					"bonding_conversation_good_soldier_two_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_good_soldier_two_b_user",
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
		name = "bonding_conversation_good_soldier_two_e",
		wwise_route = 0,
		response = "bonding_conversation_good_soldier_two_e",
		database = "veteran_male_a",
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
					"bonding_conversation_good_soldier_two_d"
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
				"bonding_conversation_good_soldier_two_a_user",
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
		name = "bonding_conversation_good_soldier_two_f",
		wwise_route = 0,
		response = "bonding_conversation_good_soldier_two_f",
		database = "veteran_male_a",
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
					"bonding_conversation_good_soldier_two_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_good_soldier_two_b_user",
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
		name = "bonding_conversation_headshot_extension_vet_a_ogr_b_b",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_ogr_b_b",
		database = "veteran_male_a",
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
					"loc_ogryn_b__head_shot_01",
					"loc_ogryn_b__head_shot_02",
					"loc_ogryn_b__head_shot_03",
					"loc_ogryn_b__head_shot_04",
					"loc_ogryn_b__head_shot_05",
					"loc_ogryn_b__head_shot_06",
					"loc_ogryn_b__head_shot_07",
					"loc_ogryn_b__head_shot_08",
					"loc_ogryn_b__head_shot_09",
					"loc_ogryn_b__head_shot_10"
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
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_headshot",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_headshot_user",
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
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_a_ogr_b_c",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_ogr_b_c",
		database = "veteran_male_a",
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
					"bonding_conversation_headshot_extension_vet_a_ogr_b_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b"
				}
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_headshot_replier",
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
		name = "bonding_conversation_headshot_extension_vet_a_ogr_b_d",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_ogr_b_d",
		database = "veteran_male_a",
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
					"bonding_conversation_headshot_extension_vet_a_ogr_b_c"
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
				"bonding_conversation_headshot_user",
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
		name = "bonding_conversation_headshot_extension_vet_a_ogr_b_e",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_ogr_b_e",
		database = "veteran_male_a",
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
					"bonding_conversation_headshot_extension_vet_a_ogr_b_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_headshot_replier",
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
		name = "bonding_conversation_headshot_extension_vet_a_psy_c_b",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_psy_c_b",
		database = "veteran_male_a",
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
					"loc_psyker_male_c__head_shot_01",
					"loc_psyker_male_c__head_shot_02",
					"loc_psyker_male_c__head_shot_03",
					"loc_psyker_male_c__head_shot_04",
					"loc_psyker_male_c__head_shot_05",
					"loc_psyker_male_c__head_shot_06",
					"loc_psyker_male_c__head_shot_07",
					"loc_psyker_male_c__head_shot_08",
					"loc_psyker_male_c__head_shot_09",
					"loc_psyker_male_c__head_shot_10"
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
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_headshot",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_headshot_user",
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
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_a_psy_c_c",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_psy_c_c",
		database = "veteran_male_a",
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
					"bonding_conversation_headshot_extension_vet_a_psy_c_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c"
				}
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_headshot_replier",
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
		name = "bonding_conversation_headshot_extension_vet_a_psy_c_d",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_psy_c_d",
		database = "veteran_male_a",
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
					"bonding_conversation_headshot_extension_vet_a_psy_c_c"
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
				"bonding_conversation_headshot_user",
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
		name = "bonding_conversation_headshot_extension_vet_a_psy_c_e",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_psy_c_e",
		database = "veteran_male_a",
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
					"bonding_conversation_headshot_extension_vet_a_psy_c_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_headshot_replier",
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
		name = "bonding_conversation_headshot_extension_vet_a_vet_c_b",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_vet_c_b",
		database = "veteran_male_a",
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
					"loc_veteran_male_c__head_shot_01",
					"loc_veteran_male_c__head_shot_02",
					"loc_veteran_male_c__head_shot_03",
					"loc_veteran_male_c__head_shot_04",
					"loc_veteran_male_c__head_shot_05",
					"loc_veteran_male_c__head_shot_06",
					"loc_veteran_male_c__head_shot_07",
					"loc_veteran_male_c__head_shot_08",
					"loc_veteran_male_c__head_shot_09",
					"loc_veteran_male_c__head_shot_10"
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
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.GTEQ,
				0
			},
			{
				"user_memory",
				"last_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_headshot",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_headshot_user",
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
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_a_vet_c_c",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_vet_c_c",
		database = "veteran_male_a",
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
					"bonding_conversation_headshot_extension_vet_a_vet_c_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c"
				}
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.GT,
				OP.LT,
				1
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
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
		name = "bonding_conversation_headshot_extension_vet_a_vet_c_d",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_vet_c_d",
		database = "veteran_male_a",
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
					"bonding_conversation_headshot_extension_vet_a_vet_c_c"
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
				"bonding_conversation_headshot_user",
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
		name = "bonding_conversation_headshot_extension_vet_a_zea_c_b",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_zea_c_b",
		database = "veteran_male_a",
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
					"loc_zealot_female_c__head_shot_01",
					"loc_zealot_female_c__head_shot_02",
					"loc_zealot_female_c__head_shot_03",
					"loc_zealot_female_c__head_shot_04",
					"loc_zealot_female_c__head_shot_05",
					"loc_zealot_female_c__head_shot_06",
					"loc_zealot_female_c__head_shot_07",
					"loc_zealot_female_c__head_shot_08",
					"loc_zealot_female_c__head_shot_09",
					"loc_zealot_female_c__head_shot_10"
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
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_headshot",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_headshot_user",
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
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_a_zea_c_c",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_a_zea_c_c",
		database = "veteran_male_a",
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
					"bonding_conversation_headshot_extension_vet_a_zea_c_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_c"
				}
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_headshot_replier",
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
		name = "bonding_conversation_killstreak_extension_vet_a_psy_b_c",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_a_psy_b_c",
		database = "veteran_male_a",
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
					"loc_psyker_female_b__response_for_veteran_seen_killstreak_psyker_01",
					"loc_psyker_female_b__response_for_veteran_seen_killstreak_psyker_02",
					"loc_psyker_female_b__response_for_veteran_seen_killstreak_psyker_03",
					"loc_psyker_female_b__response_for_veteran_seen_killstreak_psyker_04",
					"loc_psyker_female_b__response_for_veteran_seen_killstreak_psyker_05"
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
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_killstreak_user",
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
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_a_psy_b_d",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_a_psy_b_d",
		database = "veteran_male_a",
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
					"bonding_conversation_killstreak_extension_vet_a_psy_b_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b"
				}
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
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
		name = "bonding_conversation_killstreak_extension_vet_a_psy_b_e",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_a_psy_b_e",
		database = "veteran_male_a",
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
					"bonding_conversation_killstreak_extension_vet_a_psy_b_d"
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
				"bonding_conversation_killstreak_user",
				OP.EQ,
				OP.LT,
				1
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
		name = "bonding_conversation_killstreak_extension_vet_a_vet_b_c",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_a_vet_b_c",
		database = "veteran_male_a",
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
					"loc_veteran_female_b__response_for_veteran_seen_killstreak_veteran_01",
					"loc_veteran_female_b__response_for_veteran_seen_killstreak_veteran_02",
					"loc_veteran_female_b__response_for_veteran_seen_killstreak_veteran_03",
					"loc_veteran_female_b__response_for_veteran_seen_killstreak_veteran_04",
					"loc_veteran_female_b__response_for_veteran_seen_killstreak_veteran_05"
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
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_killstreak_user",
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
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_a_vet_b_d",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_a_vet_b_d",
		database = "veteran_male_a",
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
					"bonding_conversation_killstreak_extension_vet_a_vet_b_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
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
		name = "bonding_conversation_killstreak_extension_vet_a_zea_a_c",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_a_zea_a_c",
		database = "veteran_male_a",
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
					"loc_zealot_female_a__response_for_veteran_seen_killstreak_zealot_01",
					"loc_zealot_female_a__response_for_veteran_seen_killstreak_zealot_02",
					"loc_zealot_female_a__response_for_veteran_seen_killstreak_zealot_03",
					"loc_zealot_female_a__response_for_veteran_seen_killstreak_zealot_04",
					"loc_zealot_female_a__response_for_veteran_seen_killstreak_zealot_05"
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
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_killstreak_user",
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
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_a_zea_a_d",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_a_zea_a_d",
		database = "veteran_male_a",
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
					"bonding_conversation_killstreak_extension_vet_a_zea_a_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_a"
				}
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
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
		name = "bonding_conversation_lasgun_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_lasgun_a",
		database = "veteran_male_a",
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
				300
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
					"veteran_male_a"
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
				"bonding_conversation_lasgun_a",
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
				"bonding_conversation_lasgun_a",
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
				"bonding_conversation_lasgun_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_lasgun_b",
		wwise_route = 0,
		response = "bonding_conversation_lasgun_b",
		database = "veteran_male_a",
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
					"bonding_conversation_lasgun_a"
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
				"bonding_conversation_lasgun_b_user",
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
		name = "bonding_conversation_lasgun_c",
		wwise_route = 0,
		response = "bonding_conversation_lasgun_c",
		database = "veteran_male_a",
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
					"bonding_conversation_lasgun_b"
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
				"bonding_conversation_lasgun_a_user",
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
		name = "bonding_conversation_lasgun_d",
		wwise_route = 0,
		response = "bonding_conversation_lasgun_d",
		database = "veteran_male_a",
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
					"bonding_conversation_lasgun_c"
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
				"bonding_conversation_lasgun_b_user",
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
		name = "bonding_conversation_leman_russ_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_leman_russ_a",
		database = "veteran_male_a",
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
					"veteran_male_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_leman_russ_a",
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
				"bonding_conversation_leman_russ_a",
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
				"bonding_conversation_leman_russ_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_leman_russ_b",
		wwise_route = 0,
		response = "bonding_conversation_leman_russ_b",
		database = "veteran_male_a",
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
					"bonding_conversation_leman_russ_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_leman_russ_b_user",
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
		name = "bonding_conversation_leman_russ_c",
		wwise_route = 0,
		response = "bonding_conversation_leman_russ_c",
		database = "veteran_male_a",
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
					"bonding_conversation_leman_russ_b"
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
				"bonding_conversation_leman_russ_a_user",
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
		name = "bonding_conversation_leman_russ_d",
		wwise_route = 0,
		response = "bonding_conversation_leman_russ_d",
		database = "veteran_male_a",
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
					"bonding_conversation_leman_russ_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_leman_russ_b_user",
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
		name = "bonding_conversation_mouthy_a",
		wwise_route = 0,
		response = "bonding_conversation_mouthy_a",
		database = "veteran_male_a",
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
					"loc_psyker_female_a__combat_pause_limited_zealot_c_18_b_01",
					"loc_psyker_female_a__combat_pause_quirk_speed_b_02",
					"loc_psyker_female_a__combat_pause_limited_psyker_a_19_b_01",
					"loc_psyker_female_a__combat_pause_limited_ogryn_d_03_b_01",
					"loc_psyker_female_a__lore_the_emperor_three_c_01",
					"loc_psyker_female_a__lore_the_emperor_two_c_01",
					"loc_psyker_female_a__lore_imperium_one_c_01"
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
				"faction_memory",
				"bonding_conversation_mouthy_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_mouthy_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_mouthy_a_user",
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
		name = "bonding_conversation_mouthy_b",
		wwise_route = 0,
		response = "bonding_conversation_mouthy_b",
		database = "veteran_male_a",
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
					"bonding_conversation_mouthy_a"
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
				"bonding_conversation_mouthy_b_user",
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
		name = "bonding_conversation_mouthy_c",
		wwise_route = 0,
		response = "bonding_conversation_mouthy_c",
		database = "veteran_male_a",
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
					"bonding_conversation_mouthy_b"
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
				"bonding_conversation_mouthy_a_user",
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
		name = "bonding_conversation_mouthy_d",
		wwise_route = 0,
		response = "bonding_conversation_mouthy_d",
		database = "veteran_male_a",
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
					"bonding_conversation_mouthy_c"
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
				"bonding_conversation_mouthy_b_user",
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
		name = "bonding_conversation_round_three_coconut_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_round_three_coconut_a",
		database = "veteran_male_a",
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
					"veteran_male_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_coconut_a",
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
				"bonding_conversation_round_three_coconut_a",
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
				"bonding_conversation_round_three_coconut_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_round_three_coconut_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_coconut_b",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_coconut_a"
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
				"bonding_conversation_round_three_coconut_b_user",
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
		name = "bonding_conversation_round_three_coconut_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_coconut_c",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_coconut_b"
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
				"bonding_conversation_round_three_coconut_a_user",
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
		name = "bonding_conversation_round_three_coconut_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_coconut_d",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_coconut_c"
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
				"bonding_conversation_round_three_coconut_b_user",
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
		name = "bonding_conversation_round_three_coconut_e",
		wwise_route = 0,
		response = "bonding_conversation_round_three_coconut_e",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_coconut_d"
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
				"bonding_conversation_round_three_coconut_a_user",
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
		name = "bonding_conversation_round_three_fascination_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_round_three_fascination_a",
		database = "veteran_male_a",
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
					"veteran_male_a"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_fascination_a",
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
				"time_since_veteran_seen_killstreak_psyker",
				OP.GT,
				1
			},
			{
				"user_memory",
				"time_since_veteran_seen_killstreak_psyker",
				OP.TIMEDIFF,
				OP.LT,
				45
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_fascination_a",
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
				"bonding_conversation_round_three_fascination_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_round_three_fascination_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_fascination_b",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_fascination_a"
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
				"bonding_conversation_round_three_fascination_b_user",
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
		name = "bonding_conversation_round_three_fascination_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_fascination_c",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_fascination_b"
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
				"bonding_conversation_round_three_fascination_a_user",
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
		name = "bonding_conversation_round_three_fascination_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_fascination_d",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_fascination_c"
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
				"bonding_conversation_round_three_fascination_b_user",
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
		name = "bonding_conversation_round_three_firezone_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_round_three_firezone_a",
		database = "veteran_male_a",
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
					"veteran_male_a"
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
				"bonding_conversation_round_three_firezone_a",
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
				"time_since_friendly_fire_vt_og",
				OP.GT,
				1
			},
			{
				"user_memory",
				"time_since_friendly_fire_vt_og",
				OP.TIMEDIFF,
				OP.LT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_firezone_a",
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
				"bonding_conversation_round_three_firezone_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_round_three_firezone_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_firezone_b",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_firezone_a"
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
				"bonding_conversation_round_three_firezone_b_user",
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
		name = "bonding_conversation_round_three_firezone_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_firezone_c",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_firezone_b"
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
				"bonding_conversation_round_three_firezone_a_user",
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
		name = "bonding_conversation_round_three_firezone_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_firezone_d",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_firezone_c"
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
				"bonding_conversation_round_three_firezone_b_user",
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
		name = "bonding_conversation_round_three_intheway_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_round_three_intheway_a",
		database = "veteran_male_a",
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
					"veteran_male_a"
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
				"bonding_conversation_round_three_intheway_a",
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
				"time_since_friendly_fire_vt_og",
				OP.GT,
				1
			},
			{
				"user_memory",
				"time_since_friendly_fire_vt_og",
				OP.TIMEDIFF,
				OP.LT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_intheway_a",
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
				"bonding_conversation_round_three_intheway_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_round_three_intheway_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_intheway_b",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_intheway_a"
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
				"bonding_conversation_round_three_intheway_b_user",
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
		name = "bonding_conversation_round_three_intheway_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_intheway_c",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_intheway_b"
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
				"bonding_conversation_round_three_intheway_a_user",
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
		name = "bonding_conversation_round_three_intheway_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_intheway_d",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_intheway_c"
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
				"bonding_conversation_round_three_intheway_b_user",
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
		name = "bonding_conversation_round_three_willpower_a",
		wwise_route = 0,
		response = "bonding_conversation_round_three_willpower_a",
		database = "veteran_male_a",
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
					"loc_ogryn_a__combat_pause_one_liner_02",
					"loc_ogryn_a__combat_pause_one_liner_07",
					"loc_ogryn_a__combat_pause_one_liner_09",
					"loc_ogryn_a__combat_pause_limited_veteran_a_14_b_01",
					"loc_ogryn_a__combat_pause_quirk_rations_b_02"
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
				"faction_memory",
				"bonding_conversation_round_three_willpower_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_willpower_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_round_three_willpower_a_user",
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
		name = "bonding_conversation_round_three_willpower_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_willpower_b",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_willpower_a"
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
				"bonding_conversation_round_three_willpower_b_user",
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
		name = "bonding_conversation_round_three_willpower_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_willpower_c",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_willpower_b"
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
				"bonding_conversation_round_three_willpower_a_user",
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
		name = "bonding_conversation_round_three_willpower_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_willpower_d",
		database = "veteran_male_a",
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
					"bonding_conversation_round_three_willpower_c"
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
				"bonding_conversation_round_three_willpower_b_user",
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
