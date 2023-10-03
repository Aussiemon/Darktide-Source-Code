local contracts_view_settings = {
	task_complexity_easy_icon = "content/ui/materials/icons/contracts/complexity_easy",
	task_description_complete_missions = "loc_contracts_task_description_complete_missions",
	task_description_complete_missions_by_name = "loc_contracts_task_description_complete_missions_by_name",
	task_fulfilled_check_mark = "",
	task_label_complete_mission_no_death = "loc_contracts_task_label_complete_mission_no_death",
	contract_reward_string_format = "+%d",
	task_description_collect_pickups = "loc_contracts_task_description_collect_pickups",
	task_description_block_damage = "loc_contracts_task_description_block_damage",
	task_label_kill_minions = "loc_contracts_task_label_kill_minions",
	task_label_collect_pickups = "loc_contracts_task_label_collect_pickups",
	task_label_complete_missions_by_name = "loc_contracts_task_label_complete_missions_by_name",
	task_label_complete_missions = "loc_contracts_task_label_complete_missions",
	task_complexity_easy = "loc_contracts_contract_complexity_easy",
	task_description_kill_bosses = "loc_contracts_task_description_kill_bosses",
	task_description_kill_minions = "loc_contracts_task_description_kill_minions",
	task_complexity_medium_icon = "content/ui/materials/icons/contracts/complexity_medium",
	task_label_block_damage = "loc_contracts_task_label_block_damage",
	reroll_input_action = "confirm_pressed",
	task_description_complete_mission_no_death = "loc_contracts_task_description_complete_mission_no_death",
	task_label_kill_bosses = "loc_contracts_task_label_kill_bosses",
	task_complexity_hard_icon = "content/ui/materials/icons/contracts/complexity_hard",
	task_reward_string_format = "%d",
	task_complexity_tutorial_icon = "content/ui/materials/icons/contracts/complexity_tutorial",
	task_complexity_tutorial = "loc_contracts_contract_complexity_tutorial",
	contract_progress_localization_string_format = "loc_contracts_contract_reward_tasks_completed",
	task_complexity_medium = "loc_contracts_contract_complexity_medium",
	task_info_reward_string_format = "+%d",
	task_description_collect_resources = "loc_contracts_task_description_collect_resources",
	num_tasks_in_list = 8,
	wallet_type = "marks",
	task_label_collect_resources = "loc_contracts_task_label_collect_resources",
	task_complexity_hard = "loc_contracts_contract_complexity_hard",
	task_parameter_strings = {
		renegade = "loc_contract_task_enemy_type_renegade",
		tome = "loc_contract_task_pickup_type_tome",
		cultist = "loc_contract_task_enemy_type_cultist",
		traitor = "loc_contract_task_enemy_type_traitor",
		tome_or_grimoire = "loc_contract_task_pickup_type_grimoire_or_tome",
		melee = "loc_contract_task_weapon_type_melee",
		grimoire = "loc_contract_task_pickup_type_grimoire",
		ranged = "loc_contract_task_weapon_type_ranged"
	},
	vo_event_replacing_task = {
		"contract_vendor_replacing_task"
	},
	vo_event_vendor_greeting = {
		"hub_interact_contract_vendor"
	},
	vo_event_vendor_first_interaction = {
		"npc_first_interaction_contract_vendor_a",
		"npc_first_interaction_contract_vendor_b",
		"npc_first_interaction_contract_vendor_c",
		"npc_first_interaction_contract_vendor_d",
		"npc_first_interaction_contract_vendor_e"
	}
}

return settings("ContractsViewSettings", contracts_view_settings)
