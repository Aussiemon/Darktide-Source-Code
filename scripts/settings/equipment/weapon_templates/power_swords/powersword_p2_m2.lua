-- chunkname: @scripts/settings/equipment/weapon_templates/power_swords/powersword_p2_m2.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MeleeActionInputSetupMid = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_mid")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokePowerswordP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powersword_p2")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local hit_zone_names = HitZone.hit_zone_names
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local wounds_shapes = WoundsSettings.shapes
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local toughness_trait_templates = WeaponTraitTemplates[template_types.toughness]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local charge_trait_templates = WeaponTraitTemplates[template_types.charge]
local weapon_template = {}

weapon_template.action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs)
weapon_template.action_inputs.special_action.buffer_time = 0.5
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)

local default_weapon_box = {
	0.1,
	0.075,
	1.15,
}

weapon_template.allowed_inputs_in_sprint = {
	combat_ability = true,
	special_action = true,
	start_attack = true,
	wield = true,
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
		anim_event = "equip_p2",
		anim_event_3p = "equip",
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
				action_name = "action_activate_special_left",
			},
		},
	},
	action_melee_start_left = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_left_diagonal",
		anim_event_3p = "attack_swing_charge_left",
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
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special_left",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_down_left",
		anim_event_3p = "attack_swing_left_diagonal",
		damage_window_end = 0.5,
		damage_window_start = 0.425,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.15,
		total_time = 2,
		weapon_handling_template = "time_scale_1_1",
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
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
				chain_until = 0.05,
			},
			special_action = {
				action_name = "action_activate_special_right",
				chain_time = 0.5,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/swing_down_left",
			anchor_point_offset = {
				0.12,
				0,
				0.15,
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_smiter_p2,
		damage_profile_special_active = DamageProfileTemplates.light_sword_smiter_active_p2,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword_p2,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_clean,
		wounds_shape_special_active = wounds_shapes.vertical_slash,
	},
	action_left_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_heavy_left_diagonal",
		anim_event_3p = "attack_swing_heavy_left",
		attack_direction_override = "left",
		damage_window_end = 0.2833333333333333,
		damage_window_start = 0.18333333333333332,
		first_person_hit_anim = "hit_left_down_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		no_hit_stop_on_active = true,
		range_mod = 1.3,
		total_time = 1,
		weapon_handling_template = "time_scale_0_9",
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
				chain_time = 0.3,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.3,
				chain_until = 0.1,
			},
			special_action = {
				action_name = "action_activate_special_right",
				chain_time = 0.3,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.25,
			0.125,
			1.15,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/heavy_swing_left_diagonal",
			anchor_point_offset = {
				0,
				0,
				-0.35,
			},
		},
		damage_profile = DamageProfileTemplates.heavy_sword_tank_p2,
		damage_profile_special_active = DamageProfileTemplates.heavy_sword_tank_active_p2,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword_p2,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean,
		wounds_shape_special_active = wounds_shapes.horizontal_slash,
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_right_diagonal_up",
		anim_event_3p = "attack_swing_charge_up_right",
		kind = "windup",
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
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special_right",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_right_01",
		anim_event_3p = "attack_swing_right",
		damage_window_end = 0.4,
		damage_window_start = 0.31666666666666665,
		first_person_hit_anim = "hit_right_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.27,
		total_time = 2,
		weapon_handling_template = "time_scale_0_9",
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
				chain_time = 0.57,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
				chain_until = 0.25,
			},
			special_action = {
				action_name = "action_activate_special_left_2",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.25,
			0.125,
			1.15,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/swing_right",
			anchor_point_offset = {
				0,
				0,
				-0.05,
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_tank_p2,
		damage_profile_special_active = DamageProfileTemplates.light_sword_tank_active_p2,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword_p2,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean,
		wounds_shape_special_active = wounds_shapes.horizontal_slash,
	},
	action_right_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_heavy_right_up",
		anim_event_3p = "attack_swing_heavy_up_right",
		attack_direction_override = "up",
		damage_window_end = 0.4666666666666667,
		damage_window_start = 0.36666666666666664,
		first_person_hit_anim = "hit_right_up_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		power_level = 550,
		range_mod = 1.25,
		total_time = 1,
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
				action_name = "action_melee_start_left",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.35,
				chain_until = 0.05,
			},
			special_action = {
				action_name = "action_activate_special_left",
				chain_time = 0.35,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/heavy_swing_right_up",
			anchor_point_offset = {
				0.1,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.heavy_sword_smiter_p2,
		damage_profile_special_active = DamageProfileTemplates.heavy_sword_smiter_active_p2,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword_p2,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.left_45_slash_clean,
		wounds_shape_special_active = wounds_shapes.left_45_slash,
	},
	action_melee_start_left_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_left_diagonal",
		anim_event_3p = "attack_swing_charge_left",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
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
				action_name = "action_activate_special_left_2",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_light_2 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_left",
		damage_window_end = 0.4166666666666667,
		damage_window_start = 0.3333333333333333,
		first_person_hit_anim = "hit_left_down_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.28,
		total_time = 2,
		weapon_handling_template = "time_scale_0_9",
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
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.56,
			},
			block = {
				action_name = "action_block",
				chain_time = 0,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			special_action = {
				action_name = "action_activate_special_right_2",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.25,
			0.125,
			1.15,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/swing_left",
			anchor_point_offset = {
				0,
				0,
				-0.1,
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_tank_p2,
		damage_profile_special_active = DamageProfileTemplates.light_sword_tank_active_p2,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword_p2,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean,
		wounds_shape_special_active = wounds_shapes.horizontal_slash,
	},
	action_melee_start_right_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_right",
		anim_event_3p = "attack_swing_charge_right",
		hit_stop_anim = "attack_hit",
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
				action_name = "action_activate_special_right",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_light_2 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_up_right",
		anim_event_3p = "attack_swing_right_diagonal",
		damage_window_end = 0.3333333333333333,
		damage_window_start = 0.26666666666666666,
		first_person_hit_anim = "hit_down_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		power_level = 650,
		range_mod = 1.2,
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
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
				chain_until = 0.25,
			},
			special_action = {
				action_name = "action_activate_special_left",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.35,
			0.125,
			1.15,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/swing_right_up",
			anchor_point_offset = {
				0.2,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_p2,
		damage_profile_special_active = DamageProfileTemplates.light_sword_active_p2,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword_p2,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.left_45_slash_clean,
		wounds_shape_special_active = wounds_shapes.left_45_slash,
	},
	action_block = {
		anim_end_event = "parry_finished",
		anim_event = "parry_pose",
		kind = "block",
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
			special_action = {
				action_name = "action_activate_special_right",
			},
		},
	},
	action_push = {
		anim_event = "attack_push",
		block_duration = 0.5,
		kind = "push",
		push_radius = 2.5,
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
				action_name = "action_melee_start_push_combo",
				chain_time = 0.35,
			},
			push_follow_up = {
				action_name = "action_right_light_pushfollow",
				chain_time = 0.25,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_activate_special_right_push",
				chain_time = 0.4,
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
	action_right_light_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_right_01",
		anim_event_3p = "attack_swing_right",
		damage_window_end = 0.4083333333333333,
		damage_window_start = 0.325,
		first_person_hit_anim = "hit_up_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 1,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.15,
			},
			{
				modifier = 1.15,
				t = 0.28,
			},
			{
				modifier = 0.45,
				t = 0.32,
			},
			{
				modifier = 0.6,
				t = 0.46,
			},
			{
				modifier = 1,
				t = 0.7,
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
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.43,
			},
			special_action = {
				action_name = "action_activate_special_left_2",
				chain_time = 0.43,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/swing_right",
			anchor_point_offset = {
				0.22,
				0,
				-0.05,
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_tank_p2,
		damage_profile_special_active = DamageProfileTemplates.light_sword_tank_active_p2,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword_p2,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean,
		wounds_shape_special_active = wounds_shapes.horizontal_slash,
	},
	action_melee_start_push_combo = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_right_diagonal_up",
		anim_event_3p = "attack_swing_charge_up_right",
		kind = "windup",
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
				action_name = "action_right_light_push_combo",
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special_right_push",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_light_push_combo = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_down_right",
		anim_event_3p = "attack_swing_right_diagonal",
		damage_window_end = 0.4,
		damage_window_start = 0.3,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		weapon_handling_template = "time_scale_1_1",
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
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
				chain_until = 0.05,
			},
			special_action = {
				action_name = "action_activate_special_left",
				chain_time = 0.5,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.1,
			0.075,
			1.25,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/swing_down_right",
			anchor_point_offset = {
				0,
				0,
				-0.05,
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_smiter_p2,
		damage_profile_special_active = DamageProfileTemplates.light_sword_smiter_active_p2,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword_p2,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_clean,
		wounds_shape_special_active = wounds_shapes.vertical_slash,
	},
	action_activate_special_left = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activate_anim_event = "activate_p2",
		activate_anim_event_3p = "activate",
		activation_time = 0.35,
		allowed_during_sprint = true,
		block_duration = 0.6,
		deactivate_anim_event = "activate_p2",
		deactivate_anim_event_3p = "activate",
		deactivation_time = 0.37,
		kind = "toggle_special_with_block",
		skip_3p_anims = false,
		start_input = "special_action",
		total_time = 1.25,
		total_time_deactivate = 1.25,
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
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_activate_special_left",
				chain_time = 0.6,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.overheat_state ~= "lockout"
		end,
	},
	action_activate_special_right = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activate_anim_event = "activate_right_p2",
		activate_anim_event_3p = "activate",
		activation_time = 0.35,
		allowed_during_sprint = true,
		block_duration = 0.6,
		deactivate_anim_event = "activate_right_p2",
		deactivate_anim_event_3p = "activate",
		deactivation_time = 0.37,
		kind = "toggle_special_with_block",
		skip_3p_anims = false,
		total_time = 1.25,
		total_time_deactivate = 1.25,
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
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_activate_special_right",
				chain_time = 0.6,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.overheat_state ~= "lockout"
		end,
	},
	action_activate_special_left_2 = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activate_anim_event = "activate_p2",
		activate_anim_event_3p = "activate",
		activation_time = 0.35,
		allowed_during_sprint = true,
		block_duration = 0.6,
		deactivate_anim_event = "activate_p2",
		deactivate_anim_event_3p = "activate",
		deactivation_time = 0.37,
		kind = "toggle_special_with_block",
		skip_3p_anims = false,
		total_time = 1.25,
		total_time_deactivate = 1.25,
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
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_activate_special_left_2",
				chain_time = 0.6,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.overheat_state ~= "lockout"
		end,
	},
	action_activate_special_right_2 = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activate_anim_event = "activate_right_p2",
		activate_anim_event_3p = "activate",
		activation_time = 0.35,
		allowed_during_sprint = true,
		block_duration = 0.6,
		deactivate_anim_event = "activate_right_p2",
		deactivate_anim_event_3p = "activate",
		deactivation_time = 0.37,
		kind = "toggle_special_with_block",
		skip_3p_anims = false,
		total_time = 1.25,
		total_time_deactivate = 1.25,
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
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_activate_special_right_2",
				chain_time = 0.6,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.overheat_state ~= "lockout"
		end,
	},
	action_activate_special_right_push = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activate_anim_event = "activate_right_p2",
		activate_anim_event_3p = "activate",
		activation_time = 0.35,
		allowed_during_sprint = true,
		block_duration = 0.6,
		deactivate_anim_event = "activate_right_p2",
		deactivate_anim_event_3p = "activate",
		deactivation_time = 0.37,
		kind = "toggle_special_with_block",
		skip_3p_anims = false,
		total_time = 1.25,
		total_time_deactivate = 1.25,
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
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_push_combo",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_activate_special_right_push",
				chain_time = 0.6,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.overheat_state ~= "lockout"
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
		weapon_handling_template = "time_scale_1",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/power_sword"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/power_sword"
weapon_template.weapon_box = {
	0.1,
	0.7,
	0.02,
}
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.15
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.special_charge_template = "powersword_p2_m1_weapon_special"
weapon_template.use_special_charge_template_for_overheat_decay = true
weapon_template.weapon_special_class = "WeaponSpecialCharging"
weapon_template.weapon_special_tweak_data = {
	keep_active_on_sprint = true,
	keep_active_on_stun = true,
	keep_active_on_vault = true,
}
weapon_template.overheat_configuration = {
	explode_at_high_overheat = false,
	lockout_enabled = true,
	overheat_icon_text = "",
	overheat_lockout_icon_text = "",
	fx = {
		looping_sound_parameter_name = "overheat_plasma_gun",
		on_screen_cloud_name = "plasma",
		on_screen_effect = "content/fx/particles/screenspace/screen_plasma_rifle_warning",
		on_screen_variable_name = "plasma_radius",
		sfx_source_name = "_overheat",
		vfx_source_name = "_overheat",
	},
}
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_block",
	_special_active = "fx_blade",
	_sweep = "fx_sweep",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.weapon_counter = {
	show_when_unwielded = false,
	weapon_counter_type = "overheat_lockout",
}
weapon_template.keywords = {
	"melee",
	"power_sword",
	"p2",
	"activated",
}
weapon_template.dodge_template = "smiter_plus"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "chainsword_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.medium
weapon_template.overclocks = {
	cleave_damage_up_dps_down = {
		powersword_p2_m1_cleave_damage_stat = 0.1,
		powersword_p2_m1_dps_stat = -0.1,
	},
	finesse_up_cleave_damage_down = {
		powersword_p2_m1_cleave_damage_stat = -0.2,
		powersword_p2_m1_finesse_stat = 0.2,
	},
	cleave_targets_up_cleave_damage_down = {
		powersword_p2_m1_cleave_damage_stat = -0.1,
		powersword_p2_m1_cleave_targets_stat = 0.1,
	},
	mobility_up_cleave_targets_down = {
		powersword_p1_m1_cleave_targets_stat = -0.1,
		powersword_p2_m1_mobility_stat = 0.1,
	},
	dps_up_mobility_down = {
		powersword_p2_m1_dps_stat = 0.1,
		powersword_p2_m1_mobility_stat = -0.1,
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	powersword_p2_m2_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
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
			action_left_heavy = {
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
			action_right_light = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_right_heavy = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_right_light_2 = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_right_light_push_combo = {
				damage_trait_templates.powersword_dps_stat,
			},
		},
	},
	powersword_p2_m2_power_output_stat = {
		display_name = "loc_stats_display_power_output",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				overrides = {
					light_sword_smiter_active_p2 = {
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
					heavy_sword_active_p2 = {
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
					light_sword_active_p2 = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_heavy = {
				overrides = {
					heavy_sword_smiter_active_p2 = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_left_light_2 = {
				overrides = {
					light_sword_active_p2 = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_light_2 = {
				overrides = {
					light_sword_active_p2 = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_light_pushfollow = {
				overrides = {
					light_sword_active_p2 = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_light_push_combo = {
				overrides = {
					light_sword_smiter_active_p2 = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
		},
	},
	powersword_p2_m2_heat_stat = {
		display_name = "loc_stats_display_heat_management_powersword_2h",
		is_stat_trait = true,
		charge = {
			base_special = {
				charge_trait_templates.powersword_p2_heat_stat,
				display_data = {
					display_stats = {
						overheat_overtime = {
							overheat_percent = {},
						},
						overheat_swing = {
							overheat_percent = {},
						},
						overheat_decay = {
							auto_vent_duration = {},
						},
					},
				},
			},
		},
	},
	powersword_p2_m2_finesse_stat = {
		display_name = "loc_stats_display_finesse_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
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
				overrides = {
					light_sword_smiter_active_p2 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_left_heavy = {
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
				overrides = {
					heavy_sword_active_p2 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_right_light = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					light_sword_active_p2 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_right_heavy = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					heavy_sword_smiter_active_p2 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_left_light_2 = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					light_sword_active_p2 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_right_light_2 = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					light_sword_active_p2 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_right_light_pushfollow = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					light_sword_active_p2 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
			},
			action_right_light_push_combo = {
				damage_trait_templates.powersword_finesse_stat,
				overrides = {
					light_sword_smiter_active_p2 = {
						damage_trait_templates.powersword_finesse_stat,
					},
				},
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
			action_right_light_push_combo = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
		},
	},
	powersword_p2_m2_mobility_stat = {
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
weapon_template.traits = {}

local bespoke_powersword_p2_traits = table.ukeys(WeaponTraitsBespokePowerswordP2)

table.append(weapon_template.traits, bespoke_powersword_p2_traits)

weapon_template.displayed_keywords = {
	{
		description = "loc_weapon_stats_display_high_cleave_desc",
		display_name = "loc_weapon_keyword_high_cleave",
	},
	{
		display_name = "loc_weapon_keyword_power_weapon",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_tank",
		type = "linesman",
		attack_chain = {
			"smiter",
			"tank",
			"tank",
			"linesman",
		},
	},
	secondary = {
		display_name = "loc_gestalt_tank",
		type = "linesman",
		attack_chain = {
			"tank",
			"smiter",
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
			icon = "smiter",
			value_func = "primary_attack",
		},
		{
			header = "heavy",
			icon = "tank",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "activate",
		icon = "activate",
	},
}

return weapon_template
