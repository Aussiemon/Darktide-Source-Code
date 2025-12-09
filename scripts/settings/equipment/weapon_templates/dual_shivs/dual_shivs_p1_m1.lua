-- chunkname: @scripts/settings/equipment/weapon_templates/dual_shivs/dual_shivs_p1_m1.lua

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
local MeleeActionInputSetupFast = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_fast")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeDualShivsP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_dual_shivs_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local armor_types = ArmorSettings.types
local attack_types = AttackSettings.attack_types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local wounds_shapes = WoundsSettings.shapes
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}
local action_inputs = table.clone(MeleeActionInputSetupFast.action_inputs)

weapon_template.action_inputs = action_inputs
weapon_template.action_inputs.special_action.buffer_time = 0.4
weapon_template.action_inputs.light_attack.input_sequence[1].time_window = 0.26
weapon_template.action_inputs.heavy_attack.input_sequence[1].duration = 0.26
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupFast.action_input_hierarchy)

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
		input = "block",
		transition = "base",
	},
}

ActionInputHierarchy.update_hierarchy_entry(weapon_template.action_input_hierarchy, "start_attack", new_start_attack_action_transition)
table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

local default_weapon_box = {
	0.1,
	0.1,
	1.25,
}
local large_weapon_box = {
	0.125,
	0.125,
	1.25,
}
local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3,
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

weapon_template.action_inputs.wield.buffer_time = 0.4

local action_movement_curves = {
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
			modifier = 0.7,
			t = 0.05,
		},
		{
			modifier = 0.65,
			t = 0.1,
		},
		{
			modifier = 0.6,
			t = 0.25,
		},
		{
			modifier = 0.8,
			t = 0.4,
		},
		{
			modifier = 1,
			t = 1,
		},
		start_modifier = 0.8,
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
			modifier = 1.3,
			t = 0.15,
		},
		{
			modifier = 1.2,
			t = 0.4,
		},
		{
			modifier = 0.85,
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
			modifier = 1.15,
			t = 0.15,
		},
		{
			modifier = 1.05,
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
		start_modifier = 1.1,
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
		total_time = 0.25,
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
				action_name = "action_start_1",
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_special_throw",
				chain_time = 0.24,
			},
		},
	},
	action_start_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down",
		first_person_hit_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "windup",
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = action_movement_curves.windup,
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
	action_start_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down",
		first_person_hit_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = action_movement_curves.windup,
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
				action_name = "action_heavy_1",
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
	action_start_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down",
		first_person_hit_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = action_movement_curves.windup,
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
	action_start_4 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down",
		first_person_hit_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = action_movement_curves.windup,
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
				action_name = "action_heavy_1",
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
	action_start_alt_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_up",
		first_person_hit_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = action_movement_curves.windup_slow,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_alt_1",
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.375,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_start_alt_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down",
		first_person_hit_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = action_movement_curves.windup,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_light_alt_2",
			},
			heavy_attack = {
				action_name = "action_heavy_1",
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
	action_light_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_left_diagonal_02",
		anim_event_3p = "attack_swing_left_diagonal",
		attack_direction_override = "left",
		damage_window_end = 0.25,
		damage_window_start = 0.18333333333333332,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.05,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_0_9_shivs",
		action_movement_curve = action_movement_curves.light_attack,
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
				action_name = "action_special_throw",
				chain_time = 0.35,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = large_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_shivs/attack_swing_left",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					0.15,
				},
			},
		},
		damage_profile = DamageProfileTemplates.dual_shivs_light_ninja,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_light_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_right_02",
		anim_event_3p = "attack_swing_right_02",
		attack_direction_override = "right",
		damage_window_end = 0.19166666666666668,
		damage_window_start = 0.13333333333333333,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_shivs",
		action_movement_curve = action_movement_curves.light_attack,
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
				chain_time = 0.325,
			},
			special_action = {
				action_name = "action_special_throw",
				chain_time = 0.33,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = large_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_shivs/attack_swing_right_v02",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.dual_shivs_light_ninja_stabby,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_light_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_right",
		attack_direction_override = "right",
		damage_window_end = 0.21666666666666667,
		damage_window_start = 0.14166666666666666,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_1_shivs",
		action_movement_curve = action_movement_curves.light_attack,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_start_4",
				chain_time = 0.475,
			},
			special_action = {
				action_name = "action_special_throw",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = large_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_shivs/attack_swing_right_lhand_offhand_sweep",
				reference_attachment_id = "left",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.dual_shivs_light_ninja,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_light_4 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_up_diagonal_02",
		anim_event_3p = "attack_swing_up_diagonal_02",
		attack_direction_override = "left",
		damage_window_end = 0.20833333333333334,
		damage_window_start = 0.15,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.05,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_shivs",
		action_movement_curve = action_movement_curves.light_attack,
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
				chain_time = 0.35,
			},
			special_action = {
				action_name = "action_special_throw",
				chain_time = 0.38,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = large_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_shivs/attack_swing_up_diagonal_lhand_offhand_sweep",
				reference_attachment_id = "left",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.dual_shivs_light_ninja_stabby,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_light_alt_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_stab_left_diagonal_lhand",
		anim_event_3p = "attack_swing_up_diagonal_02",
		attack_direction_override = "left",
		damage_window_end = 0.30833333333333335,
		damage_window_start = 0.225,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.05,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_shivs",
		action_movement_curve = action_movement_curves.light_attack,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_start_alt_2",
				chain_time = 0.35,
			},
			special_action = {
				action_name = "action_special_throw",
				chain_time = 0.375,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = large_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_shivs/attack_stab_left_diagonal_lhand_offhand_sweep",
				reference_attachment_id = "left",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.dual_shivs_light_ninja_stabby_plus,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_light_alt_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_left_diagonal",
		attack_direction_override = "left",
		damage_window_end = 0.3,
		damage_window_start = 0.21666666666666667,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		power_level = 550,
		range_mod = 1,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_0_9_shivs",
		action_movement_curve = action_movement_curves.light_attack_alt,
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
				chain_time = 0.3,
			},
			special_action = {
				action_name = "action_special_throw",
				chain_time = 0.25,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = large_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_shivs/attack_swing_left_diagonal_rhand",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.dual_shivs_light_ninja_stabby_plus,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_heavy_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_down",
		attack_direction_override = "down",
		damage_window_end = 0.16666666666666666,
		damage_window_start = 0.11666666666666667,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.08,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_2_shivs",
		action_movement_curve = action_movement_curves.heavy_attack_1,
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
				action_name = "action_start_alt_1",
				chain_time = 0.52,
			},
			special_action = {
				action_name = "action_special_throw",
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
		weapon_box = large_weapon_box,
		sweep_process_mode = ActionSweepSettings.multi_sweep_process_mode.shared,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_shivs/heavy_attack_swing_down",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0.05,
					0,
					0,
				},
			},
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_shivs/heavy_attack_swing_down_offhand_sweep",
				reference_attachment_id = "left",
				anchor_point_offset = {
					0.175,
					0.1,
					0,
					15,
				},
			},
		},
		damage_profile = DamageProfileTemplates.dual_shivs_heavy_double_stab,
		damage_type = damage_types.metal_slashing_medium,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_heavy_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_up",
		attack_direction_override = "push",
		damage_window_end = 0.13333333333333333,
		damage_window_start = 0.06666666666666667,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		power_level = 550,
		range_mod = 1.05,
		start_input = nil,
		sweep_trail_window_start = 100,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_shivs",
		action_movement_curve = action_movement_curves.heavy_attack_2,
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
				action_name = "action_start_1",
				chain_time = 0.35,
			},
			special_action = {
				action_name = "action_special_throw",
				chain_time = 0.35,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.35,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = large_weapon_box,
		sweep_process_mode = ActionSweepSettings.multi_sweep_process_mode.shared,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_shivs/heavy_attack_stab_fwd",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.dual_shivs_heavy_stab,
		damage_type = damage_types.metal_slashing_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_block = {
		anim_end_event = "parry_finished",
		anim_event = "parry_pose",
		kind = "block",
		minimum_hold_time = 0.2,
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
			special_action = {
				action_name = "action_special_throw",
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
				action_name = "action_pushfollow",
				chain_time = 0.3,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.3,
			},
			start_attack = {
				action_name = "action_start_1",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_special_throw",
				chain_time = 0.4,
			},
		},
		inner_push_rad = math.pi * 0.1,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.ninja_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical,
		haptic_trigger_template = HapticTriggerTemplates.melee.push,
	},
	action_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_followup",
		anim_event_3p = "attack_swing_right_02",
		attack_direction_override = "push",
		damage_window_end = 0.36666666666666664,
		damage_window_start = 0.25,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.05,
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_shivs",
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
				action_name = "action_start_alt_1",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_special_throw",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.125,
			0.125,
			1.25,
		},
		sweep_process_mode = ActionSweepSettings.multi_sweep_process_mode.shared,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/dual_shivs/attack_push_follow_up",
				reference_attachment_id = "right",
				anchor_point_offset = {
					0,
					0.1,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.dual_shivs_light_ninja_stabby_plus,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_special_throw = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "ability_knife_throw",
		anim_event_3p = "ability_knife_throw",
		fire_time = 0.2,
		kind = "weapon_throw",
		projectile_item = "content/items/weapons/player/shivs_throwing_knives",
		sprint_requires_press_to_interrupt = false,
		start_input = "special_action",
		total_time = 0.5,
		weapon_handling_template = "time_scale_1_shivs",
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = action_movement_curves.light_attack,
		allowed_chain_actions = {
			block = {
				action_name = "action_block",
				chain_time = 0.3,
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		projectile_template = ProjectileTemplates.dual_shivs_p1_throwing_knives,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input)
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/dual_shivs"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/dual_shivs"
weapon_template.weapon_box = {
	0.15,
	0.65,
	0.15,
}
weapon_template.hud_configuration = {
	hud_ammo_icon = "content/ui/materials/icons/throwables/hud/zealot_throwing_knives_ammo_counter",
	uses_ammunition = true,
	uses_overheat = false,
	uses_weapon_special_charges = true,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.damage_window_start_sweep_trail_offset = -0.2
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "dual_shivs_p1_m1"
weapon_template.fx_sources = {
	_block = "fx_block",
	_sweep = "fx_sweep",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.buffs = {
	on_equip = {
		"dual_shivs_p1_throwing_knives_poison",
		"dual_shivs_regain_weapon_special_charges_on_backstab_kill",
	},
}
weapon_template.keywords = {
	"melee",
	"dual_shivs",
	"p1",
}
weapon_template.dodge_template = "ninja_knife"
weapon_template.sprint_template = "ninja_2"
weapon_template.stamina_template = "dual_shivs_p1"
weapon_template.toughness_template = "assault"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.combat_knife
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.light

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	dual_shivs_p1_m1_dps_stat = {
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
			action_light_4 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_alt_1 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_alt_2 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	dual_shivs_p1_m1_armor_pierce_stat = {
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
			action_light_4 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_alt_1 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_alt_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat,
			},
		},
	},
	dual_shivs_p1_m1_finesse_stat = {
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
			action_light_4 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_alt_1 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_alt_2 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_melee_finesse_stat,
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
			action_heavy_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_3 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_4 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_alt_1 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_alt_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
		},
	},
	dual_shivs_p1_m1_first_target_stat = {
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
			action_heavy_2 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_3 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_alt_1 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_alt_2 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_first_target_stat,
			},
		},
	},
	dual_shivs_p1_m1_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
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
weapon_template.weapon_special_class = "WeaponSpecialKillCountCharges"
weapon_template.weapon_special_tweak_data = {
	default_num_charges_to_add = 0,
	initial_charges = 3,
	keep_active_on_unwield = true,
	max_charges = 3,
	num_charges_to_consume_on_activation = 1,
	breed_tag_charges = {
		captain = 3,
		elite = 1,
		monster = 3,
		ogryn = 1,
		special = 1,
	},
}
weapon_template.traits = {}

local weapon_traits_bespoke_dual_shivs_p1 = table.ukeys(WeaponTraitsBespokeDualShivsP1)

table.append(weapon_template.traits, weapon_traits_bespoke_dual_shivs_p1)

weapon_template.displayed_keywords = {
	{
		description = "loc_weapon_stats_display_very_fast_attack_desc",
		display_name = "loc_weapon_keyword_very_fast_attack",
	},
	{
		description = "loc_weapon_stats_display_ninja_fencer_desc",
		display_name = "loc_weapon_keyword_ninja_fencer",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_ninja_fencer",
		type = "ninja_fencer",
		attack_chain = {
			"ninja_fencer",
			"ninja_fencer",
			"ninja_fencer",
			"ninja_fencer",
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
		desc = "loc_stats_special_action_throw_poison_dual_shivs_p1_desc",
		display_name = "loc_weapon_special_action_throw",
		type = "special_attack",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "light",
			icon = "ninja_fencer",
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
weapon_template.special_action_name = "action_special_throw"

return weapon_template
