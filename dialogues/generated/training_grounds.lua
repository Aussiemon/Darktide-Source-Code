-- chunkname: @dialogues/generated/training_grounds.lua

return function ()
	define_rule({
		name = "armor_desc_a",
		wwise_route = 42,
		response = "armor_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"armor"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"armor_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"armor_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "chain_light_desc_a",
		wwise_route = 42,
		response = "chain_light_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
					"tg_welcome"
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
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "combat_ability_tutorial_desc_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"combat_ability_tutorial_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_generic_desc_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_generic_desc_a",
		database = "training_grounds",
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
				"combat_ability_psyker_1"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"combat_ability_tutorial_generic_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_generic_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_ogryn_1_desc_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_ogryn_1_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"combat_ability_ogryn_1"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"combat_ability_tutorial_ogryn_1_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_ogryn_1_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_ogryn_desc_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_ogryn_desc_a",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"combat_ability_tutorial_ogryn_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_ogryn_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_psyker_3_desc_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_psyker_3_desc_a",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"combat_ability_tutorial_psyker_3_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_psyker_3_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_psyker_desc_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_psyker_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"combat_ability_tutorial_psyker_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_psyker_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_veteran_3_desc_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_veteran_3_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"combat_ability"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"combat_ability_tutorial_veteran_3_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_veteran_3_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_zealot_3_desc_alt1_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_zealot_3_desc_alt1_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"combat_ability_zealot_1"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"combat_ability_tutorial_zealot_3_desc_alt1_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_zealot_3_desc_alt1_a",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_zealot_3_desc_alt2_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_zealot_3_desc_alt2_a",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_zealot_3_desc_alt3_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_zealot_3_desc_alt3_a",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_zealot_3_desc_alt4_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_zealot_3_desc_alt4_a",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_zealot_3_desc_alt5_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_zealot_3_desc_alt5_a",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_zealot_3_desc_alt6_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_zealot_3_desc_alt6_a",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_zealot_3_desc_alt7_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_zealot_3_desc_alt7_a",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1
			}
		},
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
		name = "combat_ability_tutorial_zealot_desc_a",
		wwise_route = 42,
		response = "combat_ability_tutorial_zealot_desc_a",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"combat_ability_tutorial_zealot_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_zealot_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "corruption_tutorial_desc_a",
		wwise_route = 42,
		response = "corruption_tutorial_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"corruption"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"corruption_tutorial_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"corruption_tutorial_desc_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "self"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "corruption_tutorial_desc_b",
		wwise_route = 42,
		response = "corruption_tutorial_desc_b",
		database = "training_grounds",
		category = "vox_prio_1",
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
					"corruption_tutorial_desc_a"
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
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "dodging_tutorial_desc_a",
		wwise_route = 42,
		response = "dodging_tutorial_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"dodge_left"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"dodging_tutorial_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"dodging_tutorial_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "healing_self_and_others_desc_a",
		wwise_route = 42,
		response = "healing_self_and_others_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"healing_objective_1"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"healing_self_and_others_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"healing_self_and_others_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "health_station_tutorial_desc_a",
		wwise_route = 42,
		response = "health_station_tutorial_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"health_staton_objective_1"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"health_station_tutorial_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"health_station_tutorial_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "incoming_suppression_desc_a",
		wwise_route = 42,
		response = "incoming_suppression_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"incoming_suppression_objective_0"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"incoming_suppression_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"incoming_suppression_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "lock_in_melee_desc_a",
		wwise_route = 42,
		response = "lock_in_melee_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"lock_in_melee"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"lock_in_melee_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"lock_in_melee_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "psyker_ability_desc_a",
		wwise_route = 42,
		response = "psyker_ability_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"biomancer_blitz"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"psyker_ability_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"psyker_ability_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "push_follow_up_desc_a",
		wwise_route = 42,
		response = "push_follow_up_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"push_follow"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"push_follow_up_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"push_follow_up_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "pushing_desc_a",
		wwise_route = 42,
		response = "pushing_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"push"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"pushing_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"pushing_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "ranged_grenade_desc_a",
		wwise_route = 42,
		response = "ranged_grenade_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"grenade"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"ranged_grenade_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"ranged_grenade_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "ranged_grenade_desc_a_bonebreaker_blitz",
		wwise_route = 42,
		response = "ranged_grenade_desc_a_bonebreaker_blitz",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"bonebreaker_blitz"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"ranged_grenade_desc_a_bonebreaker_blitz",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"ranged_grenade_desc_a_bonebreaker_blitz",
				OP.ADD,
				1
			}
		},
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
		name = "ranged_grenade_desc_a_maniac_blitz",
		wwise_route = 42,
		response = "ranged_grenade_desc_a_maniac_blitz",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"maniac_blitz"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"ranged_grenade_desc_a_maniac_blitz",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"ranged_grenade_desc_a_maniac_blitz",
				OP.ADD,
				1
			}
		},
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
		name = "ranged_suppression_desc_a",
		wwise_route = 42,
		response = "ranged_suppression_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"suppression_objective_1"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"ranged_suppression_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"ranged_suppression_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "reviving_tutorial_desc_a",
		wwise_route = 42,
		response = "reviving_tutorial_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"reviving"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"reviving_tutorial_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"reviving_tutorial_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "sprint_slide_desc_a",
		wwise_route = 42,
		response = "sprint_slide_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"slide"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"sprint_slide_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"sprint_slide_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "tagging_desc_a",
		wwise_route = 42,
		response = "tagging_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"tag_sniper"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tagging_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tagging_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "tg_advanced_training_end",
		wwise_route = 42,
		response = "tg_advanced_training_end",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_advanced_training_end",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_advanced_training_end",
				OP.ADD,
				1
			}
		},
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
		name = "tg_armour",
		wwise_route = 42,
		response = "tg_armour",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1
			}
		},
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
		name = "tg_attack_chains",
		wwise_route = 42,
		response = "tg_attack_chains",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_attack_chains",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_attack_chains",
				OP.ADD,
				1
			}
		},
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
		name = "tg_corruption",
		wwise_route = 42,
		response = "tg_corruption",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_corruption",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_corruption",
				OP.ADD,
				1
			}
		},
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
		name = "tg_dodge",
		wwise_route = 42,
		response = "tg_dodge",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_dodge",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_dodge",
				OP.ADD,
				1
			}
		},
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
		name = "tg_grenades",
		wwise_route = 42,
		response = "tg_grenades",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_grenades",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_grenades",
				OP.ADD,
				1
			}
		},
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
		name = "tg_health_and_ammo",
		wwise_route = 42,
		response = "tg_health_and_ammo",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_health_and_ammo",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_health_and_ammo",
				OP.ADD,
				1
			}
		},
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
		name = "tg_health_station",
		wwise_route = 42,
		response = "tg_health_station",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_health_station",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_health_station",
				OP.ADD,
				1
			}
		},
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
		name = "tg_melee_lock",
		wwise_route = 42,
		response = "tg_melee_lock",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_melee_lock",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_melee_lock",
				OP.ADD,
				1
			}
		},
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
		name = "tg_psyker_ability",
		wwise_route = 42,
		response = "tg_psyker_ability",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_psyker_ability",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_psyker_ability",
				OP.ADD,
				1
			}
		},
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
		name = "tg_push",
		wwise_route = 42,
		response = "tg_push",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_push",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_push",
				OP.ADD,
				1
			}
		},
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
		name = "tg_push_follow",
		wwise_route = 42,
		response = "tg_push_follow",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_push_follow",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_push_follow",
				OP.ADD,
				1
			}
		},
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
		name = "tg_reviving",
		wwise_route = 42,
		response = "tg_reviving",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_reviving",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_reviving",
				OP.ADD,
				1
			}
		},
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
		name = "tg_special_attack",
		wwise_route = 42,
		response = "tg_special_attack",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_special_attack",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_special_attack",
				OP.ADD,
				1
			}
		},
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
		name = "tg_sprint_slide",
		wwise_route = 42,
		response = "tg_sprint_slide",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_sprint_slide",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_sprint_slide",
				OP.ADD,
				1
			}
		},
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
		name = "tg_suppression",
		wwise_route = 42,
		response = "tg_suppression",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_suppression",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_suppression",
				OP.ADD,
				1
			}
		},
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
		name = "tg_tagging",
		wwise_route = 42,
		response = "tg_tagging",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_tagging",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_tagging",
				OP.ADD,
				1
			}
		},
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
		name = "tg_toughness",
		wwise_route = 42,
		response = "tg_toughness",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_toughness",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_toughness",
				OP.ADD,
				1
			}
		},
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
		name = "tg_training_end",
		wwise_route = 42,
		response = "tg_training_end",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_training_end",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_training_end",
				OP.ADD,
				1
			}
		},
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
		name = "tg_welcome",
		wwise_route = 42,
		response = "tg_welcome",
		database = "training_grounds",
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
				"welcome"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"tg_welcome",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_welcome",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "self"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "toughness_damage_tutorial_desc_a",
		wwise_route = 42,
		response = "toughness_damage_tutorial_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"toughness_pre_1"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"toughness_damage_tutorial_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"toughness_damage_tutorial_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "toughness_tutorial_2_desc_a",
		wwise_route = 42,
		response = "toughness_tutorial_2_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"toughness_tutorial_2_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"toughness_tutorial_2_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "toughness_tutorial_2_desc_b",
		wwise_route = 42,
		response = "toughness_tutorial_2_desc_b",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"toughness_melee"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"toughness_tutorial_2_desc_b",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"toughness_tutorial_2_desc_b",
				OP.ADD,
				1
			}
		},
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
		name = "toughness_tutorial_desc_a",
		wwise_route = 42,
		response = "toughness_tutorial_desc_a",
		database = "training_grounds",
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
				"disabled_trigger"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"toughness_tutorial_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"toughness_tutorial_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "training_grounds_advanced_training_desc_a",
		wwise_route = 42,
		response = "training_grounds_advanced_training_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"training_end"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"training_grounds_advanced_training_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"training_grounds_advanced_training_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "training_grounds_training_end_desc_a",
		wwise_route = 42,
		response = "training_grounds_training_end_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"training_end_advanced"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"training_grounds_training_end_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"training_grounds_training_end_desc_a",
				OP.ADD,
				1
			}
		},
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
		name = "weapon_special_desc_a",
		wwise_route = 42,
		response = "weapon_special_desc_a",
		database = "training_grounds",
		category = "vox_prio_1",
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
				"weapon_special"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"faction_memory",
				"weapon_special_desc_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"weapon_special_desc_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
end
