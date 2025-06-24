-- chunkname: @scripts/settings/equipment/weapon_templates/shotpistol_shield/shotpistol_shield_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local ShotshellTemplates = require("scripts/settings/projectile/shotshell_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeShotpistolShieldP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotpistol_shield_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]

local function _crosshair_type_func(condition_func_params)
	if not condition_func_params then
		return "shotgun"
	end

	local inventory_slot_component = condition_func_params.inventory_slot_component
	local current_ammunition_clip = inventory_slot_component.current_ammunition_clip

	if current_ammunition_clip == 0 then
		return "dot"
	end

	return "shotgun"
end

local weapon_template = {}

weapon_template.action_inputs = {
	shoot_pressed = {
		buffer_time = 0.35,
		max_queue = 2,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	block_shoot_pressed = {
		buffer_time = 0.35,
		max_queue = 2,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	block_hold = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
			},
		},
	},
	block_pressed = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	block_release = {
		buffer_time = 0.35,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_two_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	reload_block_cancel = {
		buffer_time = 0.35,
		max_queue = 1,
		input_sequence = {
			{
				hold_input = "action_two_hold",
				input = "weapon_reload",
				value = true,
			},
		},
	},
	reload_pressed = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "weapon_reload",
				value = true,
			},
		},
	},
	block_reload_pressed = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "action_two_hold",
				input = "weapon_reload",
				value = true,
			},
		},
	},
	block_reload_pressed_release = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				inputs = {
					{
						input = "weapon_reload",
						value = false,
					},
					{
						input = "action_two_hold",
						value = true,
					},
				},
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
	special_action = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "weapon_extra_pressed",
				value = true,
			},
		},
	},
	special_action_hold = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "weapon_extra_hold",
				input = "weapon_extra_hold",
				value = true,
			},
		},
	},
	special_action_release = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "weapon_extra_release",
				input = "weapon_extra_release",
				value = true,
			},
		},
	},
	special_action_light = {
		buffer_time = 0.3,
		max_queue = 1,
		input_sequence = {
			{
				input = "weapon_extra_hold",
				time_window = 0.25,
				value = false,
			},
		},
	},
	special_action_heavy = {
		buffer_time = 0.5,
		max_queue = 1,
		input_sequence = {
			{
				duration = 0.25,
				input = "weapon_extra_hold",
				value = true,
			},
			{
				auto_complete = true,
				input = "weapon_extra_hold",
				time_window = 1.5,
				value = false,
			},
		},
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "shoot_pressed",
		transition = "stay",
	},
	{
		input = "block_hold",
		transition = {
			{
				input = "special_action",
				transition = "base",
			},
			{
				input = "block_release",
				transition = "base",
			},
			{
				input = "block_shoot_pressed",
				transition = {
					{
						input = "block_shoot_pressed",
						transition = "stay",
					},
					{
						input = "block_hold",
						transition = "previous",
					},
					{
						input = "block_release",
						transition = "base",
					},
					{
						input = "special_action_hold",
						transition = "base",
					},
					{
						input = "wield",
						transition = "base",
					},
					{
						input = "combat_ability",
						transition = "base",
					},
					{
						input = "grenade_ability",
						transition = "base",
					},
				},
			},
			{
				input = "block_reload_pressed",
				transition = {
					{
						input = "block_reload_pressed_release",
						transition = "base",
					},
					{
						input = "shoot_pressed",
						transition = "base",
					},
					{
						input = "block_hold",
						transition = "base",
					},
					{
						input = "wield",
						transition = "base",
					},
					{
						input = "combat_ability",
						transition = "base",
					},
					{
						input = "grenade_ability",
						transition = "base",
					},
				},
			},
			{
				input = "reload_pressed",
				transition = "previous",
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "base",
			},
			{
				input = "grenade_ability",
				transition = "base",
			},
		},
	},
	{
		input = "special_action_hold",
		transition = {
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "special_action_light",
				transition = "base",
			},
			{
				input = "special_action_heavy",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "base",
			},
			{
				input = "grenade_ability",
				transition = "base",
			},
			{
				input = "reload_pressed",
				transition = "base",
			},
		},
	},
	{
		input = "reload_pressed",
		transition = "stay",
	},
	{
		input = "wield",
		transition = "stay",
	},
	{
		input = "combat_ability",
		transition = "base",
	},
	{
		input = "grenade_ability",
		transition = "base",
	},
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_wield = {
		allowed_during_sprint = true,
		kind = "ranged_wield",
		total_time = 0.4,
		uninterruptible = true,
		wield_anim_event = "equip",
		wield_reload_anim_event = "equip_reload",
		conditional_state_to_action_input = {
			started_reload = {
				input_name = "reload_pressed",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			block_hold = {
				action_name = "action_block",
				chain_time = 0.1,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.5,
			},
			reload_pressed = {
				action_name = "action_reload",
				chain_time = 0.1,
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.25,
			},
		},
	},
	action_shoot_hip = {
		allowed_during_sprint = false,
		ammunition_usage = 1,
		kind = "shoot_pellets",
		sprint_ready_up_time = 0.2,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		total_time = 0.75,
		weapon_handling_template = "stubrevolver_single_shot",
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.1,
			},
			{
				modifier = 1.35,
				t = 0.15,
			},
			{
				modifier = 1.15,
				t = 0.175,
			},
			{
				modifier = 1.05,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.75,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle_crit",
			muzzle_flash_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.shotpistol_shield,
			damage_type = damage_types.pellet,
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t)
			if not condition_func_params then
				return true
			end

			local weapon_extension = condition_func_params.weapon_extension
			local last_shoot_action_t = weapon_extension.last_shoot_action_t
			local next_allowed_shoot_action_t = last_shoot_action_t + 0.3
			local weapon_action_component = condition_func_params.weapon_action_component
			local current_action_name = weapon_action_component.current_action_name
			local previous_action_name = weapon_action_component.previous_action_name
			local previous_action_end_t = weapon_action_component.end_t
			local allow_after_block = current_action_name ~= "none" or previous_action_name ~= "action_block" or t >= previous_action_end_t + 0.3
			local allow_shot = next_allowed_shoot_action_t <= t

			if allow_after_block and allow_shot then
				return true
			end

			return false
		end,
		action_finish_func = function (reason, data, condition_func_params, t)
			if not condition_func_params then
				return
			end

			local weapon_extension = condition_func_params.weapon_extension
			local weapon_action_component = condition_func_params.weapon_action_component
			local start_t = weapon_action_component.start_t

			weapon_extension.last_shoot_action_t = start_t
		end,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload_pressed = {
				action_name = "action_reload",
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.55,
			},
			block_hold = {
				action_name = "action_block",
				chain_time = 0.25,
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.25,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint,
		},
	},
	action_shoot_blocking = {
		allowed_during_sprint = true,
		ammunition_usage = 1,
		kind = "shoot_pellets",
		recoil_template = "default_shotpistol_shield_ads",
		spread_template = "default_shotpistol_shield_ads",
		sprint_ready_up_time = 0,
		start_input = "block_shoot_pressed",
		total_time = 0.75,
		weapon_handling_template = "stubrevolver_single_shot",
		haptic_trigger_template = HapticTriggerTemplates.ranged.shotgun_p2_double_shot,
		crosshair = {
			crosshair_type = "shotgun",
		},
		action_movement_curve = {
			{
				modifier = 0.85,
				t = 0.05,
			},
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 0.915,
				t = 0.175,
			},
			{
				modifier = 0.95,
				t = 0.3,
			},
			{
				modifier = 1.1,
				t = 1,
			},
			start_modifier = 0.8,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle_crit",
			muzzle_flash_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.shotpistol_shield,
			damage_type = damage_types.pellet,
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t)
			if not condition_func_params then
				return true
			end

			local weapon_extension = condition_func_params.weapon_extension
			local last_shoot_action_t = weapon_extension.last_shoot_action_t
			local next_allowed_shoot_action_t = last_shoot_action_t + 0.55

			if next_allowed_shoot_action_t <= t then
				return condition_func_params.inventory_slot_component.current_ammunition_clip > 0
			end

			return false
		end,
		action_finish_func = function (reason, data, condition_func_params, t)
			if not condition_func_params then
				return
			end

			local weapon_extension = condition_func_params.weapon_extension
			local weapon_action_component = condition_func_params.weapon_action_component
			local start_t = weapon_action_component.start_t

			weapon_extension.last_shoot_action_t = start_t
		end,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			block_hold = {
				action_name = "action_block_from_shoot",
				chain_time = 0.1,
			},
			block_release = {
				action_name = "action_unaim",
				chain_time = 0.4,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true,
		},
	},
	action_block = {
		abort_sprint = true,
		allowed_during_sprint = true,
		block_unblockable = true,
		kind = "block_aiming",
		minimum_hold_time = 0.3,
		sprint_requires_press_to_interrupt = true,
		start_input = "block_hold",
		stop_input = "block_release",
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_4",
		total_time = math.huge,
		anim_event_func = function (action_settings, condition_func_params, is_chain_action, previous_action)
			if not condition_func_params then
				return "to_braced", "to_braced"
			end

			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
			local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve

			if current_ammunition_reserve == 0 and current_ammunition_clip == 0 then
				return "to_parry_block", "to_reload_parry"
			elseif current_ammunition_clip == 0 then
				return "to_reload_parry", "to_reload_parry"
			end

			return "to_braced", "to_braced"
		end,
		anim_end_event_func = function (action_settings, condition_func_params)
			if not condition_func_params then
				return "to_unaim_braced", "to_unaim_braced"
			end

			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
			local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve

			if current_ammunition_reserve == 0 and current_ammunition_clip == 0 then
				return "to_unaim_parry_block", "to_unaim_reload_parry"
			elseif current_ammunition_clip == 0 then
				return "to_unaim_reload_parry", "to_unaim_reload_parry"
			end

			return "to_unaim_braced", "to_unaim_braced"
		end,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		crosshair = {
			crosshair_type_func = _crosshair_type_func,
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_bfg,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 0.9,
				t = 0.175,
			},
			{
				modifier = 0.95,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.9,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			block_shoot_pressed = {
				action_name = "action_shoot_blocking",
				chain_time = 0.5,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			special_action = {
				{
					action_name = "action_bash_light_from_block_no_ammo",
					chain_time = 0.25,
				},
				{
					action_name = "action_bash_light",
					chain_time = 0.25,
				},
			},
		},
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true,
		},
	},
	action_block_from_shoot = {
		block_unblockable = true,
		kind = "block_aiming",
		skip_enter_alternate_fire = true,
		skip_update_perfect_blocking = true,
		uninterruptible = true,
		total_time = math.huge,
		anim_event_func = function (action_settings, condition_func_params, is_chain_action, previous_action)
			if not condition_func_params then
				return nil
			end

			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
			local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve

			if current_ammunition_reserve == 0 and current_ammunition_clip == 0 then
				return "attack_shoot_to_parry", "attack_shoot_to_parry"
			elseif current_ammunition_clip == 0 then
				return "attack_shoot_to_parry", "attack_shoot_to_parry"
			end

			return nil
		end,
		anim_end_event_func = function (action_settings, condition_func_params)
			if not condition_func_params then
				return "to_unaim_braced"
			end

			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
			local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve

			if current_ammunition_reserve == 0 and current_ammunition_clip == 0 then
				return "to_unaim_parry_block", "to_unaim_reload_parry"
			elseif current_ammunition_clip == 0 then
				return "to_unaim_reload_parry", "to_unaim_reload_parry"
			end

			return "to_unaim_braced", "to_unaim_braced"
		end,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		crosshair = {
			crosshair_type = "shotgun",
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_bfg,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 0.9,
				t = 0.175,
			},
			{
				modifier = 0.95,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.9,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			block_shoot_pressed = {
				action_name = "action_shoot_blocking",
				chain_time = 0.45,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			special_action = {
				{
					action_name = "action_bash_light_from_block_no_ammo",
					chain_time = 0.25,
				},
				{
					action_name = "action_bash_light",
					chain_time = 0.25,
				},
			},
			block_release = {
				action_name = "action_unaim",
				chain_time = 0.35,
			},
		},
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true,
		},
	},
	action_block_from_bash = {
		block_unblockable = true,
		kind = "block_aiming",
		skip_update_perfect_blocking = true,
		stop_input = "block_release",
		uninterruptible = true,
		total_time = math.huge,
		anim_event_func = function (action_settings, condition_func_params, is_chain_action, previous_action)
			if not condition_func_params then
				return "to_braced", "to_braced"
			end

			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
			local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve

			if current_ammunition_reserve == 0 and current_ammunition_clip == 0 then
				return "to_parry_block", "to_reload_parry"
			elseif current_ammunition_clip == 0 then
				return "to_reload_parry", "to_reload_parry"
			end

			return "to_braced", "to_braced"
		end,
		anim_end_event_func = function (action_settings, condition_func_params)
			if not condition_func_params then
				return "to_unaim_braced", "to_unaim_braced"
			end

			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
			local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve

			if current_ammunition_reserve == 0 and current_ammunition_clip == 0 then
				return "to_unaim_parry_block", "to_unaim_reload_parry"
			elseif current_ammunition_clip == 0 then
				return "to_unaim_reload_parry", "to_unaim_reload_parry"
			end

			return "to_unaim_braced", "to_unaim_braced"
		end,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		crosshair = {
			crosshair_type = "shotgun",
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_bfg,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 0.9,
				t = 0.175,
			},
			{
				modifier = 0.95,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.7,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			reload_pressed = {
				action_name = "action_reload",
			},
			block_shoot_pressed = {
				action_name = "action_shoot_blocking",
				chain_time = 0.15,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			special_action = {
				{
					action_name = "action_bash_light_from_block_no_ammo",
					chain_time = 0.25,
				},
				{
					action_name = "action_bash_light",
					chain_time = 0.25,
				},
			},
		},
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true,
		},
	},
	action_unaim = {
		block_unblockable = true,
		kind = "block_unaim",
		start_input = "block_release",
		total_time = 0.035,
		anim_event_func = function (action_settings, condition_func_params, is_chain_action, previous_action)
			if not condition_func_params then
				return "to_unaim_braced"
			end

			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
			local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve

			if current_ammunition_reserve == 0 and current_ammunition_clip == 0 then
				return "to_unaim_parry_block", "to_unaim_reload_parry"
			elseif current_ammunition_clip == 0 then
				local previous_actions_settings = previous_action and previous_action:action_settings()
				local previous_action_name = previous_actions_settings and previous_actions_settings.name

				if previous_action_name and previous_action_name == "action_shoot_blocking" then
					return "to_unaim_braced", "to_unaim_braced"
				else
					return "to_unaim_reload_parry", "to_unaim_reload_parry"
				end
			end

			return "to_unaim_braced"
		end,
		crosshair = {
			crosshair_type_func = _crosshair_type_func,
		},
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 0.9,
				t = 0.175,
			},
			{
				modifier = 0.95,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.7,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true,
		},
	},
	action_reload = {
		abort_sprint = true,
		allowed_during_sprint = true,
		kind = "reload_state",
		sprint_requires_press_to_interrupt = true,
		start_input = "reload_pressed",
		stop_alternate_fire = true,
		total_time = 2.5,
		weapon_handling_template = "time_scale_1_2",
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 0.9,
				t = 0.175,
			},
			{
				modifier = 0.95,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.4,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 3.7,
			},
			block_hold = {
				action_name = "action_block",
				chain_time = 0.35,
			},
			wield = {
				action_name = "action_unwield",
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_bash_start = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "charge_special",
		kind = "windup",
		prevent_sprint = true,
		sprint_requires_press_to_interrupt = true,
		start_input = "special_action_hold",
		total_time = 2,
		uninterruptible = true,
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 0.9,
				t = 0.175,
			},
			{
				modifier = 0.95,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			special_action_light = {
				action_name = "action_bash_light",
				chain_time = 0,
			},
			special_action_heavy = {
				action_name = "action_bash_heavy",
				chain_time = 0.525,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.275,
			},
			block_hold = {
				action_name = "action_block_from_bash",
				chain_time = 0.15,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_bash_light = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_end_event = "to_unaim_braced",
		anim_event = "attack_stab_01",
		block_duration = 0.5,
		block_unblockable = true,
		kind = "push",
		push_radius = 3.25,
		range_mod = 1.15,
		sprint_requires_press_to_interrupt = true,
		stop_alternate_fire = true,
		total_time = 0.6,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		crosshair = {
			crosshair_type = "dot",
		},
		inner_push_rad = math.pi * 0.55,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.human_shield_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.default_shield_push,
		outer_damage_type = damage_types.physical,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 0.9,
				t = 0.175,
			},
			{
				modifier = 0.95,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload_pressed = {
				action_name = "action_reload",
				chain_time = 2.5,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.5,
			},
			block_hold = {
				action_name = "action_block_from_bash",
				chain_time = 0.5,
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 1,
			},
		},
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true,
		},
		anim_end_event_func = function (action_settings, condition_func_params)
			if not condition_func_params then
				return "to_unaim_braced", "to_unaim_braced"
			end

			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_ammunition_clip = inventory_slot_component.current_ammunition_clip

			if current_ammunition_clip == 0 then
				return "to_unaim_braced", "to_unaim_braced"
			end

			return "to_unaim_braced", "to_unaim_braced"
		end,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action"
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_bash_light_from_block_no_ammo = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_end_event = "to_unaim_braced",
		anim_event = "attack_stab_01",
		block_duration = 0.5,
		block_unblockable = true,
		kind = "push",
		push_radius = 3.25,
		range_mod = 1.15,
		sprint_requires_press_to_interrupt = true,
		stop_alternate_fire = true,
		total_time = 0.6,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		crosshair = {
			crosshair_type = "dot",
		},
		inner_push_rad = math.pi * 0.55,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.human_shield_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.default_shield_push,
		outer_damage_type = damage_types.physical,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 0.9,
				t = 0.175,
			},
			{
				modifier = 0.95,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			block_hold = {
				action_name = "action_block_from_bash",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_bash_light_from_block_no_ammo",
				chain_time = 0.25,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.current_ammunition_clip <= 0
		end,
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true,
		},
		anim_end_event_func = function (action_settings, condition_func_params)
			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
			local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve

			if current_ammunition_reserve == 0 and current_ammunition_clip == 0 then
				return "to_unaim_parry_block", "to_unaim_reload_parry"
			end

			return "to_unaim_reload_parry", "to_unaim_reload_parry"
		end,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action"
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_bash_heavy = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_special_heavy",
		attack_direction_override = "push",
		damage_window_end = 0.31666666666666665,
		damage_window_start = 0.14166666666666666,
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.3,
		sprint_requires_press_to_interrupt = true,
		stop_alternate_fire = true,
		total_time = 1.1,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_3",
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.85,
				t = 0.1,
			},
			{
				modifier = 0.87,
				t = 0.25,
			},
			{
				modifier = 0.9,
				t = 0.3,
			},
			{
				modifier = 1.2,
				t = 0.35,
			},
			{
				modifier = 1.3,
				t = 0.4,
			},
			{
				modifier = 1.05,
				t = 0.6,
			},
			{
				modifier = 0.8,
				t = 1,
			},
			start_modifier = 0.95,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload_pressed = {
				action_name = "action_reload",
				chain_time = 0.6,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.6,
			},
			block_hold = {
				action_name = "action_block_from_bash",
				chain_time = 0.8,
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.9,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return not condition_func_params.alternate_fire_component.is_active
		end,
		weapon_box = {
			1.15,
			0.9,
			0.5,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/assault_shield_shotpistol/special_attack",
			anchor_point_offset = {
				-0.15,
				0.85,
				-0.45,
			},
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.shotpistol_weapon_special_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_inspect = {
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
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/assault_shield_shotpistol"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/assault_shield_shotpistol"
weapon_template.reload_template = ReloadTemplates.shotpistol_shield
weapon_template.spread_template = "default_shotpistol_shield_hip"
weapon_template.recoil_template = "default_shotpistol_shield_hip"
weapon_template.look_delta_template = "stub_pistol"
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_and_started_reload",
		input_name = "reload_pressed",
	},
	{
		conditional_state = "no_ammo_with_delay",
		input_name = "reload_pressed",
	},
}
weapon_template.no_ammo_delay = 0.35
weapon_template.combo_reset_duration = 0.5
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "shotpistol_shield_p1_m1"
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_01",
}
weapon_template.crosshair = {
	crosshair_type_func = _crosshair_type_func,
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	look_delta_template = "stub_pistol_aiming",
	peeking_mechanics = true,
	recoil_template = "default_shotpistol_shield_ads",
	spread_template = "default_shotpistol_shield_ads",
	suppression_template = "default_shotpistol_shield_ads",
	sway_template = "default_shotpistol_shield_ads",
	crosshair = {
		crosshair_type_func = _crosshair_type_func,
	},
	camera = {
		custom_vertical_fov = 50,
		near_range = 0.025,
		vertical_fov = 65,
	},
	action_movement_curve = {
		{
			modifier = 0.65,
			t = 0.05,
		},
		{
			modifier = 0.75,
			t = 0.15,
		},
		{
			modifier = 0.725,
			t = 0.175,
		},
		{
			modifier = 0.85,
			t = 0.3,
		},
		{
			modifier = 0.95,
			t = 1,
		},
		start_modifier = 0.8,
	},
	movement_speed_modifier = {
		{
			modifier = 0.62,
			t = 0.25,
		},
		{
			modifier = 0.95,
			t = 0.6,
		},
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	shotpistol_shield_p1_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.stubrevolver_dps_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_blocking = {
				damage_trait_templates.stubrevolver_dps_stat,
			},
		},
	},
	shotpistol_shield_p1_m1_reload_speed_stat = {
		display_name = "loc_stats_display_reload_speed_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_reload = {
				weapon_handling_trait_templates.default_reload_speed_modify,
				display_data = {
					display_stats = {
						__all_basic_stats = true,
						time_scale = {
							display_name = "loc_weapon_stats_display_reload_speed",
						},
					},
				},
			},
		},
	},
	shotpistol_shield_p1_m1_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_dodge"),
			},
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_sprint"),
			},
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_curve"),
			},
		},
		recoil = {
			base = {
				recoil_trait_templates.default_mobility_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_recoil", "loc_weapon_stats_display_hip_fire"),
			},
			alternate_fire = {
				recoil_trait_templates.default_mobility_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_recoil", "loc_weapon_stats_display_ads"),
			},
		},
		spread = {
			base = {
				spread_trait_templates.default_mobility_spread_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_spread"),
			},
		},
	},
	shotpistol_shield_p1_m1_armor_piercing_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.shotpistol_shield_p1_m1_armor_piercing_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_blocking = {
				damage_trait_templates.shotpistol_shield_p1_m1_armor_piercing_stat,
			},
		},
	},
	shotpistol_shield_p1_m1_crit_stat = {
		display_name = "loc_stats_display_crit_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_shoot_hip = {
				weapon_handling_trait_templates.shotpistol_shield_p1_m1_crit_stat,
				display_data = {
					display_stats = {
						__all_basic_stats = true,
						critical_strike = {
							chance_modifier = {
								display_name = "loc_weapon_stats_display_crit_chance_ranged",
							},
						},
					},
				},
			},
			action_shoot_blocking = {
				weapon_handling_trait_templates.shotpistol_shield_p1_m1_crit_stat,
			},
		},
		damage = {
			action_shoot_hip = {
				damage_trait_templates.shotpistol_shield_p1_m1_crit_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_blocking = {
				damage_trait_templates.shotpistol_shield_p1_m1_crit_stat,
			},
		},
	},
}
weapon_template.keywords = {
	"ranged",
	"shotpistol_shield",
	"p1",
}
weapon_template.can_use_while_vaulting = true
weapon_template.dodge_template = "smiter"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "shotpistol_shield_p1_m1"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.movement_curve_modifier_template = "shotpistol"
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.killshot_semiauto
weapon_template.hipfire_inputs = {
	shoot_pressed = true,
}
weapon_template.traits = {}

local bespoke_shotpistol_shield_p1_m1_traits = table.ukeys(WeaponTraitsBespokeShotpistolShieldP1)

table.append(weapon_template.traits, bespoke_shotpistol_shield_p1_m1_traits)

weapon_template.buffs = {
	on_equip = {
		"suppression_immune_while_blocking",
	},
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_high_damage",
	},
	{
		display_name = "loc_weapon_keyword_accurate",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_ranged_attack_primary",
		fire_mode = "semi_auto",
		type = "hipfire",
	},
	secondary = {
		display_name = "loc_ranged_attack_secondary_braced",
		fire_mode = "semi_auto",
		type = "brace",
	},
	special = {
		desc = "loc_stats_special_action_melee_weapon_bash_desc",
		display_name = "loc_weapon_special_weapon_bash",
		type = "melee_hand",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "hipfire",
			icon = "hipfire",
			sub_icon = "semi_auto",
			value_func = "primary_attack",
		},
		{
			header = "brace",
			icon = "brace",
			sub_icon = "semi_auto",
			value_func = "secondary_attack",
		},
		{
			header = "ammo",
			value_func = "ammo",
		},
	},
	weapon_special = {
		header = "weapon_bash",
		icon = "melee_hand",
	},
}
weapon_template.explicit_combo = {
	{
		"action_shoot_hip",
	},
	{
		"action_shoot_blocking",
	},
}

return weapon_template
