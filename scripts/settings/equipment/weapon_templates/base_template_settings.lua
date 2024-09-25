-- chunkname: @scripts/settings/equipment/weapon_templates/base_template_settings.lua

local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules
local wield_inputs = PlayerCharacterConstants.wield_inputs

local function _quick_throw_allowed(action_settings, condition_func_params, used_input)
	local slot_to_wield = "slot_grenade_ability"
	local weapon_extension = condition_func_params.weapon_extension
	local visual_loadout_extension = condition_func_params.visual_loadout_extension
	local ability_extension = condition_func_params.ability_extension

	if not weapon_extension:can_wield(slot_to_wield) then
		return false
	end

	if not visual_loadout_extension:can_wield(slot_to_wield) then
		return false
	end

	if not ability_extension:can_wield(slot_to_wield) then
		return false
	end

	local talent_extension = condition_func_params.talent_extension
	local has_special_rule = talent_extension:has_special_rule(special_rules.enable_quick_throw_grenades)

	return has_special_rule
end

local base_template_settings = {}

base_template_settings.action_inputs = {
	combat_ability = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "combat_ability_pressed",
				value = true,
			},
		},
	},
	grenade_ability = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "grenade_ability_pressed",
				value = true,
			},
		},
	},
	inspect_start = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "weapon_inspect_hold",
				value = true,
			},
			{
				duration = 0.2,
				input = "weapon_inspect_hold",
				value = true,
			},
		},
	},
	inspect_stop = {
		buffer_time = 0.02,
		input_sequence = {
			{
				input = "weapon_inspect_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	wield = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
}
base_template_settings.actions = {
	combat_ability = {
		kind = "unwield_to_specific",
		slot_to_wield = "slot_combat_ability",
		sprint_ready_up_time = 0,
		start_input = "combat_ability",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	grenade_ability = {
		action_priority = 1,
		allowed_during_sprint = true,
		kind = "unwield_to_specific",
		slot_to_wield = "slot_grenade_ability",
		start_input = "grenade_ability",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return not _quick_throw_allowed(action_settings, condition_func_params, used_input)
		end,
	},
	grenade_ability_quick_throw = {
		ability_type = "grenade_ability",
		action_priority = 2,
		allowed_during_sprint = true,
		anim_event = "ability_knife_throw",
		anim_time_scale = 1.25,
		fire_time = 0.25,
		kind = "spawn_projectile",
		override_origin_slot = "slot_grenade_ability",
		sprint_requires_press_to_interrupt = false,
		start_input = "grenade_ability",
		stop_alternate_fire = true,
		time_scale_stat_buffs = false,
		total_time = 0.55,
		uninterruptible = true,
		use_ability_charge = true,
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.8,
		},
		projectile_template = ProjectileTemplates.zealot_throwing_knives,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return _quick_throw_allowed(action_settings, condition_func_params, used_input)
		end,
	},
}
base_template_settings.action_input_hierarchy = {
	combat_ability = "stay",
	grenade_ability = "stay",
	inspect_start = {
		inspect_stop = "base",
	},
}

return base_template_settings
