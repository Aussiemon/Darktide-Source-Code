-- chunkname: @dialogues/generated/mission_vo_lm_scavenge.lua

return function ()
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_lm_scavenge",
		name = "cmd_mission_scavenge_entering_ship_port",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_mission_scavenge_entering_ship_port",
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
				"cmd_mission_scavenge_entering_ship_port",
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
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"cmd_mission_scavenge_entering_ship_port",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"cmd_mission_scavenge_entering_ship_port",
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
		database = "mission_vo_lm_scavenge",
		name = "cmd_mission_scavenge_hacking_event_end",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_mission_scavenge_hacking_event_end",
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
				"cmd_mission_scavenge_hacking_event_end",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest",
				},
			},
			{
				"user_memory",
				"cmd_mission_scavenge_hacking_event_end",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cmd_mission_scavenge_hacking_event_end",
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
		database = "mission_vo_lm_scavenge",
		name = "cmd_mission_scavenge_hacking_event_start",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_mission_scavenge_hacking_event_start",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_servitors",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_lm_scavenge",
		name = "cmd_mission_scavenge_luggable_event_end",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_mission_scavenge_luggable_event_end",
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
				"cmd_mission_scavenge_luggable_event_end",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_luggable_event_end",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_luggable_event_end",
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
		database = "mission_vo_lm_scavenge",
		name = "cmd_mission_scavenge_luggable_event_start",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_mission_scavenge_luggable_event_start",
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
				"cmd_mission_scavenge_luggable_event_start",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"cmd_mission_scavenge_luggable_event_start",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"cmd_mission_scavenge_luggable_event_start",
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
		database = "mission_vo_lm_scavenge",
		name = "cmd_mission_scavenge_vault_access",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_mission_scavenge_vault_access",
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
				"cmd_mission_scavenge_vault_access",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"cmd_mission_scavenge_vault_access",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"cmd_mission_scavenge_vault_access",
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
		database = "mission_vo_lm_scavenge",
		name = "info_mission_scavenge_hangar_guidance_one",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_mission_scavenge_hangar_guidance_one",
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
				"info_mission_scavenge_hangar_guidance_one",
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
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"info_mission_scavenge_hangar_guidance_one",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"info_mission_scavenge_hangar_guidance_one",
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
		database = "mission_vo_lm_scavenge",
		name = "info_mission_scavenge_hangar_guidance_two",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_mission_scavenge_hangar_guidance_two",
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
				"info_mission_scavenge_hangar_guidance_two",
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
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"info_mission_scavenge_hangar_guidance_two",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"info_mission_scavenge_hangar_guidance_two",
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
		database = "mission_vo_lm_scavenge",
		name = "info_mission_scavenge_ship_elevator_vista",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_mission_scavenge_ship_elevator_vista",
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
				"info_mission_scavenge_ship_elevator_vista",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
					"pilot",
					"sergeant",
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"info_mission_scavenge_ship_elevator_vista",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"info_mission_scavenge_ship_elevator_vista",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_atmosphere_shield",
		response = "mission_scavenge_atmosphere_shield",
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
				"lm_scavenge",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.NEQ,
				"thischeckisdisabled",
			},
			{
				"faction_memory",
				"mission_scavenge_start_banter",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_start_banter",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_cmd_load_pneumatic",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_cmd_load_pneumatic",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"luggable_mission_pick_up_lm_scavenge",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
					"pilot",
					"sergeant",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_consulate_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_consulate_a",
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
				"mission_scavenge_consulate_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_consulate_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_consulate_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_consulate_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_consulate_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_consulate_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_consulate_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_consulate_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_consulate_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_daylight",
		response = "mission_scavenge_daylight",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_atmosphere_shield",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"mission_scavenge_daylight_user",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_daylight_response",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_daylight_response",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_daylight",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_daylight_response_b",
		response = "mission_scavenge_daylight_response_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_daylight_response",
				},
			},
			{
				"user_memory",
				"mission_scavenge_daylight_user",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_elevator_conversation_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_elevator_conversation_01_a",
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
				"mission_scavenge_elevator_conversation_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_01_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_elevator_conversation_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_elevator_conversation_01_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_elevator_conversation_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_elevator_conversation_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_elevator_conversation_01_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_elevator_conversation_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_elevator_conversation_one_line_one",
		response = "mission_scavenge_elevator_conversation_one_line_one",
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
				20,
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_scavenge_elevator_conversation_one_line_one",
			},
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_one_line_one",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_one_line_one",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_elevator_conversation_one_line_three",
		response = "mission_scavenge_elevator_conversation_one_line_three",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_elevator_conversation_one_line_two",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_elevator_conversation_one_line_two",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_elevator_conversation_one_line_two",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_elevator_conversation_one_line_one",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_elevator_conversation_three_line_one",
		response = "mission_scavenge_elevator_conversation_three_line_one",
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
				20,
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_scavenge_elevator_conversation_three_line_one",
			},
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_three_line_one",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_three_line_one",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_elevator_conversation_three_line_three",
		response = "mission_scavenge_elevator_conversation_three_line_three",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_elevator_conversation_three_line_two",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_elevator_conversation_three_line_two",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_elevator_conversation_three_line_two",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_elevator_conversation_three_line_one",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_elevator_conversation_two_line_one",
		response = "mission_scavenge_elevator_conversation_two_line_one",
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
				20,
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"mission_scavenge_elevator_conversation_two_line_one",
			},
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_two_line_one",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_elevator_conversation_two_line_one",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_elevator_conversation_two_line_three",
		response = "mission_scavenge_elevator_conversation_two_line_three",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_elevator_conversation_two_line_two",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_elevator_conversation_two_line_two",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_elevator_conversation_two_line_two",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_elevator_conversation_two_line_one",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_entering_ship_port_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_entering_ship_port_a",
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
				"mission_scavenge_entering_ship_port_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_entering_ship_port_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_entering_ship_port_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_entering_ship_port_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_entering_ship_port_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_entering_ship_port_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_entering_ship_port_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_entering_ship_port_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_entering_ship_port_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_extract_chase_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_extract_chase_a",
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
				"mission_scavenge_extract_chase_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_extract_chase_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_extract_chase_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_extract_chase_b",
		post_wwise_event = "play_radio_static_end",
		response = "mission_scavenge_extract_chase_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_extract_chase_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_extract_chase_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_extract_chase_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_extract_chase_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_first_objective",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_first_objective",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_daylight_response_b",
					"start_zone_direction_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
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
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_first_objective_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_first_objective_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_safezone_01_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 5,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_first_objective_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_first_objective_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_first_objective_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_first_objective_response",
		response = "mission_scavenge_first_objective_response",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_first_objective",
					"mission_scavenge_first_objective_b",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_hacking_event_complete_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_hacking_event_complete_a",
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
				"mission_scavenge_hacking_event_complete_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_hacking_event_complete_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_hacking_event_complete_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_hacking_event_complete_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_hacking_event_complete_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_hacking_event_complete_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_hacking_event_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_hacking_event_start_a",
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
				"mission_scavenge_hacking_event_start_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_hacking_event_start_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_hacking_event_start_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_hacking_event_start_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_hacking_event_start_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_hacking_event_start_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_hangar_guidance_one_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_hangar_guidance_one_a",
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
				"mission_scavenge_hangar_guidance_one_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_hangar_guidance_one_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_hangar_guidance_one_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_hangar_guidance_one_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_hangar_guidance_one_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_hangar_guidance_one_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_hangar_guidance_two_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_hangar_guidance_two_a",
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
				"mission_scavenge_hangar_guidance_two_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_hangar_guidance_two_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_hangar_guidance_two_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_interior",
		response = "mission_scavenge_interior",
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
				"mission_scavenge_interior",
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low",
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
				"enemies_close",
				OP.LT,
				10,
			},
			{
				"faction_memory",
				"mission_scavenge_interior",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
			{
				"faction_memory",
				"mission_scavenge_interior",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_interior",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"mission_scavenge_interior",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_luggable_event_complete_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_luggable_event_complete_a",
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
				"mission_scavenge_luggable_event_complete_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_luggable_event_complete_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_luggable_event_complete_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_luggable_event_first_pickup_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_luggable_event_first_pickup_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"event_one_down",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_luggable_event_start_a",
				OP.EQ,
				1,
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_luggable_event_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_luggable_event_start_a",
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
				"mission_scavenge_luggable_event_start_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_luggable_event_start_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_luggable_event_start_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_luggable_event_third_pickup_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_luggable_event_third_pickup_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"info_event_almost_done",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_luggable_event_start_a",
				OP.EQ,
				1,
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_luggable_event_trigger_switch_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_luggable_event_trigger_switch_a",
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
				"mission_scavenge_luggable_event_trigger_switch_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_luggable_event_trigger_switch_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_luggable_event_trigger_switch_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_pneumatic_conveyor_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_pneumatic_conveyor_a",
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
				"mission_scavenge_pneumatic_conveyor_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_pneumatic_conveyor_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_pneumatic_conveyor_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_pneumatic_press",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_pneumatic_press",
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
				"mission_scavenge_pneumatic_press",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_pneumatic_press",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_pneumatic_press",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_safezone_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_safezone_01_a",
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
				"mission_scavenge_safezone_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_safezone_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_safezone_01_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_safezone_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_safezone_01_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_safezone_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_safezone_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_safezone_01_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_safezone_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_safezone_01_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_safezone_01_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_safezone_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_safezone_01_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_safezone_01_e",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_safezone_01_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_servitors",
		response = "mission_scavenge_servitors",
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
				"mission_scavenge_servitors",
			},
			{
				"faction_memory",
				"mission_scavenge_servitors",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_servitors",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_shield_ruin_vista_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_shield_ruin_vista_a",
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
				"mission_scavenge_shield_ruin_vista_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_shield_ruin_vista_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_shield_ruin_vista_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_ship_elevator_end",
		response = "mission_scavenge_ship_elevator_end",
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
				"mission_scavenge_ship_elevator_end",
			},
			{
				"faction_memory",
				"mission_scavenge_ship_elevator_end",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_ship_elevator_end",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_ship_elevator_moving_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_ship_elevator_moving_a",
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
				"mission_scavenge_ship_elevator_moving_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_ship_elevator_moving_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_ship_elevator_moving_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_ship_elevator_moving_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_ship_elevator_moving_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_ship_elevator_moving_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_ship_elevator_moving_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_ship_elevator_moving_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_ship_elevator_moving_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_ship_elevator_switch_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_ship_elevator_switch_a",
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
				"mission_scavenge_ship_elevator_switch_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_ship_elevator_switch_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_ship_elevator_switch_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_ship_elevator_vista_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_ship_elevator_vista_a",
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
				"mission_scavenge_ship_elevator_vista_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_ship_elevator_vista_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_ship_elevator_vista_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_ship_elevator_vista_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_ship_elevator_vista_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_ship_elevator_vista_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_underhalls",
		response = "mission_scavenge_underhalls",
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
				"mission_scavenge_underhalls",
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
				"mission_scavenge_underhalls",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_underhalls",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_vault_access_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_vault_access_a",
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
				"mission_scavenge_vault_access_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_vault_access_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_vault_access_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_vault_airlock_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_vault_airlock_a",
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
				"mission_scavenge_vault_airlock_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tank_commander",
				},
			},
			{
				"faction_memory",
				"mission_scavenge_vault_airlock_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_scavenge_vault_airlock_a",
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
		database = "mission_vo_lm_scavenge",
		name = "mission_scavenge_vault_airlock_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_scavenge_vault_airlock_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_scavenge_vault_airlock_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
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
