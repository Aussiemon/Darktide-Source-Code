return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "event_kill_kill_the_target",
		response = "event_kill_kill_the_target",
		database = "event_vo_kill",
		wwise_route = 1,
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
					"renegade_captain_taunt"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "event_kill_target_damaged",
		category = "player_prio_0",
		wwise_route = 0,
		response = "event_kill_target_damaged",
		database = "event_vo_kill",
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
				"event_kill_target_damaged"
			},
			{
				"faction_memory",
				"event_kill_target_damaged",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_kill_target_damaged",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "event_kill_target_destroyed_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "event_kill_target_destroyed_a",
		database = "event_vo_kill",
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
				"event_kill_target_destroyed_a"
			},
			{
				"faction_memory",
				"event_kill_target_destroyed_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_kill_target_destroyed_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_giver_default"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "event_kill_target_destroyed_b",
		response = "event_kill_target_destroyed_b",
		database = "event_vo_kill",
		wwise_route = 1,
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
					"event_kill_target_destroyed_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "event_kill_target_heavy_damage_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "event_kill_target_heavy_damage_a",
		database = "event_vo_kill",
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
				"event_kill_target_heavy_damage_a"
			},
			{
				"faction_memory",
				"event_kill_target_heavy_damage_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_kill_target_heavy_damage_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_giver_default"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "event_kill_target_heavy_damage_b",
		response = "event_kill_target_heavy_damage_b",
		database = "event_vo_kill",
		wwise_route = 1,
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
					"event_kill_target_heavy_damage_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
end
