-- chunkname: @dialogues/generated/zealot_female_b.lua

return function ()
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_death_zea_a",
		response = "bonding_conversation_metropolitan_death_zea_a",
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
					"ogryn_b",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_death_zea_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_metropolitan_death_zea_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_death_zea_a",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_death_zea_b",
		response = "bonding_conversation_metropolitan_death_zea_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_death_zea_a",
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
				"bonding_conversation_metropolitan_death_zea_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_death_zea_c",
		response = "bonding_conversation_metropolitan_death_zea_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_death_zea_b",
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
				"bonding_conversation_metropolitan_death_zea_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_death_zea_d",
		response = "bonding_conversation_metropolitan_death_zea_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_death_zea_c",
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
				"bonding_conversation_metropolitan_death_zea_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_death_zea_e",
		response = "bonding_conversation_metropolitan_death_zea_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_death_zea_d",
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
				"bonding_conversation_metropolitan_death_zea_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_fail_a",
		response = "bonding_conversation_metropolitan_fail_a",
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
					"psyker_male_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_fail_a",
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
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_fail_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_fail_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_fail_b",
		response = "bonding_conversation_metropolitan_fail_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_fail_a",
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
				"bonding_conversation_metropolitan_fail_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_fail_c",
		response = "bonding_conversation_metropolitan_fail_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_fail_b",
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
				"bonding_conversation_metropolitan_fail_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_fail_d",
		response = "bonding_conversation_metropolitan_fail_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_fail_c",
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
				"bonding_conversation_metropolitan_fail_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_flaming_fist_a",
		response = "bonding_conversation_metropolitan_flaming_fist_a",
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
					"ogryn_b",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_flaming_fist_a",
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
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_flaming_fist_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_flaming_fist_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_flaming_fist_b",
		response = "bonding_conversation_metropolitan_flaming_fist_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_flaming_fist_a",
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
				"bonding_conversation_metropolitan_flaming_fist_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_flaming_fist_c",
		response = "bonding_conversation_metropolitan_flaming_fist_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_flaming_fist_b",
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
				"bonding_conversation_metropolitan_flaming_fist_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_flaming_fist_d",
		response = "bonding_conversation_metropolitan_flaming_fist_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_flaming_fist_c",
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
				"bonding_conversation_metropolitan_flaming_fist_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_full_heart_a",
		response = "bonding_conversation_metropolitan_full_heart_a",
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
					"ogryn_b",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_full_heart_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_metropolitan_full_heart_a",
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
				"bonding_conversation_metropolitan_full_heart_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_full_heart_b",
		response = "bonding_conversation_metropolitan_full_heart_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_full_heart_a",
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
				"bonding_conversation_metropolitan_full_heart_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_full_heart_c",
		response = "bonding_conversation_metropolitan_full_heart_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_full_heart_b",
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
				"bonding_conversation_metropolitan_full_heart_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_full_heart_d",
		response = "bonding_conversation_metropolitan_full_heart_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_full_heart_c",
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
				"bonding_conversation_metropolitan_full_heart_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_happy_a",
		response = "bonding_conversation_metropolitan_happy_a",
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
					"psyker_female_c",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_happy_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_metropolitan_happy_a",
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
				"bonding_conversation_metropolitan_happy_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_happy_b",
		response = "bonding_conversation_metropolitan_happy_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_happy_a",
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
				"bonding_conversation_metropolitan_happy_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_happy_c",
		response = "bonding_conversation_metropolitan_happy_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_happy_b",
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
				"bonding_conversation_metropolitan_happy_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_happy_d",
		response = "bonding_conversation_metropolitan_happy_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_happy_c",
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
				"bonding_conversation_metropolitan_happy_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_impatience_a",
		response = "bonding_conversation_metropolitan_impatience_a",
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
					"veteran_female_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_impatience_a",
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
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_impatience_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_impatience_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_impatience_b",
		response = "bonding_conversation_metropolitan_impatience_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_impatience_a",
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
				"bonding_conversation_metropolitan_impatience_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_impatience_c",
		response = "bonding_conversation_metropolitan_impatience_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_impatience_b",
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
				"bonding_conversation_metropolitan_impatience_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_impatience_d",
		response = "bonding_conversation_metropolitan_impatience_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_impatience_c",
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
				"bonding_conversation_metropolitan_impatience_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_indolence_a",
		response = "bonding_conversation_metropolitan_indolence_a",
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
					"ogryn_b",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_indolence_a",
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
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_indolence_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_indolence_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_indolence_b",
		response = "bonding_conversation_metropolitan_indolence_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_indolence_a",
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
				"bonding_conversation_metropolitan_indolence_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_indolence_c",
		response = "bonding_conversation_metropolitan_indolence_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_indolence_b",
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
				"bonding_conversation_metropolitan_indolence_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_indolence_d",
		response = "bonding_conversation_metropolitan_indolence_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_indolence_c",
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
				"bonding_conversation_metropolitan_indolence_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_indolence_e",
		response = "bonding_conversation_metropolitan_indolence_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_indolence_d",
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
				"bonding_conversation_metropolitan_indolence_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_lex_a",
		response = "bonding_conversation_metropolitan_lex_a",
		wwise_route = 0,
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
					"loc_psyker_female_c__combat_pause_limited_ogryn_a_07_b_01",
					"loc_psyker_female_c__combat_pause_limited_zealot_a_15_b_01",
					"loc_psyker_female_c__lore_brahms_three_c_02",
					"loc_psyker_female_c__combat_pause_one_liner_09",
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
				"faction_memory",
				"bonding_conversation_metropolitan_lex_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_lex_a",
				OP.ADD,
				1,
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_lex_a_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_lex_b",
		response = "bonding_conversation_metropolitan_lex_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_lex_a",
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
				"bonding_conversation_metropolitan_lex_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_lex_c",
		response = "bonding_conversation_metropolitan_lex_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_lex_b",
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
				"bonding_conversation_metropolitan_lex_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_lex_d",
		response = "bonding_conversation_metropolitan_lex_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_lex_c",
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
				"bonding_conversation_metropolitan_lex_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_lice_a",
		response = "bonding_conversation_metropolitan_lice_a",
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
					"psyker_male_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_lice_a",
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
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_lice_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_lice_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_lice_b",
		response = "bonding_conversation_metropolitan_lice_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_lice_a",
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
				"bonding_conversation_metropolitan_lice_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_lice_c",
		response = "bonding_conversation_metropolitan_lice_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_lice_b",
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
				"bonding_conversation_metropolitan_lice_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_lice_d",
		response = "bonding_conversation_metropolitan_lice_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_lice_c",
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
				"bonding_conversation_metropolitan_lice_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_mentor_a",
		response = "bonding_conversation_metropolitan_mentor_a",
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
					"psyker_female_c",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_mentor_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"time_since_zealot_seen_killstreak_psyker",
				OP.TIMEDIFF,
				OP.LT,
				30,
			},
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_mentor_a",
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
				"bonding_conversation_metropolitan_mentor_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_mentor_b",
		response = "bonding_conversation_metropolitan_mentor_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_mentor_a",
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
				"bonding_conversation_metropolitan_mentor_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_mentor_c",
		response = "bonding_conversation_metropolitan_mentor_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_mentor_b",
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
				"bonding_conversation_metropolitan_mentor_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_mentor_d",
		response = "bonding_conversation_metropolitan_mentor_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_mentor_c",
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
				"bonding_conversation_metropolitan_mentor_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_mentor_e",
		response = "bonding_conversation_metropolitan_mentor_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_mentor_d",
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
				"bonding_conversation_metropolitan_mentor_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_pressure_a",
		response = "bonding_conversation_metropolitan_pressure_a",
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
					"psyker_male_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_pressure_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_metropolitan_pressure_a",
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
				"bonding_conversation_metropolitan_pressure_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_pressure_b",
		response = "bonding_conversation_metropolitan_pressure_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_pressure_a",
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
				"bonding_conversation_metropolitan_pressure_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_pressure_c",
		response = "bonding_conversation_metropolitan_pressure_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_pressure_b",
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
				"bonding_conversation_metropolitan_pressure_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_pressure_d",
		response = "bonding_conversation_metropolitan_pressure_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_pressure_c",
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
				"bonding_conversation_metropolitan_pressure_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_pressure_e",
		response = "bonding_conversation_metropolitan_pressure_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_pressure_d",
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
				"bonding_conversation_metropolitan_pressure_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_pressure_f",
		response = "bonding_conversation_metropolitan_pressure_f",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_pressure_e",
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
				"bonding_conversation_metropolitan_pressure_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_purpose_zeaf_a",
		response = "bonding_conversation_metropolitan_purpose_zeaf_a",
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
					"psyker_female_c",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_purpose_zeaf_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_metropolitan_purpose_zeaf_a",
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
				"bonding_conversation_metropolitan_purpose_zeaf_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_purpose_zeaf_b",
		response = "bonding_conversation_metropolitan_purpose_zeaf_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_purpose_zeaf_a",
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
				"bonding_conversation_metropolitan_purpose_zeaf_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_purpose_zeaf_c",
		response = "bonding_conversation_metropolitan_purpose_zeaf_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_purpose_zeaf_b",
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
				"bonding_conversation_metropolitan_purpose_zeaf_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_purpose_zeaf_d",
		response = "bonding_conversation_metropolitan_purpose_zeaf_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_purpose_zeaf_c",
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
				"bonding_conversation_metropolitan_purpose_zeaf_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_redemption_a",
		response = "bonding_conversation_metropolitan_redemption_a",
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
					"veteran_female_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_redemption_a",
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
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_redemption_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_redemption_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_redemption_b",
		response = "bonding_conversation_metropolitan_redemption_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_redemption_a",
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
				"bonding_conversation_metropolitan_redemption_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_redemption_c",
		response = "bonding_conversation_metropolitan_redemption_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_redemption_b",
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
				"bonding_conversation_metropolitan_redemption_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_redemption_d",
		response = "bonding_conversation_metropolitan_redemption_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_redemption_c",
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
				"bonding_conversation_metropolitan_redemption_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_redemption_e",
		response = "bonding_conversation_metropolitan_redemption_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_redemption_d",
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
				"bonding_conversation_metropolitan_redemption_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_redemption_f",
		response = "bonding_conversation_metropolitan_redemption_f",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_redemption_e",
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
				"bonding_conversation_metropolitan_redemption_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_saint_a",
		response = "bonding_conversation_metropolitan_saint_a",
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
					"veteran_female_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_saint_a",
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
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_saint_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_saint_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_saint_b",
		response = "bonding_conversation_metropolitan_saint_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_saint_a",
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
				"bonding_conversation_metropolitan_saint_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_saint_c",
		response = "bonding_conversation_metropolitan_saint_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_saint_b",
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
				"bonding_conversation_metropolitan_saint_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_saint_d",
		response = "bonding_conversation_metropolitan_saint_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_saint_c",
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
				"bonding_conversation_metropolitan_saint_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_saint_e",
		response = "bonding_conversation_metropolitan_saint_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_saint_d",
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
				"bonding_conversation_metropolitan_saint_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_sealed_a",
		response = "bonding_conversation_metropolitan_sealed_a",
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
					"psyker_male_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_sealed_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_metropolitan_sealed_a",
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
				"bonding_conversation_metropolitan_sealed_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_sealed_b",
		response = "bonding_conversation_metropolitan_sealed_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_sealed_a",
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
				"bonding_conversation_metropolitan_sealed_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_sealed_c",
		response = "bonding_conversation_metropolitan_sealed_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_sealed_b",
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
				"bonding_conversation_metropolitan_sealed_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_sealed_d",
		response = "bonding_conversation_metropolitan_sealed_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_sealed_c",
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
				"bonding_conversation_metropolitan_sealed_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_sealed_e",
		response = "bonding_conversation_metropolitan_sealed_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_sealed_d",
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
				"bonding_conversation_metropolitan_sealed_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_sealed_f",
		response = "bonding_conversation_metropolitan_sealed_f",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_sealed_e",
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
				"bonding_conversation_metropolitan_sealed_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_spine_a",
		response = "bonding_conversation_metropolitan_spine_a",
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
					"veteran_female_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_spine_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_metropolitan_spine_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_spine_a",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_spine_b",
		response = "bonding_conversation_metropolitan_spine_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_spine_a",
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
				"bonding_conversation_metropolitan_spine_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_spine_c",
		response = "bonding_conversation_metropolitan_spine_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_spine_b",
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
				"bonding_conversation_metropolitan_spine_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_spine_d",
		response = "bonding_conversation_metropolitan_spine_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_spine_c",
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
				"bonding_conversation_metropolitan_spine_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_spine_e",
		response = "bonding_conversation_metropolitan_spine_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_spine_d",
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
				"bonding_conversation_metropolitan_spine_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_teeth_a",
		response = "bonding_conversation_metropolitan_teeth_a",
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
					"veteran_female_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_teeth_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_metropolitan_teeth_a",
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
				"bonding_conversation_metropolitan_teeth_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_teeth_b",
		response = "bonding_conversation_metropolitan_teeth_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_teeth_a",
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
				"bonding_conversation_metropolitan_teeth_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_teeth_c",
		response = "bonding_conversation_metropolitan_teeth_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_teeth_b",
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
				"bonding_conversation_metropolitan_teeth_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_teeth_d",
		response = "bonding_conversation_metropolitan_teeth_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_teeth_c",
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
				"bonding_conversation_metropolitan_teeth_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_teeth_e",
		response = "bonding_conversation_metropolitan_teeth_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_teeth_d",
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
				"bonding_conversation_metropolitan_teeth_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_teeth_f",
		response = "bonding_conversation_metropolitan_teeth_f",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_teeth_e",
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
				"bonding_conversation_metropolitan_teeth_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_truth_a",
		response = "bonding_conversation_metropolitan_truth_a",
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
					"psyker_male_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_truth_a",
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
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_truth_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_truth_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_truth_b",
		response = "bonding_conversation_metropolitan_truth_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_truth_a",
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
				"bonding_conversation_metropolitan_truth_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_truth_c",
		response = "bonding_conversation_metropolitan_truth_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_truth_b",
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
				"bonding_conversation_metropolitan_truth_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_truth_d",
		response = "bonding_conversation_metropolitan_truth_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_truth_c",
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
				"bonding_conversation_metropolitan_truth_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_truth_e",
		response = "bonding_conversation_metropolitan_truth_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_truth_d",
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
				"bonding_conversation_metropolitan_truth_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_vocation_a",
		response = "bonding_conversation_metropolitan_vocation_a",
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
					"psyker_female_c",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_vocation_a",
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
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_vocation_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_vocation_a_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_vocation_b",
		response = "bonding_conversation_metropolitan_vocation_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_vocation_a",
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
				"bonding_conversation_metropolitan_vocation_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_vocation_c",
		response = "bonding_conversation_metropolitan_vocation_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_vocation_b",
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
				"bonding_conversation_metropolitan_vocation_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_vocation_d",
		response = "bonding_conversation_metropolitan_vocation_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_vocation_c",
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
				"bonding_conversation_metropolitan_vocation_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_vocation_e",
		response = "bonding_conversation_metropolitan_vocation_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_vocation_d",
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
				"bonding_conversation_metropolitan_vocation_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_metropolitan_vocation_f",
		response = "bonding_conversation_metropolitan_vocation_f",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_vocation_e",
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
				"bonding_conversation_metropolitan_vocation_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_optimist_a",
		response = "bonding_conversation_optimist_a",
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
					"psyker_male_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_optimist_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_optimist_a",
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
				"bonding_conversation_optimist_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_optimist_b",
		response = "bonding_conversation_optimist_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_optimist_a",
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
				"bonding_conversation_optimist_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_optimist_c",
		response = "bonding_conversation_optimist_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_optimist_b",
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
				"bonding_conversation_optimist_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_optimist_d",
		response = "bonding_conversation_optimist_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_optimist_c",
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
				"bonding_conversation_optimist_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_optimist_e",
		response = "bonding_conversation_optimist_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_optimist_d",
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
				"bonding_conversation_optimist_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_compliment_a",
		response = "bonding_conversation_round_three_compliment_a",
		wwise_route = 0,
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
					"loc_psyker_female_a__combat_pause_limited_zealot_b_01_b_01",
					"loc_psyker_female_a__combat_pause_quirk_hates_poxwalkers_b_02",
					"loc_psyker_female_a__combat_pause_quirk_forgetful_b_02",
					"loc_psyker_female_a__combat_pause_limited_zealot_a_15_b_01",
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
				"faction_memory",
				"bonding_conversation_round_three_compliment_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_compliment_a",
				OP.ADD,
				1,
			},
			{
				"user_memory",
				"bonding_conversation_round_three_compliment_a_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_compliment_b",
		response = "bonding_conversation_round_three_compliment_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_compliment_a",
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
				"bonding_conversation_round_three_compliment_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_compliment_c",
		response = "bonding_conversation_round_three_compliment_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_compliment_b",
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
				"bonding_conversation_round_three_compliment_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_compliment_d",
		response = "bonding_conversation_round_three_compliment_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_compliment_c",
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
				"bonding_conversation_round_three_compliment_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_compliment_e",
		response = "bonding_conversation_round_three_compliment_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_compliment_d",
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
				"bonding_conversation_round_three_compliment_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_compliment_f",
		response = "bonding_conversation_round_three_compliment_f",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_compliment_e",
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
				"bonding_conversation_round_three_compliment_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_distance_a",
		response = "bonding_conversation_round_three_distance_a",
		wwise_route = 0,
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
					"loc_psyker_female_b__combat_pause_one_liner_05",
					"loc_psyker_female_b__combat_pause_limited_zealot_b_15_b_01",
					"loc_psyker_female_b__combat_pause_quirk_anger_b_02",
					"loc_psyker_female_b__combat_pause_quirk_drink_b_01",
					"loc_psyker_female_b__combat_pause_quirk_speed_b_01",
					"loc_psyker_female_b__combat_pause_quirk_speed_b_02",
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
				"faction_memory",
				"bonding_conversation_round_three_distance_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_round_three_distance_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_distance_a",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_distance_b",
		response = "bonding_conversation_round_three_distance_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_distance_a",
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
				"bonding_conversation_round_three_distance_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_distance_c",
		response = "bonding_conversation_round_three_distance_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_distance_b",
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
				"bonding_conversation_round_three_distance_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_distance_d",
		response = "bonding_conversation_round_three_distance_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_distance_c",
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
				"bonding_conversation_round_three_distance_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_distance_e",
		response = "bonding_conversation_round_three_distance_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_distance_d",
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
				"bonding_conversation_round_three_distance_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_distance_f",
		response = "bonding_conversation_round_three_distance_f",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_distance_e",
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
				"bonding_conversation_round_three_distance_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_distance_g",
		response = "bonding_conversation_round_three_distance_g",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_distance_f",
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
				"bonding_conversation_round_three_distance_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_distance_h",
		response = "bonding_conversation_round_three_distance_h",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_distance_g",
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
				"bonding_conversation_round_three_distance_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_psyker_peril_07_a",
		response = "bonding_conversation_round_three_psyker_peril_07_a",
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
					"psyker_male_b",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_psyker_peril_07_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_round_three_psyker_peril_07_a",
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
				"bonding_conversation_round_three_psyker_peril_07_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_psyker_peril_07_b",
		response = "bonding_conversation_round_three_psyker_peril_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_psyker_peril_07_a",
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
				"bonding_conversation_round_three_psyker_peril_07_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_psyker_peril_07_c",
		response = "bonding_conversation_round_three_psyker_peril_07_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_psyker_peril_07_b",
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
				"bonding_conversation_round_three_psyker_peril_07_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_psyker_peril_08_a",
		response = "bonding_conversation_round_three_psyker_peril_08_a",
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
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_psyker_peril_08_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_round_three_psyker_peril_08_a",
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
				"bonding_conversation_round_three_psyker_peril_08_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_psyker_peril_08_b",
		response = "bonding_conversation_round_three_psyker_peril_08_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_psyker_peril_08_a",
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
				"bonding_conversation_round_three_psyker_peril_08_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_psyker_peril_08_c",
		response = "bonding_conversation_round_three_psyker_peril_08_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_psyker_peril_08_b",
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
				"bonding_conversation_round_three_psyker_peril_08_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_psyker_peril_08_d",
		response = "bonding_conversation_round_three_psyker_peril_08_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_psyker_peril_08_c",
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
				"bonding_conversation_round_three_psyker_peril_08_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_rebuild_a",
		response = "bonding_conversation_round_three_rebuild_a",
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
					"zealot_female_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_rebuild_a",
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
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_round_three_rebuild_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_rebuild_a",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_rebuild_b",
		response = "bonding_conversation_round_three_rebuild_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_rebuild_a",
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
				"bonding_conversation_round_three_rebuild_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_rebuild_c",
		response = "bonding_conversation_round_three_rebuild_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_rebuild_b",
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
				"bonding_conversation_round_three_rebuild_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_rebuild_d",
		response = "bonding_conversation_round_three_rebuild_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_rebuild_c",
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
				"bonding_conversation_round_three_rebuild_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_screams_a",
		response = "bonding_conversation_round_three_screams_a",
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
					"psyker_female_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_screams_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_round_three_screams_a",
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
				"bonding_conversation_round_three_screams_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_screams_b",
		response = "bonding_conversation_round_three_screams_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_screams_a",
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
				"bonding_conversation_round_three_screams_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_screams_c",
		response = "bonding_conversation_round_three_screams_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_screams_b",
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
				"bonding_conversation_round_three_screams_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_screams_d",
		response = "bonding_conversation_round_three_screams_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_screams_c",
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
				"bonding_conversation_round_three_screams_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_spared_a",
		response = "bonding_conversation_round_three_spared_a",
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
					"psyker_female_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_spared_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"time_since_zealot_seen_killstreak_psyker",
				OP.TIMEDIFF,
				OP.LT,
				30,
			},
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_spared_a",
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
				"bonding_conversation_round_three_spared_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_spared_b",
		response = "bonding_conversation_round_three_spared_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_spared_a",
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
				"bonding_conversation_round_three_spared_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_spared_c",
		response = "bonding_conversation_round_three_spared_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_spared_b",
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
				"bonding_conversation_round_three_spared_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_spared_d",
		response = "bonding_conversation_round_three_spared_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_spared_c",
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
				"bonding_conversation_round_three_spared_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_spared_e",
		response = "bonding_conversation_round_three_spared_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_spared_d",
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
				"bonding_conversation_round_three_spared_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_travails_a",
		response = "bonding_conversation_round_three_travails_a",
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
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_travails_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_round_three_travails_a",
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
				"bonding_conversation_round_three_travails_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_travails_b",
		response = "bonding_conversation_round_three_travails_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_travails_a",
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
				"bonding_conversation_round_three_travails_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_travails_c",
		response = "bonding_conversation_round_three_travails_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_travails_b",
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
				"bonding_conversation_round_three_travails_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_travails_d",
		response = "bonding_conversation_round_three_travails_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_travails_c",
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
				"bonding_conversation_round_three_travails_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_useful_a",
		response = "bonding_conversation_round_three_useful_a",
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
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_round_three_useful_a",
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
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_round_three_useful_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
			{
				"user_memory",
				"bonding_conversation_round_three_useful_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_useful_b",
		response = "bonding_conversation_round_three_useful_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_useful_a",
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
				"bonding_conversation_round_three_useful_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_useful_c",
		response = "bonding_conversation_round_three_useful_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_useful_b",
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
				"bonding_conversation_round_three_useful_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_useful_d",
		response = "bonding_conversation_round_three_useful_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_useful_c",
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
				"bonding_conversation_round_three_useful_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_round_three_useful_e",
		response = "bonding_conversation_round_three_useful_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_round_three_useful_d",
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
				"bonding_conversation_round_three_useful_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_tantersome_a",
		response = "bonding_conversation_tantersome_a",
		wwise_route = 0,
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
					"loc_zealot_male_c__combat_pause_one_liner_09",
					"loc_zealot_male_c__combat_pause_quirk_anger_b_01",
					"loc_zealot_male_c__combat_pause_quirk_flame_b_01",
					"loc_zealot_male_c__combat_pause_circumstance_zealot_b_gas_b_01",
					"loc_zealot_male_c__combat_pause_circumstance_zealot_b_gas_b_02",
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
				"faction_memory",
				"bonding_conversation_tantersome_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_tantersome_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversation_tantersome_a",
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
		database = "zealot_female_b",
		name = "bonding_conversation_tantersome_b",
		response = "bonding_conversation_tantersome_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_tantersome_a",
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
				"bonding_conversation_tantersome_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_tantersome_c",
		response = "bonding_conversation_tantersome_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_tantersome_b",
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
				"bonding_conversation_tantersome_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_tantersome_d",
		response = "bonding_conversation_tantersome_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_tantersome_c",
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
				"bonding_conversation_tantersome_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_tantersome_e",
		response = "bonding_conversation_tantersome_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_tantersome_d",
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
				"bonding_conversation_tantersome_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_tantersome_f",
		response = "bonding_conversation_tantersome_f",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_tantersome_e",
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
				"bonding_conversation_tantersome_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_brahms_05_a",
		response = "bonding_conversation_waterloo_brahms_05_a",
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
					"veteran_female_b",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_waterloo_brahms_05_a",
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
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_waterloo_brahms_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversation_waterloo_brahms_05_a",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_brahms_05_b",
		response = "bonding_conversation_waterloo_brahms_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_brahms_05_a",
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
				"bonding_conversation_waterloo_brahms_05_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_brahms_05_c",
		response = "bonding_conversation_waterloo_brahms_05_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_brahms_05_b",
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
				"bonding_conversation_waterloo_brahms_05_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_brahms_05_d",
		response = "bonding_conversation_waterloo_brahms_05_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_brahms_05_c",
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
				"bonding_conversation_waterloo_brahms_05_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_psycho_a",
		response = "bonding_conversation_waterloo_psycho_a",
		wwise_route = 0,
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
					"loc_veteran_female_b__combat_pause_one_liner_03",
					"loc_veteran_female_b__combat_pause_one_liner_02",
					"loc_veteran_female_b__combat_pause_one_liner_06",
					"loc_veteran_female_b__combat_pause_one_liner_01",
					"loc_veteran_female_b__combat_pause_one_liner_07",
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
				"faction_memory",
				"bonding_conversation_waterloo_psycho_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_waterloo_psycho_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversation_waterloo_psycho_a",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_psycho_b",
		response = "bonding_conversation_waterloo_psycho_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_psycho_a",
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
				"bonding_conversation_waterloo_psycho_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_psycho_c",
		response = "bonding_conversation_waterloo_psycho_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_psycho_b",
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
				"bonding_conversation_waterloo_psycho_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_psycho_d",
		response = "bonding_conversation_waterloo_psycho_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_psycho_c",
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
				"bonding_conversation_waterloo_psycho_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_rannick_05_a",
		response = "bonding_conversation_waterloo_rannick_05_a",
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
					"veteran_female_b",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_waterloo_rannick_05_a",
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
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_waterloo_rannick_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversation_waterloo_rannick_05_a",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_rannick_05_b",
		response = "bonding_conversation_waterloo_rannick_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_rannick_05_a",
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
				"bonding_conversation_waterloo_rannick_05_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_rannick_05_c",
		response = "bonding_conversation_waterloo_rannick_05_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_rannick_05_b",
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
				"bonding_conversation_waterloo_rannick_05_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_rannick_05_d",
		response = "bonding_conversation_waterloo_rannick_05_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_rannick_05_c",
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
				"bonding_conversation_waterloo_rannick_05_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_sin_a",
		response = "bonding_conversation_waterloo_sin_a",
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
					"veteran_female_b",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_waterloo_sin_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_waterloo_sin_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversation_waterloo_sin_a",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_sin_b",
		response = "bonding_conversation_waterloo_sin_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_sin_a",
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
				"bonding_conversation_waterloo_sin_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_sin_c",
		response = "bonding_conversation_waterloo_sin_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_sin_b",
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
				"bonding_conversation_waterloo_sin_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_sin_d",
		response = "bonding_conversation_waterloo_sin_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_sin_c",
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
				"bonding_conversation_waterloo_sin_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_tithe_a",
		response = "bonding_conversation_waterloo_tithe_a",
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
					"veteran_female_b",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_waterloo_tithe_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversation_waterloo_tithe_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversation_waterloo_tithe_a",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_tithe_b",
		response = "bonding_conversation_waterloo_tithe_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_tithe_a",
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
				"bonding_conversation_waterloo_tithe_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_tithe_c",
		response = "bonding_conversation_waterloo_tithe_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_tithe_b",
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
				"bonding_conversation_waterloo_tithe_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_tithe_d",
		response = "bonding_conversation_waterloo_tithe_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_tithe_c",
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
				"bonding_conversation_waterloo_tithe_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_tithe_e",
		response = "bonding_conversation_waterloo_tithe_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_tithe_d",
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
				"bonding_conversation_waterloo_tithe_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_tithe_f",
		response = "bonding_conversation_waterloo_tithe_f",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_tithe_e",
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
				"bonding_conversation_waterloo_tithe_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_tithe_g",
		response = "bonding_conversation_waterloo_tithe_g",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_tithe_f",
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
				"bonding_conversation_waterloo_tithe_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_tithe_h",
		response = "bonding_conversation_waterloo_tithe_h",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_tithe_g",
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
				"bonding_conversation_waterloo_tithe_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_wolfer_05_a",
		response = "bonding_conversation_waterloo_wolfer_05_a",
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
					"veteran_female_b",
				},
			},
			{
				"faction_memory",
				"bonding_conversation_waterloo_wolfer_05_a",
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
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_waterloo_wolfer_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversation_waterloo_wolfer_05_a",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_wolfer_05_b",
		response = "bonding_conversation_waterloo_wolfer_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_wolfer_05_a",
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
				"bonding_conversation_waterloo_wolfer_05_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_wolfer_05_c",
		response = "bonding_conversation_waterloo_wolfer_05_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_wolfer_05_b",
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
				"bonding_conversation_waterloo_wolfer_05_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversation_waterloo_wolfer_05_d",
		response = "bonding_conversation_waterloo_wolfer_05_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_waterloo_wolfer_05_c",
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
				"bonding_conversation_waterloo_wolfer_05_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_decorum_a",
		response = "bonding_conversations_victoria_decorum_a",
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
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversations_victoria_decorum_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversations_victoria_decorum_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversations_victoria_decorum_a",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_decorum_b",
		response = "bonding_conversations_victoria_decorum_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_decorum_a",
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
				"bonding_conversations_victoria_decorum_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_decorum_c",
		response = "bonding_conversations_victoria_decorum_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_decorum_b",
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
				"bonding_conversations_victoria_decorum_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_decorum_d",
		response = "bonding_conversations_victoria_decorum_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_decorum_c",
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
				"bonding_conversations_victoria_decorum_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_decorum_e",
		response = "bonding_conversations_victoria_decorum_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_decorum_d",
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
				"bonding_conversations_victoria_decorum_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_driven_a",
		response = "bonding_conversations_victoria_driven_a",
		wwise_route = 0,
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
					"loc_zealot_female_c__combat_pause_one_liner_03",
					"loc_zealot_female_c__combat_pause_one_liner_04",
					"loc_zealot_female_c__combat_pause_one_liner_10",
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
				"faction_memory",
				"bonding_conversations_victoria_driven_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversations_victoria_driven_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversations_victoria_driven_a",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_driven_b",
		response = "bonding_conversations_victoria_driven_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_driven_a",
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
				"bonding_conversations_victoria_driven_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_driven_c",
		response = "bonding_conversations_victoria_driven_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_driven_b",
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
				"bonding_conversations_victoria_driven_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_driven_d",
		response = "bonding_conversations_victoria_driven_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_driven_c",
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
				"bonding_conversations_victoria_driven_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_freedom_a",
		response = "bonding_conversations_victoria_freedom_a",
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
					"zealot_female_c",
				},
			},
			{
				"faction_memory",
				"bonding_conversations_victoria_freedom_a",
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
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversations_victoria_freedom_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversations_victoria_freedom_a",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_freedom_b",
		response = "bonding_conversations_victoria_freedom_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_freedom_a",
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
				"bonding_conversations_victoria_freedom_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_freedom_c",
		response = "bonding_conversations_victoria_freedom_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_freedom_b",
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
				"bonding_conversations_victoria_freedom_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_freedom_d",
		response = "bonding_conversations_victoria_freedom_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_freedom_c",
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
				"bonding_conversations_victoria_freedom_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_glorious_day_a",
		response = "bonding_conversations_victoria_glorious_day_a",
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
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversations_victoria_glorious_day_a",
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
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversations_victoria_glorious_day_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversations_victoria_glorious_day_a",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_glorious_day_b",
		response = "bonding_conversations_victoria_glorious_day_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_glorious_day_a",
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
				"bonding_conversations_victoria_glorious_day_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_glorious_day_c",
		response = "bonding_conversations_victoria_glorious_day_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_glorious_day_b",
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
				"bonding_conversations_victoria_glorious_day_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_glorious_day_d",
		response = "bonding_conversations_victoria_glorious_day_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_glorious_day_c",
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
				"bonding_conversations_victoria_glorious_day_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_glorious_day_e",
		response = "bonding_conversations_victoria_glorious_day_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_glorious_day_d",
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
				"bonding_conversations_victoria_glorious_day_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_glorious_day_f",
		response = "bonding_conversations_victoria_glorious_day_f",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_glorious_day_e",
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
				"bonding_conversations_victoria_glorious_day_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_glorious_day_g",
		response = "bonding_conversations_victoria_glorious_day_g",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_glorious_day_f",
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
				"bonding_conversations_victoria_glorious_day_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_ice_a",
		response = "bonding_conversations_victoria_ice_a",
		wwise_route = 0,
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
					"loc_veteran_female_c__combat_pause_limited_zealot_b_17_b_01",
					"loc_veteran_female_c__combat_pause_one_liner_09",
					"loc_veteran_female_c__combat_pause_limited_veteran_c_04_b_01",
					"loc_veteran_female_c__combat_pause_limited_psyker_a_04_b_01",
					"loc_veteran_female_c__combat_pause_quirk_endless_war_b_01",
					"loc_veteran_female_c__combat_pause_quirk_weapons_b_02",
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
				"faction_memory",
				"bonding_conversations_victoria_ice_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversations_victoria_ice_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversations_victoria_ice_a",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_ice_b",
		response = "bonding_conversations_victoria_ice_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_ice_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversations_victoria_ice_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_ice_c",
		response = "bonding_conversations_victoria_ice_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_ice_b",
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
				"bonding_conversations_victoria_ice_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_ice_d",
		response = "bonding_conversations_victoria_ice_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_ice_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_c",
				},
			},
			{
				"user_memory",
				"bonding_conversations_victoria_ice_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_purging_a",
		response = "bonding_conversations_victoria_purging_a",
		wwise_route = 0,
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
					"loc_zealot_female_c__combat_pause_limited_zealot_b_02_b_01",
					"loc_zealot_female_c__combat_pause_limited_zealot_b_09_b_01",
					"loc_zealot_female_c__combat_pause_one_liner_09",
					"loc_zealot_female_c__combat_pause_quirk_endless_b_02",
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
				"faction_memory",
				"bonding_conversations_victoria_purging_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversations_victoria_purging_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversations_victoria_purging_a",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_purging_b",
		response = "bonding_conversations_victoria_purging_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_purging_a",
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
				"bonding_conversations_victoria_purging_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_purging_c",
		response = "bonding_conversations_victoria_purging_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_purging_b",
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
				"bonding_conversations_victoria_purging_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_purging_d",
		response = "bonding_conversations_victoria_purging_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_purging_c",
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
				"bonding_conversations_victoria_purging_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_righteous_a",
		response = "bonding_conversations_victoria_righteous_a",
		wwise_route = 0,
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
					"loc_zealot_female_c__combat_pause_one_liner_04",
					"loc_zealot_female_c__combat_pause_one_liner_03",
					"loc_zealot_female_c__combat_pause_limited_zealot_b_06_b_01",
					"loc_zealot_female_c__combat_pause_quirk_trial_b_01",
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
				"faction_memory",
				"bonding_conversations_victoria_righteous_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversations_victoria_righteous_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversations_victoria_righteous_a",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_righteous_b",
		response = "bonding_conversations_victoria_righteous_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_righteous_a",
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
				"bonding_conversations_victoria_righteous_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_righteous_c",
		response = "bonding_conversations_victoria_righteous_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_righteous_b",
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
				"bonding_conversations_victoria_righteous_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_righteous_d",
		response = "bonding_conversations_victoria_righteous_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_righteous_c",
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
				"bonding_conversations_victoria_righteous_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_righteous_e",
		response = "bonding_conversations_victoria_righteous_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_righteous_d",
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
				"bonding_conversations_victoria_righteous_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_slaughter_a",
		response = "bonding_conversations_victoria_slaughter_a",
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
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"bonding_conversations_victoria_slaughter_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140,
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
				"bonding_conversations_victoria_slaughter_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"bonding_conversations_victoria_slaughter_a",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_slaughter_b",
		response = "bonding_conversations_victoria_slaughter_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_slaughter_a",
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
				"bonding_conversations_victoria_slaughter_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_slaughter_c",
		response = "bonding_conversations_victoria_slaughter_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_slaughter_b",
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
				"bonding_conversations_victoria_slaughter_a_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_slaughter_d",
		response = "bonding_conversations_victoria_slaughter_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_slaughter_c",
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
				"bonding_conversations_victoria_slaughter_b_user",
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
		database = "zealot_female_b",
		name = "bonding_conversations_victoria_slaughter_e",
		response = "bonding_conversations_victoria_slaughter_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversations_victoria_slaughter_d",
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
				"bonding_conversations_victoria_slaughter_a_user",
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
		database = "zealot_female_b",
		name = "oval_bonding_conversation_air_a",
		response = "oval_bonding_conversation_air_a",
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
					"ogryn_a",
				},
			},
			{
				"faction_memory",
				"oval_bonding_conversation_air_a",
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
		},
		on_done = {
			{
				"user_memory",
				"oval_bonding_conversation_air_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"oval_bonding_conversation_air_a",
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
		database = "zealot_female_b",
		name = "oval_bonding_conversation_air_b",
		response = "oval_bonding_conversation_air_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"oval_bonding_conversation_air_a",
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
				"oval_bonding_conversation_air_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "zealot_female_b",
		name = "oval_bonding_conversation_air_c",
		response = "oval_bonding_conversation_air_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"oval_bonding_conversation_air_b",
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
				"oval_bonding_conversation_air_a_user",
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
		database = "zealot_female_b",
		name = "oval_bonding_conversation_air_d",
		response = "oval_bonding_conversation_air_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"oval_bonding_conversation_air_c",
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
				"oval_bonding_conversation_air_b_user",
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
