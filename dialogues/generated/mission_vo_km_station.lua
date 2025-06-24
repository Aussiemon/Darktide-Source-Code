-- chunkname: @dialogues/generated/mission_vo_km_station.lua

return function ()
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "info_mission_station_first_objective",
		post_wwise_event = "play_radio_static_end",
		response = "info_mission_station_first_objective",
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
					"mission_station_tanks",
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
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "mission_vo_km_station",
		name = "info_mission_station_first_objective_response",
		response = "info_mission_station_first_objective_response",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"info_mission_station_first_objective",
					"info_mission_station_first_objective_response_wolfer_a",
					"mission_station_first_objective_a",
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
		database = "mission_vo_km_station",
		name = "info_mission_station_first_objective_response_wolfer_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_mission_station_first_objective_response_wolfer_a",
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
					"info_mission_station_first_objective_wolfer",
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
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "info_mission_station_first_objective_wolfer",
		response = "info_mission_station_first_objective_wolfer",
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
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_sergeant_b__mission_station_tanks_a_01",
					"loc_sergeant_b__mission_station_tanks_a_02",
					"loc_sergeant_b__mission_station_tanks_a_03",
					"loc_sergeant_b__mission_station_tanks_a_04",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {
			{
				"faction_memory",
				"wolfer_active",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "info_mission_station_second_objective",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_mission_station_second_objective",
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
				"info_mission_station_second_objective",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
				},
			},
			{
				"faction_memory",
				"info_mission_station_second_objective",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"info_mission_station_second_objective",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_airlock_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_airlock_a",
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
				"mission_station_airlock_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_airlock_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_airlock_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_airlock_b",
		post_wwise_event = "play_radio_static_end",
		response = "mission_station_airlock_b",
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
					"mission_station_airlock_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
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
		category = "player_prio_0",
		database = "mission_vo_km_station",
		name = "mission_station_approach",
		response = "mission_station_approach",
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
				"mission_station_approach",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1,
			},
			{
				"query_context",
				"distance",
				OP.LT,
				25,
			},
			{
				"faction_memory",
				"mission_station_approach",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_approach",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_contraband_lockers_wolfer",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_contraband_lockers_wolfer",
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
				"mission_station_contraband_lockers_wolfer",
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
				"mission_station_contraband_lockers_wolfer",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_contraband_lockers_wolfer",
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
		database = "mission_vo_km_station",
		name = "mission_station_contrabrand_lockers",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_contrabrand_lockers",
		wwise_route = 1,
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
				"mission_station_contrabrand_lockers",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1,
			},
			{
				"query_context",
				"distance",
				OP.LT,
				17,
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_contrabrand_lockers",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"wolfer_active",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_contrabrand_lockers",
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
		database = "mission_vo_km_station",
		name = "mission_station_contrabrand_lockers_journey_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_contrabrand_lockers_journey_a",
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
				"mission_station_contrabrand_lockers_journey_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_contrabrand_lockers_journey_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_contrabrand_lockers_journey_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_cross_station",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_cross_station",
		wwise_route = 1,
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
				"mission_station_cross_station",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1,
			},
			{
				"query_context",
				"distance",
				OP.LT,
				30,
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_cross_station",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_cross_station",
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
		database = "mission_vo_km_station",
		name = "mission_station_end_event_complete_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_end_event_complete_a",
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
				"mission_station_end_event_complete_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_end_event_complete_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_end_event_complete_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_end_event_conversation_01_a",
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
				"mission_station_end_event_conversation_01_a",
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
				"mission_station_end_event_conversation",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_end_event_conversation",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"allow_captain_taunt_response",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_end_event_conversation_01_b",
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
					"mission_station_end_event_conversation_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
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
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_02_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_end_event_conversation_02_a",
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
				"mission_station_end_event_conversation_02_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_end_event_conversation",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_end_event_conversation",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"allow_captain_taunt_response",
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
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_end_event_conversation_02_b",
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
					"mission_station_end_event_conversation_02_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_end_event_conversation_a",
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
				"mission_station_end_event_conversation_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_end_event_conversation_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_end_event_conversation_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_b",
		post_wwise_event = "play_radio_static_end",
		response = "mission_station_end_event_conversation_b",
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
					"mission_station_end_event_conversation_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {
			{
				"faction_memory",
				"allow_captain_taunt_response",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
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
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_one_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_end_event_conversation_one_a",
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
				"mission_station_end_event_conversation_one_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_end_event_conversation",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_end_event_conversation",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"allow_captain_taunt_response",
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
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_one_b",
		response = "mission_station_end_event_conversation_one_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_station_end_event_conversation_one_a",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_three_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_end_event_conversation_three_a",
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
				"mission_station_end_event_conversation_three_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_end_event_conversation",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_end_event_conversation",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"allow_captain_taunt_response",
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
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_three_b",
		response = "mission_station_end_event_conversation_three_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_station_end_event_conversation_three_a",
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
		category = "conversations_prio_0",
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_two_a",
		response = "mission_station_end_event_conversation_two_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"environmental_story",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_station_end_event_conversation_two_a",
			},
			{
				"faction_memory",
				"mission_station_end_event_conversation",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_end_event_conversation",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_two_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_end_event_conversation_two_b",
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
					"mission_station_end_event_conversation_two_a",
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
				},
			},
		},
		on_done = {
			{
				"faction_memory",
				"allow_captain_taunt_response",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
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
		database = "mission_vo_km_station",
		name = "mission_station_end_event_conversation_two_c",
		response = "mission_station_end_event_conversation_two_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_station_end_event_conversation_two_b",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_enter_station",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_enter_station",
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
				"mission_station_enter_station",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
					"enemy_nemesis_wolfer",
				},
			},
			{
				"faction_memory",
				"mission_station_enter_station",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_enter_station",
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
		database = "mission_vo_km_station",
		name = "mission_station_first_objective_a",
		post_wwise_event = "play_radio_static_end",
		response = "mission_station_first_objective_a",
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
					"mission_station_start_zone_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_head_to_market",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_head_to_market",
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
				"mission_station_head_to_market",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
					"enemy_nemesis_wolfer",
				},
			},
			{
				"faction_memory",
				"mission_station_head_to_market",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_head_to_market",
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
		database = "mission_vo_km_station",
		name = "mission_station_head_to_market_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_head_to_market_a",
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
				"mission_station_head_to_market_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_head_to_market_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_head_to_market_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_head_to_market_b",
		post_wwise_event = "play_radio_static_end",
		response = "mission_station_head_to_market_b",
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
					"mission_station_head_to_market_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
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
		database = "mission_vo_km_station",
		name = "mission_station_head_to_platform_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_head_to_platform_a",
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
				"mission_station_head_to_platform_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_head_to_platform_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_head_to_platform_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_interrogate_splice_point",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_interrogate_splice_point",
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
				"mission_station_interrogate_splice_point",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
				},
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"",
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
		database = "mission_vo_km_station",
		name = "mission_station_interrogate_splice_point_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_interrogate_splice_point_a",
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
				"mission_station_interrogate_splice_point_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_interrogate_splice_point_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_interrogate_splice_point_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_interrogate_splice_point_b",
		response = "mission_station_interrogate_splice_point_b",
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
					"mission_station_interrogate_splice_point_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
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
		database = "mission_vo_km_station",
		name = "mission_station_interrogate_splice_point_c",
		response = "mission_station_interrogate_splice_point_c",
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
					"mission_station_interrogate_splice_point_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "mission_vo_km_station",
		name = "mission_station_interrogation_bay_a",
		response = "mission_station_interrogation_bay_a",
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
				"mission_station_interrogation_bay_a",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1,
			},
			{
				"query_context",
				"distance",
				OP.LT,
				17,
			},
			{
				"faction_memory",
				"mission_station_interrogation_bay_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_interrogation_bay_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_interrogation_bay_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_interrogation_bay_b",
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
					"mission_station_interrogation_bay_a",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_interrogation_bay_journey_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_interrogation_bay_journey_a",
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
				"mission_station_interrogation_bay_journey_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_interrogation_bay_journey_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_interrogation_bay_journey_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_interrogation_bay_journey_b",
		post_wwise_event = "play_radio_static_end",
		response = "mission_station_interrogation_bay_journey_b",
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
					"mission_station_interrogation_bay_journey_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
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
		category = "player_prio_0",
		database = "mission_vo_km_station",
		name = "mission_station_interrogation_bay_wolfer_branch_a",
		response = "mission_station_interrogation_bay_wolfer_branch_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_station_interrogation_bay_wolfer_branch_a",
			},
			{
				"faction_memory",
				"mission_station_interrogation_bay_wolfer_branch_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_interrogation_bay_wolfer_branch_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_interrogation_bay_wolfer_branch_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_interrogation_bay_wolfer_branch_b",
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
					"mission_station_interrogation_bay_wolfer_branch_a",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_maintenance_bay",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_maintenance_bay",
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
				"mission_station_maintenance_bay",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
					"enemy_nemesis_wolfer",
				},
			},
			{
				"faction_memory",
				"mission_station_maintenance_bay",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_maintenance_bay",
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
		database = "mission_vo_km_station",
		name = "mission_station_maintenance_bay_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_maintenance_bay_a",
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
				"mission_station_maintenance_bay_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_maintenance_bay_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_maintenance_bay_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_maintenance_bay_b",
		post_wwise_event = "play_radio_static_end",
		response = "mission_station_maintenance_bay_b",
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
					"mission_station_maintenance_bay_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_01_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_mid_event_conversation_01_a",
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
				"mission_station_mid_event_conversation_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_mid_event_conversation_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_mid_event_conversation_01_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_mid_event_conversation_01_b",
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
					"mission_station_mid_event_conversation_01_a",
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
			target = "mission_giver_default",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_mid_event_conversation_01_c",
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
					"mission_station_mid_event_conversation_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_02_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_mid_event_conversation_02_a",
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
				"mission_station_mid_event_conversation_02_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_mid_event_conversation_02_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_mid_event_conversation_02_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_mid_event_conversation_02_b",
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
					"mission_station_mid_event_conversation_02_a",
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
			target = "mission_giver_default",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_mid_event_conversation_02_c",
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
					"mission_station_mid_event_conversation_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
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
		category = "conversations_prio_0",
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_one_a",
		response = "mission_station_mid_event_conversation_one_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"environmental_story",
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_station_mid_event_conversation_one_a",
			},
			{
				"faction_memory",
				"mission_station_mid_event_conversation",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_mid_event_conversation",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_one_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_mid_event_conversation_one_b",
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
					"mission_station_mid_event_conversation_one_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_one_c",
		response = "mission_station_mid_event_conversation_one_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_station_mid_event_conversation_one_b",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_three_a",
		response = "mission_station_mid_event_conversation_three_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"environmental_story",
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_station_mid_event_conversation_three_a",
			},
			{
				"faction_memory",
				"mission_station_mid_event_conversation",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_mid_event_conversation",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_three_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_mid_event_conversation_three_b",
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
					"mission_station_mid_event_conversation_three_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_three_c",
		response = "mission_station_mid_event_conversation_three_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_station_mid_event_conversation_three_b",
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
		category = "conversations_prio_0",
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_two_a",
		response = "mission_station_mid_event_conversation_two_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"environmental_story",
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_station_mid_event_conversation_two_a",
			},
			{
				"faction_memory",
				"mission_station_mid_event_conversation",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_mid_event_conversation",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_two_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_mid_event_conversation_two_b",
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
					"mission_station_mid_event_conversation_two_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_event_conversation_two_c",
		response = "mission_station_mid_event_conversation_two_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_station_mid_event_conversation_two_b",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_mid_monologue_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_mid_monologue_a",
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
				"mission_station_mid_monologue_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_mid_monologue_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_mid_monologue_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_monologue_b",
		response = "mission_station_mid_monologue_b",
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
					"mission_station_mid_monologue_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
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
		database = "mission_vo_km_station",
		name = "mission_station_mid_monologue_c",
		post_wwise_event = "play_radio_static_end",
		response = "mission_station_mid_monologue_c",
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
					"mission_station_mid_monologue_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
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
		database = "mission_vo_km_station",
		name = "mission_station_post_monologue_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_post_monologue_a",
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
				"mission_station_post_monologue_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_post_monologue_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_post_monologue_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "mission_vo_km_station",
		name = "mission_station_start_banter_a",
		response = "mission_station_start_banter_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"start_banter",
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"km_station",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled",
			},
			{
				"faction_memory",
				"mission_station_start_banter_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_start_banter_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default_class",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_start_banter_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_start_banter_b",
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
					"mission_station_start_banter_a",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_start_zone_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_start_zone_a",
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
				"mission_station_start_zone_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_start_zone_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_start_zone_a",
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
		database = "mission_vo_km_station",
		name = "mission_station_start_zone_b",
		response = "mission_station_start_zone_b",
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
					"mission_station_start_zone_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
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
		database = "mission_vo_km_station",
		name = "mission_station_start_zone_c",
		response = "mission_station_start_zone_c",
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
					"mission_station_start_zone_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
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
		database = "mission_vo_km_station",
		name = "mission_station_station_approach_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_station_approach_a",
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
					"mission_station_approach",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
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
		category = "player_prio_0",
		database = "mission_vo_km_station",
		name = "mission_station_station_hall",
		response = "mission_station_station_hall",
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
				"mission_station_station_hall",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1,
			},
			{
				"query_context",
				"distance",
				OP.LT,
				36,
			},
			{
				"faction_memory",
				"mission_station_station_hall",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_station_hall",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_tanks",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_tanks",
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
				"mission_station_tanks",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_tanks",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_tanks",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_km_station",
		name = "mission_station_the_bridge",
		response = "mission_station_the_bridge",
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
				"mission_station_the_bridge",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1,
			},
			{
				"query_context",
				"distance",
				OP.LT,
				51,
			},
			{
				"faction_memory",
				"mission_station_the_bridge",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_the_bridge",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_station",
		name = "mission_station_upload_schedule",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_station_upload_schedule",
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
				"mission_station_upload_schedule",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
				},
			},
			{
				"faction_memory",
				"mission_station_upload_schedule",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_station_upload_schedule",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "level_event",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
end
