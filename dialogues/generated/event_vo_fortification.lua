-- chunkname: @dialogues/generated/event_vo_fortification.lua

return function ()
	define_rule({
		category = "player_prio_0",
		database = "event_vo_fortification",
		name = "event_fortification_beacon_deployed",
		response = "event_fortification_beacon_deployed",
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
				"event_fortification_beacon_deployed",
			},
			{
				"faction_memory",
				"event_fortification_beacon_deployed",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"event_fortification_beacon_deployed",
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
		database = "event_vo_fortification",
		name = "event_fortification_disable_the_skyfire",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "event_fortification_disable_the_skyfire",
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
				"event_fortification_disable_the_skyfire",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest",
					"explicator",
				},
			},
			{
				"faction_memory",
				"event_fortification_disable_the_skyfire",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"event_fortification_disable_the_skyfire",
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
		database = "event_vo_fortification",
		name = "event_fortification_fortification_survive",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "event_fortification_fortification_survive",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"event_fortification_beacon_deployed",
				},
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
		category = "player_prio_0",
		database = "event_vo_fortification",
		name = "event_fortification_gate_powered",
		response = "event_fortification_gate_powered",
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
				"event_fortification_gate_powered",
			},
			{
				"faction_memory",
				"event_fortification_gate_powered",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"event_fortification_gate_powered",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "event_vo_fortification",
		name = "event_fortification_kill_stragglers",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "event_fortification_kill_stragglers",
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
				"event_fortification_kill_stragglers",
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
			{
				"faction_memory",
				"event_fortification_kill_stragglers",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"event_fortification_kill_stragglers",
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
		database = "event_vo_fortification",
		name = "event_fortification_power_up_gate",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "event_fortification_power_up_gate",
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
				"event_fortification_power_up_gate",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"sergeant",
					"tech_priest",
					"explicator",
				},
			},
			{
				"faction_memory",
				"event_fortification_power_up_gate",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"event_fortification_power_up_gate",
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
		database = "event_vo_fortification",
		name = "event_fortification_set_landing_beacon",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "event_fortification_set_landing_beacon",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"event_fortification_skyfire_disabled",
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
					"explicator",
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
		database = "event_vo_fortification",
		name = "event_fortification_skyfire_disabled",
		response = "event_fortification_skyfire_disabled",
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
				"event_fortification_skyfire_disabled",
			},
			{
				"faction_memory",
				"event_fortification_skyfire_disabled",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"event_fortification_skyfire_disabled",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
	})
end
