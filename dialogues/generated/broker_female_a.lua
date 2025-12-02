-- chunkname: @dialogues/generated/broker_female_a.lua

return function ()
	define_rule({
		category = "conversations_prio_1",
		database = "broker_female_a",
		name = "broker_bonding_conversation_25_a",
		response = "broker_bonding_conversation_25_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_male_b",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_25_a",
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
				"broker_bonding_conversation_25_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_25_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_25_b",
		response = "broker_bonding_conversation_25_b",
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
					"broker_bonding_conversation_25_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_25_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_25_c",
		response = "broker_bonding_conversation_25_c",
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
					"broker_bonding_conversation_25_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_25_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_25_d",
		response = "broker_bonding_conversation_25_d",
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
					"broker_bonding_conversation_25_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_b",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_25_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_26_a",
		response = "broker_bonding_conversation_26_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_male_b",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_26_a",
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
				"broker_bonding_conversation_26_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_26_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_26_b",
		response = "broker_bonding_conversation_26_b",
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
					"broker_bonding_conversation_26_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_26_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_26_c",
		response = "broker_bonding_conversation_26_c",
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
					"broker_bonding_conversation_26_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_26_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_26_d",
		response = "broker_bonding_conversation_26_d",
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
					"broker_bonding_conversation_26_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_b",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_26_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_27_a",
		response = "broker_bonding_conversation_27_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_male_b",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_27_a",
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
				"broker_bonding_conversation_27_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_27_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_27_b",
		response = "broker_bonding_conversation_27_b",
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
					"broker_bonding_conversation_27_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_27_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_27_c",
		response = "broker_bonding_conversation_27_c",
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
					"broker_bonding_conversation_27_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_27_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_27_d",
		response = "broker_bonding_conversation_27_d",
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
					"broker_bonding_conversation_27_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_b",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_27_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_28_a",
		response = "broker_bonding_conversation_28_a",
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
					"broker_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_28_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_bonding_conversation_28_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_28_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_28_b",
		response = "broker_bonding_conversation_28_b",
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
					"broker_bonding_conversation_28_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_28_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_28_c",
		response = "broker_bonding_conversation_28_c",
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
					"broker_bonding_conversation_28_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_b",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_28_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_28_d",
		response = "broker_bonding_conversation_28_d",
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
					"broker_bonding_conversation_28_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_28_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_29_a",
		response = "broker_bonding_conversation_29_a",
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
					"broker_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_29_a",
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
				"broker_bonding_conversation_29_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_29_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_29_b",
		response = "broker_bonding_conversation_29_b",
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
					"broker_bonding_conversation_29_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_29_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_29_c",
		response = "broker_bonding_conversation_29_c",
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
					"broker_bonding_conversation_29_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_b",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_29_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_29_d",
		response = "broker_bonding_conversation_29_d",
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
					"broker_bonding_conversation_29_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_29_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_30_a",
		response = "broker_bonding_conversation_30_a",
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
					"broker_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_30_a",
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
				"broker_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_30_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_30_b",
		response = "broker_bonding_conversation_30_b",
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
					"broker_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_30_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_30_c",
		response = "broker_bonding_conversation_30_c",
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
					"broker_bonding_conversation_30_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_b",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_30_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_30_d",
		response = "broker_bonding_conversation_30_d",
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
					"broker_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_30_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_31_a",
		response = "broker_bonding_conversation_31_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_b",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_31_a",
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
				"broker_bonding_conversation_31_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_31_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_31_b",
		response = "broker_bonding_conversation_31_b",
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
					"broker_bonding_conversation_31_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_31_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_31_c",
		response = "broker_bonding_conversation_31_c",
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
					"broker_bonding_conversation_31_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_31_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_31_d",
		response = "broker_bonding_conversation_31_d",
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
					"broker_bonding_conversation_31_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_b",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_31_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_32_a",
		response = "broker_bonding_conversation_32_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_b",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_32_a",
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
				"broker_bonding_conversation_32_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_32_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_32_b",
		response = "broker_bonding_conversation_32_b",
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
					"broker_bonding_conversation_32_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_32_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_32_c",
		response = "broker_bonding_conversation_32_c",
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
					"broker_bonding_conversation_32_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_32_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_32_d",
		response = "broker_bonding_conversation_32_d",
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
					"broker_bonding_conversation_32_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_b",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_32_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_33_a",
		response = "broker_bonding_conversation_33_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_b",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_33_a",
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
				"broker_bonding_conversation_33_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_33_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_33_b",
		response = "broker_bonding_conversation_33_b",
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
					"broker_bonding_conversation_33_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_33_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_33_c",
		response = "broker_bonding_conversation_33_c",
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
					"broker_bonding_conversation_33_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_33_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_33_d",
		response = "broker_bonding_conversation_33_d",
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
					"broker_bonding_conversation_33_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_b",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_33_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_34_a",
		response = "broker_bonding_conversation_34_a",
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
					"broker_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_34_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_bonding_conversation_34_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_34_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_34_b",
		response = "broker_bonding_conversation_34_b",
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
					"broker_bonding_conversation_34_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_34_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_34_c",
		response = "broker_bonding_conversation_34_c",
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
					"broker_bonding_conversation_34_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_b",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_34_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_34_d",
		response = "broker_bonding_conversation_34_d",
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
					"broker_bonding_conversation_34_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_34_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_35_a",
		response = "broker_bonding_conversation_35_a",
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
					"broker_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_35_a",
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
				"broker_bonding_conversation_35_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_35_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_35_b",
		response = "broker_bonding_conversation_35_b",
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
					"broker_bonding_conversation_35_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_35_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_35_c",
		response = "broker_bonding_conversation_35_c",
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
					"broker_bonding_conversation_35_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_b",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_35_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_35_d",
		response = "broker_bonding_conversation_35_d",
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
					"broker_bonding_conversation_35_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_35_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_36_a",
		response = "broker_bonding_conversation_36_a",
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
					"broker_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_36_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_bonding_conversation_36_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_36_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_36_b",
		response = "broker_bonding_conversation_36_b",
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
					"broker_bonding_conversation_36_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_36_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_36_c",
		response = "broker_bonding_conversation_36_c",
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
					"broker_bonding_conversation_36_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_b",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_36_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_36_d",
		response = "broker_bonding_conversation_36_d",
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
					"broker_bonding_conversation_36_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_36_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_37_a",
		response = "broker_bonding_conversation_37_a",
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
					"broker_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_37_a",
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
				"broker_bonding_conversation_37_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_37_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_37_b",
		response = "broker_bonding_conversation_37_b",
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
					"broker_bonding_conversation_37_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_37_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_37_c",
		response = "broker_bonding_conversation_37_c",
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
					"broker_bonding_conversation_37_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_c",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_37_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_37_d",
		response = "broker_bonding_conversation_37_d",
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
					"broker_bonding_conversation_37_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_37_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_38_a",
		response = "broker_bonding_conversation_38_a",
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
					"broker_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_38_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_bonding_conversation_38_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_38_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_38_b",
		response = "broker_bonding_conversation_38_b",
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
					"broker_bonding_conversation_38_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_38_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_38_c",
		response = "broker_bonding_conversation_38_c",
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
					"broker_bonding_conversation_38_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_c",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_38_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_38_d",
		response = "broker_bonding_conversation_38_d",
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
					"broker_bonding_conversation_38_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_38_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_39_a",
		response = "broker_bonding_conversation_39_a",
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
					"broker_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_39_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_bonding_conversation_39_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_39_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_39_b",
		response = "broker_bonding_conversation_39_b",
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
					"broker_bonding_conversation_39_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_39_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_39_c",
		response = "broker_bonding_conversation_39_c",
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
					"broker_bonding_conversation_39_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_c",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_39_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_39_d",
		response = "broker_bonding_conversation_39_d",
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
					"broker_bonding_conversation_39_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_39_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_40_a",
		response = "broker_bonding_conversation_40_a",
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
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_broker_male_c__combat_pause_one_liner_01",
					"loc_broker_male_c__combat_pause_one_liner_02",
					"loc_broker_male_c__combat_pause_one_liner_03",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_40_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_40_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_40_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_40_b",
		response = "broker_bonding_conversation_40_b",
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
					"broker_bonding_conversation_40_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_40_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_40_c",
		response = "broker_bonding_conversation_40_c",
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
					"broker_bonding_conversation_40_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_40_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_40_d",
		response = "broker_bonding_conversation_40_d",
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
					"broker_bonding_conversation_40_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_c",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_40_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_41_a",
		response = "broker_bonding_conversation_41_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_male_c",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_41_a",
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
				"broker_bonding_conversation_41_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_41_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_41_b",
		response = "broker_bonding_conversation_41_b",
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
					"broker_bonding_conversation_41_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_41_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_41_c",
		response = "broker_bonding_conversation_41_c",
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
					"broker_bonding_conversation_41_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_41_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_41_d",
		response = "broker_bonding_conversation_41_d",
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
					"broker_bonding_conversation_41_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_c",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_41_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_42_a",
		response = "broker_bonding_conversation_42_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_male_c",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_42_a",
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
				"broker_bonding_conversation_42_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_42_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_42_b",
		response = "broker_bonding_conversation_42_b",
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
					"broker_bonding_conversation_42_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_42_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_42_c",
		response = "broker_bonding_conversation_42_c",
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
					"broker_bonding_conversation_42_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_42_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_42_d",
		response = "broker_bonding_conversation_42_d",
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
					"broker_bonding_conversation_42_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_c",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_42_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_43_a",
		response = "broker_bonding_conversation_43_a",
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
					"broker_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_43_a",
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
				"broker_bonding_conversation_43_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_43_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_43_b",
		response = "broker_bonding_conversation_43_b",
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
					"broker_bonding_conversation_43_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_43_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_43_c",
		response = "broker_bonding_conversation_43_c",
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
					"broker_bonding_conversation_43_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_c",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_43_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_43_d",
		response = "broker_bonding_conversation_43_d",
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
					"broker_bonding_conversation_43_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_43_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_44_a",
		response = "broker_bonding_conversation_44_a",
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
					"broker_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_44_a",
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
				"broker_bonding_conversation_44_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_44_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_44_b",
		response = "broker_bonding_conversation_44_b",
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
					"broker_bonding_conversation_44_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_44_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_44_c",
		response = "broker_bonding_conversation_44_c",
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
					"broker_bonding_conversation_44_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_c",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_44_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_44_d",
		response = "broker_bonding_conversation_44_d",
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
					"broker_bonding_conversation_44_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_44_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_45_a",
		response = "broker_bonding_conversation_45_a",
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
					"broker_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_45_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_bonding_conversation_45_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_45_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_45_b",
		response = "broker_bonding_conversation_45_b",
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
					"broker_bonding_conversation_45_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_45_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_45_c",
		response = "broker_bonding_conversation_45_c",
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
					"broker_bonding_conversation_45_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_c",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_45_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_45_d",
		response = "broker_bonding_conversation_45_d",
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
					"broker_bonding_conversation_45_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_45_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_46_a",
		response = "broker_bonding_conversation_46_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_c",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_46_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_bonding_conversation_46_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_46_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_46_b",
		response = "broker_bonding_conversation_46_b",
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
					"broker_bonding_conversation_46_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_46_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_46_c",
		response = "broker_bonding_conversation_46_c",
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
					"broker_bonding_conversation_46_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_46_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_46_d",
		response = "broker_bonding_conversation_46_d",
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
					"broker_bonding_conversation_46_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_c",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_46_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_47_a",
		response = "broker_bonding_conversation_47_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_c",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_47_a",
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
				"broker_bonding_conversation_47_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_47_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_47_b",
		response = "broker_bonding_conversation_47_b",
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
					"broker_bonding_conversation_47_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_47_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_47_c",
		response = "broker_bonding_conversation_47_c",
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
					"broker_bonding_conversation_47_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_47_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_47_d",
		response = "broker_bonding_conversation_47_d",
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
					"broker_bonding_conversation_47_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_c",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_47_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_48_a",
		response = "broker_bonding_conversation_48_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_c",
				},
			},
			{
				"faction_memory",
				"broker_bonding_conversation_48_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_bonding_conversation_48_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_bonding_conversation_48_a",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_48_b",
		response = "broker_bonding_conversation_48_b",
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
					"broker_bonding_conversation_48_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_bonding_conversation_48_b_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_48_c",
		response = "broker_bonding_conversation_48_c",
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
					"broker_bonding_conversation_48_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_48_a_user",
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
		database = "broker_female_a",
		name = "broker_bonding_conversation_48_d",
		response = "broker_bonding_conversation_48_d",
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
					"broker_bonding_conversation_48_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_c",
				},
			},
			{
				"user_memory",
				"broker_bonding_conversation_48_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_01_a",
		response = "broker_female_a_adamant_bonding_conversation_01_a",
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
				OP.LT,
				360,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
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
				"broker_female_a_adamant_bonding_conversation_01_a",
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
				"broker_female_a_adamant_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_01_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_01_b",
		response = "broker_female_a_adamant_bonding_conversation_01_b",
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
					"broker_female_a_adamant_bonding_conversation_01_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_01_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_01_c",
		response = "broker_female_a_adamant_bonding_conversation_01_c",
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
					"broker_female_a_adamant_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_01_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_01_d",
		response = "broker_female_a_adamant_bonding_conversation_01_d",
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
					"broker_female_a_adamant_bonding_conversation_01_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_01_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_02_a",
		response = "broker_female_a_adamant_bonding_conversation_02_a",
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
					"broker_female_a",
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
				"broker_female_a_adamant_bonding_conversation_02_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_02_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_02_b",
		response = "broker_female_a_adamant_bonding_conversation_02_b",
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
					"broker_female_a_adamant_bonding_conversation_02_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_02_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_02_c",
		response = "broker_female_a_adamant_bonding_conversation_02_c",
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
					"broker_female_a_adamant_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_02_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_02_d",
		response = "broker_female_a_adamant_bonding_conversation_02_d",
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
					"broker_female_a_adamant_bonding_conversation_02_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_02_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_03_a",
		response = "broker_female_a_adamant_bonding_conversation_03_a",
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
					"broker_female_a",
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
				"broker_female_a_adamant_bonding_conversation_03_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_03_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_03_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_03_b",
		response = "broker_female_a_adamant_bonding_conversation_03_b",
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
					"broker_female_a_adamant_bonding_conversation_03_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_03_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_03_c",
		response = "broker_female_a_adamant_bonding_conversation_03_c",
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
					"broker_female_a_adamant_bonding_conversation_03_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_03_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_03_d",
		response = "broker_female_a_adamant_bonding_conversation_03_d",
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
					"broker_female_a_adamant_bonding_conversation_03_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_03_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_04_a",
		response = "broker_female_a_adamant_bonding_conversation_04_a",
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
					"adamant_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_04_a",
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
				"broker_female_a_adamant_bonding_conversation_04_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_04_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_04_b",
		response = "broker_female_a_adamant_bonding_conversation_04_b",
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
					"broker_female_a_adamant_bonding_conversation_04_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_04_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_04_c",
		response = "broker_female_a_adamant_bonding_conversation_04_c",
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
					"broker_female_a_adamant_bonding_conversation_04_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_04_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_04_d",
		response = "broker_female_a_adamant_bonding_conversation_04_d",
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
					"broker_female_a_adamant_bonding_conversation_04_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_04_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_05_a",
		response = "broker_female_a_adamant_bonding_conversation_05_a",
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
					"adamant_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_05_a",
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
				"broker_female_a_adamant_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_05_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_05_b",
		response = "broker_female_a_adamant_bonding_conversation_05_b",
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
					"broker_female_a_adamant_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_05_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_05_c",
		response = "broker_female_a_adamant_bonding_conversation_05_c",
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
					"broker_female_a_adamant_bonding_conversation_05_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_05_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_05_d",
		response = "broker_female_a_adamant_bonding_conversation_05_d",
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
					"broker_female_a_adamant_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_05_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_06_a",
		response = "broker_female_a_adamant_bonding_conversation_06_a",
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
					"adamant_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_06_a",
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
				"broker_female_a_adamant_bonding_conversation_06_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_06_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_06_b",
		response = "broker_female_a_adamant_bonding_conversation_06_b",
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
					"broker_female_a_adamant_bonding_conversation_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_06_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_06_c",
		response = "broker_female_a_adamant_bonding_conversation_06_c",
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
					"broker_female_a_adamant_bonding_conversation_06_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_06_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_06_d",
		response = "broker_female_a_adamant_bonding_conversation_06_d",
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
					"broker_female_a_adamant_bonding_conversation_06_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_06_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_07_a",
		response = "broker_female_a_adamant_bonding_conversation_07_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_07_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_07_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_07_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_07_b",
		response = "broker_female_a_adamant_bonding_conversation_07_b",
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
					"broker_female_a_adamant_bonding_conversation_07_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_07_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_07_c",
		response = "broker_female_a_adamant_bonding_conversation_07_c",
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
					"broker_female_a_adamant_bonding_conversation_07_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_07_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_07_d",
		response = "broker_female_a_adamant_bonding_conversation_07_d",
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
					"broker_female_a_adamant_bonding_conversation_07_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_07_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_08_a",
		response = "broker_female_a_adamant_bonding_conversation_08_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_08_a",
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
				"broker_female_a_adamant_bonding_conversation_08_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_08_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_08_b",
		response = "broker_female_a_adamant_bonding_conversation_08_b",
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
					"broker_female_a_adamant_bonding_conversation_08_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_08_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_08_c",
		response = "broker_female_a_adamant_bonding_conversation_08_c",
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
					"broker_female_a_adamant_bonding_conversation_08_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_08_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_08_d",
		response = "broker_female_a_adamant_bonding_conversation_08_d",
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
					"broker_female_a_adamant_bonding_conversation_08_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_08_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_09_a",
		response = "broker_female_a_adamant_bonding_conversation_09_a",
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
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_adamant_female_a__combat_pause_quirk_broker_a_trait_05_b_01",
					"loc_adamant_female_a__combat_pause_quirk_broker_a_trait_07_b_01",
					"loc_adamant_female_a__combat_pause_quirk_broker_a_trait_04_b_01",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_09_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_09_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_09_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_09_b",
		response = "broker_female_a_adamant_bonding_conversation_09_b",
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
					"broker_female_a_adamant_bonding_conversation_09_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_09_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_09_c",
		response = "broker_female_a_adamant_bonding_conversation_09_c",
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
					"broker_female_a_adamant_bonding_conversation_09_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_09_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_09_d",
		response = "broker_female_a_adamant_bonding_conversation_09_d",
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
					"broker_female_a_adamant_bonding_conversation_09_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_09_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_10_a",
		response = "broker_female_a_adamant_bonding_conversation_10_a",
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
					"adamant_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_10_a",
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
				"broker_female_a_adamant_bonding_conversation_10_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_10_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_10_b",
		response = "broker_female_a_adamant_bonding_conversation_10_b",
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
					"broker_female_a_adamant_bonding_conversation_10_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_10_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_10_c",
		response = "broker_female_a_adamant_bonding_conversation_10_c",
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
					"broker_female_a_adamant_bonding_conversation_10_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_10_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_10_d",
		response = "broker_female_a_adamant_bonding_conversation_10_d",
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
					"broker_female_a_adamant_bonding_conversation_10_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_10_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_11_a",
		response = "broker_female_a_adamant_bonding_conversation_11_a",
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
					"adamant_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_11_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_11_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_11_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_11_b",
		response = "broker_female_a_adamant_bonding_conversation_11_b",
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
					"broker_female_a_adamant_bonding_conversation_11_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_11_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_11_c",
		response = "broker_female_a_adamant_bonding_conversation_11_c",
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
					"broker_female_a_adamant_bonding_conversation_11_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_11_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_11_d",
		response = "broker_female_a_adamant_bonding_conversation_11_d",
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
					"broker_female_a_adamant_bonding_conversation_11_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_11_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_12_a",
		response = "broker_female_a_adamant_bonding_conversation_12_a",
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
					"adamant_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_12_a",
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
				"broker_female_a_adamant_bonding_conversation_12_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_12_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_12_b",
		response = "broker_female_a_adamant_bonding_conversation_12_b",
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
					"broker_female_a_adamant_bonding_conversation_12_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_12_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_12_c",
		response = "broker_female_a_adamant_bonding_conversation_12_c",
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
					"broker_female_a_adamant_bonding_conversation_12_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_12_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_12_d",
		response = "broker_female_a_adamant_bonding_conversation_12_d",
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
					"broker_female_a_adamant_bonding_conversation_12_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_12_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_13_a",
		response = "broker_female_a_adamant_bonding_conversation_13_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_male_b",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_13_a",
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
				"broker_female_a_adamant_bonding_conversation_13_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_13_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_13_b",
		response = "broker_female_a_adamant_bonding_conversation_13_b",
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
					"broker_female_a_adamant_bonding_conversation_13_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_13_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_13_c",
		response = "broker_female_a_adamant_bonding_conversation_13_c",
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
					"broker_female_a_adamant_bonding_conversation_13_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_13_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_13_d",
		response = "broker_female_a_adamant_bonding_conversation_13_d",
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
					"broker_female_a_adamant_bonding_conversation_13_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_13_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_14_a",
		response = "broker_female_a_adamant_bonding_conversation_14_a",
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
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_adamant_male_b__combat_pause_one_liner_a_01",
					"loc_adamant_male_b__combat_pause_one_liner_a_04",
					"loc_adamant_male_b__combat_pause_one_liner_a_07",
					"loc_adamant_male_b__combat_pause_one_liner_a_08",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_14_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_14_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_14_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_14_b",
		response = "broker_female_a_adamant_bonding_conversation_14_b",
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
					"broker_female_a_adamant_bonding_conversation_14_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_14_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_14_c",
		response = "broker_female_a_adamant_bonding_conversation_14_c",
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
					"broker_female_a_adamant_bonding_conversation_14_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_14_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_14_d",
		response = "broker_female_a_adamant_bonding_conversation_14_d",
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
					"broker_female_a_adamant_bonding_conversation_14_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_14_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_15_a",
		response = "broker_female_a_adamant_bonding_conversation_15_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_male_b",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_15_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_15_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_15_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_15_b",
		response = "broker_female_a_adamant_bonding_conversation_15_b",
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
					"broker_female_a_adamant_bonding_conversation_15_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_15_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_15_c",
		response = "broker_female_a_adamant_bonding_conversation_15_c",
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
					"broker_female_a_adamant_bonding_conversation_15_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_15_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_15_d",
		response = "broker_female_a_adamant_bonding_conversation_15_d",
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
					"broker_female_a_adamant_bonding_conversation_15_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_15_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_16_a",
		response = "broker_female_a_adamant_bonding_conversation_16_a",
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
					"adamant_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_16_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_16_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_16_b",
		response = "broker_female_a_adamant_bonding_conversation_16_b",
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
					"broker_female_a_adamant_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_16_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_16_c",
		response = "broker_female_a_adamant_bonding_conversation_16_c",
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
					"broker_female_a_adamant_bonding_conversation_16_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_16_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_16_d",
		response = "broker_female_a_adamant_bonding_conversation_16_d",
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
					"broker_female_a_adamant_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_16_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_17_a",
		response = "broker_female_a_adamant_bonding_conversation_17_a",
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
					"adamant_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_17_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_17_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_17_b",
		response = "broker_female_a_adamant_bonding_conversation_17_b",
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
					"broker_female_a_adamant_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_17_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_17_c",
		response = "broker_female_a_adamant_bonding_conversation_17_c",
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
					"broker_female_a_adamant_bonding_conversation_17_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_17_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_17_d",
		response = "broker_female_a_adamant_bonding_conversation_17_d",
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
					"broker_female_a_adamant_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_17_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_18_a",
		response = "broker_female_a_adamant_bonding_conversation_18_a",
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
					"adamant_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_18_a",
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
				"broker_female_a_adamant_bonding_conversation_18_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_18_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_18_b",
		response = "broker_female_a_adamant_bonding_conversation_18_b",
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
					"broker_female_a_adamant_bonding_conversation_18_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_18_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_18_c",
		response = "broker_female_a_adamant_bonding_conversation_18_c",
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
					"broker_female_a_adamant_bonding_conversation_18_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_male_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_18_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_18_d",
		response = "broker_female_a_adamant_bonding_conversation_18_d",
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
					"broker_female_a_adamant_bonding_conversation_18_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_18_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_19_a",
		response = "broker_female_a_adamant_bonding_conversation_19_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_b",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_19_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_19_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_19_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_19_b",
		response = "broker_female_a_adamant_bonding_conversation_19_b",
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
					"broker_female_a_adamant_bonding_conversation_19_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_19_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_19_c",
		response = "broker_female_a_adamant_bonding_conversation_19_c",
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
					"broker_female_a_adamant_bonding_conversation_19_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_19_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_19_d",
		response = "broker_female_a_adamant_bonding_conversation_19_d",
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
					"broker_female_a_adamant_bonding_conversation_19_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_19_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_21_a",
		response = "broker_female_a_adamant_bonding_conversation_21_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_b",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_21_a",
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
				"broker_female_a_adamant_bonding_conversation_21_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_21_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_21_b",
		response = "broker_female_a_adamant_bonding_conversation_21_b",
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
					"broker_female_a_adamant_bonding_conversation_21_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_21_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_21_c",
		response = "broker_female_a_adamant_bonding_conversation_21_c",
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
					"broker_female_a_adamant_bonding_conversation_21_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_21_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_21_d",
		response = "broker_female_a_adamant_bonding_conversation_21_d",
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
					"broker_female_a_adamant_bonding_conversation_21_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_21_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_22_a",
		response = "broker_female_a_adamant_bonding_conversation_22_a",
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
					"adamant_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_22_a",
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
				"broker_female_a_adamant_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_22_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_22_b",
		response = "broker_female_a_adamant_bonding_conversation_22_b",
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
					"broker_female_a_adamant_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_22_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_22_c",
		response = "broker_female_a_adamant_bonding_conversation_22_c",
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
					"broker_female_a_adamant_bonding_conversation_22_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_22_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_22_d",
		response = "broker_female_a_adamant_bonding_conversation_22_d",
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
					"broker_female_a_adamant_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_22_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_23_a",
		response = "broker_female_a_adamant_bonding_conversation_23_a",
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
					"adamant_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_23_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_23_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_23_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_23_b",
		response = "broker_female_a_adamant_bonding_conversation_23_b",
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
					"broker_female_a_adamant_bonding_conversation_23_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_23_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_23_c",
		response = "broker_female_a_adamant_bonding_conversation_23_c",
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
					"broker_female_a_adamant_bonding_conversation_23_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_23_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_23_d",
		response = "broker_female_a_adamant_bonding_conversation_23_d",
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
					"broker_female_a_adamant_bonding_conversation_23_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_23_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_24_a",
		response = "broker_female_a_adamant_bonding_conversation_24_a",
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
					"adamant_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_24_a",
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
				"broker_female_a_adamant_bonding_conversation_24_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_24_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_24_b",
		response = "broker_female_a_adamant_bonding_conversation_24_b",
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
					"broker_female_a_adamant_bonding_conversation_24_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_24_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_24_c",
		response = "broker_female_a_adamant_bonding_conversation_24_c",
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
					"broker_female_a_adamant_bonding_conversation_24_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_24_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_24_d",
		response = "broker_female_a_adamant_bonding_conversation_24_d",
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
					"broker_female_a_adamant_bonding_conversation_24_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_24_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_25_a",
		response = "broker_female_a_adamant_bonding_conversation_25_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_male_c",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_25_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_25_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_25_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_25_b",
		response = "broker_female_a_adamant_bonding_conversation_25_b",
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
					"broker_female_a_adamant_bonding_conversation_25_a",
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
				"broker_female_a_adamant_bonding_conversation_25_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_25_c",
		response = "broker_female_a_adamant_bonding_conversation_25_c",
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
					"broker_female_a_adamant_bonding_conversation_25_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_25_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_25_d",
		response = "broker_female_a_adamant_bonding_conversation_25_d",
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
					"broker_female_a_adamant_bonding_conversation_25_c",
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
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_25_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_26_a",
		response = "broker_female_a_adamant_bonding_conversation_26_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_male_c",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_26_a",
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
				"broker_female_a_adamant_bonding_conversation_26_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_26_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_26_b",
		response = "broker_female_a_adamant_bonding_conversation_26_b",
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
					"broker_female_a_adamant_bonding_conversation_26_a",
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
				"broker_female_a_adamant_bonding_conversation_26_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_26_c",
		response = "broker_female_a_adamant_bonding_conversation_26_c",
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
					"broker_female_a_adamant_bonding_conversation_26_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_26_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_26_d",
		response = "broker_female_a_adamant_bonding_conversation_26_d",
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
					"broker_female_a_adamant_bonding_conversation_26_c",
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
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_26_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_27_a",
		response = "broker_female_a_adamant_bonding_conversation_27_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_male_c",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_27_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_27_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_27_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_27_b",
		response = "broker_female_a_adamant_bonding_conversation_27_b",
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
					"broker_female_a_adamant_bonding_conversation_27_a",
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
				"broker_female_a_adamant_bonding_conversation_27_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_27_c",
		response = "broker_female_a_adamant_bonding_conversation_27_c",
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
					"broker_female_a_adamant_bonding_conversation_27_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_27_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_27_d",
		response = "broker_female_a_adamant_bonding_conversation_27_d",
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
					"broker_female_a_adamant_bonding_conversation_27_c",
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
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_27_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_28_a",
		response = "broker_female_a_adamant_bonding_conversation_28_a",
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
					"adamant_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_28_a",
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
				"broker_female_a_adamant_bonding_conversation_28_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_28_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_28_b",
		response = "broker_female_a_adamant_bonding_conversation_28_b",
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
					"broker_female_a_adamant_bonding_conversation_28_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_28_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_28_c",
		response = "broker_female_a_adamant_bonding_conversation_28_c",
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
					"broker_female_a_adamant_bonding_conversation_28_b",
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
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_28_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_28_d",
		response = "broker_female_a_adamant_bonding_conversation_28_d",
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
					"broker_female_a_adamant_bonding_conversation_28_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_28_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_29_a",
		response = "broker_female_a_adamant_bonding_conversation_29_a",
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
					"adamant_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_29_a",
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
				"broker_female_a_adamant_bonding_conversation_29_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_29_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_29_b",
		response = "broker_female_a_adamant_bonding_conversation_29_b",
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
					"broker_female_a_adamant_bonding_conversation_29_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_29_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_29_c",
		response = "broker_female_a_adamant_bonding_conversation_29_c",
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
					"broker_female_a_adamant_bonding_conversation_29_b",
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
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_29_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_29_d",
		response = "broker_female_a_adamant_bonding_conversation_29_d",
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
					"broker_female_a_adamant_bonding_conversation_29_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_29_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_30_a",
		response = "broker_female_a_adamant_bonding_conversation_30_a",
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
					"adamant_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_30_a",
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
				"broker_female_a_adamant_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_30_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_30_b",
		response = "broker_female_a_adamant_bonding_conversation_30_b",
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
					"broker_female_a_adamant_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_30_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_30_c",
		response = "broker_female_a_adamant_bonding_conversation_30_c",
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
					"broker_female_a_adamant_bonding_conversation_30_b",
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
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_30_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_30_d",
		response = "broker_female_a_adamant_bonding_conversation_30_d",
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
					"broker_female_a_adamant_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_30_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_31_a",
		response = "broker_female_a_adamant_bonding_conversation_31_a",
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
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_adamant_female_c__combat_pause_one_liner_a_03",
					"loc_adamant_female_c__combat_pause_one_liner_a_04",
					"loc_adamant_female_c__combat_pause_one_liner_a_06",
					"loc_adamant_female_c__combat_pause_one_liner_a_08",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_31_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_31_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_31_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_31_b",
		response = "broker_female_a_adamant_bonding_conversation_31_b",
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
					"broker_female_a_adamant_bonding_conversation_31_a",
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
				"broker_female_a_adamant_bonding_conversation_31_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_31_c",
		response = "broker_female_a_adamant_bonding_conversation_31_c",
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
					"broker_female_a_adamant_bonding_conversation_31_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_31_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_31_d",
		response = "broker_female_a_adamant_bonding_conversation_31_d",
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
					"broker_female_a_adamant_bonding_conversation_31_c",
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
				"broker_female_a_adamant_bonding_conversation_31_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_32_a",
		response = "broker_female_a_adamant_bonding_conversation_32_a",
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
					"broker_female_a",
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
				"broker_female_a_adamant_bonding_conversation_32_a",
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
				"broker_female_a_adamant_bonding_conversation_32_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_32_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_32_b",
		response = "broker_female_a_adamant_bonding_conversation_32_b",
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
					"broker_female_a_adamant_bonding_conversation_32_a",
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
				"broker_female_a_adamant_bonding_conversation_32_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_32_c",
		response = "broker_female_a_adamant_bonding_conversation_32_c",
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
					"broker_female_a_adamant_bonding_conversation_32_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_32_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_32_d",
		response = "broker_female_a_adamant_bonding_conversation_32_d",
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
					"broker_female_a_adamant_bonding_conversation_32_c",
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
				"broker_female_a_adamant_bonding_conversation_32_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_33_a",
		response = "broker_female_a_adamant_bonding_conversation_33_a",
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
					"broker_female_a",
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
				"broker_female_a_adamant_bonding_conversation_33_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_33_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_33_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_33_b",
		response = "broker_female_a_adamant_bonding_conversation_33_b",
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
					"broker_female_a_adamant_bonding_conversation_33_a",
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
				"broker_female_a_adamant_bonding_conversation_33_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_33_c",
		response = "broker_female_a_adamant_bonding_conversation_33_c",
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
					"broker_female_a_adamant_bonding_conversation_33_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_33_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_33_d",
		response = "broker_female_a_adamant_bonding_conversation_33_d",
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
					"broker_female_a_adamant_bonding_conversation_33_c",
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
				"broker_female_a_adamant_bonding_conversation_33_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_34_a",
		response = "broker_female_a_adamant_bonding_conversation_34_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_34_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_34_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_34_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_34_b",
		response = "broker_female_a_adamant_bonding_conversation_34_b",
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
					"broker_female_a_adamant_bonding_conversation_34_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_34_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_34_c",
		response = "broker_female_a_adamant_bonding_conversation_34_c",
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
					"broker_female_a_adamant_bonding_conversation_34_b",
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
				"broker_female_a_adamant_bonding_conversation_34_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_34_d",
		response = "broker_female_a_adamant_bonding_conversation_34_d",
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
					"broker_female_a_adamant_bonding_conversation_34_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_34_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_35_a",
		response = "broker_female_a_adamant_bonding_conversation_35_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_35_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_adamant_bonding_conversation_35_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_35_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_35_b",
		response = "broker_female_a_adamant_bonding_conversation_35_b",
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
					"broker_female_a_adamant_bonding_conversation_35_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_35_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_35_c",
		response = "broker_female_a_adamant_bonding_conversation_35_c",
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
					"broker_female_a_adamant_bonding_conversation_35_b",
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
				"broker_female_a_adamant_bonding_conversation_35_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_35_d",
		response = "broker_female_a_adamant_bonding_conversation_35_d",
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
					"broker_female_a_adamant_bonding_conversation_35_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_35_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_36_a",
		response = "broker_female_a_adamant_bonding_conversation_36_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_36_a",
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
				"broker_female_a_adamant_bonding_conversation_36_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_adamant_bonding_conversation_36_a",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_36_b",
		response = "broker_female_a_adamant_bonding_conversation_36_b",
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
					"broker_female_a_adamant_bonding_conversation_36_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_36_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_36_c",
		response = "broker_female_a_adamant_bonding_conversation_36_c",
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
					"broker_female_a_adamant_bonding_conversation_36_b",
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
				"broker_female_a_adamant_bonding_conversation_36_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_adamant_bonding_conversation_36_d",
		response = "broker_female_a_adamant_bonding_conversation_36_d",
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
					"broker_female_a_adamant_bonding_conversation_36_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_adamant_bonding_conversation_36_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_01_a",
		response = "broker_female_a_ogryn_bonding_conversation_01_a",
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
					"broker_female_a",
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
				"broker_female_a_ogryn_bonding_conversation_01_a",
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
				"broker_female_a_ogryn_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_01_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_01_b",
		response = "broker_female_a_ogryn_bonding_conversation_01_b",
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
					"broker_female_a_ogryn_bonding_conversation_01_a",
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
				"broker_female_a_ogryn_bonding_conversation_01_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_01_c",
		response = "broker_female_a_ogryn_bonding_conversation_01_c",
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
					"broker_female_a_ogryn_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_01_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_01_d",
		response = "broker_female_a_ogryn_bonding_conversation_01_d",
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
					"broker_female_a_ogryn_bonding_conversation_01_c",
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
				"broker_female_a_ogryn_bonding_conversation_01_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_02_a",
		response = "broker_female_a_ogryn_bonding_conversation_02_a",
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
					"broker_female_a",
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
				"broker_female_a_ogryn_bonding_conversation_02_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_02_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_02_b",
		response = "broker_female_a_ogryn_bonding_conversation_02_b",
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
					"broker_female_a_ogryn_bonding_conversation_02_a",
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
				"broker_female_a_ogryn_bonding_conversation_02_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_02_c",
		response = "broker_female_a_ogryn_bonding_conversation_02_c",
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
					"broker_female_a_ogryn_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_02_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_02_d",
		response = "broker_female_a_ogryn_bonding_conversation_02_d",
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
					"broker_female_a_ogryn_bonding_conversation_02_c",
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
				"broker_female_a_ogryn_bonding_conversation_02_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_03_a",
		response = "broker_female_a_ogryn_bonding_conversation_03_a",
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
					"broker_female_a",
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
				"broker_female_a_ogryn_bonding_conversation_03_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_03_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_03_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_03_b",
		response = "broker_female_a_ogryn_bonding_conversation_03_b",
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
					"broker_female_a_ogryn_bonding_conversation_03_a",
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
				"broker_female_a_ogryn_bonding_conversation_03_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_03_c",
		response = "broker_female_a_ogryn_bonding_conversation_03_c",
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
					"broker_female_a_ogryn_bonding_conversation_03_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_03_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_03_d",
		response = "broker_female_a_ogryn_bonding_conversation_03_d",
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
					"broker_female_a_ogryn_bonding_conversation_03_c",
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
				"broker_female_a_ogryn_bonding_conversation_03_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_04_a",
		response = "broker_female_a_ogryn_bonding_conversation_04_a",
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
					"ogryn_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_04_a",
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
				"broker_female_a_ogryn_bonding_conversation_04_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_04_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_04_b",
		response = "broker_female_a_ogryn_bonding_conversation_04_b",
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
					"broker_female_a_ogryn_bonding_conversation_04_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_04_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_04_c",
		response = "broker_female_a_ogryn_bonding_conversation_04_c",
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
					"broker_female_a_ogryn_bonding_conversation_04_b",
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
				"broker_female_a_ogryn_bonding_conversation_04_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_04_d",
		response = "broker_female_a_ogryn_bonding_conversation_04_d",
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
					"broker_female_a_ogryn_bonding_conversation_04_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_04_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_05_a",
		response = "broker_female_a_ogryn_bonding_conversation_05_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_05_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_05_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_05_b",
		response = "broker_female_a_ogryn_bonding_conversation_05_b",
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
					"broker_female_a_ogryn_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_05_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_05_c",
		response = "broker_female_a_ogryn_bonding_conversation_05_c",
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
					"broker_female_a_ogryn_bonding_conversation_05_b",
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
				"broker_female_a_ogryn_bonding_conversation_05_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_05_d",
		response = "broker_female_a_ogryn_bonding_conversation_05_d",
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
					"broker_female_a_ogryn_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_05_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_05_e",
		response = "broker_female_a_ogryn_bonding_conversation_05_e",
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
					"broker_female_a_ogryn_bonding_conversation_05_d",
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
				"broker_female_a_ogryn_bonding_conversation_05_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_06_a",
		response = "broker_female_a_ogryn_bonding_conversation_06_a",
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
					"ogryn_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_06_a",
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
				"broker_female_a_ogryn_bonding_conversation_06_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_06_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_06_b",
		response = "broker_female_a_ogryn_bonding_conversation_06_b",
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
					"broker_female_a_ogryn_bonding_conversation_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_06_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_06_c",
		response = "broker_female_a_ogryn_bonding_conversation_06_c",
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
					"broker_female_a_ogryn_bonding_conversation_06_b",
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
				"broker_female_a_ogryn_bonding_conversation_06_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_06_d",
		response = "broker_female_a_ogryn_bonding_conversation_06_d",
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
					"broker_female_a_ogryn_bonding_conversation_06_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_06_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_06_e",
		response = "broker_female_a_ogryn_bonding_conversation_06_e",
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
					"broker_female_a_ogryn_bonding_conversation_06_d",
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
				"broker_female_a_ogryn_bonding_conversation_06_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_07_a",
		response = "broker_female_a_ogryn_bonding_conversation_07_a",
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
					"broker_female_a",
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
				"broker_female_a_ogryn_bonding_conversation_07_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_07_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_07_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_07_b",
		response = "broker_female_a_ogryn_bonding_conversation_07_b",
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
					"broker_female_a_ogryn_bonding_conversation_07_a",
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
				"broker_female_a_ogryn_bonding_conversation_07_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_07_c",
		response = "broker_female_a_ogryn_bonding_conversation_07_c",
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
					"broker_female_a_ogryn_bonding_conversation_07_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_07_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_07_d",
		response = "broker_female_a_ogryn_bonding_conversation_07_d",
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
					"broker_female_a_ogryn_bonding_conversation_07_c",
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
				"broker_female_a_ogryn_bonding_conversation_07_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_08_a",
		response = "broker_female_a_ogryn_bonding_conversation_08_a",
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
					"broker_female_a",
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
				"broker_female_a_ogryn_bonding_conversation_08_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_08_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_08_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_08_b",
		response = "broker_female_a_ogryn_bonding_conversation_08_b",
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
					"broker_female_a_ogryn_bonding_conversation_08_a",
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
				"broker_female_a_ogryn_bonding_conversation_08_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_08_c",
		response = "broker_female_a_ogryn_bonding_conversation_08_c",
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
					"broker_female_a_ogryn_bonding_conversation_08_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_08_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_08_d",
		response = "broker_female_a_ogryn_bonding_conversation_08_d",
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
					"broker_female_a_ogryn_bonding_conversation_08_c",
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
				"broker_female_a_ogryn_bonding_conversation_08_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_09_a",
		response = "broker_female_a_ogryn_bonding_conversation_09_a",
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
					"broker_female_a",
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
				"broker_female_a_ogryn_bonding_conversation_09_a",
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
				"broker_female_a_ogryn_bonding_conversation_09_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_09_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_09_b",
		response = "broker_female_a_ogryn_bonding_conversation_09_b",
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
					"broker_female_a_ogryn_bonding_conversation_09_a",
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
				"broker_female_a_ogryn_bonding_conversation_09_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_09_c",
		response = "broker_female_a_ogryn_bonding_conversation_09_c",
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
					"broker_female_a_ogryn_bonding_conversation_09_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_09_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_09_d",
		response = "broker_female_a_ogryn_bonding_conversation_09_d",
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
					"broker_female_a_ogryn_bonding_conversation_09_c",
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
				"broker_female_a_ogryn_bonding_conversation_09_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_10_a",
		response = "broker_female_a_ogryn_bonding_conversation_10_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_10_a",
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
				"broker_female_a_ogryn_bonding_conversation_10_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_10_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_10_b",
		response = "broker_female_a_ogryn_bonding_conversation_10_b",
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
					"broker_female_a_ogryn_bonding_conversation_10_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_10_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_10_c",
		response = "broker_female_a_ogryn_bonding_conversation_10_c",
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
					"broker_female_a_ogryn_bonding_conversation_10_b",
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
				"broker_female_a_ogryn_bonding_conversation_10_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_10_d",
		response = "broker_female_a_ogryn_bonding_conversation_10_d",
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
					"broker_female_a_ogryn_bonding_conversation_10_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_10_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_11_a",
		response = "broker_female_a_ogryn_bonding_conversation_11_a",
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
					"ogryn_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_11_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
			{
				"user_memory",
				"reload_failed_out_of_ammo",
				OP.TIMEDIFF,
				OP.LT,
				60,
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_11_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_11_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_11_b",
		response = "broker_female_a_ogryn_bonding_conversation_11_b",
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
					"broker_female_a_ogryn_bonding_conversation_11_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_11_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_11_c",
		response = "broker_female_a_ogryn_bonding_conversation_11_c",
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
					"broker_female_a_ogryn_bonding_conversation_11_b",
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
				"broker_female_a_ogryn_bonding_conversation_11_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_11_d",
		response = "broker_female_a_ogryn_bonding_conversation_11_d",
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
					"broker_female_a_ogryn_bonding_conversation_11_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_11_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_12_a",
		response = "broker_female_a_ogryn_bonding_conversation_12_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_12_a",
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
				"broker_female_a_ogryn_bonding_conversation_12_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_12_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_12_b",
		response = "broker_female_a_ogryn_bonding_conversation_12_b",
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
					"broker_female_a_ogryn_bonding_conversation_12_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_12_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_12_c",
		response = "broker_female_a_ogryn_bonding_conversation_12_c",
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
					"broker_female_a_ogryn_bonding_conversation_12_b",
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
				"broker_female_a_ogryn_bonding_conversation_12_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_12_d",
		response = "broker_female_a_ogryn_bonding_conversation_12_d",
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
					"broker_female_a_ogryn_bonding_conversation_12_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_12_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_13_a",
		response = "broker_female_a_ogryn_bonding_conversation_13_a",
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
					"broker_female_a",
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
				"broker_female_a_ogryn_bonding_conversation_13_a",
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
				"broker_female_a_ogryn_bonding_conversation_13_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_13_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_13_b",
		response = "broker_female_a_ogryn_bonding_conversation_13_b",
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
					"broker_female_a_ogryn_bonding_conversation_13_a",
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
				"broker_female_a_ogryn_bonding_conversation_13_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_13_c",
		response = "broker_female_a_ogryn_bonding_conversation_13_c",
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
					"broker_female_a_ogryn_bonding_conversation_13_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_13_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_13_d",
		response = "broker_female_a_ogryn_bonding_conversation_13_d",
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
					"broker_female_a_ogryn_bonding_conversation_13_c",
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
				"broker_female_a_ogryn_bonding_conversation_13_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_14_a",
		response = "broker_female_a_ogryn_bonding_conversation_14_a",
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
					"broker_female_a",
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
				"broker_female_a_ogryn_bonding_conversation_14_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_14_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_14_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_14_b",
		response = "broker_female_a_ogryn_bonding_conversation_14_b",
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
					"broker_female_a_ogryn_bonding_conversation_14_a",
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
				"broker_female_a_ogryn_bonding_conversation_14_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_14_c",
		response = "broker_female_a_ogryn_bonding_conversation_14_c",
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
					"broker_female_a_ogryn_bonding_conversation_14_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_14_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_14_d",
		response = "broker_female_a_ogryn_bonding_conversation_14_d",
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
					"broker_female_a_ogryn_bonding_conversation_14_c",
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
				"broker_female_a_ogryn_bonding_conversation_14_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_15_a",
		response = "broker_female_a_ogryn_bonding_conversation_15_a",
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
					"broker_female_a",
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
				"broker_female_a_ogryn_bonding_conversation_15_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_15_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_15_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_15_b",
		response = "broker_female_a_ogryn_bonding_conversation_15_b",
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
					"broker_female_a_ogryn_bonding_conversation_15_a",
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
				"broker_female_a_ogryn_bonding_conversation_15_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_15_c",
		response = "broker_female_a_ogryn_bonding_conversation_15_c",
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
					"broker_female_a_ogryn_bonding_conversation_15_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_15_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_15_d",
		response = "broker_female_a_ogryn_bonding_conversation_15_d",
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
					"broker_female_a_ogryn_bonding_conversation_15_c",
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
				"broker_female_a_ogryn_bonding_conversation_15_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_16_a",
		response = "broker_female_a_ogryn_bonding_conversation_16_a",
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
					"ogryn_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_16_a",
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
				"broker_female_a_ogryn_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_16_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_16_b",
		response = "broker_female_a_ogryn_bonding_conversation_16_b",
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
					"broker_female_a_ogryn_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_16_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_16_c",
		response = "broker_female_a_ogryn_bonding_conversation_16_c",
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
					"broker_female_a_ogryn_bonding_conversation_16_b",
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
				"broker_female_a_ogryn_bonding_conversation_16_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_16_d",
		response = "broker_female_a_ogryn_bonding_conversation_16_d",
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
					"broker_female_a_ogryn_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_16_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_17_a",
		response = "broker_female_a_ogryn_bonding_conversation_17_a",
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
					"ogryn_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_17_a",
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
				"broker_female_a_ogryn_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_17_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_17_b",
		response = "broker_female_a_ogryn_bonding_conversation_17_b",
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
					"broker_female_a_ogryn_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_17_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_17_c",
		response = "broker_female_a_ogryn_bonding_conversation_17_c",
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
					"broker_female_a_ogryn_bonding_conversation_17_b",
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
				"broker_female_a_ogryn_bonding_conversation_17_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_17_d",
		response = "broker_female_a_ogryn_bonding_conversation_17_d",
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
					"broker_female_a_ogryn_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_17_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_18_a",
		response = "broker_female_a_ogryn_bonding_conversation_18_a",
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
					"ogryn_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_18_a",
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
				"broker_female_a_ogryn_bonding_conversation_18_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_18_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_18_b",
		response = "broker_female_a_ogryn_bonding_conversation_18_b",
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
					"broker_female_a_ogryn_bonding_conversation_18_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_18_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_18_c",
		response = "broker_female_a_ogryn_bonding_conversation_18_c",
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
					"broker_female_a_ogryn_bonding_conversation_18_b",
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
				"broker_female_a_ogryn_bonding_conversation_18_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_18_d",
		response = "broker_female_a_ogryn_bonding_conversation_18_d",
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
					"broker_female_a_ogryn_bonding_conversation_18_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_18_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_19_a",
		response = "broker_female_a_ogryn_bonding_conversation_19_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_d",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_19_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_19_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_19_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_19_b",
		response = "broker_female_a_ogryn_bonding_conversation_19_b",
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
					"broker_female_a_ogryn_bonding_conversation_19_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_19_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_19_c",
		response = "broker_female_a_ogryn_bonding_conversation_19_c",
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
					"broker_female_a_ogryn_bonding_conversation_19_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_19_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_19_d",
		response = "broker_female_a_ogryn_bonding_conversation_19_d",
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
					"broker_female_a_ogryn_bonding_conversation_19_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_19_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_20_a",
		response = "broker_female_a_ogryn_bonding_conversation_20_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_d",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_20_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_20_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_20_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_20_b",
		response = "broker_female_a_ogryn_bonding_conversation_20_b",
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
					"broker_female_a_ogryn_bonding_conversation_20_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_20_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_20_c",
		response = "broker_female_a_ogryn_bonding_conversation_20_c",
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
					"broker_female_a_ogryn_bonding_conversation_20_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_20_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_20_d",
		response = "broker_female_a_ogryn_bonding_conversation_20_d",
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
					"broker_female_a_ogryn_bonding_conversation_20_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_20_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_21_a",
		response = "broker_female_a_ogryn_bonding_conversation_21_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_d",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_21_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_21_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_21_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_21_b",
		response = "broker_female_a_ogryn_bonding_conversation_21_b",
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
					"broker_female_a_ogryn_bonding_conversation_21_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_21_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_21_c",
		response = "broker_female_a_ogryn_bonding_conversation_21_c",
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
					"broker_female_a_ogryn_bonding_conversation_21_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_21_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_21_d",
		response = "broker_female_a_ogryn_bonding_conversation_21_d",
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
					"broker_female_a_ogryn_bonding_conversation_21_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_21_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_22_a",
		response = "broker_female_a_ogryn_bonding_conversation_22_a",
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
					"ogryn_d",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_22_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_22_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_22_b",
		response = "broker_female_a_ogryn_bonding_conversation_22_b",
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
					"broker_female_a_ogryn_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_22_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_22_c",
		response = "broker_female_a_ogryn_bonding_conversation_22_c",
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
					"broker_female_a_ogryn_bonding_conversation_22_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_22_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_22_d",
		response = "broker_female_a_ogryn_bonding_conversation_22_d",
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
					"broker_female_a_ogryn_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_22_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_23_a",
		response = "broker_female_a_ogryn_bonding_conversation_23_a",
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
					"ogryn_d",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_23_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_23_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_23_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_23_b",
		response = "broker_female_a_ogryn_bonding_conversation_23_b",
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
					"broker_female_a_ogryn_bonding_conversation_23_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_23_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_23_c",
		response = "broker_female_a_ogryn_bonding_conversation_23_c",
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
					"broker_female_a_ogryn_bonding_conversation_23_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_23_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_23_d",
		response = "broker_female_a_ogryn_bonding_conversation_23_d",
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
					"broker_female_a_ogryn_bonding_conversation_23_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_23_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_24_a",
		response = "broker_female_a_ogryn_bonding_conversation_24_a",
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
					"ogryn_d",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_24_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_ogryn_bonding_conversation_24_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_ogryn_bonding_conversation_24_a",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_24_b",
		response = "broker_female_a_ogryn_bonding_conversation_24_b",
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
					"broker_female_a_ogryn_bonding_conversation_24_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_24_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_24_c",
		response = "broker_female_a_ogryn_bonding_conversation_24_c",
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
					"broker_female_a_ogryn_bonding_conversation_24_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_24_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_ogryn_bonding_conversation_24_d",
		response = "broker_female_a_ogryn_bonding_conversation_24_d",
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
					"broker_female_a_ogryn_bonding_conversation_24_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_ogryn_bonding_conversation_24_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_01_a",
		response = "broker_female_a_psyker_bonding_conversation_01_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_01_a",
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
				"broker_female_a_psyker_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_01_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_01_b",
		response = "broker_female_a_psyker_bonding_conversation_01_b",
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
					"broker_female_a_psyker_bonding_conversation_01_a",
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
				"broker_female_a_psyker_bonding_conversation_01_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_01_c",
		response = "broker_female_a_psyker_bonding_conversation_01_c",
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
					"broker_female_a_psyker_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_01_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_01_d",
		response = "broker_female_a_psyker_bonding_conversation_01_d",
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
					"broker_female_a_psyker_bonding_conversation_01_c",
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
				"broker_female_a_psyker_bonding_conversation_01_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_02_a",
		response = "broker_female_a_psyker_bonding_conversation_02_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_02_a",
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
				"broker_female_a_psyker_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_02_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_02_b",
		response = "broker_female_a_psyker_bonding_conversation_02_b",
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
					"broker_female_a_psyker_bonding_conversation_02_a",
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
				"broker_female_a_psyker_bonding_conversation_02_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_02_c",
		response = "broker_female_a_psyker_bonding_conversation_02_c",
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
					"broker_female_a_psyker_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_02_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_02_d",
		response = "broker_female_a_psyker_bonding_conversation_02_d",
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
					"broker_female_a_psyker_bonding_conversation_02_c",
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
				"broker_female_a_psyker_bonding_conversation_02_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_03_a",
		response = "broker_female_a_psyker_bonding_conversation_03_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_03_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_psyker_bonding_conversation_03_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_03_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_03_b",
		response = "broker_female_a_psyker_bonding_conversation_03_b",
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
					"broker_female_a_psyker_bonding_conversation_03_a",
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
				"broker_female_a_psyker_bonding_conversation_03_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_03_c",
		response = "broker_female_a_psyker_bonding_conversation_03_c",
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
					"broker_female_a_psyker_bonding_conversation_03_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_03_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_03_d",
		response = "broker_female_a_psyker_bonding_conversation_03_d",
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
					"broker_female_a_psyker_bonding_conversation_03_c",
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
				"broker_female_a_psyker_bonding_conversation_03_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_04_a",
		response = "broker_female_a_psyker_bonding_conversation_04_a",
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
					"psyker_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_04_a",
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
				"broker_female_a_psyker_bonding_conversation_04_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_04_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_04_b",
		response = "broker_female_a_psyker_bonding_conversation_04_b",
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
					"broker_female_a_psyker_bonding_conversation_04_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_04_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_04_c",
		response = "broker_female_a_psyker_bonding_conversation_04_c",
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
					"broker_female_a_psyker_bonding_conversation_04_b",
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
				"broker_female_a_psyker_bonding_conversation_04_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_04_d",
		response = "broker_female_a_psyker_bonding_conversation_04_d",
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
					"broker_female_a_psyker_bonding_conversation_04_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_04_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_05_a",
		response = "broker_female_a_psyker_bonding_conversation_05_a",
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
					"psyker_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_05_a",
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
				"broker_female_a_psyker_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_05_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_05_b",
		response = "broker_female_a_psyker_bonding_conversation_05_b",
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
					"broker_female_a_psyker_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_05_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_05_c",
		response = "broker_female_a_psyker_bonding_conversation_05_c",
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
					"broker_female_a_psyker_bonding_conversation_05_b",
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
				"broker_female_a_psyker_bonding_conversation_05_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_05_d",
		response = "broker_female_a_psyker_bonding_conversation_05_d",
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
					"broker_female_a_psyker_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_05_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_06_a",
		response = "broker_female_a_psyker_bonding_conversation_06_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_06_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_psyker_bonding_conversation_06_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_06_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_06_b",
		response = "broker_female_a_psyker_bonding_conversation_06_b",
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
					"broker_female_a_psyker_bonding_conversation_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_06_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_06_c",
		response = "broker_female_a_psyker_bonding_conversation_06_c",
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
					"broker_female_a_psyker_bonding_conversation_06_b",
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
				"broker_female_a_psyker_bonding_conversation_06_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_06_d",
		response = "broker_female_a_psyker_bonding_conversation_06_d",
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
					"broker_female_a_psyker_bonding_conversation_06_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_06_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_07_a",
		response = "broker_female_a_psyker_bonding_conversation_07_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_07_a",
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
				"broker_female_a_psyker_bonding_conversation_07_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_07_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_07_b",
		response = "broker_female_a_psyker_bonding_conversation_07_b",
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
					"broker_female_a_psyker_bonding_conversation_07_a",
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
				"broker_female_a_psyker_bonding_conversation_07_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_07_c",
		response = "broker_female_a_psyker_bonding_conversation_07_c",
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
					"broker_female_a_psyker_bonding_conversation_07_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_07_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_07_d",
		response = "broker_female_a_psyker_bonding_conversation_07_d",
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
					"broker_female_a_psyker_bonding_conversation_07_c",
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
				"broker_female_a_psyker_bonding_conversation_07_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_08_a",
		response = "broker_female_a_psyker_bonding_conversation_08_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_08_a",
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
				"broker_female_a_psyker_bonding_conversation_08_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_08_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_08_b",
		response = "broker_female_a_psyker_bonding_conversation_08_b",
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
					"broker_female_a_psyker_bonding_conversation_08_a",
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
				"broker_female_a_psyker_bonding_conversation_08_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_08_c",
		response = "broker_female_a_psyker_bonding_conversation_08_c",
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
					"broker_female_a_psyker_bonding_conversation_08_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_08_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_08_d",
		response = "broker_female_a_psyker_bonding_conversation_08_d",
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
					"broker_female_a_psyker_bonding_conversation_08_c",
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
				"broker_female_a_psyker_bonding_conversation_08_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_09_a",
		response = "broker_female_a_psyker_bonding_conversation_09_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_09_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_psyker_bonding_conversation_09_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_09_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_09_b",
		response = "broker_female_a_psyker_bonding_conversation_09_b",
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
					"broker_female_a_psyker_bonding_conversation_09_a",
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
				"broker_female_a_psyker_bonding_conversation_09_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_09_c",
		response = "broker_female_a_psyker_bonding_conversation_09_c",
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
					"broker_female_a_psyker_bonding_conversation_09_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_09_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_09_d",
		response = "broker_female_a_psyker_bonding_conversation_09_d",
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
					"broker_female_a_psyker_bonding_conversation_09_c",
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
				"broker_female_a_psyker_bonding_conversation_09_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_10_a",
		response = "broker_female_a_psyker_bonding_conversation_10_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_10_a",
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
				"broker_female_a_psyker_bonding_conversation_10_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_10_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_10_b",
		response = "broker_female_a_psyker_bonding_conversation_10_b",
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
					"broker_female_a_psyker_bonding_conversation_10_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_10_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_10_c",
		response = "broker_female_a_psyker_bonding_conversation_10_c",
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
					"broker_female_a_psyker_bonding_conversation_10_b",
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
				"broker_female_a_psyker_bonding_conversation_10_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_10_d",
		response = "broker_female_a_psyker_bonding_conversation_10_d",
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
					"broker_female_a_psyker_bonding_conversation_10_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_10_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_11_a",
		response = "broker_female_a_psyker_bonding_conversation_11_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_11_a",
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
				"broker_female_a_psyker_bonding_conversation_11_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_11_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_11_b",
		response = "broker_female_a_psyker_bonding_conversation_11_b",
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
					"broker_female_a_psyker_bonding_conversation_11_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_11_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_11_c",
		response = "broker_female_a_psyker_bonding_conversation_11_c",
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
					"broker_female_a_psyker_bonding_conversation_11_b",
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
				"broker_female_a_psyker_bonding_conversation_11_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_11_d",
		response = "broker_female_a_psyker_bonding_conversation_11_d",
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
					"broker_female_a_psyker_bonding_conversation_11_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_11_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_12_a",
		response = "broker_female_a_psyker_bonding_conversation_12_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_12_a",
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
				"broker_female_a_psyker_bonding_conversation_12_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_12_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_12_b",
		response = "broker_female_a_psyker_bonding_conversation_12_b",
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
					"broker_female_a_psyker_bonding_conversation_12_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_12_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_12_c",
		response = "broker_female_a_psyker_bonding_conversation_12_c",
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
					"broker_female_a_psyker_bonding_conversation_12_b",
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
				"broker_female_a_psyker_bonding_conversation_12_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_12_d",
		response = "broker_female_a_psyker_bonding_conversation_12_d",
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
					"broker_female_a_psyker_bonding_conversation_12_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_12_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_13_a",
		response = "broker_female_a_psyker_bonding_conversation_13_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_13_a",
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
				"broker_female_a_psyker_bonding_conversation_13_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_13_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_13_b",
		response = "broker_female_a_psyker_bonding_conversation_13_b",
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
					"broker_female_a_psyker_bonding_conversation_13_a",
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
				"broker_female_a_psyker_bonding_conversation_13_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_13_c",
		response = "broker_female_a_psyker_bonding_conversation_13_c",
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
					"broker_female_a_psyker_bonding_conversation_13_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_13_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_13_d",
		response = "broker_female_a_psyker_bonding_conversation_13_d",
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
					"broker_female_a_psyker_bonding_conversation_13_c",
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
				"broker_female_a_psyker_bonding_conversation_13_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_14_a",
		response = "broker_female_a_psyker_bonding_conversation_14_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_14_a",
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
				"broker_female_a_psyker_bonding_conversation_14_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_14_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_14_b",
		response = "broker_female_a_psyker_bonding_conversation_14_b",
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
					"broker_female_a_psyker_bonding_conversation_14_a",
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
				"broker_female_a_psyker_bonding_conversation_14_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_14_c",
		response = "broker_female_a_psyker_bonding_conversation_14_c",
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
					"broker_female_a_psyker_bonding_conversation_14_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_14_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_14_d",
		response = "broker_female_a_psyker_bonding_conversation_14_d",
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
					"broker_female_a_psyker_bonding_conversation_14_c",
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
				"broker_female_a_psyker_bonding_conversation_14_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_15_a",
		response = "broker_female_a_psyker_bonding_conversation_15_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_15_a",
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
				"broker_female_a_psyker_bonding_conversation_15_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_15_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_15_b",
		response = "broker_female_a_psyker_bonding_conversation_15_b",
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
					"broker_female_a_psyker_bonding_conversation_15_a",
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
				"broker_female_a_psyker_bonding_conversation_15_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_15_c",
		response = "broker_female_a_psyker_bonding_conversation_15_c",
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
					"broker_female_a_psyker_bonding_conversation_15_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_15_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_15_d",
		response = "broker_female_a_psyker_bonding_conversation_15_d",
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
					"broker_female_a_psyker_bonding_conversation_15_c",
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
				"broker_female_a_psyker_bonding_conversation_15_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_16_a",
		response = "broker_female_a_psyker_bonding_conversation_16_a",
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
					"psyker_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_16_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_psyker_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_16_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_16_b",
		response = "broker_female_a_psyker_bonding_conversation_16_b",
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
					"broker_female_a_psyker_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_16_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_16_c",
		response = "broker_female_a_psyker_bonding_conversation_16_c",
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
					"broker_female_a_psyker_bonding_conversation_16_b",
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
				"broker_female_a_psyker_bonding_conversation_16_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_16_d",
		response = "broker_female_a_psyker_bonding_conversation_16_d",
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
					"broker_female_a_psyker_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_16_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_17_a",
		response = "broker_female_a_psyker_bonding_conversation_17_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_17_a",
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
				"broker_female_a_psyker_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_17_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_17_b",
		response = "broker_female_a_psyker_bonding_conversation_17_b",
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
					"broker_female_a_psyker_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_17_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_17_c",
		response = "broker_female_a_psyker_bonding_conversation_17_c",
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
					"broker_female_a_psyker_bonding_conversation_17_b",
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
				"broker_female_a_psyker_bonding_conversation_17_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_17_d",
		response = "broker_female_a_psyker_bonding_conversation_17_d",
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
					"broker_female_a_psyker_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_17_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_18_a",
		response = "broker_female_a_psyker_bonding_conversation_18_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_18_a",
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
				"broker_female_a_psyker_bonding_conversation_18_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_18_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_18_b",
		response = "broker_female_a_psyker_bonding_conversation_18_b",
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
					"broker_female_a_psyker_bonding_conversation_18_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_18_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_18_c",
		response = "broker_female_a_psyker_bonding_conversation_18_c",
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
					"broker_female_a_psyker_bonding_conversation_18_b",
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
				"broker_female_a_psyker_bonding_conversation_18_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_18_d",
		response = "broker_female_a_psyker_bonding_conversation_18_d",
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
					"broker_female_a_psyker_bonding_conversation_18_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_18_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_19_a",
		response = "broker_female_a_psyker_bonding_conversation_19_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_19_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_psyker_bonding_conversation_19_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_19_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_19_b",
		response = "broker_female_a_psyker_bonding_conversation_19_b",
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
					"broker_female_a_psyker_bonding_conversation_19_a",
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
				"broker_female_a_psyker_bonding_conversation_19_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_19_c",
		response = "broker_female_a_psyker_bonding_conversation_19_c",
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
					"broker_female_a_psyker_bonding_conversation_19_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_19_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_19_d",
		response = "broker_female_a_psyker_bonding_conversation_19_d",
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
					"broker_female_a_psyker_bonding_conversation_19_c",
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
				"broker_female_a_psyker_bonding_conversation_19_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_20_a",
		response = "broker_female_a_psyker_bonding_conversation_20_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_20_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_psyker_bonding_conversation_20_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_20_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_20_b",
		response = "broker_female_a_psyker_bonding_conversation_20_b",
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
					"broker_female_a_psyker_bonding_conversation_20_a",
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
				"broker_female_a_psyker_bonding_conversation_20_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_20_c",
		response = "broker_female_a_psyker_bonding_conversation_20_c",
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
					"broker_female_a_psyker_bonding_conversation_20_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_20_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_20_d",
		response = "broker_female_a_psyker_bonding_conversation_20_d",
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
					"broker_female_a_psyker_bonding_conversation_20_c",
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
				"broker_female_a_psyker_bonding_conversation_20_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_21_a",
		response = "broker_female_a_psyker_bonding_conversation_21_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_21_a",
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
				"broker_female_a_psyker_bonding_conversation_21_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_21_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_21_b",
		response = "broker_female_a_psyker_bonding_conversation_21_b",
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
					"broker_female_a_psyker_bonding_conversation_21_a",
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
				"broker_female_a_psyker_bonding_conversation_21_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_21_c",
		response = "broker_female_a_psyker_bonding_conversation_21_c",
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
					"broker_female_a_psyker_bonding_conversation_21_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_21_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_21_d",
		response = "broker_female_a_psyker_bonding_conversation_21_d",
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
					"broker_female_a_psyker_bonding_conversation_21_c",
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
				"broker_female_a_psyker_bonding_conversation_21_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_22_a",
		response = "broker_female_a_psyker_bonding_conversation_22_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_22_a",
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
				"broker_female_a_psyker_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_22_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_22_b",
		response = "broker_female_a_psyker_bonding_conversation_22_b",
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
					"broker_female_a_psyker_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_22_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_22_c",
		response = "broker_female_a_psyker_bonding_conversation_22_c",
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
					"broker_female_a_psyker_bonding_conversation_22_b",
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
				"broker_female_a_psyker_bonding_conversation_22_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_22_d",
		response = "broker_female_a_psyker_bonding_conversation_22_d",
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
					"broker_female_a_psyker_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_22_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_23_a",
		response = "broker_female_a_psyker_bonding_conversation_23_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_23_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_psyker_bonding_conversation_23_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_23_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_23_b",
		response = "broker_female_a_psyker_bonding_conversation_23_b",
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
					"broker_female_a_psyker_bonding_conversation_23_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_23_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_23_c",
		response = "broker_female_a_psyker_bonding_conversation_23_c",
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
					"broker_female_a_psyker_bonding_conversation_23_b",
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
				"broker_female_a_psyker_bonding_conversation_23_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_23_d",
		response = "broker_female_a_psyker_bonding_conversation_23_d",
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
					"broker_female_a_psyker_bonding_conversation_23_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_23_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_24_a",
		response = "broker_female_a_psyker_bonding_conversation_24_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_24_a",
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
				"broker_female_a_psyker_bonding_conversation_24_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_24_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_24_b",
		response = "broker_female_a_psyker_bonding_conversation_24_b",
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
					"broker_female_a_psyker_bonding_conversation_24_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_24_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_24_c",
		response = "broker_female_a_psyker_bonding_conversation_24_c",
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
					"broker_female_a_psyker_bonding_conversation_24_b",
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
				"broker_female_a_psyker_bonding_conversation_24_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_24_d",
		response = "broker_female_a_psyker_bonding_conversation_24_d",
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
					"broker_female_a_psyker_bonding_conversation_24_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_24_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_25_a",
		response = "broker_female_a_psyker_bonding_conversation_25_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_25_a",
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
				"broker_female_a_psyker_bonding_conversation_25_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_25_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_25_b",
		response = "broker_female_a_psyker_bonding_conversation_25_b",
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
					"broker_female_a_psyker_bonding_conversation_25_a",
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
				"broker_female_a_psyker_bonding_conversation_25_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_25_c",
		response = "broker_female_a_psyker_bonding_conversation_25_c",
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
					"broker_female_a_psyker_bonding_conversation_25_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_25_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_25_d",
		response = "broker_female_a_psyker_bonding_conversation_25_d",
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
					"broker_female_a_psyker_bonding_conversation_25_c",
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
				"broker_female_a_psyker_bonding_conversation_25_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_26_a",
		response = "broker_female_a_psyker_bonding_conversation_26_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_26_a",
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
				"broker_female_a_psyker_bonding_conversation_26_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_26_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_26_b",
		response = "broker_female_a_psyker_bonding_conversation_26_b",
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
					"broker_female_a_psyker_bonding_conversation_26_a",
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
				"broker_female_a_psyker_bonding_conversation_26_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_26_c",
		response = "broker_female_a_psyker_bonding_conversation_26_c",
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
					"broker_female_a_psyker_bonding_conversation_26_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_26_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_26_d",
		response = "broker_female_a_psyker_bonding_conversation_26_d",
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
					"broker_female_a_psyker_bonding_conversation_26_c",
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
				"broker_female_a_psyker_bonding_conversation_26_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_27_a",
		response = "broker_female_a_psyker_bonding_conversation_27_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_27_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_psyker_bonding_conversation_27_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_27_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_27_b",
		response = "broker_female_a_psyker_bonding_conversation_27_b",
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
					"broker_female_a_psyker_bonding_conversation_27_a",
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
				"broker_female_a_psyker_bonding_conversation_27_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_27_c",
		response = "broker_female_a_psyker_bonding_conversation_27_c",
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
					"broker_female_a_psyker_bonding_conversation_27_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_27_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_27_d",
		response = "broker_female_a_psyker_bonding_conversation_27_d",
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
					"broker_female_a_psyker_bonding_conversation_27_c",
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
				"broker_female_a_psyker_bonding_conversation_27_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_28_a",
		response = "broker_female_a_psyker_bonding_conversation_28_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_28_a",
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
				"broker_female_a_psyker_bonding_conversation_28_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_28_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_28_b",
		response = "broker_female_a_psyker_bonding_conversation_28_b",
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
					"broker_female_a_psyker_bonding_conversation_28_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_28_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_28_c",
		response = "broker_female_a_psyker_bonding_conversation_28_c",
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
					"broker_female_a_psyker_bonding_conversation_28_b",
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
				"broker_female_a_psyker_bonding_conversation_28_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_28_d",
		response = "broker_female_a_psyker_bonding_conversation_28_d",
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
					"broker_female_a_psyker_bonding_conversation_28_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_28_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_29_a",
		response = "broker_female_a_psyker_bonding_conversation_29_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_29_a",
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
				"broker_female_a_psyker_bonding_conversation_29_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_29_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_29_b",
		response = "broker_female_a_psyker_bonding_conversation_29_b",
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
					"broker_female_a_psyker_bonding_conversation_29_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_29_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_29_c",
		response = "broker_female_a_psyker_bonding_conversation_29_c",
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
					"broker_female_a_psyker_bonding_conversation_29_b",
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
				"broker_female_a_psyker_bonding_conversation_29_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_29_d",
		response = "broker_female_a_psyker_bonding_conversation_29_d",
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
					"broker_female_a_psyker_bonding_conversation_29_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_29_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_30_a",
		response = "broker_female_a_psyker_bonding_conversation_30_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_30_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_psyker_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_30_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_30_b",
		response = "broker_female_a_psyker_bonding_conversation_30_b",
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
					"broker_female_a_psyker_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_30_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_30_c",
		response = "broker_female_a_psyker_bonding_conversation_30_c",
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
					"broker_female_a_psyker_bonding_conversation_30_b",
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
				"broker_female_a_psyker_bonding_conversation_30_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_30_d",
		response = "broker_female_a_psyker_bonding_conversation_30_d",
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
					"broker_female_a_psyker_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_30_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_31_a",
		response = "broker_female_a_psyker_bonding_conversation_31_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_31_a",
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
				"broker_female_a_psyker_bonding_conversation_31_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_31_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_31_b",
		response = "broker_female_a_psyker_bonding_conversation_31_b",
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
					"broker_female_a_psyker_bonding_conversation_31_a",
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
				"broker_female_a_psyker_bonding_conversation_31_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_31_c",
		response = "broker_female_a_psyker_bonding_conversation_31_c",
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
					"broker_female_a_psyker_bonding_conversation_31_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_31_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_31_d",
		response = "broker_female_a_psyker_bonding_conversation_31_d",
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
					"broker_female_a_psyker_bonding_conversation_31_c",
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
				"broker_female_a_psyker_bonding_conversation_31_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_32_a",
		response = "broker_female_a_psyker_bonding_conversation_32_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_32_a",
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
				"broker_female_a_psyker_bonding_conversation_32_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_32_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_32_b",
		response = "broker_female_a_psyker_bonding_conversation_32_b",
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
					"broker_female_a_psyker_bonding_conversation_32_a",
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
				"broker_female_a_psyker_bonding_conversation_32_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_32_c",
		response = "broker_female_a_psyker_bonding_conversation_32_c",
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
					"broker_female_a_psyker_bonding_conversation_32_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_32_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_32_d",
		response = "broker_female_a_psyker_bonding_conversation_32_d",
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
					"broker_female_a_psyker_bonding_conversation_32_c",
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
				"broker_female_a_psyker_bonding_conversation_32_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_33_a",
		response = "broker_female_a_psyker_bonding_conversation_33_a",
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
					"broker_female_a",
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
				"broker_female_a_psyker_bonding_conversation_33_a",
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
				"broker_female_a_psyker_bonding_conversation_33_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_33_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_33_b",
		response = "broker_female_a_psyker_bonding_conversation_33_b",
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
					"broker_female_a_psyker_bonding_conversation_33_a",
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
				"broker_female_a_psyker_bonding_conversation_33_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_33_c",
		response = "broker_female_a_psyker_bonding_conversation_33_c",
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
					"broker_female_a_psyker_bonding_conversation_33_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_33_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_33_d",
		response = "broker_female_a_psyker_bonding_conversation_33_d",
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
					"broker_female_a_psyker_bonding_conversation_33_c",
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
				"broker_female_a_psyker_bonding_conversation_33_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_34_a",
		response = "broker_female_a_psyker_bonding_conversation_34_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_34_a",
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
				"broker_female_a_psyker_bonding_conversation_34_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_34_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_34_b",
		response = "broker_female_a_psyker_bonding_conversation_34_b",
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
					"broker_female_a_psyker_bonding_conversation_34_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_34_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_34_c",
		response = "broker_female_a_psyker_bonding_conversation_34_c",
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
					"broker_female_a_psyker_bonding_conversation_34_b",
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
				"broker_female_a_psyker_bonding_conversation_34_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_34_d",
		response = "broker_female_a_psyker_bonding_conversation_34_d",
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
					"broker_female_a_psyker_bonding_conversation_34_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_34_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_35_a",
		response = "broker_female_a_psyker_bonding_conversation_35_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_35_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_psyker_bonding_conversation_35_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_35_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_35_b",
		response = "broker_female_a_psyker_bonding_conversation_35_b",
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
					"broker_female_a_psyker_bonding_conversation_35_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_35_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_35_c",
		response = "broker_female_a_psyker_bonding_conversation_35_c",
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
					"broker_female_a_psyker_bonding_conversation_35_b",
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
				"broker_female_a_psyker_bonding_conversation_35_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_35_d",
		response = "broker_female_a_psyker_bonding_conversation_35_d",
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
					"broker_female_a_psyker_bonding_conversation_35_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_35_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_36_a",
		response = "broker_female_a_psyker_bonding_conversation_36_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_36_a",
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
				"broker_female_a_psyker_bonding_conversation_36_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_psyker_bonding_conversation_36_a",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_36_b",
		response = "broker_female_a_psyker_bonding_conversation_36_b",
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
					"broker_female_a_psyker_bonding_conversation_36_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_36_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_36_c",
		response = "broker_female_a_psyker_bonding_conversation_36_c",
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
					"broker_female_a_psyker_bonding_conversation_36_b",
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
				"broker_female_a_psyker_bonding_conversation_36_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_psyker_bonding_conversation_36_d",
		response = "broker_female_a_psyker_bonding_conversation_36_d",
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
					"broker_female_a_psyker_bonding_conversation_36_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_psyker_bonding_conversation_36_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_01_a",
		response = "broker_female_a_veteran_bonding_conversation_01_a",
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
					"broker_female_a",
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
				"broker_female_a_veteran_bonding_conversation_01_a",
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
				"broker_female_a_veteran_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_01_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_01_b",
		response = "broker_female_a_veteran_bonding_conversation_01_b",
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
					"broker_female_a_veteran_bonding_conversation_01_a",
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
				"broker_female_a_veteran_bonding_conversation_01_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_01_c",
		response = "broker_female_a_veteran_bonding_conversation_01_c",
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
					"broker_female_a_veteran_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_01_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_01_d",
		response = "broker_female_a_veteran_bonding_conversation_01_d",
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
					"broker_female_a_veteran_bonding_conversation_01_c",
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
				"broker_female_a_veteran_bonding_conversation_01_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_02_a",
		response = "broker_female_a_veteran_bonding_conversation_02_a",
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
					"broker_female_a",
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
				"broker_female_a_veteran_bonding_conversation_02_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_veteran_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_02_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_02_b",
		response = "broker_female_a_veteran_bonding_conversation_02_b",
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
					"broker_female_a_veteran_bonding_conversation_02_a",
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
				"broker_female_a_veteran_bonding_conversation_02_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_02_c",
		response = "broker_female_a_veteran_bonding_conversation_02_c",
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
					"broker_female_a_veteran_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_02_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_02_d",
		response = "broker_female_a_veteran_bonding_conversation_02_d",
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
					"broker_female_a_veteran_bonding_conversation_02_c",
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
				"broker_female_a_veteran_bonding_conversation_02_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_03_a",
		response = "broker_female_a_veteran_bonding_conversation_03_a",
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
					"broker_female_a",
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
				"broker_female_a_veteran_bonding_conversation_03_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_veteran_bonding_conversation_03_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_03_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_03_b",
		response = "broker_female_a_veteran_bonding_conversation_03_b",
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
					"broker_female_a_veteran_bonding_conversation_03_a",
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
				"broker_female_a_veteran_bonding_conversation_03_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_03_c",
		response = "broker_female_a_veteran_bonding_conversation_03_c",
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
					"broker_female_a_veteran_bonding_conversation_03_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_03_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_03_d",
		response = "broker_female_a_veteran_bonding_conversation_03_d",
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
					"broker_female_a_veteran_bonding_conversation_03_c",
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
				"broker_female_a_veteran_bonding_conversation_03_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_04_a",
		response = "broker_female_a_veteran_bonding_conversation_04_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_04_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_veteran_bonding_conversation_04_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_04_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_04_b",
		response = "broker_female_a_veteran_bonding_conversation_04_b",
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
					"broker_female_a_veteran_bonding_conversation_04_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_04_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_04_c",
		response = "broker_female_a_veteran_bonding_conversation_04_c",
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
					"broker_female_a_veteran_bonding_conversation_04_b",
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
				"broker_female_a_veteran_bonding_conversation_04_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_04_d",
		response = "broker_female_a_veteran_bonding_conversation_04_d",
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
					"broker_female_a_veteran_bonding_conversation_04_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_04_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_05_a",
		response = "broker_female_a_veteran_bonding_conversation_05_a",
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
					"veteran_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_05_a",
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
				"broker_female_a_veteran_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_05_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_05_b",
		response = "broker_female_a_veteran_bonding_conversation_05_b",
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
					"broker_female_a_veteran_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_05_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_05_c",
		response = "broker_female_a_veteran_bonding_conversation_05_c",
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
					"broker_female_a_veteran_bonding_conversation_05_b",
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
				"broker_female_a_veteran_bonding_conversation_05_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_05_d",
		response = "broker_female_a_veteran_bonding_conversation_05_d",
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
					"broker_female_a_veteran_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_05_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_06_a",
		response = "broker_female_a_veteran_bonding_conversation_06_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_06_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_veteran_bonding_conversation_06_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_06_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_06_b",
		response = "broker_female_a_veteran_bonding_conversation_06_b",
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
					"broker_female_a_veteran_bonding_conversation_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_06_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_06_c",
		response = "broker_female_a_veteran_bonding_conversation_06_c",
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
					"broker_female_a_veteran_bonding_conversation_06_b",
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
				"broker_female_a_veteran_bonding_conversation_06_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_06_d",
		response = "broker_female_a_veteran_bonding_conversation_06_d",
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
					"broker_female_a_veteran_bonding_conversation_06_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_06_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_13_a",
		response = "broker_female_a_veteran_bonding_conversation_13_a",
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
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_veteran_male_b__combat_pause_one_liner_01",
					"loc_veteran_male_b__combat_pause_one_liner_02",
					"loc_veteran_male_b__combat_pause_one_liner_03",
					"loc_veteran_male_b__combat_pause_one_liner_04",
					"loc_veteran_male_b__combat_pause_one_liner_05",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_13_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_13_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_13_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_13_b",
		response = "broker_female_a_veteran_bonding_conversation_13_b",
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
					"broker_female_a_veteran_bonding_conversation_13_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_13_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_13_c",
		response = "broker_female_a_veteran_bonding_conversation_13_c",
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
					"broker_female_a_veteran_bonding_conversation_13_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_13_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_13_d",
		response = "broker_female_a_veteran_bonding_conversation_13_d",
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
					"broker_female_a_veteran_bonding_conversation_13_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_13_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_14_a",
		response = "broker_female_a_veteran_bonding_conversation_14_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_b",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_14_a",
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
				"broker_female_a_veteran_bonding_conversation_14_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_14_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_14_b",
		response = "broker_female_a_veteran_bonding_conversation_14_b",
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
					"broker_female_a_veteran_bonding_conversation_14_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_14_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_14_c",
		response = "broker_female_a_veteran_bonding_conversation_14_c",
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
					"broker_female_a_veteran_bonding_conversation_14_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_14_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_14_d",
		response = "broker_female_a_veteran_bonding_conversation_14_d",
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
					"broker_female_a_veteran_bonding_conversation_14_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_14_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_15_a",
		response = "broker_female_a_veteran_bonding_conversation_15_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_b",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_15_a",
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
				"broker_female_a_veteran_bonding_conversation_15_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_15_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_15_b",
		response = "broker_female_a_veteran_bonding_conversation_15_b",
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
					"broker_female_a_veteran_bonding_conversation_15_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_15_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_15_c",
		response = "broker_female_a_veteran_bonding_conversation_15_c",
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
					"broker_female_a_veteran_bonding_conversation_15_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_15_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_15_d",
		response = "broker_female_a_veteran_bonding_conversation_15_d",
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
					"broker_female_a_veteran_bonding_conversation_15_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_15_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_16_a",
		response = "broker_female_a_veteran_bonding_conversation_16_a",
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
					"veteran_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_16_a",
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
				"broker_female_a_veteran_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_16_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_16_b",
		response = "broker_female_a_veteran_bonding_conversation_16_b",
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
					"broker_female_a_veteran_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_16_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_16_c",
		response = "broker_female_a_veteran_bonding_conversation_16_c",
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
					"broker_female_a_veteran_bonding_conversation_16_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_16_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_16_d",
		response = "broker_female_a_veteran_bonding_conversation_16_d",
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
					"broker_female_a_veteran_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_16_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_17_a",
		response = "broker_female_a_veteran_bonding_conversation_17_a",
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
					"veteran_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_17_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_veteran_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_17_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_17_b",
		response = "broker_female_a_veteran_bonding_conversation_17_b",
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
					"broker_female_a_veteran_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_17_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_17_c",
		response = "broker_female_a_veteran_bonding_conversation_17_c",
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
					"broker_female_a_veteran_bonding_conversation_17_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_17_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_17_d",
		response = "broker_female_a_veteran_bonding_conversation_17_d",
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
					"broker_female_a_veteran_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_17_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_18_a",
		response = "broker_female_a_veteran_bonding_conversation_18_a",
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
					"veteran_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_18_a",
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
				"broker_female_a_veteran_bonding_conversation_18_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_18_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_18_b",
		response = "broker_female_a_veteran_bonding_conversation_18_b",
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
					"broker_female_a_veteran_bonding_conversation_18_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_18_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_18_c",
		response = "broker_female_a_veteran_bonding_conversation_18_c",
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
					"broker_female_a_veteran_bonding_conversation_18_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_18_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_18_d",
		response = "broker_female_a_veteran_bonding_conversation_18_d",
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
					"broker_female_a_veteran_bonding_conversation_18_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_18_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_19_a",
		response = "broker_female_a_veteran_bonding_conversation_19_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_b",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_19_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_veteran_bonding_conversation_19_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_19_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_19_b",
		response = "broker_female_a_veteran_bonding_conversation_19_b",
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
					"broker_female_a_veteran_bonding_conversation_19_a",
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
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_19_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_19_c",
		response = "broker_female_a_veteran_bonding_conversation_19_c",
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
					"broker_female_a_veteran_bonding_conversation_19_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_19_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_19_d",
		response = "broker_female_a_veteran_bonding_conversation_19_d",
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
					"broker_female_a_veteran_bonding_conversation_19_c",
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
				"broker_female_a_veteran_bonding_conversation_19_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_20_a",
		response = "broker_female_a_veteran_bonding_conversation_20_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_b",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_20_a",
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
				"broker_female_a_veteran_bonding_conversation_20_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_20_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_20_b",
		response = "broker_female_a_veteran_bonding_conversation_20_b",
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
					"broker_female_a_veteran_bonding_conversation_20_a",
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
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_20_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_20_c",
		response = "broker_female_a_veteran_bonding_conversation_20_c",
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
					"broker_female_a_veteran_bonding_conversation_20_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_20_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_20_d",
		response = "broker_female_a_veteran_bonding_conversation_20_d",
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
					"broker_female_a_veteran_bonding_conversation_20_c",
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
				"broker_female_a_veteran_bonding_conversation_20_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_21_a",
		response = "broker_female_a_veteran_bonding_conversation_21_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_b",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_21_a",
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
				"broker_female_a_veteran_bonding_conversation_21_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_21_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_21_b",
		response = "broker_female_a_veteran_bonding_conversation_21_b",
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
					"broker_female_a_veteran_bonding_conversation_21_a",
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
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_21_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_21_c",
		response = "broker_female_a_veteran_bonding_conversation_21_c",
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
					"broker_female_a_veteran_bonding_conversation_21_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_21_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_21_d",
		response = "broker_female_a_veteran_bonding_conversation_21_d",
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
					"broker_female_a_veteran_bonding_conversation_21_c",
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
				"broker_female_a_veteran_bonding_conversation_21_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_22_a",
		response = "broker_female_a_veteran_bonding_conversation_22_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_22_a",
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
				"broker_female_a_veteran_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_22_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_22_b",
		response = "broker_female_a_veteran_bonding_conversation_22_b",
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
					"broker_female_a_veteran_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_22_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_22_c",
		response = "broker_female_a_veteran_bonding_conversation_22_c",
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
					"broker_female_a_veteran_bonding_conversation_22_b",
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
				"broker_female_a_veteran_bonding_conversation_22_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_22_d",
		response = "broker_female_a_veteran_bonding_conversation_22_d",
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
					"broker_female_a_veteran_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_22_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_23_a",
		response = "broker_female_a_veteran_bonding_conversation_23_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_23_a",
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
				"broker_female_a_veteran_bonding_conversation_23_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_23_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_23_b",
		response = "broker_female_a_veteran_bonding_conversation_23_b",
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
					"broker_female_a_veteran_bonding_conversation_23_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_23_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_23_c",
		response = "broker_female_a_veteran_bonding_conversation_23_c",
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
					"broker_female_a_veteran_bonding_conversation_23_b",
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
				"broker_female_a_veteran_bonding_conversation_23_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_23_d",
		response = "broker_female_a_veteran_bonding_conversation_23_d",
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
					"broker_female_a_veteran_bonding_conversation_23_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_23_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_24_a",
		response = "broker_female_a_veteran_bonding_conversation_24_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_24_a",
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
				"broker_female_a_veteran_bonding_conversation_24_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_24_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_24_b",
		response = "broker_female_a_veteran_bonding_conversation_24_b",
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
					"broker_female_a_veteran_bonding_conversation_24_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_24_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_24_c",
		response = "broker_female_a_veteran_bonding_conversation_24_c",
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
					"broker_female_a_veteran_bonding_conversation_24_b",
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
				"broker_female_a_veteran_bonding_conversation_24_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_24_d",
		response = "broker_female_a_veteran_bonding_conversation_24_d",
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
					"broker_female_a_veteran_bonding_conversation_24_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_24_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_25_a",
		response = "broker_female_a_veteran_bonding_conversation_25_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_c",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_25_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_veteran_bonding_conversation_25_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_25_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_25_b",
		response = "broker_female_a_veteran_bonding_conversation_25_b",
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
					"broker_female_a_veteran_bonding_conversation_25_a",
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
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_25_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_25_c",
		response = "broker_female_a_veteran_bonding_conversation_25_c",
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
					"broker_female_a_veteran_bonding_conversation_25_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_25_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_25_d",
		response = "broker_female_a_veteran_bonding_conversation_25_d",
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
					"broker_female_a_veteran_bonding_conversation_25_c",
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
				"broker_female_a_veteran_bonding_conversation_25_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_26_a",
		response = "broker_female_a_veteran_bonding_conversation_26_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_c",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_26_a",
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
				"broker_female_a_veteran_bonding_conversation_26_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_26_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_26_b",
		response = "broker_female_a_veteran_bonding_conversation_26_b",
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
					"broker_female_a_veteran_bonding_conversation_26_a",
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
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_26_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_26_c",
		response = "broker_female_a_veteran_bonding_conversation_26_c",
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
					"broker_female_a_veteran_bonding_conversation_26_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_26_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_26_d",
		response = "broker_female_a_veteran_bonding_conversation_26_d",
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
					"broker_female_a_veteran_bonding_conversation_26_c",
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
				"broker_female_a_veteran_bonding_conversation_26_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_27_a",
		response = "broker_female_a_veteran_bonding_conversation_27_a",
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
					"broker_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_c",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_27_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_veteran_bonding_conversation_27_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_27_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_27_b",
		response = "broker_female_a_veteran_bonding_conversation_27_b",
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
					"broker_female_a_veteran_bonding_conversation_27_a",
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
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_27_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_27_c",
		response = "broker_female_a_veteran_bonding_conversation_27_c",
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
					"broker_female_a_veteran_bonding_conversation_27_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_27_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_27_d",
		response = "broker_female_a_veteran_bonding_conversation_27_d",
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
					"broker_female_a_veteran_bonding_conversation_27_c",
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
				"broker_female_a_veteran_bonding_conversation_27_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_28_a",
		response = "broker_female_a_veteran_bonding_conversation_28_a",
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
					"veteran_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_28_a",
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
				"broker_female_a_veteran_bonding_conversation_28_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_28_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_28_b",
		response = "broker_female_a_veteran_bonding_conversation_28_b",
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
					"broker_female_a_veteran_bonding_conversation_28_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_28_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_28_c",
		response = "broker_female_a_veteran_bonding_conversation_28_c",
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
					"broker_female_a_veteran_bonding_conversation_28_b",
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
				"broker_female_a_veteran_bonding_conversation_28_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_28_d",
		response = "broker_female_a_veteran_bonding_conversation_28_d",
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
					"broker_female_a_veteran_bonding_conversation_28_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_28_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_29_a",
		response = "broker_female_a_veteran_bonding_conversation_29_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_29_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_veteran_bonding_conversation_29_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_29_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_29_b",
		response = "broker_female_a_veteran_bonding_conversation_29_b",
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
					"broker_female_a_veteran_bonding_conversation_29_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_29_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_29_c",
		response = "broker_female_a_veteran_bonding_conversation_29_c",
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
					"broker_female_a_veteran_bonding_conversation_29_b",
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
				"broker_female_a_veteran_bonding_conversation_29_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_29_d",
		response = "broker_female_a_veteran_bonding_conversation_29_d",
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
					"broker_female_a_veteran_bonding_conversation_29_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_29_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_30_a",
		response = "broker_female_a_veteran_bonding_conversation_30_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_30_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_veteran_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_veteran_bonding_conversation_30_a",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_30_b",
		response = "broker_female_a_veteran_bonding_conversation_30_b",
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
					"broker_female_a_veteran_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_30_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_30_c",
		response = "broker_female_a_veteran_bonding_conversation_30_c",
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
					"broker_female_a_veteran_bonding_conversation_30_b",
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
				"broker_female_a_veteran_bonding_conversation_30_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_veteran_bonding_conversation_30_d",
		response = "broker_female_a_veteran_bonding_conversation_30_d",
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
					"broker_female_a_veteran_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_veteran_bonding_conversation_30_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_01_a",
		response = "broker_female_a_zealot_bonding_conversation_01_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_01_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_01_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_01_b",
		response = "broker_female_a_zealot_bonding_conversation_01_b",
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
					"broker_female_a_zealot_bonding_conversation_01_a",
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
				"broker_female_a_zealot_bonding_conversation_01_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_01_c",
		response = "broker_female_a_zealot_bonding_conversation_01_c",
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
					"broker_female_a_zealot_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_01_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_01_d",
		response = "broker_female_a_zealot_bonding_conversation_01_d",
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
					"broker_female_a_zealot_bonding_conversation_01_c",
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
				"broker_female_a_zealot_bonding_conversation_01_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_02_a",
		response = "broker_female_a_zealot_bonding_conversation_02_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_02_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_02_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_02_b",
		response = "broker_female_a_zealot_bonding_conversation_02_b",
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
					"broker_female_a_zealot_bonding_conversation_02_a",
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
				"broker_female_a_zealot_bonding_conversation_02_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_02_c",
		response = "broker_female_a_zealot_bonding_conversation_02_c",
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
					"broker_female_a_zealot_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_02_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_02_d",
		response = "broker_female_a_zealot_bonding_conversation_02_d",
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
					"broker_female_a_zealot_bonding_conversation_02_c",
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
				"broker_female_a_zealot_bonding_conversation_02_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_03_a",
		response = "broker_female_a_zealot_bonding_conversation_03_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_03_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_03_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_03_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_03_b",
		response = "broker_female_a_zealot_bonding_conversation_03_b",
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
					"broker_female_a_zealot_bonding_conversation_03_a",
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
				"broker_female_a_zealot_bonding_conversation_03_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_03_c",
		response = "broker_female_a_zealot_bonding_conversation_03_c",
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
					"broker_female_a_zealot_bonding_conversation_03_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_03_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_03_d",
		response = "broker_female_a_zealot_bonding_conversation_03_d",
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
					"broker_female_a_zealot_bonding_conversation_03_c",
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
				"broker_female_a_zealot_bonding_conversation_03_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_04_a",
		response = "broker_female_a_zealot_bonding_conversation_04_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_04_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_04_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_04_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_04_b",
		response = "broker_female_a_zealot_bonding_conversation_04_b",
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
					"broker_female_a_zealot_bonding_conversation_04_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_04_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_04_c",
		response = "broker_female_a_zealot_bonding_conversation_04_c",
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
					"broker_female_a_zealot_bonding_conversation_04_b",
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
				"broker_female_a_zealot_bonding_conversation_04_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_04_d",
		response = "broker_female_a_zealot_bonding_conversation_04_d",
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
					"broker_female_a_zealot_bonding_conversation_04_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_04_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_05_a",
		response = "broker_female_a_zealot_bonding_conversation_05_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_05_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_05_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_05_b",
		response = "broker_female_a_zealot_bonding_conversation_05_b",
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
					"broker_female_a_zealot_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_05_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_05_c",
		response = "broker_female_a_zealot_bonding_conversation_05_c",
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
					"broker_female_a_zealot_bonding_conversation_05_b",
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
				"broker_female_a_zealot_bonding_conversation_05_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_05_d",
		response = "broker_female_a_zealot_bonding_conversation_05_d",
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
					"broker_female_a_zealot_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_05_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_06_a",
		response = "broker_female_a_zealot_bonding_conversation_06_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_06_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_06_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_06_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_06_b",
		response = "broker_female_a_zealot_bonding_conversation_06_b",
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
					"broker_female_a_zealot_bonding_conversation_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_06_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_06_c",
		response = "broker_female_a_zealot_bonding_conversation_06_c",
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
					"broker_female_a_zealot_bonding_conversation_06_b",
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
				"broker_female_a_zealot_bonding_conversation_06_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_06_d",
		response = "broker_female_a_zealot_bonding_conversation_06_d",
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
					"broker_female_a_zealot_bonding_conversation_06_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_06_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_07_a",
		response = "broker_female_a_zealot_bonding_conversation_07_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_07_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_07_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_07_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_07_b",
		response = "broker_female_a_zealot_bonding_conversation_07_b",
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
					"broker_female_a_zealot_bonding_conversation_07_a",
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
				"broker_female_a_zealot_bonding_conversation_07_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_07_c",
		response = "broker_female_a_zealot_bonding_conversation_07_c",
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
					"broker_female_a_zealot_bonding_conversation_07_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_07_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_07_d",
		response = "broker_female_a_zealot_bonding_conversation_07_d",
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
					"broker_female_a_zealot_bonding_conversation_07_c",
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
				"broker_female_a_zealot_bonding_conversation_07_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_08_a",
		response = "broker_female_a_zealot_bonding_conversation_08_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_08_a",
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
				"broker_female_a_zealot_bonding_conversation_08_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_08_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_08_b",
		response = "broker_female_a_zealot_bonding_conversation_08_b",
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
					"broker_female_a_zealot_bonding_conversation_08_a",
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
				"broker_female_a_zealot_bonding_conversation_08_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_08_c",
		response = "broker_female_a_zealot_bonding_conversation_08_c",
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
					"broker_female_a_zealot_bonding_conversation_08_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_08_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_08_d",
		response = "broker_female_a_zealot_bonding_conversation_08_d",
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
					"broker_female_a_zealot_bonding_conversation_08_c",
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
				"broker_female_a_zealot_bonding_conversation_08_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_09_a",
		response = "broker_female_a_zealot_bonding_conversation_09_a",
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
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_zealot_female_a__combat_pause_one_liner_01",
					"loc_zealot_female_a__combat_pause_one_liner_02",
					"loc_zealot_female_a__combat_pause_one_liner_03",
					"loc_zealot_female_a__combat_pause_one_liner_07",
					"loc_zealot_female_a__combat_pause_one_liner_08",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_09_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_09_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_09_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_09_b",
		response = "broker_female_a_zealot_bonding_conversation_09_b",
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
					"broker_female_a_zealot_bonding_conversation_09_a",
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
				"broker_female_a_zealot_bonding_conversation_09_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_09_c",
		response = "broker_female_a_zealot_bonding_conversation_09_c",
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
					"broker_female_a_zealot_bonding_conversation_09_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_09_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_09_d",
		response = "broker_female_a_zealot_bonding_conversation_09_d",
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
					"broker_female_a_zealot_bonding_conversation_09_c",
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
				"broker_female_a_zealot_bonding_conversation_09_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_10_a",
		response = "broker_female_a_zealot_bonding_conversation_10_a",
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
					"zealot_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_10_a",
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
				"broker_female_a_zealot_bonding_conversation_10_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_10_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_10_b",
		response = "broker_female_a_zealot_bonding_conversation_10_b",
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
					"broker_female_a_zealot_bonding_conversation_10_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_10_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_10_c",
		response = "broker_female_a_zealot_bonding_conversation_10_c",
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
					"broker_female_a_zealot_bonding_conversation_10_b",
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
				"broker_female_a_zealot_bonding_conversation_10_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_10_d",
		response = "broker_female_a_zealot_bonding_conversation_10_d",
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
					"broker_female_a_zealot_bonding_conversation_10_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_10_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_11_a",
		response = "broker_female_a_zealot_bonding_conversation_11_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_11_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_11_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_11_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_11_b",
		response = "broker_female_a_zealot_bonding_conversation_11_b",
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
					"broker_female_a_zealot_bonding_conversation_11_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_11_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_11_c",
		response = "broker_female_a_zealot_bonding_conversation_11_c",
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
					"broker_female_a_zealot_bonding_conversation_11_b",
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
				"broker_female_a_zealot_bonding_conversation_11_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_11_d",
		response = "broker_female_a_zealot_bonding_conversation_11_d",
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
					"broker_female_a_zealot_bonding_conversation_11_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_11_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_12_a",
		response = "broker_female_a_zealot_bonding_conversation_12_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_12_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_12_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_12_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_12_b",
		response = "broker_female_a_zealot_bonding_conversation_12_b",
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
					"broker_female_a_zealot_bonding_conversation_12_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_12_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_12_c",
		response = "broker_female_a_zealot_bonding_conversation_12_c",
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
					"broker_female_a_zealot_bonding_conversation_12_b",
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
				"broker_female_a_zealot_bonding_conversation_12_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_12_d",
		response = "broker_female_a_zealot_bonding_conversation_12_d",
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
					"broker_female_a_zealot_bonding_conversation_12_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_12_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_13_a",
		response = "broker_female_a_zealot_bonding_conversation_13_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_13_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_13_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_13_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_13_b",
		response = "broker_female_a_zealot_bonding_conversation_13_b",
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
					"broker_female_a_zealot_bonding_conversation_13_a",
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
				"broker_female_a_zealot_bonding_conversation_13_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_13_c",
		response = "broker_female_a_zealot_bonding_conversation_13_c",
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
					"broker_female_a_zealot_bonding_conversation_13_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_13_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_13_d",
		response = "broker_female_a_zealot_bonding_conversation_13_d",
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
					"broker_female_a_zealot_bonding_conversation_13_c",
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
				"broker_female_a_zealot_bonding_conversation_13_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_14_a",
		response = "broker_female_a_zealot_bonding_conversation_14_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_14_a",
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
				"broker_female_a_zealot_bonding_conversation_14_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_14_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_14_b",
		response = "broker_female_a_zealot_bonding_conversation_14_b",
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
					"broker_female_a_zealot_bonding_conversation_14_a",
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
				"broker_female_a_zealot_bonding_conversation_14_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_14_c",
		response = "broker_female_a_zealot_bonding_conversation_14_c",
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
					"broker_female_a_zealot_bonding_conversation_14_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_14_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_14_d",
		response = "broker_female_a_zealot_bonding_conversation_14_d",
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
					"broker_female_a_zealot_bonding_conversation_14_c",
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
				"broker_female_a_zealot_bonding_conversation_14_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_15_a",
		response = "broker_female_a_zealot_bonding_conversation_15_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_15_a",
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
				"broker_female_a_zealot_bonding_conversation_15_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_15_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_15_b",
		response = "broker_female_a_zealot_bonding_conversation_15_b",
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
					"broker_female_a_zealot_bonding_conversation_15_a",
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
				"broker_female_a_zealot_bonding_conversation_15_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_15_c",
		response = "broker_female_a_zealot_bonding_conversation_15_c",
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
					"broker_female_a_zealot_bonding_conversation_15_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_15_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_15_d",
		response = "broker_female_a_zealot_bonding_conversation_15_d",
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
					"broker_female_a_zealot_bonding_conversation_15_c",
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
				"broker_female_a_zealot_bonding_conversation_15_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_16_a",
		response = "broker_female_a_zealot_bonding_conversation_16_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_16_a",
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
				"broker_female_a_zealot_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_16_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_16_b",
		response = "broker_female_a_zealot_bonding_conversation_16_b",
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
					"broker_female_a_zealot_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_16_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_16_c",
		response = "broker_female_a_zealot_bonding_conversation_16_c",
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
					"broker_female_a_zealot_bonding_conversation_16_b",
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
				"broker_female_a_zealot_bonding_conversation_16_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_16_d",
		response = "broker_female_a_zealot_bonding_conversation_16_d",
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
					"broker_female_a_zealot_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_16_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_17_a",
		response = "broker_female_a_zealot_bonding_conversation_17_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_17_a",
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
				"broker_female_a_zealot_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_17_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_17_b",
		response = "broker_female_a_zealot_bonding_conversation_17_b",
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
					"broker_female_a_zealot_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_17_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_17_c",
		response = "broker_female_a_zealot_bonding_conversation_17_c",
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
					"broker_female_a_zealot_bonding_conversation_17_b",
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
				"broker_female_a_zealot_bonding_conversation_17_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_17_d",
		response = "broker_female_a_zealot_bonding_conversation_17_d",
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
					"broker_female_a_zealot_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_17_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_18_a",
		response = "broker_female_a_zealot_bonding_conversation_18_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_18_a",
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
				"broker_female_a_zealot_bonding_conversation_18_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_18_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_18_b",
		response = "broker_female_a_zealot_bonding_conversation_18_b",
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
					"broker_female_a_zealot_bonding_conversation_18_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_18_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_18_c",
		response = "broker_female_a_zealot_bonding_conversation_18_c",
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
					"broker_female_a_zealot_bonding_conversation_18_b",
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
				"broker_female_a_zealot_bonding_conversation_18_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_18_d",
		response = "broker_female_a_zealot_bonding_conversation_18_d",
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
					"broker_female_a_zealot_bonding_conversation_18_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_18_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_19_a",
		response = "broker_female_a_zealot_bonding_conversation_19_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_19_a",
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
				"broker_female_a_zealot_bonding_conversation_19_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_19_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_19_b",
		response = "broker_female_a_zealot_bonding_conversation_19_b",
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
					"broker_female_a_zealot_bonding_conversation_19_a",
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
				"broker_female_a_zealot_bonding_conversation_19_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_19_c",
		response = "broker_female_a_zealot_bonding_conversation_19_c",
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
					"broker_female_a_zealot_bonding_conversation_19_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_19_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_19_d",
		response = "broker_female_a_zealot_bonding_conversation_19_d",
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
					"broker_female_a_zealot_bonding_conversation_19_c",
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
				"broker_female_a_zealot_bonding_conversation_19_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_20_a",
		response = "broker_female_a_zealot_bonding_conversation_20_a",
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
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_zealot_female_b__combat_pause_one_liner_02",
					"loc_zealot_female_b__combat_pause_one_liner_04",
					"loc_zealot_female_b__combat_pause_one_liner_05",
					"loc_zealot_female_b__combat_pause_one_liner_07",
					"loc_zealot_female_b__combat_pause_one_liner_08",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_20_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_20_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_20_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_20_b",
		response = "broker_female_a_zealot_bonding_conversation_20_b",
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
					"broker_female_a_zealot_bonding_conversation_20_a",
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
				"broker_female_a_zealot_bonding_conversation_20_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_20_c",
		response = "broker_female_a_zealot_bonding_conversation_20_c",
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
					"broker_female_a_zealot_bonding_conversation_20_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_20_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_20_d",
		response = "broker_female_a_zealot_bonding_conversation_20_d",
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
					"broker_female_a_zealot_bonding_conversation_20_c",
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
				"broker_female_a_zealot_bonding_conversation_20_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_21_a",
		response = "broker_female_a_zealot_bonding_conversation_21_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_21_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_21_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_21_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_21_b",
		response = "broker_female_a_zealot_bonding_conversation_21_b",
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
					"broker_female_a_zealot_bonding_conversation_21_a",
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
				"broker_female_a_zealot_bonding_conversation_21_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_21_c",
		response = "broker_female_a_zealot_bonding_conversation_21_c",
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
					"broker_female_a_zealot_bonding_conversation_21_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_21_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_21_d",
		response = "broker_female_a_zealot_bonding_conversation_21_d",
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
					"broker_female_a_zealot_bonding_conversation_21_c",
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
				"broker_female_a_zealot_bonding_conversation_21_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_22_a",
		response = "broker_female_a_zealot_bonding_conversation_22_a",
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
					"zealot_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_22_a",
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
				"broker_female_a_zealot_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_22_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_22_b",
		response = "broker_female_a_zealot_bonding_conversation_22_b",
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
					"broker_female_a_zealot_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_22_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_22_c",
		response = "broker_female_a_zealot_bonding_conversation_22_c",
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
					"broker_female_a_zealot_bonding_conversation_22_b",
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
				"broker_female_a_zealot_bonding_conversation_22_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_22_d",
		response = "broker_female_a_zealot_bonding_conversation_22_d",
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
					"broker_female_a_zealot_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_22_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_23_a",
		response = "broker_female_a_zealot_bonding_conversation_23_a",
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
					"zealot_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_23_a",
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
				"broker_female_a_zealot_bonding_conversation_23_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_23_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_23_b",
		response = "broker_female_a_zealot_bonding_conversation_23_b",
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
					"broker_female_a_zealot_bonding_conversation_23_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_23_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_23_c",
		response = "broker_female_a_zealot_bonding_conversation_23_c",
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
					"broker_female_a_zealot_bonding_conversation_23_b",
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
				"broker_female_a_zealot_bonding_conversation_23_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_23_d",
		response = "broker_female_a_zealot_bonding_conversation_23_d",
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
					"broker_female_a_zealot_bonding_conversation_23_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_23_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_24_a",
		response = "broker_female_a_zealot_bonding_conversation_24_a",
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
					"zealot_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_24_a",
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
				"broker_female_a_zealot_bonding_conversation_24_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_24_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_24_b",
		response = "broker_female_a_zealot_bonding_conversation_24_b",
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
					"broker_female_a_zealot_bonding_conversation_24_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_24_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_24_c",
		response = "broker_female_a_zealot_bonding_conversation_24_c",
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
					"broker_female_a_zealot_bonding_conversation_24_b",
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
				"broker_female_a_zealot_bonding_conversation_24_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_24_d",
		response = "broker_female_a_zealot_bonding_conversation_24_d",
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
					"broker_female_a_zealot_bonding_conversation_24_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_24_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_25_a",
		response = "broker_female_a_zealot_bonding_conversation_25_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_25_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_25_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_25_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_25_b",
		response = "broker_female_a_zealot_bonding_conversation_25_b",
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
					"broker_female_a_zealot_bonding_conversation_25_a",
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
				"broker_female_a_zealot_bonding_conversation_25_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_25_c",
		response = "broker_female_a_zealot_bonding_conversation_25_c",
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
					"broker_female_a_zealot_bonding_conversation_25_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_25_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_25_d",
		response = "broker_female_a_zealot_bonding_conversation_25_d",
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
					"broker_female_a_zealot_bonding_conversation_25_c",
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
				"broker_female_a_zealot_bonding_conversation_25_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_26_a",
		response = "broker_female_a_zealot_bonding_conversation_26_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_26_a",
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
				"broker_female_a_zealot_bonding_conversation_26_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_26_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_26_b",
		response = "broker_female_a_zealot_bonding_conversation_26_b",
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
					"broker_female_a_zealot_bonding_conversation_26_a",
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
				"broker_female_a_zealot_bonding_conversation_26_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_26_c",
		response = "broker_female_a_zealot_bonding_conversation_26_c",
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
					"broker_female_a_zealot_bonding_conversation_26_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_26_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_26_d",
		response = "broker_female_a_zealot_bonding_conversation_26_d",
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
					"broker_female_a_zealot_bonding_conversation_26_c",
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
				"broker_female_a_zealot_bonding_conversation_26_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_27_a",
		response = "broker_female_a_zealot_bonding_conversation_27_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_27_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
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
				"broker_female_a_zealot_bonding_conversation_27_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_27_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_27_b",
		response = "broker_female_a_zealot_bonding_conversation_27_b",
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
					"broker_female_a_zealot_bonding_conversation_27_a",
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
				"broker_female_a_zealot_bonding_conversation_27_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_27_c",
		response = "broker_female_a_zealot_bonding_conversation_27_c",
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
					"broker_female_a_zealot_bonding_conversation_27_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_27_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_27_d",
		response = "broker_female_a_zealot_bonding_conversation_27_d",
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
					"broker_female_a_zealot_bonding_conversation_27_c",
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
				"broker_female_a_zealot_bonding_conversation_27_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_28_a",
		response = "broker_female_a_zealot_bonding_conversation_28_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_28_a",
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
				"broker_female_a_zealot_bonding_conversation_28_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_28_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_28_b",
		response = "broker_female_a_zealot_bonding_conversation_28_b",
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
					"broker_female_a_zealot_bonding_conversation_28_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_28_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_28_c",
		response = "broker_female_a_zealot_bonding_conversation_28_c",
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
					"broker_female_a_zealot_bonding_conversation_28_b",
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
				"broker_female_a_zealot_bonding_conversation_28_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_28_d",
		response = "broker_female_a_zealot_bonding_conversation_28_d",
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
					"broker_female_a_zealot_bonding_conversation_28_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_28_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_29_a",
		response = "broker_female_a_zealot_bonding_conversation_29_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_29_a",
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
				"broker_female_a_zealot_bonding_conversation_29_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_29_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_29_b",
		response = "broker_female_a_zealot_bonding_conversation_29_b",
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
					"broker_female_a_zealot_bonding_conversation_29_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_29_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_29_c",
		response = "broker_female_a_zealot_bonding_conversation_29_c",
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
					"broker_female_a_zealot_bonding_conversation_29_b",
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
				"broker_female_a_zealot_bonding_conversation_29_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_29_d",
		response = "broker_female_a_zealot_bonding_conversation_29_d",
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
					"broker_female_a_zealot_bonding_conversation_29_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_29_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_30_a",
		response = "broker_female_a_zealot_bonding_conversation_30_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_30_a",
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
				"broker_female_a_zealot_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_30_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_30_b",
		response = "broker_female_a_zealot_bonding_conversation_30_b",
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
					"broker_female_a_zealot_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_30_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_30_c",
		response = "broker_female_a_zealot_bonding_conversation_30_c",
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
					"broker_female_a_zealot_bonding_conversation_30_b",
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
				"broker_female_a_zealot_bonding_conversation_30_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_30_d",
		response = "broker_female_a_zealot_bonding_conversation_30_d",
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
					"broker_female_a_zealot_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_30_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_31_a",
		response = "broker_female_a_zealot_bonding_conversation_31_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_31_a",
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
				"broker_female_a_zealot_bonding_conversation_31_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_31_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_31_b",
		response = "broker_female_a_zealot_bonding_conversation_31_b",
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
					"broker_female_a_zealot_bonding_conversation_31_a",
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
				"broker_female_a_zealot_bonding_conversation_31_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_31_c",
		response = "broker_female_a_zealot_bonding_conversation_31_c",
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
					"broker_female_a_zealot_bonding_conversation_31_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_31_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_31_d",
		response = "broker_female_a_zealot_bonding_conversation_31_d",
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
					"broker_female_a_zealot_bonding_conversation_31_c",
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
				"broker_female_a_zealot_bonding_conversation_31_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_32_a",
		response = "broker_female_a_zealot_bonding_conversation_32_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_32_a",
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
				"broker_female_a_zealot_bonding_conversation_32_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_32_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_32_b",
		response = "broker_female_a_zealot_bonding_conversation_32_b",
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
					"broker_female_a_zealot_bonding_conversation_32_a",
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
				"broker_female_a_zealot_bonding_conversation_32_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_32_c",
		response = "broker_female_a_zealot_bonding_conversation_32_c",
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
					"broker_female_a_zealot_bonding_conversation_32_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_32_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_32_d",
		response = "broker_female_a_zealot_bonding_conversation_32_d",
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
					"broker_female_a_zealot_bonding_conversation_32_c",
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
				"broker_female_a_zealot_bonding_conversation_32_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_33_a",
		response = "broker_female_a_zealot_bonding_conversation_33_a",
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
					"broker_female_a",
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
				"broker_female_a_zealot_bonding_conversation_33_a",
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
				"broker_female_a_zealot_bonding_conversation_33_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_33_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_33_b",
		response = "broker_female_a_zealot_bonding_conversation_33_b",
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
					"broker_female_a_zealot_bonding_conversation_33_a",
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
				"broker_female_a_zealot_bonding_conversation_33_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_33_c",
		response = "broker_female_a_zealot_bonding_conversation_33_c",
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
					"broker_female_a_zealot_bonding_conversation_33_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_33_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_33_d",
		response = "broker_female_a_zealot_bonding_conversation_33_d",
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
					"broker_female_a_zealot_bonding_conversation_33_c",
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
				"broker_female_a_zealot_bonding_conversation_33_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_34_a",
		response = "broker_female_a_zealot_bonding_conversation_34_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_34_a",
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
				"broker_female_a_zealot_bonding_conversation_34_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_34_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_34_b",
		response = "broker_female_a_zealot_bonding_conversation_34_b",
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
					"broker_female_a_zealot_bonding_conversation_34_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_34_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_34_c",
		response = "broker_female_a_zealot_bonding_conversation_34_c",
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
					"broker_female_a_zealot_bonding_conversation_34_b",
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
				"broker_female_a_zealot_bonding_conversation_34_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_34_d",
		response = "broker_female_a_zealot_bonding_conversation_34_d",
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
					"broker_female_a_zealot_bonding_conversation_34_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_34_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_35_a",
		response = "broker_female_a_zealot_bonding_conversation_35_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_35_a",
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
				"broker_female_a_zealot_bonding_conversation_35_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_35_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_35_b",
		response = "broker_female_a_zealot_bonding_conversation_35_b",
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
					"broker_female_a_zealot_bonding_conversation_35_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_35_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_35_c",
		response = "broker_female_a_zealot_bonding_conversation_35_c",
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
					"broker_female_a_zealot_bonding_conversation_35_b",
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
				"broker_female_a_zealot_bonding_conversation_35_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_35_d",
		response = "broker_female_a_zealot_bonding_conversation_35_d",
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
					"broker_female_a_zealot_bonding_conversation_35_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_35_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_36_a",
		response = "broker_female_a_zealot_bonding_conversation_36_a",
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
					"broker_female_a",
				},
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_36_a",
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
				"broker_female_a_zealot_bonding_conversation_36_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"broker_female_a_zealot_bonding_conversation_36_a",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_36_b",
		response = "broker_female_a_zealot_bonding_conversation_36_b",
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
					"broker_female_a_zealot_bonding_conversation_36_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_36_b_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_36_c",
		response = "broker_female_a_zealot_bonding_conversation_36_c",
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
					"broker_female_a_zealot_bonding_conversation_36_b",
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
				"broker_female_a_zealot_bonding_conversation_36_a_user",
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
		database = "broker_female_a",
		name = "broker_female_a_zealot_bonding_conversation_36_d",
		response = "broker_female_a_zealot_bonding_conversation_36_d",
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
					"broker_female_a_zealot_bonding_conversation_36_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
				},
			},
			{
				"user_memory",
				"broker_female_a_zealot_bonding_conversation_36_b_user",
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
end
