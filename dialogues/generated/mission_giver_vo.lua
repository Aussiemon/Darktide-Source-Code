return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "access_elevator",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "access_elevator",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"access_elevator"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				17
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
				"access_elevator",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"access_elevator",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_clear_enemies",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_clear_enemies",
		database = "mission_giver_vo",
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
				"cmd_clear_enemies"
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
				"user_memory",
				"cmd_clear_enemies",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_clear_enemies",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_deploy_skull",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "cmd_deploy_skull",
		database = "mission_giver_vo",
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
				"cmd_deploy_skull"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"cmd_deploy_skull",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_deploy_skull",
				OP.TIMESET,
				0
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_find_fortification_event_area",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_find_fortification_event_area",
		database = "mission_giver_vo",
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
				"cmd_find_fortification_event_area"
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
				"user_memory",
				"cmd_find_fortification_event_area",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_find_fortification_event_area",
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
		name = "cmd_find_target_intel",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_find_target_intel",
		database = "mission_giver_vo",
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
				"cmd_find_target_intel"
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
				"user_memory",
				"cmd_find_target_intel",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_find_target_intel",
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
		name = "cmd_get_to_extraction_point",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_get_to_extraction_point",
		database = "mission_giver_vo",
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
				"cmd_get_to_extraction_point"
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
				"user_memory",
				"cmd_get_to_extraction_point",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_get_to_extraction_point",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_go_for_target",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_go_for_target",
		database = "mission_giver_vo",
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
				"cmd_go_for_target"
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
				"user_memory",
				"cmd_go_for_target",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_go_for_target",
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
		name = "cmd_interact_button",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_interact_button",
		database = "mission_giver_vo",
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
				"cmd_interact_button"
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
				"user_memory",
				"cmd_interact_button",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_interact_button",
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
		name = "cmd_interact_lever",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_interact_lever",
		database = "mission_giver_vo",
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
				"cmd_interact_lever"
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
				"user_memory",
				"cmd_interact_lever",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_interact_lever",
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
		name = "cmd_load_coolant",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_load_coolant",
		database = "mission_giver_vo",
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
					"luggable_mission_pick_up_lm_cooling"
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
		name = "cmd_load_pneumatic",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_load_pneumatic",
		database = "mission_giver_vo",
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
					"luggable_mission_pick_up_lm_scavenge"
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
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_luggable_item_located",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_luggable_item_located",
		database = "mission_giver_vo",
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
				"cmd_luggable_item_located"
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
				"user_memory",
				"cmd_luggable_item_located",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_luggable_item_located",
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
		name = "cmd_mission_scavenge_hacking_event_end",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_mission_scavenge_hacking_event_end",
		database = "mission_giver_vo",
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
				"cmd_mission_scavenge_hacking_event_end"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"cmd_mission_scavenge_hacking_event_end",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_mission_scavenge_hacking_event_end",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_mission_scavenge_hacking_event_start",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_mission_scavenge_hacking_event_start",
		database = "mission_giver_vo",
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
					"mission_scavenge_servitors"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_mission_scavenge_luggable_event_start",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_mission_scavenge_luggable_event_start",
		database = "mission_giver_vo",
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
				"cmd_mission_scavenge_luggable_event_start"
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
				"cmd_mission_scavenge_luggable_event_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"cmd_mission_scavenge_luggable_event_start",
				OP.ADD,
				1
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_pick_an_item",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_pick_an_item",
		database = "mission_giver_vo",
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
				"cmd_pick_an_item"
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
				"user_memory",
				"cmd_pick_an_item",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_pick_an_item",
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
		name = "cmd_stabilise",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_stabilise",
		database = "mission_giver_vo",
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
				"cmd_stabilise"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest"
				}
			},
			{
				"user_memory",
				"cmd_stabilise",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_stabilise",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_start_event_demolition",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_start_event_demolition",
		database = "mission_giver_vo",
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
				"cmd_start_event_demolition"
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
				"user_memory",
				"cmd_start_event_demolition",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_start_event_demolition",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "cmd_start_event_distribute",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_start_event_distribute",
		database = "mission_giver_vo",
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
				"cmd_start_event_distribute"
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
				"user_memory",
				"cmd_start_event_distribute",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_start_event_distribute",
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
		name = "cmd_start_event_take",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_start_event_take",
		database = "mission_giver_vo",
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
				"cmd_start_event_take"
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
				"user_memory",
				"cmd_start_event_take",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_start_event_take",
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
		name = "cmd_start_machine",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "cmd_start_machine",
		database = "mission_giver_vo",
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
				"cmd_start_machine"
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
				"user_memory",
				"cmd_start_machine",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_start_machine",
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
		name = "cmd_undeploy_skull",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "cmd_undeploy_skull",
		database = "mission_giver_vo",
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
				"cmd_undeploy_skull"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"cmd_undeploy_skull",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"cmd_undeploy_skull",
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
		name = "info_a_demolition_target_located",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_a_demolition_target_located",
		database = "mission_giver_vo",
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
				"info_a_demolition_target_located"
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
				"user_memory",
				"info_a_demolition_target_located",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_a_demolition_target_located",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_accomplished_all",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_accomplished_all",
		database = "mission_giver_vo",
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
				"info_accomplished_all"
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
				"user_memory",
				"info_accomplished_all",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_accomplished_all",
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
		name = "info_accomplished_first_target",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_accomplished_first_target",
		database = "mission_giver_vo",
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
				"info_accomplished_first_target"
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
				"user_memory",
				"info_accomplished_first_target",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_accomplished_first_target",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_accomplished_half_target",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_accomplished_half_target",
		database = "mission_giver_vo",
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
				"info_accomplished_half_target"
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
				"user_memory",
				"info_accomplished_half_target",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_accomplished_half_target",
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
		name = "info_additional_demolition_target_located",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_additional_demolition_target_located",
		database = "mission_giver_vo",
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
				"info_additional_demolition_target_located"
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
				"user_memory",
				"info_additional_demolition_target_located",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_additional_demolition_target_located",
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
		name = "info_all_players_required",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_all_players_required",
		database = "mission_giver_vo",
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
				"info_all_players_required"
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
				"user_memory",
				"info_all_players_required",
				OP.LT,
				2
			}
		},
		on_done = {
			{
				"user_memory",
				"info_all_players_required",
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
		name = "info_bypass",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_bypass",
		database = "mission_giver_vo",
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
				"info_bypass"
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
				"user_memory",
				"info_bypass",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_bypass",
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
		name = "info_bypass_pressure",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "info_bypass_pressure",
		database = "mission_giver_vo",
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
				"info_bypass_pressure"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"info_bypass_pressure",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_bypass_pressure",
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
		name = "info_call_abyss",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_call_abyss",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"info_call_abyss"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				25
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot"
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
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_call_extraction",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_call_extraction",
		database = "mission_giver_vo",
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
					""
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
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_closer_to_target",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_closer_to_target",
		database = "mission_giver_vo",
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
				"info_closer_to_target"
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
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_demolition_target_located",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_demolition_target_located",
		database = "mission_giver_vo",
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
				"info_demolition_target_located"
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
				"user_memory",
				"info_demolition_target_located",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_demolition_target_located",
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
		name = "info_event_almost_done_mg",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_event_almost_done_mg",
		database = "mission_giver_vo",
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
				"info_event_almost_done_mg"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"tech_priest",
					"pilot",
					"explicator"
				}
			},
			{
				"faction_memory",
				"info_event_almost_done_mg",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_event_almost_done_mg",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_event_anticipation",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_event_anticipation",
		database = "mission_giver_vo",
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
				"info_event_anticipation"
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
				"user_memory",
				"info_event_anticipation",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_event_anticipation",
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
		name = "info_event_done",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_event_done",
		database = "mission_giver_vo",
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
				"info_event_done"
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
				"user_memory",
				"info_event_done",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_event_done",
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
		name = "info_event_half_done",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_event_half_done",
		database = "mission_giver_vo",
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
				"info_event_half_done"
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
				"user_memory",
				"info_event_half_done",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_event_half_done",
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
		name = "info_event_half_done_stresful",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 3,
		response = "info_event_half_done_stresful",
		database = "mission_giver_vo",
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
				"info_event_half_done_stresful"
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
				"user_memory",
				"info_event_half_done_stresful",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_event_half_done_stresful",
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
		name = "info_event_one_down",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_event_one_down",
		database = "mission_giver_vo",
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
				"info_event_one_down"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest"
				}
			},
			{
				"user_memory",
				"info_event_one_down",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_event_one_down",
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
		name = "info_event_repeat",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_event_repeat",
		database = "mission_giver_vo",
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
				"info_event_repeat"
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
				"user_memory",
				"info_event_repeat",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_event_repeat",
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
		name = "info_event_start",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_event_start",
		database = "mission_giver_vo",
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
				"info_event_start"
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
				"user_memory",
				"info_event_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_event_start",
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
		name = "info_event_start_second_time",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_event_start_second_time",
		database = "mission_giver_vo",
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
				"info_event_start_second_time"
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
				"user_memory",
				"info_event_start_second_time",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_event_start_second_time",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_event_starting_soon",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_event_starting_soon",
		database = "mission_giver_vo",
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
				"info_event_starting_soon"
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
				"user_memory",
				"info_event_starting_soon",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_event_starting_soon",
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
		name = "info_extraction",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_extraction",
		database = "mission_giver_vo",
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
				"info_extraction"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot"
				}
			},
			{
				"user_memory",
				"info_extraction",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_extraction",
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
		name = "info_first_bypass",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_first_bypass",
		database = "mission_giver_vo",
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
				"info_first_bypass"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
					"tech_priest",
					"sergeant"
				}
			},
			{
				"faction_memory",
				"info_first_bypass",
				OP.EQ,
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_first_bypass",
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
		name = "info_fortificatio_backup_arrived",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_fortificatio_backup_arrived",
		database = "mission_giver_vo",
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
				"info_fortificatio_backup_arrived"
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
				"user_memory",
				"info_fortificatio_backup_arrived",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_fortificatio_backup_arrived",
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
		name = "info_fortification_event_start",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_fortification_event_start",
		database = "mission_giver_vo",
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
				"info_fortification_event_start"
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
				"user_memory",
				"info_fortification_event_start",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_fortification_event_start",
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
		name = "info_get_out",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_get_out",
		database = "mission_giver_vo",
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
				"info_get_out"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest",
					"pilot"
				}
			},
			{
				"user_memory",
				"info_get_out",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_get_out",
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
		name = "info_get_out_nearby",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_get_out_nearby",
		database = "mission_giver_vo",
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
				"info_get_out_nearby"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest"
				}
			},
			{
				"user_memory",
				"info_get_out_nearby",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_get_out_nearby",
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
		name = "info_get_out_no_reply",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_get_out_no_reply",
		database = "mission_giver_vo",
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
				"info_get_out_no_reply"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest",
					"pilot"
				}
			},
			{
				"user_memory",
				"info_get_out_no_reply",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_get_out_no_reply",
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
		name = "info_incoming_enemies",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_incoming_enemies",
		database = "mission_giver_vo",
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
				"info_incoming_enemies"
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
				"user_memory",
				"info_incoming_enemies",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_incoming_enemies",
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
		name = "info_incoming_enemies_directional",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_incoming_enemies_directional",
		database = "mission_giver_vo",
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
				"info_incoming_enemies_directional"
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
				"user_memory",
				"info_incoming_enemies_directional",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_incoming_enemies_directional",
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
		name = "info_mission_scavenge_ship_elevator_vista",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_mission_scavenge_ship_elevator_vista",
		database = "mission_giver_vo",
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
				"info_mission_scavenge_ship_elevator_vista"
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
				"info_mission_scavenge_ship_elevator_vista",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_mission_scavenge_ship_elevator_vista",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_respawn_beacons_activated",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_respawn_beacons_activated",
		database = "mission_giver_vo",
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
				"info_respawn_beacons_activated"
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
				"user_memory",
				"info_respawn_beacons_activated",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_respawn_beacons_activated",
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
		name = "info_scan_batch_done",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "info_scan_batch_done",
		database = "mission_giver_vo",
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
				"info_scan_batch_done"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"info_scan_batch_done",
				OP.GTEQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_scan_batch_done",
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
		name = "info_scan_completed",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "info_scan_completed",
		database = "mission_giver_vo",
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
				"info_scan_completed"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"info_scan_completed",
				OP.GTEQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_scan_completed",
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
		name = "info_scan_target_located",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "info_scan_target_located",
		database = "mission_giver_vo",
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
				"info_scan_target_located"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"info_scan_target_located",
				OP.GTEQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_scan_target_located",
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
		name = "info_scanning_aborted",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "info_scanning_aborted",
		database = "mission_giver_vo",
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
				"info_scanning_aborted"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"info_scanning_aborted",
				OP.GTEQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_scanning_aborted",
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
		name = "info_scanning_inprogress",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "info_scanning_inprogress",
		database = "mission_giver_vo",
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
				"info_scanning_inprogress"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"info_scanning_inprogress",
				OP.GTEQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_scanning_inprogress",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_seeing_a_target",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_seeing_a_target",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"info_seeing_a_target"
			}
		},
		on_done = {}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_seeing_kill_target",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_seeing_kill_target",
		database = "mission_giver_vo",
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
				"info_seeing_kill_target"
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
				"user_memory",
				"info_seeing_kill_target",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_seeing_kill_target",
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
		name = "info_seeing_kill_targets",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_seeing_kill_targets",
		database = "mission_giver_vo",
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
				"info_seeing_kill_target"
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
				"user_memory",
				"info_seeing_kill_target",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_seeing_kill_target",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_servo_skull_deployed",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "info_servo_skull_deployed",
		database = "mission_giver_vo",
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
					"tech_priest"
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
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_spotted_it",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_spotted_it",
		database = "mission_giver_vo",
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
				"info_spotted_it"
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
				"user_memory",
				"info_spotted_it",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_spotted_it",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_target_intel_aquired",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_target_intel_aquired",
		database = "mission_giver_vo",
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
				"info_target_intel_aquired"
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
				"user_memory",
				"info_target_intel_aquired",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"info_target_intel_aquired",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_team_mix",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_team_mix",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"info_team_mix"
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "info_valkyrie_approach",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "info_valkyrie_approach",
		database = "mission_giver_vo",
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
					"almost_there"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_brief_control_mission_one",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_brief_control_mission_one",
		database = "mission_giver_vo",
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
				"mission_brief_control_mission_one"
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
				"user_memory",
				"mission_brief_control_mission_one",
				OP.GTEQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"mission_brief_control_mission_one",
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
		name = "mission_brief_control_mission_three",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_brief_control_mission_three",
		database = "mission_giver_vo",
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
					"mission_brief_control_mission_two"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_brief_control_mission_two",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_brief_control_mission_two",
		database = "mission_giver_vo",
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
					"mission_brief_control_mission_one"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_cargo_briefing_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_cargo_briefing_a",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_brief"
			},
			{
				"query_context",
				"starter_line",
				OP.EQ,
				"mission_cargo_briefing_a"
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
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_cargo_briefing_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_cargo_briefing_b",
		database = "mission_giver_vo",
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
					"mission_cargo_briefing_a"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_cargo_briefing_c",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_cargo_briefing_c",
		database = "mission_giver_vo",
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
					"mission_cargo_briefing_b"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_cartel_brief_one",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_cartel_brief_one",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_brief"
			},
			{
				"query_context",
				"starter_line",
				OP.EQ,
				"mission_cartel_brief_one"
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
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_cartel_brief_three",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_cartel_brief_three",
		database = "mission_giver_vo",
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
					"mission_cartel_brief_two"
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
		on_done = {}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_cartel_brief_two",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_cartel_brief_two",
		database = "mission_giver_vo",
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
					"mission_cartel_brief_one"
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
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_cooling_briefing_one",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_cooling_briefing_one",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_brief"
			},
			{
				"query_context",
				"starter_line",
				OP.EQ,
				"mission_cooling_briefing_one"
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
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_cooling_briefing_three",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_cooling_briefing_three",
		database = "mission_giver_vo",
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
					"mission_cooling_briefing_two"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_cooling_briefing_two",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_cooling_briefing_two",
		database = "mission_giver_vo",
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
					"mission_cooling_briefing_one"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		name = "mission_enforcer_briefing_a",
		response = "mission_enforcer_briefing_a",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_brief"
			},
			{
				"query_context",
				"starter_line",
				OP.EQ,
				"mission_enforcer_briefing_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"explicator",
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		name = "mission_enforcer_briefing_b",
		wwise_route = 1,
		response = "mission_enforcer_briefing_b",
		database = "mission_giver_vo",
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
					"mission_enforcer_briefing_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		wwise_route = 1,
		name = "mission_enforcer_briefing_c",
		response = "mission_enforcer_briefing_c",
		database = "mission_giver_vo",
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
					"mission_enforcer_briefing_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"sergeant",
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_enforcer_end_event_conversation_one_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_enforcer_end_event_conversation_one_b",
		database = "mission_giver_vo",
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
					"mission_enforcer_end_event_conversation_one_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_first_scan",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_first_scan",
		database = "mission_giver_vo",
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
				"mission_first_scan"
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
				"mission_first_scan",
				OP.EQ,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_first_scan",
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
		name = "mission_forge_briefing_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_briefing_a",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_brief"
			},
			{
				"query_context",
				"starter_line",
				OP.EQ,
				"mission_forge_briefing_a"
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
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_forge_briefing_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_briefing_b",
		database = "mission_giver_vo",
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
					"mission_forge_briefing_a"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_forge_briefing_c",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_forge_briefing_c",
		database = "mission_giver_vo",
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
					"mission_forge_briefing_b"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_propaganda_briefing_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_propaganda_briefing_a",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_brief"
			},
			{
				"query_context",
				"starter_line",
				OP.EQ,
				"mission_propaganda_briefing_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"pilot",
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_propaganda_briefing_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_propaganda_briefing_b",
		database = "mission_giver_vo",
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
					"mission_propaganda_briefing_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"pilot",
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_propaganda_briefing_c",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_propaganda_briefing_c",
		database = "mission_giver_vo",
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
					"mission_propaganda_briefing_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"pilot",
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_rails_briefing_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_rails_briefing_a",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_brief"
			},
			{
				"query_context",
				"starter_line",
				OP.EQ,
				"mission_rails_briefing_a"
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
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_rails_briefing_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_rails_briefing_b",
		database = "mission_giver_vo",
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
					"mission_rails_briefing_a"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_rails_briefing_c",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_rails_briefing_c",
		database = "mission_giver_vo",
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
					"mission_rails_briefing_b"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_scan_aborted",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_scan_aborted",
		database = "mission_giver_vo",
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
				"mission_scan_aborted"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"mission_scan_aborted",
				OP.GTEQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"mission_scan_aborted",
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
		name = "mission_scan_complete",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "mission_scan_complete",
		database = "mission_giver_vo",
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
				"mission_scan_complete"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"mission_scan_complete",
				OP.GTEQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"",
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
		name = "mission_scan_final",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "mission_scan_final",
		database = "mission_giver_vo",
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
					"level_hab_block_temple_response"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_scan_new_target",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "mission_scan_new_target",
		database = "mission_giver_vo",
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
				"mission_scan_new_target"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"mission_scan_new_target",
				OP.GTEQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"mission_scan_new_target",
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
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_scan_started",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "mission_scan_started",
		database = "mission_giver_vo",
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
				"mission_scan_started"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"mission_scan_started",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"mission_scan_started",
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
		name = "mission_scavenge_briefing_one",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_scavenge_briefing_one",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_brief"
			},
			{
				"query_context",
				"starter_line",
				OP.EQ,
				"mission_scavenge_briefing_one"
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
		on_done = {}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_scavenge_briefing_three",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_scavenge_briefing_three",
		database = "mission_giver_vo",
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
					"mission_scavenge_briefing_two"
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
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_scavenge_briefing_two",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_scavenge_briefing_two",
		database = "mission_giver_vo",
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
					"mission_scavenge_briefing_one"
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
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_station_briefing_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_station_briefing_a",
		database = "mission_giver_vo",
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
				"mission_station_briefing_a"
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
				"",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"",
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
		name = "mission_station_briefing_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_station_briefing_b",
		database = "mission_giver_vo",
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
					"mission_station_briefing_a"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_station_briefing_c",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_station_briefing_c",
		database = "mission_giver_vo",
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
					"mission_station_briefing_b"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_stockpile_briefing_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_stockpile_briefing_a",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_brief"
			},
			{
				"query_context",
				"starter_line",
				OP.EQ,
				"mission_stockpile_briefing_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"pilot",
					"tech_priest"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_stockpile_briefing_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_stockpile_briefing_b",
		database = "mission_giver_vo",
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
					"mission_stockpile_briefing_a"
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
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_stockpile_briefing_c",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_stockpile_briefing_c",
		database = "mission_giver_vo",
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
					"mission_stockpile_briefing_b"
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
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_strain_briefing_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_strain_briefing_a",
		database = "mission_giver_vo",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_brief"
			},
			{
				"query_context",
				"starter_line",
				OP.EQ,
				"mission_strain_briefing_a"
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
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_strain_briefing_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_strain_briefing_b",
		database = "mission_giver_vo",
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
					"mission_strain_briefing_a"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "mission_strain_briefing_c",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "mission_strain_briefing_c",
		database = "mission_giver_vo",
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
					"mission_strain_briefing_b"
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
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "obj_mission_control",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "obj_mission_control",
		database = "mission_giver_vo",
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
				"obj_mission_control"
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
				"user_memory",
				"obj_mission_control",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"obj_mission_control",
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
		name = "obj_mission_delivery_generic",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "obj_mission_delivery_generic",
		database = "mission_giver_vo",
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
				"obj_mission_delivery_generic"
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
				"user_memory",
				"obj_mission_delivery_generic",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"obj_mission_delivery_generic",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "obj_mission_delivery_place",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "obj_mission_delivery_place",
		database = "mission_giver_vo",
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
				"obj_mission_delivery_place"
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
				"user_memory",
				"obj_mission_delivery_place",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"obj_mission_delivery_place",
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
		name = "obj_mission_delivery_take",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "obj_mission_delivery_take",
		database = "mission_giver_vo",
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
				"obj_mission_delivery_take"
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
				"user_memory",
				"obj_mission_delivery_take",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"obj_mission_delivery_take",
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
		name = "obj_mission_demolition",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "obj_mission_demolition",
		database = "mission_giver_vo",
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
				"obj_mission_demolition"
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
				"user_memory",
				"obj_mission_demolition",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"obj_mission_demolition",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "obj_mission_fortification",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "obj_mission_fortification",
		database = "mission_giver_vo",
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
				"obj_mission_fortification"
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
				"user_memory",
				"obj_mission_fortification",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"obj_mission_fortification",
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
		name = "obj_mission_hacking",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "obj_mission_hacking",
		database = "mission_giver_vo",
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
				"obj_mission_hacking"
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
				"obj_mission_hacking",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"obj_mission_hacking",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "obj_mission_kill",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "obj_mission_kill",
		database = "mission_giver_vo",
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
				"obj_mission_kill"
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
				"user_memory",
				"obj_mission_kill ",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"obj_mission_kill ",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
end
