-- chunkname: @scripts/settings/equipment/weapon_templates/base_template_settings.lua

local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSettings.special_rules
local wield_inputs = PlayerCharacterConstants.wield_inputs
local slot_configuration = PlayerCharacterConstants.slot_configuration

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

local NIL_VALUE_OVERRIDE = "__NIL_VALUE__"
local base_template_settings = {
	NIL_VALUE_OVERRIDE = NIL_VALUE_OVERRIDE,
}

base_template_settings.combat_ability_action_inputs = {}
base_template_settings.action_inputs = {
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
	inspect_alt_start = {
		buffer_time = 0,
		input_sequence = {
			{
				hold_input = "weapon_inspect_hold",
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	inspect_alt_stop = {
		buffer_time = 0,
		input_sequence = {
			{
				hold_input = "weapon_inspect_hold",
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	inspect_3p_start = {
		buffer_time = 0,
		input_sequence = {
			{
				hold_input = "weapon_inspect_hold",
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	inspect_3p_stop = {
		buffer_time = 0,
		input_sequence = {
			{
				hold_input = "weapon_inspect_hold",
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	wield = {
		buffer_time = 0.4,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
}

table.add_missing(base_template_settings.action_inputs, base_template_settings.combat_ability_action_inputs)

base_template_settings.generate_unwield_action = function (additional_settings)
	local action_unwield = {
		action_priority = 1,
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			if used_input == "grenade_ability_pressed" then
				return _can_wield_grenade_slot(action_settings, condition_func_params, used_input) and not _has_talent_special_rule(condition_func_params, special_rules.zealot_throwing_knives) and not _has_talent_special_rule(condition_func_params, special_rules.adamant_whistle) and (not _has_talent_special_rule(condition_func_params, special_rules.quick_flash_grenade) or _has_talent_special_rule(condition_func_params, special_rules.tox_grenade) or _has_talent_special_rule(condition_func_params, special_rules.broker_missile_launcher))
			end

			return true
		end,
	}

	if additional_settings then
		table.merge(action_unwield, additional_settings)
	end

	return action_unwield
end

local function _ability_slot(ability_extension, ...)
	for i = 1, select("#", ...) do
		local ability_name = select(i, ...)
		local slot_name = ability_extension:ability_slot_by_ability_name(ability_name)

		if slot_name then
			return slot_name
		end
	end

	return nil
end

local function _ability_type(ability_extension, ...)
	for i = 1, select("#", ...) do
		local ability_name = select(i, ...)
		local ability_type = ability_extension:ability_type_by_ability_name(ability_name)

		if ability_type then
			return ability_type
		end
	end

	return nil
end

base_template_settings.actions = {
	action_unwield = base_template_settings.generate_unwield_action(),
	grenade_ability_zealot_throwing_knives = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_event = "ability_knife_throw",
		anim_time_scale = 1.25,
		consume_ability_usage_cost = true,
		fire_time = 0.25,
		kind = "spawn_projectile",
		sprint_requires_press_to_interrupt = false,
		start_input = "wield",
		stop_alternate_fire = true,
		time_scale_stat_buffs = false,
		total_time = 0.55,
		uninterruptible = true,
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
		ability_type_func = function (action_start_params, condition_func_params)
			local ability_extension = (action_start_params or condition_func_params).ability_extension
			local ability_type = _ability_type(ability_extension, "zealot_throwing_knives")

			return ability_type
		end,
		override_origin_slot_func = function (action_start_params, condition_func_params)
			local ability_extension = (action_start_params or condition_func_params).ability_extension
			local slot_name = _ability_slot(ability_extension, "zealot_throwing_knives")

			return slot_name
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local ability_slot_name = _ability_slot(condition_func_params.ability_extension, "zealot_throwing_knives")

			if not ability_slot_name then
				return false
			end

			local slot_wield_inputs = slot_configuration[ability_slot_name].wield_inputs.pressed

			for _, input in pairs(slot_wield_inputs) do
				if input == used_input then
					return true
				end
			end

			return false
		end,
	},
	grenade_ability_quick_flash_grenade = {
		action_priority = 3,
		allowed_during_sprint = true,
		anim_event = "ability_knife_throw",
		anim_time_scale = 1.25,
		consume_ability_usage_cost = true,
		fire_time = 0.25,
		kind = "spawn_projectile",
		sprint_requires_press_to_interrupt = false,
		start_input = "wield",
		stop_alternate_fire = true,
		time_scale_stat_buffs = false,
		total_time = 0.55,
		uninterruptible = true,
		vo_tag = "quick_flash_grenade",
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
		projectile_template = ProjectileTemplates.quick_flash_grenade,
		ability_type_func = function (action_start_params, condition_func_params)
			local ability_extension = (action_start_params or condition_func_params).ability_extension
			local ability_type = _ability_type(ability_extension, "broker_flash_grenade", "broker_flash_grenade_improved")

			return ability_type
		end,
		override_origin_slot_func = function (action_start_params, condition_func_params)
			local ability_extension = (action_start_params or condition_func_params).ability_extension
			local slot_name = _ability_slot(ability_extension, "broker_flash_grenade", "broker_flash_grenade_improved")

			return slot_name
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local ability_slot_name = _ability_slot(condition_func_params.ability_extension, "broker_flash_grenade", "broker_flash_grenade_improved")

			if not ability_slot_name then
				return false
			end

			local slot_wield_inputs = slot_configuration[ability_slot_name].wield_inputs.pressed

			for _, input in pairs(slot_wield_inputs) do
				if input == used_input then
					return true
				end
			end

			return false
		end,
	},
}
base_template_settings.action_input_hierarchy = {
	{
		input = "inspect_start",
		transition = {
			{
				input = "inspect_stop",
				transition = "base",
			},
			{
				input = "inspect_alt_start",
				transition = {
					{
						input = "inspect_alt_stop",
						transition = "previous",
					},
					{
						input = "inspect_stop",
						transition = "base",
					},
				},
			},
			{
				input = "inspect_3p_start",
				transition = {
					{
						input = "inspect_3p_stop",
						transition = "previous",
					},
					{
						input = "inspect_stop",
						transition = "base",
					},
				},
			},
		},
	},
}

base_template_settings.generate_action_overrides = function (base_action_settings, ...)
	local action_settings = table.clone(base_action_settings)
	local num_overrides = select("#", ...)

	for ii = 1, num_overrides, 2 do
		local override_name = select(ii, ...)
		local override = select(ii + 1, ...)

		if override == NIL_VALUE_OVERRIDE then
			action_settings[override_name] = nil
		else
			action_settings[override_name] = type(override) == "table" and table.clone(override) or override
		end
	end

	return action_settings
end

base_template_settings.generate_wield_chain_actions = function (additional_settings)
	local chain_time_or_nil = additional_settings and additional_settings.chain_time

	chain_time_or_nil = chain_time_or_nil and {
		combat_ability_pressed = 0,
		default = chain_time_or_nil or 0,
		grenade_ability_pressed = chain_time_or_nil or 0,
	}

	local actions = {
		{
			action_name = "action_unwield",
			chain_time = chain_time_or_nil,
		},
		{
			action_name = "grenade_ability_zealot_throwing_knives",
			chain_time = 0,
		},
		{
			action_name = "grenade_ability_quick_flash_grenade",
			chain_time = 0,
		},
	}

	if additional_settings then
		for k, v in pairs(additional_settings) do
			if k ~= "chain_time" then
				for _, chain in pairs(actions) do
					chain[k] = v
				end
			end
		end
	end

	return actions
end

base_template_settings.generate_inspect_action = function ()
	return {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
		skip_3p_anims = false,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
		allowed_chain_actions = {
			inspect_3p_start = {
				action_name = "action_inspect_3p",
				chain_time = 0.75,
			},
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	}
end

base_template_settings.generate_inspect_action = function ()
	return {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
		skip_3p_anims = false,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
		allowed_chain_actions = {
			inspect_3p_start = {
				action_name = "action_inspect_3p",
				chain_time = 0.75,
			},
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	}
end

base_template_settings.generate_inspect_3p_action = function (anim_event, anim_end_event)
	return {
		action_prevents_jump = true,
		block_first_person_rotation = true,
		can_crouch = false,
		can_jump = false,
		force_look = true,
		kind = "inspect_3p",
		lock_view = false,
		skip_3p_anims = false,
		stop_input = "inspect_stop",
		total_time = math.huge,
		anim_event = anim_event,
		anim_end_event = anim_end_event,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason == "new_interrupting_action" and data.new_action_kind == "inspect"
		end,
		crosshair = {
			crosshair_type = "inspect",
		},
		allowed_chain_actions = {
			inspect_3p_stop = {
				action_name = "action_inspect",
				chain_time = 1.1,
			},
		},
		action_movement_curve = {
			{
				modifier = 0,
				t = 0,
			},
			start_modifier = 0,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	}
end

return base_template_settings
