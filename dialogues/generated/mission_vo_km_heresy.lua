-- chunkname: @dialogues/generated/mission_vo_km_heresy.lua

return function ()
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_backstreets",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
			{
				"faction_memory",
				"mission_heresy_backstreets",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_backstreets",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_01_b",
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
					"mission_heresy_backstreets_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_01_c",
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
					"mission_heresy_backstreets_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_01_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_01_d",
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
					"mission_heresy_backstreets_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_01_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_01_e",
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
					"mission_heresy_backstreets_01_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_backstreets",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_backstreets",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_backstreets",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_02_b",
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
					"mission_heresy_backstreets_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_02_c",
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
					"mission_heresy_backstreets_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_02_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_02_d",
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
					"mission_heresy_backstreets_02_c",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_02_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_02_e",
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
					"mission_heresy_backstreets_02_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_backstreets",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_backstreets",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_backstreets",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_03_b",
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
					"mission_heresy_backstreets_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_03_c",
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
					"mission_heresy_backstreets_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_03_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_03_d",
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
					"mission_heresy_backstreets_03_c",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_backstreets_03_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_backstreets_03_e",
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
					"mission_heresy_backstreets_03_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_brewhouse",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_brewhouse",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_brewhouse",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_01_b",
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
					"mission_heresy_brewhouse_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_01_c",
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
					"mission_heresy_brewhouse_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_brewhouse",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
			{
				"faction_memory",
				"mission_heresy_brewhouse",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_brewhouse",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_02_b",
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
					"mission_heresy_brewhouse_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_02_c",
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
					"mission_heresy_brewhouse_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_brewhouse",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_brewhouse",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_brewhouse",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_03_b",
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
					"mission_heresy_brewhouse_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_03_c",
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
					"mission_heresy_brewhouse_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_cellar_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_cellar_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_brewhouse_cellar",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_brewhouse_cellar",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_brewhouse_cellar",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_cellar_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_cellar_01_b",
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
					"mission_heresy_brewhouse_cellar_01_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_cellar_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_cellar_01_c",
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
					"mission_heresy_brewhouse_cellar_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_cellar_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_cellar_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_brewhouse_cellar",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_brewhouse_cellar",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_brewhouse_cellar",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_cellar_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_cellar_02_b",
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
					"mission_heresy_brewhouse_cellar_02_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_cellar_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_cellar_02_c",
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
					"mission_heresy_brewhouse_cellar_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_cellar_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_cellar_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_brewhouse_cellar",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_brewhouse_cellar",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_brewhouse_cellar",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_cellar_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_cellar_03_b",
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
					"mission_heresy_brewhouse_cellar_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_cellar_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_cellar_03_c",
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
					"mission_heresy_brewhouse_cellar_03_b",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_brewhouse_cellar_03_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_brewhouse_cellar_03_d",
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
					"mission_heresy_brewhouse_cellar_03_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_airlock_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_airlock_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_airlock",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_airlock",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_airlock",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_airlock_b",
		response = "mission_heresy_cathedral_airlock_b",
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
					"mission_heresy_cathedral_airlock_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_airlock_c",
		post_wwise_event = "play_radio_static_end",
		response = "mission_heresy_cathedral_airlock_c",
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
					"mission_heresy_cathedral_airlock_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_approach_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_approach_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_approach",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_approach",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_approach",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_approach_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_approach_b",
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
					"mission_heresy_cathedral_approach_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_atrium_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_atrium_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_atrium",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_atrium",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_atrium",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_atrium_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_atrium_b",
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
					"mission_heresy_cathedral_atrium_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_bridge_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_bridge_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_bridge",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_bridge",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_bridge",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_bridge_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_bridge_01_b",
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
					"mission_heresy_cathedral_bridge_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_bridge_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_bridge_01_c",
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
					"mission_heresy_cathedral_bridge_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_bridge_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_bridge_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_bridge",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_bridge",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_bridge",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_bridge_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_bridge_02_b",
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
					"mission_heresy_cathedral_bridge_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_bridge_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_bridge_02_c",
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
					"mission_heresy_cathedral_bridge_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_bridge_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_bridge_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_bridge",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_bridge",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_bridge",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_bridge_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_bridge_03_b",
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
					"mission_heresy_cathedral_bridge_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_bridge_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_bridge_03_c",
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
					"mission_heresy_cathedral_bridge_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_agnostic_destroy_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_agnostic_destroy_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_event_agnostic_destroy",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_event_agnostic_destroy",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_event_agnostic_destroy",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_agnostic_directive_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_agnostic_directive_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_event_agnostic_directive",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_event_agnostic_directive",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_event_agnostic_directive",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_agnostic_success_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_agnostic_success_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_event_agnostic_success",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_event_agnostic_success",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_event_agnostic_success",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_agnostic_success_b",
		response = "mission_heresy_cathedral_event_agnostic_success_b",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_heresy_cathedral_event_agnostic_success_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_complete_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_complete_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_event_complete",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_event_complete",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_event_complete",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_complete_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_complete_b",
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
					"mission_heresy_cathedral_event_complete_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_complete_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_complete_c",
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
					"mission_heresy_cathedral_event_complete_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_first_dead_ritualist_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_first_dead_ritualist_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_event_first_dead_ritualist",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_event_first_dead_ritualist",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_event_first_dead_ritualist",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_interstitial_a",
		response = "mission_heresy_cathedral_event_interstitial_a",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cathedral_event_interstitial",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_event_interstitial",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_interstitial_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_interstitial_b",
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
					"mission_heresy_cathedral_event_interstitial_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_shield_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_shield_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_event_shield",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_event_shield",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_event_shield",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_shield_b",
		post_wwise_event = "play_radio_static_end",
		response = "mission_heresy_cathedral_event_shield_b",
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
					"mission_heresy_cathedral_event_shield_a",
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
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_shield_down_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_shield_down_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_event_shield_down_01",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_event_shield_down_01",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_event_shield_down_01",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_shield_down_01_b",
		response = "mission_heresy_cathedral_event_shield_down_01_b",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_heresy_cathedral_event_shield_down_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_shield_down_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_shield_down_01_c",
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
					"mission_heresy_cathedral_event_shield_down_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_shield_down_01_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_shield_down_01_d",
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
					"mission_heresy_cathedral_event_shield_down_01_c",
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
			target = "level_event",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_shield_down_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_shield_down_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_event_shield_down_02",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_event_shield_down_02",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_event_shield_down_02",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_shield_down_02_b",
		response = "mission_heresy_cathedral_event_shield_down_02_b",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_heresy_cathedral_event_shield_down_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_smash_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_smash_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_event_smash",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_event_smash",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_event_smash",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_start_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_event_start",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_event_start",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_event_start",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_start_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_start_b",
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
					"mission_heresy_cathedral_event_start_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cathedral_event_start_ingame_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_cathedral_event_start_ingame_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_cathedral_event_start_ingame",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_event_start_ingame",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_cathedral_event_start_ingame",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_corridor_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_corridor_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_corridor",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_corridor",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_corridor",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_corridor_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_corridor_01_b",
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
					"mission_heresy_corridor_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_corridor_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_corridor_01_c",
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
					"mission_heresy_corridor_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_corridor_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_corridor_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_corridor",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_corridor",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_corridor",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_corridor_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_corridor_02_b",
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
					"mission_heresy_corridor_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_corridor_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_corridor_02_c",
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
					"mission_heresy_corridor_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_corridor_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_corridor_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_corridor",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_corridor",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_corridor",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_corridor_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_corridor_03_b",
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
					"mission_heresy_corridor_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_corridor_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_corridor_03_c",
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
					"mission_heresy_corridor_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cult_chant_01_a",
		response = "mission_heresy_cult_chant_01_a",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cult_chant_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cult_chant_01_b",
		response = "mission_heresy_cult_chant_01_b",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cult_chant_01_b",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cult_chant_01_c",
		response = "mission_heresy_cult_chant_01_c",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cult_chant_01_c",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cult_chant_01_d",
		response = "mission_heresy_cult_chant_01_d",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cult_chant_01_d",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cult_chant_01_e",
		response = "mission_heresy_cult_chant_01_e",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cult_chant_01_e",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cult_chant_01_f",
		response = "mission_heresy_cult_chant_01_f",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cult_chant_01_f",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cult_chant_02_a",
		response = "mission_heresy_cult_chant_02_a",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cult_chant_02_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_cathedral_event_interstitial",
				OP.EQ,
				0,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cult_chant_02_b",
		response = "mission_heresy_cult_chant_02_b",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cult_chant_02_b",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cult_chant_02_c",
		response = "mission_heresy_cult_chant_02_c",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cult_chant_02_c",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cult_chant_02_d",
		response = "mission_heresy_cult_chant_02_d",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cult_chant_02_d",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cult_chant_02_e",
		response = "mission_heresy_cult_chant_02_e",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cult_chant_02_e",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_cult_chant_02_f",
		response = "mission_heresy_cult_chant_02_f",
		wwise_route = 56,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_heresy_cult_chant_02_f",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_elevator_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_elevator_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_elevator",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_elevator",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_elevator",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_elevator_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_elevator_01_b",
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
					"mission_heresy_elevator_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_elevator_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_elevator_01_c",
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
					"mission_heresy_elevator_01_b",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_elevator_01_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_elevator_01_d",
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
					"mission_heresy_elevator_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_elevator_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_elevator_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_elevator",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_elevator",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_elevator",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_elevator_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_elevator_02_b",
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
					"mission_heresy_elevator_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_elevator_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_elevator_02_c",
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
					"mission_heresy_elevator_02_b",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_elevator_02_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_elevator_02_d",
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
					"mission_heresy_elevator_02_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_elevator_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_elevator_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_elevator",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_elevator",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_elevator",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_elevator_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_elevator_03_b",
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
					"mission_heresy_elevator_03_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_elevator_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_elevator_03_c",
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
					"mission_heresy_elevator_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_inner_brewhouse_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_inner_brewhouse_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_inner_brewhouse",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_inner_brewhouse",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_inner_brewhouse",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_inner_brewhouse_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_inner_brewhouse_01_b",
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
					"mission_heresy_inner_brewhouse_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_inner_brewhouse_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_inner_brewhouse_01_c",
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
					"mission_heresy_inner_brewhouse_01_b",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_inner_brewhouse_01_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_inner_brewhouse_01_d",
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
					"mission_heresy_inner_brewhouse_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_inner_brewhouse_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_inner_brewhouse_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_inner_brewhouse",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_inner_brewhouse",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_inner_brewhouse",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_inner_brewhouse_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_inner_brewhouse_02_b",
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
					"mission_heresy_inner_brewhouse_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_inner_brewhouse_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_inner_brewhouse_02_c",
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
					"mission_heresy_inner_brewhouse_02_b",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_inner_brewhouse_02_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_inner_brewhouse_02_d",
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
					"mission_heresy_inner_brewhouse_02_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_inner_brewhouse_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_inner_brewhouse_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_inner_brewhouse",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_inner_brewhouse",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_inner_brewhouse",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_inner_brewhouse_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_inner_brewhouse_03_b",
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
					"mission_heresy_inner_brewhouse_03_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_inner_brewhouse_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_inner_brewhouse_03_c",
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
					"mission_heresy_inner_brewhouse_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_outro_cinematic_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_outro_cinematic_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_outro_cinematic",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_outro_cinematic",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_outro_cinematic",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_plaza_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_plaza_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_plaza",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_plaza",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_plaza",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_plaza_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_plaza_01_b",
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
					"mission_heresy_plaza_01_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_plaza_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_plaza_01_c",
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
					"mission_heresy_plaza_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_plaza_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_plaza_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_plaza",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_plaza",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_plaza",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_plaza_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_plaza_02_b",
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
					"mission_heresy_plaza_02_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_plaza_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_plaza_02_c",
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
					"mission_heresy_plaza_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_plaza_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_plaza_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_plaza",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_plaza",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_plaza",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_plaza_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_plaza_03_b",
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
					"mission_heresy_plaza_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_plaza_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_plaza_03_c",
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
					"mission_heresy_plaza_03_b",
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
			target = "disabled",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_red_plaza_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_red_plaza_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_red_plaza",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_red_plaza",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_red_plaza",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_red_plaza_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_red_plaza_01_b",
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
					"mission_heresy_red_plaza_01_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_red_plaza_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_red_plaza_01_c",
		wwise_route = 1,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_heresy_red_plaza_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_red_plaza_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_red_plaza_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_red_plaza",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_red_plaza",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_red_plaza",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_red_plaza_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_red_plaza_02_b",
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
					"mission_heresy_red_plaza_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_red_plaza_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_red_plaza_02_c",
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
					"mission_heresy_red_plaza_02_b",
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
			target = "disabled",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_red_plaza_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_red_plaza_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_red_plaza",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_red_plaza",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_red_plaza",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_red_plaza_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_red_plaza_03_b",
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
					"mission_heresy_red_plaza_03_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_red_plaza_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_red_plaza_03_c",
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
					"mission_heresy_red_plaza_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_airlock_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_airlock_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_airlock",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_airlock",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_airlock",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_airlock_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_airlock_01_b",
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
					"mission_heresy_ritual_airlock_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_airlock_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_airlock_01_c",
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
					"mission_heresy_ritual_airlock_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_airlock_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_airlock_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_airlock",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_airlock",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_airlock",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_airlock_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_airlock_02_b",
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
					"mission_heresy_ritual_airlock_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_airlock_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_airlock_02_c",
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
					"mission_heresy_ritual_airlock_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_airlock_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_airlock_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_airlock",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_airlock",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_airlock",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_airlock_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_airlock_03_b",
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
					"mission_heresy_ritual_airlock_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_airlock_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_airlock_03_c",
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
					"mission_heresy_ritual_airlock_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_ambush",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_ambush",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_ambush",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_b",
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
					"mission_heresy_ritual_ambush_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_c",
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
					"mission_heresy_ritual_ambush_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_d",
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
					"mission_heresy_ritual_ambush_c",
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
			target = "disabled",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_e",
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
					"mission_heresy_ritual_ambush_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_end_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_end_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_ambush_end",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_end",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_end",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_end_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_end_01_b",
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
					"mission_heresy_ritual_ambush_end_01_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_end_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_end_01_c",
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
					"mission_heresy_ritual_ambush_end_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_end_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_end_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_ambush_end",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_end",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_end",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_end_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_end_02_b",
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
					"mission_heresy_ritual_ambush_end_02_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_end_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_end_02_c",
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
					"mission_heresy_ritual_ambush_end_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_end_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_end_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_ambush_end",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_end",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_end",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_end_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_end_03_b",
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
					"mission_heresy_ritual_ambush_end_03_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_end_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_end_03_c",
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
					"mission_heresy_ritual_ambush_end_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_ambush_mid",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_mid",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_mid",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_01_b",
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
					"mission_heresy_ritual_ambush_mid_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_01_c",
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
					"mission_heresy_ritual_ambush_mid_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_01_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_01_d",
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
					"mission_heresy_ritual_ambush_mid_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_01_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_01_e",
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
					"mission_heresy_ritual_ambush_mid_01_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_ambush_mid",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_mid",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_mid",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_02_b",
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
					"mission_heresy_ritual_ambush_mid_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_02_c",
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
					"mission_heresy_ritual_ambush_mid_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_02_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_02_d",
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
					"mission_heresy_ritual_ambush_mid_02_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_02_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_02_e",
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
					"mission_heresy_ritual_ambush_mid_02_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_ambush_mid",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_mid",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_mid",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_03_b",
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
					"mission_heresy_ritual_ambush_mid_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_03_c",
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
					"mission_heresy_ritual_ambush_mid_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_03_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_03_d",
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
					"mission_heresy_ritual_ambush_mid_03_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_nemesis_wolfer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_mid_03_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_mid_03_e",
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
					"mission_heresy_ritual_ambush_mid_03_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_monster_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_monster_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_ambush_monster",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_ritualist",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_monster",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_ambush_monster",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_ambush_monster_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_ambush_monster_b",
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
					"mission_heresy_ritual_ambush_monster_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_graffiti_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_graffiti_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_graffiti",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_graffiti",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_graffiti",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_graffiti_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_graffiti_01_b",
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
					"mission_heresy_ritual_graffiti_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_graffiti_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_graffiti_01_c",
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
					"mission_heresy_ritual_graffiti_01_b",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_graffiti_01_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_graffiti_01_d",
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
					"mission_heresy_ritual_graffiti_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_graffiti_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_graffiti_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_graffiti",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_graffiti",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_graffiti",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_graffiti_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_graffiti_02_b",
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
					"mission_heresy_ritual_graffiti_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_graffiti_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_graffiti_02_c",
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
					"mission_heresy_ritual_graffiti_02_b",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_graffiti_02_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_graffiti_02_d",
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
					"mission_heresy_ritual_graffiti_02_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_graffiti_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_graffiti_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_ritual_graffiti",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_ritual_graffiti",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_ritual_graffiti",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_graffiti_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_graffiti_03_b",
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
					"mission_heresy_ritual_graffiti_03_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_graffiti_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_graffiti_03_c",
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
					"mission_heresy_ritual_graffiti_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_ritual_graffiti_03_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_ritual_graffiti_03_d",
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
					"mission_heresy_ritual_graffiti_03_c",
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
			target = "disabled",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_one_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_one_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_safe_zone_part_one",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_safe_zone_part_one",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_safe_zone_part_one",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_one_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_one_01_b",
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
					"mission_heresy_safe_zone_part_one_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_one_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_one_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_safe_zone_part_one",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_safe_zone_part_one",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_safe_zone_part_one",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_one_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_one_02_b",
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
					"mission_heresy_safe_zone_part_one_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_one_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_one_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_safe_zone_part_one",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_safe_zone_part_one",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_safe_zone_part_one",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_one_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_one_03_b",
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
					"mission_heresy_safe_zone_part_one_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_two_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_two_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_safe_zone_part_two",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_safe_zone_part_two",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_safe_zone_part_two",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_two_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_two_01_b",
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
					"mission_heresy_safe_zone_part_two_01_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_two_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_two_01_c",
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
					"mission_heresy_safe_zone_part_two_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_two_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_two_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_safe_zone_part_two",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_safe_zone_part_two",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_safe_zone_part_two",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_two_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_two_02_b",
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
					"mission_heresy_safe_zone_part_two_02_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_two_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_two_02_c",
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
					"mission_heresy_safe_zone_part_two_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_two_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_two_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_heresy_safe_zone_part_two",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_heresy_safe_zone_part_two",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_heresy_safe_zone_part_two",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_two_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_two_03_b",
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
					"mission_heresy_safe_zone_part_two_03_a",
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
			target = "mission_givers",
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
		database = "mission_vo_km_heresy",
		name = "mission_heresy_safe_zone_part_two_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_heresy_safe_zone_part_two_03_c",
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
					"mission_heresy_safe_zone_part_two_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
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
end
