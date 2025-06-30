-- chunkname: @dialogues/generated/adamant_female_c.lua

return function ()
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_05_a",
		response = "adamant_female_c_ogryn_bonding_conversation_05_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_05_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_05_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_05_b",
		response = "adamant_female_c_ogryn_bonding_conversation_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_05_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_05_c",
		response = "adamant_female_c_ogryn_bonding_conversation_05_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_05_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_05_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_05_d",
		response = "adamant_female_c_ogryn_bonding_conversation_05_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_05_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_07_a",
		response = "adamant_female_c_ogryn_bonding_conversation_07_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_07_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_07_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_07_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_07_b",
		response = "adamant_female_c_ogryn_bonding_conversation_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_07_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_07_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_07_c",
		response = "adamant_female_c_ogryn_bonding_conversation_07_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_07_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_07_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_07_d",
		response = "adamant_female_c_ogryn_bonding_conversation_07_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_07_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_07_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_11_a",
		response = "adamant_female_c_ogryn_bonding_conversation_11_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_b",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_11_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_11_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_11_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_11_b",
		response = "adamant_female_c_ogryn_bonding_conversation_11_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_11_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_11_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_11_c",
		response = "adamant_female_c_ogryn_bonding_conversation_11_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_11_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_11_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_11_d",
		response = "adamant_female_c_ogryn_bonding_conversation_11_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_11_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_11_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_16_a",
		response = "adamant_female_c_ogryn_bonding_conversation_16_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_16_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_16_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_16_b",
		response = "adamant_female_c_ogryn_bonding_conversation_16_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_16_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_16_c",
		response = "adamant_female_c_ogryn_bonding_conversation_16_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_16_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_16_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_16_d",
		response = "adamant_female_c_ogryn_bonding_conversation_16_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_16_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_17_a",
		response = "adamant_female_c_ogryn_bonding_conversation_17_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_17_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_17_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_17_b",
		response = "adamant_female_c_ogryn_bonding_conversation_17_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_17_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_17_c",
		response = "adamant_female_c_ogryn_bonding_conversation_17_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_17_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_17_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_17_d",
		response = "adamant_female_c_ogryn_bonding_conversation_17_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_17_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_22_a",
		response = "adamant_female_c_ogryn_bonding_conversation_22_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_22_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_22_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_22_b",
		response = "adamant_female_c_ogryn_bonding_conversation_22_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_22_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_22_c",
		response = "adamant_female_c_ogryn_bonding_conversation_22_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_22_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_22_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_22_d",
		response = "adamant_female_c_ogryn_bonding_conversation_22_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_22_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_25_a",
		response = "adamant_female_c_ogryn_bonding_conversation_25_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_25_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_25_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_ogryn_bonding_conversation_25_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_25_b",
		response = "adamant_female_c_ogryn_bonding_conversation_25_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_25_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_25_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_25_c",
		response = "adamant_female_c_ogryn_bonding_conversation_25_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_25_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_25_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_ogryn_bonding_conversation_25_d",
		response = "adamant_female_c_ogryn_bonding_conversation_25_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_ogryn_bonding_conversation_25_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_ogryn_bonding_conversation_25_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_01_a",
		response = "adamant_female_c_psyker_bonding_conversation_01_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_01_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_01_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_01_b",
		response = "adamant_female_c_psyker_bonding_conversation_01_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_01_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_01_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_01_c",
		response = "adamant_female_c_psyker_bonding_conversation_01_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_01_c_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_01_d",
		response = "adamant_female_c_psyker_bonding_conversation_01_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_01_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_01_d_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_02_a",
		response = "adamant_female_c_psyker_bonding_conversation_02_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_02_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_02_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_02_b",
		response = "adamant_female_c_psyker_bonding_conversation_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_02_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_01_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_02_c",
		response = "adamant_female_c_psyker_bonding_conversation_02_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_02_c_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_02_d",
		response = "adamant_female_c_psyker_bonding_conversation_02_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_02_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_02_d_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_05_a",
		response = "adamant_female_c_psyker_bonding_conversation_05_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_05_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_05_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_05_b",
		response = "adamant_female_c_psyker_bonding_conversation_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_05_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_05_c",
		response = "adamant_female_c_psyker_bonding_conversation_05_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_05_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_05_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_05_d",
		response = "adamant_female_c_psyker_bonding_conversation_05_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_05_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_11_a",
		response = "adamant_female_c_psyker_bonding_conversation_11_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_11_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_11_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_11_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_11_b",
		response = "adamant_female_c_psyker_bonding_conversation_11_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_11_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_11_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_11_c",
		response = "adamant_female_c_psyker_bonding_conversation_11_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_11_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_11_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_11_d",
		response = "adamant_female_c_psyker_bonding_conversation_11_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_11_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_11_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_12_a",
		response = "adamant_female_c_psyker_bonding_conversation_12_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_12_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_12_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_12_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_12_b",
		response = "adamant_female_c_psyker_bonding_conversation_12_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_12_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_12_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_12_c",
		response = "adamant_female_c_psyker_bonding_conversation_12_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_12_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_12_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_12_d",
		response = "adamant_female_c_psyker_bonding_conversation_12_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_12_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_12_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_17_a",
		response = "adamant_female_c_psyker_bonding_conversation_17_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_b",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_17_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_17_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_17_b",
		response = "adamant_female_c_psyker_bonding_conversation_17_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_17_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_17_c",
		response = "adamant_female_c_psyker_bonding_conversation_17_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_17_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_17_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_17_d",
		response = "adamant_female_c_psyker_bonding_conversation_17_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_17_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_20_a",
		response = "adamant_female_c_psyker_bonding_conversation_20_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_b",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_20_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_20_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_20_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_20_b",
		response = "adamant_female_c_psyker_bonding_conversation_20_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_20_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_20_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_20_c",
		response = "adamant_female_c_psyker_bonding_conversation_20_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_20_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_20_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_20_d",
		response = "adamant_female_c_psyker_bonding_conversation_20_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_20_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_20_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_22_a",
		response = "adamant_female_c_psyker_bonding_conversation_22_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_22_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_22_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_22_b",
		response = "adamant_female_c_psyker_bonding_conversation_22_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_22_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_22_c",
		response = "adamant_female_c_psyker_bonding_conversation_22_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_22_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_22_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_22_d",
		response = "adamant_female_c_psyker_bonding_conversation_22_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_22_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_25_a",
		response = "adamant_female_c_psyker_bonding_conversation_25_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_25_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_25_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_25_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_25_b",
		response = "adamant_female_c_psyker_bonding_conversation_25_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_25_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_25_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_25_c",
		response = "adamant_female_c_psyker_bonding_conversation_25_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_25_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_25_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_25_d",
		response = "adamant_female_c_psyker_bonding_conversation_25_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_25_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_25_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_27_a",
		response = "adamant_female_c_psyker_bonding_conversation_27_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_27_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_27_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_27_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_27_b",
		response = "adamant_female_c_psyker_bonding_conversation_27_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_27_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_27_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_27_c",
		response = "adamant_female_c_psyker_bonding_conversation_27_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_27_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_27_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_27_d",
		response = "adamant_female_c_psyker_bonding_conversation_27_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_27_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_27_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_30_a",
		response = "adamant_female_c_psyker_bonding_conversation_30_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_30_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_30_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_30_b",
		response = "adamant_female_c_psyker_bonding_conversation_30_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_30_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_30_c",
		response = "adamant_female_c_psyker_bonding_conversation_30_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_30_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_30_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_30_d",
		response = "adamant_female_c_psyker_bonding_conversation_30_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_30_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_31_a",
		response = "adamant_female_c_psyker_bonding_conversation_31_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_31_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_31_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_31_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_31_b",
		response = "adamant_female_c_psyker_bonding_conversation_31_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_31_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_31_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_31_c",
		response = "adamant_female_c_psyker_bonding_conversation_31_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_31_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_31_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_31_d",
		response = "adamant_female_c_psyker_bonding_conversation_31_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_31_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_31_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_32_a",
		response = "adamant_female_c_psyker_bonding_conversation_32_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_32_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_32_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_32_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_32_b",
		response = "adamant_female_c_psyker_bonding_conversation_32_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_32_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_32_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_32_c",
		response = "adamant_female_c_psyker_bonding_conversation_32_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_32_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_32_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_32_d",
		response = "adamant_female_c_psyker_bonding_conversation_32_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_32_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_32_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_36_a",
		response = "adamant_female_c_psyker_bonding_conversation_36_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_a",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_36_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_36_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_36_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_36_b",
		response = "adamant_female_c_psyker_bonding_conversation_36_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_36_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_36_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_36_c",
		response = "adamant_female_c_psyker_bonding_conversation_36_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_36_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_36_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_36_d",
		response = "adamant_female_c_psyker_bonding_conversation_36_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_36_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_36_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_37_a",
		response = "adamant_female_c_psyker_bonding_conversation_37_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_a",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_37_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_37_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_37_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_37_b",
		response = "adamant_female_c_psyker_bonding_conversation_37_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_37_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_37_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_37_c",
		response = "adamant_female_c_psyker_bonding_conversation_37_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_37_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_37_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_37_d",
		response = "adamant_female_c_psyker_bonding_conversation_37_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_37_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_37_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_41_a",
		response = "adamant_female_c_psyker_bonding_conversation_41_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_41_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_41_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_41_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_41_b",
		response = "adamant_female_c_psyker_bonding_conversation_41_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_41_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_41_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_41_c",
		response = "adamant_female_c_psyker_bonding_conversation_41_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_41_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_41_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_41_d",
		response = "adamant_female_c_psyker_bonding_conversation_41_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_41_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_41_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_42_a",
		response = "adamant_female_c_psyker_bonding_conversation_42_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_42_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_42_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_42_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_42_b",
		response = "adamant_female_c_psyker_bonding_conversation_42_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_42_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_42_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_42_c",
		response = "adamant_female_c_psyker_bonding_conversation_42_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_42_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_42_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_42_d",
		response = "adamant_female_c_psyker_bonding_conversation_42_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_42_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_42_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_45_a",
		response = "adamant_female_c_psyker_bonding_conversation_45_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_45_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_45_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_45_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_45_b",
		response = "adamant_female_c_psyker_bonding_conversation_45_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_45_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_45_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_45_c",
		response = "adamant_female_c_psyker_bonding_conversation_45_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_45_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_45_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_45_d",
		response = "adamant_female_c_psyker_bonding_conversation_45_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_45_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_45_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_47_a",
		response = "adamant_female_c_psyker_bonding_conversation_47_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_b",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_47_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_47_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_47_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_47_b",
		response = "adamant_female_c_psyker_bonding_conversation_47_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_47_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_47_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_47_c",
		response = "adamant_female_c_psyker_bonding_conversation_47_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_47_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_47_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_47_d",
		response = "adamant_female_c_psyker_bonding_conversation_47_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_47_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_47_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_50_a",
		response = "adamant_female_c_psyker_bonding_conversation_50_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_b",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_50_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_50_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_50_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_50_b",
		response = "adamant_female_c_psyker_bonding_conversation_50_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_50_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_50_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_50_c",
		response = "adamant_female_c_psyker_bonding_conversation_50_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_50_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_50_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_50_d",
		response = "adamant_female_c_psyker_bonding_conversation_50_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_50_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_50_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_52_a",
		response = "adamant_female_c_psyker_bonding_conversation_52_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_52_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_52_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_52_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_52_b",
		response = "adamant_female_c_psyker_bonding_conversation_52_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_52_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_52_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_52_c",
		response = "adamant_female_c_psyker_bonding_conversation_52_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_52_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_52_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_52_d",
		response = "adamant_female_c_psyker_bonding_conversation_52_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_52_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_52_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_55_a",
		response = "adamant_female_c_psyker_bonding_conversation_55_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_55_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_55_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_55_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_55_b",
		response = "adamant_female_c_psyker_bonding_conversation_55_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_55_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_55_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_55_c",
		response = "adamant_female_c_psyker_bonding_conversation_55_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_55_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_55_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_55_d",
		response = "adamant_female_c_psyker_bonding_conversation_55_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_55_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_55_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_60_a",
		response = "adamant_female_c_psyker_bonding_conversation_60_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_60_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_60_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_psyker_bonding_conversation_60_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_60_b",
		response = "adamant_female_c_psyker_bonding_conversation_60_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_60_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_60_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_60_c",
		response = "adamant_female_c_psyker_bonding_conversation_60_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_60_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_60_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_psyker_bonding_conversation_60_d",
		response = "adamant_female_c_psyker_bonding_conversation_60_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_psyker_bonding_conversation_60_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_psyker_bonding_conversation_60_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_01_a",
		response = "adamant_female_c_veteran_bonding_conversation_01_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_01_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_01_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_01_b",
		response = "adamant_female_c_veteran_bonding_conversation_01_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_01_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_01_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_01_c",
		response = "adamant_female_c_veteran_bonding_conversation_01_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_01_c_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_01_d",
		response = "adamant_female_c_veteran_bonding_conversation_01_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_01_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_01_d_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_02_a",
		response = "adamant_female_c_veteran_bonding_conversation_02_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_02_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_02_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_02_b",
		response = "adamant_female_c_veteran_bonding_conversation_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_02_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_02_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_02_c",
		response = "adamant_female_c_veteran_bonding_conversation_02_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_02_c_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_02_d",
		response = "adamant_female_c_veteran_bonding_conversation_02_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_02_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_01_d_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_03_a",
		response = "adamant_female_c_veteran_bonding_conversation_03_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_03_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_03_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_03_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_03_b",
		response = "adamant_female_c_veteran_bonding_conversation_03_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_03_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_03_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_03_c",
		response = "adamant_female_c_veteran_bonding_conversation_03_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_03_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_03_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_03_d",
		response = "adamant_female_c_veteran_bonding_conversation_03_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_03_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_03_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_07_a",
		response = "adamant_female_c_veteran_bonding_conversation_07_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_07_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_07_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_07_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_07_b",
		response = "adamant_female_c_veteran_bonding_conversation_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_07_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_07_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_07_c",
		response = "adamant_female_c_veteran_bonding_conversation_07_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_07_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_07_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_07_d",
		response = "adamant_female_c_veteran_bonding_conversation_07_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_07_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_07_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_26_a",
		response = "adamant_female_c_veteran_bonding_conversation_26_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_26_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_26_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_26_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_26_b",
		response = "adamant_female_c_veteran_bonding_conversation_26_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_26_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_26_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_26_c",
		response = "adamant_female_c_veteran_bonding_conversation_26_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_26_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_26_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_26_d",
		response = "adamant_female_c_veteran_bonding_conversation_26_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_26_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_26_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_33_a",
		response = "adamant_female_c_veteran_bonding_conversation_33_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_a",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_33_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_33_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_33_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_33_b",
		response = "adamant_female_c_veteran_bonding_conversation_33_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_33_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_33_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_33_c",
		response = "adamant_female_c_veteran_bonding_conversation_33_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_33_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_33_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_33_d",
		response = "adamant_female_c_veteran_bonding_conversation_33_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_33_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_33_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_37_a",
		response = "adamant_female_c_veteran_bonding_conversation_37_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_37_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_37_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_37_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_37_b",
		response = "adamant_female_c_veteran_bonding_conversation_37_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_37_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_37_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_37_c",
		response = "adamant_female_c_veteran_bonding_conversation_37_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_37_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_37_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_37_d",
		response = "adamant_female_c_veteran_bonding_conversation_37_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_37_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_37_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_50_a",
		response = "adamant_female_c_veteran_bonding_conversation_50_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_50_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_50_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_veteran_bonding_conversation_50_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_50_b",
		response = "adamant_female_c_veteran_bonding_conversation_50_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_50_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_50_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_50_c",
		response = "adamant_female_c_veteran_bonding_conversation_50_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_50_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_50_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_veteran_bonding_conversation_50_d",
		response = "adamant_female_c_veteran_bonding_conversation_50_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_veteran_bonding_conversation_50_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_veteran_bonding_conversation_50_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_01_a",
		response = "adamant_female_c_zealot_bonding_conversation_01_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_01_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_01_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_01_b",
		response = "adamant_female_c_zealot_bonding_conversation_01_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_01_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_01_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_01_c",
		response = "adamant_female_c_zealot_bonding_conversation_01_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_01_c_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_01_d",
		response = "adamant_female_c_zealot_bonding_conversation_01_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_01_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_01_d_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_02_a",
		response = "adamant_female_c_zealot_bonding_conversation_02_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_02_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_02_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_02_b",
		response = "adamant_female_c_zealot_bonding_conversation_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_02_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_02_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_02_c",
		response = "adamant_female_c_zealot_bonding_conversation_02_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_01_c_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_02_d",
		response = "adamant_female_c_zealot_bonding_conversation_02_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_02_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_01_d_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_05_a",
		response = "adamant_female_c_zealot_bonding_conversation_05_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_05_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_05_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_05_b",
		response = "adamant_female_c_zealot_bonding_conversation_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_05_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_05_c",
		response = "adamant_female_c_zealot_bonding_conversation_05_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_05_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_05_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_05_d",
		response = "adamant_female_c_zealot_bonding_conversation_05_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_05_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_06_a",
		response = "adamant_female_c_zealot_bonding_conversation_06_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_06_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_06_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_06_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_06_b",
		response = "adamant_female_c_zealot_bonding_conversation_06_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_06_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_06_c",
		response = "adamant_female_c_zealot_bonding_conversation_06_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_06_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_06_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_06_d",
		response = "adamant_female_c_zealot_bonding_conversation_06_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_06_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_06_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_07_a",
		response = "adamant_female_c_zealot_bonding_conversation_07_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_07_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_07_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_07_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_07_b",
		response = "adamant_female_c_zealot_bonding_conversation_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_07_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_07_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_07_c",
		response = "adamant_female_c_zealot_bonding_conversation_07_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_07_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_07_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_07_d",
		response = "adamant_female_c_zealot_bonding_conversation_07_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_07_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_07_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_10_a",
		response = "adamant_female_c_zealot_bonding_conversation_10_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_10_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_10_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_10_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_10_b",
		response = "adamant_female_c_zealot_bonding_conversation_10_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_10_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_10_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_10_c",
		response = "adamant_female_c_zealot_bonding_conversation_10_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_10_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_10_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_10_d",
		response = "adamant_female_c_zealot_bonding_conversation_10_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_10_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_10_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_11_a",
		response = "adamant_female_c_zealot_bonding_conversation_11_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_b",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_11_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_11_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_11_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_11_b",
		response = "adamant_female_c_zealot_bonding_conversation_11_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_11_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_11_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_11_c",
		response = "adamant_female_c_zealot_bonding_conversation_11_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_11_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_11_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_11_d",
		response = "adamant_female_c_zealot_bonding_conversation_11_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_11_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_11_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_16_a",
		response = "adamant_female_c_zealot_bonding_conversation_16_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_16_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_16_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_16_b",
		response = "adamant_female_c_zealot_bonding_conversation_16_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_16_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_16_c",
		response = "adamant_female_c_zealot_bonding_conversation_16_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_16_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_16_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_16_d",
		response = "adamant_female_c_zealot_bonding_conversation_16_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_16_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_17_a",
		response = "adamant_female_c_zealot_bonding_conversation_17_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_17_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_17_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_17_b",
		response = "adamant_female_c_zealot_bonding_conversation_17_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_17_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_17_c",
		response = "adamant_female_c_zealot_bonding_conversation_17_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_17_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_17_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_17_d",
		response = "adamant_female_c_zealot_bonding_conversation_17_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_17_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_20_a",
		response = "adamant_female_c_zealot_bonding_conversation_20_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_20_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_20_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_20_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_20_b",
		response = "adamant_female_c_zealot_bonding_conversation_20_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_20_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_20_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_20_c",
		response = "adamant_female_c_zealot_bonding_conversation_20_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_20_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_20_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_20_d",
		response = "adamant_female_c_zealot_bonding_conversation_20_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_20_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_20_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_22_a",
		response = "adamant_female_c_zealot_bonding_conversation_22_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_22_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_22_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_22_b",
		response = "adamant_female_c_zealot_bonding_conversation_22_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_22_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_22_c",
		response = "adamant_female_c_zealot_bonding_conversation_22_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_22_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_22_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_22_d",
		response = "adamant_female_c_zealot_bonding_conversation_22_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_22_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_25_a",
		response = "adamant_female_c_zealot_bonding_conversation_25_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_25_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_25_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_25_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_25_b",
		response = "adamant_female_c_zealot_bonding_conversation_25_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_25_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_25_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_25_c",
		response = "adamant_female_c_zealot_bonding_conversation_25_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_25_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_25_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_25_d",
		response = "adamant_female_c_zealot_bonding_conversation_25_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_25_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_25_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_26_a",
		response = "adamant_female_c_zealot_bonding_conversation_26_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_26_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_26_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_26_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_26_b",
		response = "adamant_female_c_zealot_bonding_conversation_26_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_26_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_26_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_26_c",
		response = "adamant_female_c_zealot_bonding_conversation_26_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_26_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_26_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_26_d",
		response = "adamant_female_c_zealot_bonding_conversation_26_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_26_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_26_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_30_a",
		response = "adamant_female_c_zealot_bonding_conversation_30_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_30_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_30_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_30_b",
		response = "adamant_female_c_zealot_bonding_conversation_30_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_30_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_30_c",
		response = "adamant_female_c_zealot_bonding_conversation_30_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_30_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_30_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_30_d",
		response = "adamant_female_c_zealot_bonding_conversation_30_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_30_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_31_a",
		response = "adamant_female_c_zealot_bonding_conversation_31_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_female_a",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_31_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_31_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_31_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_31_b",
		response = "adamant_female_c_zealot_bonding_conversation_31_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_31_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_31_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_31_c",
		response = "adamant_female_c_zealot_bonding_conversation_31_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_31_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_31_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_31_d",
		response = "adamant_female_c_zealot_bonding_conversation_31_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_31_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_31_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_32_a",
		response = "adamant_female_c_zealot_bonding_conversation_32_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_female_a",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_32_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_32_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_32_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_32_b",
		response = "adamant_female_c_zealot_bonding_conversation_32_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_32_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_32_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_32_c",
		response = "adamant_female_c_zealot_bonding_conversation_32_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_32_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_32_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_32_d",
		response = "adamant_female_c_zealot_bonding_conversation_32_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_32_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_32_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_40_a",
		response = "adamant_female_c_zealot_bonding_conversation_40_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_40_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_40_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_40_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_40_b",
		response = "adamant_female_c_zealot_bonding_conversation_40_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_40_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_40_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_40_c",
		response = "adamant_female_c_zealot_bonding_conversation_40_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_40_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_a",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_40_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_40_d",
		response = "adamant_female_c_zealot_bonding_conversation_40_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_40_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_40_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_41_a",
		response = "adamant_female_c_zealot_bonding_conversation_41_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_female_b",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_41_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_41_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_41_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_41_b",
		response = "adamant_female_c_zealot_bonding_conversation_41_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_41_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_41_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_41_c",
		response = "adamant_female_c_zealot_bonding_conversation_41_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_41_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_41_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_41_d",
		response = "adamant_female_c_zealot_bonding_conversation_41_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_41_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_41_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_45_a",
		response = "adamant_female_c_zealot_bonding_conversation_45_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_female_b",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_45_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_45_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_45_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_45_b",
		response = "adamant_female_c_zealot_bonding_conversation_45_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_45_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_45_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_45_c",
		response = "adamant_female_c_zealot_bonding_conversation_45_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_45_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_45_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_45_d",
		response = "adamant_female_c_zealot_bonding_conversation_45_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_45_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_45_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_46_a",
		response = "adamant_female_c_zealot_bonding_conversation_46_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_46_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_46_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_46_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_46_b",
		response = "adamant_female_c_zealot_bonding_conversation_46_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_46_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_46_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_46_c",
		response = "adamant_female_c_zealot_bonding_conversation_46_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_46_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_46_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_46_d",
		response = "adamant_female_c_zealot_bonding_conversation_46_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_46_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_46_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_47_a",
		response = "adamant_female_c_zealot_bonding_conversation_47_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_47_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_47_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_47_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_47_b",
		response = "adamant_female_c_zealot_bonding_conversation_47_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_47_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_47_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_47_c",
		response = "adamant_female_c_zealot_bonding_conversation_47_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_47_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_47_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_47_d",
		response = "adamant_female_c_zealot_bonding_conversation_47_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_47_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_47_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_50_a",
		response = "adamant_female_c_zealot_bonding_conversation_50_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_50_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_50_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_50_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_50_b",
		response = "adamant_female_c_zealot_bonding_conversation_50_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_50_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_50_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_50_c",
		response = "adamant_female_c_zealot_bonding_conversation_50_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_50_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_b",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_50_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_50_d",
		response = "adamant_female_c_zealot_bonding_conversation_50_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_50_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_50_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_52_a",
		response = "adamant_female_c_zealot_bonding_conversation_52_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_52_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_52_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_52_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_52_b",
		response = "adamant_female_c_zealot_bonding_conversation_52_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_52_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_52_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_52_c",
		response = "adamant_female_c_zealot_bonding_conversation_52_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_52_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_52_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_52_d",
		response = "adamant_female_c_zealot_bonding_conversation_52_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_52_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_52_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_55_a",
		response = "adamant_female_c_zealot_bonding_conversation_55_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"zealot_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_55_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_55_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_55_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_55_b",
		response = "adamant_female_c_zealot_bonding_conversation_55_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_55_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_55_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_55_c",
		response = "adamant_female_c_zealot_bonding_conversation_55_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_55_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_55_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_55_d",
		response = "adamant_female_c_zealot_bonding_conversation_55_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_55_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_55_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_56_a",
		response = "adamant_female_c_zealot_bonding_conversation_56_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_56_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_56_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_56_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_56_b",
		response = "adamant_female_c_zealot_bonding_conversation_56_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_56_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_56_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_56_c",
		response = "adamant_female_c_zealot_bonding_conversation_56_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_56_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_56_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_56_d",
		response = "adamant_female_c_zealot_bonding_conversation_56_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_56_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_56_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_57_a",
		response = "adamant_female_c_zealot_bonding_conversation_57_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_57_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_57_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_57_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_57_b",
		response = "adamant_female_c_zealot_bonding_conversation_57_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_57_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_57_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_57_c",
		response = "adamant_female_c_zealot_bonding_conversation_57_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_57_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_57_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_57_d",
		response = "adamant_female_c_zealot_bonding_conversation_57_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_57_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_57_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_60_a",
		response = "adamant_female_c_zealot_bonding_conversation_60_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_60_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_60_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"adamant_female_c_zealot_bonding_conversation_60_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_60_b",
		response = "adamant_female_c_zealot_bonding_conversation_60_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_60_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_60_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_60_c",
		response = "adamant_female_c_zealot_bonding_conversation_60_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_60_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_60_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_female_c_zealot_bonding_conversation_60_d",
		response = "adamant_female_c_zealot_bonding_conversation_60_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c_zealot_bonding_conversation_60_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"user_memory",
				"adamant_female_c_zealot_bonding_conversation_60_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_to_adamant_bonding_conversation_96_a",
		response = "adamant_to_adamant_bonding_conversation_96_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_male_a",
				},
			},
			{
				"faction_memory",
				"adamant_to_adamant_bonding_conversation_96_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"adamant_to_adamant_bonding_conversation_96_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
			{
				"user_memory",
				"adamant_to_adamant_bonding_conversation_96_a_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "adamant_female_c",
		name = "adamant_to_adamant_bonding_conversation_96_c",
		response = "adamant_to_adamant_bonding_conversation_96_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_to_adamant_bonding_conversation_96_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"adamant_to_adamant_bonding_conversation_96_c_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
end
