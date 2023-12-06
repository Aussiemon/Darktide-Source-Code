return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "cmd_wandering_skull",
		response = "cmd_wandering_skull",
		database = "event_vo_scan",
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
				"cmd_wandering_skull"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest",
					"explicator"
				}
			},
			{
				"faction_memory",
				"cmd_wandering_skull",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"mission_scan_final",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"cmd_wandering_skull",
				OP.TIMESET,
				0
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "event_scan_all_targets_scanned",
		response = "event_scan_all_targets_scanned",
		database = "event_vo_scan",
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
				"all_targets_scanned"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
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
				duration = 0.5
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "event_scan_find_targets_first",
		response = "event_scan_find_targets_first",
		database = "event_vo_scan",
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
				"event_scan_find_targets"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest",
					"explicator"
				}
			},
			{
				"faction_memory",
				"event_scan_find_targets",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_scan_find_targets",
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
		name = "event_scan_find_targets_more",
		response = "event_scan_find_targets_more",
		database = "event_vo_scan",
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
				"event_scan_find_targets"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest",
					"explicator"
				}
			},
			{
				"faction_memory",
				"event_scan_find_targets",
				OP.GTEQ,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_scan_find_targets",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "event_scan_first_target_scanned",
		category = "player_prio_0",
		wwise_route = 0,
		response = "event_scan_first_target_scanned",
		database = "event_vo_scan",
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
				"scan_performed"
			},
			{
				"faction_memory",
				"event_scan_first_target_scanned",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_scan_first_target_scanned",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "event_scan_more_data",
		response = "event_scan_more_data",
		database = "event_vo_scan",
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
				"event_scan_more_data"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest",
					"explicator"
				}
			},
			{
				"faction_memory",
				"event_scan_more_data",
				OP.EQ,
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_scan_more_data",
				OP.ADD,
				0
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
		name = "event_scan_skull_waiting",
		response = "event_scan_skull_waiting",
		database = "event_vo_scan",
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
				"event_scan_skull_waiting"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest",
					"explicator"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "info_servo_skull_deployed",
		response = "info_servo_skull_deployed",
		database = "event_vo_scan",
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
				"info_servo_skull_deployed"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest",
					"explicator"
				}
			},
			{
				"user_memory",
				"info_servo_skull_deployed",
				OP.GTEQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_servo_skull_deployed",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
end
