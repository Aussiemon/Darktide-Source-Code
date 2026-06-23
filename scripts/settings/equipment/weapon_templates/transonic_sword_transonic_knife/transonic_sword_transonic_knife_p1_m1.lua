-- chunkname: @scripts/settings/equipment/weapon_templates/transonic_sword_transonic_knife/transonic_sword_transonic_knife_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MeleeActionInputSetupMid = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_mid")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeTransonicSwordTransonicKnifeP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_transonic_sword_transonic_knife_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local attack_types = AttackSettings.attack_types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}
local action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs)

action_inputs.special_action_release = {
	buffer_time = 0.4,
	input_sequence = {
		{
			duration = 0.25,
			input = "weapon_extra_hold",
			value = true,
		},
		{
			auto_complete = true,
			input = "weapon_extra_hold",
			time_window = 0.55,
			value = false,
		},
	},
}
action_inputs.special_action_cancel = {
	buffer_time = 0.1,
	input_sequence = {
		{
			hold_input = "weapon_extra_hold",
			input = "action_two_pressed",
			value = true,
		},
	},
}
weapon_template.action_inputs = action_inputs
weapon_template.action_inputs.special_action.buffer_time = 0.5
weapon_template.action_inputs.start_attack.buffer_time = 0.35
weapon_template.action_inputs.light_attack.input_sequence[1].time_window = 0.25
weapon_template.action_inputs.heavy_attack.input_sequence[1].duration = 0.25
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

local new_special_action_transition = {
	{
		input = "special_action_release",
		transition = "base",
	},
	{
		input = "special_action_cancel",
		transition = "base",
	},
	{
		input = "special_action",
		transition = "base",
	},
	{
		input = "start_attack",
		transition = "base",
	},
	{
		input = "attack_cancel",
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

ActionInputHierarchy.update_hierarchy_entry(weapon_template.action_input_hierarchy, "special_action", new_special_action_transition)

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
}

ActionInputHierarchy.update_hierarchy_entry(weapon_template.action_input_hierarchy, "block", new_block_action_transition)
table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_inputs.wield.buffer_time = 0.4

local DEFAULT_WEAPON_BOX = {
	0.115,
	0.115,
	1.2,
}
local LONG_WEAPON_BOX = {
	0.125,
	0.125,
	1.3,
}
local HIT_ZONE_PRIORITY = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3,
}

table.add_missing(HIT_ZONE_PRIORITY, default_hit_zone_priority)

local ACTION_MOVEMENT_CURVES = {
	windup = {
		{
			modifier = 0.8,
			t = 0.05,
		},
		{
			modifier = 0.95,
			t = 0.1,
		},
		{
			modifier = 1,
			t = 0.25,
		},
		{
			modifier = 1.1,
			t = 0.4,
		},
		{
			modifier = 1,
			t = 0.6,
		},
		{
			modifier = 1,
			t = 1,
		},
		start_modifier = 0.7,
	},
	windup_slow = {
		{
			modifier = 0.65,
			t = 0.05,
		},
		{
			modifier = 0.55,
			t = 0.1,
		},
		{
			modifier = 0.6,
			t = 0.25,
		},
		{
			modifier = 0.7,
			t = 0.4,
		},
		{
			modifier = 0.8,
			t = 1,
		},
		start_modifier = 0.7,
	},
	light_attack_init = {
		{
			modifier = 2,
			t = 0.1,
		},
		{
			modifier = 1.8,
			t = 0.15,
		},
		{
			modifier = 1.4,
			t = 0.2,
		},
		{
			modifier = 0.6,
			t = 0.4,
		},
		{
			modifier = 1,
			t = 0.8,
		},
		start_modifier = 0.1,
	},
	light_attack = {
		{
			modifier = 1.35,
			t = 0.06,
		},
		{
			modifier = 1.325,
			t = 0.18,
		},
		{
			modifier = 1.25,
			t = 0.22,
		},
		{
			modifier = 0.8,
			t = 0.28,
		},
		{
			modifier = 1,
			t = 0.34,
		},
		start_modifier = 0.45,
	},
	light_attack_alt = {
		{
			modifier = 2,
			t = 0.05,
		},
		{
			modifier = 1.8,
			t = 0.11,
		},
		{
			modifier = 1.4,
			t = 0.17,
		},
		{
			modifier = 1,
			t = 0.21,
		},
		start_modifier = 0.45,
	},
	heavy_attack_1 = {
		{
			modifier = 1.4,
			t = 0.15,
		},
		{
			modifier = 1.3,
			t = 0.4,
		},
		{
			modifier = 0.925,
			t = 0.6,
		},
		{
			modifier = 1,
			t = 1,
		},
		start_modifier = 1.25,
	},
	heavy_attack_2 = {
		{
			modifier = 1.9,
			t = 0.15,
		},
		{
			modifier = 1.85,
			t = 0.3,
		},
		{
			modifier = 1.7,
			t = 0.4,
		},
		{
			modifier = 1.5,
			t = 0.6,
		},
		{
			modifier = 1,
			t = 1,
		},
		start_modifier = 2,
	},
}
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
local TIME_SCALE_STAT_BUFFS = {
	buff_stat_buffs.attack_speed,
	buff_stat_buffs.melee_attack_speed,
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
		total_time = 0.45,
		uninterruptible = true,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.3,
			},
			start_modifier = 0.9,
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
				{
					action_name = "action_start_1_special",
				},
				{
					action_name = "action_start_wield",
				},
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				{
					action_name = "action_special_deactivate",
					chain_time = 0.1,
				},
				{
					action_name = "action_special_activate",
					chain_time = 0.1,
				},
			},
		},
	},
	action_start_wield = {
		action_priority = 3,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down",
		anim_event_3p = "heavy_charge_right",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_wield",
			},
			heavy_attack = {
				action_name = "action_heavy_wield",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_wield = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_diagonal_down_alt",
		anim_event_3p = "attack_right_diagonal_down",
		damage_window_end = 0.4666666666666667,
		damage_window_start = 0.385,
		kind = "sweep",
		range_mod = 1.1,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_start_3",
				chain_time = 0.55,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_right_diagonal_down_alt",
				reference_attachment_id = "right",
				anchor_point_offset = {
					-0.1,
					0,
					0.05,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 1.15,
			[armor_types.resistant] = 1.15,
			[armor_types.super_armor] = 1.15,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_light_linesman,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_heavy_wield = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_diagonal_down",
		anim_event_3p = "heavy_attack_right",
		damage_window_end = 0.3333333333333333,
		damage_window_start = 0.20833333333333334,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.175,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.heavy_attack_1,
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
				action_name = "action_start_wield_combo",
				chain_time = 0.52,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_heavy_right_diagonal_down",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 1.15,
			[armor_types.resistant] = 1.15,
			[armor_types.super_armor] = 1.15,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_heavy_linesman,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_start_wield_combo = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_diagonal_down_pose",
		anim_event_3p = "heavy_charge_left_diagonal_down",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup,
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
				chain_time = 0.575,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_start_1 = {
		action_priority = 1,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_diagonal_down",
		anim_event_3p = "heavy_charge_left",
		chain_anim_event = "heavy_charge_left_diagonal_down_pose",
		chain_anim_event_3p = "heavy_charge_left",
		kind = "windup",
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup,
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
				chain_time = 0.575,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_diagonal_down",
		anim_event_3p = "attack_left_diagonal_down",
		damage_window_end = 0.4083333333333333,
		damage_window_start = 0.325,
		kind = "sweep",
		range_mod = 1.1,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_start_2",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_left_diagonal_down",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0.1,
					0,
					-0.05,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 1.15,
			[armor_types.resistant] = 1.15,
			[armor_types.super_armor] = 1.15,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_light_linesman,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_heavy_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_diagonal_down",
		anim_event_3p = "heavy_attack_left_down",
		damage_window_end = 0.3,
		damage_window_start = 0.18333333333333332,
		kind = "sweep",
		range_mod = 1.2,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.heavy_attack_1,
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
				action_name = "action_start_2",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/heavy_swing_left_diagonal",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0.2,
					0,
					-0.15,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 1.15,
			[armor_types.resistant] = 1.15,
			[armor_types.super_armor] = 1.15,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_heavy_linesman,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_start_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_cross",
		anim_event_3p = "heavy_charge_cross",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup,
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
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.6,
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
		anim_event = "attack_right_diagonal_down_alt",
		anim_event_3p = "attack_right_diagonal_down",
		damage_window_end = 0.4666666666666667,
		damage_window_start = 0.385,
		kind = "sweep",
		range_mod = 1.1,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_start_3",
				chain_time = 0.55,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_right_diagonal_down_alt",
				reference_attachment_id = "right",
				anchor_point_offset = {
					-0.1,
					0,
					0.05,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 1.15,
			[armor_types.resistant] = 1.15,
			[armor_types.super_armor] = 1.15,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_light_linesman,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_heavy_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_cross",
		anim_event_3p = "heavy_attack_cross",
		attack_direction_override = "push",
		damage_window_end = 0.3,
		damage_window_start = 0.25,
		kind = "sweep",
		range_mod = 1.2,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.heavy_attack_2,
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
				action_name = "action_start_3",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweep_process_mode = ActionSweepSettings.multi_sweep_process_mode.shared,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_heavy_cross",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					-0.25,
				},
			},
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_heavy_cross_offhand_sweep",
				reference_attachment_id = "left",
				anchor_point_offset = {
					0,
					0,
					-0.5,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 1.15,
			[armor_types.resistant] = 1.15,
			[armor_types.super_armor] = 1.15,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_heavy_double_linesman,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_start_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_diagonal_down_pose",
		anim_event_3p = "heavy_charge_left",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup,
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
			},
			heavy_attack = {
				action_name = "action_heavy_1",
				chain_time = 0.575,
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
		anim_event = "attack_right_offhand",
		anim_event_3p = "attack_right_offhand",
		damage_window_end = 0.48333333333333334,
		damage_window_start = 0.4166666666666667,
		kind = "sweep",
		range_mod = 1.225,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_start_1",
				chain_time = 0.46,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.46,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = DEFAULT_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_right_offhand_offhand_sweep",
				reference_attachment_id = "left",
				anchor_point_offset = {
					0,
					0.15,
					-0.3,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 1.15,
			[armor_types.resistant] = 1.15,
			[armor_types.super_armor] = 1.15,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_light_ninja,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_start_1_special = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_cross_down",
		anim_event_3p = "heavy_charge_cross_down",
		chain_anim_event = "heavy_charge_cross_down_pose",
		chain_anim_event_3p = "heavy_charge_cross_down",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup_slow,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_1_special",
			},
			heavy_attack = {
				action_name = "action_heavy_1_special",
				chain_time = 0.525,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_light_1_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_stab",
		anim_event_3p = "attack_swing_up_diagonal_02",
		attack_direction_override = "push",
		chain_anim_event = "attack_stab_alt",
		chain_anim_event_3p = "attack_stab_alt",
		damage_window_end = 0.175,
		damage_window_start = 0.13333333333333333,
		ignore_armor_aborts_attack = true,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.15,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_start_2_special",
				chain_time = 0.375,
			},
			special_action = {
				action_name = "action_special_deactivate",
				chain_time = 0.375,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = {
			0.2,
			0.2,
			1.2,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_stab_alt_offhand_sweep",
				reference_attachment_id = "left",
				anchor_point_offset = {
					-0.25,
					0,
					-0.2,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.unarmored] = 1.75,
			[armor_types.berserker] = 1.75,
			[armor_types.disgustingly_resilient] = 1.75,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_light_ninja_ap,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_heavy_1_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_cross_down",
		chain_anim_event_3p = "heavy_attack_cross_down",
		damage_window_end = 0.25,
		damage_window_start = 0.2,
		ignore_armor_aborts_attack = true,
		kind = "sweep",
		range_mod = 1.15,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.heavy_attack_2,
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
				action_name = "action_start_2_special",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_special_deactivate",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_heavy_cross_down",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					0.1,
				},
			},
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_heavy_cross_down_offhand_sweep",
				reference_attachment_id = "left",
				anchor_point_offset = {
					-0.15,
					0,
					-0.15,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.unarmored] = 1.75,
			[armor_types.berserker] = 1.75,
			[armor_types.disgustingly_resilient] = 1.75,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_heavy_double_smiter_ap,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_start_2_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_down",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_2_special",
			},
			heavy_attack = {
				action_name = "action_heavy_2_special",
				chain_time = 0.51,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_light_2_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_down",
		anim_event_3p = "attack_down",
		attack_direction_override = "down",
		damage_window_end = 0.5,
		damage_window_start = 0.425,
		ignore_armor_aborts_attack = true,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.125,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack_alt,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_start_3_special",
				chain_time = 0.55,
			},
			special_action = {
				action_name = "action_special_deactivate",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		hit_zone_priority = HIT_ZONE_PRIORITY,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/swing_down_left",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					0.15,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.unarmored] = 1.75,
			[armor_types.berserker] = 1.75,
			[armor_types.disgustingly_resilient] = 1.75,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_light_smiter_ap,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_heavy_2_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_down",
		damage_window_end = 0.2916666666666667,
		damage_window_start = 0.225,
		ignore_armor_aborts_attack = true,
		kind = "sweep",
		range_mod = 1.15,
		start_input = nil,
		sweep_trail_window_start = 100,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.heavy_attack_1,
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
				action_name = "action_start_1_special",
				chain_time = 0.55,
			},
			special_action = {
				action_name = "action_special_deactivate",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_heavy_left_down",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0.1,
					0,
					0,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.unarmored] = 1.75,
			[armor_types.berserker] = 1.75,
			[armor_types.disgustingly_resilient] = 1.75,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_heavy_smiter_ap,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_start_3_special = {
		action_priority = 1,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_cross_down_pose",
		anim_event_3p = "heavy_charge_left",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup_slow,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_3_special",
			},
			heavy_attack = {
				action_name = "action_heavy_1_special",
				chain_time = 0.525,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_light_3_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_down",
		anim_event_3p = "attack_right_diagonal_down",
		attack_direction_override = "down",
		damage_window_end = 0.425,
		damage_window_start = 0.35,
		ignore_armor_aborts_attack = true,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.2,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_start_4_special",
				chain_time = 0.55,
			},
			special_action = {
				action_name = "action_special_deactivate",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_right_down",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.unarmored] = 1.75,
			[armor_types.berserker] = 1.75,
			[armor_types.disgustingly_resilient] = 1.75,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_light_smiter_ap,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_start_4_special = {
		action_priority = 1,
		allowed_during_sprint = true,
		anim_event = "heavy_charge_left_down",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_1_special",
			},
			heavy_attack = {
				action_name = "action_heavy_2_special",
				chain_time = 0.51,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_block = {
		anim_end_event = "parry_finished",
		anim_event = "parry_pose",
		kind = "block",
		minimum_hold_time = 0.3,
		start_input = "block",
		stop_input = "block_release",
		uninterruptible = true,
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
		block_duration = 0.4,
		kind = "push",
		push_radius = 2.5,
		start_input = nil,
		total_time = 1,
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
			push_follow_up = {
				{
					action_name = "action_pushfollow_special",
					chain_time = 0.3,
				},
				{
					action_name = "action_pushfollow",
					chain_time = 0.3,
				},
			},
			block = {
				action_name = "action_block",
				chain_time = 0.3,
			},
			start_attack = {
				{
					action_name = "action_start_1_special",
					chain_time = 0.45,
				},
				{
					action_name = "action_start_1",
					chain_time = 0.45,
				},
			},
			special_action = {
				{
					action_name = "action_special_deactivate",
					chain_time = 0.45,
				},
				{
					action_name = "action_special_activate",
					chain_time = 0.45,
				},
			},
		},
		inner_push_rad = math.pi * 0.1,
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
		anim_event = "attack_left_down",
		anim_event_3p = "attack_down",
		attack_direction_override = "down",
		damage_window_end = 0.5083333333333333,
		damage_window_start = 0.425,
		kind = "sweep",
		range_mod = 1.2,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
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
				action_name = "action_start_pushfollow_combo",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		hit_zone_priority = HIT_ZONE_PRIORITY,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/swing_down_left",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 1.15,
			[armor_types.resistant] = 1.15,
			[armor_types.super_armor] = 1.15,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_light_smiter,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_start_pushfollow_combo = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_cross",
		anim_event_3p = "heavy_charge_cross",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_pushfollow_combo",
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_pushfollow_combo = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_down",
		anim_event_3p = "attack_right_diagonal_down",
		attack_direction_override = "down",
		damage_window_end = 0.425,
		damage_window_start = 0.35,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.2,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_start_3",
				chain_time = 0.55,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/cryptic_power_sword/attack_right_down",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 1.15,
			[armor_types.resistant] = 1.15,
			[armor_types.super_armor] = 1.15,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_light_smiter,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_pushfollow_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right",
		anim_event_3p = "attack_right",
		damage_window_end = 0.38333333333333336,
		damage_window_start = 0.3358333333333333,
		ignore_armor_aborts_attack = true,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.2,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
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
				action_name = "action_start_pushfollow_special_combo",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_special_deactivate",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_right",
				reference_attachment_id = "right",
				anchor_point_offset = {
					-0.1,
					0,
					-0.05,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.unarmored] = 1.75,
			[armor_types.berserker] = 1.75,
			[armor_types.disgustingly_resilient] = 1.75,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_light_linesman_ap,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_start_pushfollow_special_combo = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_down",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_pushfollow_special_combo",
			},
			heavy_attack = {
				action_name = "action_heavy_2_special",
				chain_time = 0.51,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_light_pushfollow_special_combo = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_diagonal_down",
		anim_event_3p = "attack_left_diagonal_down",
		chain_anim_event = "attack_left_diagonal_down_alt",
		chain_anim_event_3p = "attack_left_diagonal_down",
		damage_window_end = 0.4083333333333333,
		damage_window_start = 0.325,
		ignore_armor_aborts_attack = true,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.1,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_start_3_special",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_special_deactivate",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_left_diagonal_down",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0.1,
					0,
					-0.05,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.unarmored] = 1.75,
			[armor_types.berserker] = 1.75,
			[armor_types.disgustingly_resilient] = 1.75,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_light_linesman_ap,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_special_activate_default_start = {
		activate_anim_event = "activate_stance",
		activate_anim_event_3p = "stance_activate",
		activation_time = 0.53,
		allowed_during_sprint = true,
		deactivate_anim_event = "activate_stance",
		deactivate_anim_event_3p = "stance_activate",
		deactivation_time = 0.53,
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = "special_action",
		total_time = 0.575,
		total_time_deactivate = 0.575,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.2,
			},
			{
				modifier = 0.62,
				t = 0.3,
			},
			{
				modifier = 0.6,
				t = 0.325,
			},
			{
				modifier = 0.61,
				t = 0.35,
			},
			{
				modifier = 0.75,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 1,
			},
			{
				modifier = 1.1,
				t = 2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			block = {
				action_name = "action_block",
				chain_time = 0.55,
			},
			wield = {
				action_name = "action_unwield",
			},
			special_action_release = {
				action_name = "action_special_activate_default_end",
				chain_time = 0.54,
			},
		},
		conditional_state_to_action_input = {
			action_end = {
				input_name = "special_action_release",
			},
		},
	},
	action_special_activate_default_end = {
		allowed_during_sprint = true,
		kind = "dummy",
		start_input = nil,
		total_time = 0.005,
		total_time_deactivate = 0.005,
		weapon_handling_template = "time_scale_1",
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
	},
	action_special_activate = {
		abort_sprint = true,
		activation_time = 0.45,
		anim_end_event = "parry_finished",
		anim_event = "attack_special_parry",
		anim_event_3p = "attack_special_parry",
		block_duration = 0.75,
		deactivation_time = 0.45,
		invalid_start_action_for_stat_calculation = true,
		kind = "toggle_special_with_block",
		prevent_sprint = true,
		start_input = nil,
		total_time = 1,
		total_time_deactivate = 1,
		weapon_handling_template = "time_scale_1",
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
			block = {
				action_name = "action_block",
				chain_time = 0.525,
			},
			start_attack = {
				action_name = "action_special_start_activate",
				chain_time = 0.525,
			},
			special_action_release = {
				action_name = "action_special_end",
				chain_time = 0.99,
			},
		},
		conditional_state_to_action_input = {
			action_end = {
				input_name = "special_action_release",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action"
		end,
		block_attack_types = {
			[attack_types.melee] = true,
		},
	},
	action_special_start_activate = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special_activate_charge",
		anim_event_3p = "loop",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup_slow,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_special_sweep_activate_light",
			},
			heavy_attack = {
				action_name = "action_special_sweep_activate_heavy",
				chain_time = 0.25,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_special_sweep_activate_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special_activate",
		anim_event_3p = "attack_left_down_offhand",
		attack_direction_override = "down",
		damage_window_end = 0.35,
		damage_window_start = 0.275,
		ignore_armor_aborts_attack = true,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.25,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack,
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
				action_name = "action_start_2_special",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_special_deactivate",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = DEFAULT_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_special_stab_offhand_sweep",
				reference_attachment_id = "left",
				anchor_point_offset = {
					0.2,
					0,
					0,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.unarmored] = 1.75,
			[armor_types.berserker] = 1.75,
			[armor_types.disgustingly_resilient] = 1.75,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_special_smiter_ap,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_special_sweep_activate_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special_activate_heavy",
		anim_event_3p = "attack_left_down_offhand",
		attack_direction_override = "down",
		damage_window_end = 0.15,
		damage_window_start = 0.06666666666666667,
		ignore_armor_aborts_attack = true,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.25,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack,
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
				action_name = "action_start_2_special",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_special_deactivate",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = DEFAULT_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_special_stab_fast_offhand_sweep",
				reference_attachment_id = "left",
				anchor_point_offset = {
					0.2,
					0,
					0,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.unarmored] = 1.75,
			[armor_types.berserker] = 1.75,
			[armor_types.disgustingly_resilient] = 1.75,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_special_smiter_ap,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_special_deactivate = {
		abort_sprint = true,
		activation_time = 0.5,
		anim_end_event = "parry_finished",
		anim_event = "attack_special_parry",
		anim_event_3p = "attack_special_parry",
		block_duration = 0.75,
		deactivation_time = 0.5,
		invalid_start_action_for_stat_calculation = true,
		kind = "toggle_special_with_block",
		prevent_sprint = true,
		start_input = nil,
		total_time = 1,
		total_time_deactivate = 1,
		weapon_handling_template = "time_scale_1",
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
			block = {
				action_name = "action_block",
				chain_time = 0.575,
			},
			start_attack = {
				action_name = "action_special_start_deactivate",
				chain_time = 0.575,
			},
			special_action_release = {
				action_name = "action_special_end",
				chain_time = 0.99,
			},
		},
		conditional_state_to_action_input = {
			action_end = {
				input_name = "special_action_release",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action"
		end,
		block_attack_types = {
			[attack_types.melee] = true,
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_special_start_deactivate = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special_activate_diagonal_charge",
		anim_event_3p = "loop",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = ACTION_MOVEMENT_CURVES.windup_slow,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_special_sweep_deactivate_light",
			},
			heavy_attack = {
				action_name = "action_special_sweep_deactivate_heavy",
				chain_time = 0.25,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_special_sweep_deactivate_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special_activate_diagonal",
		anim_event_3p = "attack_right_diagonal_up",
		damage_window_end = 0.36666666666666664,
		damage_window_start = 0.26666666666666666,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.15,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack,
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
				action_name = "action_start_3",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_special_right_diagonal_up",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 1.15,
			[armor_types.resistant] = 1.15,
			[armor_types.super_armor] = 1.15,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_special_linesman,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_special_sweep_deactivate_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special_activate_diagonal_heavy",
		anim_event_3p = "attack_right_diagonal_up",
		damage_window_end = 0.23333333333333334,
		damage_window_start = 0.13333333333333333,
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.15,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_transonic",
		action_movement_curve = ACTION_MOVEMENT_CURVES.light_attack,
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
				action_name = "action_start_3",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = LONG_WEAPON_BOX,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_transonic_blades/attack_special_right_diagonal_up_fast",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 1.15,
			[armor_types.resistant] = 1.15,
			[armor_types.super_armor] = 1.15,
		},
		damage_profile = DamageProfileTemplates.transonic_sword_transonic_knife_special_linesman,
		damage_type = damage_types.transonic,
		damage_type_special_active = damage_types.transonic,
		time_scale_stat_buffs = TIME_SCALE_STAT_BUFFS,
	},
	action_special_end = {
		allowed_during_sprint = true,
		kind = "dummy",
		start_input = nil,
		total_time = 0.005,
		total_time_deactivate = 0.005,
		weapon_handling_template = "time_scale_1",
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
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
		chain_anim_event = "alternative_inspect_stop",
		chain_anim_event_3p = "alternative_inspect_stop",
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
			inspect_alt_start = {
				action_name = "action_inspect_alt",
				chain_time = 0.75,
			},
			inspect_3p_start = {
				action_name = "action_inspect_3p",
				chain_time = 0.75,
			},
		},
	},
	action_inspect_alt = {
		anim_end_event = "inspect_end",
		anim_event = "alternative_inspect_start",
		anim_event_3p = "alternative_inspect_start",
		kind = "inspect",
		lock_view = true,
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
			inspect_alt_stop = {
				action_name = "action_inspect",
				chain_time = 1.1,
			},
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/dual_transonic_blades"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/dual_transonics"
weapon_template.weapon_box = {
	0.15,
	0.65,
	0.15,
}
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
	uses_weapon_special_charges = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.damage_window_start_sweep_trail_offset = -0.2
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_block",
	_sweep = "fx_sweep",
	_wielded_idling_sfx = "sfx_idle",
	_wielded_idling_vfx = "vfx_idle",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.buffs = {
	on_equip = {},
}
weapon_template.keywords = {
	"melee",
	"transonic_sword_transonic_knife",
	"p1",
}
weapon_template.dodge_template = "transonics"
weapon_template.sprint_template = "transonics"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "assault"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.combat_knife
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.light

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	transonic_sword_transonic_knife_p1_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.default_melee_dps_stat,
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
				damage_trait_templates.default_melee_dps_stat,
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
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_3 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_wield = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_wield = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_pushfollow_combo = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_special_sweep_activate_light = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_special_sweep_activate_heavy = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_1_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_2_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_3_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_pushfollow_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_pushfollow_special_combo = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_special_sweep_deactivate_light = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_special_sweep_deactivate_heavy = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat = {
		display_name = "loc_stats_display_cleave_damage_and_targets_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true,
						targets = {
							[2] = {
								armor_damage_modifier = {
									attack = {
										[armor_types.unarmored] = {
											display_name = "loc_weapon_stats_display_cleave_unarmored",
										},
										[armor_types.disgustingly_resilient] = {
											display_name = "loc_weapon_stats_display_cleave_disgustingly_resilient",
										},
										[armor_types.resistant] = {
											display_name = "loc_weapon_stats_display_cleave_resistant",
										},
										[armor_types.berserker] = {
											display_name = "loc_weapon_stats_display_cleave_berserker",
										},
									},
								},
							},
						},
					},
				},
			},
			action_heavy_1 = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true,
						targets = {
							[2] = {
								armor_damage_modifier = {
									attack = {
										[armor_types.unarmored] = {
											display_name = "loc_weapon_stats_display_cleave_unarmored",
										},
										[armor_types.disgustingly_resilient] = {
											display_name = "loc_weapon_stats_display_cleave_disgustingly_resilient",
										},
										[armor_types.resistant] = {
											display_name = "loc_weapon_stats_display_cleave_resistant",
										},
										[armor_types.berserker] = {
											display_name = "loc_weapon_stats_display_cleave_berserker",
										},
									},
								},
							},
						},
					},
				},
			},
			action_light_2 = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_light_3 = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_light_wield = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_heavy_wield = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_pushfollow = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_light_pushfollow_combo = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_special_sweep_activate_light = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_special_sweep_activate_heavy = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_light_1_special = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_light_2_special = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_light_3_special = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_pushfollow_special = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_light_pushfollow_special_combo = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_special_sweep_deactivate_light = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
			action_special_sweep_deactivate_heavy = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_cleave_damage_and_targets_stat,
			},
		},
	},
	transonic_sword_transonic_knife_p1_m1_crit_stat = {
		display_name = "loc_stats_display_crit_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_light_1 = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_heavy_1 = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_light_2 = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_heavy_2 = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_light_3 = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_light_wield = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_heavy_wield = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_pushfollow = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_light_pushfollow_combo = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_special_sweep_activate_light = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_special_sweep_activate_heavy = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_light_1_special = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_heavy_1_special = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_light_2_special = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_heavy_2_special = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_light_3_special = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_pushfollow_special = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_light_pushfollow_special_combo = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_special_sweep_deactivate_light = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_special_sweep_deactivate_heavy = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
		},
		damage = {
			action_light_1 = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_heavy_1 = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_light_2 = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_light_3 = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_light_wield = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_heavy_wield = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_pushfollow = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_light_pushfollow_combo = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_special_sweep_activate_light = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_special_sweep_activate_heavy = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_light_1_special = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_light_2_special = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_light_3_special = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_pushfollow_special = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_light_pushfollow_special_combo = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_special_sweep_deactivate_light = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
			action_special_sweep_deactivate_heavy = {
				damage_trait_templates.transonic_sword_transonic_knife_p1_m1_crit_stat,
			},
		},
	},
	transonic_sword_transonic_knife_p1_m1_finesse_stat = {
		display_name = "loc_stats_display_finesse_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.default_melee_finesse_stat,
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
				damage_trait_templates.default_melee_finesse_stat,
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
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_3 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_wield = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_heavy_wield = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_pushfollow_combo = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_special_sweep_activate_light = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_special_sweep_activate_heavy = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_1_special = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_2_special = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_3_special = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_pushfollow_special = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_pushfollow_special_combo = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_special_sweep_deactivate_light = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_special_sweep_deactivate_heavy = {
				damage_trait_templates.default_melee_finesse_stat,
			},
		},
		weapon_handling = {
			action_light_1 = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_heavy_1 = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_light_2 = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_heavy_2 = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_light_3 = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_light_wield = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_heavy_wield = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_pushfollow = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_light_pushfollow_combo = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_special_sweep_activate_light = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_special_sweep_activate_heavy = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_light_1_special = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_heavy_1_special = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_light_2_special = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_heavy_2_special = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_light_3_special = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_pushfollow_special = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_light_pushfollow_special_combo = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_special_sweep_deactivate_light = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
			action_special_sweep_deactivate_heavy = {
				weapon_handling_trait_templates.transonic_sword_transonic_knife_p1_m1_finesse_stat,
			},
		},
	},
	transonic_sword_transonic_knife_p1_m1_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								armor_damage_modifier = {
									attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers,
								},
							},
						},
					},
				},
			},
			action_heavy_1 = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								armor_damage_modifier = {
									attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers,
								},
							},
						},
					},
				},
			},
			action_light_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_3 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_wield = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_wield = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_pushfollow_combo = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_special_sweep_activate_light = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_special_sweep_activate_heavy = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_1_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_2_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_3_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_pushfollow_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_pushfollow_special_combo = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_special_sweep_deactivate_light = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_special_sweep_deactivate_heavy = {
				damage_trait_templates.default_armor_pierce_stat,
			},
		},
	},
}
weapon_template.weapon_special_class = "WeaponSpecialActivateToggle"
weapon_template.weapon_special_tweak_data = {
	deactivation_animation_delay = 0.4,
	deactivation_animation_on_abort = true,
	set_inactive_func = function (inventory_slot_component, reason, tweak_data)
		local disable_special_active = reason == "manual_toggle"

		if disable_special_active then
			inventory_slot_component.special_active = false
			inventory_slot_component.num_special_charges = 0
		end

		return true
	end,
}
weapon_template.traits = {}

local weapon_traits_bespoke_transonic_sword_transonic_knife_p1 = table.ukeys(WeaponTraitsBespokeTransonicSwordTransonicKnifeP1)

table.append(weapon_template.traits, weapon_traits_bespoke_transonic_sword_transonic_knife_p1)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_versatile",
	},
	{
		description = "loc_weapon_stats_display_high_cleave_desc",
		display_name = "loc_weapon_keyword_high_cleave",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_linesman",
		type = "linesman",
		attack_chain = {
			"linesman",
			"linesman",
			"ninja_fencer",
		},
	},
	secondary = {
		display_name = "loc_gestalt_linesman",
		type = "linesman",
		attack_chain = {
			"linesman",
			"linesman",
		},
	},
	special = {
		desc = "loc_stats_special_action_transonic_sword_transonic_knife_desc",
		display_name = "loc_weapon_special_mode_switch",
		type = "activate",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "light",
			icon = "linesman",
			value_func = "primary_attack",
		},
		{
			header = "heavy",
			icon = "linesman",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "activate",
		icon = "activate",
	},
}
weapon_template.special_action_name = "action_special_sweep_activate_light"

weapon_template.action_inspect_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect"
end

weapon_template.action_alt_inspect_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect_alt"
end

weapon_template.action_inspect_3p_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect_3p"
end

weapon_template.action_inspect_3p_base_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect"
end

return weapon_template
