return function ()
	define_rule({
		name = "npc_first_interaction_training_ground_psyker_a",
		wwise_route = 42,
		response = "npc_first_interaction_training_ground_psyker_a",
		database = "mission_vo_om_hub_01",
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
					"prologue_hub_go_training_grounds_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "self"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2.5
			}
		}
	})
	define_rule({
		name = "npc_first_interaction_training_ground_psyker_b",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "npc_first_interaction_training_ground_psyker_b",
		database = "mission_vo_om_hub_01",
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
					"npc_first_interaction_training_ground_psyker_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "self"
		}
	})
	define_rule({
		name = "npc_first_interaction_training_ground_psyker_c",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "npc_first_interaction_training_ground_psyker_c",
		database = "mission_vo_om_hub_01",
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
					"npc_first_interaction_training_ground_psyker_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "self"
		}
	})
	define_rule({
		name = "npc_first_interaction_training_ground_psyker_d",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "npc_first_interaction_training_ground_psyker_d",
		database = "mission_vo_om_hub_01",
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
					"npc_first_interaction_training_ground_psyker_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "self"
		}
	})
	define_rule({
		name = "npc_first_interaction_training_ground_psyker_e",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "npc_first_interaction_training_ground_psyker_e",
		database = "mission_vo_om_hub_01",
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
					"npc_first_interaction_training_ground_psyker_d"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "self"
		}
	})
	define_rule({
		pre_wwise_event = "play_radio_static_start",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "prologue_hub_go_training_grounds_a",
		wwise_route = 1,
		response = "prologue_hub_go_training_grounds_a",
		database = "mission_vo_om_hub_01",
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
				"prologue_hub_go_training_grounds"
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
				"prologue_hub_go_training_grounds",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_hub_go_training_grounds",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "self"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "prologue_hub_go_training_grounds_b",
		wwise_route = 1,
		response = "prologue_hub_go_training_grounds_b",
		database = "mission_vo_om_hub_01",
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
					"prologue_hub_go_training_grounds_a"
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
		}
	})
	define_rule({
		pre_wwise_event = "play_radio_static_start",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "prologue_hub_mourningstar_intro_a",
		wwise_route = 1,
		response = "prologue_hub_mourningstar_intro_a",
		database = "mission_vo_om_hub_01",
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
				"prologue_hub_mourningstar_intro"
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
				"prologue_hub_mourningstar_intro",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"prologue_hub_mourningstar_intro",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "self"
		}
	})
	define_rule({
		concurrent_wwise_event = "play_vox_static_loop",
		wwise_route = 1,
		name = "prologue_hub_mourningstar_intro_b",
		response = "prologue_hub_mourningstar_intro_b",
		database = "mission_vo_om_hub_01",
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
					"prologue_hub_mourningstar_intro_a"
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
			target = "self"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "prologue_hub_mourningstar_intro_c",
		wwise_route = 1,
		response = "prologue_hub_mourningstar_intro_c",
		database = "mission_vo_om_hub_01",
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
					"prologue_hub_mourningstar_intro_b"
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
			target = "disabled"
		}
	})
end
