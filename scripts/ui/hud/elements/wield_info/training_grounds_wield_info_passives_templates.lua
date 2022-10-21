local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local SLOT_DEVICE_NAME = "slot_device"
local SLOT_GRENADE_NAME = "slot_grenade_ability"
local SLOT_POCKETABLE_NAME = "slot_pocketable"
local SLOT_SECONDARY = "slot_secondary"
local training_grounds_wield_info_passives_templates = {}
training_grounds_wield_info_passives_templates[1] = {
	name = "weapon_attack_chains",
	input_descriptions = {
		{
			description = "loc_weapon_action_title_light",
			input_action = "action_one_pressed",
			id = "light_attack"
		},
		{
			description = "loc_heavy_attack",
			input_action = "action_one_hold",
			id = "heavy_attack"
		}
	},
	validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
		local scenario_name = scenario_system:get_current_scenario_name()

		if not scenario_name or scenario_name ~= "attack_chains" then
			return false
		end

		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if not unit_data_extension then
			return false
		end

		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot

		if wielded_slot == SLOT_SECONDARY then
			return false
		end

		return true
	end
}
training_grounds_wield_info_passives_templates[2] = {
	name = "wield_psyker_ability",
	input_descriptions = {
		{
			description = "loc_talents_category_tactical",
			input_action = "grenade_ability_pressed"
		}
	},
	validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
		local scenario_name = scenario_system:get_current_scenario_name()

		if not scenario_name or scenario_name ~= "biomancer_blitz" then
			return false
		end

		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if not unit_data_extension then
			return false
		end

		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot

		if wielded_slot == SLOT_GRENADE_NAME then
			return false
		end

		return true
	end
}
training_grounds_wield_info_passives_templates[3] = {
	name = "wield_grenade",
	input_descriptions = {
		{
			description = "loc_talents_category_tactical",
			input_action = "grenade_ability_pressed"
		}
	},
	validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
		local scenario_name = scenario_system:get_current_scenario_name()

		if not scenario_name or scenario_name ~= "ranged_grenade" then
			return false
		end

		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if not unit_data_extension then
			return false
		end

		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot

		if wielded_slot == SLOT_GRENADE_NAME then
			return false
		end

		return true
	end
}
training_grounds_wield_info_passives_templates[4] = {
	name = "activate_combat_ability",
	input_descriptions = {
		{
			description = "loc_combat_ability_input",
			input_action = "combat_ability_pressed"
		}
	},
	validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
		local scenario_name = scenario_system:get_current_scenario_name()

		if not scenario_name or scenario_name ~= "combat_ability" then
			return false
		end

		return true
	end
}
training_grounds_wield_info_passives_templates[5] = {
	name = "training_ground_dodging",
	input_descriptions = {
		{
			description = "loc_training_ground_move_left_description",
			id = "tg_move_left",
			input_action = {
				"keyboard_move_left",
				"move_controller"
			}
		},
		{
			description = "loc_training_ground_move_right_description",
			id = "tg_move_right",
			input_action = {
				"keyboard_move_right",
				"move_controller"
			}
		},
		{
			description = "loc_training_ground_move_backward_description",
			id = "tg_move_backward",
			input_action = {
				"keyboard_move_backward",
				"move_controller"
			}
		},
		{
			description = "loc_training_ground_dodge_description",
			input_action = "jump",
			id = "tg_dodge"
		}
	},
	validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
		local scenario_name = scenario_system:get_current_scenario_name()

		if not scenario_name or scenario_name ~= "dodging" then
			return false
		end

		return true
	end
}
training_grounds_wield_info_passives_templates[6] = {
	name = "health_and_ammo_kits",
	input_descriptions = {
		{
			description = "loc_utility_input_description",
			input_action = "wield_3"
		}
	},
	validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
		local scenario_name = scenario_system:get_current_scenario_name()

		if not scenario_name or scenario_name ~= "healing_self_and_others" then
			return false
		end

		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if not unit_data_extension then
			return false
		end

		local visual_loadout_extension = ScriptUnit.has_extension(player_unit, "visual_loadout_system")
		local weapon_item = visual_loadout_extension and visual_loadout_extension:item_in_slot(SLOT_POCKETABLE_NAME)
		local weapon_template = weapon_item and WeaponTemplate.weapon_template_from_item(weapon_item)

		if not weapon_template then
			return false
		end

		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot

		if wielded_slot == SLOT_POCKETABLE_NAME then
			return false
		end

		return true
	end
}
training_grounds_wield_info_passives_templates[7] = {
	name = "tag_and_world_markers",
	input_descriptions = {
		{
			description = "loc_tag_input_description",
			input_action = "smart_tag_pressed",
			id = "tag_and_world_markers_tag"
		},
		{
			description = "loc_world_marker_input_description",
			input_action = "smart_tag",
			id = "tag_and_world_markers_marker"
		}
	},
	validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
		local scenario_name = scenario_system:get_current_scenario_name()

		if not scenario_name or scenario_name ~= "tagging" then
			return false
		end

		return true
	end
}
training_grounds_wield_info_passives_templates[8] = {
	name = "training_grounds_sprint_and_slide",
	input_descriptions = {
		{
			description = "loc_input_sprint",
			input_action = "sprint",
			id = "sprint_and_slide_sprint"
		},
		{
			description = "loc_input_slide",
			input_action = "crouch",
			id = "sprint_and_slide_crouch"
		}
	},
	validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
		local scenario_name = scenario_system:get_current_scenario_name()

		if not scenario_name or scenario_name ~= "sprint_slide" then
			return false
		end

		return true
	end
}
training_grounds_wield_info_passives_templates[9] = {
	name = "training_grounds_push",
	input_descriptions = {
		{
			description = "loc_block",
			input_action = "action_two_hold",
			id = "tg_push_block"
		},
		{
			description = "loc_pushf",
			input_action = "action_one_pressed",
			id = "tg_push_push"
		}
	},
	validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
		local scenario_name = scenario_system:get_current_scenario_name()

		if not scenario_name or scenario_name ~= "push" then
			return false
		end

		return true
	end
}
training_grounds_wield_info_passives_templates[10] = {
	name = "armor_heavy_attack",
	input_descriptions = {
		{
			description = "loc_tg_armor_heavy_attack",
			input_action = "action_one_hold"
		}
	},
	validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
		local scenario_name = scenario_system:get_current_scenario_name()

		if not scenario_name or scenario_name ~= "armor_types" then
			return false
		end

		return true
	end
}
training_grounds_wield_info_passives_templates[11] = {
	name = "training_grounds_push_follow_up",
	input_descriptions = {
		{
			description = "loc_block",
			input_action = "action_two_hold",
			id = "tg_push_follow_block"
		},
		{
			description = "loc_tg_push_follow",
			input_action = "action_one_hold",
			id = "tg_push_follow_push"
		}
	},
	validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
		local scenario_name = scenario_system:get_current_scenario_name()

		if not scenario_name or scenario_name ~= "push_follow" then
			return false
		end

		return true
	end
}

return training_grounds_wield_info_passives_templates
