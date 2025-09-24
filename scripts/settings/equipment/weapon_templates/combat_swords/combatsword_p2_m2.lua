-- chunkname: @scripts/settings/equipment/weapon_templates/combat_swords/combatsword_p2_m2.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MeleeActionInputSetupMid = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_mid")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeCombatswordP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p2")
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
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_template = {}
local action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs)

action_inputs.parry = {
	buffer_time = 0,
}

local action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)

action_input_hierarchy[#action_input_hierarchy + 1] = {
	input = "parry",
	transition = "base",
}

local new_special_action_transition = {
	{
		input = "attack_cancel",
		transition = "base",
	},
	{
		input = "start_attack",
		transition = {
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
	{
		input = "special_action",
		transition = "base",
	},
}

ActionInputHierarchy.update_hierarchy_entry(action_input_hierarchy, "special_action", new_special_action_transition)

weapon_template.action_inputs = action_inputs
weapon_template.action_input_hierarchy = action_input_hierarchy

local default_weapon_box = {
	0.1,
	0.1,
	1.1,
}
local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3,
}
local hit_zone_priority_tank = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3,
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)
table.add_missing(hit_zone_priority_tank, default_hit_zone_priority)

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
			special_action = {
				action_name = "action_attack_special",
			},
		},
	},
	action_melee_start_left = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left",
		anim_event_3p = "attack_swing_charge_up_left",
		kind = "windup",
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05,
			},
			{
				modifier = 0.7,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.25,
			},
			{
				modifier = 0.85,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.835,
				t = 0.55,
			},
			{
				modifier = 0.95,
				t = 3,
			},
			start_modifier = 0.75,
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
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_attack_special",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_diagonal_down",
		anim_event_3p = "attack_swing_left_diagonal",
		damage_window_end = 0.4,
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.2,
			},
			{
				modifier = 0.6,
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
			start_modifier = 0.7,
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
				chain_time = 0.52,
			},
			block = {
				action_name = "action_block",
				chain_time = 0,
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.48,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_sword/swing_left_diagonal",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_combatsword_linesman_p2,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.left_45_slash_clean,
	},
	action_left_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_up",
		anim_event_3p = "attack_swing_heavy_up_left",
		attack_direction_override = "push",
		damage_window_end = 0.23333333333333334,
		damage_window_start = 0.1,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 1,
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
				chain_time = 0.54,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
				chain_until = 0.1,
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_sword/heavy_swing_left_up",
				anchor_point_offset = {
					0,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_combatsword_p2_smiter_up,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.right_45_slash_clean,
	},
	action_melee_start_right = {
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_right",
		anim_event_3p = "attack_swing_charge_down_right",
		hit_stop_anim = "attack_hit",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05,
			},
			{
				modifier = 0.7,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.25,
			},
			{
				modifier = 0.85,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.835,
				t = 0.55,
			},
			{
				modifier = 0.95,
				t = 3,
			},
			start_modifier = 0.75,
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
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.54,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_attack_special",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right",
		anim_event_3p = "attack_swing_heavy_right",
		damage_window_end = 0.43333333333333335,
		damage_window_start = 0.3333333333333333,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.25,
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
				action_name = "action_melee_start_left_2",
				chain_time = 0.42,
			},
			block = {
				action_name = "action_block",
				chain_time = 0,
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority_tank,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_sword/swing_right",
				anchor_point_offset = {
					0,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_combatsword_linesman_tank_p2,
		damage_type = damage_types.metal_slashing_light,
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 0.5,
			[armor_types.super_armor] = 0.1,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean,
	},
	action_right_heavy = {
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_down_right",
		anim_event_3p = "attack_swing_heavy_down_right",
		damage_window_end = 0.3,
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 1,
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
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.3,
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
				chain_until = 0.05,
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.55,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_sword/heavy_swing_down_right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_combatsword_p2_smiter,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.right_45_slash_clean,
	},
	action_melee_start_left_2 = {
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left",
		anim_event_3p = "attack_swing_charge_up_left",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05,
			},
			{
				modifier = 0.7,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.25,
			},
			{
				modifier = 0.85,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.835,
				t = 0.55,
			},
			{
				modifier = 0.95,
				t = 3,
			},
			start_modifier = 0.75,
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
				action_name = "action_left_light_2",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.56,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_light_2 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_left",
		anim_event_3p = "attack_swing_left",
		damage_window_end = 0.43333333333333335,
		damage_window_start = 0.3333333333333333,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.25,
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
				chain_time = 0.52,
			},
			block = {
				action_name = "action_block",
				chain_time = 0,
			},
			special_action = {
				action_name = "action_attack_special",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority_tank,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_sword/swing_left",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_combatsword_linesman_tank_p2,
		damage_type = damage_types.metal_slashing_light,
		action_armor_hit_mass_mod = {
			[armor_types.armored] = 0.25,
			[armor_types.super_armor] = 0.1,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean,
	},
	action_melee_start_right_2 = {
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_right",
		anim_event_3p = "attack_swing_charge_down_right",
		hit_stop_anim = "attack_hit",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05,
			},
			{
				modifier = 0.7,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.25,
			},
			{
				modifier = 0.85,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.835,
				t = 0.55,
			},
			{
				modifier = 0.95,
				t = 3,
			},
			start_modifier = 0.75,
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
				action_name = "action_right_light_2",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.54,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_attack_special",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_light_2 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_right_diagonal_down",
		anim_event_3p = "attack_swing_right_diagonal",
		damage_window_end = 0.5,
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.25,
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
				action_name = "action_melee_start_left",
				chain_time = 0.73,
			},
			block = {
				action_name = "action_block",
				chain_time = 0,
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.45,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_sword/swing_right_diagonal",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_combatsword_linesman_p2,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.right_45_slash_clean,
	},
	action_block = {
		anim_end_event = "parry_finished",
		anim_event = "parry_pose",
		kind = "block",
		start_input = "block",
		stop_input = "block_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.2,
			},
			{
				modifier = 0.82,
				t = 0.3,
			},
			{
				modifier = 0.8,
				t = 0.325,
			},
			{
				modifier = 0.81,
				t = 0.35,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.85,
				t = 1,
			},
			{
				modifier = 0.8,
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
			special_action = {
				action_name = "action_attack_special",
			},
		},
	},
	action_attack_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special_right_diagonal_down",
		anim_event_3p = "attack_swing_right_diagonal",
		attack_direction_override = "push",
		damage_window_end = 0.7666666666666667,
		damage_window_start = 0.6,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		power_level = 500,
		range_mod = 1.25,
		start_input = "special_action",
		total_time = 1.25,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15,
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
				action_name = "action_melee_start_special",
				chain_time = 0.8,
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 1.2,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.7,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		herding_template = HerdingTemplates.punch,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_sword/attack_special_right_diagonal_down",
				anchor_point_offset = {
					0,
					0,
					-0.25,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_combatsword_p2_special,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.right_45_slash_clean,
	},
	action_melee_start_special = {
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left",
		anim_event_3p = "attack_swing_charge_up_left",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05,
			},
			{
				modifier = 0.7,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.25,
			},
			{
				modifier = 0.85,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.835,
				t = 0.55,
			},
			{
				modifier = 0.95,
				t = 3,
			},
			start_modifier = 0.75,
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
				action_name = "action_attack_special_2",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_attack_special_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special_left",
		anim_event_3p = "attack_swing_left",
		attack_direction_override = "left",
		damage_window_end = 0.3,
		damage_window_start = 0.18,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		power_level = 500,
		range_mod = 1.25,
		total_time = 1.22,
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
				modifier = 0.45,
				t = 0.55,
			},
			{
				modifier = 0.55,
				t = 0.6,
			},
			{
				modifier = 0.7,
				t = 0.8,
			},
			{
				modifier = 0.975,
				t = 0.85,
			},
			{
				modifier = 1,
				t = 1.1,
			},
			start_modifier = 1.2,
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
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.65,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_sword/attack_special_left",
				anchor_point_offset = {
					0,
					0,
					-0.2,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_combatsword_linesman,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean,
	},
	action_right_light_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_stab",
		anim_event_3p = "attack_swing_stab",
		attack_direction_override = "push",
		damage_window_end = 0.36666666666666664,
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.2,
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
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_sword/swing_stab_01",
				anchor_point_offset = {
					0.1,
					-0.1,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_combatsword_smiter_stab,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.default,
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			push_follow_up = {
				action_name = "action_right_light_pushfollow",
				chain_time = 0.25,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.3,
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.25,
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.25,
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/power_sword"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/combat_sword"
weapon_template.weapon_box = {
	0.1,
	0.7,
	0.02,
}
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.3
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_sweep = "fx_sweep",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"combat_sword",
	"p2",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "chainsword_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.heavy
weapon_template.overclocks = {
	cleave_damage_up_dps_down = {
		combatsword_p1_m1_cleave_damage_stat = 0.1,
		combatsword_p1_m1_dps_stat = -0.1,
	},
	finesse_up_cleave_damage_down = {
		combatsword_p1_m1_cleave_damage_stat = -0.2,
		combatsword_p1_m1_finesse_stat = 0.2,
	},
	cleave_targets_up_cleave_damage_down = {
		combatsword_p1_m1_cleave_damage_stat = -0.1,
		combatsword_p1_m1_cleave_targets_stat = 0.1,
	},
	mobility_up_cleave_targets_down = {
		combatsword_p1_m1_cleave_targets_stat = -0.1,
		combatsword_p1_m1_mobility_stat = 0.1,
	},
	dps_up_mobility_down = {
		combatsword_p1_m1_dps_stat = 0.1,
		combatsword_p1_m1_mobility_stat = -0.1,
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	combatsword_p2_m2_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.combatsword_dps_stat,
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
				damage_trait_templates.combatsword_dps_stat,
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
				damage_trait_templates.combatsword_dps_stat,
			},
			action_right_heavy = {
				damage_trait_templates.combatsword_dps_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.combatsword_dps_stat,
			},
			action_attack_special = {
				damage_trait_templates.combatsword_dps_stat,
			},
			action_attack_special_2 = {
				damage_trait_templates.combatsword_dps_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.combatsword_dps_stat,
			},
			action_right_light_2 = {
				damage_trait_templates.combatsword_dps_stat,
			},
		},
	},
	combatsword_p2_m2_cleave_damage_stat = {
		display_name = "loc_stats_display_cleave_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.combatsword_cleave_damage_stat,
				display_data = {
					display_stats = {
						armor_damage_modifier = {
							attack = {
								[armor_types.armored] = {
									display_name = "loc_weapon_stats_display_cleave_armored",
								},
								[armor_types.unarmored] = {
									display_name = "loc_weapon_stats_display_cleave_unarmored",
								},
								[armor_types.disgustingly_resilient] = {
									display_name = "loc_weapon_stats_display_cleave_disgustingly_resilient",
								},
							},
						},
					},
				},
			},
			action_left_heavy = {
				damage_trait_templates.combatsword_cleave_damage_stat,
			},
			action_right_light = {
				damage_trait_templates.combatsword_cleave_damage_stat,
			},
			action_right_heavy = {
				damage_trait_templates.combatsword_cleave_damage_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.combatsword_cleave_damage_stat,
			},
			action_attack_special = {
				damage_trait_templates.combatsword_cleave_damage_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.combatsword_cleave_damage_stat,
			},
			action_right_light_2 = {
				damage_trait_templates.combatsword_cleave_damage_stat,
			},
		},
	},
	combatsword_p2_m2_first_target_stat = {
		display_name = "loc_stats_display_first_target_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
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
			action_left_heavy = {
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
			action_right_light = {
				damage_trait_templates.default_first_target_stat,
			},
			action_right_heavy = {
				damage_trait_templates.default_first_target_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_attack_special = {
				damage_trait_templates.default_first_target_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_first_target_stat,
			},
			action_right_light_2 = {
				damage_trait_templates.default_first_target_stat,
			},
		},
	},
	combatsword_p2_m2_cleave_targets_stat = {
		display_name = "loc_stats_display_cleave_targets_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.combatsword_cleave_targets_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_left_heavy = {
				damage_trait_templates.combatsword_cleave_targets_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_right_light = {
				damage_trait_templates.combatsword_cleave_targets_stat,
			},
			action_right_heavy = {
				damage_trait_templates.combatsword_cleave_targets_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.combatsword_cleave_targets_stat,
			},
			action_attack_special = {
				damage_trait_templates.combatsword_cleave_targets_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.combatsword_cleave_targets_stat,
			},
			action_right_light_2 = {
				damage_trait_templates.combatsword_cleave_targets_stat,
			},
		},
	},
	combatsword_p2_m2_defence_stat = {
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

local bespoke_combatsword_p2_traits = table.ukeys(WeaponTraitsBespokeCombatswordP2)

table.append(weapon_template.traits, bespoke_combatsword_p2_traits)

weapon_template.displayed_keywords = {
	{
		description = "loc_weapon_stats_display_high_cleave_desc",
		display_name = "loc_weapon_keyword_high_cleave",
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
			"tank",
			"tank",
			"linesman",
		},
	},
	secondary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"smiter",
		},
	},
	special = {
		desc = "loc_stats_special_action_special_attack_combatsword_p2m1_desc",
		display_name = "loc_weapon_special_special_attack",
		type = "special_attack",
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
			icon = "smiter",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "special_attack",
		icon = "special_attack",
	},
}
weapon_template.special_action_name = "action_attack_special"

return weapon_template
