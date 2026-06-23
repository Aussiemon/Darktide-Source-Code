-- chunkname: @dialogues/generated/cryptic_b.lua

return function ()
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_01_a",
		response = "combat_pause_limited_cryptic_b_01_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_a",
					"cryptic_c",
					"cryptic_d",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_01_a",
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
				"combat_pause_limited_cryptic_b_01_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_01_b",
		response = "combat_pause_limited_cryptic_b_01_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_01_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_a",
					"cryptic_c",
					"cryptic_d",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_02_a",
		response = "combat_pause_limited_cryptic_b_02_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_b",
					"adamant_female_c",
					"adamant_male_b",
					"adamant_male_c",
					"broker_female_b",
					"broker_female_c",
					"broker_male_b",
					"broker_male_c",
					"ogryn_d",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_b",
					"psyker_male_c",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_b",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_02_a",
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
				"combat_pause_limited_cryptic_b_02_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_02_b",
		response = "combat_pause_limited_cryptic_b_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_02_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_b",
					"adamant_female_c",
					"adamant_male_b",
					"adamant_male_c",
					"broker_female_b",
					"broker_female_c",
					"broker_male_b",
					"broker_male_c",
					"ogryn_d",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_b",
					"psyker_male_c",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_b",
					"zealot_male_c",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_03_a",
		response = "combat_pause_limited_cryptic_b_03_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
					"broker_male_a",
					"cryptic_a",
					"cryptic_c",
					"enginseer_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_03_a",
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
				"combat_pause_limited_cryptic_b_03_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_03_b",
		response = "combat_pause_limited_cryptic_b_03_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_03_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
					"broker_male_a",
					"cryptic_a",
					"cryptic_c",
					"enginseer_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_04_a",
		response = "combat_pause_limited_cryptic_b_04_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_a",
					"adamant_male_a",
					"cryptic_c",
					"psyker_female_a",
					"psyker_male_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_b",
					"veteran_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_04_a",
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
				"combat_pause_limited_cryptic_b_04_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_04_b",
		response = "combat_pause_limited_cryptic_b_04_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_04_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
					"adamant_male_a",
					"cryptic_c",
					"psyker_female_a",
					"psyker_male_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_b",
					"veteran_male_c",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_05_a",
		response = "combat_pause_limited_cryptic_b_05_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_b",
					"adamant_female_c",
					"adamant_male_b",
					"adamant_male_c",
					"broker_female_a",
					"broker_male_a",
					"cryptic_a",
					"enginseer_a",
					"ogryn_d",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_b",
					"psyker_male_c",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_05_a",
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
				"combat_pause_limited_cryptic_b_05_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_05_b",
		response = "combat_pause_limited_cryptic_b_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_b",
					"adamant_female_c",
					"adamant_male_b",
					"adamant_male_c",
					"broker_female_a",
					"broker_male_a",
					"cryptic_a",
					"enginseer_a",
					"ogryn_d",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_b",
					"psyker_male_c",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_06_a",
		response = "combat_pause_limited_cryptic_b_06_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_c",
					"broker_male_c",
					"veteran_female_a",
					"veteran_male_a",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_06_a",
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
				"combat_pause_limited_cryptic_b_06_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_06_b",
		response = "combat_pause_limited_cryptic_b_06_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_c",
					"broker_male_c",
					"veteran_female_a",
					"veteran_male_a",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_07_a",
		response = "combat_pause_limited_cryptic_b_07_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_b",
					"broker_male_b",
					"cryptic_c",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_07_a",
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
				"combat_pause_limited_cryptic_b_07_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_07_b",
		response = "combat_pause_limited_cryptic_b_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_07_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_b",
					"broker_male_b",
					"cryptic_c",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_08_a",
		response = "combat_pause_limited_cryptic_b_08_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_a",
					"adamant_male_a",
					"cryptic_d",
					"cryptic_d",
					"ogryn_a",
					"ogryn_a",
					"ogryn_d",
					"psyker_female_a",
					"psyker_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_08_a",
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
				"combat_pause_limited_cryptic_b_08_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_08_b",
		response = "combat_pause_limited_cryptic_b_08_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_08_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
					"adamant_male_a",
					"cryptic_d",
					"cryptic_d",
					"ogryn_a",
					"ogryn_a",
					"ogryn_d",
					"psyker_female_a",
					"psyker_male_a",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_09_a",
		response = "combat_pause_limited_cryptic_b_09_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_a",
					"adamant_male_a",
					"broker_female_b",
					"broker_male_b",
					"enginseer_a",
					"psyker_female_a",
					"psyker_male_a",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_09_a",
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
				"combat_pause_limited_cryptic_b_09_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_09_b",
		response = "combat_pause_limited_cryptic_b_09_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_09_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
					"adamant_male_a",
					"broker_female_b",
					"broker_male_b",
					"enginseer_a",
					"psyker_female_a",
					"psyker_male_a",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_10_a",
		response = "combat_pause_limited_cryptic_b_10_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_d",
					"cryptic_d",
					"ogryn_a",
					"ogryn_a",
					"ogryn_b",
					"ogryn_b",
					"ogryn_c",
					"ogryn_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_10_a",
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
				"combat_pause_limited_cryptic_b_10_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_10_b",
		response = "combat_pause_limited_cryptic_b_10_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_10_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_d",
					"cryptic_d",
					"ogryn_a",
					"ogryn_a",
					"ogryn_b",
					"ogryn_b",
					"ogryn_c",
					"ogryn_c",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_11_a",
		response = "combat_pause_limited_cryptic_b_11_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_b",
					"adamant_female_c",
					"adamant_male_b",
					"adamant_male_c",
					"ogryn_d",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_11_a",
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
				"combat_pause_limited_cryptic_b_11_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_11_b",
		response = "combat_pause_limited_cryptic_b_11_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_11_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_b",
					"adamant_female_c",
					"adamant_male_b",
					"adamant_male_c",
					"ogryn_d",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_12_a",
		response = "combat_pause_limited_cryptic_b_12_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_a",
					"veteran_female_a",
					"veteran_male_a",
					"veteran_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_12_a",
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
				"combat_pause_limited_cryptic_b_12_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_12_b",
		response = "combat_pause_limited_cryptic_b_12_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_12_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a",
					"veteran_female_a",
					"veteran_male_a",
					"veteran_male_a",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_13_a",
		response = "combat_pause_limited_cryptic_b_13_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
					"broker_female_c",
					"broker_male_a",
					"broker_male_c",
					"cryptic_a",
					"zealot_female_a",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_13_a",
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
				"combat_pause_limited_cryptic_b_13_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_13_b",
		response = "combat_pause_limited_cryptic_b_13_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_13_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
					"broker_female_c",
					"broker_male_a",
					"broker_male_c",
					"cryptic_a",
					"zealot_female_a",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_c",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_14_a",
		response = "combat_pause_limited_cryptic_b_14_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_b",
					"broker_female_c",
					"broker_male_b",
					"broker_male_c",
					"enginseer_a",
					"ogryn_b",
					"ogryn_b",
					"ogryn_c",
					"ogryn_c",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_14_a",
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
				"combat_pause_limited_cryptic_b_14_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_14_b",
		response = "combat_pause_limited_cryptic_b_14_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_14_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_b",
					"broker_female_c",
					"broker_male_b",
					"broker_male_c",
					"enginseer_a",
					"ogryn_b",
					"ogryn_b",
					"ogryn_c",
					"ogryn_c",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_15_a",
		response = "combat_pause_limited_cryptic_b_15_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_a",
					"adamant_female_b",
					"adamant_female_c",
					"adamant_male_a",
					"adamant_male_b",
					"adamant_male_c",
					"ogryn_d",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_15_a",
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
				"combat_pause_limited_cryptic_b_15_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_15_b",
		response = "combat_pause_limited_cryptic_b_15_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_15_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
					"adamant_female_b",
					"adamant_female_c",
					"adamant_male_a",
					"adamant_male_b",
					"adamant_male_c",
					"ogryn_d",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_16_a",
		response = "combat_pause_limited_cryptic_b_16_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_c",
					"ogryn_b",
					"ogryn_b",
					"ogryn_c",
					"ogryn_c",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_b",
					"veteran_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_16_a",
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
				"combat_pause_limited_cryptic_b_16_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_16_b",
		response = "combat_pause_limited_cryptic_b_16_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_c",
					"ogryn_b",
					"ogryn_b",
					"ogryn_c",
					"ogryn_c",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_b",
					"veteran_male_c",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_17_a",
		response = "combat_pause_limited_cryptic_b_17_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_female_a",
					"broker_male_a",
					"cryptic_a",
					"cryptic_c",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_17_a",
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
				"combat_pause_limited_cryptic_b_17_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_17_b",
		response = "combat_pause_limited_cryptic_b_17_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_female_a",
					"broker_male_a",
					"cryptic_a",
					"cryptic_c",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_18_a",
		response = "combat_pause_limited_cryptic_b_18_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_b",
					"adamant_female_c",
					"adamant_male_b",
					"adamant_male_c",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_18_a",
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
				"combat_pause_limited_cryptic_b_18_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_18_b",
		response = "combat_pause_limited_cryptic_b_18_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_18_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_b",
					"adamant_female_c",
					"adamant_male_b",
					"adamant_male_c",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_19_a",
		response = "combat_pause_limited_cryptic_b_19_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_a",
					"adamant_male_a",
					"cryptic_a",
					"psyker_female_a",
					"psyker_male_a",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_19_a",
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
				"combat_pause_limited_cryptic_b_19_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_19_b",
		response = "combat_pause_limited_cryptic_b_19_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_19_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_a",
					"adamant_male_a",
					"cryptic_a",
					"psyker_female_a",
					"psyker_male_a",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_20_a",
		response = "combat_pause_limited_cryptic_b_20_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"adamant_female_b",
					"adamant_female_c",
					"adamant_male_b",
					"adamant_male_c",
					"cryptic_d",
					"cryptic_d",
					"enginseer_a",
					"ogryn_a",
					"ogryn_a",
					"ogryn_d",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_b",
					"psyker_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_cryptic_b_20_a",
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
				"combat_pause_limited_cryptic_b_20_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "combat_pause_limited_cryptic_b_20_b",
		response = "combat_pause_limited_cryptic_b_20_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_cryptic_b_20_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"adamant_female_b",
					"adamant_female_c",
					"adamant_male_b",
					"adamant_male_c",
					"cryptic_d",
					"cryptic_d",
					"enginseer_a",
					"ogryn_a",
					"ogryn_a",
					"ogryn_d",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_b",
					"psyker_male_c",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_01_a",
		response = "cryptic_b_adamant_bonding_conversation_01_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_01_a",
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
				"cryptic_b_adamant_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_01_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_01_b",
		response = "cryptic_b_adamant_bonding_conversation_01_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_01_a",
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
				"cryptic_b_adamant_bonding_conversation_01_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_01_c",
		response = "cryptic_b_adamant_bonding_conversation_01_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_01_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_01_d",
		response = "cryptic_b_adamant_bonding_conversation_01_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_01_c",
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
				"cryptic_b_adamant_bonding_conversation_01_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_02_a",
		response = "cryptic_b_adamant_bonding_conversation_02_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_02_a",
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
				"cryptic_b_adamant_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_02_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_02_b",
		response = "cryptic_b_adamant_bonding_conversation_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_02_a",
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
				"cryptic_b_adamant_bonding_conversation_02_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_02_c",
		response = "cryptic_b_adamant_bonding_conversation_02_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_02_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_02_d",
		response = "cryptic_b_adamant_bonding_conversation_02_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_02_c",
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
				"cryptic_b_adamant_bonding_conversation_02_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_03_a",
		response = "cryptic_b_adamant_bonding_conversation_03_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_03_a",
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
				"cryptic_b_adamant_bonding_conversation_03_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_03_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_03_b",
		response = "cryptic_b_adamant_bonding_conversation_03_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_03_a",
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
				"cryptic_b_adamant_bonding_conversation_03_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_03_c",
		response = "cryptic_b_adamant_bonding_conversation_03_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_03_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_03_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_03_d",
		response = "cryptic_b_adamant_bonding_conversation_03_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_03_c",
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
				"cryptic_b_adamant_bonding_conversation_03_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_04_a",
		response = "cryptic_b_adamant_bonding_conversation_04_a",
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
					"adamant_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_04_a",
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
				"cryptic_b_adamant_bonding_conversation_04_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_04_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_04_b",
		response = "cryptic_b_adamant_bonding_conversation_04_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_04_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_04_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_04_c",
		response = "cryptic_b_adamant_bonding_conversation_04_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_04_b",
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
				"cryptic_b_adamant_bonding_conversation_04_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_04_d",
		response = "cryptic_b_adamant_bonding_conversation_04_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_04_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_04_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_05_a",
		response = "cryptic_b_adamant_bonding_conversation_05_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_05_a",
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
				"cryptic_b_adamant_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_05_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_05_b",
		response = "cryptic_b_adamant_bonding_conversation_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_05_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_05_c",
		response = "cryptic_b_adamant_bonding_conversation_05_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_05_b",
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
				"cryptic_b_adamant_bonding_conversation_05_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_05_d",
		response = "cryptic_b_adamant_bonding_conversation_05_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_05_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_06_a",
		response = "cryptic_b_adamant_bonding_conversation_06_a",
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
					"adamant_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_06_a",
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
				"cryptic_b_adamant_bonding_conversation_06_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_06_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_06_b",
		response = "cryptic_b_adamant_bonding_conversation_06_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_06_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_06_c",
		response = "cryptic_b_adamant_bonding_conversation_06_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_06_b",
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
				"cryptic_b_adamant_bonding_conversation_06_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_06_d",
		response = "cryptic_b_adamant_bonding_conversation_06_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_06_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_06_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_13_a",
		response = "cryptic_b_adamant_bonding_conversation_13_a",
		wwise_route = 0,
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
					"loc_adamant_male_b__combat_pause_one_liner_a_05",
					"loc_adamant_male_b__combat_pause_one_liner_a_08",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_13_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_13_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_13_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_13_b",
		response = "cryptic_b_adamant_bonding_conversation_13_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_13_a",
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
				"cryptic_b_adamant_bonding_conversation_13_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_13_c",
		response = "cryptic_b_adamant_bonding_conversation_13_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_13_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_13_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_13_d",
		response = "cryptic_b_adamant_bonding_conversation_13_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_13_c",
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
				"cryptic_b_adamant_bonding_conversation_13_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_14_a",
		response = "cryptic_b_adamant_bonding_conversation_14_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_14_a",
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
				"cryptic_b_adamant_bonding_conversation_14_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_14_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_14_b",
		response = "cryptic_b_adamant_bonding_conversation_14_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_14_a",
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
				"cryptic_b_adamant_bonding_conversation_14_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_14_c",
		response = "cryptic_b_adamant_bonding_conversation_14_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_14_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_14_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_14_d",
		response = "cryptic_b_adamant_bonding_conversation_14_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_14_c",
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
				"cryptic_b_adamant_bonding_conversation_14_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_15_a",
		response = "cryptic_b_adamant_bonding_conversation_15_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_15_a",
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
				"cryptic_b_adamant_bonding_conversation_15_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_15_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_15_b",
		response = "cryptic_b_adamant_bonding_conversation_15_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_15_a",
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
				"cryptic_b_adamant_bonding_conversation_15_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_15_c",
		response = "cryptic_b_adamant_bonding_conversation_15_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_15_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_15_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_15_d",
		response = "cryptic_b_adamant_bonding_conversation_15_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_15_c",
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
				"cryptic_b_adamant_bonding_conversation_15_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_16_a",
		response = "cryptic_b_adamant_bonding_conversation_16_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_16_a",
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
				"cryptic_b_adamant_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_16_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_16_b",
		response = "cryptic_b_adamant_bonding_conversation_16_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_16_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_16_c",
		response = "cryptic_b_adamant_bonding_conversation_16_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_16_b",
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
				"cryptic_b_adamant_bonding_conversation_16_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_16_d",
		response = "cryptic_b_adamant_bonding_conversation_16_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_16_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_17_a",
		response = "cryptic_b_adamant_bonding_conversation_17_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_17_a",
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
				"cryptic_b_adamant_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_17_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_17_b",
		response = "cryptic_b_adamant_bonding_conversation_17_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_17_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_17_c",
		response = "cryptic_b_adamant_bonding_conversation_17_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_17_b",
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
				"cryptic_b_adamant_bonding_conversation_17_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_17_d",
		response = "cryptic_b_adamant_bonding_conversation_17_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_17_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_18_a",
		response = "cryptic_b_adamant_bonding_conversation_18_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_18_a",
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
				"cryptic_b_adamant_bonding_conversation_18_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_18_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_18_b",
		response = "cryptic_b_adamant_bonding_conversation_18_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_18_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_18_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_18_c",
		response = "cryptic_b_adamant_bonding_conversation_18_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_18_b",
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
				"cryptic_b_adamant_bonding_conversation_18_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_18_d",
		response = "cryptic_b_adamant_bonding_conversation_18_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_18_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_18_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_19_a",
		response = "cryptic_b_adamant_bonding_conversation_19_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_19_a",
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
				"cryptic_b_adamant_bonding_conversation_19_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_19_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_19_b",
		response = "cryptic_b_adamant_bonding_conversation_19_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_19_a",
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
				"cryptic_b_adamant_bonding_conversation_19_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_19_c",
		response = "cryptic_b_adamant_bonding_conversation_19_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_19_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_19_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_19_d",
		response = "cryptic_b_adamant_bonding_conversation_19_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_19_c",
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
				"cryptic_b_adamant_bonding_conversation_19_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_20_a",
		response = "cryptic_b_adamant_bonding_conversation_20_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_20_a",
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
				"cryptic_b_adamant_bonding_conversation_20_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_20_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_20_b",
		response = "cryptic_b_adamant_bonding_conversation_20_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_20_a",
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
				"cryptic_b_adamant_bonding_conversation_20_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_20_c",
		response = "cryptic_b_adamant_bonding_conversation_20_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_20_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_20_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_20_d",
		response = "cryptic_b_adamant_bonding_conversation_20_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_20_c",
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
				"cryptic_b_adamant_bonding_conversation_20_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_21_a",
		response = "cryptic_b_adamant_bonding_conversation_21_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_21_a",
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
				"cryptic_b_adamant_bonding_conversation_21_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_21_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_21_b",
		response = "cryptic_b_adamant_bonding_conversation_21_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_21_a",
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
				"cryptic_b_adamant_bonding_conversation_21_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_21_c",
		response = "cryptic_b_adamant_bonding_conversation_21_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_21_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_21_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_21_d",
		response = "cryptic_b_adamant_bonding_conversation_21_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_21_c",
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
				"cryptic_b_adamant_bonding_conversation_21_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_22_a",
		response = "cryptic_b_adamant_bonding_conversation_22_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_22_a",
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
				"cryptic_b_adamant_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_22_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_22_b",
		response = "cryptic_b_adamant_bonding_conversation_22_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_22_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_22_c",
		response = "cryptic_b_adamant_bonding_conversation_22_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_22_b",
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
				"cryptic_b_adamant_bonding_conversation_22_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_22_d",
		response = "cryptic_b_adamant_bonding_conversation_22_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_22_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_22_e",
		response = "cryptic_b_adamant_bonding_conversation_22_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_22_d",
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
				"cryptic_b_adamant_bonding_conversation_22_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_23_a",
		response = "cryptic_b_adamant_bonding_conversation_23_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_23_a",
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
				"cryptic_b_adamant_bonding_conversation_23_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_23_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_23_b",
		response = "cryptic_b_adamant_bonding_conversation_23_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_23_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_23_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_23_c",
		response = "cryptic_b_adamant_bonding_conversation_23_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_23_b",
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
				"cryptic_b_adamant_bonding_conversation_23_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_23_d",
		response = "cryptic_b_adamant_bonding_conversation_23_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_23_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_23_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_24_a",
		response = "cryptic_b_adamant_bonding_conversation_24_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_24_a",
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
				"cryptic_b_adamant_bonding_conversation_24_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_24_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_24_b",
		response = "cryptic_b_adamant_bonding_conversation_24_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_24_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_24_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_24_c",
		response = "cryptic_b_adamant_bonding_conversation_24_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_24_b",
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
				"cryptic_b_adamant_bonding_conversation_24_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_24_d",
		response = "cryptic_b_adamant_bonding_conversation_24_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_24_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_24_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_25_a",
		response = "cryptic_b_adamant_bonding_conversation_25_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_25_a",
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
				"cryptic_b_adamant_bonding_conversation_25_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_25_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_25_b",
		response = "cryptic_b_adamant_bonding_conversation_25_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_25_a",
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
				"cryptic_b_adamant_bonding_conversation_25_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_25_c",
		response = "cryptic_b_adamant_bonding_conversation_25_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_25_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_25_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_25_d",
		response = "cryptic_b_adamant_bonding_conversation_25_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_25_c",
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
				"cryptic_b_adamant_bonding_conversation_25_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_26_a",
		response = "cryptic_b_adamant_bonding_conversation_26_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_26_a",
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
				"cryptic_b_adamant_bonding_conversation_26_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_26_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_26_b",
		response = "cryptic_b_adamant_bonding_conversation_26_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_26_a",
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
				"cryptic_b_adamant_bonding_conversation_26_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_26_c",
		response = "cryptic_b_adamant_bonding_conversation_26_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_26_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_26_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_26_d",
		response = "cryptic_b_adamant_bonding_conversation_26_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_26_c",
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
				"cryptic_b_adamant_bonding_conversation_26_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_27_a",
		response = "cryptic_b_adamant_bonding_conversation_27_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_27_a",
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
				"cryptic_b_adamant_bonding_conversation_27_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_27_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_27_b",
		response = "cryptic_b_adamant_bonding_conversation_27_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_27_a",
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
				"cryptic_b_adamant_bonding_conversation_27_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_27_c",
		response = "cryptic_b_adamant_bonding_conversation_27_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_27_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_27_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_27_d",
		response = "cryptic_b_adamant_bonding_conversation_27_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_27_c",
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
				"cryptic_b_adamant_bonding_conversation_27_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_28_a",
		response = "cryptic_b_adamant_bonding_conversation_28_a",
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
					"adamant_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_28_a",
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
				"cryptic_b_adamant_bonding_conversation_28_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_28_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_28_b",
		response = "cryptic_b_adamant_bonding_conversation_28_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_28_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_28_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_28_c",
		response = "cryptic_b_adamant_bonding_conversation_28_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_28_b",
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
				"cryptic_b_adamant_bonding_conversation_28_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_28_d",
		response = "cryptic_b_adamant_bonding_conversation_28_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_28_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_28_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_29_a",
		response = "cryptic_b_adamant_bonding_conversation_29_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_29_a",
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
				"cryptic_b_adamant_bonding_conversation_29_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_29_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_29_b",
		response = "cryptic_b_adamant_bonding_conversation_29_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_29_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_29_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_29_c",
		response = "cryptic_b_adamant_bonding_conversation_29_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_29_b",
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
				"cryptic_b_adamant_bonding_conversation_29_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_29_d",
		response = "cryptic_b_adamant_bonding_conversation_29_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_29_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_29_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_30_a",
		response = "cryptic_b_adamant_bonding_conversation_30_a",
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
					"adamant_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_30_a",
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
				"cryptic_b_adamant_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_30_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_30_b",
		response = "cryptic_b_adamant_bonding_conversation_30_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_30_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_30_c",
		response = "cryptic_b_adamant_bonding_conversation_30_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_30_b",
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
				"cryptic_b_adamant_bonding_conversation_30_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_30_d",
		response = "cryptic_b_adamant_bonding_conversation_30_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_30_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_31_a",
		response = "cryptic_b_adamant_bonding_conversation_31_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_31_a",
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
				"cryptic_b_adamant_bonding_conversation_31_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_31_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_31_b",
		response = "cryptic_b_adamant_bonding_conversation_31_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_31_a",
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
				"cryptic_b_adamant_bonding_conversation_31_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_31_c",
		response = "cryptic_b_adamant_bonding_conversation_31_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_31_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_31_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_31_d",
		response = "cryptic_b_adamant_bonding_conversation_31_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_31_c",
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
				"cryptic_b_adamant_bonding_conversation_31_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_32_a",
		response = "cryptic_b_adamant_bonding_conversation_32_a",
		wwise_route = 0,
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
					"loc_adamant_female_c__combat_pause_one_liner_a_02",
					"loc_adamant_female_c__combat_pause_one_liner_a_05",
					"loc_adamant_female_c__combat_pause_one_liner_a_08",
					"loc_adamant_female_c__combat_pause_one_liner_a_09",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_32_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_32_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_32_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_32_b",
		response = "cryptic_b_adamant_bonding_conversation_32_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_32_a",
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
				"cryptic_b_adamant_bonding_conversation_32_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_32_c",
		response = "cryptic_b_adamant_bonding_conversation_32_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_32_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_32_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_32_d",
		response = "cryptic_b_adamant_bonding_conversation_32_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_32_c",
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
				"cryptic_b_adamant_bonding_conversation_32_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_33_a",
		response = "cryptic_b_adamant_bonding_conversation_33_a",
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
					"cryptic_b",
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
				"cryptic_b_adamant_bonding_conversation_33_a",
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
				"cryptic_b_adamant_bonding_conversation_33_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_33_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_33_b",
		response = "cryptic_b_adamant_bonding_conversation_33_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_33_a",
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
				"cryptic_b_adamant_bonding_conversation_33_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_33_c",
		response = "cryptic_b_adamant_bonding_conversation_33_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_33_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_33_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_33_d",
		response = "cryptic_b_adamant_bonding_conversation_33_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_33_c",
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
				"cryptic_b_adamant_bonding_conversation_33_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_34_a",
		response = "cryptic_b_adamant_bonding_conversation_34_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_34_a",
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
				"cryptic_b_adamant_bonding_conversation_34_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_34_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_34_b",
		response = "cryptic_b_adamant_bonding_conversation_34_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_34_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_34_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_34_c",
		response = "cryptic_b_adamant_bonding_conversation_34_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_34_b",
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
				"cryptic_b_adamant_bonding_conversation_34_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_34_d",
		response = "cryptic_b_adamant_bonding_conversation_34_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_34_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_34_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_35_a",
		response = "cryptic_b_adamant_bonding_conversation_35_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_35_a",
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
				"cryptic_b_adamant_bonding_conversation_35_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_35_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_35_b",
		response = "cryptic_b_adamant_bonding_conversation_35_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_35_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_35_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_35_c",
		response = "cryptic_b_adamant_bonding_conversation_35_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_35_b",
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
				"cryptic_b_adamant_bonding_conversation_35_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_35_d",
		response = "cryptic_b_adamant_bonding_conversation_35_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_35_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_35_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_36_a",
		response = "cryptic_b_adamant_bonding_conversation_36_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_36_a",
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
				"cryptic_b_adamant_bonding_conversation_36_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_adamant_bonding_conversation_36_a",
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
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_36_b",
		response = "cryptic_b_adamant_bonding_conversation_36_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_36_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_36_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_36_c",
		response = "cryptic_b_adamant_bonding_conversation_36_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_36_b",
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
				"cryptic_b_adamant_bonding_conversation_36_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_adamant_bonding_conversation_36_d",
		response = "cryptic_b_adamant_bonding_conversation_36_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_adamant_bonding_conversation_36_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_adamant_bonding_conversation_36_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_01_a",
		response = "cryptic_b_broker_bonding_conversation_01_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_male_a",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_01_a",
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
				"cryptic_b_broker_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_01_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_01_b",
		response = "cryptic_b_broker_bonding_conversation_01_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_01_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_01_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_01_c",
		response = "cryptic_b_broker_bonding_conversation_01_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_01_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_01_d",
		response = "cryptic_b_broker_bonding_conversation_01_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_01_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_a",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_01_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_02_a",
		response = "cryptic_b_broker_bonding_conversation_02_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_male_a",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_02_a",
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
				"cryptic_b_broker_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_02_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_02_b",
		response = "cryptic_b_broker_bonding_conversation_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_02_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_02_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_02_c",
		response = "cryptic_b_broker_bonding_conversation_02_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_02_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_02_d",
		response = "cryptic_b_broker_bonding_conversation_02_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_02_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_a",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_02_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_03_a",
		response = "cryptic_b_broker_bonding_conversation_03_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"broker_male_a",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_03_a",
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
				"cryptic_b_broker_bonding_conversation_03_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_03_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_03_b",
		response = "cryptic_b_broker_bonding_conversation_03_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_03_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_03_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_03_c",
		response = "cryptic_b_broker_bonding_conversation_03_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_03_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_03_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_03_d",
		response = "cryptic_b_broker_bonding_conversation_03_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_03_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_a",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_03_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_04_a",
		response = "cryptic_b_broker_bonding_conversation_04_a",
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
					"broker_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_04_a",
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
				"cryptic_b_broker_bonding_conversation_04_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_04_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_04_b",
		response = "cryptic_b_broker_bonding_conversation_04_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_04_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_04_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_04_c",
		response = "cryptic_b_broker_bonding_conversation_04_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_04_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_a",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_04_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_04_d",
		response = "cryptic_b_broker_bonding_conversation_04_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_04_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_04_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_05_a",
		response = "cryptic_b_broker_bonding_conversation_05_a",
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
					"broker_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_05_a",
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
				"cryptic_b_broker_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_05_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_05_b",
		response = "cryptic_b_broker_bonding_conversation_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_05_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_05_c",
		response = "cryptic_b_broker_bonding_conversation_05_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_05_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_a",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_05_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_05_d",
		response = "cryptic_b_broker_bonding_conversation_05_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_05_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_06_a",
		response = "cryptic_b_broker_bonding_conversation_06_a",
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
					"broker_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_06_a",
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
				"cryptic_b_broker_bonding_conversation_06_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_06_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_06_b",
		response = "cryptic_b_broker_bonding_conversation_06_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_06_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_06_c",
		response = "cryptic_b_broker_bonding_conversation_06_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_06_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"broker_male_a",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_06_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_06_d",
		response = "cryptic_b_broker_bonding_conversation_06_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_06_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_06_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_07_a",
		response = "cryptic_b_broker_bonding_conversation_07_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_07_a",
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
				"cryptic_b_broker_bonding_conversation_07_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_07_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_07_b",
		response = "cryptic_b_broker_bonding_conversation_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_07_a",
				},
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
				"cryptic_b_broker_bonding_conversation_07_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_07_c",
		response = "cryptic_b_broker_bonding_conversation_07_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_07_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_07_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_07_d",
		response = "cryptic_b_broker_bonding_conversation_07_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_07_c",
				},
			},
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
				"cryptic_b_broker_bonding_conversation_07_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_08_a",
		response = "cryptic_b_broker_bonding_conversation_08_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_08_a",
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
				"cryptic_b_broker_bonding_conversation_08_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_08_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_08_b",
		response = "cryptic_b_broker_bonding_conversation_08_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_08_a",
				},
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
				"cryptic_b_broker_bonding_conversation_08_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_08_c",
		response = "cryptic_b_broker_bonding_conversation_08_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_08_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_08_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_08_d",
		response = "cryptic_b_broker_bonding_conversation_08_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_08_c",
				},
			},
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
				"cryptic_b_broker_bonding_conversation_08_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_09_a",
		response = "cryptic_b_broker_bonding_conversation_09_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_09_a",
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
				"cryptic_b_broker_bonding_conversation_09_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_09_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_09_b",
		response = "cryptic_b_broker_bonding_conversation_09_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_09_a",
				},
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
				"cryptic_b_broker_bonding_conversation_09_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_09_c",
		response = "cryptic_b_broker_bonding_conversation_09_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_09_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_09_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_09_d",
		response = "cryptic_b_broker_bonding_conversation_09_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_09_c",
				},
			},
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
				"cryptic_b_broker_bonding_conversation_09_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_10_a",
		response = "cryptic_b_broker_bonding_conversation_10_a",
		wwise_route = 0,
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
					"loc_cryptic_b__combat_pause_limited_broker_a_05_b_01",
					"loc_cryptic_b__combat_pause_quirk_broker_a_trait_03_b_01",
					"loc_cryptic_b__combat_pause_quirk_broker_a_trait_05_b_01",
					"loc_cryptic_b__combat_pause_quirk_broker_a_trait_09_b_01",
				},
			},
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
				"cryptic_b_broker_bonding_conversation_10_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_10_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_10_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_10_b",
		response = "cryptic_b_broker_bonding_conversation_10_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_10_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_10_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_10_c",
		response = "cryptic_b_broker_bonding_conversation_10_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_10_b",
				},
			},
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
				"cryptic_b_broker_bonding_conversation_10_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_10_d",
		response = "cryptic_b_broker_bonding_conversation_10_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_10_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_10_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_11_a",
		response = "cryptic_b_broker_bonding_conversation_11_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_11_a",
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
				"cryptic_b_broker_bonding_conversation_11_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_11_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_11_b",
		response = "cryptic_b_broker_bonding_conversation_11_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_11_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_11_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_11_c",
		response = "cryptic_b_broker_bonding_conversation_11_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_11_b",
				},
			},
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
				"cryptic_b_broker_bonding_conversation_11_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_11_d",
		response = "cryptic_b_broker_bonding_conversation_11_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_11_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_11_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_12_a",
		response = "cryptic_b_broker_bonding_conversation_12_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_12_a",
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
				"cryptic_b_broker_bonding_conversation_12_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_12_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_12_b",
		response = "cryptic_b_broker_bonding_conversation_12_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_12_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_12_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_12_c",
		response = "cryptic_b_broker_bonding_conversation_12_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_12_b",
				},
			},
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
				"cryptic_b_broker_bonding_conversation_12_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_12_d",
		response = "cryptic_b_broker_bonding_conversation_12_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_12_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_12_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_13_a",
		response = "cryptic_b_broker_bonding_conversation_13_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_13_a",
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
				"cryptic_b_broker_bonding_conversation_13_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_13_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_13_b",
		response = "cryptic_b_broker_bonding_conversation_13_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_13_a",
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
				"cryptic_b_broker_bonding_conversation_13_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_13_c",
		response = "cryptic_b_broker_bonding_conversation_13_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_13_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_13_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_13_d",
		response = "cryptic_b_broker_bonding_conversation_13_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_13_c",
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
				"cryptic_b_broker_bonding_conversation_13_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_14_a",
		response = "cryptic_b_broker_bonding_conversation_14_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_14_a",
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
				"cryptic_b_broker_bonding_conversation_14_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_14_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_14_b",
		response = "cryptic_b_broker_bonding_conversation_14_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_14_a",
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
				"cryptic_b_broker_bonding_conversation_14_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_14_c",
		response = "cryptic_b_broker_bonding_conversation_14_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_14_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_14_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_14_d",
		response = "cryptic_b_broker_bonding_conversation_14_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_14_c",
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
				"cryptic_b_broker_bonding_conversation_14_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_15_a",
		response = "cryptic_b_broker_bonding_conversation_15_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_15_a",
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
				"cryptic_b_broker_bonding_conversation_15_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_15_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_15_b",
		response = "cryptic_b_broker_bonding_conversation_15_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_15_a",
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
				"cryptic_b_broker_bonding_conversation_15_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_15_c",
		response = "cryptic_b_broker_bonding_conversation_15_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_15_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_15_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_15_d",
		response = "cryptic_b_broker_bonding_conversation_15_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_15_c",
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
				"cryptic_b_broker_bonding_conversation_15_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_16_a",
		response = "cryptic_b_broker_bonding_conversation_16_a",
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
				300,
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_16_a",
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
				"cryptic_b_broker_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_16_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_16_b",
		response = "cryptic_b_broker_bonding_conversation_16_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_16_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_16_c",
		response = "cryptic_b_broker_bonding_conversation_16_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_16_b",
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
				"cryptic_b_broker_bonding_conversation_16_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_16_d",
		response = "cryptic_b_broker_bonding_conversation_16_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_16_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_17_a",
		response = "cryptic_b_broker_bonding_conversation_17_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_17_a",
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
				"cryptic_b_broker_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_17_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_17_b",
		response = "cryptic_b_broker_bonding_conversation_17_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_17_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_17_c",
		response = "cryptic_b_broker_bonding_conversation_17_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_17_b",
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
				"cryptic_b_broker_bonding_conversation_17_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_17_d",
		response = "cryptic_b_broker_bonding_conversation_17_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_17_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_18_a",
		response = "cryptic_b_broker_bonding_conversation_18_a",
		wwise_route = 0,
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
					"loc_cryptic_b__combat_pause_one_liner_05",
					"loc_cryptic_b__combat_pause_quirk_broker_b_trait_02_b_01",
					"loc_cryptic_b__combat_pause_quirk_broker_b_trait_03_b_01",
					"loc_cryptic_b__combat_pause_quirk_broker_b_trait_09_b_01",
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
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_18_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_18_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_18_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_18_b",
		response = "cryptic_b_broker_bonding_conversation_18_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_18_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_18_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_18_c",
		response = "cryptic_b_broker_bonding_conversation_18_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_18_b",
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
				"cryptic_b_broker_bonding_conversation_18_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_18_d",
		response = "cryptic_b_broker_bonding_conversation_18_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_18_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_18_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_19_a",
		response = "cryptic_b_broker_bonding_conversation_19_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_19_a",
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
				"cryptic_b_broker_bonding_conversation_19_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_19_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_19_b",
		response = "cryptic_b_broker_bonding_conversation_19_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_19_a",
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
				"cryptic_b_broker_bonding_conversation_19_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_19_c",
		response = "cryptic_b_broker_bonding_conversation_19_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_19_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_19_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_19_d",
		response = "cryptic_b_broker_bonding_conversation_19_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_19_c",
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
				"cryptic_b_broker_bonding_conversation_19_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_20_a",
		response = "cryptic_b_broker_bonding_conversation_20_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_20_a",
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
				"cryptic_b_broker_bonding_conversation_20_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_20_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_20_b",
		response = "cryptic_b_broker_bonding_conversation_20_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_20_a",
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
				"cryptic_b_broker_bonding_conversation_20_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_20_c",
		response = "cryptic_b_broker_bonding_conversation_20_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_20_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_20_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_20_d",
		response = "cryptic_b_broker_bonding_conversation_20_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_20_c",
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
				"cryptic_b_broker_bonding_conversation_20_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_21_a",
		response = "cryptic_b_broker_bonding_conversation_21_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_21_a",
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
				"cryptic_b_broker_bonding_conversation_21_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_21_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_21_b",
		response = "cryptic_b_broker_bonding_conversation_21_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_21_a",
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
				"cryptic_b_broker_bonding_conversation_21_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_21_c",
		response = "cryptic_b_broker_bonding_conversation_21_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_21_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_21_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_21_d",
		response = "cryptic_b_broker_bonding_conversation_21_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_21_c",
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
				"cryptic_b_broker_bonding_conversation_21_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_22_a",
		response = "cryptic_b_broker_bonding_conversation_22_a",
		wwise_route = 0,
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
					"loc_cryptic_b__combat_pause_one_liner_02",
					"loc_cryptic_b__combat_pause_one_liner_04",
					"loc_cryptic_b__combat_pause_quirk_broker_b_trait_03_b_01",
					"loc_cryptic_b__combat_pause_quirk_broker_b_trait_08_b_01",
					"",
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
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_22_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_22_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_22_b",
		response = "cryptic_b_broker_bonding_conversation_22_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_22_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_22_c",
		response = "cryptic_b_broker_bonding_conversation_22_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_22_b",
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
				"cryptic_b_broker_bonding_conversation_22_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_22_d",
		response = "cryptic_b_broker_bonding_conversation_22_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_22_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_23_a",
		response = "cryptic_b_broker_bonding_conversation_23_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_23_a",
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
				"cryptic_b_broker_bonding_conversation_23_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_23_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_23_b",
		response = "cryptic_b_broker_bonding_conversation_23_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_23_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_23_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_23_c",
		response = "cryptic_b_broker_bonding_conversation_23_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_23_b",
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
				"cryptic_b_broker_bonding_conversation_23_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_23_d",
		response = "cryptic_b_broker_bonding_conversation_23_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_23_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_23_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_24_a",
		response = "cryptic_b_broker_bonding_conversation_24_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_24_a",
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
				"cryptic_b_broker_bonding_conversation_24_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_24_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_24_b",
		response = "cryptic_b_broker_bonding_conversation_24_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_24_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_24_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_24_c",
		response = "cryptic_b_broker_bonding_conversation_24_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_24_b",
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
				"cryptic_b_broker_bonding_conversation_24_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_24_d",
		response = "cryptic_b_broker_bonding_conversation_24_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_24_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_24_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_26_a",
		response = "cryptic_b_broker_bonding_conversation_26_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_26_a",
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
				"cryptic_b_broker_bonding_conversation_26_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_26_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_26_b",
		response = "cryptic_b_broker_bonding_conversation_26_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_26_a",
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
				"cryptic_b_broker_bonding_conversation_26_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_26_c",
		response = "cryptic_b_broker_bonding_conversation_26_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_26_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_26_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_26_d",
		response = "cryptic_b_broker_bonding_conversation_26_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_26_c",
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
				"cryptic_b_broker_bonding_conversation_26_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_27_a",
		response = "cryptic_b_broker_bonding_conversation_27_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_27_a",
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
				"cryptic_b_broker_bonding_conversation_27_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_27_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_27_b",
		response = "cryptic_b_broker_bonding_conversation_27_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_27_a",
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
				"cryptic_b_broker_bonding_conversation_27_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_27_c",
		response = "cryptic_b_broker_bonding_conversation_27_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_27_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_27_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_27_d",
		response = "cryptic_b_broker_bonding_conversation_27_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_27_c",
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
				"cryptic_b_broker_bonding_conversation_27_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_28_a",
		response = "cryptic_b_broker_bonding_conversation_28_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_28_a",
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
				"cryptic_b_broker_bonding_conversation_28_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_28_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_28_b",
		response = "cryptic_b_broker_bonding_conversation_28_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_28_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_28_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_28_c",
		response = "cryptic_b_broker_bonding_conversation_28_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_28_b",
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
				"cryptic_b_broker_bonding_conversation_28_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_28_d",
		response = "cryptic_b_broker_bonding_conversation_28_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_28_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_28_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_29_a",
		response = "cryptic_b_broker_bonding_conversation_29_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_29_a",
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
				"cryptic_b_broker_bonding_conversation_29_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_29_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_29_b",
		response = "cryptic_b_broker_bonding_conversation_29_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_29_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_29_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_29_c",
		response = "cryptic_b_broker_bonding_conversation_29_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_29_b",
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
				"cryptic_b_broker_bonding_conversation_29_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_29_d",
		response = "cryptic_b_broker_bonding_conversation_29_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_29_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_29_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_30_a",
		response = "cryptic_b_broker_bonding_conversation_30_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_30_a",
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
				"cryptic_b_broker_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_30_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_30_b",
		response = "cryptic_b_broker_bonding_conversation_30_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_30_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_30_c",
		response = "cryptic_b_broker_bonding_conversation_30_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_30_b",
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
				"cryptic_b_broker_bonding_conversation_30_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_30_d",
		response = "cryptic_b_broker_bonding_conversation_30_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_30_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_32_a",
		response = "cryptic_b_broker_bonding_conversation_32_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_32_a",
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
				"cryptic_b_broker_bonding_conversation_32_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_32_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_32_b",
		response = "cryptic_b_broker_bonding_conversation_32_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_32_a",
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
				"cryptic_b_broker_bonding_conversation_32_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_32_c",
		response = "cryptic_b_broker_bonding_conversation_32_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_32_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_32_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_32_d",
		response = "cryptic_b_broker_bonding_conversation_32_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_32_c",
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
				"cryptic_b_broker_bonding_conversation_32_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_33_a",
		response = "cryptic_b_broker_bonding_conversation_33_a",
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
					"cryptic_b",
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
				"cryptic_b_broker_bonding_conversation_33_a",
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
				"cryptic_b_broker_bonding_conversation_33_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_33_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_33_b",
		response = "cryptic_b_broker_bonding_conversation_33_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_33_a",
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
				"cryptic_b_broker_bonding_conversation_33_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_33_c",
		response = "cryptic_b_broker_bonding_conversation_33_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_33_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_33_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_33_d",
		response = "cryptic_b_broker_bonding_conversation_33_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_33_c",
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
				"cryptic_b_broker_bonding_conversation_33_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_34_a",
		response = "cryptic_b_broker_bonding_conversation_34_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_34_a",
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
				"cryptic_b_broker_bonding_conversation_34_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_34_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_34_b",
		response = "cryptic_b_broker_bonding_conversation_34_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_34_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_34_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_34_c",
		response = "cryptic_b_broker_bonding_conversation_34_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_34_b",
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
				"cryptic_b_broker_bonding_conversation_34_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_34_d",
		response = "cryptic_b_broker_bonding_conversation_34_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_34_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_34_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_35_a",
		response = "cryptic_b_broker_bonding_conversation_35_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_35_a",
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
				"cryptic_b_broker_bonding_conversation_35_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_35_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_35_b",
		response = "cryptic_b_broker_bonding_conversation_35_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_35_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_35_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_35_c",
		response = "cryptic_b_broker_bonding_conversation_35_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_35_b",
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
				"cryptic_b_broker_bonding_conversation_35_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_35_d",
		response = "cryptic_b_broker_bonding_conversation_35_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_35_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_35_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_36_a",
		response = "cryptic_b_broker_bonding_conversation_36_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_36_a",
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
				"cryptic_b_broker_bonding_conversation_36_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_broker_bonding_conversation_36_a",
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
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_36_b",
		response = "cryptic_b_broker_bonding_conversation_36_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_36_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_36_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_36_c",
		response = "cryptic_b_broker_bonding_conversation_36_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_36_b",
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
				"cryptic_b_broker_bonding_conversation_36_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_broker_bonding_conversation_36_d",
		response = "cryptic_b_broker_bonding_conversation_36_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_broker_bonding_conversation_36_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_broker_bonding_conversation_36_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_01_a",
		response = "cryptic_b_ogryn_bonding_conversation_01_a",
		wwise_route = 0,
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
					"loc_ogryn_a__combat_pause_one_liner_02",
					"loc_ogryn_a__combat_pause_one_liner_05",
					"loc_ogryn_a__combat_pause_one_liner_06",
					"loc_ogryn_a__combat_pause_one_liner_07",
					"",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_01_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_01_b",
		response = "cryptic_b_ogryn_bonding_conversation_01_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_01_a",
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
				"cryptic_b_ogryn_bonding_conversation_01_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_01_c",
		response = "cryptic_b_ogryn_bonding_conversation_01_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_01_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_01_d",
		response = "cryptic_b_ogryn_bonding_conversation_01_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_01_c",
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
				"cryptic_b_ogryn_bonding_conversation_01_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_02_a",
		response = "cryptic_b_ogryn_bonding_conversation_02_a",
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
					"cryptic_b",
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
				"cryptic_b_ogryn_bonding_conversation_02_a",
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
				"cryptic_b_ogryn_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_02_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_02_b",
		response = "cryptic_b_ogryn_bonding_conversation_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_02_a",
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
				"cryptic_b_ogryn_bonding_conversation_02_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_02_c",
		response = "cryptic_b_ogryn_bonding_conversation_02_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_02_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_02_d",
		response = "cryptic_b_ogryn_bonding_conversation_02_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_02_c",
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
				"cryptic_b_ogryn_bonding_conversation_02_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_03_a",
		response = "cryptic_b_ogryn_bonding_conversation_03_a",
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
					"cryptic_b",
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
				"cryptic_b_ogryn_bonding_conversation_03_a",
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
				"cryptic_b_ogryn_bonding_conversation_03_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_03_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_03_b",
		response = "cryptic_b_ogryn_bonding_conversation_03_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_03_a",
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
				"cryptic_b_ogryn_bonding_conversation_03_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_03_c",
		response = "cryptic_b_ogryn_bonding_conversation_03_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_03_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_03_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_03_d",
		response = "cryptic_b_ogryn_bonding_conversation_03_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_03_c",
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
				"cryptic_b_ogryn_bonding_conversation_03_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_04_a",
		response = "cryptic_b_ogryn_bonding_conversation_04_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_04_a",
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
				"cryptic_b_ogryn_bonding_conversation_04_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_04_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_04_b",
		response = "cryptic_b_ogryn_bonding_conversation_04_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_04_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_04_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_04_c",
		response = "cryptic_b_ogryn_bonding_conversation_04_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_04_b",
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
				"cryptic_b_ogryn_bonding_conversation_04_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_04_d",
		response = "cryptic_b_ogryn_bonding_conversation_04_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_04_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_04_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_05_a",
		response = "cryptic_b_ogryn_bonding_conversation_05_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_05_a",
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
				"cryptic_b_ogryn_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_05_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_05_b",
		response = "cryptic_b_ogryn_bonding_conversation_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_05_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_05_c",
		response = "cryptic_b_ogryn_bonding_conversation_05_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_05_b",
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
				"cryptic_b_ogryn_bonding_conversation_05_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_05_d",
		response = "cryptic_b_ogryn_bonding_conversation_05_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_05_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_06_a",
		response = "cryptic_b_ogryn_bonding_conversation_06_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_06_a",
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
				"cryptic_b_ogryn_bonding_conversation_06_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_06_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_06_b",
		response = "cryptic_b_ogryn_bonding_conversation_06_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_06_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_06_c",
		response = "cryptic_b_ogryn_bonding_conversation_06_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_06_b",
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
				"cryptic_b_ogryn_bonding_conversation_06_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_06_d",
		response = "cryptic_b_ogryn_bonding_conversation_06_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_06_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_06_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_07_a",
		response = "cryptic_b_ogryn_bonding_conversation_07_a",
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
					"cryptic_b",
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
				"cryptic_b_ogryn_bonding_conversation_07_a",
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
				"cryptic_b_ogryn_bonding_conversation_07_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_07_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_07_b",
		response = "cryptic_b_ogryn_bonding_conversation_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_07_a",
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
				"cryptic_b_ogryn_bonding_conversation_07_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_07_c",
		response = "cryptic_b_ogryn_bonding_conversation_07_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_07_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_07_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_07_d",
		response = "cryptic_b_ogryn_bonding_conversation_07_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_07_c",
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
				"cryptic_b_ogryn_bonding_conversation_07_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_08_a",
		response = "cryptic_b_ogryn_bonding_conversation_08_a",
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
					"cryptic_b",
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
				"cryptic_b_ogryn_bonding_conversation_08_a",
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
				"cryptic_b_ogryn_bonding_conversation_08_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_08_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_08_b",
		response = "cryptic_b_ogryn_bonding_conversation_08_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_08_a",
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
				"cryptic_b_ogryn_bonding_conversation_08_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_08_c",
		response = "cryptic_b_ogryn_bonding_conversation_08_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_08_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_08_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_08_d",
		response = "cryptic_b_ogryn_bonding_conversation_08_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_08_c",
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
				"cryptic_b_ogryn_bonding_conversation_08_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_09_a",
		response = "cryptic_b_ogryn_bonding_conversation_09_a",
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
					"cryptic_b",
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
				"cryptic_b_ogryn_bonding_conversation_09_a",
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
				"cryptic_b_ogryn_bonding_conversation_09_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_09_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_09_b",
		response = "cryptic_b_ogryn_bonding_conversation_09_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_09_a",
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
				"cryptic_b_ogryn_bonding_conversation_09_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_09_c",
		response = "cryptic_b_ogryn_bonding_conversation_09_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_09_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_09_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_09_d",
		response = "cryptic_b_ogryn_bonding_conversation_09_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_09_c",
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
				"cryptic_b_ogryn_bonding_conversation_09_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_10_a",
		response = "cryptic_b_ogryn_bonding_conversation_10_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_10_a",
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
				"cryptic_b_ogryn_bonding_conversation_10_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_10_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_10_b",
		response = "cryptic_b_ogryn_bonding_conversation_10_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_10_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_10_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_10_c",
		response = "cryptic_b_ogryn_bonding_conversation_10_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_10_b",
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
				"cryptic_b_ogryn_bonding_conversation_10_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_10_d",
		response = "cryptic_b_ogryn_bonding_conversation_10_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_10_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_10_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_11_a",
		response = "cryptic_b_ogryn_bonding_conversation_11_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_11_a",
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
				"cryptic_b_ogryn_bonding_conversation_11_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_11_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_11_b",
		response = "cryptic_b_ogryn_bonding_conversation_11_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_11_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_11_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_11_c",
		response = "cryptic_b_ogryn_bonding_conversation_11_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_11_b",
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
				"cryptic_b_ogryn_bonding_conversation_11_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_11_d",
		response = "cryptic_b_ogryn_bonding_conversation_11_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_11_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_11_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_12_a",
		response = "cryptic_b_ogryn_bonding_conversation_12_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_12_a",
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
				"cryptic_b_ogryn_bonding_conversation_12_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_12_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_12_b",
		response = "cryptic_b_ogryn_bonding_conversation_12_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_12_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_12_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_12_c",
		response = "cryptic_b_ogryn_bonding_conversation_12_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_12_b",
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
				"cryptic_b_ogryn_bonding_conversation_12_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_12_d",
		response = "cryptic_b_ogryn_bonding_conversation_12_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_12_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_12_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_13_a",
		response = "cryptic_b_ogryn_bonding_conversation_13_a",
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
					"cryptic_b",
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
				"cryptic_b_ogryn_bonding_conversation_13_a",
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
				"cryptic_b_ogryn_bonding_conversation_13_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_13_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_13_b",
		response = "cryptic_b_ogryn_bonding_conversation_13_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_13_a",
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
				"cryptic_b_ogryn_bonding_conversation_13_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_13_c",
		response = "cryptic_b_ogryn_bonding_conversation_13_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_13_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_13_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_13_d",
		response = "cryptic_b_ogryn_bonding_conversation_13_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_13_c",
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
				"cryptic_b_ogryn_bonding_conversation_13_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_14_a",
		response = "cryptic_b_ogryn_bonding_conversation_14_a",
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
					"cryptic_b",
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
				"cryptic_b_ogryn_bonding_conversation_14_a",
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
				"cryptic_b_ogryn_bonding_conversation_14_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_14_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_14_b",
		response = "cryptic_b_ogryn_bonding_conversation_14_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_14_a",
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
				"cryptic_b_ogryn_bonding_conversation_14_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_14_c",
		response = "cryptic_b_ogryn_bonding_conversation_14_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_14_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_14_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_14_d",
		response = "cryptic_b_ogryn_bonding_conversation_14_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_14_c",
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
				"cryptic_b_ogryn_bonding_conversation_14_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_15_a",
		response = "cryptic_b_ogryn_bonding_conversation_15_a",
		wwise_route = 0,
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
					"loc_ogryn_c__away_from_squad_01",
					"loc_ogryn_c__away_from_squad_02",
					"loc_ogryn_c__away_from_squad_03",
					"loc_ogryn_c__away_from_squad_04",
					"loc_ogryn_c__away_from_squad_05",
					"loc_ogryn_c__away_from_squad_06",
					"loc_ogryn_c__away_from_squad_07",
					"loc_ogryn_c__away_from_squad_08",
					"loc_ogryn_c__away_from_squad_09",
					"loc_ogryn_c__away_from_squad_10",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_15_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_15_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_15_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_15_b",
		response = "cryptic_b_ogryn_bonding_conversation_15_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_15_a",
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
				"cryptic_b_ogryn_bonding_conversation_15_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_15_c",
		response = "cryptic_b_ogryn_bonding_conversation_15_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_15_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_15_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_15_d",
		response = "cryptic_b_ogryn_bonding_conversation_15_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_15_c",
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
				"cryptic_b_ogryn_bonding_conversation_15_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_16_a",
		response = "cryptic_b_ogryn_bonding_conversation_16_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_16_a",
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
				"cryptic_b_ogryn_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_16_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_16_b",
		response = "cryptic_b_ogryn_bonding_conversation_16_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_16_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_16_c",
		response = "cryptic_b_ogryn_bonding_conversation_16_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_16_b",
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
				"cryptic_b_ogryn_bonding_conversation_16_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_16_d",
		response = "cryptic_b_ogryn_bonding_conversation_16_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_16_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_17_a",
		response = "cryptic_b_ogryn_bonding_conversation_17_a",
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
					"ogryn_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_17_a",
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
				"cryptic_b_ogryn_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_17_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_17_b",
		response = "cryptic_b_ogryn_bonding_conversation_17_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_17_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_17_c",
		response = "cryptic_b_ogryn_bonding_conversation_17_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_17_b",
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
				"cryptic_b_ogryn_bonding_conversation_17_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_17_d",
		response = "cryptic_b_ogryn_bonding_conversation_17_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_17_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_18_a",
		response = "cryptic_b_ogryn_bonding_conversation_18_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_18_a",
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
				"cryptic_b_ogryn_bonding_conversation_18_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_18_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_18_b",
		response = "cryptic_b_ogryn_bonding_conversation_18_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_18_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_18_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_18_c",
		response = "cryptic_b_ogryn_bonding_conversation_18_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_18_b",
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
				"cryptic_b_ogryn_bonding_conversation_18_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_18_d",
		response = "cryptic_b_ogryn_bonding_conversation_18_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_18_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_18_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_19_a",
		response = "cryptic_b_ogryn_bonding_conversation_19_a",
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
					"cryptic_b",
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
				"cryptic_b_ogryn_bonding_conversation_19_a",
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
				"cryptic_b_ogryn_bonding_conversation_19_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_19_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_19_b",
		response = "cryptic_b_ogryn_bonding_conversation_19_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_19_a",
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
				"cryptic_b_ogryn_bonding_conversation_19_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_19_c",
		response = "cryptic_b_ogryn_bonding_conversation_19_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_19_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_19_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_19_d",
		response = "cryptic_b_ogryn_bonding_conversation_19_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_19_c",
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
				"cryptic_b_ogryn_bonding_conversation_19_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_20_a",
		response = "cryptic_b_ogryn_bonding_conversation_20_a",
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
					"cryptic_b",
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
				"cryptic_b_ogryn_bonding_conversation_20_a",
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
				"cryptic_b_ogryn_bonding_conversation_20_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_20_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_20_b",
		response = "cryptic_b_ogryn_bonding_conversation_20_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_20_a",
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
				"cryptic_b_ogryn_bonding_conversation_20_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_20_c",
		response = "cryptic_b_ogryn_bonding_conversation_20_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_20_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_20_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_20_d",
		response = "cryptic_b_ogryn_bonding_conversation_20_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_20_c",
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
				"cryptic_b_ogryn_bonding_conversation_20_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_21_a",
		response = "cryptic_b_ogryn_bonding_conversation_21_a",
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
					"cryptic_b",
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
				"cryptic_b_ogryn_bonding_conversation_21_a",
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
				"cryptic_b_ogryn_bonding_conversation_21_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_21_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_21_b",
		response = "cryptic_b_ogryn_bonding_conversation_21_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_21_a",
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
				"cryptic_b_ogryn_bonding_conversation_21_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_21_c",
		response = "cryptic_b_ogryn_bonding_conversation_21_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_21_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_21_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_21_d",
		response = "cryptic_b_ogryn_bonding_conversation_21_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_21_c",
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
				"cryptic_b_ogryn_bonding_conversation_21_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_22_a",
		response = "cryptic_b_ogryn_bonding_conversation_22_a",
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
					"ogryn_d",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_22_a",
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
				"cryptic_b_ogryn_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_22_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_22_b",
		response = "cryptic_b_ogryn_bonding_conversation_22_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_22_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_22_c",
		response = "cryptic_b_ogryn_bonding_conversation_22_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_22_b",
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
				"cryptic_b_ogryn_bonding_conversation_22_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_22_d",
		response = "cryptic_b_ogryn_bonding_conversation_22_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_22_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_23_a",
		response = "cryptic_b_ogryn_bonding_conversation_23_a",
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
					"ogryn_d",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_23_a",
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
				"cryptic_b_ogryn_bonding_conversation_23_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_23_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_23_b",
		response = "cryptic_b_ogryn_bonding_conversation_23_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_23_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_23_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_23_c",
		response = "cryptic_b_ogryn_bonding_conversation_23_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_23_b",
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
				"cryptic_b_ogryn_bonding_conversation_23_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_23_d",
		response = "cryptic_b_ogryn_bonding_conversation_23_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_23_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_23_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_24_a",
		response = "cryptic_b_ogryn_bonding_conversation_24_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_24_a",
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
				"cryptic_b_ogryn_bonding_conversation_24_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_ogryn_bonding_conversation_24_a",
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
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_24_b",
		response = "cryptic_b_ogryn_bonding_conversation_24_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_24_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_24_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_24_c",
		response = "cryptic_b_ogryn_bonding_conversation_24_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_24_b",
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
				"cryptic_b_ogryn_bonding_conversation_24_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_ogryn_bonding_conversation_24_d",
		response = "cryptic_b_ogryn_bonding_conversation_24_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_ogryn_bonding_conversation_24_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_ogryn_bonding_conversation_24_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_01_a",
		response = "cryptic_b_psyker_bonding_conversation_01_a",
		wwise_route = 0,
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
					"loc_psyker_male_a__combat_pause_quirk_ogryn_d_rebuild_b_01",
					"loc_psyker_male_a__combat_pause_quirk_ogryn_d_long_way_b_02",
					"loc_psyker_male_a__combat_pause_quirk_adamant_c_trait_09_b_02",
					"loc_psyker_male_a__combat_pause_quirk_broker_b_trait_03_b_01",
					"loc_psyker_male_a__combat_pause_quirk_broker_c_trait_03_b_01",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_01_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_01_b",
		response = "cryptic_b_psyker_bonding_conversation_01_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_01_a",
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
				"cryptic_b_psyker_bonding_conversation_01_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_01_c",
		response = "cryptic_b_psyker_bonding_conversation_01_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_01_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_01_d",
		response = "cryptic_b_psyker_bonding_conversation_01_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_01_c",
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
				"cryptic_b_psyker_bonding_conversation_01_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_02_a",
		response = "cryptic_b_psyker_bonding_conversation_02_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_02_a",
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
				"cryptic_b_psyker_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_02_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_02_b",
		response = "cryptic_b_psyker_bonding_conversation_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_02_a",
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
				"cryptic_b_psyker_bonding_conversation_02_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_02_c",
		response = "cryptic_b_psyker_bonding_conversation_02_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_02_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_02_d",
		response = "cryptic_b_psyker_bonding_conversation_02_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_02_c",
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
				"cryptic_b_psyker_bonding_conversation_02_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_03_a",
		response = "cryptic_b_psyker_bonding_conversation_03_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_03_a",
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
				"cryptic_b_psyker_bonding_conversation_03_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_03_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_03_b",
		response = "cryptic_b_psyker_bonding_conversation_03_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_03_a",
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
				"cryptic_b_psyker_bonding_conversation_03_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_03_c",
		response = "cryptic_b_psyker_bonding_conversation_03_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_03_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_03_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_03_d",
		response = "cryptic_b_psyker_bonding_conversation_03_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_03_c",
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
				"cryptic_b_psyker_bonding_conversation_03_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_04_a",
		response = "cryptic_b_psyker_bonding_conversation_04_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_04_a",
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
				"cryptic_b_psyker_bonding_conversation_04_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_04_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_04_b",
		response = "cryptic_b_psyker_bonding_conversation_04_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_04_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_04_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_04_c",
		response = "cryptic_b_psyker_bonding_conversation_04_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_04_b",
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
				"cryptic_b_psyker_bonding_conversation_04_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_04_d",
		response = "cryptic_b_psyker_bonding_conversation_04_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_04_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_04_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_05_a",
		response = "cryptic_b_psyker_bonding_conversation_05_a",
		wwise_route = 0,
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
					"loc_cryptic_b__combat_pause_quirk_broker_b_trait_10_b_01",
					"loc_cryptic_b__combat_pause_quirk_friends_b_01",
					"loc_cryptic_b__combat_pause_limited_cryptic_d_20_b_01",
					"loc_cryptic_b__combat_pause_limited_psyker_a_11_b_01",
					"loc_cryptic_b__combat_pause_limited_bolt_on_a_ogryn_a_02_b_01",
					"loc_cryptic_b__combat_pause_quirk_lonely_b_01",
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
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_05_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_05_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_05_b",
		response = "cryptic_b_psyker_bonding_conversation_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_05_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_05_c",
		response = "cryptic_b_psyker_bonding_conversation_05_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_05_b",
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
				"cryptic_b_psyker_bonding_conversation_05_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_05_d",
		response = "cryptic_b_psyker_bonding_conversation_05_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_05_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_06_a",
		response = "cryptic_b_psyker_bonding_conversation_06_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_06_a",
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
				"cryptic_b_psyker_bonding_conversation_06_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_06_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_06_b",
		response = "cryptic_b_psyker_bonding_conversation_06_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_06_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_06_c",
		response = "cryptic_b_psyker_bonding_conversation_06_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_06_b",
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
				"cryptic_b_psyker_bonding_conversation_06_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_06_d",
		response = "cryptic_b_psyker_bonding_conversation_06_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_06_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_06_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_07_a",
		response = "cryptic_b_psyker_bonding_conversation_07_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_07_a",
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
				"cryptic_b_psyker_bonding_conversation_07_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_07_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_07_b",
		response = "cryptic_b_psyker_bonding_conversation_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_07_a",
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
				"cryptic_b_psyker_bonding_conversation_07_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_07_c",
		response = "cryptic_b_psyker_bonding_conversation_07_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_07_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_07_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_07_d",
		response = "cryptic_b_psyker_bonding_conversation_07_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_07_c",
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
				"cryptic_b_psyker_bonding_conversation_07_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_08_a",
		response = "cryptic_b_psyker_bonding_conversation_08_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_08_a",
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
				"cryptic_b_psyker_bonding_conversation_08_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_08_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_08_b",
		response = "cryptic_b_psyker_bonding_conversation_08_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_08_a",
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
				"cryptic_b_psyker_bonding_conversation_08_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_08_c",
		response = "cryptic_b_psyker_bonding_conversation_08_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_08_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_08_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_08_d",
		response = "cryptic_b_psyker_bonding_conversation_08_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_08_c",
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
				"cryptic_b_psyker_bonding_conversation_08_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_09_a",
		response = "cryptic_b_psyker_bonding_conversation_09_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_09_a",
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
				"cryptic_b_psyker_bonding_conversation_09_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_09_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_09_b",
		response = "cryptic_b_psyker_bonding_conversation_09_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_09_a",
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
				"cryptic_b_psyker_bonding_conversation_09_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_09_c",
		response = "cryptic_b_psyker_bonding_conversation_09_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_09_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_09_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_09_d",
		response = "cryptic_b_psyker_bonding_conversation_09_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_09_c",
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
				"cryptic_b_psyker_bonding_conversation_09_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_10_a",
		response = "cryptic_b_psyker_bonding_conversation_10_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_10_a",
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
				"cryptic_b_psyker_bonding_conversation_10_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_10_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_10_b",
		response = "cryptic_b_psyker_bonding_conversation_10_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_10_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_10_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_10_c",
		response = "cryptic_b_psyker_bonding_conversation_10_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_10_b",
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
				"cryptic_b_psyker_bonding_conversation_10_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_10_d",
		response = "cryptic_b_psyker_bonding_conversation_10_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_10_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_10_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_11_a",
		response = "cryptic_b_psyker_bonding_conversation_11_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_11_a",
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
				"cryptic_b_psyker_bonding_conversation_11_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_11_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_11_b",
		response = "cryptic_b_psyker_bonding_conversation_11_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_11_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_11_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_11_c",
		response = "cryptic_b_psyker_bonding_conversation_11_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_11_b",
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
				"cryptic_b_psyker_bonding_conversation_11_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_11_d",
		response = "cryptic_b_psyker_bonding_conversation_11_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_11_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_11_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_12_a",
		response = "cryptic_b_psyker_bonding_conversation_12_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_12_a",
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
				"cryptic_b_psyker_bonding_conversation_12_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_12_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_12_b",
		response = "cryptic_b_psyker_bonding_conversation_12_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_12_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_12_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_12_c",
		response = "cryptic_b_psyker_bonding_conversation_12_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_12_b",
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
				"cryptic_b_psyker_bonding_conversation_12_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_12_d",
		response = "cryptic_b_psyker_bonding_conversation_12_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_12_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_12_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_13_a",
		response = "cryptic_b_psyker_bonding_conversation_13_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_13_a",
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
				"cryptic_b_psyker_bonding_conversation_13_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_13_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_13_b",
		response = "cryptic_b_psyker_bonding_conversation_13_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_13_a",
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
				"cryptic_b_psyker_bonding_conversation_13_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_13_c",
		response = "cryptic_b_psyker_bonding_conversation_13_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_13_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_13_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_13_d",
		response = "cryptic_b_psyker_bonding_conversation_13_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_13_c",
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
				"cryptic_b_psyker_bonding_conversation_13_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_14_a",
		response = "cryptic_b_psyker_bonding_conversation_14_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_14_a",
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
				"cryptic_b_psyker_bonding_conversation_14_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_14_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_14_b",
		response = "cryptic_b_psyker_bonding_conversation_14_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_14_a",
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
				"cryptic_b_psyker_bonding_conversation_14_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_14_c",
		response = "cryptic_b_psyker_bonding_conversation_14_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_14_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_14_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_14_d",
		response = "cryptic_b_psyker_bonding_conversation_14_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_14_c",
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
				"cryptic_b_psyker_bonding_conversation_14_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_15_a",
		response = "cryptic_b_psyker_bonding_conversation_15_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_15_a",
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
				"cryptic_b_psyker_bonding_conversation_15_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_15_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_15_b",
		response = "cryptic_b_psyker_bonding_conversation_15_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_15_a",
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
				"cryptic_b_psyker_bonding_conversation_15_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_15_c",
		response = "cryptic_b_psyker_bonding_conversation_15_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_15_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_15_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_15_d",
		response = "cryptic_b_psyker_bonding_conversation_15_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_15_c",
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
				"cryptic_b_psyker_bonding_conversation_15_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_16_a",
		response = "cryptic_b_psyker_bonding_conversation_16_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_16_a",
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
				"cryptic_b_psyker_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_16_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_16_b",
		response = "cryptic_b_psyker_bonding_conversation_16_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_16_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_16_c",
		response = "cryptic_b_psyker_bonding_conversation_16_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_16_b",
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
				"cryptic_b_psyker_bonding_conversation_16_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_16_d",
		response = "cryptic_b_psyker_bonding_conversation_16_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_16_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_17_a",
		response = "cryptic_b_psyker_bonding_conversation_17_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_17_a",
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
				"cryptic_b_psyker_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_17_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_17_b",
		response = "cryptic_b_psyker_bonding_conversation_17_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_17_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_17_c",
		response = "cryptic_b_psyker_bonding_conversation_17_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_17_b",
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
				"cryptic_b_psyker_bonding_conversation_17_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_17_d",
		response = "cryptic_b_psyker_bonding_conversation_17_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_17_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_18_a",
		response = "cryptic_b_psyker_bonding_conversation_18_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_18_a",
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
				"cryptic_b_psyker_bonding_conversation_18_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_18_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_18_b",
		response = "cryptic_b_psyker_bonding_conversation_18_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_18_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_18_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_18_c",
		response = "cryptic_b_psyker_bonding_conversation_18_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_18_b",
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
				"cryptic_b_psyker_bonding_conversation_18_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_18_d",
		response = "cryptic_b_psyker_bonding_conversation_18_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_18_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_18_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_19_a",
		response = "cryptic_b_psyker_bonding_conversation_19_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_19_a",
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
				"cryptic_b_psyker_bonding_conversation_19_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_19_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_19_b",
		response = "cryptic_b_psyker_bonding_conversation_19_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_19_a",
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
				"cryptic_b_psyker_bonding_conversation_19_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_19_c",
		response = "cryptic_b_psyker_bonding_conversation_19_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_19_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_19_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_19_d",
		response = "cryptic_b_psyker_bonding_conversation_19_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_19_c",
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
				"cryptic_b_psyker_bonding_conversation_19_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_20_a",
		response = "cryptic_b_psyker_bonding_conversation_20_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_20_a",
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
				"cryptic_b_psyker_bonding_conversation_20_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_20_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_20_b",
		response = "cryptic_b_psyker_bonding_conversation_20_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_20_a",
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
				"cryptic_b_psyker_bonding_conversation_20_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_20_c",
		response = "cryptic_b_psyker_bonding_conversation_20_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_20_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_20_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_20_d",
		response = "cryptic_b_psyker_bonding_conversation_20_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_20_c",
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
				"cryptic_b_psyker_bonding_conversation_20_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_21_a",
		response = "cryptic_b_psyker_bonding_conversation_21_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_21_a",
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
				"cryptic_b_psyker_bonding_conversation_21_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_21_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_21_b",
		response = "cryptic_b_psyker_bonding_conversation_21_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_21_a",
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
				"cryptic_b_psyker_bonding_conversation_21_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_21_c",
		response = "cryptic_b_psyker_bonding_conversation_21_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_21_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_21_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_21_d",
		response = "cryptic_b_psyker_bonding_conversation_21_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_21_c",
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
				"cryptic_b_psyker_bonding_conversation_21_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_22_a",
		response = "cryptic_b_psyker_bonding_conversation_22_a",
		wwise_route = 0,
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
					"loc_cryptic_b__combat_pause_one_liner_04",
					"loc_cryptic_b__combat_pause_limited_psyker_b_10_b_01",
					"loc_cryptic_b__combat_pause_limited_psyker_b_11_b_01",
					"loc_cryptic_b__combat_pause_limited_bolt_on_a_psyker_b_02_b_01",
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
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_22_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_22_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_22_b",
		response = "cryptic_b_psyker_bonding_conversation_22_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_22_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_22_c",
		response = "cryptic_b_psyker_bonding_conversation_22_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_22_b",
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
				"cryptic_b_psyker_bonding_conversation_22_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_22_d",
		response = "cryptic_b_psyker_bonding_conversation_22_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_22_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_23_a",
		response = "cryptic_b_psyker_bonding_conversation_23_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_23_a",
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
				"cryptic_b_psyker_bonding_conversation_23_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_23_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_23_b",
		response = "cryptic_b_psyker_bonding_conversation_23_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_23_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_23_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_23_c",
		response = "cryptic_b_psyker_bonding_conversation_23_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_23_b",
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
				"cryptic_b_psyker_bonding_conversation_23_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_23_d",
		response = "cryptic_b_psyker_bonding_conversation_23_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_23_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_23_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_24_a",
		response = "cryptic_b_psyker_bonding_conversation_24_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_24_a",
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
				"cryptic_b_psyker_bonding_conversation_24_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_24_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_24_b",
		response = "cryptic_b_psyker_bonding_conversation_24_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_24_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_24_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_24_c",
		response = "cryptic_b_psyker_bonding_conversation_24_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_24_b",
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
				"cryptic_b_psyker_bonding_conversation_24_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_24_d",
		response = "cryptic_b_psyker_bonding_conversation_24_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_24_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_24_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_25_a",
		response = "cryptic_b_psyker_bonding_conversation_25_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_25_a",
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
				"faction_memory",
				"cryptic_seen_killstreak_psyker",
				OP.TIMEDIFF,
				OP.LT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_25_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_25_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_25_b",
		response = "cryptic_b_psyker_bonding_conversation_25_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_25_a",
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
				"cryptic_b_psyker_bonding_conversation_25_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_25_c",
		response = "cryptic_b_psyker_bonding_conversation_25_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_25_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_25_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_25_d",
		response = "cryptic_b_psyker_bonding_conversation_25_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_25_c",
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
				"cryptic_b_psyker_bonding_conversation_25_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_26_a",
		response = "cryptic_b_psyker_bonding_conversation_26_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_26_a",
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
				"cryptic_b_psyker_bonding_conversation_26_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_26_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_26_b",
		response = "cryptic_b_psyker_bonding_conversation_26_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_26_a",
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
				"cryptic_b_psyker_bonding_conversation_26_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_26_c",
		response = "cryptic_b_psyker_bonding_conversation_26_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_26_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_26_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_26_d",
		response = "cryptic_b_psyker_bonding_conversation_26_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_26_c",
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
				"cryptic_b_psyker_bonding_conversation_26_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_27_a",
		response = "cryptic_b_psyker_bonding_conversation_27_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_27_a",
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
				"cryptic_b_psyker_bonding_conversation_27_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_27_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_27_b",
		response = "cryptic_b_psyker_bonding_conversation_27_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_27_a",
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
				"cryptic_b_psyker_bonding_conversation_27_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_27_c",
		response = "cryptic_b_psyker_bonding_conversation_27_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_27_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_27_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_27_d",
		response = "cryptic_b_psyker_bonding_conversation_27_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_27_c",
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
				"cryptic_b_psyker_bonding_conversation_27_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_28_a",
		response = "cryptic_b_psyker_bonding_conversation_28_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_28_a",
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
				"cryptic_b_psyker_bonding_conversation_28_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_28_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_28_b",
		response = "cryptic_b_psyker_bonding_conversation_28_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_28_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_28_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_28_c",
		response = "cryptic_b_psyker_bonding_conversation_28_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_28_b",
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
				"cryptic_b_psyker_bonding_conversation_28_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_28_d",
		response = "cryptic_b_psyker_bonding_conversation_28_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_28_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_28_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_29_a",
		response = "cryptic_b_psyker_bonding_conversation_29_a",
		wwise_route = 0,
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
					"loc_cryptic_b__combat_pause_one_liner_05",
					"loc_cryptic_b__combat_pause_quirk_nostalgia_b_01",
					"loc_cryptic_b__combat_pause_limited_cryptic_b_18_b_01",
					"loc_cryptic_b__combat_pause_quirk_broker_c_trait_01_b_01",
					"loc_cryptic_b__combat_pause_quirk_broker_b_trait_07_b_01",
					"loc_cryptic_b__combat_pause_quirk_end_b_01",
					"loc_cryptic_b__combat_pause_quirk_adamant_b_trait_03_b_01",
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
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_29_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_29_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_29_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_29_b",
		response = "cryptic_b_psyker_bonding_conversation_29_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_29_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_29_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_29_c",
		response = "cryptic_b_psyker_bonding_conversation_29_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_29_b",
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
				"cryptic_b_psyker_bonding_conversation_29_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_29_d",
		response = "cryptic_b_psyker_bonding_conversation_29_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_29_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_29_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_29_e",
		response = "cryptic_b_psyker_bonding_conversation_29_e",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_29_d",
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
				"cryptic_b_psyker_bonding_conversation_29_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_30_a",
		response = "cryptic_b_psyker_bonding_conversation_30_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_30_a",
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
				"cryptic_b_psyker_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_30_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_30_b",
		response = "cryptic_b_psyker_bonding_conversation_30_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_30_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_30_c",
		response = "cryptic_b_psyker_bonding_conversation_30_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_30_b",
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
				"cryptic_b_psyker_bonding_conversation_30_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_30_d",
		response = "cryptic_b_psyker_bonding_conversation_30_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_30_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_31_a",
		response = "cryptic_b_psyker_bonding_conversation_31_a",
		wwise_route = 0,
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
					"loc_psyker_female_c__combat_pause_limited_cryptic_b_11_b_01",
					"loc_psyker_female_c__combat_pause_limited_cryptic_b_15_b_01",
					"loc_psyker_female_c__combat_pause_limited_cryptic_b_18_b_01",
					"loc_psyker_female_c__combat_pause_quirk_reads_thoughts_b_01",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_31_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_31_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_31_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_31_b",
		response = "cryptic_b_psyker_bonding_conversation_31_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_31_a",
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
				"cryptic_b_psyker_bonding_conversation_31_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_31_c",
		response = "cryptic_b_psyker_bonding_conversation_31_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_31_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_31_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_31_d",
		response = "cryptic_b_psyker_bonding_conversation_31_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_31_c",
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
				"cryptic_b_psyker_bonding_conversation_31_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_32_a",
		response = "cryptic_b_psyker_bonding_conversation_32_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_32_a",
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
				"cryptic_b_psyker_bonding_conversation_32_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_32_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_32_b",
		response = "cryptic_b_psyker_bonding_conversation_32_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_32_a",
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
				"cryptic_b_psyker_bonding_conversation_32_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_32_c",
		response = "cryptic_b_psyker_bonding_conversation_32_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_32_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_32_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_32_d",
		response = "cryptic_b_psyker_bonding_conversation_32_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_32_c",
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
				"cryptic_b_psyker_bonding_conversation_32_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_33_a",
		response = "cryptic_b_psyker_bonding_conversation_33_a",
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
					"cryptic_b",
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
				"cryptic_b_psyker_bonding_conversation_33_a",
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
				"cryptic_b_psyker_bonding_conversation_33_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_33_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_33_b",
		response = "cryptic_b_psyker_bonding_conversation_33_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_33_a",
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
				"cryptic_b_psyker_bonding_conversation_33_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_33_c",
		response = "cryptic_b_psyker_bonding_conversation_33_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_33_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_33_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_33_d",
		response = "cryptic_b_psyker_bonding_conversation_33_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_33_c",
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
				"cryptic_b_psyker_bonding_conversation_33_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_34_a",
		response = "cryptic_b_psyker_bonding_conversation_34_a",
		wwise_route = 0,
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
					"loc_cryptic_b__combat_pause_quirk_adamant_b_trait_05_b_01",
					"loc_cryptic_b__combat_pause_quirk_friends_b_01",
					"loc_cryptic_b__combat_pause_quirk_ogryn_d_chatty_b_01",
					"loc_cryptic_b__combat_pause_quirk_broker_a_trait_06_b_01",
					"loc_cryptic_b__combat_pause_one_liner_01",
					"loc_cryptic_b__combat_pause_limited_bolt_on_a_psyker_c_02_b_01",
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
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_34_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_34_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_34_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_34_b",
		response = "cryptic_b_psyker_bonding_conversation_34_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_34_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_34_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_34_c",
		response = "cryptic_b_psyker_bonding_conversation_34_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_34_b",
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
				"cryptic_b_psyker_bonding_conversation_34_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_34_d",
		response = "cryptic_b_psyker_bonding_conversation_34_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_34_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_34_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_35_a",
		response = "cryptic_b_psyker_bonding_conversation_35_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_35_a",
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
				"cryptic_b_psyker_bonding_conversation_35_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_35_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_35_b",
		response = "cryptic_b_psyker_bonding_conversation_35_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_35_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_35_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_35_c",
		response = "cryptic_b_psyker_bonding_conversation_35_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_35_b",
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
				"cryptic_b_psyker_bonding_conversation_35_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_35_d",
		response = "cryptic_b_psyker_bonding_conversation_35_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_35_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_35_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_36_a",
		response = "cryptic_b_psyker_bonding_conversation_36_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_36_a",
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
				"cryptic_b_psyker_bonding_conversation_36_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_psyker_bonding_conversation_36_a",
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
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_36_b",
		response = "cryptic_b_psyker_bonding_conversation_36_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_36_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_36_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_36_c",
		response = "cryptic_b_psyker_bonding_conversation_36_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_36_b",
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
				"cryptic_b_psyker_bonding_conversation_36_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_psyker_bonding_conversation_36_d",
		response = "cryptic_b_psyker_bonding_conversation_36_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_psyker_bonding_conversation_36_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_psyker_bonding_conversation_36_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_01_a",
		response = "cryptic_b_veteran_bonding_conversation_01_a",
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
					"cryptic_b",
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
				"cryptic_b_veteran_bonding_conversation_01_a",
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
				"cryptic_b_veteran_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_01_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_01_b",
		response = "cryptic_b_veteran_bonding_conversation_01_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_01_a",
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
				"cryptic_b_veteran_bonding_conversation_01_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_01_c",
		response = "cryptic_b_veteran_bonding_conversation_01_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_01_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_01_d",
		response = "cryptic_b_veteran_bonding_conversation_01_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_01_c",
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
				"cryptic_b_veteran_bonding_conversation_01_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_02_a",
		response = "cryptic_b_veteran_bonding_conversation_02_a",
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
					"cryptic_b",
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
				"cryptic_b_veteran_bonding_conversation_02_a",
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
				"cryptic_b_veteran_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_02_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_02_b",
		response = "cryptic_b_veteran_bonding_conversation_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_02_a",
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
				"cryptic_b_veteran_bonding_conversation_02_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_02_c",
		response = "cryptic_b_veteran_bonding_conversation_02_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_02_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_02_d",
		response = "cryptic_b_veteran_bonding_conversation_02_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_02_c",
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
				"cryptic_b_veteran_bonding_conversation_02_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_03_a",
		response = "cryptic_b_veteran_bonding_conversation_03_a",
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
					"cryptic_b",
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
				"cryptic_b_veteran_bonding_conversation_03_a",
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
				"cryptic_b_veteran_bonding_conversation_03_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_03_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_03_b",
		response = "cryptic_b_veteran_bonding_conversation_03_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_03_a",
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
				"cryptic_b_veteran_bonding_conversation_03_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_03_c",
		response = "cryptic_b_veteran_bonding_conversation_03_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_03_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_03_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_03_d",
		response = "cryptic_b_veteran_bonding_conversation_03_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_03_c",
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
				"cryptic_b_veteran_bonding_conversation_03_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_04_a",
		response = "cryptic_b_veteran_bonding_conversation_04_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_04_a",
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
				"cryptic_b_veteran_bonding_conversation_04_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_04_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_04_b",
		response = "cryptic_b_veteran_bonding_conversation_04_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_04_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_04_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_04_c",
		response = "cryptic_b_veteran_bonding_conversation_04_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_04_b",
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
				"cryptic_b_veteran_bonding_conversation_04_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_04_d",
		response = "cryptic_b_veteran_bonding_conversation_04_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_04_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_04_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_05_a",
		response = "cryptic_b_veteran_bonding_conversation_05_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_05_a",
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
				"cryptic_b_veteran_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_05_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_05_b",
		response = "cryptic_b_veteran_bonding_conversation_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_05_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_05_c",
		response = "cryptic_b_veteran_bonding_conversation_05_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_05_b",
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
				"cryptic_b_veteran_bonding_conversation_05_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_05_d",
		response = "cryptic_b_veteran_bonding_conversation_05_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_05_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_06_a",
		response = "cryptic_b_veteran_bonding_conversation_06_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_06_a",
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
				"cryptic_b_veteran_bonding_conversation_06_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_06_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_06_b",
		response = "cryptic_b_veteran_bonding_conversation_06_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_06_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_06_c",
		response = "cryptic_b_veteran_bonding_conversation_06_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_06_b",
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
				"cryptic_b_veteran_bonding_conversation_06_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_06_d",
		response = "cryptic_b_veteran_bonding_conversation_06_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_06_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_06_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_07_a",
		response = "cryptic_b_veteran_bonding_conversation_07_a",
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
					"cryptic_b",
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
				"cryptic_b_veteran_bonding_conversation_07_a",
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
				"cryptic_b_veteran_bonding_conversation_07_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_07_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_07_b",
		response = "cryptic_b_veteran_bonding_conversation_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_07_a",
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
				"cryptic_b_veteran_bonding_conversation_07_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_07_c",
		response = "cryptic_b_veteran_bonding_conversation_07_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_07_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_07_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_07_d",
		response = "cryptic_b_veteran_bonding_conversation_07_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_07_c",
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
				"cryptic_b_veteran_bonding_conversation_07_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_08_a",
		response = "cryptic_b_veteran_bonding_conversation_08_a",
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
					"cryptic_b",
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
				"cryptic_b_veteran_bonding_conversation_08_a",
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
				"cryptic_b_veteran_bonding_conversation_08_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_08_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_08_b",
		response = "cryptic_b_veteran_bonding_conversation_08_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_08_a",
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
				"cryptic_b_veteran_bonding_conversation_08_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_08_c",
		response = "cryptic_b_veteran_bonding_conversation_08_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_08_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_08_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_08_d",
		response = "cryptic_b_veteran_bonding_conversation_08_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_08_c",
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
				"cryptic_b_veteran_bonding_conversation_08_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_09_a",
		response = "cryptic_b_veteran_bonding_conversation_09_a",
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
					"cryptic_b",
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
				"cryptic_b_veteran_bonding_conversation_09_a",
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
				"cryptic_b_veteran_bonding_conversation_09_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_09_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_09_b",
		response = "cryptic_b_veteran_bonding_conversation_09_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_09_a",
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
				"cryptic_b_veteran_bonding_conversation_09_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_09_c",
		response = "cryptic_b_veteran_bonding_conversation_09_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_09_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_09_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_09_d",
		response = "cryptic_b_veteran_bonding_conversation_09_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_09_c",
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
				"cryptic_b_veteran_bonding_conversation_09_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_10_a",
		response = "cryptic_b_veteran_bonding_conversation_10_a",
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
					"veteran_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_10_a",
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
				"cryptic_b_veteran_bonding_conversation_10_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_10_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_10_b",
		response = "cryptic_b_veteran_bonding_conversation_10_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_10_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_10_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_10_c",
		response = "cryptic_b_veteran_bonding_conversation_10_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_10_b",
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
				"cryptic_b_veteran_bonding_conversation_10_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_10_d",
		response = "cryptic_b_veteran_bonding_conversation_10_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_10_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_10_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_12_a",
		response = "cryptic_b_veteran_bonding_conversation_12_a",
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
					"veteran_female_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_12_a",
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
				"cryptic_b_veteran_bonding_conversation_12_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_12_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_12_b",
		response = "cryptic_b_veteran_bonding_conversation_12_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_12_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_12_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_12_c",
		response = "cryptic_b_veteran_bonding_conversation_12_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_12_b",
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
				"cryptic_b_veteran_bonding_conversation_12_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_12_d",
		response = "cryptic_b_veteran_bonding_conversation_12_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_12_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_12_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_13_a",
		response = "cryptic_b_veteran_bonding_conversation_13_a",
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
					"cryptic_b",
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
				"cryptic_b_veteran_bonding_conversation_13_a",
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
				"cryptic_b_veteran_bonding_conversation_13_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_13_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_13_b",
		response = "cryptic_b_veteran_bonding_conversation_13_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_13_a",
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
				"cryptic_b_veteran_bonding_conversation_13_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_13_c",
		response = "cryptic_b_veteran_bonding_conversation_13_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_13_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_13_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_13_d",
		response = "cryptic_b_veteran_bonding_conversation_13_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_13_c",
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
				"cryptic_b_veteran_bonding_conversation_13_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_14_a",
		response = "cryptic_b_veteran_bonding_conversation_14_a",
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
					"cryptic_b",
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
				"cryptic_b_veteran_bonding_conversation_14_a",
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
				"cryptic_b_veteran_bonding_conversation_14_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_14_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_14_b",
		response = "cryptic_b_veteran_bonding_conversation_14_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_14_a",
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
				"cryptic_b_veteran_bonding_conversation_14_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_14_c",
		response = "cryptic_b_veteran_bonding_conversation_14_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_14_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_14_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_14_d",
		response = "cryptic_b_veteran_bonding_conversation_14_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_14_c",
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
				"cryptic_b_veteran_bonding_conversation_14_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_15_a",
		response = "cryptic_b_veteran_bonding_conversation_15_a",
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
					"cryptic_b",
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
				"cryptic_b_veteran_bonding_conversation_15_a",
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
				"cryptic_b_veteran_bonding_conversation_15_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_15_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_15_b",
		response = "cryptic_b_veteran_bonding_conversation_15_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_15_a",
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
				"cryptic_b_veteran_bonding_conversation_15_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_15_c",
		response = "cryptic_b_veteran_bonding_conversation_15_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_15_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_15_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_15_d",
		response = "cryptic_b_veteran_bonding_conversation_15_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_15_c",
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
				"cryptic_b_veteran_bonding_conversation_15_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_16_a",
		response = "cryptic_b_veteran_bonding_conversation_16_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_16_a",
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
				"cryptic_b_veteran_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_16_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_16_b",
		response = "cryptic_b_veteran_bonding_conversation_16_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_16_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_16_c",
		response = "cryptic_b_veteran_bonding_conversation_16_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_16_b",
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
				"cryptic_b_veteran_bonding_conversation_16_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_16_d",
		response = "cryptic_b_veteran_bonding_conversation_16_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_16_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_17_a",
		response = "cryptic_b_veteran_bonding_conversation_17_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_17_a",
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
				"cryptic_b_veteran_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_17_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_17_b",
		response = "cryptic_b_veteran_bonding_conversation_17_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_17_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_17_c",
		response = "cryptic_b_veteran_bonding_conversation_17_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_17_b",
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
				"cryptic_b_veteran_bonding_conversation_17_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_17_d",
		response = "cryptic_b_veteran_bonding_conversation_17_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_17_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_18_a",
		response = "cryptic_b_veteran_bonding_conversation_18_a",
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
				420,
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_18_a",
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
				"cryptic_b_veteran_bonding_conversation_18_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_18_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_18_b",
		response = "cryptic_b_veteran_bonding_conversation_18_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_18_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_18_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_18_c",
		response = "cryptic_b_veteran_bonding_conversation_18_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_18_b",
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
				"cryptic_b_veteran_bonding_conversation_18_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_18_d",
		response = "cryptic_b_veteran_bonding_conversation_18_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_18_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_18_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_25_a",
		response = "cryptic_b_veteran_bonding_conversation_25_a",
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
					"cryptic_b",
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
				"cryptic_b_veteran_bonding_conversation_25_a",
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
				"cryptic_b_veteran_bonding_conversation_25_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_25_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_25_b",
		response = "cryptic_b_veteran_bonding_conversation_25_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_25_a",
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
				"cryptic_b_veteran_bonding_conversation_25_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_25_c",
		response = "cryptic_b_veteran_bonding_conversation_25_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_25_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_25_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_25_d",
		response = "cryptic_b_veteran_bonding_conversation_25_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_25_c",
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
				"cryptic_b_veteran_bonding_conversation_25_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_26_a",
		response = "cryptic_b_veteran_bonding_conversation_26_a",
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
					"cryptic_b",
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
				"cryptic_b_veteran_bonding_conversation_26_a",
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
				"cryptic_b_veteran_bonding_conversation_26_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_26_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_26_b",
		response = "cryptic_b_veteran_bonding_conversation_26_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_26_a",
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
				"cryptic_b_veteran_bonding_conversation_26_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_26_c",
		response = "cryptic_b_veteran_bonding_conversation_26_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_26_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_26_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_26_d",
		response = "cryptic_b_veteran_bonding_conversation_26_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_26_c",
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
				"cryptic_b_veteran_bonding_conversation_26_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_27_a",
		response = "cryptic_b_veteran_bonding_conversation_27_a",
		wwise_route = 0,
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
					"loc_veteran_male_c__combat_pause_limited_adamant_c_05_b_01",
					"loc_veteran_male_c__combat_pause_quirk_nostalgia_b_01",
					"loc_veteran_male_c__combat_pause_quirk_adamant_c_trait_06_b_01",
					"loc_veteran_male_c__combat_pause_quirk_adamant_a_trait_07_b_02",
					"loc_veteran_male_c__combat_pause_quirk_broker_a_trait_09_b_01",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_27_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_27_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_27_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_27_b",
		response = "cryptic_b_veteran_bonding_conversation_27_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_27_a",
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
				"cryptic_b_veteran_bonding_conversation_27_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_27_c",
		response = "cryptic_b_veteran_bonding_conversation_27_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_27_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_27_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_27_d",
		response = "cryptic_b_veteran_bonding_conversation_27_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_27_c",
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
				"cryptic_b_veteran_bonding_conversation_27_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_28_a",
		response = "cryptic_b_veteran_bonding_conversation_28_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_28_a",
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
				"cryptic_b_veteran_bonding_conversation_28_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_28_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_28_b",
		response = "cryptic_b_veteran_bonding_conversation_28_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_28_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_28_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_28_c",
		response = "cryptic_b_veteran_bonding_conversation_28_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_28_b",
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
				"cryptic_b_veteran_bonding_conversation_28_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_28_d",
		response = "cryptic_b_veteran_bonding_conversation_28_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_28_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_28_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_29_a",
		response = "cryptic_b_veteran_bonding_conversation_29_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_29_a",
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
				"cryptic_b_veteran_bonding_conversation_29_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_29_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_29_b",
		response = "cryptic_b_veteran_bonding_conversation_29_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_29_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_29_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_29_c",
		response = "cryptic_b_veteran_bonding_conversation_29_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_29_b",
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
				"cryptic_b_veteran_bonding_conversation_29_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_29_d",
		response = "cryptic_b_veteran_bonding_conversation_29_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_29_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_29_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_30_a",
		response = "cryptic_b_veteran_bonding_conversation_30_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_30_a",
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
				"cryptic_b_veteran_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_30_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_30_b",
		response = "cryptic_b_veteran_bonding_conversation_30_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_30_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_30_c",
		response = "cryptic_b_veteran_bonding_conversation_30_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_30_b",
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
				"cryptic_b_veteran_bonding_conversation_30_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_30_d",
		response = "cryptic_b_veteran_bonding_conversation_30_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_30_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_31_a",
		response = "cryptic_b_veteran_bonding_conversation_31_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_c",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_31_a",
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
				"cryptic_b_veteran_bonding_conversation_31_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_31_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_31_b",
		response = "cryptic_b_veteran_bonding_conversation_31_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_31_a",
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
				"cryptic_b_veteran_bonding_conversation_31_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_31_c",
		response = "cryptic_b_veteran_bonding_conversation_31_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_31_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_31_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_31_d",
		response = "cryptic_b_veteran_bonding_conversation_31_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_31_c",
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
				"cryptic_b_veteran_bonding_conversation_31_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_32_a",
		response = "cryptic_b_veteran_bonding_conversation_32_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_c",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_32_a",
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
				"cryptic_b_veteran_bonding_conversation_32_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_32_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_32_b",
		response = "cryptic_b_veteran_bonding_conversation_32_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_32_a",
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
				"cryptic_b_veteran_bonding_conversation_32_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_32_c",
		response = "cryptic_b_veteran_bonding_conversation_32_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_32_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_32_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_32_d",
		response = "cryptic_b_veteran_bonding_conversation_32_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_32_c",
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
				"cryptic_b_veteran_bonding_conversation_32_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_33_a",
		response = "cryptic_b_veteran_bonding_conversation_33_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_c",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_33_a",
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
				"cryptic_b_veteran_bonding_conversation_33_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_33_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_33_b",
		response = "cryptic_b_veteran_bonding_conversation_33_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_33_a",
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
				"cryptic_b_veteran_bonding_conversation_33_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_33_c",
		response = "cryptic_b_veteran_bonding_conversation_33_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_33_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_33_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_33_d",
		response = "cryptic_b_veteran_bonding_conversation_33_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_33_c",
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
				"cryptic_b_veteran_bonding_conversation_33_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_34_a",
		response = "cryptic_b_veteran_bonding_conversation_34_a",
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
					"veteran_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_34_a",
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
				"cryptic_b_veteran_bonding_conversation_34_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_34_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_34_b",
		response = "cryptic_b_veteran_bonding_conversation_34_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_34_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_34_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_34_c",
		response = "cryptic_b_veteran_bonding_conversation_34_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_34_b",
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
				"cryptic_b_veteran_bonding_conversation_34_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_34_d",
		response = "cryptic_b_veteran_bonding_conversation_34_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_34_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_34_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_35_a",
		response = "cryptic_b_veteran_bonding_conversation_35_a",
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
					"veteran_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_35_a",
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
				"cryptic_b_veteran_bonding_conversation_35_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_35_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_35_b",
		response = "cryptic_b_veteran_bonding_conversation_35_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_35_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_35_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_35_c",
		response = "cryptic_b_veteran_bonding_conversation_35_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_35_b",
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
				"cryptic_b_veteran_bonding_conversation_35_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_35_d",
		response = "cryptic_b_veteran_bonding_conversation_35_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_35_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_35_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_36_a",
		response = "cryptic_b_veteran_bonding_conversation_36_a",
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
					"veteran_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_36_a",
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
				"cryptic_b_veteran_bonding_conversation_36_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_veteran_bonding_conversation_36_a",
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
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_36_b",
		response = "cryptic_b_veteran_bonding_conversation_36_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_36_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_36_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_36_c",
		response = "cryptic_b_veteran_bonding_conversation_36_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_36_b",
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
				"cryptic_b_veteran_bonding_conversation_36_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_veteran_bonding_conversation_36_d",
		response = "cryptic_b_veteran_bonding_conversation_36_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_veteran_bonding_conversation_36_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_veteran_bonding_conversation_36_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_01_a",
		response = "cryptic_b_zealot_bonding_conversation_01_a",
		wwise_route = 0,
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
					"loc_zealot_male_a__combat_pause_one_liner_01",
					"loc_zealot_male_a__combat_pause_one_liner_03",
					"loc_zealot_male_a__combat_pause_one_liner_08",
					"loc_zealot_male_a__combat_pause_one_liner_09",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_01_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_01_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_01_b",
		response = "cryptic_b_zealot_bonding_conversation_01_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_01_a",
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
				"cryptic_b_zealot_bonding_conversation_01_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_01_c",
		response = "cryptic_b_zealot_bonding_conversation_01_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_01_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_01_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_01_d",
		response = "cryptic_b_zealot_bonding_conversation_01_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_01_c",
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
				"cryptic_b_zealot_bonding_conversation_01_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_02_a",
		response = "cryptic_b_zealot_bonding_conversation_02_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_02_a",
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
				"cryptic_b_zealot_bonding_conversation_02_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_02_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_02_b",
		response = "cryptic_b_zealot_bonding_conversation_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_02_a",
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
				"cryptic_b_zealot_bonding_conversation_02_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_02_c",
		response = "cryptic_b_zealot_bonding_conversation_02_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_02_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_02_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_02_d",
		response = "cryptic_b_zealot_bonding_conversation_02_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_02_c",
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
				"cryptic_b_zealot_bonding_conversation_02_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_03_a",
		response = "cryptic_b_zealot_bonding_conversation_03_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_03_a",
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
				"cryptic_b_zealot_bonding_conversation_03_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_03_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_03_b",
		response = "cryptic_b_zealot_bonding_conversation_03_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_03_a",
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
				"cryptic_b_zealot_bonding_conversation_03_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_03_c",
		response = "cryptic_b_zealot_bonding_conversation_03_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_03_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_03_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_03_d",
		response = "cryptic_b_zealot_bonding_conversation_03_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_03_c",
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
				"cryptic_b_zealot_bonding_conversation_03_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_04_a",
		response = "cryptic_b_zealot_bonding_conversation_04_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_04_a",
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
				"cryptic_b_zealot_bonding_conversation_04_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_04_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_04_b",
		response = "cryptic_b_zealot_bonding_conversation_04_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_04_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_04_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_04_c",
		response = "cryptic_b_zealot_bonding_conversation_04_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_04_b",
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
				"cryptic_b_zealot_bonding_conversation_04_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_04_d",
		response = "cryptic_b_zealot_bonding_conversation_04_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_04_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_04_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_05_a",
		response = "cryptic_b_zealot_bonding_conversation_05_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_05_a",
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
				"cryptic_b_zealot_bonding_conversation_05_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_05_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_05_b",
		response = "cryptic_b_zealot_bonding_conversation_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_05_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_05_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_05_c",
		response = "cryptic_b_zealot_bonding_conversation_05_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_05_b",
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
				"cryptic_b_zealot_bonding_conversation_05_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_05_d",
		response = "cryptic_b_zealot_bonding_conversation_05_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_05_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_05_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_06_a",
		response = "cryptic_b_zealot_bonding_conversation_06_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_06_a",
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
				"cryptic_b_zealot_bonding_conversation_06_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_06_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_06_b",
		response = "cryptic_b_zealot_bonding_conversation_06_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_06_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_06_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_06_c",
		response = "cryptic_b_zealot_bonding_conversation_06_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_06_b",
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
				"cryptic_b_zealot_bonding_conversation_06_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_06_d",
		response = "cryptic_b_zealot_bonding_conversation_06_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_06_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_06_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_07_a",
		response = "cryptic_b_zealot_bonding_conversation_07_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_07_a",
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
				"cryptic_b_zealot_bonding_conversation_07_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_07_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_07_b",
		response = "cryptic_b_zealot_bonding_conversation_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_07_a",
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
				"cryptic_b_zealot_bonding_conversation_07_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_07_c",
		response = "cryptic_b_zealot_bonding_conversation_07_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_07_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_07_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_07_d",
		response = "cryptic_b_zealot_bonding_conversation_07_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_07_c",
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
				"cryptic_b_zealot_bonding_conversation_07_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_08_a",
		response = "cryptic_b_zealot_bonding_conversation_08_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_08_a",
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
				"cryptic_b_zealot_bonding_conversation_08_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_08_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_08_b",
		response = "cryptic_b_zealot_bonding_conversation_08_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_08_a",
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
				"cryptic_b_zealot_bonding_conversation_08_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_08_c",
		response = "cryptic_b_zealot_bonding_conversation_08_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_08_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_08_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_08_d",
		response = "cryptic_b_zealot_bonding_conversation_08_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_08_c",
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
				"cryptic_b_zealot_bonding_conversation_08_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_09_a",
		response = "cryptic_b_zealot_bonding_conversation_09_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_09_a",
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
				"cryptic_b_zealot_bonding_conversation_09_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_09_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_09_b",
		response = "cryptic_b_zealot_bonding_conversation_09_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_09_a",
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
				"cryptic_b_zealot_bonding_conversation_09_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_09_c",
		response = "cryptic_b_zealot_bonding_conversation_09_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_09_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_09_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_09_d",
		response = "cryptic_b_zealot_bonding_conversation_09_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_09_c",
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
				"cryptic_b_zealot_bonding_conversation_09_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_10_a",
		response = "cryptic_b_zealot_bonding_conversation_10_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_10_a",
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
				"cryptic_b_zealot_bonding_conversation_10_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_10_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_10_b",
		response = "cryptic_b_zealot_bonding_conversation_10_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_10_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_10_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_10_c",
		response = "cryptic_b_zealot_bonding_conversation_10_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_10_b",
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
				"cryptic_b_zealot_bonding_conversation_10_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_10_d",
		response = "cryptic_b_zealot_bonding_conversation_10_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_10_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_10_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_11_a",
		response = "cryptic_b_zealot_bonding_conversation_11_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_11_a",
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
				"cryptic_b_zealot_bonding_conversation_11_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_11_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_11_b",
		response = "cryptic_b_zealot_bonding_conversation_11_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_11_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_11_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_11_c",
		response = "cryptic_b_zealot_bonding_conversation_11_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_11_b",
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
				"cryptic_b_zealot_bonding_conversation_11_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_11_d",
		response = "cryptic_b_zealot_bonding_conversation_11_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_11_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_11_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_12_a",
		response = "cryptic_b_zealot_bonding_conversation_12_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_12_a",
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
				"cryptic_b_zealot_bonding_conversation_12_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_12_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_12_b",
		response = "cryptic_b_zealot_bonding_conversation_12_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_12_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_12_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_12_c",
		response = "cryptic_b_zealot_bonding_conversation_12_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_12_b",
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
				"cryptic_b_zealot_bonding_conversation_12_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_12_d",
		response = "cryptic_b_zealot_bonding_conversation_12_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_12_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_12_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_13_a",
		response = "cryptic_b_zealot_bonding_conversation_13_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_13_a",
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
				"cryptic_b_zealot_bonding_conversation_13_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_13_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_13_b",
		response = "cryptic_b_zealot_bonding_conversation_13_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_13_a",
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
				"cryptic_b_zealot_bonding_conversation_13_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_13_c",
		response = "cryptic_b_zealot_bonding_conversation_13_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_13_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_13_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_13_d",
		response = "cryptic_b_zealot_bonding_conversation_13_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_13_c",
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
				"cryptic_b_zealot_bonding_conversation_13_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_14_a",
		response = "cryptic_b_zealot_bonding_conversation_14_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_14_a",
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
				"cryptic_b_zealot_bonding_conversation_14_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_14_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_14_b",
		response = "cryptic_b_zealot_bonding_conversation_14_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_14_a",
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
				"cryptic_b_zealot_bonding_conversation_14_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_14_c",
		response = "cryptic_b_zealot_bonding_conversation_14_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_14_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_14_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_14_d",
		response = "cryptic_b_zealot_bonding_conversation_14_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_14_c",
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
				"cryptic_b_zealot_bonding_conversation_14_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_15_a",
		response = "cryptic_b_zealot_bonding_conversation_15_a",
		wwise_route = 0,
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
					"loc_zealot_male_b__combat_pause_one_liner_05",
					"loc_zealot_male_b__combat_pause_quirk_endless_war_b_02",
					"loc_zealot_male_b__combat_pause_quirk_anger_b_02",
					"loc_zealot_male_b__combat_pause_quirk_speed_b_02",
					"loc_zealot_male_b__combat_pause_quirk_killing_stopped_b_02",
					"loc_zealot_male_b__combat_pause_quirk_speed_b_01",
					"loc_zealot_male_b__combat_pause_quirk_adamant_c_trait_05_b_02",
					"loc_zealot_male_b__combat_pause_quirk_ogryn_d_kill_quick_b_01",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_15_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_15_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_15_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_15_b",
		response = "cryptic_b_zealot_bonding_conversation_15_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_15_a",
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
				"cryptic_b_zealot_bonding_conversation_15_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_15_c",
		response = "cryptic_b_zealot_bonding_conversation_15_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_15_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_15_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_15_d",
		response = "cryptic_b_zealot_bonding_conversation_15_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_15_c",
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
				"cryptic_b_zealot_bonding_conversation_15_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_16_a",
		response = "cryptic_b_zealot_bonding_conversation_16_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_16_a",
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
				"cryptic_b_zealot_bonding_conversation_16_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_16_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_16_b",
		response = "cryptic_b_zealot_bonding_conversation_16_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_16_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_16_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_16_c",
		response = "cryptic_b_zealot_bonding_conversation_16_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_16_b",
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
				"cryptic_b_zealot_bonding_conversation_16_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_16_d",
		response = "cryptic_b_zealot_bonding_conversation_16_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_16_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_16_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_17_a",
		response = "cryptic_b_zealot_bonding_conversation_17_a",
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
					"zealot_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_17_a",
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
				"cryptic_b_zealot_bonding_conversation_17_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_17_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_17_b",
		response = "cryptic_b_zealot_bonding_conversation_17_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_17_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_17_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_17_c",
		response = "cryptic_b_zealot_bonding_conversation_17_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_17_b",
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
				"cryptic_b_zealot_bonding_conversation_17_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_17_d",
		response = "cryptic_b_zealot_bonding_conversation_17_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_17_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_17_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_18_a",
		response = "cryptic_b_zealot_bonding_conversation_18_a",
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
				300,
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_18_a",
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
				"cryptic_b_zealot_bonding_conversation_18_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_18_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_18_b",
		response = "cryptic_b_zealot_bonding_conversation_18_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_18_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_18_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_18_c",
		response = "cryptic_b_zealot_bonding_conversation_18_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_18_b",
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
				"cryptic_b_zealot_bonding_conversation_18_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_18_d",
		response = "cryptic_b_zealot_bonding_conversation_18_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_18_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_18_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_19_a",
		response = "cryptic_b_zealot_bonding_conversation_19_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_19_a",
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
				"cryptic_b_zealot_bonding_conversation_19_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_19_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_19_b",
		response = "cryptic_b_zealot_bonding_conversation_19_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_19_a",
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
				"cryptic_b_zealot_bonding_conversation_19_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_19_c",
		response = "cryptic_b_zealot_bonding_conversation_19_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_19_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_19_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_19_d",
		response = "cryptic_b_zealot_bonding_conversation_19_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_19_c",
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
				"cryptic_b_zealot_bonding_conversation_19_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_20_a",
		response = "cryptic_b_zealot_bonding_conversation_20_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_20_a",
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
				"cryptic_b_zealot_bonding_conversation_20_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_20_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_20_b",
		response = "cryptic_b_zealot_bonding_conversation_20_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_20_a",
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
				"cryptic_b_zealot_bonding_conversation_20_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_20_c",
		response = "cryptic_b_zealot_bonding_conversation_20_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_20_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_20_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_20_d",
		response = "cryptic_b_zealot_bonding_conversation_20_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_20_c",
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
				"cryptic_b_zealot_bonding_conversation_20_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_21_a",
		response = "cryptic_b_zealot_bonding_conversation_21_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_21_a",
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
				"cryptic_b_zealot_bonding_conversation_21_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_21_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_21_b",
		response = "cryptic_b_zealot_bonding_conversation_21_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_21_a",
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
				"cryptic_b_zealot_bonding_conversation_21_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_21_c",
		response = "cryptic_b_zealot_bonding_conversation_21_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_21_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_21_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_21_d",
		response = "cryptic_b_zealot_bonding_conversation_21_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_21_c",
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
				"cryptic_b_zealot_bonding_conversation_21_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_22_a",
		response = "cryptic_b_zealot_bonding_conversation_22_a",
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
				300,
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_22_a",
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
				"cryptic_b_zealot_bonding_conversation_22_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_22_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_22_b",
		response = "cryptic_b_zealot_bonding_conversation_22_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_22_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_22_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_22_c",
		response = "cryptic_b_zealot_bonding_conversation_22_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_22_b",
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
				"cryptic_b_zealot_bonding_conversation_22_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_22_d",
		response = "cryptic_b_zealot_bonding_conversation_22_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_22_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_22_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_23_a",
		response = "cryptic_b_zealot_bonding_conversation_23_a",
		wwise_route = 0,
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
					"loc_cryptic_b__combat_pause_limited_zealot_b_15_b_01",
					"loc_cryptic_b__combat_pause_quirk_expendable_b_01",
					"loc_cryptic_b__combat_pause_quirk_pilgrimage_b_01",
					"loc_cryptic_b__combat_pause_quirk_adamant_b_trait_07_b_01",
					"loc_cryptic_b__combat_pause_quirk_adamant_a_trait_08_b_01",
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
				"cryptic_b_zealot_bonding_conversation_23_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_23_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_23_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_23_b",
		response = "cryptic_b_zealot_bonding_conversation_23_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_23_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_23_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_23_c",
		response = "cryptic_b_zealot_bonding_conversation_23_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_23_b",
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
				"cryptic_b_zealot_bonding_conversation_23_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_23_d",
		response = "cryptic_b_zealot_bonding_conversation_23_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_23_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_23_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_24_a",
		response = "cryptic_b_zealot_bonding_conversation_24_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_24_a",
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
				"cryptic_b_zealot_bonding_conversation_24_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_24_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_24_b",
		response = "cryptic_b_zealot_bonding_conversation_24_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_24_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_24_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_24_c",
		response = "cryptic_b_zealot_bonding_conversation_24_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_24_b",
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
				"cryptic_b_zealot_bonding_conversation_24_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_24_d",
		response = "cryptic_b_zealot_bonding_conversation_24_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_24_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_24_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_25_a",
		response = "cryptic_b_zealot_bonding_conversation_25_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_25_a",
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
				"cryptic_b_zealot_bonding_conversation_25_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_25_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_25_b",
		response = "cryptic_b_zealot_bonding_conversation_25_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_25_a",
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
				"cryptic_b_zealot_bonding_conversation_25_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_25_c",
		response = "cryptic_b_zealot_bonding_conversation_25_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_25_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_25_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_25_d",
		response = "cryptic_b_zealot_bonding_conversation_25_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_25_c",
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
				"cryptic_b_zealot_bonding_conversation_25_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_26_a",
		response = "cryptic_b_zealot_bonding_conversation_26_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_26_a",
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
				"cryptic_b_zealot_bonding_conversation_26_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_26_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_26_b",
		response = "cryptic_b_zealot_bonding_conversation_26_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_26_a",
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
				"cryptic_b_zealot_bonding_conversation_26_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_26_c",
		response = "cryptic_b_zealot_bonding_conversation_26_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_26_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_26_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_26_d",
		response = "cryptic_b_zealot_bonding_conversation_26_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_26_c",
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
				"cryptic_b_zealot_bonding_conversation_26_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_27_a",
		response = "cryptic_b_zealot_bonding_conversation_27_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_27_a",
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
				"cryptic_b_zealot_bonding_conversation_27_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_27_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_27_b",
		response = "cryptic_b_zealot_bonding_conversation_27_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_27_a",
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
				"cryptic_b_zealot_bonding_conversation_27_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_27_c",
		response = "cryptic_b_zealot_bonding_conversation_27_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_27_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_27_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_27_d",
		response = "cryptic_b_zealot_bonding_conversation_27_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_27_c",
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
				"cryptic_b_zealot_bonding_conversation_27_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_28_a",
		response = "cryptic_b_zealot_bonding_conversation_28_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_28_a",
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
				"cryptic_b_zealot_bonding_conversation_28_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_28_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_28_b",
		response = "cryptic_b_zealot_bonding_conversation_28_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_28_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_28_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_28_c",
		response = "cryptic_b_zealot_bonding_conversation_28_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_28_b",
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
				"cryptic_b_zealot_bonding_conversation_28_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_28_d",
		response = "cryptic_b_zealot_bonding_conversation_28_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_28_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_28_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_29_a",
		response = "cryptic_b_zealot_bonding_conversation_29_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_29_a",
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
				"cryptic_b_zealot_bonding_conversation_29_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_29_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_29_b",
		response = "cryptic_b_zealot_bonding_conversation_29_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_29_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_29_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_29_c",
		response = "cryptic_b_zealot_bonding_conversation_29_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_29_b",
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
				"cryptic_b_zealot_bonding_conversation_29_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_29_d",
		response = "cryptic_b_zealot_bonding_conversation_29_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_29_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_29_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_30_a",
		response = "cryptic_b_zealot_bonding_conversation_30_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_30_a",
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
				"cryptic_b_zealot_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_30_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_30_b",
		response = "cryptic_b_zealot_bonding_conversation_30_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_30_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_30_c",
		response = "cryptic_b_zealot_bonding_conversation_30_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_30_b",
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
				"cryptic_b_zealot_bonding_conversation_30_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_30_d",
		response = "cryptic_b_zealot_bonding_conversation_30_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_30_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_31_a",
		response = "cryptic_b_zealot_bonding_conversation_31_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_31_a",
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
				"cryptic_b_zealot_bonding_conversation_31_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_31_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_31_b",
		response = "cryptic_b_zealot_bonding_conversation_31_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_31_a",
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
				"cryptic_b_zealot_bonding_conversation_31_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_31_c",
		response = "cryptic_b_zealot_bonding_conversation_31_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_31_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_31_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_31_d",
		response = "cryptic_b_zealot_bonding_conversation_31_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_31_c",
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
				"cryptic_b_zealot_bonding_conversation_31_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_32_a",
		response = "cryptic_b_zealot_bonding_conversation_32_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_32_a",
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
				"cryptic_b_zealot_bonding_conversation_32_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_32_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_32_b",
		response = "cryptic_b_zealot_bonding_conversation_32_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_32_a",
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
				"cryptic_b_zealot_bonding_conversation_32_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_32_c",
		response = "cryptic_b_zealot_bonding_conversation_32_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_32_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_32_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_32_d",
		response = "cryptic_b_zealot_bonding_conversation_32_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_32_c",
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
				"cryptic_b_zealot_bonding_conversation_32_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_33_a",
		response = "cryptic_b_zealot_bonding_conversation_33_a",
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
					"cryptic_b",
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
				"cryptic_b_zealot_bonding_conversation_33_a",
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
				"cryptic_b_zealot_bonding_conversation_33_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_33_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_33_b",
		response = "cryptic_b_zealot_bonding_conversation_33_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_33_a",
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
				"cryptic_b_zealot_bonding_conversation_33_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_33_c",
		response = "cryptic_b_zealot_bonding_conversation_33_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_33_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_33_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_33_d",
		response = "cryptic_b_zealot_bonding_conversation_33_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_33_c",
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
				"cryptic_b_zealot_bonding_conversation_33_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_34_a",
		response = "cryptic_b_zealot_bonding_conversation_34_a",
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
					"zealot_female_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_34_a",
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
				"cryptic_b_zealot_bonding_conversation_34_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_34_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_34_b",
		response = "cryptic_b_zealot_bonding_conversation_34_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_34_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_34_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_34_c",
		response = "cryptic_b_zealot_bonding_conversation_34_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_34_b",
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
				"cryptic_b_zealot_bonding_conversation_34_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_34_d",
		response = "cryptic_b_zealot_bonding_conversation_34_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_34_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_34_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_35_a",
		response = "cryptic_b_zealot_bonding_conversation_35_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_35_a",
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
				"cryptic_b_zealot_bonding_conversation_35_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_35_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_35_b",
		response = "cryptic_b_zealot_bonding_conversation_35_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_35_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_35_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_35_c",
		response = "cryptic_b_zealot_bonding_conversation_35_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_35_b",
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
				"cryptic_b_zealot_bonding_conversation_35_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_35_d",
		response = "cryptic_b_zealot_bonding_conversation_35_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_35_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_35_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_36_a",
		response = "cryptic_b_zealot_bonding_conversation_36_a",
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
					"cryptic_b",
				},
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_36_a",
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
				"cryptic_b_zealot_bonding_conversation_36_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_b_zealot_bonding_conversation_36_a",
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
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_36_b",
		response = "cryptic_b_zealot_bonding_conversation_36_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_36_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_36_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_36_c",
		response = "cryptic_b_zealot_bonding_conversation_36_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_36_b",
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
				"cryptic_b_zealot_bonding_conversation_36_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_b_zealot_bonding_conversation_36_d",
		response = "cryptic_b_zealot_bonding_conversation_36_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b_zealot_bonding_conversation_36_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_b_zealot_bonding_conversation_36_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_13_a",
		response = "cryptic_bonding_conversation_13_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_c",
				},
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_13_a",
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
				"cryptic_bonding_conversation_13_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_13_a",
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_13_b",
		response = "cryptic_bonding_conversation_13_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_13_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_bonding_conversation_13_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_13_c",
		response = "cryptic_bonding_conversation_13_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_13_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_13_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_13_d",
		response = "cryptic_bonding_conversation_13_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_13_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_c",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_13_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_14_a",
		response = "cryptic_bonding_conversation_14_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_c",
				},
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_14_a",
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
				"cryptic_bonding_conversation_14_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_14_a",
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_14_b",
		response = "cryptic_bonding_conversation_14_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_14_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_bonding_conversation_14_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_14_c",
		response = "cryptic_bonding_conversation_14_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_14_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_14_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_14_d",
		response = "cryptic_bonding_conversation_14_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_14_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_c",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_14_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_15_a",
		response = "cryptic_bonding_conversation_15_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_c",
				},
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_15_a",
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
				"cryptic_bonding_conversation_15_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_15_a",
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_15_b",
		response = "cryptic_bonding_conversation_15_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_15_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_c",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_bonding_conversation_15_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_15_c",
		response = "cryptic_bonding_conversation_15_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_15_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_15_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_15_d",
		response = "cryptic_bonding_conversation_15_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_15_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_c",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_15_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_19_a",
		response = "cryptic_bonding_conversation_19_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_d",
				},
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_19_a",
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
				"cryptic_bonding_conversation_19_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_19_a",
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_19_b",
		response = "cryptic_bonding_conversation_19_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_19_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_d",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_bonding_conversation_19_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_19_c",
		response = "cryptic_bonding_conversation_19_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_19_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_19_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_19_d",
		response = "cryptic_bonding_conversation_19_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_19_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_d",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_19_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_20_a",
		response = "cryptic_bonding_conversation_20_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_d",
				},
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_20_a",
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
				"cryptic_bonding_conversation_20_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_20_a",
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_20_b",
		response = "cryptic_bonding_conversation_20_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_20_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_d",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_bonding_conversation_20_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_20_c",
		response = "cryptic_bonding_conversation_20_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_20_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_20_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_20_d",
		response = "cryptic_bonding_conversation_20_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_20_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_d",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_20_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_21_a",
		response = "cryptic_bonding_conversation_21_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_d",
				},
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_21_a",
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
				"cryptic_bonding_conversation_21_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_21_a",
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_21_b",
		response = "cryptic_bonding_conversation_21_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_21_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_d",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_bonding_conversation_21_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_21_c",
		response = "cryptic_bonding_conversation_21_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_21_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_21_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_21_d",
		response = "cryptic_bonding_conversation_21_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_21_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_d",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_21_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_28_a",
		response = "cryptic_bonding_conversation_28_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_a",
				},
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_28_a",
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
				"cryptic_bonding_conversation_28_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_28_a",
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_28_b",
		response = "cryptic_bonding_conversation_28_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_28_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_bonding_conversation_28_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_28_c",
		response = "cryptic_bonding_conversation_28_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_28_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_28_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_28_d",
		response = "cryptic_bonding_conversation_28_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_28_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_a",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_28_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_29_a",
		response = "cryptic_bonding_conversation_29_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_a",
				},
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_29_a",
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
				"cryptic_bonding_conversation_29_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_29_a",
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_29_b",
		response = "cryptic_bonding_conversation_29_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_29_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_bonding_conversation_29_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_29_c",
		response = "cryptic_bonding_conversation_29_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_29_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_29_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_29_d",
		response = "cryptic_bonding_conversation_29_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_29_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_a",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_29_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_30_a",
		response = "cryptic_bonding_conversation_30_a",
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
					"cryptic_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"cryptic_a",
				},
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_30_a",
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
				"cryptic_bonding_conversation_30_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"cryptic_bonding_conversation_30_a",
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
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_30_b",
		response = "cryptic_bonding_conversation_30_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_30_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_a",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_bonding_conversation_30_b_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_30_c",
		response = "cryptic_bonding_conversation_30_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_30_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_b",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_30_a_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic_b",
		name = "cryptic_bonding_conversation_30_d",
		response = "cryptic_bonding_conversation_30_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_bonding_conversation_30_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"cryptic_a",
				},
			},
			{
				"user_memory",
				"cryptic_bonding_conversation_30_b_user",
				OP.EQ,
				1,
			},
		},
		on_done = {},
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
