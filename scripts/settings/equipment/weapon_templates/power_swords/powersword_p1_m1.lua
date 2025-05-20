-- chunkname: @scripts/settings/equipment/weapon_templates/power_swords/powersword_p1_m1.lua

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
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokePowerswordP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powersword_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
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
local weapon_template = {}

weapon_template.action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs)
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)

local default_weapon_box = {
	0.1,
	0.075,
	1.15,
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
			special_action = {
				action_name = "action_activate_special_left",
			},
		},
	},
	action_melee_start_left = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_left",
		chain_anim_event = "attack_swing_charge_left",
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
		anim_event = "attack_swing_left_diagonal",
		damage_window_end = 0.4,
		damage_window_start = 0.325,
		first_person_hit_anim = "hit_left_down_shake",
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
				chain_time = 0.5,
				chain_until = 0.05,
			},
			special_action = {
				action_name = "action_activate_special_right",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/swing_left_diagonal",
			anchor_point_offset = {
				0,
				0,
				-0.12,
			},
		},
		damage_profile = DamageProfileTemplates.light_sword,
		damage_profile_special_active = DamageProfileTemplates.light_powersword_active,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.left_45_slash_clean,
		wounds_shape_special_active = wounds_shapes.left_45_slash,
	},
	action_left_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_heavy_left",
		damage_window_end = 0.3333333333333333,
		damage_window_start = 0.2,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		no_hit_stop_on_active = true,
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
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/heavy_swing_left",
			anchor_point_offset = {
				0,
				0,
				-0.05,
			},
		},
		damage_profile = DamageProfileTemplates.heavy_sword,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword,
		damage_profile_special_active = DamageProfileTemplates.heavy_powersword_active,
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
		anim_event = "attack_swing_charge_right",
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
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_right_diagonal",
		damage_window_end = 0.4666666666666667,
		damage_window_start = 0.35,
		first_person_hit_anim = "hit_right_down_shake",
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
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/swing_right_diagonal",
			anchor_point_offset = {
				0,
				0,
				-0.08,
			},
		},
		damage_profile = DamageProfileTemplates.light_sword,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword,
		damage_profile_special_active = DamageProfileTemplates.light_powersword_active,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.right_45_slash_clean,
		wounds_shape_special_active = wounds_shapes.right_45_slash,
	},
	action_right_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_heavy_right",
		damage_window_end = 0.3333333333333333,
		damage_window_start = 0.2,
		first_person_hit_anim = "hit_right_shake",
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
				action_name = "action_melee_start_left",
				chain_time = 0.375,
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
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/heavy_swing_right",
			anchor_point_offset = {
				0,
				0,
				-0.1,
			},
		},
		damage_profile = DamageProfileTemplates.heavy_sword,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword,
		damage_profile_special_active = DamageProfileTemplates.heavy_powersword_active,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean,
		wounds_shape_special_active = wounds_shapes.horizontal_slash,
	},
	action_melee_start_left_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_left",
		chain_anim_event = "attack_swing_charge_left",
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
				action_name = "action_left_light_2",
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
	action_left_light_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_left_diagonal",
		damage_window_end = 0.4,
		damage_window_start = 0.325,
		first_person_hit_anim = "hit_left_down_shake",
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
				chain_time = 0.7,
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
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/swing_left_diagonal",
			anchor_point_offset = {
				0,
				0,
				-0.12,
			},
		},
		damage_profile = DamageProfileTemplates.light_sword,
		damage_profile_special_active = DamageProfileTemplates.light_powersword_active,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword,
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
				action_name = "action_activate_special_left",
			},
		},
	},
	action_right_light_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_down_right",
		anim_event_3p = "attack_swing_down",
		damage_window_end = 0.45,
		damage_window_start = 0.35,
		first_person_hit_anim = "hit_right_down_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.25,
		total_time = 2,
		weapon_handling_template = "time_scale_1_4",
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
				action_name = "action_melee_start_left",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.65,
			},
			special_action = {
				action_name = "action_activate_special_left",
				chain_time = 0.65,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/power_sword/swing_down_right",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.light_sword_smiter,
		damage_type = damage_types.metal_slashing_medium,
		damage_type_special_active = damage_types.power_sword,
		damage_profile_special_active = DamageProfileTemplates.light_powersword_smiter_push_follow_up_active,
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
				action_name = "action_melee_start_right",
				chain_time = 0.45,
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
				action_name = "action_activate_special_left",
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
	action_activate_special_left = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.35,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate",
		kind = "activate_special",
		skip_3p_anims = false,
		start_input = "special_action",
		total_time = 1.25,
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
		},
	},
	action_activate_special_right = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.35,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate_right",
		anim_event_3p = "activate",
		kind = "activate_special",
		skip_3p_anims = false,
		total_time = 1.25,
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
weapon_template.weapon_special_class = "WeaponSpecialDeactivateAfterNumActivations"
weapon_template.weapon_special_tweak_data = {
	active_duration = 3,
	allow_reactivation_while_active = true,
	keep_active_on_sprint = true,
	keep_active_on_stun = true,
	keep_active_on_vault = true,
	num_activations = 1,
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
weapon_template.keywords = {
	"melee",
	"power_sword",
	"p1",
	"activated",
}
weapon_template.dodge_template = "smiter"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "smiter"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "chainsword_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.medium
weapon_template.overclocks = {
	cleave_damage_up_dps_down = {
		powersword_p1_m1_cleave_damage_stat = 0.1,
		powersword_p1_m1_dps_stat = -0.1,
	},
	finesse_up_cleave_damage_down = {
		powersword_p1_m1_cleave_damage_stat = -0.2,
		powersword_p1_m1_finesse_stat = 0.2,
	},
	cleave_targets_up_cleave_damage_down = {
		powersword_p1_m1_cleave_damage_stat = -0.1,
		powersword_p1_m1_cleave_targets_stat = 0.1,
	},
	mobility_up_cleave_targets_down = {
		powersword_p1_m1_cleave_targets_stat = -0.1,
		powersword_p1_m1_mobility_stat = 0.1,
	},
	dps_up_mobility_down = {
		powersword_p1_m1_dps_stat = 0.1,
		powersword_p1_m1_mobility_stat = -0.1,
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	powersword_p1_m1_dps_stat = {
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
			action_left_light_2 = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_right_heavy = {
				damage_trait_templates.powersword_dps_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.powersword_dps_stat,
			},
		},
	},
	powersword_p1_m1_cleave_damage_stat = {
		display_name = "loc_stats_display_cleave_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.powersword_cleave_damage_stat,
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
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_right_light = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_right_heavy = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
		},
	},
	powersword_p1_m1_cleave_targets_stat = {
		display_name = "loc_stats_display_cleave_targets_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.powersword_cleave_targets_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_left_heavy = {
				damage_trait_templates.powersword_cleave_targets_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_right_light = {
				damage_trait_templates.powersword_cleave_targets_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.powersword_cleave_targets_stat,
			},
			action_right_heavy = {
				damage_trait_templates.powersword_cleave_targets_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.powersword_cleave_targets_stat,
			},
		},
	},
	powersword_p1_m1_finesse_stat = {
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
			},
			action_right_light = {
				damage_trait_templates.powersword_finesse_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.powersword_finesse_stat,
			},
			action_right_heavy = {
				damage_trait_templates.powersword_finesse_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.powersword_finesse_stat,
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
			action_right_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
		},
	},
	powersword_p1_m1_mobility_stat = {
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

local bespoke_powersword_p1_traits = table.ukeys(WeaponTraitsBespokePowerswordP1)

table.append(weapon_template.traits, bespoke_powersword_p1_traits)

weapon_template.perks = {
	powersword_p1_m1_dps_perk = {
		display_name = "loc_trait_display_powersword_p1_m1_dps_perk",
		damage = {
			action_left_light = {
				damage_trait_templates.powersword_dps_perk,
			},
			action_left_heavy = {
				damage_trait_templates.powersword_dps_perk,
			},
			action_right_light = {
				damage_trait_templates.powersword_dps_perk,
			},
			action_right_heavy = {
				damage_trait_templates.powersword_dps_perk,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.powersword_dps_perk,
			},
		},
	},
	powersword_p1_m1_cleave_damage_perk = {
		display_name = "loc_trait_display_powersword_p1_m1_cleave_damage_perk",
		damage = {
			action_left_light = {
				damage_trait_templates.powersword_cleave_damage_perk,
			},
			action_left_heavy = {
				damage_trait_templates.powersword_cleave_damage_perk,
			},
			action_right_light = {
				damage_trait_templates.powersword_cleave_damage_perk,
			},
			action_right_heavy = {
				damage_trait_templates.powersword_cleave_damage_perk,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.powersword_cleave_damage_perk,
			},
		},
	},
	powersword_p1_m1_finesse_perk = {
		display_name = "loc_trait_display_powersword_p1_m1_finesse_perk",
		damage = {
			action_left_light = {
				damage_trait_templates.powersword_finesse_perk,
			},
			action_left_heavy = {
				damage_trait_templates.powersword_finesse_perk,
			},
			action_right_light = {
				damage_trait_templates.powersword_finesse_perk,
			},
			action_right_heavy = {
				damage_trait_templates.powersword_finesse_perk,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.powersword_finesse_perk,
			},
		},
		weapon_handling = {
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_perk,
			},
			action_left_heavy = {
				weapon_handling_trait_templates.default_finesse_perk,
			},
			action_right_light = {
				weapon_handling_trait_templates.default_finesse_perk,
			},
			action_right_heavy = {
				weapon_handling_trait_templates.default_finesse_perk,
			},
			action_right_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_perk,
			},
		},
	},
	powersword_p1_m1_cleave_targets_perk = {
		display_name = "loc_trait_display_powersword_p1_m1_cleave_targets_perk",
		damage = {
			action_left_light = {
				damage_trait_templates.powersword_cleave_targets_perk,
			},
			action_left_heavy = {
				damage_trait_templates.powersword_cleave_targets_perk,
			},
			action_right_light = {
				damage_trait_templates.powersword_cleave_targets_perk,
			},
			action_right_heavy = {
				damage_trait_templates.powersword_cleave_targets_perk,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.powersword_cleave_targets_perk,
			},
		},
	},
	powersword_p1_m1_mobility_perk = {
		display_name = "loc_trait_display_powersword_p1_m1_mobility_perk",
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_perk,
			},
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_perk,
			},
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_perk,
			},
		},
	},
}
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
		display_name = "loc_gestalt_linesman",
		type = "linesman",
		attack_chain = {
			"linesman",
			"linesman",
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
		desc = "loc_stats_special_action_powerup_desc",
		display_name = "loc_weapon_special_activate",
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

return weapon_template
