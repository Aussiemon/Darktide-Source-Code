-- chunkname: @dialogues/generated/event_vo_hacking.lua

return function ()
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "event_vo_hacking",
		name = "cmd_hacking_decode_resuming",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_hacking_decode_resuming",
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
				"cmd_hacking_decode_resuming",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest",
					"contract_vendor",
					"purser",
					"training_ground_psyker",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "event_vo_hacking",
		name = "cmd_hacking_find_another",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_hacking_find_another",
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
				"cmd_hacking_find_another",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"pilot",
					"explicator",
					"pilot",
				},
			},
			{
				"user_memory",
				"cmd_hacking_find_another",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cmd_hacking_find_another",
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
		database = "event_vo_hacking",
		name = "cmd_hacking_fix_decode",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_hacking_fix_decode",
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
				"cmd_hacking_fix_decode",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest",
					"contract_vendor",
					"purser",
					"explicator",
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"hacking_fix_decode",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hacking_fix_decode",
				OP.TIMESET,
				0,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "event_vo_hacking",
		name = "cmd_hacking_place_device",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "cmd_hacking_place_device",
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
				"cmd_hacking_place_device",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"pilot",
					"tech_priest",
				},
			},
			{
				"user_memory",
				"cmd_hacking_place_device",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"cmd_hacking_place_device",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "event_vo_hacking",
		name = "hacking_auspex_mutter_a",
		response = "hacking_auspex_mutter_a",
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
				"hacking_auspex_mutter_a",
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
				OP.LTEQ,
				3,
			},
			{
				"user_memory",
				"hacking_auspex_mutter_a",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"hacking_auspex_mutter_a",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3,
			},
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "event_vo_hacking",
		name = "info_hacking_decoding_in_progress",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_hacking_decoding_in_progress",
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
				"info_hacking_decoding_in_progress",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"pilot",
					"explicator",
					"tech_priest",
					"contract_vendor",
					"purser",
					"training_ground_psyker",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "event_vo_hacking",
		name = "info_hacking_decoding_in_progress_vox_response",
		post_wwise_event = "play_radio_static_end",
		response = "info_hacking_decoding_in_progress_vox_response",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"vox_introduction_hacking_event",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
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
				duration = 0.24,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "event_vo_hacking",
		name = "info_hacking_mission_almost_done",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_hacking_mission_almost_done",
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
				"info_hacking_mission_almost_done",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"tech_priest",
					"sergeant",
					"contract_vendor",
					"purser",
					"training_ground_psyker",
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
		database = "event_vo_hacking",
		name = "info_hacking_mission_complete",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_hacking_mission_complete",
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
				"info_hacking_mission_complete",
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
			{
				"user_memory",
				"info_hacking_mission_complete",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"info_hacking_mission_complete",
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
		database = "event_vo_hacking",
		name = "response_to_hacking_fix_decode",
		response = "response_to_hacking_fix_decode",
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
				"response_to_hacking_fix_decode",
			},
			{
				"faction_memory",
				"hacking_fix_decode",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hacking_fix_decode",
				OP.TIMESET,
				0,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "event_vo_hacking",
		name = "vox_introduction_hacking_event",
		pre_wwise_event = "play_radio_static_start",
		response = "vox_introduction_hacking_event",
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
				"vox_introduction_hacking_event",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
					"explicator",
					"pilot",
					"sergeant",
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"vox_introduction_hacking_event",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"vox_introduction_hacking_event",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
end
