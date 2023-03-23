return function ()
	define_rule({
		name = "bonding_conversation_abandoned_a",
		wwise_route = 0,
		response = "bonding_conversation_abandoned_a",
		database = "zealot_male_c",
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
					"loc_veteran_male_c__combat_pause_quirk_expendable_b_01",
					"loc_veteran_male_c__combat_pause_limited_veteran_a_14_b_01",
					"loc_veteran_male_c__combat_pause_limited_veteran_b_02_b_01",
					"loc_veteran_male_c__combat_pause_limited_veteran_c_16_b_01",
					"loc_veteran_male_c__lore_imperium_two_c_02"
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
				"faction_memory",
				"bonding_conversation_abandoned_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_abandoned_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_abandoned_a_user",
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
		name = "bonding_conversation_abandoned_b",
		wwise_route = 0,
		response = "bonding_conversation_abandoned_b",
		database = "zealot_male_c",
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
					"bonding_conversation_abandoned_a"
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
				"bonding_conversation_abandoned_b_user",
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
		name = "bonding_conversation_abandoned_c",
		wwise_route = 0,
		response = "bonding_conversation_abandoned_c",
		database = "zealot_male_c",
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
					"bonding_conversation_abandoned_b"
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
				"bonding_conversation_abandoned_a_user",
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
		name = "bonding_conversation_abandoned_d",
		wwise_route = 0,
		response = "bonding_conversation_abandoned_d",
		database = "zealot_male_c",
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
					"bonding_conversation_abandoned_c"
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
				"bonding_conversation_abandoned_b_user",
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
		name = "bonding_conversation_blessings_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_blessings_a",
		database = "zealot_male_c",
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
					"zealot_male_c"
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
				"bonding_conversation_blessings_a",
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
				"bonding_conversation_blessings_a",
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
				"bonding_conversation_blessings_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_blessings_b",
		wwise_route = 0,
		response = "bonding_conversation_blessings_b",
		database = "zealot_male_c",
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
					"bonding_conversation_blessings_a"
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
				"bonding_conversation_blessings_b_user",
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
		name = "bonding_conversation_blessings_c",
		wwise_route = 0,
		response = "bonding_conversation_blessings_c",
		database = "zealot_male_c",
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
					"bonding_conversation_blessings_b"
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
				"bonding_conversation_blessings_a_user",
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
		name = "bonding_conversation_blessings_d",
		wwise_route = 0,
		response = "bonding_conversation_blessings_d",
		database = "zealot_male_c",
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
					"bonding_conversation_blessings_c"
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
				"bonding_conversation_blessings_b_user",
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
		name = "bonding_conversation_family_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_family_a",
		database = "zealot_male_c",
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
					"zealot_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_family_a",
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
				"bonding_conversation_family_a",
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
				"bonding_conversation_family_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_family_b",
		wwise_route = 0,
		response = "bonding_conversation_family_b",
		database = "zealot_male_c",
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
					"bonding_conversation_family_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_family_b_user",
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
		name = "bonding_conversation_family_c",
		wwise_route = 0,
		response = "bonding_conversation_family_c",
		database = "zealot_male_c",
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
					"bonding_conversation_family_b"
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
				"bonding_conversation_family_a_user",
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
		name = "bonding_conversation_family_d",
		wwise_route = 0,
		response = "bonding_conversation_family_d",
		database = "zealot_male_c",
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
					"bonding_conversation_family_c"
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
				"bonding_conversation_family_b_user",
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
		name = "bonding_conversation_family_e",
		wwise_route = 0,
		response = "bonding_conversation_family_e",
		database = "zealot_male_c",
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
					"bonding_conversation_family_d"
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
				"bonding_conversation_family_a_user",
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
		name = "bonding_conversation_family_f",
		wwise_route = 0,
		response = "bonding_conversation_family_f",
		database = "zealot_male_c",
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
					"bonding_conversation_family_e"
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
				"bonding_conversation_family_b_user",
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
		name = "bonding_conversation_final_hours_a",
		wwise_route = 0,
		response = "bonding_conversation_final_hours_a",
		database = "zealot_male_c",
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
					"loc_veteran_male_c__combat_pause_limited_veteran_a_14_b_01",
					"loc_veteran_male_c__combat_pause_limited_veteran_b_02_b_01",
					"loc_veteran_male_c__lore_era_indomitus_one_c_02",
					"loc_veteran_male_c__lore_imperium_two_c_02"
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
				"faction_memory",
				"bonding_conversation_final_hours_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_final_hours_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_final_hours_a_user",
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
		name = "bonding_conversation_final_hours_b",
		wwise_route = 0,
		response = "bonding_conversation_final_hours_b",
		database = "zealot_male_c",
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
					"bonding_conversation_final_hours_a"
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
				"bonding_conversation_final_hours_b_user",
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
		name = "bonding_conversation_final_hours_c",
		wwise_route = 0,
		response = "bonding_conversation_final_hours_c",
		database = "zealot_male_c",
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
					"bonding_conversation_final_hours_b"
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
				"bonding_conversation_final_hours_a_user",
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
		name = "bonding_conversation_final_hours_d",
		wwise_route = 0,
		response = "bonding_conversation_final_hours_d",
		database = "zealot_male_c",
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
					"bonding_conversation_final_hours_c"
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
				"bonding_conversation_final_hours_b_user",
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
		name = "bonding_conversation_fulfilment_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_fulfilment_a",
		database = "zealot_male_c",
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
					"zealot_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_fulfilment_a",
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
				"bonding_conversation_fulfilment_a",
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
				"bonding_conversation_fulfilment_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_fulfilment_b",
		wwise_route = 0,
		response = "bonding_conversation_fulfilment_b",
		database = "zealot_male_c",
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
					"bonding_conversation_fulfilment_a"
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
				"bonding_conversation_fulfilment_b_user",
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
		name = "bonding_conversation_fulfilment_c",
		wwise_route = 0,
		response = "bonding_conversation_fulfilment_c",
		database = "zealot_male_c",
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
					"bonding_conversation_fulfilment_b"
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
				"bonding_conversation_fulfilment_a_user",
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
		name = "bonding_conversation_fulfilment_d",
		wwise_route = 0,
		response = "bonding_conversation_fulfilment_d",
		database = "zealot_male_c",
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
					"bonding_conversation_fulfilment_c"
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
				"bonding_conversation_fulfilment_b_user",
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
		name = "bonding_conversation_funny_look_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_funny_look_a",
		database = "zealot_male_c",
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
					"zealot_male_c"
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
				"bonding_conversation_funny_look_a",
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
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_funny_look_a",
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
				"bonding_conversation_funny_look_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_funny_look_b",
		wwise_route = 0,
		response = "bonding_conversation_funny_look_b",
		database = "zealot_male_c",
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
					"bonding_conversation_funny_look_a"
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
				"bonding_conversation_funny_look_b_user",
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
		name = "bonding_conversation_funny_look_c",
		wwise_route = 0,
		response = "bonding_conversation_funny_look_c",
		database = "zealot_male_c",
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
					"bonding_conversation_funny_look_b"
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
				"bonding_conversation_funny_look_a_user",
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
		name = "bonding_conversation_funny_look_d",
		wwise_route = 0,
		response = "bonding_conversation_funny_look_d",
		database = "zealot_male_c",
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
					"bonding_conversation_funny_look_c"
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
				"bonding_conversation_funny_look_b_user",
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
		name = "bonding_conversation_heart_a",
		wwise_route = 0,
		response = "bonding_conversation_heart_a",
		database = "zealot_male_c",
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
					"loc_veteran_male_c__combat_pause_quirk_expendable_b_01",
					"loc_veteran_male_c__combat_pause_limited_veteran_a_14_b_01",
					"loc_veteran_male_c__combat_pause_limited_veteran_b_02_b_01",
					"loc_veteran_male_c__combat_pause_limited_veteran_c_16_b_01",
					"loc_veteran_male_c__lore_imperium_two_c_02"
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
				"faction_memory",
				"bonding_conversation_heart_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heart_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_heart_a_user",
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
		name = "bonding_conversation_heart_b",
		wwise_route = 0,
		response = "bonding_conversation_heart_b",
		database = "zealot_male_c",
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
					"bonding_conversation_heart_a"
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
				"bonding_conversation_heart_b_user",
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
		name = "bonding_conversation_heart_c",
		wwise_route = 0,
		response = "bonding_conversation_heart_c",
		database = "zealot_male_c",
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
					"bonding_conversation_heart_b"
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
				"bonding_conversation_heart_a_user",
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
		name = "bonding_conversation_heart_d",
		wwise_route = 0,
		response = "bonding_conversation_heart_d",
		database = "zealot_male_c",
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
					"bonding_conversation_heart_c"
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
				"bonding_conversation_heart_b_user",
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
		name = "bonding_conversation_hope_falls_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_hope_falls_a",
		database = "zealot_male_c",
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
					"zealot_male_c"
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
				"bonding_conversation_hope_falls_a",
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
				"bonding_conversation_hope_falls_a",
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
				"bonding_conversation_hope_falls_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_hope_falls_b",
		wwise_route = 0,
		response = "bonding_conversation_hope_falls_b",
		database = "zealot_male_c",
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
					"bonding_conversation_hope_falls_a"
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
				"bonding_conversation_hope_falls_b_user",
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
		name = "bonding_conversation_hope_falls_c",
		wwise_route = 0,
		response = "bonding_conversation_hope_falls_c",
		database = "zealot_male_c",
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
					"bonding_conversation_hope_falls_b"
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
				"bonding_conversation_hope_falls_a_user",
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
		name = "bonding_conversation_hope_falls_d",
		wwise_route = 0,
		response = "bonding_conversation_hope_falls_d",
		database = "zealot_male_c",
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
					"bonding_conversation_hope_falls_c"
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
				"bonding_conversation_hope_falls_b_user",
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
		name = "bonding_conversation_kindred_soul_a",
		wwise_route = 0,
		response = "bonding_conversation_kindred_soul_a",
		database = "zealot_male_c",
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
					"loc_psyker_male_c__combat_pause_quirk_doomed_b_02",
					"loc_psyker_male_c__combat_pause_quirk_desert_b_02",
					"loc_psyker_male_c__combat_pause_quirk_pilgrimage_b_02",
					"loc_psyker_male_c__combat_pause_quirk_traitor_b_01",
					"loc_psyker_male_c__combat_pause_quirk_victory_b_02"
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
				"faction_memory",
				"bonding_conversation_kindred_soul_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_kindred_soul_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_kindred_soul_a_user",
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
		name = "bonding_conversation_kindred_soul_b",
		wwise_route = 0,
		response = "bonding_conversation_kindred_soul_b",
		database = "zealot_male_c",
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
					"bonding_conversation_kindred_soul_a"
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
				"bonding_conversation_kindred_soul_b_user",
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
		name = "bonding_conversation_kindred_soul_c",
		wwise_route = 0,
		response = "bonding_conversation_kindred_soul_c",
		database = "zealot_male_c",
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
					"bonding_conversation_kindred_soul_b"
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
				"bonding_conversation_kindred_soul_a_user",
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
		name = "bonding_conversation_kindred_soul_d",
		wwise_route = 0,
		response = "bonding_conversation_kindred_soul_d",
		database = "zealot_male_c",
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
					"bonding_conversation_kindred_soul_c"
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
				"bonding_conversation_kindred_soul_b_user",
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
		name = "bonding_conversation_mourn_a",
		wwise_route = 0,
		response = "bonding_conversation_mourn_a",
		database = "zealot_male_c",
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
					"loc_veteran_male_c__combat_pause_limited_veteran_a_14_b_01",
					"loc_veteran_male_c__combat_pause_limited_veteran_b_02_b_01",
					"loc_veteran_male_c__lore_daemons_four_c_01",
					"loc_veteran_male_c__lore_daemons_four_c_02",
					"loc_veteran_male_c__lore_surgeon_one_c_01"
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
				"faction_memory",
				"bonding_conversation_mourn_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_mourn_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_mourn_a_user",
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
		name = "bonding_conversation_mourn_b",
		wwise_route = 0,
		response = "bonding_conversation_mourn_b",
		database = "zealot_male_c",
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
					"bonding_conversation_mourn_a"
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
				"bonding_conversation_mourn_b_user",
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
		name = "bonding_conversation_mourn_c",
		wwise_route = 0,
		response = "bonding_conversation_mourn_c",
		database = "zealot_male_c",
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
					"bonding_conversation_mourn_b"
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
				"bonding_conversation_mourn_a_user",
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
		name = "bonding_conversation_mourn_d",
		wwise_route = 0,
		response = "bonding_conversation_mourn_d",
		database = "zealot_male_c",
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
					"bonding_conversation_mourn_c"
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
				"bonding_conversation_mourn_b_user",
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
		name = "bonding_conversation_nature_a",
		wwise_route = 0,
		response = "bonding_conversation_nature_a",
		database = "zealot_male_c",
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
					"loc_psyker_male_c__combat_pause_quirk_doomed_b_02",
					"loc_psyker_male_c__combat_pause_quirk_desert_b_02",
					"loc_psyker_male_c__combat_pause_quirk_pilgrimage_b_02",
					"loc_psyker_male_c__combat_pause_quirk_traitor_b_01",
					"loc_psyker_male_c__combat_pause_quirk_victory_b_02"
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
				"faction_memory",
				"bonding_conversation_nature_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_nature_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_nature_a_user",
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
		name = "bonding_conversation_nature_b",
		wwise_route = 0,
		response = "bonding_conversation_nature_b",
		database = "zealot_male_c",
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
					"bonding_conversation_nature_a"
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
				"bonding_conversation_nature_b_user",
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
		name = "bonding_conversation_nature_c",
		wwise_route = 0,
		response = "bonding_conversation_nature_c",
		database = "zealot_male_c",
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
					"bonding_conversation_nature_b"
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
				"bonding_conversation_nature_a_user",
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
		name = "bonding_conversation_nature_d",
		wwise_route = 0,
		response = "bonding_conversation_nature_d",
		database = "zealot_male_c",
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
					"bonding_conversation_nature_c"
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
				"bonding_conversation_nature_b_user",
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
		name = "bonding_conversation_obsession_a",
		wwise_route = 0,
		response = "bonding_conversation_obsession_a",
		database = "zealot_male_c",
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
					"loc_veteran_male_c__combat_pause_one_liner_05",
					"loc_veteran_male_c__combat_pause_limited_zealot_c_05_b_01",
					"loc_veteran_male_c__combat_pause_quirk_prayer_b_02",
					"loc_veteran_male_c__combat_pause_quirk_pilgrimage_b_01",
					"loc_veteran_male_c__combat_pause_quirk_pilgrimage_b_01"
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
				"faction_memory",
				"bonding_conversation_obsession_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_obsession_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_obsession_a_user",
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
		name = "bonding_conversation_obsession_b",
		wwise_route = 0,
		response = "bonding_conversation_obsession_b",
		database = "zealot_male_c",
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
					"bonding_conversation_obsession_a"
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
				"bonding_conversation_obsession_b_user",
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
		name = "bonding_conversation_obsession_c",
		wwise_route = 0,
		response = "bonding_conversation_obsession_c",
		database = "zealot_male_c",
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
					"bonding_conversation_obsession_b"
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
				"bonding_conversation_obsession_a_user",
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
		name = "bonding_conversation_obsession_d",
		wwise_route = 0,
		response = "bonding_conversation_obsession_d",
		database = "zealot_male_c",
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
					"bonding_conversation_obsession_c"
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
				"bonding_conversation_obsession_b_user",
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
		name = "bonding_conversation_reward_one_day_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_reward_one_day_a",
		database = "zealot_male_c",
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
					"zealot_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_reward_one_day_a",
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
				"bonding_conversation_reward_one_day_a",
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
				"bonding_conversation_reward_one_day_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_reward_one_day_b",
		wwise_route = 0,
		response = "bonding_conversation_reward_one_day_b",
		database = "zealot_male_c",
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
					"bonding_conversation_reward_one_day_a"
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
				"bonding_conversation_reward_one_day_b_user",
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
		name = "bonding_conversation_reward_one_day_c",
		wwise_route = 0,
		response = "bonding_conversation_reward_one_day_c",
		database = "zealot_male_c",
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
					"bonding_conversation_reward_one_day_b"
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
				"bonding_conversation_reward_one_day_a_user",
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
		name = "bonding_conversation_reward_one_day_d",
		wwise_route = 0,
		response = "bonding_conversation_reward_one_day_d",
		database = "zealot_male_c",
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
					"bonding_conversation_reward_one_day_c"
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
				"bonding_conversation_reward_one_day_b_user",
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
		name = "bonding_conversation_round_three_deeds_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_round_three_deeds_a",
		database = "zealot_male_c",
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
					"zealot_male_c"
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
				"bonding_conversation_round_three_deeds_a",
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
				"bonding_conversation_round_three_deeds_a",
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
				"bonding_conversation_round_three_deeds_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_round_three_deeds_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_deeds_b",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_deeds_a"
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
				"bonding_conversation_round_three_deeds_b_user",
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
		name = "bonding_conversation_round_three_deeds_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_deeds_c",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_deeds_b"
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
				"bonding_conversation_round_three_deeds_a_user",
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
		name = "bonding_conversation_round_three_deeds_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_deeds_d",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_deeds_c"
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
				"bonding_conversation_round_three_deeds_b_user",
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
		name = "bonding_conversation_round_three_dignity_a",
		wwise_route = 0,
		response = "bonding_conversation_round_three_dignity_a",
		database = "zealot_male_c",
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
					"loc_psyker_female_a__combat_pause_one_liner_08",
					"loc_psyker_female_a__combat_pause_quirk_speed_b_02",
					"loc_psyker_female_a__lore_enemy_within_two_c_01",
					"loc_psyker_female_a__lore_grendyl_two_c_02",
					"loc_psyker_female_a__lore_hadron_two_c_02"
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
				"faction_memory",
				"bonding_conversation_round_three_dignity_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_dignity_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_round_three_dignity_a_user",
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
		name = "bonding_conversation_round_three_dignity_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_dignity_b",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_dignity_a"
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
				"bonding_conversation_round_three_dignity_b_user",
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
		name = "bonding_conversation_round_three_dignity_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_dignity_c",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_dignity_b"
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
				"bonding_conversation_round_three_dignity_a_user",
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
		name = "bonding_conversation_round_three_dignity_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_dignity_d",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_dignity_c"
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
				"bonding_conversation_round_three_dignity_b_user",
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
		name = "bonding_conversation_round_three_psyker_peril_05_a",
		wwise_route = 0,
		response = "bonding_conversation_round_three_psyker_peril_05_a",
		database = "zealot_male_c",
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
					"loc_psyker_male_a__lore_enemy_within_three_c_01",
					"loc_psyker_male_a__lore_enemy_within_four_c_02",
					"loc_psyker_male_a__lore_enemy_within_two_c_02",
					"loc_psyker_male_a__combat_pause_limited_zealot_a_01_b_01"
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
				"faction_memory",
				"bonding_conversation_round_three_psyker_peril_05_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_psyker_peril_05_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_round_three_psyker_peril_05_a_user",
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
		name = "bonding_conversation_round_three_psyker_peril_05_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_psyker_peril_05_b",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_psyker_peril_05_a"
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
				"bonding_conversation_round_three_psyker_peril_05_b_user",
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
		name = "bonding_conversation_round_three_psyker_peril_05_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_psyker_peril_05_c",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_psyker_peril_05_b"
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
				"bonding_conversation_round_three_psyker_peril_05_a_user",
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
		name = "bonding_conversation_round_three_psyker_peril_05_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_psyker_peril_05_d",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_psyker_peril_05_c"
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
				"bonding_conversation_round_three_psyker_peril_05_b_user",
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
		name = "bonding_conversation_round_three_seat_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_round_three_seat_a",
		database = "zealot_male_c",
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
					"zealot_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_seat_a",
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
				"bonding_conversation_round_three_seat_a",
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
				"bonding_conversation_round_three_seat_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_round_three_seat_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_seat_b",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_seat_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_round_three_seat_b_user",
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
		name = "bonding_conversation_round_three_seat_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_seat_c",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_seat_b"
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
				"bonding_conversation_round_three_seat_a_user",
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
		name = "bonding_conversation_round_three_seat_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_seat_d",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_seat_c"
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
				"bonding_conversation_round_three_seat_b_user",
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
		name = "bonding_conversation_round_three_smart_a",
		wwise_route = 0,
		response = "bonding_conversation_round_three_smart_a",
		database = "zealot_male_c",
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
					"loc_ogryn_a__lore_astra_militarum_two_c_01",
					"loc_ogryn_a__combat_pause_quirk_abhuman_b_01",
					"loc_ogryn_a__combat_pause_quirk_cold_b_01",
					"loc_ogryn_a__combat_pause_quirk_dead_b_02",
					"loc_ogryn_a__combat_pause_quirk_drink_b_01",
					"loc_ogryn_a__combat_pause_quirk_emperor_b_02"
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
				"faction_memory",
				"bonding_conversation_round_three_smart_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_smart_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_round_three_smart_a_user",
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
		name = "bonding_conversation_round_three_smart_b",
		wwise_route = 0,
		response = "bonding_conversation_round_three_smart_b",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_smart_a"
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
				"bonding_conversation_round_three_smart_b_user",
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
		name = "bonding_conversation_round_three_smart_c",
		wwise_route = 0,
		response = "bonding_conversation_round_three_smart_c",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_smart_b"
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
				"bonding_conversation_round_three_smart_a_user",
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
		name = "bonding_conversation_round_three_smart_d",
		wwise_route = 0,
		response = "bonding_conversation_round_three_smart_d",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_smart_c"
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
				"bonding_conversation_round_three_smart_b_user",
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
		name = "bonding_conversation_round_three_smart_e",
		wwise_route = 0,
		response = "bonding_conversation_round_three_smart_e",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_smart_d"
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
				"bonding_conversation_round_three_smart_a_user",
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
		name = "bonding_conversation_round_three_smart_f",
		wwise_route = 0,
		response = "bonding_conversation_round_three_smart_f",
		database = "zealot_male_c",
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
					"bonding_conversation_round_three_smart_e"
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
				"bonding_conversation_round_three_smart_b_user",
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
		name = "bonding_conversation_waste_not_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_waste_not_a",
		database = "zealot_male_c",
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
					"zealot_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_waste_not_a",
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
				"bonding_conversation_waste_not_a",
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
				"bonding_conversation_waste_not_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_waste_not_b",
		wwise_route = 0,
		response = "bonding_conversation_waste_not_b",
		database = "zealot_male_c",
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
					"bonding_conversation_waste_not_a"
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
				"bonding_conversation_waste_not_b_user",
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
		name = "bonding_conversation_waste_not_c",
		wwise_route = 0,
		response = "bonding_conversation_waste_not_c",
		database = "zealot_male_c",
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
					"bonding_conversation_waste_not_b"
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
				"bonding_conversation_waste_not_a_user",
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
		name = "bonding_conversation_waste_not_d",
		wwise_route = 0,
		response = "bonding_conversation_waste_not_d",
		database = "zealot_male_c",
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
					"bonding_conversation_waste_not_c"
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
				"bonding_conversation_waste_not_b_user",
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
		name = "bonding_conversation_whining_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_whining_a",
		database = "zealot_male_c",
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
					"zealot_male_c"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_whining_a",
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
				"bonding_conversation_whining_a",
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
				"bonding_conversation_whining_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_whining_b",
		wwise_route = 0,
		response = "bonding_conversation_whining_b",
		database = "zealot_male_c",
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
					"bonding_conversation_whining_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_whining_b_user",
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
		name = "bonding_conversation_whining_c",
		wwise_route = 0,
		response = "bonding_conversation_whining_c",
		database = "zealot_male_c",
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
					"bonding_conversation_whining_b"
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
				"bonding_conversation_whining_a_user",
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
		name = "bonding_conversation_whining_d",
		wwise_route = 0,
		response = "bonding_conversation_whining_d",
		database = "zealot_male_c",
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
					"bonding_conversation_whining_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_whining_b_user",
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
		name = "bonding_conversation_whining_e",
		wwise_route = 0,
		response = "bonding_conversation_whining_e",
		database = "zealot_male_c",
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
					"bonding_conversation_whining_d"
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
				"bonding_conversation_whining_a_user",
				OP.EQ,
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
end
