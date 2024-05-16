-- chunkname: @dialogues/generated/circumstance_vo_nurgle_rot.lua

return function ()
	define_rule({
		category = "conversations_prio_0",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_five_a",
		response = "nurgle_circumstance_conversation_five_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30,
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_nurgle_rot",
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low, medium",
			},
			{
				"user_context",
				"pacing_state",
				OP.SET_INCLUDES,
				args = {
					"tension_peak_fade",
					"relax",
					"build_up_tension_low",
					"build_up_tension_no_trickle",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_five_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "nurgle_circumstance_conversation_five_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"nurgle_circumstance_conversation_five_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
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
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_five_c",
		response = "nurgle_circumstance_conversation_five_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"nurgle_circumstance_conversation_five_b",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_four_a",
		response = "nurgle_circumstance_conversation_four_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30,
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_nurgle_rot",
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low, medium",
			},
			{
				"user_context",
				"pacing_state",
				OP.SET_INCLUDES,
				args = {
					"tension_peak_fade",
					"relax",
					"build_up_tension_low",
					"build_up_tension_no_trickle",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_four_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "nurgle_circumstance_conversation_four_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"nurgle_circumstance_conversation_four_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
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
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_four_c",
		response = "nurgle_circumstance_conversation_four_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"nurgle_circumstance_conversation_four_b",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_one_a",
		response = "nurgle_circumstance_conversation_one_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30,
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_nurgle_rot",
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low, medium",
			},
			{
				"user_context",
				"pacing_state",
				OP.SET_INCLUDES,
				args = {
					"tension_peak_fade",
					"relax",
					"build_up_tension_low",
					"build_up_tension_no_trickle",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_one_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "nurgle_circumstance_conversation_one_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"nurgle_circumstance_conversation_one_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
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
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_one_c",
		response = "nurgle_circumstance_conversation_one_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"nurgle_circumstance_conversation_one_b",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_three_a",
		response = "nurgle_circumstance_conversation_three_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30,
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_nurgle_rot",
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low",
			},
			{
				"user_context",
				"pacing_state",
				OP.SET_INCLUDES,
				args = {
					"tension_peak_fade",
					"relax",
					"build_up_tension_low",
					"build_up_tension_no_trickle",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_three_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "nurgle_circumstance_conversation_three_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"nurgle_circumstance_conversation_three_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
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
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_three_c",
		response = "nurgle_circumstance_conversation_three_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"nurgle_circumstance_conversation_three_b",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_two_a",
		response = "nurgle_circumstance_conversation_two_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30,
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_nurgle_rot",
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low, medium",
			},
			{
				"user_context",
				"pacing_state",
				OP.SET_INCLUDES,
				args = {
					"tension_peak_fade",
					"relax",
					"build_up_tension_low",
					"build_up_tension_no_trickle",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_conversation",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
				"0",
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_two_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "nurgle_circumstance_conversation_two_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"nurgle_circumstance_conversation_two_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
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
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_conversation_two_c",
		response = "nurgle_circumstance_conversation_two_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"nurgle_circumstance_conversation_two_b",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "player_prio_2",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_prop_alive",
		response = "nurgle_circumstance_prop_alive",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at",
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"nurgle_circumstance_prop_alive",
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				40,
			},
			{
				"faction_memory",
				"nurgle_circumstance_prop",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_prop",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_prop_growth",
		response = "nurgle_circumstance_prop_growth",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at",
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"nurgle_circumstance_prop_growth",
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				40,
			},
			{
				"faction_memory",
				"nurgle_circumstance_prop",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_prop",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_prop_shrine",
		response = "nurgle_circumstance_prop_shrine",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at",
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"nurgle_circumstance_prop_shrine",
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				40,
			},
			{
				"faction_memory",
				"nurgle_circumstance_prop",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"nurgle_circumstance_prop",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_start_a",
		response = "nurgle_circumstance_start_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"start_banter",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_nurgle_rot",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"pilot",
					"tech_priest",
					"explicator",
				},
			},
			{
				"faction_memory",
				"start_banter",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"start_banter",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_start_b",
		response = "nurgle_circumstance_start_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"nurgle_circumstance_start_a",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "all",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "circumstance_vo_nurgle_rot",
		name = "nurgle_circumstance_start_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "nurgle_circumstance_start_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"nurgle_circumstance_start_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
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
end
