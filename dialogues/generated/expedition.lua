-- chunkname: @dialogues/generated/expedition.lua

return function ()
	define_rule({
		category = "player_prio_0",
		database = "expedition",
		name = "expedition_elevator_coming",
		response = "expedition_elevator_coming",
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
				"expedition_elevator_coming",
			},
			{
				"faction_memory",
				"expedition_elevator_coming",
				OP.TIMEDIFF,
				OP.GT,
				300,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expedition_elevator_coming",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_alarm_triggered_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_alarm_triggered_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_alarm_triggered_a",
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
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_opportunity",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_alarm_triggered_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_alarm_triggered_b",
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
					"expeditions_alarm_triggered_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		database = "expedition",
		name = "expeditions_artillery_support_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_artillery_support_a",
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
				"expeditions_artillery_support_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "expedition",
		name = "expeditions_call_extraction_a",
		response = "expeditions_call_extraction_a",
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
				"expeditions_call_extraction_a",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_call_extraction_pilot_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_call_extraction_pilot_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_call_extraction",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"dummy_memory",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"dummy_memory_2",
				OP.EQ,
				0,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.5,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_chest_locked_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_chest_locked_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_chest_locked_a",
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
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_opportunity",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_chest_unlocked_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_chest_unlocked_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_chest_unlocked_a",
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
			{
				"faction_memory",
				"expeditions_chest_unlocked_a",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_chest_unlocked_a",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_distraction_end_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_distraction_end_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_distraction_end_a",
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
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_distraction_start_a",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_distraction_start_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_distraction_start_a",
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
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_opportunity",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_distraction_start_b",
		post_wwise_event = "play_radio_static_end",
		response = "expeditions_distraction_start_b",
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
					"expeditions_distraction_start_a",
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
		database = "expedition",
		name = "expeditions_extraction_reminder_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_extraction_reminder_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_extraction_reminder_a",
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
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_alert_extraction_response_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_alert_extraction_response_a",
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
					"expeditions_call_extraction_a",
					"expeditions_call_extraction_pilot_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector",
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
		database = "expedition",
		name = "expeditions_heat_alert_heat_drop_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_alert_heat_drop_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"drop",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"alert",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_alert_heat_rise_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_alert_heat_rise_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"rise",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"alert",
				},
			},
			{
				"faction_memory",
				"heat_vo_disabled",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_alert_horde_vector_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_alert_horde_vector_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"horde_spawn",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"alert",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_alert_monster_spawned_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_alert_monster_spawned_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"monster_spawn",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"undetected",
					"alert",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_alert_opportunity_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_alert_opportunity_start_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"opportunity_started",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"alert",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"heat_vo_disabled",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"last_opportunity",
				OP.TIMEDIFF,
				OP.LT,
				20,
			},
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 8,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_alert_safe_room_entered_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_alert_safe_room_entered_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"safe_room_entered",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"none",
					"undetected",
					"alert",
					"detected",
					"max",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_alert_safe_room_event_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_alert_safe_room_event_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"safe_room_event",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"none",
					"undetected",
					"alert",
					"detected",
					"max",
				},
			},
			{
				"faction_memory",
				"dummy",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				0,
			},
			{
				"faction_memory",
				"heat_vo_disabled",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_detected_heat_drop_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_detected_heat_drop_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"drop",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"detected",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_detected_heat_rise_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_detected_heat_rise_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"rise",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"detected",
				},
			},
			{
				"faction_memory",
				"heat_vo_disabled",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_detected_horde_vector_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_detected_horde_vector_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"horde_spawn",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"detected",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_detected_loner_targeted_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_detected_loner_targeted_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"loner_targeted",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"detected",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_detected_monster_spawned_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_detected_monster_spawned_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"monster_spawn",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"detected",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_detected_opportunity_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_detected_opportunity_start_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"opportunity_started",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"detected",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"heat_vo_disabled",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"last_opportunity",
				OP.TIMEDIFF,
				OP.LT,
				20,
			},
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 8,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_detected_opportunity_start_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_detected_opportunity_start_b",
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
					"expeditions_heat_detected_opportunity_start_a",
					"expeditions_heat_alert_opportunity_start_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		database = "expedition",
		name = "expeditions_heat_detected_safe_room_exit_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_detected_safe_room_exit_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"safe_room_exited",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"detected",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"last_new_area",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_max_heat_rise_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_max_heat_rise_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"rise",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"max",
				},
			},
			{
				"faction_memory",
				"heat_vo_disabled",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_max_horde_vector_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_max_horde_vector_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"horde_spawn",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"max",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_max_monster_spawned_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_max_monster_spawned_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"monster_spawn",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"max",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_max_opportunity_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_max_opportunity_start_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"opportunity_started",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"max",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"heat_vo_disabled",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"last_opportunity",
				OP.TIMEDIFF,
				OP.LT,
				20,
			},
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 8,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_max_opportunity_start_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_max_opportunity_start_b",
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
					"expeditions_heat_max_opportunity_start_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		database = "expedition",
		name = "expeditions_heat_max_patrol_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_max_patrol_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"trickle_horde_spawn",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"max",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_max_safe_room_exit_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_max_safe_room_exit_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"safe_room_exited",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"max",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"last_new_area",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_undetected_heat_drop_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_undetected_heat_drop_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"drop",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"undetected",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_undetected_heat_rise_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_undetected_heat_rise_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"rise",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"undetected",
				},
			},
			{
				"faction_memory",
				"heat_vo_disabled",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_undetected_opportunity_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_undetected_opportunity_start_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"opportunity_started",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"none",
					"undetected",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"heat_vo_disabled",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"last_opportunity",
				OP.TIMEDIFF,
				OP.LT,
				20,
			},
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 8,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_heat_undetected_opportunity_start_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_heat_undetected_opportunity_start_b",
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
					"expeditions_heat_undetected_opportunity_start_a",
					"expeditions_heat_alert_opportunity_start_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		category = "npc_prio_0",
		database = "expedition",
		name = "expeditions_loot_converter_a",
		response = "expeditions_loot_converter_a",
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
				"expeditions_loot_converter_a",
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
				"data_reliquary_carried",
				OP.EQ,
				1,
			},
			{
				"faction_memory",
				"last_loot_converter",
				OP.TIMEDIFF,
				OP.GT,
				300,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_loot_converter",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_mission_forced_extraction_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_mission_forced_extraction_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_mission_forced_extraction_a",
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
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 3,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_mission_new_area_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_mission_new_area_start_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heat_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"safe_room_exited",
				},
			},
			{
				"query_context",
				"heat_stage",
				OP.SET_INCLUDES,
				args = {
					"none",
					"undetected",
					"alert",
				},
			},
			{
				"faction_memory",
				"heat_vo",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"heat_vo",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"last_new_area",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_mission_start_a",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_mission_start_a",
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
				"expeditions_mission_start_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"expeditions_mission_start_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_mission_start_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "all_including_self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_mission_start_b",
		post_wwise_event = "play_radio_static_end",
		response = "expeditions_mission_start_b",
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
					"expeditions_mission_start_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"expeditions_mission_start_b",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_mission_start_b",
				OP.ADD,
				1,
			},
		},
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
		database = "expedition",
		name = "expeditions_mission_start_c",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_mission_start_c",
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
					"expeditions_mission_start_b",
					"expeditions_mission_start_a",
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
			{
				"faction_memory",
				"expeditions_mission_start_b",
				OP.EQ,
				1,
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
		database = "expedition",
		name = "expeditions_mission_start_circumstance_001_lightning_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_mission_start_circumstance_001_lightning_a",
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
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_exp_lightning",
				},
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"expeditions_mission_start_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		database = "expedition",
		name = "expeditions_mission_start_circumstance_002_flies_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_mission_start_circumstance_002_flies_a",
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
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_exp_flies",
				},
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"expeditions_mission_start_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		database = "expedition",
		name = "expeditions_mission_start_circumstance_003_tornado_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_mission_start_circumstance_003_tornado_a",
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
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_exp_vortex",
				},
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"expeditions_mission_start_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		database = "expedition",
		name = "expeditions_mission_start_circumstance_004_sandstorms_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_mission_start_circumstance_004_sandstorms_a",
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
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_exp_sandstorm",
				},
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"expeditions_mission_start_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		database = "expedition",
		name = "expeditions_mission_start_circumstance_005_tox_gas_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_mission_start_circumstance_005_tox_gas_a",
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
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_exp_toxic_gas",
				},
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"expeditions_mission_start_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		database = "expedition",
		name = "expeditions_mission_start_circumstance_006_minefield_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_mission_start_circumstance_006_minefield_a",
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
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_exp_minefield",
				},
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"expeditions_mission_start_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		database = "expedition",
		name = "expeditions_mission_start_d",
		post_wwise_event = "play_radio_static_end",
		response = "expeditions_mission_start_d",
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
					"expeditions_mission_start_c",
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
		database = "expedition",
		name = "expeditions_opportunities_no_more_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_opportunities_no_more_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_opportunities_no_more_a",
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
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
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
				duration = 2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_opportunity_start_first_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_opportunity_start_first_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_power_out_a",
					"expeditions_chest_locked_a",
					"expeditions_sealed_door_a",
					"expeditions_place_explosives_a",
					"expeditions_distraction_start_a",
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
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a_perma",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"last_opportunity",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a_perma",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_place_explosives_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_place_explosives_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_place_explosives_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_opportunity",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_power_out_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_power_out_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_power_out_a",
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
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_opportunity",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_power_restored_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_power_restored_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_power_restored_a",
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
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_sealed_door_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_sealed_door_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_sealed_door_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"expeditions_opportunity_start_first_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_opportunity",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "expedition",
		name = "expeditions_sentry_gun_activated_a",
		response = "expeditions_sentry_gun_activated_a",
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
				"expeditions_sentry_gun_activated_a",
			},
			{
				"faction_memory",
				"expeditions_sentry_gun_activated_a",
				OP.TIMEDIFF,
				OP.GT,
				3,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_sentry_gun_activated_a",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "expedition",
		name = "expeditions_sentry_gun_deactivated_a",
		response = "expeditions_sentry_gun_deactivated_a",
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
				"expeditions_sentry_gun_deactivated_a",
			},
			{
				"faction_memory",
				"expeditions_sentry_gun_deactivated_a",
				OP.TIMEDIFF,
				OP.GT,
				3,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_sentry_gun_deactivated_a",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_shield_deployed_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_shield_deployed_a",
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
				"expeditions_shield_deployed_a",
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
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.5,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_shop_door_triggered_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_shop_door_triggered_a",
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
					"expeditions_heat_alert_safe_room_event_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
		database = "expedition",
		name = "expeditions_shop_exit_reminder_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_shop_exit_reminder_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_shop_exit_reminder_a",
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
			{
				"faction_memory",
				"last_new_area",
				OP.TIMEDIFF,
				OP.GT,
				120,
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
		database = "expedition",
		name = "expeditions_shop_found_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_shop_found_a",
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
				OP.SET_INCLUDES,
				args = {
					"expeditions_shop_found_a",
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
	})
	define_rule({
		category = "npc_prio_0",
		database = "expedition",
		name = "expeditions_shop_goodbye_a",
		response = "expeditions_shop_goodbye_a",
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
				"expeditions_shop_goodbye_a",
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
				"expeditions_shop_goodbye_a",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_shop_goodbye_a",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "expedition",
		name = "expeditions_shop_greeting_a",
		response = "expeditions_shop_greeting_a",
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
				"expeditions_shop_greeting_a",
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
				"expeditions_shop_greeting_a",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_shop_greeting_a",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "expedition",
		name = "expeditions_shop_purchase_a",
		response = "expeditions_shop_purchase_a",
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
				"expeditions_shop_purchase_a",
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
				"expeditions_shop_purchase_a",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_shop_purchase_a",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_sighted_first_data_reliquary_a",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_sighted_first_data_reliquary_a",
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
				"data_reliquary",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				0,
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
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"expeditions_sighted_first_data_reliquary_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_sighted_first_data_reliquary_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_sighted_first_data_reliquary_b",
		post_wwise_event = "play_radio_static_end",
		response = "expeditions_sighted_first_data_reliquary_b",
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
					"expeditions_sighted_first_data_reliquary_a",
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
		database = "expedition",
		name = "expeditions_sighted_first_salvage_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_sighted_first_salvage_a",
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
				"salvage",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				0,
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
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"expeditions_sighted_first_salvage_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_sighted_first_salvage_a",
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
		database = "expedition",
		name = "expeditions_sighted_first_tech_remnants_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_sighted_first_tech_remnants_a",
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
				"tech_remnants",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				0,
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
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"expeditions_sighted_first_tech_remnants_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_sighted_first_tech_remnants_a",
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
		database = "expedition",
		name = "expeditions_valkyrie_support_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_valkyrie_support_a",
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
				"expeditions_valkyrie_support_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"expeditions_valkyrie_support",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_valkyrie_support",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "expeditions_valkyrie_support_hover_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "expeditions_valkyrie_support_hover_a",
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
				"expeditions_valkyrie_support_hover_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"expeditions_valkyrie_support",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"faction_memory",
				"expeditions_valkyrie_support",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "expedition",
		name = "mission_wastes_short_conversation_01_a",
		response = "mission_wastes_short_conversation_01_a",
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
				OP.NEQ,
				"true_disabled",
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
					"ogryn_d",
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
				"mission_wastes_short_conversation_01_a",
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
				"mission_wastes_short_conversation_01_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_01_b",
		response = "mission_wastes_short_conversation_01_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_wastes_short_conversation_01_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_02_a",
		response = "mission_wastes_short_conversation_02_a",
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
				OP.NEQ,
				"true_disabled",
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
					"ogryn_d",
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
				"mission_wastes_short_conversation_02_a",
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
				"mission_wastes_short_conversation_02_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_02_b",
		response = "mission_wastes_short_conversation_02_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_wastes_short_conversation_02_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_03_a",
		response = "mission_wastes_short_conversation_03_a",
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
				OP.NEQ,
				"true_disabled",
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
					"ogryn_d",
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
				"mission_wastes_short_conversation_03_a",
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
				"mission_wastes_short_conversation_03_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_03_b",
		response = "mission_wastes_short_conversation_03_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_wastes_short_conversation_03_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_04_a",
		response = "mission_wastes_short_conversation_04_a",
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
				OP.NEQ,
				"true_disabled",
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
					"ogryn_d",
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
				"mission_wastes_short_conversation_04_a",
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
				"mission_wastes_short_conversation_04_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_04_b",
		response = "mission_wastes_short_conversation_04_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_wastes_short_conversation_04_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_05_a",
		response = "mission_wastes_short_conversation_05_a",
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
				OP.NEQ,
				"true_disabled",
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
					"ogryn_d",
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
				"mission_wastes_short_conversation_05_a",
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
				"mission_wastes_short_conversation_05_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_05_b",
		response = "mission_wastes_short_conversation_05_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_wastes_short_conversation_05_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_06_a",
		response = "mission_wastes_short_conversation_06_a",
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
				OP.NEQ,
				"true_disabled",
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
					"ogryn_d",
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
				"mission_wastes_short_conversation_06_a",
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
				"mission_wastes_short_conversation_06_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_06_b",
		response = "mission_wastes_short_conversation_06_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_wastes_short_conversation_06_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_07_a",
		response = "mission_wastes_short_conversation_07_a",
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
				OP.NEQ,
				"true_disabled",
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
					"ogryn_d",
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
				"mission_wastes_short_conversation_07_a",
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
				"mission_wastes_short_conversation_07_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_07_b",
		response = "mission_wastes_short_conversation_07_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_wastes_short_conversation_07_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_08_a",
		response = "mission_wastes_short_conversation_08_a",
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
				OP.NEQ,
				"true_disabled",
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
					"ogryn_d",
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
				"mission_wastes_short_conversation_08_a",
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
				"mission_wastes_short_conversation_08_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_08_b",
		response = "mission_wastes_short_conversation_08_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_wastes_short_conversation_08_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_09_a",
		response = "mission_wastes_short_conversation_09_a",
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
				OP.NEQ,
				"true_disabled",
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
					"ogryn_d",
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
				"mission_wastes_short_conversation_09_a",
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
				"mission_wastes_short_conversation_09_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_09_b",
		response = "mission_wastes_short_conversation_09_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_wastes_short_conversation_09_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_10_a",
		response = "mission_wastes_short_conversation_10_a",
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
				OP.NEQ,
				"true_disabled",
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
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"ogryn_d",
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
				"mission_wastes_short_conversation_10_a",
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
				"mission_wastes_short_conversation_10_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_10_b",
		response = "mission_wastes_short_conversation_10_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_wastes_short_conversation_10_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_11_a",
		response = "mission_wastes_short_conversation_11_a",
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
				OP.NEQ,
				"true_disabled",
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
					"ogryn_b",
					"ogryn_c",
					"ogryn_d",
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
				"mission_wastes_short_conversation_11_a",
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
				"mission_wastes_short_conversation_11_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_11_b",
		response = "mission_wastes_short_conversation_11_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_wastes_short_conversation_11_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_12_a",
		response = "mission_wastes_short_conversation_12_a",
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
				OP.NEQ,
				"true_disabled",
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
					"ogryn_c",
					"ogryn_d",
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
				"mission_wastes_short_conversation_12_a",
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
				"mission_wastes_short_conversation_12_a",
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
		database = "expedition",
		name = "mission_wastes_short_conversation_12_b",
		response = "mission_wastes_short_conversation_12_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_wastes_short_conversation_12_a",
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
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_001_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_001_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_001_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_001_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_001_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_001_b",
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
					"zenica_combat_pause_npc_001_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_001_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_001_c",
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
					"zenica_combat_pause_npc_001_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_001_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_001_d",
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
					"zenica_combat_pause_npc_001_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_002_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_002_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_002_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_002_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_002_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_002_b",
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
					"zenica_combat_pause_npc_002_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_002_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_002_c",
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
					"zenica_combat_pause_npc_002_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_002_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_002_d",
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
					"zenica_combat_pause_npc_002_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_003_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_003_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_003_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_003_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_003_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_003_b",
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
					"zenica_combat_pause_npc_003_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_003_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_003_c",
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
					"zenica_combat_pause_npc_003_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_003_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_003_d",
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
					"zenica_combat_pause_npc_003_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_003_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_003_e",
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
					"zenica_combat_pause_npc_003_d",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_004_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_004_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_004_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_004_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_004_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_004_b",
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
					"zenica_combat_pause_npc_004_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_004_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_004_c",
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
					"zenica_combat_pause_npc_004_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_004_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_004_d",
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
					"zenica_combat_pause_npc_004_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_005_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_005_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_005_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_005_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_005_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_005_b",
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
					"zenica_combat_pause_npc_005_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_005_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_005_c",
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
					"zenica_combat_pause_npc_005_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_005_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_005_d",
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
					"zenica_combat_pause_npc_005_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_005_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_005_e",
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
					"zenica_combat_pause_npc_005_d",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_006_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_006_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_006_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_006_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_006_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_006_b",
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
					"zenica_combat_pause_npc_006_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_006_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_006_c",
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
					"zenica_combat_pause_npc_006_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_006_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_006_d",
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
					"zenica_combat_pause_npc_006_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_007_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_007_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_007_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_007_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_007_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_007_b",
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
					"zenica_combat_pause_npc_007_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_007_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_007_c",
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
					"zenica_combat_pause_npc_007_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_007_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_007_d",
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
					"zenica_combat_pause_npc_007_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_008_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_008_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_008_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_008_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_008_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_008_b",
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
					"zenica_combat_pause_npc_008_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_008_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_008_c",
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
					"zenica_combat_pause_npc_008_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_008_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_008_d",
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
					"zenica_combat_pause_npc_008_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_009_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_009_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_009_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_009_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_009_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_009_b",
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
					"zenica_combat_pause_npc_009_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_009_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_009_c",
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
					"zenica_combat_pause_npc_009_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_009_d",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_009_d",
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
					"zenica_combat_pause_npc_009_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_009_e",
		post_wwise_event = "play_radio_static_end",
		response = "zenica_combat_pause_npc_009_e",
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
					"zenica_combat_pause_npc_009_d",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_010_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_010_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_010_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_010_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_010_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_010_b",
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
					"zenica_combat_pause_npc_010_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_010_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_010_c",
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
					"zenica_combat_pause_npc_010_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_010_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_010_d",
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
					"zenica_combat_pause_npc_010_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_011_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_011_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_011_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_011_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_011_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_011_b",
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
					"zenica_combat_pause_npc_011_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_011_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_011_c",
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
					"zenica_combat_pause_npc_011_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_011_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_011_d",
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
					"zenica_combat_pause_npc_011_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_012_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_012_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_012_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_012_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_012_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_012_b",
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
					"zenica_combat_pause_npc_012_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_012_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_012_c",
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
					"zenica_combat_pause_npc_012_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_012_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_012_d",
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
					"zenica_combat_pause_npc_012_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_013_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_013_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_013_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_013_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_013_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_013_b",
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
					"zenica_combat_pause_npc_013_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_013_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_013_c",
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
					"zenica_combat_pause_npc_013_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_013_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_013_d",
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
					"zenica_combat_pause_npc_013_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_014_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_014_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_014_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_014_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_014_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_014_b",
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
					"zenica_combat_pause_npc_014_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_014_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_014_c",
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
					"zenica_combat_pause_npc_014_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_014_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_014_d",
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
					"zenica_combat_pause_npc_014_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_015_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_015_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_015_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_015_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_015_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_015_b",
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
					"zenica_combat_pause_npc_015_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_015_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_015_c",
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
					"zenica_combat_pause_npc_015_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_015_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_015_d",
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
					"zenica_combat_pause_npc_015_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_016_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_016_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_016_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_016_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_016_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_016_b",
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
					"zenica_combat_pause_npc_016_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_016_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_016_c",
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
					"zenica_combat_pause_npc_016_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_016_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_016_d",
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
					"zenica_combat_pause_npc_016_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_016_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_016_e",
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
					"zenica_combat_pause_npc_016_d",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_016_f",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_016_f",
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
					"zenica_combat_pause_npc_016_e",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_017_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_017_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_017_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_017_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_017_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_017_b",
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
					"zenica_combat_pause_npc_017_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_017_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_017_c",
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
					"zenica_combat_pause_npc_017_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_017_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_017_d",
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
					"zenica_combat_pause_npc_017_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_018_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_018_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_018_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_018_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_018_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_018_b",
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
					"zenica_combat_pause_npc_018_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_018_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_018_c",
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
					"zenica_combat_pause_npc_018_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_018_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_018_d",
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
					"zenica_combat_pause_npc_018_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_019_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_019_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_019_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_019_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_019_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_019_b",
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
					"zenica_combat_pause_npc_019_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_019_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_019_c",
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
					"zenica_combat_pause_npc_019_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_019_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_019_d",
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
					"zenica_combat_pause_npc_019_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_020_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_020_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_020_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_020_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_020_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_020_b",
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
					"zenica_combat_pause_npc_020_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_020_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_020_c",
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
					"zenica_combat_pause_npc_020_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_020_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_020_d",
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
					"zenica_combat_pause_npc_020_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_021_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_021_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_021_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_021_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_021_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_021_b",
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
					"zenica_combat_pause_npc_021_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_021_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_021_c",
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
					"zenica_combat_pause_npc_021_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_021_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_021_d",
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
					"zenica_combat_pause_npc_021_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_022_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_022_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_022_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_022_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_022_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_022_b",
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
					"zenica_combat_pause_npc_022_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_022_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_022_c",
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
					"zenica_combat_pause_npc_022_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_022_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_022_d",
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
					"zenica_combat_pause_npc_022_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_022_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_022_e",
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
					"zenica_combat_pause_npc_022_d",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_023_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_023_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_023_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_023_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_023_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_023_b",
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
					"zenica_combat_pause_npc_023_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_023_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_023_c",
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
					"zenica_combat_pause_npc_023_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_023_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_023_d",
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
					"zenica_combat_pause_npc_023_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_024_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_024_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_024_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_024_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_024_b",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_024_b",
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
					"zenica_combat_pause_npc_024_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_024_c",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_024_c",
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
					"zenica_combat_pause_npc_024_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_024_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_024_d",
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
					"zenica_combat_pause_npc_024_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_025_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_025_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_025_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_025_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_025_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_025_b",
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
					"zenica_combat_pause_npc_025_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_025_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_025_c",
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
					"zenica_combat_pause_npc_025_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_025_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_025_d",
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
					"zenica_combat_pause_npc_025_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_025_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_025_e",
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
					"zenica_combat_pause_npc_025_d",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_026_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_026_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_026_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_026_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_026_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_026_b",
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
					"zenica_combat_pause_npc_026_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_026_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_026_c",
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
					"zenica_combat_pause_npc_026_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_026_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_026_d",
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
					"zenica_combat_pause_npc_026_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_027_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_027_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_027_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_027_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_027_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_027_b",
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
					"zenica_combat_pause_npc_027_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_027_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_027_c",
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
					"zenica_combat_pause_npc_027_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_027_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_027_d",
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
					"zenica_combat_pause_npc_027_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_027_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_027_e",
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
					"zenica_combat_pause_npc_027_d",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_028_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_028_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_028_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_028_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_028_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_028_b",
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
					"zenica_combat_pause_npc_028_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_028_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_028_c",
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
					"zenica_combat_pause_npc_028_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_028_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_028_d",
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
					"zenica_combat_pause_npc_028_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_029_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_029_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_029_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_029_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_029_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_029_b",
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
					"zenica_combat_pause_npc_029_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_029_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_029_c",
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
					"zenica_combat_pause_npc_029_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_029_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_029_d",
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
					"zenica_combat_pause_npc_029_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_030_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_030_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_030_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_030_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_030_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_030_b",
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
					"zenica_combat_pause_npc_030_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_030_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_030_c",
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
					"zenica_combat_pause_npc_030_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_030_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_030_d",
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
					"zenica_combat_pause_npc_030_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_031_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_031_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_031_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_031_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_031_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_031_b",
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
					"zenica_combat_pause_npc_031_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_031_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_031_c",
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
					"zenica_combat_pause_npc_031_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_031_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_031_d",
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
					"zenica_combat_pause_npc_031_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_032_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_032_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_032_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_032_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_032_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_032_b",
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
					"zenica_combat_pause_npc_032_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_032_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_032_c",
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
					"zenica_combat_pause_npc_032_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_032_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_032_d",
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
					"zenica_combat_pause_npc_032_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_033_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_033_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_033_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_033_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_033_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_033_b",
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
					"zenica_combat_pause_npc_033_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_033_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_033_c",
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
					"zenica_combat_pause_npc_033_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_033_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_033_d",
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
					"zenica_combat_pause_npc_033_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_034_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_034_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_034_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_034_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_034_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_034_b",
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
					"zenica_combat_pause_npc_034_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_034_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_034_c",
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
					"zenica_combat_pause_npc_034_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_034_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_034_d",
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
					"zenica_combat_pause_npc_034_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_035_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_035_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_035_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_035_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_035_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_035_b",
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
					"zenica_combat_pause_npc_035_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_035_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_035_c",
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
					"zenica_combat_pause_npc_035_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_035_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_035_d",
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
					"zenica_combat_pause_npc_035_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_036_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_036_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_036_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_036_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_036_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_036_b",
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
					"zenica_combat_pause_npc_036_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_036_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_036_c",
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
					"zenica_combat_pause_npc_036_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_036_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_036_d",
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
					"zenica_combat_pause_npc_036_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_037_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_037_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_037_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_037_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_037_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_037_b",
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
					"zenica_combat_pause_npc_037_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_037_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_037_c",
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
					"zenica_combat_pause_npc_037_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_037_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_037_d",
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
					"zenica_combat_pause_npc_037_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_038_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_038_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_038_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_038_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_038_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_038_b",
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
					"zenica_combat_pause_npc_038_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_038_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_038_c",
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
					"zenica_combat_pause_npc_038_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_038_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_038_d",
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
					"zenica_combat_pause_npc_038_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_039_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_039_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_039_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_039_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_039_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_039_b",
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
					"zenica_combat_pause_npc_039_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_039_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_039_c",
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
					"zenica_combat_pause_npc_039_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_039_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_039_d",
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
					"zenica_combat_pause_npc_039_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_040_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_040_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_040_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_040_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_040_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_040_b",
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
					"zenica_combat_pause_npc_040_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_040_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_040_c",
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
					"zenica_combat_pause_npc_040_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_040_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_040_d",
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
					"zenica_combat_pause_npc_040_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_041_a",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_041_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_041_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_041_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_041_b",
		post_wwise_event = "play_radio_static_end",
		response = "zenica_combat_pause_npc_041_b",
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
					"zenica_combat_pause_npc_041_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_041_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_041_c",
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
					"zenica_combat_pause_npc_041_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_041_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_041_d",
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
					"zenica_combat_pause_npc_041_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_042_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_042_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_042_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_042_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_042_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_042_b",
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
					"zenica_combat_pause_npc_042_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_042_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_042_c",
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
					"zenica_combat_pause_npc_042_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_042_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_042_d",
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
					"zenica_combat_pause_npc_042_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_043_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_043_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_043_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_043_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_043_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_043_b",
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
					"zenica_combat_pause_npc_043_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_043_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_043_c",
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
					"zenica_combat_pause_npc_043_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_043_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_043_d",
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
					"zenica_combat_pause_npc_043_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_044_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_044_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_044_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_044_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_044_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_044_b",
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
					"zenica_combat_pause_npc_044_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_044_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_044_c",
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
					"zenica_combat_pause_npc_044_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_044_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_044_d",
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
					"zenica_combat_pause_npc_044_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_045_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_045_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_045_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_045_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_045_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_045_b",
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
					"zenica_combat_pause_npc_045_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_045_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_045_c",
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
					"zenica_combat_pause_npc_045_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_046_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_046_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_046_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_046_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_046_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_046_b",
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
					"zenica_combat_pause_npc_046_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_046_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_046_c",
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
					"zenica_combat_pause_npc_046_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_046_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_046_d",
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
					"zenica_combat_pause_npc_046_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_047_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_047_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_047_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_047_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_047_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_047_b",
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
					"zenica_combat_pause_npc_047_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_047_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_047_c",
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
					"zenica_combat_pause_npc_047_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_047_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_047_d",
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
					"zenica_combat_pause_npc_047_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_048_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_048_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_048_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_048_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_048_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_048_b",
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
					"zenica_combat_pause_npc_048_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_048_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_048_c",
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
					"zenica_combat_pause_npc_048_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_048_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_048_d",
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
					"zenica_combat_pause_npc_048_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_049_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_049_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_049_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_049_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_049_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_049_b",
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
					"zenica_combat_pause_npc_049_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_049_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_049_c",
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
					"zenica_combat_pause_npc_049_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_049_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_049_d",
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
					"zenica_combat_pause_npc_049_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_050_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_050_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_050_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_050_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_050_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_050_b",
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
					"zenica_combat_pause_npc_050_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_050_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_050_c",
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
					"zenica_combat_pause_npc_050_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_050_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_050_d",
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
					"zenica_combat_pause_npc_050_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_056_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_056_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_056_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_056_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_056_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_056_b",
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
					"zenica_combat_pause_npc_056_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_056_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_056_c",
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
					"zenica_combat_pause_npc_056_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_056_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_056_d",
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
					"zenica_combat_pause_npc_056_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_057_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_057_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_057_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_057_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_057_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_057_b",
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
					"zenica_combat_pause_npc_057_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_057_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_057_c",
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
					"zenica_combat_pause_npc_057_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_057_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_057_d",
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
					"zenica_combat_pause_npc_057_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_058_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_058_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_058_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_058_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_058_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_058_b",
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
					"zenica_combat_pause_npc_058_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_058_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_058_c",
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
					"zenica_combat_pause_npc_058_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_058_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_058_d",
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
					"zenica_combat_pause_npc_058_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_059_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_059_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_059_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_059_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_059_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_059_b",
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
					"zenica_combat_pause_npc_059_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_059_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_059_c",
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
					"zenica_combat_pause_npc_059_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_059_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_059_d",
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
					"zenica_combat_pause_npc_059_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_059_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_059_e",
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
					"zenica_combat_pause_npc_059_d",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_060_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_060_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				300,
			},
			{
				"faction_memory",
				"zenica_combat_pause_npc_060_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"expeditions_high_heat",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_060_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_060_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_060_b",
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
					"zenica_combat_pause_npc_060_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_060_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_060_c",
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
					"zenica_combat_pause_npc_060_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_060_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_060_d",
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
					"zenica_combat_pause_npc_060_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_061_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_061_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_061_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_061_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_061_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_061_b",
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
					"zenica_combat_pause_npc_061_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_061_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_061_c",
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
					"zenica_combat_pause_npc_061_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_061_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_061_d",
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
					"zenica_combat_pause_npc_061_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_062_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_062_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_062_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_062_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_062_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_062_b",
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
					"zenica_combat_pause_npc_062_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_062_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_062_c",
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
					"zenica_combat_pause_npc_062_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_062_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_062_d",
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
					"zenica_combat_pause_npc_062_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_063_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_063_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_063_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_063_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_063_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_063_b",
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
					"zenica_combat_pause_npc_063_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_063_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_063_c",
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
					"zenica_combat_pause_npc_063_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_063_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_063_d",
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
					"zenica_combat_pause_npc_063_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_064_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_064_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_064_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_064_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_064_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_064_b",
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
					"zenica_combat_pause_npc_064_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_064_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_064_c",
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
					"zenica_combat_pause_npc_064_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_064_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_064_d",
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
					"zenica_combat_pause_npc_064_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_065_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_065_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_065_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_065_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_065_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_065_b",
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
					"zenica_combat_pause_npc_065_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_065_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_065_c",
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
					"zenica_combat_pause_npc_065_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_065_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_065_d",
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
					"zenica_combat_pause_npc_065_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_066_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_066_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_066_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_066_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_066_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_066_b",
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
					"zenica_combat_pause_npc_066_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_066_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_066_c",
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
					"zenica_combat_pause_npc_066_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_066_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_066_d",
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
					"zenica_combat_pause_npc_066_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_067_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_067_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_067_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_067_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_067_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_067_b",
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
					"zenica_combat_pause_npc_067_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_067_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_067_c",
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
					"zenica_combat_pause_npc_067_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_067_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_067_d",
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
					"zenica_combat_pause_npc_067_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_068_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_068_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_068_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_068_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_068_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_068_b",
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
					"zenica_combat_pause_npc_068_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_068_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_068_c",
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
					"zenica_combat_pause_npc_068_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_068_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_068_d",
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
					"zenica_combat_pause_npc_068_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_069_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_069_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_069_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_069_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_069_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_069_b",
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
					"zenica_combat_pause_npc_069_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_069_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_069_c",
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
					"zenica_combat_pause_npc_069_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_069_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_069_d",
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
					"zenica_combat_pause_npc_069_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_070_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_070_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
				},
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
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
				"zenica_combat_pause_npc_070_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"zenica_combat_pause_npc_070_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_070_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_070_b",
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
					"zenica_combat_pause_npc_070_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_070_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_070_c",
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
					"zenica_combat_pause_npc_070_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"pilot_a",
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
		category = "conversations_prio_1",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "expedition",
		name = "zenica_combat_pause_npc_070_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "zenica_combat_pause_npc_070_d",
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
					"zenica_combat_pause_npc_070_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"tech_priest_a",
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
