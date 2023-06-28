return function ()
	define_rule({
		name = "event_fortification_beacon_deployed",
		category = "player_prio_0",
		wwise_route = 0,
		response = "event_fortification_beacon_deployed",
		database = "event_vo_fortification",
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
				"event_fortification_beacon_deployed"
			},
			{
				"faction_memory",
				"event_fortification_beacon_deployed",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_fortification_beacon_deployed",
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
		name = "event_fortification_disable_the_skyfire",
		response = "event_fortification_disable_the_skyfire",
		database = "event_vo_fortification",
		wwise_route = 1,
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
				"event_fortification_disable_the_skyfire"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest",
					"explicator"
				}
			},
			{
				"faction_memory",
				"event_fortification_disable_the_skyfire",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_fortification_disable_the_skyfire",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "event_fortification_fortification_survive",
		response = "event_fortification_fortification_survive",
		database = "event_vo_fortification",
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
					"event_fortification_beacon_deployed"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"pilot",
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
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "event_fortification_gate_powered",
		category = "player_prio_0",
		wwise_route = 0,
		response = "event_fortification_gate_powered",
		database = "event_vo_fortification",
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
				"event_fortification_gate_powered"
			},
			{
				"faction_memory",
				"event_fortification_gate_powered",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_fortification_gate_powered",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "event_fortification_kill_stragglers",
		response = "event_fortification_kill_stragglers",
		database = "event_vo_fortification",
		wwise_route = 1,
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
				"event_fortification_kill_stragglers"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"explicator",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"event_fortification_kill_stragglers",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_fortification_kill_stragglers",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "event_fortification_power_up_gate",
		response = "event_fortification_power_up_gate",
		database = "event_vo_fortification",
		wwise_route = 1,
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
				"event_fortification_power_up_gate"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest",
					"explicator"
				}
			},
			{
				"faction_memory",
				"event_fortification_power_up_gate",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_fortification_power_up_gate",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "event_fortification_set_landing_beacon",
		response = "event_fortification_set_landing_beacon",
		database = "event_vo_fortification",
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
					"event_fortification_skyfire_disabled"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest",
					"explicator"
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
		name = "event_fortification_skyfire_disabled",
		category = "player_prio_0",
		wwise_route = 0,
		response = "event_fortification_skyfire_disabled",
		database = "event_vo_fortification",
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
				"event_fortification_skyfire_disabled"
			},
			{
				"faction_memory",
				"event_fortification_skyfire_disabled",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_fortification_skyfire_disabled",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_giver_default"
		}
	})
end
