-- chunkname: @scripts/settings/equipment/weapon_templates/base_template_settings.lua

local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSettings.special_rules
local wield_inputs = PlayerCharacterConstants.wield_inputs

local function _can_wield_grenade_slot(action_settings, condition_func_params, used_input)
	local slot_to_wield = "slot_grenade_ability"
	local weapon_extension = condition_func_params.weapon_extension
	local visual_loadout_extension = condition_func_params.visual_loadout_extension
	local ability_extension = condition_func_params.ability_extension

	return weapon_extension:can_wield(slot_to_wield) and visual_loadout_extension:can_wield(slot_to_wield) and ability_extension:can_wield(slot_to_wield)
end

local function _has_talent_special_rule(condition_func_params, special_rule)
	local talent_extension = condition_func_params.talent_extension

	return talent_extension:has_special_rule(special_rule)
end

local base_template_settings = {}

base_template_settings.combat_ability_action_inputs = {
	combat_ability = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				value = true,
				input = "combat_ability_pressed"
			}
		}
	}
}
base_template_settings.action_inputs = {
	grenade_ability = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				value = true,
				input = "grenade_ability_pressed"
			}
		}
	},
	inspect_start = {
		buffer_time = 0,
		input_sequence = {
			{
				value = true,
				input = "weapon_inspect_hold"
			},
			{
				value = true,
				duration = 0.2,
				input = "weapon_inspect_hold"
			}
		}
	},
	inspect_stop = {
		buffer_time = 0.02,
		input_sequence = {
			{
				value = false,
				input = "weapon_inspect_hold",
				time_window = math.huge
			}
		}
	},
	wield = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs
			}
		}
	},
	adamant_whistle_command = {
		dont_queue = true,
		buffer_time = 0
	}
}

table.add_missing(base_template_settings.action_inputs, base_template_settings.combat_ability_action_inputs)

base_template_settings.combat_ability_actions = {
	combat_ability = {
		slot_to_wield = "slot_combat_ability",
		start_input = "combat_ability",
		uninterruptible = true,
		kind = "unwield_to_specific",
		sprint_ready_up_time = 0,
		total_time = 0,
		allowed_chain_actions = {}
	}
}
base_template_settings.grenade_ability_actions = {
	grenade_ability = {
		allowed_during_sprint = true,
		slot_to_wield = "slot_grenade_ability",
		start_input = "grenade_ability",
		kind = "unwield_to_specific",
		action_priority = 1,
		uninterruptible = true,
		total_time = 0,
		allowed_chain_actions = {},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return _can_wield_grenade_slot(action_settings, condition_func_params, used_input) and not _has_talent_special_rule(condition_func_params, special_rules.zealot_throwing_knives) and not _has_talent_special_rule(condition_func_params, special_rules.adamant_whistle)
		end
	},
	grenade_ability_zealot_throwing_knives = {
		uninterruptible = true,
		start_input = "grenade_ability",
		stop_alternate_fire = true,
		kind = "spawn_projectile",
		sprint_requires_press_to_interrupt = false,
		action_priority = 2,
		use_ability_charge = true,
		allowed_during_sprint = true,
		ability_type = "grenade_ability",
		anim_time_scale = 1.25,
		time_scale_stat_buffs = false,
		fire_time = 0.25,
		override_origin_slot = "slot_grenade_ability",
		anim_event = "ability_knife_throw",
		total_time = 0.55,
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.2
			},
			{
				modifier = 0.4,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.8
		},
		projectile_template = ProjectileTemplates.zealot_throwing_knives,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return _can_wield_grenade_slot(action_settings, condition_func_params, used_input) and _has_talent_special_rule(condition_func_params, special_rules.zealot_throwing_knives) and not _has_talent_special_rule(condition_func_params, special_rules.adamant_whistle)
		end
	}
}
base_template_settings.actions = {}

table.add_missing(base_template_settings.actions, base_template_settings.combat_ability_actions)
table.add_missing(base_template_settings.actions, base_template_settings.grenade_ability_actions)

base_template_settings.action_input_hierarchy = {
	{
		transition = "stay",
		input = "combat_ability"
	},
	{
		transition = "stay",
		input = "grenade_ability"
	},
	{
		transition = "stay",
		input = "adamant_whistle_command"
	},
	{
		input = "inspect_start",
		transition = {
			{
				transition = "base",
				input = "inspect_stop"
			}
		}
	}
}

base_template_settings.generate_grenade_ability_chain_actions = function (chain_settings)
	local chain_actions = {
		{
			action_name = "grenade_ability"
		},
		{
			action_name = "grenade_ability_zealot_throwing_knives"
		}
	}

	if chain_settings then
		for key, value in pairs(chain_settings) do
			for ii = 1, #chain_actions do
				chain_actions[ii][key] = value
			end
		end
	end

	return chain_actions
end

return base_template_settings
