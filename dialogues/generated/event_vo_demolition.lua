return function ()
	define_rule({
		name = "event_demolition_first_corruptor_destroyed_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "event_demolition_first_corruptor_destroyed_a",
		database = "event_vo_demolition",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"event_demolition_first_corruptor_destroyed_a"
			},
			{
				"faction_memory",
				"event_demolition_first_corruptor_destroyed_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_demolition_first_corruptor_destroyed_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "event_demolition_first_corruptor_destroyed_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "event_demolition_first_corruptor_destroyed_b",
		database = "event_vo_demolition",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"event_demolition_first_corruptor_destroyed_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			}
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "event_demolition_last_corruptor",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "event_demolition_last_corruptor",
		database = "event_vo_demolition",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"event_demolition_last_corruptor"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"pilot",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"event_demolition_last_corruptor",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_demolition_last_corruptor",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "event_demolition_more_corruptors",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "event_demolition_more_corruptors",
		database = "event_vo_demolition",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"event_demolition_more_corruptors"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"pilot",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"event_demolition_more_corruptors",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_demolition_more_corruptors",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_event_demolition_corruptors_almost_done",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_event_demolition_corruptors_almost_done",
		database = "event_vo_demolition",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"info_event_demolition_corruptors_almost_done"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"pilot",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"info_event_demolition_corruptors_almost_done",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_event_demolition_corruptors_almost_done",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_stockpile_bazaar",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_stockpile_bazaar",
		database = "event_vo_demolition",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_stockpile_bazaar"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_stockpile_bazaar",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_stockpile_bazaar",
				OP.ADD,
				1
			}
		}
	})
end
