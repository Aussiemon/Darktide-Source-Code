-- chunkname: @scripts/settings/equipment/weapon_templates/ogryn_power_mauls/ogryn_powermaul_p1_m1.lua

local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MeleeActionInputSetupSlow = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_slow")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeOgrynPowerMaulP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_powermaul_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local explosion_trait_templates = WeaponTraitTemplates[template_types.explosion]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_template = {}

weapon_template.action_inputs = table.clone(MeleeActionInputSetupSlow.action_inputs)
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupSlow.action_input_hierarchy)

local hit_zone_priority_torso = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.weakspot] = 2,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3,
}

table.add_missing(hit_zone_priority_torso, default_hit_zone_priority)

local default_box = {
	0.3,
	0.3,
	1,
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
				modifier = 0.25,
				t = 0.1,
			},
			{
				modifier = 0.2,
				t = 0.25,
			},
			{
				modifier = 0.35,
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
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_light = {
		allowed_during_sprint = true,
		anim_event = "attack_swing_left_down",
		anim_event_3p = "attack_swing_down_slow",
		attack_direction_override = "down",
		damage_window_end = 0.6,
		damage_window_start = 0.5,
		first_person_hit_anim = "hit_down_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
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
				chain_time = 0.57,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.57,
			},
			special_action = {
				action_name = "action_weapon_special_right",
				chain_time = 0.6,
			},
		},
		weapon_box = default_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/swing_down_left",
			anchor_point_offset = {
				0.15,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_powermaul_light_smiter,
		damage_type = damage_types.ogryn_pipe_club,
		damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_smiter_active,
		herding_template = HerdingTemplates.ogryn_punch,
	},
	action_left_heavy = {
		allowed_during_sprint = true,
		anim_event = "attack_swing_heavy_left",
		attack_direction_override = "left",
		damage_window_end = 0.5666666666666667,
		damage_window_start = 0.4,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_3",
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
				action_name = "action_melee_start_heavy_follow_up_part_1",
				chain_time = 0.91,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.7,
			},
			special_action = {
				action_name = "action_weapon_special_right",
				chain_time = 0.91,
			},
		},
		hit_zone_priority = hit_zone_priority_torso,
		weapon_box = default_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/heavy_swing_left",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_powermaul_heavy_tank,
		damage_type = damage_types.ogryn_pipe_club,
		damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_heavy_tank_active,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_right",
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
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
				modifier = 0.25,
				t = 0.1,
			},
			{
				modifier = 0.2,
				t = 0.25,
			},
			{
				modifier = 0.35,
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
				action_name = "action_right_heavy",
				chain_time = 0.66,
			},
			block = {
				action_name = "action_block",
				chain_time = 0,
			},
			special_action = {
				action_name = "action_weapon_special_right",
				chain_time = 0,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_light = {
		allowed_during_sprint = "true",
		anim_event = "attack_swing_up",
		anim_event_3p = "attack_swing_up_slow",
		attack_direction_override = "up",
		damage_window_end = 0.6,
		damage_window_start = 0.4666666666666667,
		first_person_hit_anim = "hit_up_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_3",
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
				chain_time = 0.75,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.75,
			},
		},
		hit_zone_priority = hit_zone_priority_torso,
		weapon_box = default_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/swing_up",
			anchor_point_offset = {
				0.15,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_powermaul_light_smiter,
		damage_type = damage_types.ogryn_pipe_club,
		damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_smiter_active,
	},
	action_right_heavy = {
		anim_event = "attack_swing_heavy_right",
		attack_direction_override = "right",
		damage_window_end = 0.5166666666666667,
		damage_window_start = 0.38333333333333336,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_3",
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
				chain_time = 0.7,
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 1,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.7,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 1,
			},
		},
		hit_zone_priority = hit_zone_priority_torso,
		weapon_box = default_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/heavy_swing_right",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_powermaul_heavy_tank,
		damage_type = damage_types.ogryn_pipe_club,
		damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_heavy_tank_active,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
	},
	action_melee_start_left_2 = {
		anim_event = "attack_swing_charge_left",
		chain_anim_event = "attack_swing_charge_left_pose",
		chain_anim_event_3p = "attack_swing_charge_left",
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
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
				modifier = 0.25,
				t = 0.1,
			},
			{
				modifier = 0.2,
				t = 0.25,
			},
			{
				modifier = 0.35,
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
				action_name = "action_left_heavy",
				chain_time = 0.78,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0,
			},
		},
	},
	action_left_light_2 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_left_diagonal",
		anim_event_3p = "attack_swing_left_diagonal_slow",
		attack_direction_override = "left",
		damage_window_end = 0.6,
		damage_window_start = 0.4666666666666667,
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
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.6,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority_torso,
		weapon_box = default_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/swing_left_diagonal",
			anchor_point_offset = {
				0.2,
				-0,
				-0.4,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
		damage_type = damage_types.ogryn_pipe_club,
		damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_linesman_active,
		herding_template = HerdingTemplates.linesman_left_heavy,
	},
	action_melee_start_right_2 = {
		anim_event = "attack_swing_charge_right",
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
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
				modifier = 0.25,
				t = 0.1,
			},
			{
				modifier = 0.2,
				t = 0.25,
			},
			{
				modifier = 0.35,
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
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.8,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special_right",
				chain_time = 0,
			},
		},
	},
	action_right_light_2 = {
		anim_event = "attack_swing_right_diagonal",
		anim_event_3p = "attack_swing_right_diagonal_slow",
		attack_direction_override = "right",
		damage_window_end = 0.5333333333333333,
		damage_window_start = 0.38333333333333336,
		first_person_hit_anim = "hit_right_down_shake",
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
				chain_time = 0.72,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.72,
			},
		},
		hit_zone_priority = hit_zone_priority_torso,
		weapon_box = default_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/swing_right_diagonal",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
		damage_type = damage_types.ogryn_pipe_club,
		damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_linesman_active,
		herding_template = HerdingTemplates.linesman_right_heavy,
	},
	action_melee_start_heavy_follow_up_part_1 = {
		anim_event = "attack_swing_charge_right",
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
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
				modifier = 0.25,
				t = 0.1,
			},
			{
				modifier = 0.2,
				t = 0.25,
			},
			{
				modifier = 0.35,
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
				action_name = "action_right_light_heavy_follow_up_2",
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special_right",
				chain_time = 0.6,
			},
		},
	},
	action_right_light_heavy_follow_up_2 = {
		anim_event = "attack_swing_right_diagonal",
		anim_event_3p = "attack_swing_right_diagonal_slow",
		attack_direction_override = "right",
		damage_window_end = 0.5333333333333333,
		damage_window_start = 0.36666666666666664,
		first_person_hit_anim = "hit_right_shake",
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
				action_name = "action_melee_start_left",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.6,
			},
		},
		hit_zone_priority = hit_zone_priority_torso,
		weapon_box = default_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/swing_right_diagonal",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
		damage_type = damage_types.ogryn_pipe_club,
		damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_linesman_active,
		herding_template = HerdingTemplates.linesman_right_heavy,
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
				chain_time = 0.35,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.5,
			},
		},
		inner_push_rad = math.pi * 0.35,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.ogryn_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.default_push,
		outer_damage_type = damage_types.physical,
	},
	action_right_light_pushfollow = {
		anim_event = "push_follow_up",
		anim_event_3p = "attack_swing_right_slow",
		attack_direction_override = "right",
		damage_window_end = 0.5333333333333333,
		damage_window_start = 0.4,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		sprint_requires_press_to_interrupt = "true",
		total_time = 2,
		weapon_handling_template = "time_scale_1_2",
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
				chain_time = 0.57,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.6,
			},
		},
		hit_zone_priority = hit_zone_priority_torso,
		weapon_box = default_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/push_follow_up",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
		damage_type = damage_types.ogryn_pipe_club,
		damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_linesman_active,
	},
	action_weapon_special = {
		activation_time = 0.8,
		allowed_during_sprint = true,
		anim_event = "activate",
		kind = "activate_special",
		skip_3p_anims = false,
		start_input = "special_action",
		total_time = 2.6,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 0.5,
				t = 0.2,
			},
			{
				modifier = 0.3,
				t = 0.3,
			},
			{
				modifier = 0.1,
				t = 0.6,
			},
			{
				modifier = 0.55,
				t = 1.2,
			},
			{
				modifier = 0.9,
				t = 1.3,
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
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 1,
			},
			block = {
				action_name = "action_block",
				chain_time = 1,
			},
		},
	},
	action_weapon_special_right = {
		activation_time = 0.8,
		allowed_during_sprint = true,
		anim_event = "activate",
		kind = "activate_special",
		skip_3p_anims = false,
		total_time = 2.6,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 0.5,
				t = 0.2,
			},
			{
				modifier = 0.3,
				t = 0.3,
			},
			{
				modifier = 0.1,
				t = 0.6,
			},
			{
				modifier = 0.55,
				t = 1.2,
			},
			{
				modifier = 0.9,
				t = 1.3,
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
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 1,
			},
			block = {
				action_name = "action_block",
				chain_time = 1,
			},
		},
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

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	ogryn_powermaul_dps_stat = {
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
			action_right_light_heavy_follow_up_2 = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	ogryn_powermaul_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						armor_damage_modifier = {
							attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers,
						},
					},
				},
			},
			action_left_heavy = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						armor_damage_modifier = {
							attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers,
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
			action_right_light_heavy_follow_up_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
		},
	},
	ogryn_powermaul_control_stat = {
		description = "loc_stats_display_control_stat_melee_mouseover",
		display_name = "loc_stats_display_control_stat_melee",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.thunderhammer_control_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								power_distribution = {
									impact = {
										display_name = "loc_weapon_stats_display_stagger",
									},
								},
							},
						},
						cleave_distribution = {
							attack = {},
							impact = {},
						},
						stagger_duration_modifier = {},
					},
				},
			},
			action_left_heavy = {
				damage_trait_templates.thunderhammer_control_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								power_distribution = {
									impact = {
										display_name = "loc_weapon_stats_display_stagger",
									},
								},
							},
						},
						cleave_distribution = {
							attack = {},
							impact = {},
						},
						stagger_duration_modifier = {},
					},
				},
			},
			action_right_light = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_right_light_2 = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_right_light_heavy_follow_up_2 = {
				damage_trait_templates.thunderhammer_control_stat,
			},
		},
		weapon_handling = {
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_left_heavy = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true,
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
			action_right_light_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_right_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_right_light_heavy_follow_up_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
		},
	},
	ogryn_powermaul_power_output_stat = {
		display_name = "loc_stats_display_power_output",
		is_stat_trait = true,
		explosion = {
			action_left_light = {
				overrides = {
					powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
						display_data = {
							damage_profile_path = {
								"weapon_special_tweak_data",
								"explosion_template",
								from_weapon_template = true,
							},
							display_stats = {
								__all_basic_stats = true,
							},
						},
					},
				},
			},
			action_left_heavy = {
				overrides = {
					powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
			action_right_light = {
				overrides = {
					powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
			action_right_heavy = {
				overrides = {
					powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
			action_left_light_2 = {
				overrides = {
					powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
			action_right_light_2 = {
				overrides = {
					powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
			action_right_light_pushfollow = {
				overrides = {
					powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
			action_right_light_heavy_follow_up_2 = {
				overrides = {
					powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
		},
		damage = {
			action_left_light = {
				overrides = {
					ogryn_powermaul_light_smiter_active = {
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
			action_left_heavy = {
				overrides = {
					ogryn_powermaul_heavy_tank_active = {
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
			action_right_light = {
				overrides = {
					ogryn_powermaul_light_smiter_active = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_heavy = {
				overrides = {
					ogryn_powermaul_heavy_tank_active = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_left_light_2 = {
				overrides = {
					ogryn_powermaul_light_linesman_active = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_light_pushfollow = {
				overrides = {
					ogryn_powermaul_light_linesman_active = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_light_2 = {
				overrides = {
					ogryn_powermaul_light_linesman_active = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_light_heavy_follow_up_2 = {
				overrides = {
					ogryn_powermaul_light_linesman_active = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
		},
	},
	ogryn_powermaul_defence_stat = {
		display_name = "loc_stats_display_defense_stat",
		is_stat_trait = true,
		stamina = {
			base = {
				stamina_trait_templates.thunderhammer_p1_m1_defence_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
}
weapon_template.traits = {}

local bespoke_ogryn_powermaul_traits = table.ukeys(WeaponTraitsBespokeOgrynPowerMaulP1)

table.append(weapon_template.traits, bespoke_ogryn_powermaul_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control",
	},
	{
		display_name = "loc_weapon_keyword_power_weapon",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"smiter",
			"linesman",
			"linesman",
		},
	},
	secondary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {
			"tank",
			"tank",
		},
	},
	special = {
		desc = "loc_stats_special_action_powerup_desc",
		display_name = "loc_weapon_special_activate",
		type = "activate",
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/combat_blade"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/power_maul"
weapon_template.weapon_box = {
	0.1,
	0.7,
	0.02,
}
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.allow_sprinting_with_special = true
weapon_template.weapon_special_class = "WeaponSpecialExplodeOnImpact"
weapon_template.weapon_special_tweak_data = {
	active_duration = 4,
	active_on_abort = true,
	disorientation_type = "ogryn_powermaul_disorientation",
	explosion_template = ExplosionTemplates.powermaul_activated_impact,
}
weapon_template.sprint_ready_up_time = 0.2
weapon_template.max_first_person_anim_movement_speed = 4.8
weapon_template.has_first_person_dodge_events = true
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_block",
	_special_active = "fx_special_active",
	_sweep = "fx_sweep",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"ogryn_power_maul",
	"p1",
	"activated",
}
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "ogryn_club_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_powermaul
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee

return weapon_template
