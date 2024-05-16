-- chunkname: @dialogues/generated/training_grounds.lua

return function ()
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "armor_desc_a",
		response = "armor_desc_a",
		wwise_route = 42,
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
				"armor",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"armor_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"armor_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "chain_light_desc_a",
		response = "chain_light_desc_a",
		wwise_route = 42,
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
					"tg_welcome",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
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
		category = "vox_prio_1",
		database = "training_grounds",
		name = "combat_ability_tutorial_desc_a",
		response = "combat_ability_tutorial_desc_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"combat_ability_tutorial_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "combat_ability_tutorial_generic_desc_a",
		response = "combat_ability_tutorial_generic_desc_a",
		wwise_route = 42,
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
				"combat_ability_psyker_1",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"combat_ability_tutorial_generic_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_generic_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "combat_ability_tutorial_ogryn_1_desc_a",
		response = "combat_ability_tutorial_ogryn_1_desc_a",
		wwise_route = 42,
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
				"combat_ability_ogryn_1",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"combat_ability_tutorial_ogryn_1_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_ogryn_1_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "combat_ability_tutorial_ogryn_desc_a",
		response = "combat_ability_tutorial_ogryn_desc_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"combat_ability_tutorial_ogryn_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_ogryn_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "combat_ability_tutorial_psyker_3_desc_a",
		response = "combat_ability_tutorial_psyker_3_desc_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"combat_ability_tutorial_psyker_3_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_psyker_3_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "combat_ability_tutorial_psyker_desc_a",
		response = "combat_ability_tutorial_psyker_desc_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"combat_ability_tutorial_psyker_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_psyker_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "combat_ability_tutorial_veteran_3_desc_a",
		response = "combat_ability_tutorial_veteran_3_desc_a",
		wwise_route = 42,
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
				"combat_ability",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"combat_ability_tutorial_veteran_3_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_veteran_3_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "combat_ability_tutorial_zealot_3_desc_alt1_a",
		response = "combat_ability_tutorial_zealot_3_desc_alt1_a",
		wwise_route = 42,
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
				"combat_ability_zealot_1",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"combat_ability_tutorial_zealot_3_desc_alt1_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_zealot_3_desc_alt1_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "combat_ability_tutorial_zealot_3_desc_alt2_a",
		response = "combat_ability_tutorial_zealot_3_desc_alt2_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "combat_ability_tutorial_zealot_3_desc_alt3_a",
		response = "combat_ability_tutorial_zealot_3_desc_alt3_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "combat_ability_tutorial_zealot_3_desc_alt4_a",
		response = "combat_ability_tutorial_zealot_3_desc_alt4_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "combat_ability_tutorial_zealot_3_desc_alt5_a",
		response = "combat_ability_tutorial_zealot_3_desc_alt5_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "combat_ability_tutorial_zealot_3_desc_alt6_a",
		response = "combat_ability_tutorial_zealot_3_desc_alt6_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "combat_ability_tutorial_zealot_3_desc_alt7_a",
		response = "combat_ability_tutorial_zealot_3_desc_alt7_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "combat_ability_tutorial_zealot_desc_a",
		response = "combat_ability_tutorial_zealot_desc_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"combat_ability_tutorial_zealot_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_ability_tutorial_zealot_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "corruption_tutorial_desc_a",
		response = "corruption_tutorial_desc_a",
		wwise_route = 42,
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
				"corruption",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"corruption_tutorial_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"corruption_tutorial_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "corruption_tutorial_desc_b",
		response = "corruption_tutorial_desc_b",
		wwise_route = 42,
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
					"corruption_tutorial_desc_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
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
		category = "vox_prio_1",
		database = "training_grounds",
		name = "dodging_tutorial_desc_a",
		response = "dodging_tutorial_desc_a",
		wwise_route = 42,
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
				"dodge_left",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"dodging_tutorial_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"dodging_tutorial_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "healing_self_and_others_desc_a",
		response = "healing_self_and_others_desc_a",
		wwise_route = 42,
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
				"healing_objective_1",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"healing_self_and_others_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"healing_self_and_others_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "health_station_tutorial_desc_a",
		response = "health_station_tutorial_desc_a",
		wwise_route = 42,
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
				"health_station_objective_1",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"health_station_tutorial_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"health_station_tutorial_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "incoming_suppression_desc_a",
		response = "incoming_suppression_desc_a",
		wwise_route = 42,
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
				"incoming_suppression_objective_0",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"incoming_suppression_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"incoming_suppression_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "lock_in_melee_desc_a",
		response = "lock_in_melee_desc_a",
		wwise_route = 42,
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
				"lock_in_melee",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"lock_in_melee_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"lock_in_melee_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "psyker_ability_desc_a",
		response = "psyker_ability_desc_a",
		wwise_route = 42,
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
				"biomancer_blitz",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"psyker_ability_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"psyker_ability_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "push_follow_up_desc_a",
		response = "push_follow_up_desc_a",
		wwise_route = 42,
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
				"push_follow",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"push_follow_up_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"push_follow_up_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "pushing_desc_a",
		response = "pushing_desc_a",
		wwise_route = 42,
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
				"push",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"pushing_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"pushing_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "ranged_grenade_desc_a",
		response = "ranged_grenade_desc_a",
		wwise_route = 42,
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
				"grenade",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"ranged_grenade_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"ranged_grenade_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "ranged_grenade_desc_a_bonebreaker_blitz",
		response = "ranged_grenade_desc_a_bonebreaker_blitz",
		wwise_route = 42,
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
				"bonebreaker_blitz",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"ranged_grenade_desc_a_bonebreaker_blitz",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"ranged_grenade_desc_a_bonebreaker_blitz",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "ranged_grenade_desc_a_maniac_blitz",
		response = "ranged_grenade_desc_a_maniac_blitz",
		wwise_route = 42,
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
				"maniac_blitz",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"ranged_grenade_desc_a_maniac_blitz",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"ranged_grenade_desc_a_maniac_blitz",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "ranged_suppression_desc_a",
		response = "ranged_suppression_desc_a",
		wwise_route = 42,
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
				"suppression_objective_1",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"ranged_suppression_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"ranged_suppression_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "reviving_tutorial_desc_a",
		response = "reviving_tutorial_desc_a",
		wwise_route = 42,
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
				"reviving",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"reviving_tutorial_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"reviving_tutorial_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "sprint_slide_desc_a",
		response = "sprint_slide_desc_a",
		wwise_route = 42,
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
				"slide",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"sprint_slide_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"sprint_slide_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "tagging_desc_a",
		response = "tagging_desc_a",
		wwise_route = 42,
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
				"tag_sniper",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tagging_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tagging_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_advanced_training_end",
		response = "tg_advanced_training_end",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_advanced_training_end",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_advanced_training_end",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_armour",
		response = "tg_armour",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_armour",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_armour",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_attack_chains",
		response = "tg_attack_chains",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_attack_chains",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_attack_chains",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_corruption",
		response = "tg_corruption",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_corruption",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_corruption",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_dodge",
		response = "tg_dodge",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_dodge",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_dodge",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_grenades",
		response = "tg_grenades",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_grenades",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_grenades",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_health_and_ammo",
		response = "tg_health_and_ammo",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_health_and_ammo",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_health_and_ammo",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_health_station",
		response = "tg_health_station",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_health_station",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_health_station",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_melee_lock",
		response = "tg_melee_lock",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_melee_lock",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_melee_lock",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_psyker_ability",
		response = "tg_psyker_ability",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_psyker_ability",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_psyker_ability",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_push",
		response = "tg_push",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_push",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_push",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_push_follow",
		response = "tg_push_follow",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_push_follow",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_push_follow",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_reviving",
		response = "tg_reviving",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_reviving",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_reviving",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_special_attack",
		response = "tg_special_attack",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_special_attack",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_special_attack",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_sprint_slide",
		response = "tg_sprint_slide",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_sprint_slide",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_sprint_slide",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_suppression",
		response = "tg_suppression",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_suppression",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_suppression",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_tagging",
		response = "tg_tagging",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_tagging",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_tagging",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_toughness",
		response = "tg_toughness",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_toughness",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_toughness",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_training_end",
		response = "tg_training_end",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_training_end",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_training_end",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "tg_welcome",
		response = "tg_welcome",
		wwise_route = 42,
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
				"welcome",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"tg_welcome",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"tg_welcome",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "toughness_damage_tutorial_desc_a",
		response = "toughness_damage_tutorial_desc_a",
		wwise_route = 42,
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
				"toughness_pre_1",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"toughness_damage_tutorial_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"toughness_damage_tutorial_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "toughness_tutorial_2_desc_a",
		response = "toughness_tutorial_2_desc_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"toughness_tutorial_2_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"toughness_tutorial_2_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "toughness_tutorial_2_desc_b",
		response = "toughness_tutorial_2_desc_b",
		wwise_route = 42,
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
				"toughness_melee",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"toughness_tutorial_2_desc_b",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"toughness_tutorial_2_desc_b",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "training_grounds",
		name = "toughness_tutorial_desc_a",
		response = "toughness_tutorial_desc_a",
		wwise_route = 42,
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
				"disabled_trigger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"toughness_tutorial_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"toughness_tutorial_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "training_grounds_advanced_training_desc_a",
		response = "training_grounds_advanced_training_desc_a",
		wwise_route = 42,
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
				"training_end",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"training_grounds_advanced_training_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"training_grounds_advanced_training_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "training_grounds_training_end_desc_a",
		response = "training_grounds_training_end_desc_a",
		wwise_route = 42,
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
				"training_end_advanced",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"training_grounds_training_end_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"training_grounds_training_end_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_1",
		database = "training_grounds",
		name = "weapon_special_desc_a",
		response = "weapon_special_desc_a",
		wwise_route = 42,
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
				"weapon_special",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"faction_memory",
				"weapon_special_desc_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"weapon_special_desc_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
end
