-- chunkname: @dialogues/generated/mission_vo_km_enforcer.lua

return function ()
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_activate_stair",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_activate_stair",
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
				"mission_enforcer_activate_stair",
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
				"mission_enforcer_activate_stair",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_activate_stair",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_courtroom",
		response = "mission_enforcer_courtroom",
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
				"mission_enforcer_courtroom",
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
				"mission_enforcer_courtroom",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_courtroom",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_courtroom_waypoint",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_courtroom_waypoint",
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
				"mission_enforcer_courtroom_waypoint",
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
				"mission_enforcer_courtroom_waypoint",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_courtroom_waypoint",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_elevator_conversation_journey_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_elevator_conversation_journey_02_a",
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
				"mission_enforcer_elevator_conversation_journey_02_a",
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
				"mission_enforcer_elevator_conversation_journey_02_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_elevator_conversation_journey_02_a",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_elevator_conversation_journey_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_elevator_conversation_journey_02_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_elevator_conversation_journey_02_a",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_elevator_conversation_journey_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_elevator_conversation_journey_02_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_elevator_conversation_journey_02_b",
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
		category = "conversations_prio_0",
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_end_event_conversation_one_a",
		response = "mission_enforcer_end_event_conversation_one_a",
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
				1,
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
				"mission_enforcer_end_event_conversation_one_a",
			},
			{
				"faction_memory",
				"mission_enforcer_end_event_conversation_one_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_end_event_conversation_one_a",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_end_event_conversation_one_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_end_event_conversation_one_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_end_event_conversation_one_a",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_end_event_conversation_one_c",
		response = "mission_enforcer_end_event_conversation_one_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_end_event_conversation_one_b",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_end_event_conversation_three_a",
		response = "mission_enforcer_end_event_conversation_three_a",
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
				1,
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
				"mission_enforcer_end_event_conversation_three_a",
			},
			{
				"faction_memory",
				"mission_enforcer_end_event_conversation_three_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_end_event_conversation_three_a",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_end_event_conversation_three_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_end_event_conversation_three_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_end_event_conversation_three_a",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_end_event_conversation_three_c",
		response = "mission_enforcer_end_event_conversation_three_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_end_event_conversation_three_b",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_end_event_conversation_two_a",
		response = "mission_enforcer_end_event_conversation_two_a",
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
				1,
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
				"mission_enforcer_end_event_conversation_two_a",
			},
			{
				"faction_memory",
				"mission_enforcer_end_event_conversation_two_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_end_event_conversation_two_a",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_end_event_conversation_two_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_end_event_conversation_two_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_end_event_conversation_two_a",
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_enforcer_station",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_enforcer_station",
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
				"mission_enforcer_enforcer_station",
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
					"sergeant",
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"mission_enforcer_enforcer_station",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_enforcer_station",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_event_survive",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_event_survive",
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
				"mission_enforcer_event_survive",
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
				"mission_enforcer_event_survive",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_activate_stair",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_first_objective",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_first_objective",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_start_banter_c",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_first_objective_response",
		response = "mission_enforcer_first_objective_response",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_first_objective",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_hab_support",
		response = "mission_enforcer_hab_support",
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
				"mission_enforcer_hab_support",
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
				"mission_enforcer_hab_support",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_hab_support",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_infrastructure",
		response = "mission_enforcer_infrastructure",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_hab_support",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_maintenance_area",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_maintenance_area",
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
				"mission_enforcer_maintenance_area",
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
				"mission_enforcer_maintenance_area",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_maintenance_area",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_reach_cells",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_reach_cells",
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
				"mission_enforcer_reach_cells",
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
				"mission_enforcer_reach_cells",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_reach_cells",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_stairs_arrived",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_stairs_arrived",
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
				"mission_enforcer_stairs_arrived",
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
				"mission_enforcer_stairs_arrived",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_stairs_arrived",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_start_banter_a",
		response = "mission_enforcer_start_banter_a",
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
				"km_enforcer",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled",
			},
			{
				"faction_memory",
				"mission_enforcer_start_banter_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_start_banter_a",
				OP.ADD,
				1,
			},
			{
				"user_memory",
				"mission_enforcer_start_banter_a",
				OP.ADD,
				1,
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_start_banter_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_start_banter_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_start_banter_a",
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_start_banter_c",
		response = "mission_enforcer_start_banter_c",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_enforcer_start_banter_b",
				},
			},
			{
				"user_memory",
				"mission_enforcer_start_banter_a",
				OP.EQ,
				0,
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
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_through_hab",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_enforcer_through_hab",
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
				"mission_enforcer_through_hab",
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
				"mission_enforcer_through_hab",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_through_hab",
				OP.ADD,
				1,
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
		category = "player_prio_0",
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_traders_row",
		response = "mission_enforcer_traders_row",
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
				"mission_enforcer_traders_row",
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
				"mission_enforcer_traders_row",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_enforcer_traders_row",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "mission_vo_km_enforcer",
		name = "mission_enforcer_wonky_hab",
		response = "mission_enforcer_wonky_hab",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"",
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
end
