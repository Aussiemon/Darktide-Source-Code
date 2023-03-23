return function ()
	define_rule({
		name = "bonding_conversation_anger_a",
		wwise_route = 0,
		response = "bonding_conversation_anger_a",
		database = "psyker_male_b",
		category = "conversations_prio_1",
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
					"loc_veteran_male_c__combat_pause_limited_psyker_a_16_b_01",
					"loc_veteran_male_c__combat_pause_limited_zealot_c_09_b_01",
					"loc_veteran_male_c__combat_pause_quirk_accuracy_b_02",
					"loc_veteran_male_c__combat_pause_quirk_bad_feeling_b_01",
					"loc_veteran_male_c__combat_pause_quirk_sing_b_01",
					"loc_veteran_male_c__combat_pause_quirk_lonely_b_02"
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
				"faction_memory",
				"bonding_conversation_anger_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_anger_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_anger_a_user",
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
		name = "bonding_conversation_anger_b",
		wwise_route = 0,
		response = "bonding_conversation_anger_b",
		database = "psyker_male_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_anger_a"
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
				"bonding_conversation_anger_b_user",
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
		name = "bonding_conversation_anger_c",
		wwise_route = 0,
		response = "bonding_conversation_anger_c",
		database = "psyker_male_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_anger_b"
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
				"bonding_conversation_anger_a_user",
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
		name = "bonding_conversation_anger_d",
		wwise_route = 0,
		response = "bonding_conversation_anger_d",
		database = "psyker_male_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_anger_c"
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
				"bonding_conversation_anger_b_user",
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
		name = "bonding_conversation_anger_e",
		wwise_route = 0,
		response = "bonding_conversation_anger_e",
		database = "psyker_male_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_anger_d"
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
				"bonding_conversation_anger_a_user",
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
		name = "bonding_conversation_anger_f",
		wwise_route = 0,
		response = "bonding_conversation_anger_f",
		database = "psyker_male_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_anger_e"
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
				"bonding_conversation_anger_b_user",
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
