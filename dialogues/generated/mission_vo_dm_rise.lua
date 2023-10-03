return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_airlock_ponderings_a",
		response = "mission_rise_airlock_ponderings_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_airlock_ponderings_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_airlock_ponderings_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_airlock_ponderings_a",
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
		name = "mission_rise_banter_one_a",
		response = "mission_rise_banter_one_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_banter_one_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
				}
			},
			{
				"faction_memory",
				"mission_rise_banter_one_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_banter_one_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_banter_one_a_sergeant_branch",
		response = "mission_rise_banter_one_a_sergeant_branch",
		database = "mission_vo_dm_rise",
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
				"mission_rise_banter_one_a"
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
				"mission_rise_banter_one_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_banter_one_a",
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
		name = "mission_rise_banter_one_b",
		response = "mission_rise_banter_one_b",
		database = "mission_vo_dm_rise",
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
					"mission_rise_banter_one_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_banter_three_a",
		response = "mission_rise_banter_three_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_banter_three_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
				}
			},
			{
				"faction_memory",
				"mission_rise_banter_three_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_banter_three_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_banter_three_a_sergeant_branch",
		response = "mission_rise_banter_three_a_sergeant_branch",
		database = "mission_vo_dm_rise",
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
				"mission_rise_banter_three_a"
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
				"mission_rise_banter_three_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_banter_three_a",
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
		name = "mission_rise_banter_three_b",
		response = "mission_rise_banter_three_b",
		database = "mission_vo_dm_rise",
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
					"mission_rise_banter_three_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_banter_two_a",
		response = "mission_rise_banter_two_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_banter_two_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
					"sergeant"
				}
			},
			{
				"faction_memory",
				"mission_rise_banter_two_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_banter_two_a",
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
		name = "mission_rise_banter_two_b",
		response = "mission_rise_banter_two_b",
		database = "mission_vo_dm_rise",
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
					"mission_rise_banter_two_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_blast_gate_a",
		response = "mission_rise_blast_gate_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_end_event_corruptor_two_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_blast_gate_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_blast_gate_a",
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
		name = "mission_rise_demolisher_a",
		response = "mission_rise_demolisher_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_demolisher_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser"
				}
			},
			{
				"faction_memory",
				"mission_rise_demolisher_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_demolisher_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_demolisher_melk_01_a",
		response = "mission_rise_demolisher_melk_01_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_demolisher_melk_01_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_demolisher_melk",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_demolisher_melk",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_demolisher_melk_01_b",
		response = "mission_rise_demolisher_melk_01_b",
		database = "mission_vo_dm_rise",
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
					"mission_rise_demolisher_melk_01_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
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
		name = "mission_rise_demolisher_melk_02_a",
		response = "mission_rise_demolisher_melk_02_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_demolisher_melk_02_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_demolisher_melk",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_demolisher_melk",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_demolisher_melk_02_b",
		response = "mission_rise_demolisher_melk_02_b",
		database = "mission_vo_dm_rise",
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
					"mission_rise_demolisher_melk_02_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
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
		name = "mission_rise_demolisher_melk_03_a",
		response = "mission_rise_demolisher_melk_03_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_demolisher_melk_03_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_demolisher_melk",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_demolisher_melk",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_demolisher_melk_03_b",
		response = "mission_rise_demolisher_melk_03_b",
		database = "mission_vo_dm_rise",
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
					"mission_rise_demolisher_melk_03_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
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
		name = "mission_rise_elevator_conversation_a",
		response = "mission_rise_elevator_conversation_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_elevator_conversation_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
				}
			},
			{
				"faction_memory",
				"mission_rise_elevator_conversation_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_elevator_conversation_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		pre_wwise_event = "play_radio_static_start",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "mission_rise_elevator_conversation_b",
		wwise_route = 1,
		response = "mission_rise_elevator_conversation_b",
		database = "mission_vo_dm_rise",
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
					"mission_rise_elevator_conversation_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "mission_rise_elevator_conversation_c",
		wwise_route = 1,
		response = "mission_rise_elevator_conversation_c",
		database = "mission_vo_dm_rise",
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
					"mission_rise_elevator_conversation_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_elevator_conversation_d",
		response = "mission_rise_elevator_conversation_d",
		database = "mission_vo_dm_rise",
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
					"mission_rise_elevator_conversation_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_elevator_monologue_a",
		response = "mission_rise_elevator_monologue_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_elevator_conversation_a"
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
				"mission_rise_elevator_monologue_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_elevator_monologue_a",
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
		name = "mission_rise_end_event_complete_a",
		response = "mission_rise_end_event_complete_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_end_event_complete_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_end_event_complete_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_end_event_complete_a",
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
		name = "mission_rise_end_event_complete_b",
		response = "mission_rise_end_event_complete_b",
		database = "mission_vo_dm_rise",
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
					"mission_rise_end_event_complete_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_end_event_corruptor_one_a",
		response = "mission_rise_end_event_corruptor_one_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_end_event_corruptor_one_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_end_event_corruptor_one_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_end_event_corruptor_one_a",
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
		name = "mission_rise_end_event_corruptor_one_dead_a",
		response = "mission_rise_end_event_corruptor_one_dead_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_end_event_corruptor_one_dead_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_end_event_corruptor_one_dead_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_end_event_corruptor_one_dead_a",
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
		name = "mission_rise_end_event_corruptor_two_dead_a",
		response = "mission_rise_end_event_corruptor_two_dead_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_end_event_corruptor_two_dead_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_end_event_corruptor_two_dead_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_end_event_corruptor_two_dead_a",
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
		name = "mission_rise_end_event_riser_moving_a",
		response = "mission_rise_end_event_riser_moving_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_end_event_riser_moving_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_end_event_riser_moving_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_end_event_riser_moving_a",
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
		name = "mission_rise_end_event_start_a",
		response = "mission_rise_end_event_start_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_end_event_start_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser"
				}
			},
			{
				"faction_memory",
				"mission_rise_end_event_start_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_end_event_start_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_end_event_start_b",
		response = "mission_rise_end_event_start_b",
		database = "mission_vo_dm_rise",
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
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_purser_a__mission_rise_end_event_start_a_01",
					"loc_purser_a__mission_rise_end_event_start_a_02",
					"loc_purser_a__mission_rise_end_event_start_a_03",
					"loc_purser_a__mission_rise_end_event_start_a_04"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_end_event_start_c",
		response = "mission_rise_end_event_start_c",
		database = "mission_vo_dm_rise",
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
					"mission_rise_end_event_start_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_event_one_complete_a",
		response = "mission_rise_event_one_complete_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_event_one_complete_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_event_one_complete_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_event_one_complete_a",
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
		name = "mission_rise_event_one_start_a",
		response = "mission_rise_event_one_start_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_event_one_start_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_event_one_start_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_event_one_start_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_event_one_start_b",
		response = "mission_rise_event_one_start_b",
		database = "mission_vo_dm_rise",
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
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_purser_a__mission_rise_event_one_start_a_01",
					"loc_purser_a__mission_rise_event_one_start_a_02",
					"loc_purser_a__mission_rise_event_one_start_a_03",
					"loc_purser_a__mission_rise_event_one_start_a_04"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_event_one_start_c",
		response = "mission_rise_event_one_start_c",
		database = "mission_vo_dm_rise",
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
					"mission_rise_event_one_start_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_event_one_step_one_complete_a",
		response = "mission_rise_event_one_step_one_complete_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_event_one_step_one_complete_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_event_one_step_one_complete_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_event_one_step_one_complete_a",
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
		name = "mission_rise_first_objective_a",
		response = "mission_rise_first_objective_a",
		database = "mission_vo_dm_rise",
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
					"mission_rise_start_b_sergeant_branch_response"
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
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "mission_rise_first_objective_response",
		wwise_route = 0,
		response = "mission_rise_first_objective_response",
		database = "mission_vo_dm_rise",
		category = "conversations_prio_0",
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
					"mission_rise_first_objective_a",
					"mission_rise_start_e"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_first_tracks_a",
		response = "mission_rise_first_tracks_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_first_tracks_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_first_tracks_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_first_tracks_a",
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
		name = "mission_rise_keep_coming_a",
		response = "mission_rise_keep_coming_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_keep_coming_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_keep_coming_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_keep_coming_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_rise_keep_coming_b",
		wwise_route = 0,
		response = "mission_rise_keep_coming_b",
		database = "mission_vo_dm_rise",
		category = "conversations_prio_0",
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
					"event_survive_keep_coming_a"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_maze_a",
		response = "mission_rise_maze_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_maze_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_maze_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_maze_a",
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
		name = "mission_rise_pipe_bridge_a",
		response = "mission_rise_pipe_bridge_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_pipe_bridge_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_pipe_bridge_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_pipe_bridge_a",
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
		name = "mission_rise_pipe_bridge_b",
		response = "mission_rise_pipe_bridge_b",
		database = "mission_vo_dm_rise",
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
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_contract_vendor_a__mission_rise_pipe_bridge_a_01",
					"loc_contract_vendor_a__mission_rise_pipe_bridge_a_02",
					"loc_contract_vendor_a__mission_rise_pipe_bridge_a_03",
					"loc_contract_vendor_a__mission_rise_pipe_bridge_a_04"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_pipe_bridge_c",
		response = "mission_rise_pipe_bridge_c",
		database = "mission_vo_dm_rise",
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
					"mission_rise_pipe_bridge_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_siding_a",
		response = "mission_rise_siding_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_siding_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_siding_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_siding_a",
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
		name = "mission_rise_start_a",
		response = "mission_rise_start_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_start_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser"
				}
			},
			{
				"faction_memory",
				"mission_rise_start_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_start_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "mission_rise_start_b",
		wwise_route = 1,
		response = "mission_rise_start_b",
		database = "mission_vo_dm_rise",
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
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_purser_a__mission_rise_start_a_01",
					"loc_purser_a__mission_rise_start_a_02",
					"loc_purser_a__mission_rise_start_a_03",
					"loc_purser_a__mission_rise_start_a_04"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default"
		}
	})
	define_rule({
		name = "mission_rise_start_b_sergeant_branch",
		wwise_route = 0,
		response = "mission_rise_start_b_sergeant_branch",
		database = "mission_vo_dm_rise",
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_sergeant_a__mission_rise_start_a_01",
					"loc_sergeant_a__mission_rise_start_a_02",
					"loc_sergeant_a__mission_rise_start_a_03",
					"loc_sergeant_a__mission_rise_start_a_04"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn",
					"psyker",
					"veteran",
					"zealot"
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
		name = "mission_rise_start_b_sergeant_branch_response",
		wwise_route = 0,
		response = "mission_rise_start_b_sergeant_branch_response",
		database = "mission_vo_dm_rise",
		category = "conversations_prio_0",
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
					"mission_rise_start_b_sergeant_branch"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_start_c",
		response = "mission_rise_start_c",
		database = "mission_vo_dm_rise",
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
					"mission_rise_start_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_start_d",
		response = "mission_rise_start_d",
		database = "mission_vo_dm_rise",
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
					"mission_rise_start_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_start_e",
		response = "mission_rise_start_e",
		database = "mission_vo_dm_rise",
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
					"mission_rise_start_d"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "mission_rise_through_depot_a",
		response = "mission_rise_through_depot_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_through_depot_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_through_depot_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_through_depot_a",
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
		name = "mission_rise_tracks_two_a",
		response = "mission_rise_tracks_two_a",
		database = "mission_vo_dm_rise",
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
				"mission_rise_tracks_two_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
					"purser",
					"contract_vendor"
				}
			},
			{
				"faction_memory",
				"mission_rise_tracks_two_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"mission_rise_tracks_two_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
end
