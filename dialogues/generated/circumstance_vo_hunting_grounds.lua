-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds.lua

return function ()
	define_rule({
		category = "conversations_prio_1",
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_ogryn_a_hound_a",
		response = "combat_pause_circumstance_ogryn_a_hound_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_hunting_grounds",
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
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
					"ogryn_b",
					"psyker_female_a",
					"psyker_male_a",
					"veteran_female_b",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_ogryn_a_hound_a",
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
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.LT,
				80,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_ogryn_a_hound_a",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_ogryn_a_hound_b",
		response = "combat_pause_circumstance_ogryn_a_hound_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_circumstance_ogryn_a_hound_a",
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
					"veteran_female_b",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_ogryn_b_hunted_a",
		response = "combat_pause_circumstance_ogryn_b_hunted_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_hunting_grounds",
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
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
					"ogryn_c",
					"psyker_female_b",
					"psyker_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_ogryn_b_hunted_a",
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
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.LT,
				80,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_ogryn_b_hunted_a",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_ogryn_b_hunted_b",
		response = "combat_pause_circumstance_ogryn_b_hunted_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_circumstance_ogryn_b_hunted_a",
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
					"veteran_female_c",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_ogryn_c_meat_a",
		response = "combat_pause_circumstance_ogryn_c_meat_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_hunting_grounds",
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
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
					"ogryn_a",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_male_a",
					"zealot_female_b",
					"zealot_male_b",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_ogryn_c_meat_a",
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
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.LT,
				80,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_ogryn_c_meat_a",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_ogryn_c_meat_b",
		response = "combat_pause_circumstance_ogryn_c_meat_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_circumstance_ogryn_c_meat_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_male_a",
					"zealot_female_b",
					"zealot_male_b",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_psyker_a_hound_a",
		response = "combat_pause_circumstance_psyker_a_hound_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_hunting_grounds",
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
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
					"psyker_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_b",
					"veteran_female_b",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_psyker_a_hound_a",
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
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.LT,
				80,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_psyker_a_hound_a",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_psyker_a_hound_b",
		response = "combat_pause_circumstance_psyker_a_hound_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_circumstance_psyker_a_hound_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_b",
					"veteran_female_b",
					"zealot_female_c",
					"zealot_male_c",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_psyker_b_hunted_a",
		response = "combat_pause_circumstance_psyker_b_hunted_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_hunting_grounds",
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
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
					"psyker_female_b",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_c",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_psyker_b_hunted_a",
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
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.LT,
				80,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_psyker_b_hunted_a",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_psyker_b_hunted_b",
		response = "combat_pause_circumstance_psyker_b_hunted_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_circumstance_psyker_b_hunted_a",
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
					"veteran_female_c",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_psyker_c_hound_a",
		response = "combat_pause_circumstance_psyker_c_hound_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_hunting_grounds",
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
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
					"veteran_male_a",
					"zealot_female_b",
					"zealot_male_b",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_psyker_c_hound_a",
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
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.LT,
				80,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_psyker_c_hound_a",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_psyker_c_hound_b",
		response = "combat_pause_circumstance_psyker_c_hound_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_circumstance_psyker_c_hound_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"veteran_male_a",
					"zealot_female_b",
					"zealot_male_b",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_veteran_a_hound_a",
		response = "combat_pause_circumstance_veteran_a_hound_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_hunting_grounds",
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
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
					"ogryn_b",
					"psyker_female_a",
					"psyker_male_a",
					"veteran_female_b",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_veteran_a_hound_a",
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
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.LT,
				80,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_veteran_a_hound_a",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_veteran_a_hound_b",
		response = "combat_pause_circumstance_veteran_a_hound_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_circumstance_veteran_a_hound_a",
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
					"veteran_female_b",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_veteran_b_hound_a",
		response = "combat_pause_circumstance_veteran_b_hound_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_hunting_grounds",
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
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
					"veteran_female_b",
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
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_veteran_b_hound_a",
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
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.LT,
				80,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_veteran_b_hound_a",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_veteran_b_hound_b",
		response = "combat_pause_circumstance_veteran_b_hound_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_circumstance_veteran_b_hound_a",
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
					"veteran_female_c",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_veteran_c_hunt_a",
		response = "combat_pause_circumstance_veteran_c_hunt_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_hunting_grounds",
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
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
					"veteran_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_male_a",
					"zealot_female_b",
					"zealot_male_b",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_veteran_c_hunt_a",
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
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.LT,
				80,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_veteran_c_hunt_a",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_veteran_c_hunt_b",
		response = "combat_pause_circumstance_veteran_c_hunt_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_circumstance_veteran_c_hunt_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_male_a",
					"zealot_female_b",
					"zealot_male_b",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_zealot_a_hound_a",
		response = "combat_pause_circumstance_zealot_a_hound_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_hunting_grounds",
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
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
					"zealot_male_a",
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
					"veteran_female_b",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_zealot_a_hound_a",
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
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.LT,
				80,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_zealot_a_hound_a",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_zealot_a_hound_b",
		response = "combat_pause_circumstance_zealot_a_hound_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_circumstance_zealot_a_hound_a",
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
					"veteran_female_b",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_zealot_b_hunt_a",
		response = "combat_pause_circumstance_zealot_b_hunt_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_hunting_grounds",
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
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
					"zealot_male_b",
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
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_zealot_b_hunt_a",
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
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.LT,
				80,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_zealot_b_hunt_a",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_zealot_b_hunt_b",
		response = "combat_pause_circumstance_zealot_b_hunt_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_circumstance_zealot_b_hunt_a",
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
					"veteran_female_c",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_zealot_c_hound_a",
		response = "combat_pause_circumstance_zealot_c_hound_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_hunting_grounds",
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
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
					"zealot_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_male_a",
					"zealot_female_b",
					"zealot_male_b",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_zealot_c_hound_a",
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
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.LT,
				80,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_zealot_c_hound_a",
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
		database = "circumstance_vo_hunting_grounds",
		name = "combat_pause_circumstance_zealot_c_hound_b",
		response = "combat_pause_circumstance_zealot_c_hound_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"combat_pause_circumstance_zealot_c_hound_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_male_a",
					"zealot_female_b",
					"zealot_male_b",
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
		category = "player_prio_0",
		database = "circumstance_vo_hunting_grounds",
		name = "disabled_by_chaos_hound_mutator",
		response = "disabled_by_chaos_hound_mutator",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"pounced_by_special_attack",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_hound_mutator",
			},
			{
				"faction_memory",
				"disabled_by_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"disabled_by_chaos_hound_mutator",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_alerts_prio_0",
		database = "circumstance_vo_hunting_grounds",
		name = "heard_enemy_chaos_hound_mutator",
		response = "heard_enemy_chaos_hound_mutator",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_hound_mutator",
			},
			{
				"query_context",
				"enemies_close",
				OP.GTEQ,
				0,
			},
			{
				"faction_memory",
				"enemy_chaos_hound_mutator",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"enemy_chaos_hound_mutator",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "circumstance_vo_hunting_grounds",
		name = "hunting_circumstance_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hunting_circumstance_start_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_hunting_grounds",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_heat_response_two",
					"mission_cartel_mudlark",
					"mission_scavenge_daylight_response_b",
					"mission_station_tanks",
					"mission_cargo_start_banter_d",
					"mission_forge_strategic_asset",
					"mission_propaganda_short_elevator_conversation_one_b",
					"mission_propaganda_short_elevator_conversation_two_b",
					"mission_propaganda_short_elevator_conversation_three_b",
					"mission_habs_redux_start_zone_response",
					"mission_archives_start_banter_c",
					"mission_complex_start_banter_c",
					"mission_enforcer_start_banter_c",
					"mission_rails_start_banter_c",
					"mission_resurgence_start_banter_c",
					"mission_stockpile_start_banter_c",
					"mission_strain_start_banter_c",
					"mission_armoury_rooftops_c",
					"mission_raid_safe_zone_e",
					"mission_rise_first_objective_response",
					"mission_core_safe_zone_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
					"tech_priest",
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
		category = "conversations_prio_0",
		database = "circumstance_vo_hunting_grounds",
		name = "hunting_circumstance_start_b",
		response = "hunting_circumstance_start_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hunting_circumstance_start_a",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "circumstance_vo_hunting_grounds",
		name = "smart_tag_vo_enemy_chaos_hound_mutator",
		response = "smart_tag_vo_enemy_chaos_hound_mutator",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_hound_mutator",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_chaos_hound_mutator",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
end
