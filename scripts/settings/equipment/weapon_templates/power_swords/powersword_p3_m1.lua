-- chunkname: @scripts/settings/equipment/weapon_templates/power_swords/powersword_p3_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MeleeActionInputSetupMid = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_mid")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokePowerswordP3 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powersword_p3")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local wounds_shapes = WoundsSettings.shapes
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}

weapon_template.action_inputs = {
	wield = {
		buffer_time = 0.4,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
	start_attack = {
		buffer_time = 0.35,
		max_queue = 1,
		reevaluation_time = 0.18,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	attack_cancel = {
		buffer_time = 0.1,
		input_sequence = {
			{
				hold_input = "action_one_hold",
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	light_attack = {
		buffer_time = 0.3,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_one_hold",
				time_window = 0.35,
				value = false,
			},
		},
	},
	heavy_attack = {
		buffer_time = 0.5,
		max_queue = 1,
		input_sequence = {
			{
				duration = 0.35,
				input = "action_one_hold",
				value = true,
			},
			{
				auto_complete = true,
				input = "action_one_hold",
				time_window = 1,
				value = false,
			},
		},
	},
	attack_release = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	block = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "action_two_hold",
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
	push = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "action_two_hold",
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	push_follow_up = {
		buffer_time = 0.3,
		input_sequence = {
			{
				duration = 0.3,
				hold_input = "action_two_hold",
				input = "action_one_hold",
				value = true,
			},
		},
	},
	push_follow_up_release = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				inputs = {
					{
						input = "action_one_hold",
						value = false,
					},
					{
						input = "action_two_hold",
						value = false,
					},
				},
				time_window = math.huge,
			},
		},
	},
	push_follow_up_early_release = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	special_action = {
		buffer_time = 0.4,
		max_queue = 1,
		input_sequence = {
			{
				input = "weapon_extra_pressed",
				value = true,
			},
		},
	},
	start_attack_special = {
		buffer_time = 0.4,
		max_queue = 1,
		reevaluation_time = 0.18,
		input_sequence = {
			{
				input = "weapon_extra_hold",
				value = true,
			},
		},
	},
	attack_cancel_special = {
		buffer_time = 0.1,
		input_sequence = {
			{
				hold_input = "weapon_extra_hold",
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	light_attack_special = {
		buffer_time = 0.3,
		max_queue = 1,
		input_sequence = {
			{
				input = "weapon_extra_hold",
				time_window = 0.35,
				value = false,
			},
		},
	},
	heavy_attack_special = {
		buffer_time = 0.5,
		max_queue = 1,
		input_sequence = {
			{
				duration = 0.35,
				input = "weapon_extra_hold",
				value = true,
			},
			{
				auto_complete = true,
				input = "weapon_extra_hold",
				time_window = 1.6,
				value = false,
			},
		},
	},
	attack_release_special = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				input = "weapon_extra_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)

local new_start_attack_action_transition = {
	{
		input = "attack_cancel",
		transition = "base",
	},
	{
		input = "light_attack",
		transition = "base",
	},
	{
		input = "heavy_attack",
		transition = "base",
	},
	{
		input = "wield",
		transition = "base",
	},
	{
		input = "grenade_ability",
		transition = "base",
	},
	{
		input = "combat_ability",
		transition = "base",
	},
	{
		input = "block",
		transition = "base",
	},
}

ActionInputHierarchy.update_hierarchy_entry(weapon_template.action_input_hierarchy, "start_attack", new_start_attack_action_transition)

local new_start_attack_special_action_transition = {
	{
		input = "attack_cancel_special",
		transition = "base",
	},
	{
		input = "light_attack_special",
		transition = "base",
	},
	{
		input = "heavy_attack_special",
		transition = "base",
	},
	{
		input = "wield",
		transition = "base",
	},
	{
		input = "grenade_ability",
		transition = "base",
	},
	{
		input = "block",
		transition = "base",
	},
}

ActionInputHierarchy.update_hierarchy_entry(weapon_template.action_input_hierarchy, "start_attack_special", new_start_attack_special_action_transition)

local new_block_action_transition = {
	{
		input = "block_release",
		transition = "base",
	},
	{
		input = "push",
		transition = {
			{
				input = "push_follow_up",
				transition = {
					{
						input = "push_follow_up_release",
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
					{
						input = "special_action",
						transition = "base",
					},
					{
						input = "block",
						transition = "base",
					},
				},
			},
			{
				input = "push_follow_up_early_release",
				transition = "base",
			},
			{
				input = "special_action",
				transition = "base",
			},
		},
	},
	{
		input = "wield",
		transition = "base",
	},
	{
		input = "grenade_ability",
		transition = "base",
	},
	{
		input = "combat_ability",
		transition = "base",
	},
}

ActionInputHierarchy.update_hierarchy_entry(weapon_template.action_input_hierarchy, "block", new_block_action_transition)

local default_weapon_box = {
	0.135,
	0.135,
	1.1,
}
local heavy_weapon_box = {
	0.15,
	0.15,
	1.1,
}
local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.weakspot] = 1,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3,
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

local hit_anim_types = ActionSweepSettings.hit_anim_types
local HIT_ANIMS = {
	[hit_anim_types.default] = {
		hit_armor = "attack_hit_shield",
		hit_armor_3p = "hit_stop",
		hit_stop = "hit_stop",
	},
	[hit_anim_types.special_active] = {
		hit_armor = "attack_hit_shield",
		hit_armor_3p = "hit_stop",
		hit_stop = "hit_stop",
	},
}

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
		anim_event = "equip",
		kind = "wield",
		sprint_ready_up_time = 0,
		total_time = 0.1,
		uninterruptible = true,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left",
			},
			block = {
				action_name = "action_block",
			},
			start_attack_special = {
				action_name = "action_melee_start_left_special",
			},
		},
	},
	action_melee_start_left = {
		action_priority = 1,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_stab",
		anim_event_3p = "attack_swing_charge_stab",
		chain_anim_event = "heavy_charge_left_stab_pose",
		chain_anim_event_3p = "attack_swing_charge_stab",
		kind = "windup",
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.75,
				t = 0.25,
			},
			{
				modifier = 0.6,
				t = 0.4,
			},
			{
				modifier = 0.8,
				t = 1.2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_1",
			},
			heavy_attack = {
				action_name = "action_heavy_1",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			if not condition_func_params then
				return true
			end

			local weapon_extension = condition_func_params.weapon_extension
			local last_sweep_action_t = weapon_extension.last_sweep_action_t
			local next_allowed_sweep_action_t = last_sweep_action_t + 0.55

			if next_allowed_sweep_action_t <= t then
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

			weapon_extension.last_sweep_action_t = start_t
		end,
	},
	action_light_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_stab_left",
		anim_event_3p = "attack_swing_stab",
		attack_direction_override = "push",
		damage_window_end = 0.225,
		damage_window_start = 0.16666666666666666,
		kind = "sweep",
		range_mod = 1.275,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.7,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 0.7,
			},
			{
				modifier = 1.05,
				t = 0.75,
			},
			{
				modifier = 1.04,
				t = 0.8,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
			},
			start_attack_special = {
				action_name = "action_melee_start_right_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_left_stab_01",
				anchor_point_offset = {
					0.15,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_stab_p3,
		damage_type = damage_types.metal_slashing_medium,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		action_finish_func = function (reason, data, condition_func_params, t)
			if not condition_func_params then
				return
			end

			local weapon_extension = condition_func_params.weapon_extension
			local weapon_action_component = condition_func_params.weapon_action_component
			local start_t = weapon_action_component.start_t

			weapon_extension.last_sweep_action_t = start_t
		end,
	},
	action_heavy_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_stab",
		anim_event_3p = "attack_swing_heavy_stab",
		attack_direction_override = "push",
		damage_window_end = 0.21666666666666667,
		damage_window_start = 0.16666666666666666,
		kind = "sweep",
		range_mod = 1.3,
		start_input = nil,
		total_time = 1.7,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.25,
				t = 0.4,
			},
			{
				modifier = 0.75,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.375,
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.375,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			start_attack_special = {
				action_name = "action_melee_start_right_special",
				chain_time = 0.375,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = heavy_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_heavy_stab_left",
				anchor_point_offset = {
					0.1,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_sword_stab_p3,
		damage_type = damage_types.metal_slashing_medium,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down",
		anim_event_3p = "attack_swing_charge_down_right",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.75,
				t = 0.25,
			},
			{
				modifier = 0.7,
				t = 0.4,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.45,
				t = 1.2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_2",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_stab_right",
		anim_event_3p = "attack_swing_stab_02",
		attack_direction_override = "push",
		damage_window_end = 0.24166666666666667,
		damage_window_start = 0.18333333333333332,
		kind = "sweep",
		range_mod = 1.275,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.7,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 0.9,
				t = 0.8,
			},
			{
				modifier = 0.975,
				t = 0.85,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
			},
			start_attack_special = {
				action_name = "action_melee_start_right_2_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_right_stab_01",
				anchor_point_offset = {
					-0.15,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_stab_p3,
		damage_type = damage_types.metal_slashing_medium,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		action_finish_func = function (reason, data, condition_func_params, t)
			if not condition_func_params then
				return
			end

			local weapon_extension = condition_func_params.weapon_extension
			local weapon_action_component = condition_func_params.weapon_action_component
			local start_t = weapon_action_component.start_t

			weapon_extension.last_sweep_action_t = start_t
		end,
	},
	action_heavy_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_diagonal_down",
		anim_event_3p = "attack_swing_heavy_down_right",
		damage_window_end = 0.325,
		damage_window_start = 0.2,
		kind = "sweep",
		range_mod = 1.33,
		start_input = nil,
		total_time = 1.7,
		weapon_handling_template = "time_scale_1_1",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.25,
				t = 0.4,
			},
			{
				modifier = 0.8,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.35,
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.375,
			},
			start_attack_special = {
				action_name = "action_melee_start_left_2_special",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = heavy_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/heavy_swing_right_diagonal",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_sword_linesman_p3,
		damage_type = damage_types.metal_slashing_medium,
		wounds_shape = wounds_shapes.right_45_slash_clean,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_right_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down",
		anim_event_3p = "attack_swing_charge_down_right",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.75,
				t = 0.25,
			},
			{
				modifier = 0.7,
				t = 0.4,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.45,
				t = 1.2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_3",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_down",
		anim_event_3p = "attack_swing_right_diagonal",
		attack_direction_override = "down",
		damage_window_end = 0.425,
		damage_window_start = 0.36666666666666664,
		kind = "sweep",
		range_mod = 1.35,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.2,
			},
			{
				modifier = 1.15,
				t = 0.4,
			},
			{
				modifier = 0.45,
				t = 0.45,
			},
			{
				modifier = 0.6,
				t = 0.65,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.4,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
			},
			start_attack_special = {
				action_name = "action_melee_start_left_2_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_right_down",
				anchor_point_offset = {
					-0.05,
					0,
					0.25,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_smiter_p3,
		damage_type = damage_types.metal_slashing_medium,
		wounds_shape = wounds_shapes.vertical_slash_clean,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_heavy_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_down",
		anim_event_3p = "attack_swing_heavy_down_left",
		attack_direction_override = "down",
		damage_window_end = 0.2916666666666667,
		damage_window_start = 0.2,
		kind = "sweep",
		range_mod = 1.35,
		start_input = nil,
		total_time = 1.7,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.25,
				t = 0.4,
			},
			{
				modifier = 0.75,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.375,
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.475,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			start_attack_special = {
				action_name = "action_melee_start_left_special",
				chain_time = 0.475,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = heavy_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_heavy_left_down",
				anchor_point_offset = {
					0.125,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_sword_smiter_p3,
		damage_type = damage_types.metal_slashing_medium,
		wounds_shape = wounds_shapes.vertical_slash_clean,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_left_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_down",
		anim_event_3p = "attack_swing_charge_down_left",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.75,
				t = 0.25,
			},
			{
				modifier = 0.7,
				t = 0.4,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.45,
				t = 1.2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_4",
			},
			heavy_attack = {
				action_name = "action_heavy_3",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_4 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_diagonal_down",
		anim_event_3p = "attack_swing_left_diagonal",
		damage_window_end = 0.4,
		damage_window_start = 0.3333333333333333,
		kind = "sweep",
		range_mod = 1.3,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.7,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 0.7,
			},
			{
				modifier = 1.05,
				t = 0.75,
			},
			{
				modifier = 1.04,
				t = 0.8,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right_3",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
			},
			start_attack_special = {
				action_name = "action_melee_start_right_3_special",
				chain_time = 0.65,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_left_diagonal_down",
				anchor_point_offset = {
					0,
					0,
					-0.12,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_linesman_p3,
		damage_type = damage_types.metal_slashing_medium,
		wounds_shape = wounds_shapes.left_45_slash_clean,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_right_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down",
		anim_event_3p = "attack_swing_charge_down_right",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.75,
				t = 0.25,
			},
			{
				modifier = 0.7,
				t = 0.4,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.45,
				t = 1.2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_5",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_5 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_diagonal_down",
		anim_event_3p = "attack_swing_right_diagonal",
		damage_window_end = 0.425,
		damage_window_start = 0.36833333333333335,
		kind = "sweep",
		range_mod = 1.37,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.7,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 0.7,
			},
			{
				modifier = 1.05,
				t = 0.75,
			},
			{
				modifier = 1.04,
				t = 0.8,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
			start_attack_special = {
				action_name = "action_melee_start_left_2_special",
				chain_time = 0.45,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_right_diagonal_down",
				anchor_point_offset = {
					-0.15,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_linesman_p3,
		damage_type = damage_types.metal_slashing_medium,
		wounds_shape = wounds_shapes.right_45_slash_clean,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_block = {
		anim_end_event = "parry_finished",
		anim_event = "parry_pose",
		kind = "block",
		minimum_hold_time = 0.25,
		start_input = "block",
		stop_input = "block_release",
		weapon_handling_template = "time_scale_1",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.2,
			},
			{
				modifier = 0.32,
				t = 0.3,
			},
			{
				modifier = 0.3,
				t = 0.325,
			},
			{
				modifier = 0.31,
				t = 0.35,
			},
			{
				modifier = 0.55,
				t = 0.5,
			},
			{
				modifier = 0.75,
				t = 1,
			},
			{
				modifier = 0.7,
				t = 2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			push = {
				action_name = "action_push",
			},
		},
	},
	action_push = {
		anim_event = "attack_push",
		block_duration = 0.5,
		kind = "push",
		push_radius = 2.5,
		start_input = nil,
		total_time = 1,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.4,
				t = 0.1,
			},
			{
				modifier = 0.5,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.4,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_push",
				chain_time = 0.35,
			},
			push_follow_up = {
				action_name = "action_pushfollow",
				chain_time = 0.2,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.35,
			},
			start_attack_special = {
				action_name = "action_melee_start_push_special",
				chain_time = 0.35,
			},
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical,
		haptic_trigger_template = HapticTriggerTemplates.melee.push,
	},
	action_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_diagonal_down",
		anim_event_3p = "attack_swing_right_diagonal",
		damage_window_end = 0.425,
		damage_window_start = 0.36833333333333335,
		kind = "sweep",
		range_mod = 1.37,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.7,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 0.7,
			},
			{
				modifier = 1.05,
				t = 0.75,
			},
			{
				modifier = 1.04,
				t = 0.8,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
			start_attack_special = {
				action_name = "action_melee_start_left_2_special",
				chain_time = 0.45,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_right_diagonal_down",
				anchor_point_offset = {
					-0.15,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_linesman_p3,
		damage_type = damage_types.metal_slashing_medium,
		wounds_shape = wounds_shapes.right_45_slash_clean,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_push = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down",
		anim_event_3p = "attack_swing_charge_down_right",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.75,
				t = 0.25,
			},
			{
				modifier = 0.7,
				t = 0.4,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.45,
				t = 1.2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_3",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_melee_start_left_special = {
		action_priority = 2,
		activate_special_during_windup = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_stab_special",
		anim_event_3p = "attack_swing_charge_stab",
		chain_anim_event = "heavy_charge_left_stab_special_pose",
		invalid_start_action_for_stat_calculation = true,
		keep_special_active_on_sweep_chain_from_windup = true,
		kind = "windup",
		start_input = "start_attack_special",
		stop_input = "attack_cancel_special",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.78,
				t = 0.25,
			},
			{
				modifier = 0.6,
				t = 0.4,
			},
			{
				modifier = 0.55,
				t = 0.55,
			},
			{
				modifier = 0.4,
				t = 1.2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack_special = {
				action_name = "action_light_1_special",
				chain_until = 0.8,
			},
			heavy_attack_special = {
				action_name = "action_heavy_1_special",
				chain_time = 0.8,
			},
			block = {
				action_name = "action_block",
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			if not condition_func_params then
				return true
			end

			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_extension = condition_func_params.weapon_extension
			local last_sweep_action_t = weapon_extension.last_sweep_action_t
			local next_allowed_sweep_action_t = last_sweep_action_t + 0.55

			if t < next_allowed_sweep_action_t then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_consume_on_activation = weapon_special_tweak_data.num_charges_to_consume_on_activation
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_consume_on_activation <= num_special_charges

			return enough_charges
		end,
		action_finish_func = function (reason, data, condition_func_params, t)
			if not condition_func_params then
				return
			end

			local weapon_extension = condition_func_params.weapon_extension
			local weapon_action_component = condition_func_params.weapon_action_component
			local start_t = weapon_action_component.start_t

			weapon_extension.last_sweep_action_t = start_t
		end,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_1_special = {
		activate_special_during_sweep = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_stab_left",
		anim_event_3p = "attack_swing_stab",
		attack_direction_override = "push",
		damage_window_end = 0.225,
		damage_window_start = 0.16666666666666666,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.275,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.7,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 0.7,
			},
			{
				modifier = 1.05,
				t = 0.75,
			},
			{
				modifier = 1.04,
				t = 0.8,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
			},
			start_attack_special = {
				action_name = "action_melee_start_right_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_left_stab_01",
				anchor_point_offset = {
					0.15,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_stab_active_p3,
		damage_type = damage_types.power_sword,
		damage_profile_special_active = DamageProfileTemplates.light_sword_stab_active_p3,
		damage_type_special_active = damage_types.power_sword_p3_light,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		action_finish_func = function (reason, data, condition_func_params, t)
			if not condition_func_params then
				return
			end

			local weapon_extension = condition_func_params.weapon_extension
			local weapon_action_component = condition_func_params.weapon_action_component
			local start_t = weapon_action_component.start_t

			weapon_extension.last_sweep_action_t = start_t
		end,
	},
	action_heavy_1_special = {
		activate_special_during_sweep = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_stab",
		anim_event_3p = "attack_swing_heavy_stab",
		attack_direction_override = "push",
		damage_window_end = 0.21666666666666667,
		damage_window_start = 0.16666666666666666,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		no_hit_stop_on_active = true,
		range_mod = 1.3,
		start_input = nil,
		total_time = 1.7,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.25,
				t = 0.4,
			},
			{
				modifier = 0.75,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.4,
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.42,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.425,
			},
			start_attack_special = {
				action_name = "action_melee_start_right_special",
				chain_time = 0.42,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = heavy_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_heavy_stab_left",
				anchor_point_offset = {
					0.1,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_sword_stab_active_p3,
		damage_type = damage_types.power_sword,
		damage_profile_special_active = DamageProfileTemplates.heavy_sword_stab_active_p3,
		damage_type_special_active = damage_types.power_sword_p3_heavy,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_right_special = {
		activate_special_during_windup = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down_special",
		anim_event_3p = "attack_swing_charge_down_right",
		invalid_start_action_for_stat_calculation = true,
		keep_special_active_on_sweep_chain_from_windup = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel_special",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.75,
				t = 0.25,
			},
			{
				modifier = 0.7,
				t = 0.4,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.45,
				t = 1.2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack_special = {
				action_name = "action_light_2_special",
				chain_until = 0.7,
			},
			heavy_attack_special = {
				action_name = "action_heavy_2_special",
				chain_time = 0.7,
			},
			block = {
				action_name = "action_block",
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_consume_on_activation = weapon_special_tweak_data.num_charges_to_consume_on_activation
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_consume_on_activation <= num_special_charges

			return enough_charges
		end,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_melee_start_right_2_special = {
		activate_special_during_windup = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down_special",
		anim_event_3p = "attack_swing_charge_down_right",
		invalid_start_action_for_stat_calculation = true,
		keep_special_active_on_sweep_chain_from_windup = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel_special",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.75,
				t = 0.25,
			},
			{
				modifier = 0.7,
				t = 0.4,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.45,
				t = 1.2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack_special = {
				action_name = "action_light_3_special",
				chain_until = 0.7,
			},
			heavy_attack_special = {
				action_name = "action_heavy_2_special",
				chain_time = 0.7,
			},
			block = {
				action_name = "action_block",
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_consume_on_activation = weapon_special_tweak_data.num_charges_to_consume_on_activation
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_consume_on_activation <= num_special_charges

			return enough_charges
		end,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_2_special = {
		activate_special_during_sweep = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_stab_right",
		anim_event_3p = "attack_swing_stab_02",
		attack_direction_override = "push",
		damage_window_end = 0.24166666666666667,
		damage_window_start = 0.18333333333333332,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.275,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.7,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 0.9,
				t = 0.8,
			},
			{
				modifier = 0.975,
				t = 0.85,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
			},
			start_attack_special = {
				action_name = "action_melee_start_right_2_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_right_stab_01",
				anchor_point_offset = {
					-0.15,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_stab_active_p3,
		damage_type = damage_types.power_sword,
		damage_profile_special_active = DamageProfileTemplates.light_sword_stab_active_p3,
		damage_type_special_active = damage_types.power_sword_p3_light,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		action_finish_func = function (reason, data, condition_func_params, t)
			if not condition_func_params then
				return
			end

			local weapon_extension = condition_func_params.weapon_extension
			local weapon_action_component = condition_func_params.weapon_action_component
			local start_t = weapon_action_component.start_t

			weapon_extension.last_sweep_action_t = start_t
		end,
	},
	action_light_3_special = {
		activate_special_during_sweep = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_down",
		anim_event_3p = "attack_swing_right_diagonal",
		attack_direction_override = "down",
		damage_window_end = 0.425,
		damage_window_start = 0.36666666666666664,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.35,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.2,
			},
			{
				modifier = 1.15,
				t = 0.4,
			},
			{
				modifier = 0.45,
				t = 0.45,
			},
			{
				modifier = 0.6,
				t = 0.65,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.4,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
			},
			start_attack_special = {
				action_name = "action_melee_start_left_2_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_right_down",
				anchor_point_offset = {
					-0.05,
					0,
					0.25,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_smiter_active_p3,
		damage_type = damage_types.power_sword,
		damage_profile_special_active = DamageProfileTemplates.light_sword_smiter_active_p3,
		damage_type_special_active = damage_types.power_sword_p3_light,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_heavy_2_special = {
		activate_special_during_sweep = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_diagonal_down_special",
		anim_event_3p = "attack_swing_heavy_down_right",
		damage_window_end = 0.325,
		damage_window_start = 0.2,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.33,
		start_input = nil,
		total_time = 1.7,
		weapon_handling_template = "time_scale_1_1",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.25,
				t = 0.4,
			},
			{
				modifier = 0.75,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.375,
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.425,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			start_attack_special = {
				action_name = "action_melee_start_left_2_special",
				chain_time = 0.425,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = heavy_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/heavy_swing_right_diagonal",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_sword_linesman_active_p3,
		damage_type = damage_types.power_sword,
		damage_profile_special_active = DamageProfileTemplates.heavy_sword_linesman_active_p3,
		damage_type_special_active = damage_types.power_sword_p3_heavy,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_left_2_special = {
		activate_special_during_windup = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_down_special",
		anim_event_3p = "attack_swing_charge_down_left",
		invalid_start_action_for_stat_calculation = true,
		keep_special_active_on_sweep_chain_from_windup = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel_special",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.75,
				t = 0.25,
			},
			{
				modifier = 0.7,
				t = 0.4,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.45,
				t = 1.2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack_special = {
				action_name = "action_light_4_special",
			},
			heavy_attack_special = {
				action_name = "action_heavy_3_special",
				chain_time = 0.72,
				chain_until = 0.25,
			},
			block = {
				action_name = "action_block",
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_consume_on_activation = weapon_special_tweak_data.num_charges_to_consume_on_activation
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_consume_on_activation <= num_special_charges

			return enough_charges
		end,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_4_special = {
		activate_special_during_sweep = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_diagonal_down",
		anim_event_3p = "attack_swing_left_diagonal",
		damage_window_end = 0.4,
		damage_window_start = 0.3333333333333333,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.3,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.7,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 0.7,
			},
			{
				modifier = 1.05,
				t = 0.75,
			},
			{
				modifier = 1.04,
				t = 0.8,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right_3",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
			},
			start_attack_special = {
				action_name = "action_melee_start_right_3_special",
				chain_time = 0.65,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_left_diagonal_down",
				anchor_point_offset = {
					0,
					0,
					-0.12,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_linesman_active_p3,
		damage_type = damage_types.power_sword,
		damage_profile_special_active = DamageProfileTemplates.light_sword_linesman_active_p3,
		damage_type_special_active = damage_types.power_sword_p3_light,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_heavy_3_special = {
		activate_special_during_sweep = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_down_special",
		anim_event_3p = "attack_swing_heavy_down_left",
		attack_direction_override = "down",
		damage_window_end = 0.2916666666666667,
		damage_window_start = 0.2,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.35,
		start_input = nil,
		total_time = 1.7,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.25,
				t = 0.4,
			},
			{
				modifier = 0.75,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.4,
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.425,
			},
			start_attack_special = {
				action_name = "action_melee_start_left_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = heavy_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_heavy_left_down",
				anchor_point_offset = {
					0.125,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_sword_smiter_active_p3,
		damage_type = damage_types.power_sword,
		damage_profile_special_active = DamageProfileTemplates.heavy_sword_smiter_active_p3,
		damage_type_special_active = damage_types.power_sword_p3_heavy,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_right_3_special = {
		activate_special_during_windup = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down_special",
		anim_event_3p = "attack_swing_charge_down_right",
		invalid_start_action_for_stat_calculation = true,
		keep_special_active_on_sweep_chain_from_windup = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel_special",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.75,
				t = 0.25,
			},
			{
				modifier = 0.7,
				t = 0.4,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.45,
				t = 1.2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack_special = {
				action_name = "action_light_5_special",
				chain_until = 0.7,
			},
			heavy_attack_special = {
				action_name = "action_heavy_2_special",
				chain_time = 0.7,
			},
			block = {
				action_name = "action_block",
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_consume_on_activation = weapon_special_tweak_data.num_charges_to_consume_on_activation
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_consume_on_activation <= num_special_charges

			return enough_charges
		end,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_5_special = {
		activate_special_during_sweep = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_diagonal_down",
		anim_event_3p = "attack_swing_right_diagonal",
		damage_window_end = 0.425,
		damage_window_start = 0.36833333333333335,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.37,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.7,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 0.7,
			},
			{
				modifier = 1.05,
				t = 0.75,
			},
			{
				modifier = 1.04,
				t = 0.8,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
			start_attack_special = {
				action_name = "action_melee_start_left_2_special",
				chain_time = 0.45,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_right_diagonal_down",
				anchor_point_offset = {
					-0.15,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_linesman_active_p3,
		damage_type = damage_types.power_sword,
		damage_profile_special_active = DamageProfileTemplates.light_sword_linesman_active_p3,
		damage_type_special_active = damage_types.power_sword_p3_light,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_push_special = {
		activate_special_during_windup = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down_special",
		anim_event_3p = "attack_swing_charge_down_right",
		invalid_start_action_for_stat_calculation = true,
		keep_special_active_on_sweep_chain_from_windup = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel_special",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.75,
				t = 0.25,
			},
			{
				modifier = 0.7,
				t = 0.4,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.45,
				t = 1.2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack_special = {
				action_name = "action_light_3_special",
			},
			heavy_attack_special = {
				action_name = "action_heavy_2_special",
				chain_time = 0.7,
				chain_until = 0.25,
			},
			block = {
				action_name = "action_block",
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_consume_on_activation = weapon_special_tweak_data.num_charges_to_consume_on_activation
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_consume_on_activation <= num_special_charges

			return enough_charges
		end,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_inspect_3p = {
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
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
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
	},
	action_inspect = {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
		skip_3p_anims = false,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		weapon_handling_template = "time_scale_1",
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
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/cryptic_power_sword"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/cryptic_power_sword"
weapon_template.weapon_box = {
	0.1,
	0.7,
	0.02,
}
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.weapon_special_class = "WeaponSpecialCooldownCharges"
weapon_template.weapon_special_tweak_data = {
	active_duration = 4,
	cooldown = 1,
	keep_active_on_sprint = true,
	keep_active_on_stun = true,
	keep_active_on_vault = true,
	keep_active_on_windup_end = true,
	max_charges = 6,
	max_num_charges = 6,
	num_charges_to_consume_on_activation = 1,
	thresholds = {
		{
			name = "empty",
			threshold = 0,
		},
		{
			name = "one",
			threshold = 1,
		},
		{
			name = "two",
			threshold = 2,
		},
		{
			name = "three",
			threshold = 3,
		},
		{
			name = "four",
			threshold = 4,
		},
		{
			name = "five",
			threshold = 5,
		},
		{
			name = "six",
			threshold = 6,
		},
	},
	set_inactive_func = function (inventory_slot_component, reason, tweak_data)
		local keep_special_active = reason == "started_sprint"

		inventory_slot_component.special_active = keep_special_active

		return not keep_special_active
	end,
}
weapon_template.sprint_ready_up_time = 0.15
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_block",
	_power_node_1 = "fx_emit_1",
	_special_active = "fx_special_active",
	_sweep = "fx_sweep",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.weapon_counter = {
	show_when_unwielded = false,
	weapon_counter_type = "cooldown_charges",
}
weapon_template.buffs = {
	on_equip = {
		"windup_increases_special_power_default_parent",
		"melee_power_bonus_scaled_on_special_charges",
	},
}
weapon_template.keywords = {
	"melee",
	"power_sword",
	"p3",
	"activated",
}
weapon_template.dodge_template = "smiter_plus_eighty_percent_mobility_extra_dodge"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "smiter"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "chainsword_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.medium

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	powersword_p3_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.powersword_dps_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_base_damage",
									},
								},
							},
						},
					},
				},
			},
			action_heavy_1 = {
				damage_trait_templates.powersword_dps_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_base_damage",
									},
								},
							},
						},
					},
				},
			},
			action_light_2 = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_light_3 = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_light_4 = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_light_5 = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_heavy_3 = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_pushfollow = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_light_1_special = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_light_2_special = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_light_3_special = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_light_4_special = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_light_5_special = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_heavy_3_special = {
				damage_trait_templates.powersword_dps_stat,
			},
		},
	},
	powersword_p3_m1_first_target_stat = {
		display_name = "loc_stats_display_first_target_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.default_first_target_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								power_level_multiplier = {},
							},
						},
					},
				},
			},
			action_heavy_1 = {
				damage_trait_templates.default_first_target_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								power_level_multiplier = {},
							},
						},
					},
				},
			},
			action_light_2 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_3 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_5 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_3 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_1_special = {
				damage_trait_templates.default_first_target_stat,
				overrides = {
					light_sword_stab_active_p3 = {
						damage_trait_templates.default_first_target_stat,
					},
				},
			},
			action_light_2_special = {
				damage_trait_templates.default_first_target_stat,
				overrides = {
					light_sword_stab_active_p3 = {
						damage_trait_templates.default_first_target_stat,
					},
				},
			},
			action_light_3_special = {
				damage_trait_templates.default_first_target_stat,
				overrides = {
					light_sword_smiter_active_p3 = {
						damage_trait_templates.default_first_target_stat,
					},
				},
			},
			action_light_4_special = {
				damage_trait_templates.default_first_target_stat,
				overrides = {
					light_sword_linesman_active_p3 = {
						damage_trait_templates.default_first_target_stat,
					},
				},
			},
			action_light_5_special = {
				damage_trait_templates.default_first_target_stat,
				overrides = {
					light_sword_linesman_active_p3 = {
						damage_trait_templates.default_first_target_stat,
					},
				},
			},
			action_heavy_1_special = {
				damage_trait_templates.default_first_target_stat,
				overrides = {
					heavy_sword_stab_active_p3 = {
						damage_trait_templates.default_first_target_stat,
					},
				},
			},
			action_heavy_2_special = {
				damage_trait_templates.default_first_target_stat,
				overrides = {
					heavy_sword_linesman_active_p3 = {
						damage_trait_templates.default_first_target_stat,
					},
				},
			},
			action_heavy_3_special = {
				damage_trait_templates.default_first_target_stat,
				overrides = {
					heavy_sword_smiter_active_p3 = {
						damage_trait_templates.default_first_target_stat,
					},
				},
			},
		},
	},
	powersword_p3_m1_power_output_stat = {
		display_name = "loc_stats_display_power_output",
		is_stat_trait = true,
		damage = {
			action_light_1_special = {
				overrides = {
					light_sword_stab_active_p3 = {
						damage_trait_templates.default_melee_dps_stat,
						display_data = {
							prefix = "loc_weapon_action_title_light",
							damage_profile_path = {
								"damage_profile_special_active",
							},
							display_stats = {
								targets = {
									{
										power_distribution = {
											attack = {
												display_name = "loc_weapon_stats_display_power",
											},
										},
									},
								},
							},
						},
					},
				},
			},
			action_heavy_1_special = {
				overrides = {
					heavy_sword_stab_active_p3 = {
						damage_trait_templates.default_melee_dps_stat,
						display_data = {
							prefix = "loc_weapon_action_title_heavy",
							damage_profile_path = {
								"damage_profile_special_active",
							},
							display_stats = {
								targets = {
									{
										power_distribution = {
											attack = {
												display_name = "loc_weapon_stats_display_power",
											},
										},
									},
								},
							},
						},
					},
				},
			},
			action_light_2_special = {
				overrides = {
					light_sword_stab_active_p3 = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_light_3_special = {
				overrides = {
					light_sword_smiter_active_p3 = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_light_4_special = {
				overrides = {
					light_sword_linesman_active_p3 = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_light_5_special = {
				overrides = {
					light_sword_linesman_active_p3 = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_heavy_2_special = {
				overrides = {
					heavy_sword_linesman_active_p3 = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_heavy_3_special = {
				overrides = {
					heavy_sword_smiter_active_p3 = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
		},
	},
	powersword_p3_m1_finesse_stat = {
		display_name = "loc_stats_display_finesse_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.powersword_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								boost_curve_multiplier_finesse = {},
							},
						},
					},
				},
			},
			action_heavy_1 = {
				damage_trait_templates.powersword_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								boost_curve_multiplier_finesse = {},
							},
						},
					},
				},
			},
			action_light_2 = {
				damage_trait_templates.powersword_finesse_stat,
			},
			action_light_3 = {
				damage_trait_templates.powersword_finesse_stat,
			},
			action_light_4 = {
				damage_trait_templates.powersword_finesse_stat,
			},
			action_light_5 = {
				damage_trait_templates.powersword_finesse_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.powersword_finesse_stat,
			},
			action_heavy_3 = {
				damage_trait_templates.powersword_finesse_stat,
			},
			action_pushfollow = {
				damage_trait_templates.powersword_finesse_stat,
			},
			action_light_1_special = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					light_sword_stab_active_p3 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_light_2_special = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					light_sword_stab_active_p3 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_light_3_special = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					light_sword_smiter_active_p3 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_light_4_special = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					light_sword_linesman_active_p3 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_light_5_special = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					light_sword_linesman_active_p3 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_heavy_1_special = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					heavy_sword_stab_active_p3 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_heavy_2_special = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					heavy_sword_linesman_active_p3 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_heavy_3_special = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					heavy_sword_smiter_active_p3 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
		},
		weapon_handling = {
			action_light_1 = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_heavy_1 = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_light_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_3 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_4 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_5 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_heavy_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_heavy_3 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_1_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_2_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_3_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_4_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_5_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_heavy_1_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_heavy_2_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_heavy_3_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
		},
	},
	powersword_p3_m1_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.eighty_percent_mobility_extra_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
}
weapon_template.traits = {}

local bespoke_powersword_p3_traits = table.ukeys(WeaponTraitsBespokePowerswordP3)

table.append(weapon_template.traits, bespoke_powersword_p3_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_melee_power_bonus_scaled_on_special_charges",
	},
	{
		display_name = "loc_weapon_keyword_heavy_special_windup",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"smiter",
			"smiter",
			"linesman",
			"linesman",
		},
	},
	secondary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"linesman",
			"smiter",
		},
	},
	special = {
		desc = "loc_stats_special_action_powersword_p3_desc",
		display_name = "loc_weapon_special_special_attack",
		type = "special_attack",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "light",
			icon = "smiter",
			value_func = "primary_attack",
		},
		{
			header = "heavy",
			icon = "smiter",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "special_attack",
		icon = "special_attack",
	},
}
weapon_template.special_actions = {
	{
		action_name = "action_heavy_1_special",
		use_special_damage = true,
	},
}

weapon_template.action_inspect_3p_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect_3p"
end

weapon_template.action_inspect_3p_base_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect"
end

return weapon_template
