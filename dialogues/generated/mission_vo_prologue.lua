return function ()
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "melee_gameplay_01",
		wwise_route = 1,
		response = "melee_gameplay_01",
		database = "mission_vo_prologue",
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
				"melee_gameplay_01"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			},
			{
				"faction_memory",
				"melee_gameplay_01",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"melee_gameplay_01",
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
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "melee_gameplay_02",
		response = "melee_gameplay_02",
		database = "mission_vo_prologue",
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
					"prologue_monologue_05"
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
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.2
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "melee_gameplay_03",
		response = "melee_gameplay_03",
		database = "mission_vo_prologue",
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
					"prologue_combat_04"
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
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 4
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "melee_gameplay_04",
		response = "melee_gameplay_04",
		database = "mission_vo_prologue",
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
				"melee_gameplay_04"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			},
			{
				"faction_memory",
				"melee_gameplay_04",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"melee_gameplay_04",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "prologue_combat_01",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_combat_01",
		database = "mission_vo_prologue",
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
				"prologue_combat_01"
			},
			{
				"faction_memory",
				"prologue_combat_01",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_combat_01",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "prologue_combat_02",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_combat_02",
		database = "mission_vo_prologue",
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
				"prologue_combat_02"
			},
			{
				"faction_memory",
				"prologue_combat_02",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_combat_02",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "prologue_combat_03",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_combat_03",
		database = "mission_vo_prologue",
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
				"prologue_combat_03"
			},
			{
				"faction_memory",
				"prologue_combat_03",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_combat_03",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		name = "prologue_combat_04",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_combat_04",
		database = "mission_vo_prologue",
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
				"prologue_combat_04"
			},
			{
				"faction_memory",
				"prologue_combat_04",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_combat_04",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		name = "prologue_combat_05",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_combat_05",
		database = "mission_vo_prologue",
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
				"prologue_combat_05"
			},
			{
				"user_context",
				"enemies_close",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"prologue_combat_05",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_combat_05",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "prologue_end_event_01",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_end_event_01",
		database = "mission_vo_prologue",
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
				"prologue_end_event_01"
			},
			{
				"faction_memory",
				"prologue_end_event_01",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_end_event_01",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		concurrent_wwise_event = "play_vox_static_loop",
		wwise_route = 1,
		name = "prologue_end_event_02",
		response = "prologue_end_event_02",
		database = "mission_vo_prologue",
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
				"prologue_end_event_02"
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
				"faction_memory",
				"prologue_end_event_02",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_end_event_02",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "prologue_end_event_03",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_end_event_03",
		database = "mission_vo_prologue",
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
				"prologue_end_event_03"
			},
			{
				"faction_memory",
				"prologue_end_event_03",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_end_event_03",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		concurrent_wwise_event = "play_vox_static_loop",
		wwise_route = 1,
		name = "prologue_end_event_04",
		response = "prologue_end_event_04",
		database = "mission_vo_prologue",
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
				"prologue_end_event_04"
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
				"faction_memory",
				"prologue_end_event_04",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_end_event_04",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "prologue_end_event_conversation_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_end_event_conversation_a",
		database = "mission_vo_prologue",
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
				"prologue_end_event_conversation_a"
			},
			{
				"faction_memory",
				"prologue_end_event_conversation_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_end_event_conversation_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "prologue_end_event_conversation_b",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_end_event_conversation_b",
		database = "mission_vo_prologue",
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
				"prologue_end_event_conversation_b"
			},
			{
				"faction_memory",
				"prologue_end_event_conversation_b",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_end_event_conversation_b",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "prologue_firefight_conversation_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_firefight_conversation_a",
		database = "mission_vo_prologue",
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
				"prologue_firefight_conversation_a"
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"prologue"
			},
			{
				"faction_memory",
				"prologue_firefight_conversation_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_firefight_conversation_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "prologue_firefight_conversation_b",
		wwise_route = 0,
		response = "prologue_firefight_conversation_b",
		database = "mission_vo_prologue",
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
					"prologue_firefight_conversation_a"
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
		name = "prologue_monologue_01",
		wwise_route = 0,
		response = "prologue_monologue_01",
		database = "mission_vo_prologue",
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
					"melee_gameplay_01"
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
		name = "prologue_monologue_02",
		wwise_route = 0,
		response = "prologue_monologue_02",
		database = "mission_vo_prologue",
		category = "player_prio_0",
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
				"prologue_monologue_02"
			},
			{
				"faction_memory",
				"prologue_monologue_02",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_02",
				OP.ADD,
				1
			}
		},
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
		name = "prologue_monologue_03",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_monologue_03",
		database = "mission_vo_prologue",
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
				"prologue_monologue_03"
			},
			{
				"faction_memory",
				"prologue_monologue_03",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_03",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "prologue_monologue_04",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_monologue_04",
		database = "mission_vo_prologue",
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
				"prologue_monologue_04"
			},
			{
				"faction_memory",
				"prologue_monologue_04",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_04",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		name = "prologue_monologue_05",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_monologue_05",
		database = "mission_vo_prologue",
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
				"prologue_monologue_05"
			},
			{
				"faction_memory",
				"prologue_monologue_05",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_05",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		name = "prologue_monologue_06",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_monologue_06",
		database = "mission_vo_prologue",
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
				"prologue_monologue_06"
			},
			{
				"faction_memory",
				"prologue_monologue_06",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_06",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "prologue_monologue_07",
		wwise_route = 0,
		response = "prologue_monologue_07",
		database = "mission_vo_prologue",
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
					""
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
		name = "prologue_monologue_08",
		wwise_route = 0,
		response = "prologue_monologue_08",
		database = "mission_vo_prologue",
		category = "enemy_alerts_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_executor"
			},
			{
				"faction_memory",
				"renegade_executor",
				OP.EQ,
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"renegade_executor",
				OP.ADD,
				"1"
			}
		},
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
		name = "prologue_monologue_09",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_monologue_09",
		database = "mission_vo_prologue",
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
				"prologue_monologue_09"
			},
			{
				"faction_memory",
				"prologue_monologue_09",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_09",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "prologue_monologue_10",
		category = "player_prio_0",
		wwise_route = 0,
		response = "prologue_monologue_10",
		database = "mission_vo_prologue",
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
				"prologue_monologue_10"
			},
			{
				"faction_memory",
				"prologue_monologue_10",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_10",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "ranged_gameplay_01",
		category = "player_prio_0",
		wwise_route = 0,
		response = "ranged_gameplay_01",
		database = "mission_vo_prologue",
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
				"ranged_gameplay_01"
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"prologue"
			},
			{
				"faction_memory",
				"ranged_gameplay_01",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"ranged_gameplay_01",
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
		name = "ranged_gameplay_02",
		response = "ranged_gameplay_02",
		database = "mission_vo_prologue",
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
					"ranged_gameplay_01"
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
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "ranged_gameplay_03",
		wwise_route = 0,
		response = "ranged_gameplay_03",
		database = "mission_vo_prologue",
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
					"ranged_gameplay_02"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"explicator_a"
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
		name = "ranged_gameplay_04",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "ranged_gameplay_04",
		database = "mission_vo_prologue",
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
					"ranged_gameplay_03"
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
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "ranged_gameplay_05",
		response = "ranged_gameplay_05",
		database = "mission_vo_prologue",
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
				"ranged_gameplay_05"
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
			target = "players"
		}
	})
	define_rule({
		name = "ranged_gameplay_06",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "ranged_gameplay_06",
		database = "mission_vo_prologue",
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
					"ranged_gameplay_05"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"explicator_a"
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
		name = "ranged_gameplay_07",
		category = "player_prio_0",
		wwise_route = 0,
		response = "ranged_gameplay_07",
		database = "mission_vo_prologue",
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
				"ranged_gameplay_07"
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"prologue"
			},
			{
				"faction_memory",
				"ranged_gameplay_07",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"ranged_gameplay_07",
				OP.ADD,
				1
			}
		}
	})
end
