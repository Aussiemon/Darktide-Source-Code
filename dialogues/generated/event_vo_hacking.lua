return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_hacking_decode_completed",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_hacking_decode_completed",
		database = "event_vo_hacking",
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
				"cmd_hacking_decode_completed"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest"
				}
			},
			{
				"user_memory",
				"cmd_hacking_decode_completed",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_hacking_decode_completed",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_hacking_decode_resuming",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_hacking_decode_resuming",
		database = "event_vo_hacking",
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
				"cmd_hacking_decode_resuming"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest"
				}
			},
			{
				"user_memory",
				"",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"",
				OP.ADD,
				0
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_hacking_find_another",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_hacking_find_another",
		database = "event_vo_hacking",
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
				"cmd_hacking_find_another"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"pilot",
					"explicator",
					"pilot"
				}
			},
			{
				"user_memory",
				"cmd_hacking_find_another",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_hacking_find_another",
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
		name = "cmd_hacking_fix_decode",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_hacking_fix_decode",
		database = "event_vo_hacking",
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
				"cmd_hacking_fix_decode"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"hacking_fix_decode",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"faction_memory",
				"hacking_fix_decode",
				OP.TIMESET,
				0
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_hacking_fix_decode_response",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_hacking_fix_decode_response",
		database = "event_vo_hacking",
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
				"cmd_hacking_fix_decode_response"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"hacking_fix_decode",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"faction_memory",
				"hacking_fix_decode",
				OP.TIMESET,
				0
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_hacking_place_device",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_hacking_place_device",
		database = "event_vo_hacking",
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
				"cmd_hacking_place_device"
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
			},
			{
				"user_memory",
				"cmd_hacking_place_device",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_hacking_place_device",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_hacking_decoding_in_progress",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_hacking_decoding_in_progress",
		database = "event_vo_hacking",
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
				"info_hacking_decoding_in_progress"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"pilot",
					"explicator",
					"tech_priest"
				}
			},
			{
				"user_memory",
				"info_hacking_decoding_in_progress",
				OP.LT,
				2
			}
		},
		on_done = {
			{
				"user_memory",
				"info_hacking_decoding_in_progress",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_hacking_mission_almost_done",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_hacking_mission_almost_done",
		database = "event_vo_hacking",
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
				"info_hacking_mission_almost_done"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"tech_priest",
					"sergeant"
				}
			},
			{
				"user_memory",
				"info_hacking_mission_almost_done",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_hacking_mission_almost_done",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_hacking_mission_complete",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_hacking_mission_complete",
		database = "event_vo_hacking",
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
				"info_hacking_mission_complete"
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
			},
			{
				"user_memory",
				"info_hacking_mission_complete",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_hacking_mission_complete",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "response_to_hacking_fix_decode",
		category = "player_prio_0",
		wwise_route = 0,
		response = "response_to_hacking_fix_decode",
		database = "event_vo_hacking",
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
				"response_to_hacking_fix_decode"
			},
			{
				"faction_memory",
				"hacking_fix_decode",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"faction_memory",
				"hacking_fix_decode",
				OP.TIMESET,
				0
			}
		}
	})
end
