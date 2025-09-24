-- chunkname: @scripts/settings/equipment/weapon_templates/power_mauls_2h/powermaul_2h_p1_m1.lua

local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local AimAssistTemplates = require("scripts/settings/equipment/aim_assist_templates")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MeleeActionInputSetupSlow = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_slow")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokePowermaul2hP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_2h_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local wounds_shapes = WoundsSettings.shapes
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local explosion_trait_templates = WeaponTraitTemplates[template_types.explosion]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}

weapon_template.action_inputs = table.clone(MeleeActionInputSetupSlow.action_inputs)
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupSlow.action_input_hierarchy)

local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3,
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

local light_hitbox = {
	0.2,
	0.15,
	1.35,
}
local heavy_hitbox = {
	0.4,
	0.15,
	1.4,
}

weapon_template.action_inputs.push_follow_up = {
	buffer_time = 0.2,
	input_sequence = {
		{
			duration = 0.2,
			hold_input = "action_two_hold",
			input = "action_one_hold",
			value = true,
		},
	},
}
weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
		},
	},
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "equip_2h_powermaul",
		kind = "wield",
		sprint_ready_up_time = 0,
		total_time = 0.3,
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
			special_action = {
				action_name = "action_weapon_special",
			},
		},
	},
	action_melee_start_left = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_left_down",
		chain_anim_event = "attack_swing_charge_left_down_pose",
		chain_anim_event_3p = "attack_swing_charge_left_down",
		kind = "windup",
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 3,
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
				modifier = 0.68,
				t = 0.25,
			},
			{
				modifier = 0.65,
				t = 0.4,
			},
			{
				modifier = 0.65,
				t = 0.5,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.3,
				t = 1.2,
			},
			{
				modifier = 0.1,
				t = 3,
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
				action_name = "action_left_down_light",
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.53,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_down_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_left",
		attack_direction_override = "left",
		damage_window_end = 0.5333333333333333,
		damage_window_start = 0.4166666666666667,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.15,
		special_active_hit_stop_anim = "attack_hit_power",
		total_time = 2,
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
				modifier = 0.65,
				t = 0.4,
			},
			{
				modifier = 0.6,
				t = 0.45,
			},
			{
				modifier = 0.6,
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
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.68,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.53,
				chain_until = 0.2,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.55,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = light_hitbox,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_power_maul/swing_left",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_2h_light_tank,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.powermaul_2h_light_tank_active,
		herding_template = HerdingTemplates.thunder_hammer_left_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		wounds_shape_special_active = wounds_shapes.horizontal_slash_coarse,
	},
	action_left_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_heavy_left_down",
		attack_direction_override = "down",
		damage_window_end = 0.4666666666666667,
		damage_window_start = 0.3333333333333333,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.25,
		special_active_hit_stop_anim = "attack_hit_power",
		total_time = 1.75,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.1,
			},
			{
				modifier = 1.15,
				t = 0.15,
			},
			{
				modifier = 1.25,
				t = 0.25,
			},
			{
				modifier = 1.3,
				t = 0.35,
			},
			{
				modifier = 1.25,
				t = 0.45,
			},
			{
				modifier = 0.5,
				t = 0.47,
			},
			{
				modifier = 0.45,
				t = 0.6,
			},
			{
				modifier = 0.45,
				t = 0.65,
			},
			{
				modifier = 0.9,
				t = 0.8,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.4,
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
				chain_time = 0.68,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
				chain_until = 0.2,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.68,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = heavy_hitbox,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_power_maul/heavy_swing_left_down",
				anchor_point_offset = {
					0.02,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_2h_heavy_smiter,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.powermaul_2h_heavy_smiter_active,
		weapon_special_tweak_data = {
			explosion_template = ExplosionTemplates.human_heavy_powermaul_activated_impact,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing_heavy,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		wounds_shape_special_active = wounds_shapes.vertical_slash_coarse,
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_right_pose",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
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
				modifier = 0.68,
				t = 0.25,
			},
			{
				modifier = 0.65,
				t = 0.4,
			},
			{
				modifier = 0.65,
				t = 0.5,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.3,
				t = 1.2,
			},
			{
				modifier = 0.3,
				t = 3,
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
				action_name = "action_right_down_light",
				chain_time = 0.12,
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.35,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_down_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_right_down",
		anim_event_3p = "attack_swing_right_diagonal",
		attack_direction_override = "down",
		damage_window_end = 0.5,
		damage_window_start = 0.43333333333333335,
		first_person_hit_anim = "hit_right_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.15,
		special_active_hit_stop_anim = "attack_hit_power",
		total_time = 2,
		weapon_handling_template = "time_scale_1_2",
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
				modifier = 0.65,
				t = 0.4,
			},
			{
				modifier = 0.6,
				t = 0.45,
			},
			{
				modifier = 0.6,
				t = 0.6,
			},
			{
				modifier = 0.9,
				t = 0.7,
			},
			{
				modifier = 0.95,
				t = 0.75,
			},
			{
				modifier = 0.94,
				t = 0.8,
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
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.62,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
				chain_until = 0.2,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = heavy_hitbox,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_power_maul/swing_right_down",
				anchor_point_offset = {
					-0.2,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_2h_light_smiter,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.powermaul_2h_light_smiter_active,
		herding_template = HerdingTemplates.thunder_hammer_right_down_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing,
		wounds_shape = wounds_shapes.right_45_slash_coarse,
		wounds_shape_special_active = wounds_shapes.right_45_slash_coarse,
	},
	action_right_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_heavy_right",
		attack_direction_override = "right",
		damage_window_end = 0.5,
		damage_window_start = 0.35,
		first_person_hit_anim = "hit_right_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.25,
		special_active_hit_stop_anim = "attack_hit_power",
		total_time = 1.75,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_2",
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.1,
			},
			{
				modifier = 1.15,
				t = 0.15,
			},
			{
				modifier = 1.25,
				t = 0.25,
			},
			{
				modifier = 1.3,
				t = 0.35,
			},
			{
				modifier = 1.25,
				t = 0.45,
			},
			{
				modifier = 0.5,
				t = 0.47,
			},
			{
				modifier = 0.45,
				t = 0.6,
			},
			{
				modifier = 0.45,
				t = 0.65,
			},
			{
				modifier = 0.9,
				t = 0.8,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.4,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.75,
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.58,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.58,
				chain_until = 0.2,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.58,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = heavy_hitbox,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_power_maul/heavy_swing_right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_2h_heavy_tank,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.powermaul_2h_heavy_tank_active,
		weapon_special_tweak_data = {
			explosion_template = ExplosionTemplates.human_heavy_powermaul_activated_impact,
		},
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing_heavy,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		wounds_shape_special_active = wounds_shapes.horizontal_slash_coarse,
	},
	action_melee_start_left_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_left_down",
		anim_event_3p = "attack_swing_charge_left_down",
		chain_anim_event = "attack_swing_charge_left_down_pose",
		chain_anim_event_3p = "attack_swing_charge_left_down",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
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
				modifier = 0.68,
				t = 0.25,
			},
			{
				modifier = 0.65,
				t = 0.4,
			},
			{
				modifier = 0.65,
				t = 0.5,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.3,
				t = 1.2,
			},
			{
				modifier = 0.3,
				t = 3,
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
				action_name = "action_left_light",
				chain_time = 0.16,
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_weapon_special",
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
		attack_direction_override = "left",
		damage_window_end = 0.4,
		damage_window_start = 0.3,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.15,
		special_active_hit_stop_anim = "attack_hit_power",
		total_time = 2,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.21,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.65,
				t = 0.4,
			},
			{
				modifier = 0.6,
				t = 0.45,
			},
			{
				modifier = 0.5,
				t = 0.7,
			},
			{
				modifier = 1,
				t = 0.9,
			},
			{
				modifier = 1.05,
				t = 0.95,
			},
			{
				modifier = 1.04,
				t = 1.1,
			},
			{
				modifier = 1,
				t = 1.3,
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
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.53,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.52,
				chain_until = 0.2,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.55,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = light_hitbox,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_power_maul/swing_left_diagonal",
				anchor_point_offset = {
					0.3,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_2h_light_tank,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.powermaul_2h_light_tank_active,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing,
		wounds_shape = wounds_shapes.left_45_slash_coarse,
		wounds_shape_special_active = wounds_shapes.left_45_slash_coarse,
	},
	action_melee_start_right_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_right_pose",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
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
				modifier = 0.68,
				t = 0.25,
			},
			{
				modifier = 0.65,
				t = 0.4,
			},
			{
				modifier = 0.65,
				t = 0.5,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.3,
				t = 1.2,
			},
			{
				modifier = 0.3,
				t = 3,
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
				action_name = "action_right_light",
				chain_time = 0.13,
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
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_right",
		attack_direction_override = "right",
		damage_window_end = 0.5,
		damage_window_start = 0.38,
		first_person_hit_anim = "hit_right_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.15,
		special_active_hit_stop_anim = "attack_hit_power",
		total_time = 2,
		weapon_handling_template = "time_scale_1_1",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 1.15,
				t = 0.35,
			},
			{
				modifier = 0.65,
				t = 0.4,
			},
			{
				modifier = 0.6,
				t = 0.45,
			},
			{
				modifier = 0.6,
				t = 0.6,
			},
			{
				modifier = 0.9,
				t = 0.7,
			},
			{
				modifier = 0.95,
				t = 0.75,
			},
			{
				modifier = 0.94,
				t = 0.8,
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
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.67,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.52,
				chain_until = 0.2,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.6,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.4,
			0.15,
			1.3,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_power_maul/swing_right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_2h_light_tank,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.powermaul_2h_light_tank_active,
		herding_template = HerdingTemplates.thunder_hammer_right_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		wounds_shape_special_active = wounds_shapes.horizontal_slash_coarse,
	},
	action_block = {
		anim_end_event = "parry_finished",
		anim_event = "parry_pose",
		kind = "block",
		minimum_hold_time = 0.3,
		start_input = "block",
		stop_input = "block_release",
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
				chain_time = 0.15,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.68,
			},
		},
	},
	action_left_light_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_left_up",
		anim_event_3p = "attack_swing_heavy_left_diagonal_up",
		damage_window_end = 0.3,
		damage_window_start = 0.2,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.25,
		special_active_hit_stop_anim = "attack_hit_power",
		total_time = 2,
		weapon_handling_template = "time_scale_0_9",
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
				modifier = 0.55,
				t = 0.45,
			},
			{
				modifier = 0.7,
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
				action_name = "action_melee_start_right",
				chain_time = 0.3,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.35,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.35,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.4,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_power_maul/swing_left_up",
				anchor_point_offset = {
					-0.2,
					0,
					-0.2,
				},
			},
		},
		herding_template = HerdingTemplates.thunder_hammer_left_light,
		damage_profile = DamageProfileTemplates.powermaul_2h_light_pushfollow,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.powermaul_2h_light_pushfollow_active,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing,
		wounds_shape = wounds_shapes.right_45_slash_coarse,
		wounds_shape_special_active = wounds_shapes.right_45_slash_coarse,
	},
	action_push = {
		anim_event = "attack_push",
		block_duration = 0.5,
		kind = "push",
		push_radius = 2.75,
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
				action_name = "action_left_light_pushfollow",
				chain_time = 0.3,
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.3,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.3,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.35,
			},
		},
		inner_push_rad = math.pi * 0.35,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical,
		haptic_trigger_template = HapticTriggerTemplates.melee.push,
	},
	action_weapon_special = {
		activation_time = 0.3,
		allowed_during_sprint = true,
		anim_event = "activate",
		kind = "activate_special",
		skip_3p_anims = false,
		start_input = "special_action",
		total_time = 2.6,
		action_movement_curve = {
			{
				modifier = 0.9,
				t = 0.15,
			},
			{
				modifier = 0.8,
				t = 0.2,
			},
			{
				modifier = 0.7,
				t = 0.3,
			},
			{
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 0.75,
				t = 1.1,
			},
			{
				modifier = 1,
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
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.7,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
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
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/thunder_hammer"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/2h_power_maul"
weapon_template.weapon_box = {
	0.2,
	1,
	0.25,
}
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
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
	"power_maul_2h",
	"p1",
	"activated",
}
weapon_template.dodge_template = "hammer_2h"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "thunderhammer_2h_p1_m1"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.powermaul_2h
weapon_template.smart_targeting_template = SmartTargetingTemplates.tank
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.heavy
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.sprint_ready_up_time = 0.3
weapon_template.max_first_person_anim_movement_speed = 4.8
weapon_template.weapon_special_class = "WeaponSpecialExplodeOnImpact"
weapon_template.weapon_special_tweak_data = {
	active_duration = 4,
	active_on_abort = true,
	allow_reactivation_while_active = true,
	disorientation_type = "ogryn_powermaul_disorientation",
	keep_active_on_sprint = true,
	keep_active_on_stun = true,
	keep_active_on_vault = true,
	explosion_template = ExplosionTemplates.human_powermaul_activated_impact,
}
weapon_template.overclocks = {
	armor_pierce_up_dps_down = {
		thunderhammer_p1_m1_armor_pierce_stat = 0.1,
		thunderhammer_p1_m1_dps_stat = -0.1,
	},
	control_up_armor_pierce_down = {
		thunderhammer_p1_m1_armor_pierce_stat = -0.2,
		thunderhammer_p1_m1_control_stat = 0.2,
	},
	first_target_up_armor_pierce_down = {
		thunderhammer_p1_m1_armor_pierce_stat = -0.1,
		thunderhammer_p1_m1_first_target_stat = 0.1,
	},
	defence_up_first_target_down = {
		thunderhammer_p1_m1_defence_stat = 0.1,
		thunderhammer_p1_m1_first_target_stat = -0.1,
	},
	dps_up_defence_down = {
		thunderhammer_p1_m1_defence_stat = -0.1,
		thunderhammer_p1_m1_dps_stat = 0.1,
	},
}
weapon_template.base_stats = {
	powermaul_2h_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.thunderhammer_dps_stat,
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
				damage_trait_templates.thunderhammer_dps_stat,
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
			action_right_down_light = {
				damage_trait_templates.thunderhammer_dps_stat,
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_dps_stat,
			},
			action_left_light = {
				damage_trait_templates.thunderhammer_dps_stat,
			},
			action_right_light = {
				damage_trait_templates.thunderhammer_dps_stat,
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_dps_stat,
			},
		},
	},
	powermaul_2h_control_stat = {
		description = "loc_stats_display_control_stat_melee_mouseover",
		display_name = "loc_stats_display_control_stat_melee",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
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
					},
				},
			},
			action_right_down_light = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_left_light = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_right_light = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_control_stat,
			},
		},
		weapon_handling = {
			action_left_down_light = {
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
			action_right_down_light = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_right_heavy = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_right_light = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_left_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
		},
	},
	powermaul_2h_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.thunderhammer_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						armor_damage_modifier = {
							attack = {
								[armor_types.armored] = {},
								[armor_types.super_armor] = {},
							},
						},
					},
				},
			},
			action_left_heavy = {
				damage_trait_templates.thunderhammer_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						armor_damage_modifier = {
							attack = {
								[armor_types.armored] = {},
								[armor_types.super_armor] = {},
							},
						},
					},
				},
			},
			action_right_down_light = {
				damage_trait_templates.thunderhammer_armor_pierce_stat,
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_armor_pierce_stat,
			},
			action_left_light = {
				damage_trait_templates.thunderhammer_armor_pierce_stat,
			},
			action_right_light = {
				damage_trait_templates.thunderhammer_armor_pierce_stat,
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_armor_pierce_stat,
			},
		},
	},
	ogryn_powermaul_power_output_stat = {
		display_name = "loc_stats_display_power_output",
		is_stat_trait = true,
		explosion = {
			action_left_down_light = {
				overrides = {
					human_powermaul_activated_impact = {
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
					human_heavy_powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
			action_right_down_light = {
				overrides = {
					human_powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
			action_right_heavy = {
				overrides = {
					human_heavy_powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
			action_left_light = {
				overrides = {
					human_powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
			action_right_light = {
				overrides = {
					human_powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
			action_left_light_pushfollow = {
				overrides = {
					human_powermaul_activated_impact = {
						explosion_trait_templates.default_explosion_size_stat,
					},
				},
			},
		},
		damage = {
			action_left_down_light = {
				overrides = {
					powermaul_2h_light_tank_active = {
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
					powermaul_2h_heavy_smiter_active = {
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
			action_right_down_light = {
				overrides = {
					powermaul_2h_light_smiter_activate = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_heavy = {
				overrides = {
					powermaul_2h_heavy_tank_active = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_left_light = {
				overrides = {
					powermaul_2h_light_tank_active = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_left_light_pushfollow = {
				overrides = {
					powermaul_2h_light_tank_active = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_light = {
				overrides = {
					powermaul_2h_light_tank_active = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
		},
	},
	powermaul_2h_defence_stat = {
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
	},
}
weapon_template.traits = {}

local weapon_traits_bespoke_powermaul_2h_p1 = table.ukeys(WeaponTraitsBespokePowermaul2hP1)

table.append(weapon_template.traits, weapon_traits_bespoke_powermaul_2h_p1)

weapon_template.perks = {
	thunderhammer_p1_m1_dps_perk = {
		display_name = "loc_trait_display_thunderhammer_p1_m1_dps_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.thunderhammer_dps_perk,
			},
			action_left_heavy = {
				damage_trait_templates.thunderhammer_dps_perk,
			},
			action_right_down_light = {
				damage_trait_templates.thunderhammer_dps_perk,
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_dps_perk,
			},
			action_left_light = {
				damage_trait_templates.thunderhammer_dps_perk,
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_dps_perk,
			},
		},
	},
	thunderhammer_p1_m1_armor_pierce_perk = {
		display_name = "loc_trait_display_thunderhammer_p1_m1_armor_pierce_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.thunderhammer_armor_pierce_perk,
			},
			action_left_heavy = {
				damage_trait_templates.thunderhammer_armor_pierce_perk,
			},
			action_right_down_light = {
				damage_trait_templates.thunderhammer_armor_pierce_perk,
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_armor_pierce_perk,
			},
			action_left_light = {
				damage_trait_templates.thunderhammer_armor_pierce_perk,
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_armor_pierce_perk,
			},
		},
	},
	thunderhammer_p1_m1_control_perk = {
		display_name = "loc_trait_display_thunderhammer_p1_m1_control_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.thunderhammer_control_perk,
			},
			action_left_heavy = {
				damage_trait_templates.thunderhammer_control_perk,
			},
			action_right_down_light = {
				damage_trait_templates.thunderhammer_control_perk,
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_control_perk,
			},
			action_left_light = {
				damage_trait_templates.thunderhammer_control_perk,
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_control_perk,
			},
		},
		weapon_handling = {
			action_left_down_light = {
				weapon_handling_trait_templates.default_finesse_perk,
			},
			action_left_heavy = {
				weapon_handling_trait_templates.default_finesse_perk,
			},
			action_right_down_light = {
				weapon_handling_trait_templates.default_finesse_perk,
			},
			action_right_heavy = {
				weapon_handling_trait_templates.default_finesse_perk,
			},
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_perk,
			},
			action_left_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_perk,
			},
		},
	},
	thunderhammer_p1_m1_first_target_perk = {
		display_name = "loc_trait_display_thunderhammer_p1_m1_first_target_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_first_target_perk,
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_first_target_perk,
			},
			action_right_down_light = {
				damage_trait_templates.default_melee_first_target_perk,
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_first_target_perk,
			},
			action_left_light = {
				damage_trait_templates.default_melee_first_target_perk,
			},
			action_left_light_pushfollow = {
				damage_trait_templates.default_melee_first_target_perk,
			},
		},
	},
	thunderhammer_p1_m1_defence_perk = {
		display_name = "loc_trait_display_thunderhammer_p1_m1_defence_perk",
		stamina = {
			base = {
				stamina_trait_templates.thunderhammer_p1_m1_defence_perk,
			},
		},
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_perk,
			},
		},
	},
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_power_weapon",
	},
	{
		display_name = "loc_weapon_keyword_heavy_charge",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {
			"tank",
			"smiter",
			"tank",
			"tank",
		},
	},
	secondary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"tank",
		},
	},
	special = {
		desc = "loc_stats_special_action_powerup_desc",
		display_name = "loc_weapon_special_activate",
		type = "activate",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "light",
			icon = "tank",
			value_func = "primary_attack",
		},
		{
			header = "heavy",
			icon = "smiter",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "activate",
		icon = "activate",
	},
}

return weapon_template
