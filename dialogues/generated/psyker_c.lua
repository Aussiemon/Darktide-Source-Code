-- chunkname: @dialogues/generated/psyker_c.lua

return function ()
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_02_a",
		response = "combat_pause_limited_psyker_c_02_a",
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
					"psyker_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_02_a",
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
				"combat_pause_limited_psyker_c_02_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_02_b",
		response = "combat_pause_limited_psyker_c_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_02_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
					"psyker_male_b",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_04_a",
		response = "combat_pause_limited_psyker_c_04_a",
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
					"psyker_male_c",
				},
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
					"veteran_male_c",
					"adamant_male_b",
					"adamant_female_b",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_04_a",
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
				"combat_pause_limited_psyker_c_04_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_04_b",
		response = "combat_pause_limited_psyker_c_04_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_04_a",
				},
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
					"veteran_male_c",
					"adamant_male_b",
					"adamant_female_b",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_05_a",
		response = "combat_pause_limited_psyker_c_05_a",
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
					"psyker_male_c",
				},
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
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_05_a",
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
				"combat_pause_limited_psyker_c_05_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_05_b",
		response = "combat_pause_limited_psyker_c_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_05_a",
				},
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
					"zealot_male_a",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_07_a",
		response = "combat_pause_limited_psyker_c_07_a",
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
					"psyker_male_c",
				},
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
					"zealot_male_c",
					"adamant_male_b",
					"adamant_female_b",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_07_a",
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
				"combat_pause_limited_psyker_c_07_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_07_b",
		response = "combat_pause_limited_psyker_c_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_07_a",
				},
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
					"zealot_male_c",
					"adamant_male_b",
					"adamant_female_b",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_08_a",
		response = "combat_pause_limited_psyker_c_08_a",
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
					"psyker_male_c",
				},
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
					"veteran_male_c",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_08_a",
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
				"combat_pause_limited_psyker_c_08_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_08_b",
		response = "combat_pause_limited_psyker_c_08_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_08_a",
				},
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
					"veteran_male_c",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_09_a",
		response = "combat_pause_limited_psyker_c_09_a",
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
					"psyker_male_c",
				},
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
					"zealot_male_b",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_09_a",
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
				"combat_pause_limited_psyker_c_09_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_09_b",
		response = "combat_pause_limited_psyker_c_09_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_09_a",
				},
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
					"zealot_male_b",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_10_a",
		response = "combat_pause_limited_psyker_c_10_a",
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
					"psyker_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"psyker_female_b",
					"psyker_male_b",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_10_a",
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
				"combat_pause_limited_psyker_c_10_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_10_b",
		response = "combat_pause_limited_psyker_c_10_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_10_a",
				},
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
					"psyker_male_b",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_11_a",
		response = "combat_pause_limited_psyker_c_11_a",
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
					"psyker_male_c",
				},
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
					"zealot_male_c",
					"adamant_male_a",
					"adamant_female_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_11_a",
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
				"combat_pause_limited_psyker_c_11_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_11_b",
		response = "combat_pause_limited_psyker_c_11_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_11_a",
				},
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
					"zealot_male_c",
					"adamant_male_a",
					"adamant_female_a",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_12_a",
		response = "combat_pause_limited_psyker_c_12_a",
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
					"psyker_male_c",
				},
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
					"veteran_male_c",
					"adamant_male_a",
					"adamant_female_a",
					"adamant_male_b",
					"adamant_female_b",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_12_a",
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
				"combat_pause_limited_psyker_c_12_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_12_b",
		response = "combat_pause_limited_psyker_c_12_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_12_a",
				},
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
					"veteran_male_c",
					"adamant_male_a",
					"adamant_female_a",
					"adamant_male_b",
					"adamant_female_b",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_13_a",
		response = "combat_pause_limited_psyker_c_13_a",
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
					"psyker_male_c",
				},
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
					"zealot_male_b",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_13_a",
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
				"combat_pause_limited_psyker_c_13_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_13_b",
		response = "combat_pause_limited_psyker_c_13_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_13_a",
				},
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
					"zealot_male_b",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_14_a",
		response = "combat_pause_limited_psyker_c_14_a",
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
					"psyker_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"zealot_female_b",
					"zealot_male_b",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_14_a",
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
				"combat_pause_limited_psyker_c_14_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_14_b",
		response = "combat_pause_limited_psyker_c_14_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_14_a",
				},
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
					"zealot_male_b",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_15_a",
		response = "combat_pause_limited_psyker_c_15_a",
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
					"psyker_male_c",
				},
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
					"zealot_male_c",
					"adamant_male_a",
					"adamant_female_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_15_a",
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
				"combat_pause_limited_psyker_c_15_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_15_b",
		response = "combat_pause_limited_psyker_c_15_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_15_a",
				},
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
					"zealot_male_c",
					"adamant_male_a",
					"adamant_female_a",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_16_a",
		response = "combat_pause_limited_psyker_c_16_a",
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
					"psyker_male_c",
				},
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
					"veteran_male_c",
					"adamant_male_b",
					"adamant_female_b",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_16_a",
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
				"combat_pause_limited_psyker_c_16_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_16_b",
		response = "combat_pause_limited_psyker_c_16_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_16_a",
				},
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
					"veteran_male_c",
					"adamant_male_b",
					"adamant_female_b",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_17_a",
		response = "combat_pause_limited_psyker_c_17_a",
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
					"psyker_male_c",
				},
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
					"zealot_male_a",
					"adamant_male_b",
					"adamant_female_b",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_17_a",
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
				"combat_pause_limited_psyker_c_17_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_17_b",
		response = "combat_pause_limited_psyker_c_17_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_17_a",
				},
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
					"zealot_male_a",
					"adamant_male_b",
					"adamant_female_b",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_18_a",
		response = "combat_pause_limited_psyker_c_18_a",
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
					"psyker_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_b",
					"veteran_female_a",
					"veteran_male_a",
					"adamant_male_a",
					"adamant_female_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_18_a",
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
				"combat_pause_limited_psyker_c_18_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_18_b",
		response = "combat_pause_limited_psyker_c_18_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_18_a",
				},
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
					"veteran_male_a",
					"adamant_male_a",
					"adamant_female_a",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_19_a",
		response = "combat_pause_limited_psyker_c_19_a",
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
					"psyker_male_c",
				},
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
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_19_a",
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
				"combat_pause_limited_psyker_c_19_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_19_b",
		response = "combat_pause_limited_psyker_c_19_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_19_a",
				},
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
					"zealot_male_c",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_20_a",
		response = "combat_pause_limited_psyker_c_20_a",
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
					"psyker_male_c",
				},
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
					"veteran_male_c",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_limited_psyker_c_20_a",
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
				"combat_pause_limited_psyker_c_20_a",
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
		database = "psyker_c",
		name = "combat_pause_limited_psyker_c_20_b",
		response = "combat_pause_limited_psyker_c_20_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_limited_psyker_c_20_a",
				},
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
					"veteran_male_c",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "psyker_c",
		name = "combat_pause_quirk_concerning_enforcers_a",
		response = "combat_pause_quirk_concerning_enforcers_a",
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
					"psyker_male_c",
				},
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
					"zealot_male_c",
					"adamant_male_a",
					"adamant_female_a",
					"adamant_male_b",
					"adamant_female_b",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_quirk_concerning_enforcers_a",
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
				"combat_pause_quirk_concerning_enforcers_a",
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
		database = "psyker_c",
		name = "combat_pause_quirk_concerning_enforcers_b",
		response = "combat_pause_quirk_concerning_enforcers_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_quirk_concerning_enforcers_a",
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
		database = "psyker_c",
		name = "combat_pause_quirk_local_knowledge_a",
		response = "combat_pause_quirk_local_knowledge_a",
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
					"psyker_male_c",
				},
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
					"zealot_male_c",
					"adamant_male_a",
					"adamant_female_a",
					"adamant_male_b",
					"adamant_female_b",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_quirk_local_knowledge_a",
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
				"combat_pause_quirk_local_knowledge_a",
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
		database = "psyker_c",
		name = "combat_pause_quirk_local_knowledge_b",
		response = "combat_pause_quirk_local_knowledge_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_quirk_local_knowledge_a",
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
		database = "psyker_c",
		name = "combat_pause_quirk_messelina_a",
		response = "combat_pause_quirk_messelina_a",
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
					"psyker_male_c",
				},
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
					"zealot_male_c",
					"adamant_male_a",
					"adamant_female_a",
					"adamant_male_b",
					"adamant_female_b",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_quirk_messelina_a",
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
				"combat_pause_quirk_messelina_a",
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
		database = "psyker_c",
		name = "combat_pause_quirk_messelina_b",
		response = "combat_pause_quirk_messelina_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_quirk_messelina_a",
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
		database = "psyker_c",
		name = "combat_pause_quirk_tertium_splendour_a",
		response = "combat_pause_quirk_tertium_splendour_a",
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
					"psyker_male_c",
				},
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
					"zealot_male_c",
					"adamant_male_a",
					"adamant_female_a",
					"adamant_male_b",
					"adamant_female_b",
					"adamant_male_c",
					"adamant_female_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_quirk_tertium_splendour_a",
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
				"combat_pause_quirk_tertium_splendour_a",
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
		database = "psyker_c",
		name = "combat_pause_quirk_tertium_splendour_b",
		response = "combat_pause_quirk_tertium_splendour_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_quirk_tertium_splendour_a",
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
		database = "psyker_c",
		name = "psyker_gang_metropolitan_purpose_a",
		response = "psyker_gang_metropolitan_purpose_a",
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
					"psyker_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_a",
					"psyker_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_b",
					"psyker_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_NOT_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"psyker_gang_metropolitan_purpose_a",
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
				"psyker_gang_metropolitan_purpose_a",
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
		database = "psyker_c",
		name = "psyker_gang_metropolitan_purpose_b",
		response = "psyker_gang_metropolitan_purpose_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_gang_metropolitan_purpose_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
					"psyker_male_b",
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
		database = "psyker_c",
		name = "psyker_gang_metropolitan_purpose_c",
		response = "psyker_gang_metropolitan_purpose_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_gang_metropolitan_purpose_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
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
		database = "psyker_c",
		name = "psyker_gang_metropolitan_purpose_d",
		response = "psyker_gang_metropolitan_purpose_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_gang_metropolitan_purpose_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
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
		database = "psyker_c",
		name = "psyker_gang_metropolitan_trusted_a",
		response = "psyker_gang_metropolitan_trusted_a",
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
					"psyker_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_a",
					"psyker_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_b",
					"psyker_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_NOT_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"psyker_gang_metropolitan_trusted_a",
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
				"psyker_gang_metropolitan_trusted_a",
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
		database = "psyker_c",
		name = "psyker_gang_metropolitan_trusted_b",
		response = "psyker_gang_metropolitan_trusted_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_gang_metropolitan_trusted_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
					"psyker_male_b",
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
		database = "psyker_c",
		name = "psyker_gang_metropolitan_trusted_c",
		response = "psyker_gang_metropolitan_trusted_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_gang_metropolitan_trusted_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
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
		database = "psyker_c",
		name = "psyker_gang_metropolitan_trusted_d",
		response = "psyker_gang_metropolitan_trusted_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_gang_metropolitan_trusted_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
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
		database = "psyker_c",
		name = "psyker_gang_metropolitan_value_a",
		response = "psyker_gang_metropolitan_value_a",
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
					"psyker_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_a",
					"psyker_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_female_b",
					"psyker_male_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_NOT_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"psyker_gang_metropolitan_value_a",
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
				"psyker_gang_metropolitan_value_a",
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
		database = "psyker_c",
		name = "psyker_gang_metropolitan_value_b",
		response = "psyker_gang_metropolitan_value_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_gang_metropolitan_value_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
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
		database = "psyker_c",
		name = "psyker_gang_metropolitan_value_c",
		response = "psyker_gang_metropolitan_value_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_gang_metropolitan_value_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_b",
					"psyker_male_b",
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
		database = "psyker_c",
		name = "psyker_gang_metropolitan_value_d",
		response = "psyker_gang_metropolitan_value_d",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_gang_metropolitan_value_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_c",
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
end
