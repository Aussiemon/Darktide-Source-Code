return function ()
	define_rule({
		name = "tg_advanced_training_end",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_advanced_training_end",
		database = "training_grounds",
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
				"end_of_tg"
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_armour",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_armour",
		database = "training_grounds",
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
				"armor_objective_1"
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_attack_chains",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_attack_chains",
		database = "training_grounds",
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
				"attack_chain"
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_combat_ability",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_combat_ability",
		database = "training_grounds",
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
				OP.SET_INCLUDES,
				args = {
					"combat_ability_ogryn_1",
					"combat_ability_ogryn_2",
					"combat_ability_ogryn_3",
					"combat_ability_psyker_1",
					"combat_ability_psyker_2",
					"combat_ability_psyker_3",
					"combat_ability_zealot_1",
					"combat_ability_zealot_2",
					"combat_ability_zealot_3",
					"combat_ability_veteran_1",
					"combat_ability_veteran_2",
					"combat_ability_veteran_3"
				}
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
				"tg_combat_ability",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"tg_combat_ability",
				OP.ADD,
				1
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_corruption",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_corruption",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_dodge",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_dodge",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_grenades",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_grenades",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_health_and_ammo",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_health_and_ammo",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_health_station",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_health_station",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_melee_lock",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_melee_lock",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_psyker_ability",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_psyker_ability",
		database = "training_grounds",
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
				"psyker_ability"
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_push",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_push",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_push_follow",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_push_follow",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_reviving",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_reviving",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_special_attack",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_special_attack",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_sprint_slide",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_sprint_slide",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_suppression",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_suppression",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_tagging",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_tagging",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_toughness",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_toughness",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_training_end",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_training_end",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "tg_welcome",
		category = "vox_prio_0",
		wwise_route = 42,
		response = "tg_welcome",
		database = "training_grounds",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
end
