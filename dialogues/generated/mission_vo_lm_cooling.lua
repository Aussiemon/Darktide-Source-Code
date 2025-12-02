-- chunkname: @dialogues/generated/mission_vo_lm_cooling.lua

return function ()
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_lm_cooling",
		name = "cmd_mission_cooling_hacking_event_end",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_mission_cooling_hacking_event_end",
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
				"cmd_mission_cooling_hacking_event_end",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest",
					"explicator",
				},
			},
			{
				"user_memory",
				"cmd_mission_cooling_hacking_event_end",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cmd_mission_cooling_hacking_event_end",
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
		database = "mission_vo_lm_cooling",
		name = "cmd_mission_cooling_hacking_event_start",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_mission_cooling_hacking_event_start",
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
				"cmd_mission_cooling_hacking_event_start",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"cmd_mission_cooling_hacking_event_start",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"cmd_mission_cooling_hacking_event_start",
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
		database = "mission_vo_lm_cooling",
		name = "cmd_mission_cooling_luggable_event_start",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_mission_cooling_luggable_event_start",
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
				"cmd_mission_cooling_luggable_event_start",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest",
				},
			},
			{
				"user_memory",
				"cmd_mission_cooling_luggable_event_start",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cmd_mission_cooling_luggable_event_start",
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
		database = "mission_vo_lm_cooling",
		name = "info_mission_cooling_coolant_control",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_mission_cooling_coolant_control",
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
				"info_mission_cooling_coolant_control",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest",
					"explicator",
				},
			},
			{
				"faction_memory",
				"info_mission_cooling_coolant_control",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"info_mission_cooling_coolant_control",
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
		database = "mission_vo_lm_cooling",
		name = "info_mission_cooling_demolish",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_mission_cooling_demolish",
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
				"info_mission_cooling_demolish",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest",
				},
			},
			{
				"user_memory",
				"info_mission_cooling_demolish",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"info_mission_cooling_demolish",
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
		database = "mission_vo_lm_cooling",
		name = "info_mission_cooling_follow_conveyor",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_mission_cooling_follow_conveyor",
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
				"info_mission_cooling_follow_conveyor",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest",
				},
			},
			{
				"user_memory",
				"",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
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
		database = "mission_vo_lm_cooling",
		name = "info_mission_cooling_maintenance",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_mission_cooling_maintenance",
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
				"info_mission_cooling_maintenance",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"info_mission_cooling_maintenance",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"info_mission_cooling_maintenance",
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
		database = "mission_vo_lm_cooling",
		name = "info_mission_cooling_vents",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_mission_cooling_vents",
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
				"info_mission_cooling_vents",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest",
				},
			},
			{
				"user_memory",
				"info_mission_cooling_vents",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"info_mission_cooling_vents",
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
		database = "mission_vo_lm_cooling",
		name = "info_mission_cooling_vents_response",
		response = "info_mission_cooling_vents_response",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"info_mission_cooling_vents",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_cmd_load_coolant",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_cooling_cmd_load_coolant",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"luggable_mission_pick_up_lm_cooling",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
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
				duration = 0.3,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_cmd_stabilise",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_cooling_cmd_stabilise",
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
				"cmd_stabilise",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest",
				},
			},
			{
				"user_memory",
				"cmd_stabilise",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cmd_stabilise",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_elevator_conversation_one_line_one",
		response = "mission_cooling_elevator_conversation_one_line_one",
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
				OP.LT,
				50,
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_cooling_elevator_conversation_one_line_one",
			},
			{
				"faction_memory",
				"mission_cooling_elevator_conversation_one_line_one",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_elevator_conversation_one_line_one",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_elevator_conversation_one_line_three",
		response = "mission_cooling_elevator_conversation_one_line_three",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_elevator_conversation_one_line_two",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_elevator_conversation_one_line_two",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_cooling_elevator_conversation_one_line_two",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_elevator_conversation_one_line_one",
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
	define_rule({
		category = "conversations_prio_0",
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_elevator_conversation_three_line_one",
		response = "mission_cooling_elevator_conversation_three_line_one",
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
				OP.LT,
				50,
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_cooling_elevator_conversation_three_line_one",
			},
			{
				"faction_memory",
				"mission_cooling_elevator_conversation_three_line_one",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_elevator_conversation_three_line_one",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_elevator_conversation_three_line_three",
		response = "mission_cooling_elevator_conversation_three_line_three",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_elevator_conversation_three_line_two",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_elevator_conversation_three_line_two",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_cooling_elevator_conversation_three_line_two",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_elevator_conversation_three_line_one",
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
	define_rule({
		category = "conversations_prio_0",
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_elevator_conversation_two_line_one",
		response = "mission_cooling_elevator_conversation_two_line_one",
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
				OP.LT,
				50,
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_cooling_elevator_conversation_two_line_one",
			},
			{
				"faction_memory",
				"mission_cooling_elevator_conversation_two_line_one",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_elevator_conversation_two_line_one",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_elevator_conversation_two_line_three",
		response = "mission_cooling_elevator_conversation_two_line_three",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_elevator_conversation_two_line_two",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_elevator_conversation_two_line_two",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_cooling_elevator_conversation_two_line_two",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_elevator_conversation_two_line_one",
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
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_first_objective",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_cooling_first_objective",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"info_mission_cooling_vents_response",
					"start_zone_direction_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_first_objective_response",
		response = "mission_cooling_first_objective_response",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_first_objective",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_heat",
		response = "mission_cooling_heat",
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
				"lm_cooling",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled",
			},
			{
				"faction_memory",
				"mission_cooling_heat",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_heat",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_heat_response",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_cooling_heat_response",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_heat",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
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
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_heat_response_three",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_cooling_heat_response_three",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_heat_response_two",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_heat_response_two",
		response = "mission_cooling_heat_response_two",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_heat_response",
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
		category = "player_prio_0",
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_leaving",
		response = "mission_cooling_leaving",
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
				"mission_cooling_leaving",
			},
			{
				"faction_memory",
				"mission_cooling_leaving",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_leaving",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_leaving_response",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_cooling_leaving_response",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_leaving",
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
		category = "player_prio_0",
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_long_way_down",
		response = "mission_cooling_long_way_down",
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
				"mission_cooling_long_way_down",
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
				"mission_cooling_long_way_down",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_long_way_down",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_luggable_event_survive",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_cooling_luggable_event_survive",
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
				"mission_cooling_luggable_event_survive",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest",
				},
			},
			{
				"user_memory",
				"mission_cooling_luggable_event_survive",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"mission_cooling_luggable_event_survive",
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
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_overseer_office",
		response = "mission_cooling_overseer_office",
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
				"mission_cooling_overseer_office",
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
				"mission_cooling_overseer_office",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_overseer_office",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_lm_cooling",
		name = "mission_cooling_worker_habitation",
		response = "mission_cooling_worker_habitation",
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
				"mission_cooling_worker_habitation",
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
				"mission_cooling_worker_habitation",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_cooling_worker_habitation",
				OP.ADD,
				1,
			},
		},
	})
end
