-- chunkname: @dialogues/generated/mission_vo_core_research.lua

return function ()
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_abandoned_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_abandoned_a",
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
				"mission_core_abandoned_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_abandoned_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_abandoned_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_airlock_conversation_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_airlock_conversation_01_a",
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
				"mission_core_airlock_conversation_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
			{
				"faction_memory",
				"mission_core_airlock_conversation_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_airlock_conversation_01_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_airlock_conversation_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_airlock_conversation_01_b",
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
					"mission_core_airlock_conversation_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
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
		database = "mission_vo_core_research",
		name = "mission_core_dead_machine_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_dead_machine_01_b",
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
				"mission_core_dead_machine_01_b",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
			{
				"faction_memory",
				"mission_core_dead_machine_01_b",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_dead_machine_01_b",
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
		database = "mission_vo_core_research",
		name = "mission_core_dead_machine_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_dead_machine_02_a",
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
				"mission_core_dead_machine_02_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_dead_machine_02_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_dead_machine_02_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_elevator_conversation_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_elevator_conversation_01_a",
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
				"mission_core_elevator_conversation_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_elevator_conversation_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_elevator_conversation_01_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_elevator_conversation_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_elevator_conversation_01_b",
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
					"mission_core_elevator_conversation_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_elevator_conversation_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_elevator_conversation_01_c",
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
					"mission_core_elevator_conversation_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
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
		database = "mission_vo_core_research",
		name = "mission_core_elevator_conversation_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_elevator_conversation_02_a",
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
				"mission_core_elevator_conversation_02_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
			{
				"faction_memory",
				"mission_core_elevator_conversation_02_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_elevator_conversation_02_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_elevator_conversation_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_elevator_conversation_02_b",
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
					"mission_core_elevator_conversation_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
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
		database = "mission_vo_core_research",
		name = "mission_core_elevator_conversation_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_elevator_conversation_02_c",
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
					"mission_core_elevator_conversation_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_elevator_conversation_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_elevator_conversation_03_a",
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
				"mission_core_elevator_conversation_03_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_elevator_conversation_03_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_elevator_conversation_03_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_elevator_conversation_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_elevator_conversation_03_b",
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
					"mission_core_elevator_conversation_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_elevator_conversation_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_elevator_conversation_03_c",
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
					"mission_core_elevator_conversation_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
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
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_event_01_briefing_01_a",
		response = "mission_core_event_01_briefing_01_a",
		wwise_route = 54,
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
				"mission_core_event_01_briefing_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_event_01_briefing_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_01_briefing_01_b",
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
					"mission_core_event_01_briefing_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_event_01_briefing_01_c",
		response = "mission_core_event_01_briefing_01_c",
		wwise_route = 54,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_event_01_briefing_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_01_briefing_02_a",
		response = "mission_core_event_01_briefing_02_a",
		wwise_route = 54,
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
				"mission_core_event_01_briefing_02_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_event_01_briefing_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_01_briefing_02_b",
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
					"mission_core_event_01_briefing_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_event_01_briefing_02_c",
		response = "mission_core_event_01_briefing_02_c",
		wwise_route = 54,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_event_01_briefing_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_01_briefing_03_a",
		response = "mission_core_event_01_briefing_03_a",
		wwise_route = 54,
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
				"mission_core_event_01_briefing_03_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_event_01_briefing_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_01_briefing_03_b",
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
					"mission_core_event_01_briefing_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_event_01_briefing_03_c",
		response = "mission_core_event_01_briefing_03_c",
		wwise_route = 54,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_event_01_briefing_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_01_complete_a",
		response = "mission_core_event_01_complete_a",
		wwise_route = 54,
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
				"mission_core_event_01_complete_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_event_01_faulty_widget_a",
		response = "mission_core_event_01_faulty_widget_a",
		wwise_route = 54,
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
				"mission_core_event_01_faulty_widget_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_event_01_faulty_widget_blown_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_01_faulty_widget_blown_a",
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
				"mission_core_event_01_faulty_widget_blown_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_event_01_faulty_widget_fixed_a",
		response = "mission_core_event_01_faulty_widget_fixed_a",
		wwise_route = 54,
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
				"mission_core_event_01_faulty_widget_fixed_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_event_02_almost_done_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_02_almost_done_a",
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
				"mission_core_event_02_almost_done_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
			{
				"faction_memory",
				"mission_core_event_02_almost_done_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_event_02_almost_done_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_02_briefing_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_02_briefing_a",
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
				"mission_core_event_02_briefing_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_event_02_briefing_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_event_02_briefing_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_02_briefing_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_02_briefing_b",
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
					"mission_core_event_02_briefing_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_02_complete_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_02_complete_a",
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
				"mission_core_event_02_complete_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_event_02_complete_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_event_02_complete_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_02_good_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_02_good_start_a",
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
				"mission_core_event_02_good_start_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
			{
				"faction_memory",
				"mission_core_event_02_good_start_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_event_02_good_start_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_02_smash_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_02_smash_a",
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
				"mission_core_event_02_smash_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_event_02_smash_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_event_02_smash_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_02_widget_not_working_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_02_widget_not_working_a",
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
				"mission_core_event_02_widget_not_working_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_event_02_widget_not_working_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_event_02_widget_not_working_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_03_agnostic_a",
		response = "mission_core_event_03_agnostic_a",
		wwise_route = 54,
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
				"mission_core_event_03_agnostic_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_event_03_batteries_a",
		response = "mission_core_event_03_batteries_a",
		wwise_route = 54,
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
				"mission_core_event_03_batteries_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_event_03_briefing_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_03_briefing_a",
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
					"mission_core_event_02_complete_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_03_briefing_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_03_briefing_b",
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
					"mission_core_event_03_briefing_a_disabled",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_03_cables_a",
		response = "mission_core_event_03_cables_a",
		wwise_route = 54,
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
				"mission_core_event_03_cables_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_event_03_calibrate_a",
		response = "mission_core_event_03_calibrate_a",
		wwise_route = 54,
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
				"mission_core_event_03_calibrate_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_event_03_end_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_03_end_a",
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
				"mission_core_event_03_end_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_event_03_end_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_event_03_end_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_03_end_b",
		response = "mission_core_event_03_end_b",
		wwise_route = 54,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_event_03_end_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_event_03_objective_complete_a",
		response = "mission_core_event_03_objective_complete_a",
		wwise_route = 54,
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
				"mission_core_event_03_objective_complete_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_event_03_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_03_start_a",
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
					"mission_core_valk_arrives_01_a",
					"mission_core_valk_arrives_01_a_response",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_03_start_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_03_start_b",
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
					"mission_core_event_03_start_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
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
		database = "mission_vo_core_research",
		name = "mission_core_event_03_start_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_event_03_start_c",
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
					"mission_core_event_03_start_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_objective_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_objective_01_a",
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
				"mission_core_objective_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
			{
				"faction_memory",
				"mission_core_objective_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_objective_01_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_objective_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_objective_01_b",
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
					"mission_core_objective_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
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
		database = "mission_vo_core_research",
		name = "mission_core_objective_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_objective_01_c",
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
					"mission_core_objective_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_objective_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_objective_02_a",
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
				"mission_core_objective_02_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_objective_02_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_objective_02_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_objective_02_b",
		response = "mission_core_objective_02_b",
		wwise_route = 53,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_objective_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_platform_conversation_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_platform_conversation_01_a",
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
				"mission_core_platform_conversation_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_platform_conversation_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_platform_conversation_01_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_platform_conversation_01_b",
		response = "mission_core_platform_conversation_01_b",
		wwise_route = 53,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_platform_conversation_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_platform_conversation_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_platform_conversation_01_c",
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
					"mission_core_platform_conversation_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_platform_conversation_01_d",
		response = "mission_core_platform_conversation_01_d",
		wwise_route = 53,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_platform_conversation_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_platform_conversation_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_platform_conversation_02_a",
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
				"mission_core_platform_conversation_02_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_platform_conversation_02_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_platform_conversation_02_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_platform_conversation_02_b",
		response = "mission_core_platform_conversation_02_b",
		wwise_route = 53,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_platform_conversation_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_platform_conversation_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_platform_conversation_02_c",
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
					"mission_core_platform_conversation_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_platform_conversation_02_d",
		response = "mission_core_platform_conversation_02_d",
		wwise_route = 53,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_platform_conversation_02_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_platform_conversation_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_platform_conversation_03_a",
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
				"mission_core_platform_conversation_03_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_platform_conversation_03_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_platform_conversation_03_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_platform_conversation_03_b",
		response = "mission_core_platform_conversation_03_b",
		wwise_route = 53,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_platform_conversation_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_platform_conversation_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_platform_conversation_03_c",
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
					"mission_core_platform_conversation_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_platform_conversation_03_d",
		response = "mission_core_platform_conversation_03_d",
		wwise_route = 53,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_platform_conversation_03_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_platform_hurry_a",
		response = "mission_core_platform_hurry_a",
		wwise_route = 53,
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
				"mission_core_platform_hurry_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_platform_idle_a",
		response = "mission_core_platform_idle_a",
		wwise_route = 53,
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
				"mission_core_platform_idle_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_a",
		response = "mission_core_safe_zone_a",
		wwise_route = 53,
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
				"mission_core_safe_zone_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_safe_zone_b",
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
					"mission_core_safe_zone_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_c",
		response = "mission_core_safe_zone_c",
		wwise_route = 53,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_safe_zone_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_safe_zone_d",
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
					"mission_core_safe_zone_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_e",
		response = "mission_core_safe_zone_e",
		wwise_route = 53,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_safe_zone_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default_class",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_hurry_along_a",
		response = "mission_core_safe_zone_hurry_along_a",
		wwise_route = 53,
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
				"mission_core_safe_zone_hurry_along_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_optional_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_safe_zone_optional_01_a",
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
				"mission_core_safe_zone_optional_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_safe_zone_optional_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_safe_zone_optional_01_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_optional_01_b",
		response = "mission_core_safe_zone_optional_01_b",
		wwise_route = 53,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_safe_zone_optional_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_optional_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_safe_zone_optional_01_c",
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
					"mission_core_safe_zone_optional_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
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
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_optional_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_safe_zone_optional_02_a",
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
				"mission_core_safe_zone_optional_02_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_safe_zone_optional_02_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_safe_zone_optional_02_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_optional_02_b",
		response = "mission_core_safe_zone_optional_02_b",
		wwise_route = 53,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_safe_zone_optional_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_optional_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_safe_zone_optional_02_c",
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
					"mission_core_safe_zone_optional_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
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
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_optional_03_a",
		response = "mission_core_safe_zone_optional_03_a",
		wwise_route = 53,
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
				"mission_core_safe_zone_optional_03_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_optional_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_safe_zone_optional_03_b",
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
					"mission_core_safe_zone_optional_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_safe_zone_optional_03_c",
		response = "mission_core_safe_zone_optional_03_c",
		wwise_route = 53,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_safe_zone_optional_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
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
		category = "conversations_prio_1",
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_01_a",
		response = "mission_core_short_conversation_01_a",
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
					"veteran_male_a",
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
				"mission_core_short_conversation_01_a",
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
				"mission_core_short_conversation_01_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_01_b",
		response = "mission_core_short_conversation_01_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_short_conversation_01_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_02_a",
		response = "mission_core_short_conversation_02_a",
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
					"veteran_female_b",
					"veteran_male_b",
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
				"mission_core_short_conversation_02_a",
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
				"mission_core_short_conversation_02_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_02_b",
		response = "mission_core_short_conversation_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_short_conversation_02_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_03_a",
		response = "mission_core_short_conversation_03_a",
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
					"veteran_male_c",
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
				"mission_core_short_conversation_03_a",
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
				"mission_core_short_conversation_03_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_03_b",
		response = "mission_core_short_conversation_03_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_short_conversation_03_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_04_a",
		response = "mission_core_short_conversation_04_a",
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
					"zealot_male_a",
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
				"mission_core_short_conversation_04_a",
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
				"mission_core_short_conversation_04_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_04_b",
		response = "mission_core_short_conversation_04_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_short_conversation_04_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_05_a",
		response = "mission_core_short_conversation_05_a",
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
					"zealot_male_b",
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
				"mission_core_short_conversation_05_a",
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
				"mission_core_short_conversation_05_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_05_b",
		response = "mission_core_short_conversation_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_short_conversation_05_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_06_a",
		response = "mission_core_short_conversation_06_a",
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
					"zealot_male_c",
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
				"mission_core_short_conversation_06_a",
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
				"mission_core_short_conversation_06_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_06_b",
		response = "mission_core_short_conversation_06_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_short_conversation_06_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_07_a",
		response = "mission_core_short_conversation_07_a",
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
					"psyker_male_a",
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
				"mission_core_short_conversation_07_a",
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
				"mission_core_short_conversation_07_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_07_b",
		response = "mission_core_short_conversation_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_short_conversation_07_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_08_a",
		response = "mission_core_short_conversation_08_a",
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
					"psyker_male_b",
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
				"mission_core_short_conversation_08_a",
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
				"mission_core_short_conversation_08_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_08_b",
		response = "mission_core_short_conversation_08_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_short_conversation_08_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_09_a",
		response = "mission_core_short_conversation_09_a",
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
				"mission_core_short_conversation_09_a",
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
				"mission_core_short_conversation_09_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_09_b",
		response = "mission_core_short_conversation_09_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_short_conversation_09_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_10_a",
		response = "mission_core_short_conversation_10_a",
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
				"mission_core_short_conversation_10_a",
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
				"mission_core_short_conversation_10_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_10_b",
		response = "mission_core_short_conversation_10_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_short_conversation_10_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_11_a",
		response = "mission_core_short_conversation_11_a",
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
					"ogryn_a",
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
				"mission_core_short_conversation_11_a",
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
				"mission_core_short_conversation_11_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_11_b",
		response = "mission_core_short_conversation_11_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_short_conversation_11_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_12_a",
		response = "mission_core_short_conversation_12_a",
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
					"ogryn_a",
					"ogryn_b",
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
				"mission_core_short_conversation_12_a",
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
				"mission_core_short_conversation_12_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_short_conversation_12_b",
		response = "mission_core_short_conversation_12_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_core_short_conversation_12_a",
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
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_swagger_sighted_01_a",
		response = "mission_core_swagger_sighted_01_a",
		wwise_route = 53,
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
				"mission_core_swagger_sighted_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_swagger_sighted_02_a",
		response = "mission_core_swagger_sighted_02_a",
		wwise_route = 53,
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
				"mission_core_swagger_sighted_02_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "mission_vo_core_research",
		name = "mission_core_swagger_sighted_03_a",
		response = "mission_core_swagger_sighted_03_a",
		wwise_route = 53,
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
				"mission_core_swagger_sighted_03_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_core_research",
		name = "mission_core_valk_arrives_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_valk_arrives_01_a",
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
				"mission_core_valk_arrives_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cargo_pilot",
				},
			},
			{
				"faction_memory",
				"mission_core_valk_arrives_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_valk_arrives_01_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_valk_arrives_01_a_response",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_valk_arrives_01_a_response",
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
					"mission_core_event_03_briefing_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cargo_pilot",
				},
			},
			{
				"user_memory",
				"valk_triggered",
				OP.EQ,
				1,
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
		database = "mission_vo_core_research",
		name = "mission_core_valk_arrives_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_valk_arrives_02_a",
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
				"mission_core_valk_arrives_02_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cargo_pilot",
				},
			},
			{
				"faction_memory",
				"mission_core_valk_arrives_02_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_valk_arrives_02_a",
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
		database = "mission_vo_core_research",
		name = "mission_core_void_vista_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_core_void_vista_a",
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
				"mission_core_void_vista_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_core_void_vista_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_core_void_vista_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
end
