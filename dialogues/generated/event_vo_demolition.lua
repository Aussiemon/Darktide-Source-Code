-- chunkname: @dialogues/generated/event_vo_demolition.lua

return function ()
	define_rule({
		category = "player_prio_0",
		database = "event_vo_demolition",
		name = "event_demolition_first_corruptor_destroyed_a",
		response = "event_demolition_first_corruptor_destroyed_a",
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
				"event_demolition_first_corruptor_destroyed_a",
			},
			{
				"faction_memory",
				"event_demolition_first_corruptor_destroyed_a",
				OP.LT,
				2,
			},
		},
		on_done = {
			{
				"faction_memory",
				"event_demolition_first_corruptor_destroyed_a",
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
		database = "event_vo_demolition",
		name = "event_demolition_first_corruptor_destroyed_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "event_demolition_first_corruptor_destroyed_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"event_demolition_first_corruptor_destroyed_a",
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
			{
				"faction_memory",
				"event_demolition_first_corruptor_destroyed_b",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"event_demolition_first_corruptor_destroyed_b",
				OP.ADD,
				1,
			},
		},
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
		database = "event_vo_demolition",
		name = "event_demolition_last_corruptor",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "event_demolition_last_corruptor",
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
				"event_demolition_last_corruptor",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"pilot",
					"tech_priest",
					"contract_vendor",
					"purser",
					"enginseer",
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
		database = "event_vo_demolition",
		name = "event_demolition_more_corruptors",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "event_demolition_more_corruptors",
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
				"event_demolition_more_corruptors",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"pilot",
					"tech_priest",
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
		database = "event_vo_demolition",
		name = "info_event_demolition_corruptors_almost_done",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "info_event_demolition_corruptors_almost_done",
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
				"info_event_demolition_corruptors_almost_done",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"pilot",
					"tech_priest",
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"info_event_demolition_corruptors_almost_done",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"info_event_demolition_corruptors_almost_done",
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
		database = "event_vo_demolition",
		name = "mission_stockpile_bazaar",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_stockpile_bazaar",
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
				"mission_stockpile_bazaar",
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
				"mission_stockpile_bazaar",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_bazaar",
				OP.ADD,
				1,
			},
		},
	})
end
