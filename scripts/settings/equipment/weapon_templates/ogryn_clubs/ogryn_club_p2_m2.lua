﻿-- chunkname: @scripts/settings/equipment/weapon_templates/ogryn_clubs/ogryn_club_p2_m2.lua

local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MeleeActionInputSetupSlow = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_slow")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeOgrynClubP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_club_p2")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local template_types = WeaponTweakTemplateSettings.template_types
local hit_zone_names = HitZone.hit_zone_names
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_template = {}
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

weapon_template.action_inputs = table.clone(MeleeActionInputSetupSlow.action_inputs)
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupSlow.action_input_hierarchy)
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
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left",
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
			},
		},
	},
	action_melee_start_left = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_left",
		chain_anim_event = "attack_swing_charge_left_pose",
		chain_anim_event_3p = "attack_swing_charge_left",
		kind = "windup",
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 3,
		uninterruptible = true,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05,
			},
			{
				modifier = 0.45,
				t = 0.1,
			},
			{
				modifier = 0.4,
				t = 0.25,
			},
			{
				modifier = 0.55,
				t = 0.4,
			},
			{
				modifier = 0.8,
				t = 1,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_left_light",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.7,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_left_diagonal",
		anim_event_3p = "attack_swing_left_diagonal_slow",
		attack_direction_override = "left",
		damage_window_end = 0.6,
		damage_window_start = 0.5,
		first_person_hit_anim = "hit_left_down_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_0_9",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15,
			},
			{
				modifier = 0.8,
				t = 0.2,
			},
			{
				modifier = 1.5,
				t = 0.25,
			},
			{
				modifier = 1.4,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			{
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.2,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.2,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_left_diagonal",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_club_light_linesman,
		damage_type = damage_types.ogryn_pipe_club,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
	},
	action_left_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_heavy_down_right",
		attack_direction_override = "down",
		damage_window_end = 0.3333333333333333,
		damage_window_start = 0.25,
		first_person_hit_anim = "hit_left_down_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_2",
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
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.3,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_down_right",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_club_heavy_smiter,
		damage_type = damage_types.ogryn_pipe_club,
		herding_template = HerdingTemplates.smiter_down,
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_down_right",
		chain_anim_event = "attack_swing_charge_down_right_pose",
		chain_anim_event_3p = "attack_swing_charge_down_right",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		uninterruptible = true,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05,
			},
			{
				modifier = 0.45,
				t = 0.1,
			},
			{
				modifier = 0.4,
				t = 0.25,
			},
			{
				modifier = 0.55,
				t = 0.4,
			},
			{
				modifier = 0.8,
				t = 1,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_right_light",
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_right_diagonal",
		anim_event_3p = "attack_swing_right_diagonal_slow",
		attack_direction_override = "right",
		damage_window_end = 0.5666666666666667,
		damage_window_start = 0.4666666666666667,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_2",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15,
			},
			{
				modifier = 0.8,
				t = 0.2,
			},
			{
				modifier = 1.5,
				t = 0.25,
			},
			{
				modifier = 1.4,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			{
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.2,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
				chain_time = 0,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.2,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_right_diagonal",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_club_light_linesman,
		damage_type = damage_types.ogryn_pipe_club,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
	},
	action_right_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_heavy_left",
		attack_direction_override = "left",
		damage_window_end = 0.5,
		damage_window_start = 0.4,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 1.72,
		uninterruptible = true,
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
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.17,
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.15,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.1,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.25,
			0.25,
			1.25,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_left",
			anchor_point_offset = {
				0,
				0,
				-0.15,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_club_heavy_tank,
		damage_type = damage_types.ogryn_pipe_club,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
	},
	action_melee_start_left_2 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_left_pose",
		anim_event_3p = "attack_swing_charge_left",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		uninterruptible = true,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05,
			},
			{
				modifier = 0.45,
				t = 0.1,
			},
			{
				modifier = 0.4,
				t = 0.25,
			},
			{
				modifier = 0.55,
				t = 0.4,
			},
			{
				modifier = 0.8,
				t = 1,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_left_light_2",
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_light_2 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_left",
		anim_event_3p = "attack_swing_left_slow",
		attack_direction_override = "left",
		damage_window_end = 0.5333333333333333,
		damage_window_start = 0.43333333333333335,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15,
			},
			{
				modifier = 0.8,
				t = 0.2,
			},
			{
				modifier = 1.5,
				t = 0.25,
			},
			{
				modifier = 1.4,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			{
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.2,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.525,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.25,
			0.25,
			1.25,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_left",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_club_light_tank,
		damage_type = damage_types.ogryn_pipe_club,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
	},
	action_melee_start_right_2 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_down_right",
		anim_event_3p = "attack_swing_charge_down_right",
		chain_anim_event = "attack_swing_charge_down_right_pose",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		uninterruptible = true,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05,
			},
			{
				modifier = 0.45,
				t = 0.1,
			},
			{
				modifier = 0.4,
				t = 0.25,
			},
			{
				modifier = 0.55,
				t = 0.4,
			},
			{
				modifier = 0.8,
				t = 1,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_right_light_2",
				chain_time = 0.2,
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_light_2 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_down_right",
		anim_event_3p = "attack_swing_down_slow",
		attack_direction_override = "right",
		damage_window_end = 0.5,
		damage_window_start = 0.4,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 1.66,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.11,
			},
			{
				modifier = 0.8,
				t = 0.16,
			},
			{
				modifier = 1.5,
				t = 0.2,
			},
			{
				modifier = 1.4,
				t = 0.33,
			},
			{
				modifier = 1,
				t = 0.4,
			},
			{
				modifier = 0.5,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 0.83,
			},
			start_modifier = 0.2,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.64,
			},
			block = {
				action_name = "action_block",
				chain_time = 0,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.2,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.2,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_down_right",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_club_light_smiter,
		damage_type = damage_types.ogryn_pipe_club,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
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
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			push = {
				action_name = "action_push",
			},
			special_action = {
				action_name = "action_weapon_special",
			},
		},
	},
	action_right_light_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "push_follow_up_01",
		anim_event_3p = "attack_swing_right",
		attack_direction_override = "right",
		damage_window_end = 0.4666666666666667,
		damage_window_start = 0.3,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
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
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.65,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.65,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/push_follow_up",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_club_smiter_pushfollow,
		damage_type = damage_types.ogryn_pipe_club,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_push = {
		anim_event = "attack_push",
		block_duration = 0.5,
		kind = "push",
		push_radius = 2.5,
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
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			push_follow_up = {
				action_name = "action_right_light_pushfollow",
				chain_time = 0.2,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25,
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.4,
			},
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.ogryn_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.default_push,
		outer_damage_type = damage_types.physical,
	},
	action_weapon_special = {
		activate_special = true,
		activation_cooldown = 6,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_slap",
		attack_direction_override = "right",
		damage_window_end = 0.39,
		damage_window_start = 0.34,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "hit_right_shake",
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.25,
		start_input = "special_action",
		total_time = 1.4,
		uninterruptible = true,
		weapon_handling_template = "time_scale_0_9",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15,
			},
			{
				modifier = 0.8,
				t = 0.2,
			},
			{
				modifier = 1.5,
				t = 0.25,
			},
			{
				modifier = 1.4,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			{
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.2,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_punch",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.8,
			},
			special_action = {
				action_name = "action_weapon_special_2",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.4,
			0.45,
			1,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_slap",
			anchor_point_offset = {
				0.15,
				-0.3,
				-0.1,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_club_special,
		damage_type = damage_types.ogryn_slap,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
	},
	action_weapon_special_2 = {
		activate_special = true,
		activation_cooldown = 6,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_slap_left",
		anim_event_3p = "attack_swing_slap_left",
		attack_direction_override = "left",
		damage_window_end = 0.4,
		damage_window_start = 0.3333333333333333,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 1.4,
		uninterruptible = true,
		weapon_handling_template = "time_scale_0_9",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15,
			},
			{
				modifier = 0.8,
				t = 0.2,
			},
			{
				modifier = 1.5,
				t = 0.25,
			},
			{
				modifier = 1.4,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			{
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.2,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_punch",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 1.2,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.4,
			0.56,
			1,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_slap_left",
			anchor_point_offset = {
				0.15,
				-0.3,
				-0.15,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_club_special,
		damage_type = damage_types.ogryn_slap,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
	},
	action_melee_start_punch = {
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_left",
		chain_anim_event = "attack_swing_charge_left_pose",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		uninterruptible = true,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05,
			},
			{
				modifier = 0.45,
				t = 0.1,
			},
			{
				modifier = 0.4,
				t = 0.25,
			},
			{
				modifier = 0.55,
				t = 0.4,
			},
			{
				modifier = 0.8,
				t = 1,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_left_light_punch",
				chain_time = 0.3,
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.75,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_light_punch = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_stab_punch",
		anim_event_3p = "attack_swing_punch",
		attack_direction_override = "push",
		damage_window_end = 0.3333333333333333,
		damage_window_start = 0.26666666666666666,
		first_person_hit_anim = "hit_up_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_2",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15,
			},
			{
				modifier = 0.8,
				t = 0.2,
			},
			{
				modifier = 1.5,
				t = 0.25,
			},
			{
				modifier = 1.4,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			{
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.2,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.75,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25,
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.7,
			0.6,
			0.9,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_stab",
			anchor_point_offset = {
				-0.2,
				0.2,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_club_light_tank,
		damage_type = damage_types.ogryn_pipe_club,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
	},
	action_inspect = {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
		skip_3p_anims = true,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
	},
}
weapon_template.base_stats = {
	ogryn_club_p2_m2_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
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
			action_left_heavy = {
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
			action_right_light = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_weapon_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_right_light_2 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_weapon_special_2 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_left_light_punch = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	ogryn_club_p2_m2_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								armor_damage_modifier = {
									attack = {
										[armor_types.armored] = {},
										[armor_types.super_armor] = {},
									},
								},
							},
						},
					},
				},
			},
			action_left_heavy = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								armor_damage_modifier = {
									attack = {
										[armor_types.armored] = {},
										[armor_types.super_armor] = {},
									},
								},
							},
						},
					},
				},
			},
			action_right_light = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_right_heavy = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_weapon_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_right_light_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_weapon_special_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_left_light_punch = {
				damage_trait_templates.default_armor_pierce_stat,
			},
		},
	},
	ogryn_club_p2_m2_finesse_stat = {
		display_name = "loc_stats_display_finesse_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
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
			action_left_heavy = {
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
			action_right_light = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_weapon_special = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_right_light_2 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_weapon_special_2 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_left_light_punch = {
				damage_trait_templates.default_melee_finesse_stat,
			},
		},
		weapon_handling = {
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						time_scale = {},
					},
				},
			},
			action_left_heavy = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						time_scale = {},
					},
				},
			},
			action_right_light = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_right_heavy = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_left_light_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_weapon_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_right_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_right_light_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_weapon_special_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_left_light_punch = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
		},
	},
	ogryn_club_p2_m2_defence_stat = {
		display_name = "loc_stats_display_defense_stat",
		is_stat_trait = true,
		stamina = {
			base = {
				stamina_trait_templates.thunderhammer_p1_m1_defence_stat,
				display_data = {
					display_stats = {
						sprint_cost_per_second = {},
						block_cost = {},
						push_cost = {},
					},
				},
			},
		},
	},
	ogryn_club_p2_m2_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = {
					display_stats = {
						distance_scale = {},
						diminishing_return_distance_modifier = {},
						diminishing_return_start = {},
						diminishing_return_limit = {},
						speed_modifier = {},
					},
				},
			},
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = {
					display_stats = {
						sprint_speed_mod = {},
					},
				},
			},
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = {
					display_stats = {
						modifier = {},
					},
				},
			},
		},
	},
}
weapon_template.traits = {}

local bespoke_ogryn_club_p2 = table.ukeys(WeaponTraitsBespokeOgrynClubP2)

table.append(weapon_template.traits, bespoke_ogryn_club_p2)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control",
	},
	{
		display_name = "loc_weapon_keyword_smiter",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_linesman",
		type = "linesman",
		attack_chain = {
			"linesman",
			"linesman",
			"tank",
			"smiter",
		},
	},
	secondary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {
			"tank",
			"smiter",
		},
	},
	special = {
		desc = "loc_stats_special_action_special_attack_ogryn_club_p2m1_desc",
		display_name = "loc_weapon_special_fist_attack",
		type = "melee_hand",
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
			icon = "tank",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "weapon_bash",
		icon = "melee_hand",
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/combat_blade"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/club_ogryn"
weapon_template.weapon_box = {
	0.1,
	0.7,
	0.02,
}
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.2
weapon_template.max_first_person_anim_movement_speed = 4.8
weapon_template.has_first_person_dodge_events = true
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.25
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_block",
	_sweep = "fx_sweep",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"ogryn_club",
	"p2",
}
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn"
weapon_template.stamina_template = "tank"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "ogryn_club_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_club
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.special_action_name = "action_weapon_special"

return weapon_template
