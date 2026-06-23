-- chunkname: @scripts/settings/equipment/weapon_templates/power_mauls/powermaul_p3_m1.lua

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
local WeaponTraitsBespokePowermaulP3 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_p3")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
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
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local weapon_chain_lightning_trait_templates = WeaponTraitTemplates[template_types.weapon_chain_lightning]
local weapon_chain_lightning_husk_visual_template = {
	extra_angle_stat_buff = "chain_lightning_powermaul_max_angle",
	jump_time = 0.01,
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps = 2,
	max_jumps_stat_buff = "chain_lightning_powermaul_max_jumps",
	max_radius_stat_buff = "chain_lightning_powermaul_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	radius = 7.5,
	staff = false,
	max_targets = {
		num_targets = 1,
	},
	max_angle = math.degrees_to_radians(50),
	close_max_angle = math.degrees_to_radians(70),
}
local weapon_template = {}

weapon_template.action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs)
weapon_template.action_inputs.start_attack.buffer_time = 0.35
weapon_template.action_inputs.special_action.buffer_time = 0.5
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

local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
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
		total_time = 0.43,
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
				action_name = "action_melee_start_left",
			},
			special_action = {
				action_name = "action_activate_special_1",
			},
			block = {
				action_name = "action_block",
			},
		},
	},
	action_melee_start_left = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_down_charge",
		anim_event_3p = "attack_swing_charge_down",
		kind = "windup",
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.35,
				t = 0.1,
			},
			{
				modifier = 0.5,
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
				chain_time = 0.475,
			},
			special_action = {
				action_name = "action_activate_special_1",
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
		anim_event = "attack_left_diagonal_up",
		anim_event_3p = "attack_swing_up_left",
		chain_visual_jump_validation_function_name = "target_alive_and_arc_electrocuted",
		damage_window_end = 0.3333333333333333,
		damage_window_start = 0.25,
		kind = "sweep",
		range_mod = 1.2,
		start_input = nil,
		total_time = 1.5,
		trigger_chain_while_special_active_only = true,
		uninterruptible = true,
		weapon_chain_lightning_template = "powermaul_p3_arc",
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.8,
				t = 0.35,
			},
			{
				modifier = 0.5,
				t = 0.5,
			},
			{
				modifier = 0.45,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 0.7,
				t = 1,
			},
			{
				modifier = 1,
				t = 1.3,
			},
			start_modifier = 1.1,
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
				chain_time = 0.57,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special_2",
				chain_time = 0.57,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = {
			0.15,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/arc_maul/attack_left_diagonal_up",
				anchor_point_offset = {
					0,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_p3_light_tank,
		damage_profile_special_active = DamageProfileTemplates.powermaul_p3_light_tank,
		damage_type = damage_types.blunt_shock,
		damage_type_special_active = damage_types.blunt_arc_active,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		husk_chain_lightning_template = weapon_chain_lightning_husk_visual_template,
		chain_damage_settings = {
			damage_profile = DamageProfileTemplates.powermaul_p3_arc_chain_lightning_link_damage,
			damage_type = damage_types.arc_chain,
			attack_type = attack_types.arc,
		},
	},
	action_heavy_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_down",
		anim_event_3p = "attack_swing_heavy_down",
		attack_direction_override = "down",
		chain_visual_jump_validation_function_name = "target_alive_and_arc_electrocuted",
		damage_window_end = 0.275,
		damage_window_start = 0.21666666666666667,
		kind = "sweep",
		range_mod = 1.3,
		start_input = nil,
		total_time = 2,
		trigger_chain_while_special_active_only = true,
		weapon_chain_lightning_template = "powermaul_p3_arc",
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
				action_name = "action_melee_start_right_alt",
				chain_time = 0.48,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.48,
			},
			special_action = {
				action_name = "action_activate_special_2_alt",
				chain_time = 0.48,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = {
			0.2,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/arc_maul/heavy_attack_left_down",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_p3_heavy_smiter,
		damage_profile_special_active = DamageProfileTemplates.powermaul_p3_heavy_smiter,
		damage_type = damage_types.blunt_shock,
		damage_type_special_active = damage_types.blunt_arc_active,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		husk_chain_lightning_template = weapon_chain_lightning_husk_visual_template,
		chain_damage_settings = {
			damage_profile = DamageProfileTemplates.powermaul_p3_arc_chain_lightning_link_damage,
			damage_type = damage_types.arc_chain,
			attack_type = attack_types.arc,
		},
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right",
		anim_event_3p = "attack_swing_charge_right",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.35,
				t = 0.1,
			},
			{
				modifier = 0.5,
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
				action_name = "action_light_2",
			},
			heavy_attack = {
				action_name = "action_heavy_4",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_activate_special_2",
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_melee_start_right_alt = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_down_charge",
		anim_event_3p = "attack_swing_charge_down_right",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.35,
				t = 0.1,
			},
			{
				modifier = 0.5,
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
				action_name = "action_light_2",
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.51,
			},
			special_action = {
				action_name = "action_activate_special_2_alt",
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
		anim_event = "attack_right",
		anim_event_3p = "attack_swing_right",
		chain_visual_jump_validation_function_name = "target_alive_and_arc_electrocuted",
		damage_window_end = 0.4,
		damage_window_start = 0.3266666666666667,
		kind = "sweep",
		range_mod = 1.25,
		start_input = nil,
		total_time = 1.5,
		trigger_chain_while_special_active_only = true,
		weapon_chain_lightning_template = "powermaul_p3_arc",
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.8,
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
				modifier = 0.75,
				t = 0.6,
			},
			{
				modifier = 0.8,
				t = 1,
			},
			{
				modifier = 1,
				t = 1.3,
			},
			start_modifier = 1.1,
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
				chain_time = 0.56,
			},
			special_action = {
				action_name = "action_activate_special_3",
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
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.15,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/arc_maul/attack_right",
				anchor_point_offset = {
					0,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_p3_light_tank,
		damage_profile_special_active = DamageProfileTemplates.powermaul_p3_light_tank,
		damage_type = damage_types.blunt_shock,
		damage_type_special_active = damage_types.blunt_arc_active,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		husk_chain_lightning_template = weapon_chain_lightning_husk_visual_template,
		chain_damage_settings = {
			damage_profile = DamageProfileTemplates.powermaul_p3_arc_chain_lightning_link_damage,
			damage_type = damage_types.arc_chain,
			attack_type = attack_types.arc,
		},
	},
	action_heavy_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_down",
		anim_event_3p = "attack_swing_heavy_down_right",
		attack_direction_override = "down",
		chain_visual_jump_validation_function_name = "target_alive_and_arc_electrocuted",
		damage_window_end = 0.30833333333333335,
		damage_window_start = 0.23333333333333334,
		kind = "sweep",
		range_mod = 1.3,
		start_input = nil,
		total_time = 2,
		trigger_chain_while_special_active_only = true,
		weapon_chain_lightning_template = "powermaul_p3_arc",
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
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_activate_special_3",
				chain_time = 0.45,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = {
			0.2,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/arc_maul/heavy_attack_right_down",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_p3_heavy_smiter,
		damage_profile_special_active = DamageProfileTemplates.powermaul_p3_heavy_smiter,
		damage_type = damage_types.blunt_shock,
		damage_type_special_active = damage_types.blunt_arc_active,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		husk_chain_lightning_template = weapon_chain_lightning_husk_visual_template,
		chain_damage_settings = {
			damage_profile = DamageProfileTemplates.powermaul_p3_arc_chain_lightning_link_damage,
			damage_type = damage_types.arc_chain,
			attack_type = attack_types.arc,
		},
	},
	action_melee_start_left_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left",
		anim_event_3p = "attack_swing_charge_left",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.35,
				t = 0.1,
			},
			{
				modifier = 0.5,
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
				action_name = "action_light_3",
			},
			heavy_attack = {
				action_name = "action_heavy_3",
				chain_time = 0.43,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special_3",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_down",
		anim_event_3p = "attack_swing_down_left",
		attack_direction_override = "down",
		chain_visual_jump_validation_function_name = "target_alive_and_arc_electrocuted",
		damage_window_end = 0.48333333333333334,
		damage_window_start = 0.4166666666666667,
		kind = "sweep",
		range_mod = 1.2,
		start_input = nil,
		total_time = 1.5,
		trigger_chain_while_special_active_only = true,
		weapon_chain_lightning_template = "powermaul_p3_arc",
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.8,
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
				modifier = 0.75,
				t = 0.6,
			},
			{
				modifier = 0.8,
				t = 1,
			},
			{
				modifier = 1,
				t = 1.3,
			},
			start_modifier = 1.1,
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
				action_name = "action_melee_start_right_2_alt",
				chain_time = 0.58,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special_4_alt",
				chain_time = 0.59,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.15,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/arc_maul/attack_left_down",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_p3_light_smiter,
		damage_profile_special_active = DamageProfileTemplates.powermaul_p3_light_smiter,
		damage_type = damage_types.blunt_shock,
		damage_type_special_active = damage_types.blunt_arc_active,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		husk_chain_lightning_template = weapon_chain_lightning_husk_visual_template,
		chain_damage_settings = {
			damage_profile = DamageProfileTemplates.powermaul_p3_arc_chain_lightning_link_damage,
			damage_type = damage_types.arc_chain,
			attack_type = attack_types.arc,
		},
	},
	action_melee_start_right_2_alt = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_down_charge",
		anim_event_3p = "attack_swing_charge_down_right",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.35,
				t = 0.1,
			},
			{
				modifier = 0.5,
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
				action_name = "action_light_4",
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.51,
			},
			special_action = {
				action_name = "action_activate_special_4",
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_heavy_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left",
		anim_event_3p = "attack_swing_heavy_left",
		attack_direction_override = "left",
		chain_visual_jump_validation_function_name = "target_alive_and_arc_electrocuted",
		damage_window_end = 0.2833333333333333,
		damage_window_start = 0.15833333333333333,
		kind = "sweep",
		range_mod = 1.3,
		start_input = nil,
		total_time = 2,
		trigger_chain_while_special_active_only = true,
		weapon_chain_lightning_template = "powermaul_p3_arc",
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
				action_name = "action_melee_start_right_2",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_activate_special_4",
				chain_time = 0.42,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = {
			0.2,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_maul/heavy_attack_left",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_p3_heavy_tank,
		damage_profile_special_active = DamageProfileTemplates.powermaul_p3_heavy_tank,
		damage_type = damage_types.blunt_shock,
		damage_type_special_active = damage_types.blunt_arc_active,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		husk_chain_lightning_template = weapon_chain_lightning_husk_visual_template,
		chain_damage_settings = {
			damage_profile = DamageProfileTemplates.powermaul_p3_arc_chain_lightning_link_damage,
			damage_type = damage_types.arc_chain,
			attack_type = attack_types.arc,
		},
	},
	action_melee_start_right_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right",
		anim_event_3p = "attack_swing_charge_right",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.35,
				t = 0.1,
			},
			{
				modifier = 0.5,
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
				action_name = "action_light_4",
			},
			heavy_attack = {
				action_name = "action_heavy_4",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_activate_special_4",
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
		anim_event = "attack_right_diagonal_down",
		anim_event_3p = "attack_swing_right_diagonal",
		chain_visual_jump_validation_function_name = "target_alive_and_arc_electrocuted",
		damage_window_end = 0.4166666666666667,
		damage_window_start = 0.36666666666666664,
		kind = "sweep",
		range_mod = 1.25,
		start_input = nil,
		total_time = 1.5,
		trigger_chain_while_special_active_only = true,
		weapon_chain_lightning_template = "powermaul_p3_arc",
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
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.2,
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
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_activate_special_1",
				chain_time = 0.6,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = {
			0.15,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/arc_maul/attack_right_diagonal_down",
				anchor_point_offset = {
					-0.1,
					0,
					0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_p3_light_linesman,
		damage_profile_special_active = DamageProfileTemplates.powermaul_p3_light_linesman,
		damage_type = damage_types.blunt_shock,
		damage_type_special_active = damage_types.blunt_arc_active,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		husk_chain_lightning_template = weapon_chain_lightning_husk_visual_template,
		chain_damage_settings = {
			damage_profile = DamageProfileTemplates.powermaul_p3_arc_chain_lightning_link_damage,
			damage_type = damage_types.arc_chain,
			attack_type = attack_types.arc,
		},
	},
	action_heavy_4 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right",
		anim_event_3p = "attack_swing_heavy_right",
		attack_direction_override = "right",
		chain_visual_jump_validation_function_name = "target_alive_and_arc_electrocuted",
		damage_window_end = 0.24166666666666667,
		damage_window_start = 0.13333333333333333,
		kind = "sweep",
		range_mod = 1.3,
		start_input = nil,
		total_time = 2,
		trigger_chain_while_special_active_only = true,
		weapon_chain_lightning_template = "powermaul_p3_arc",
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
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_activate_special_3",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		weapon_box = {
			0.2,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_maul/heavy_attack_right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_p3_heavy_tank,
		damage_profile_special_active = DamageProfileTemplates.powermaul_p3_heavy_tank,
		damage_type = damage_types.blunt_shock,
		damage_type_special_active = damage_types.blunt_arc_active,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		husk_chain_lightning_template = weapon_chain_lightning_husk_visual_template,
		chain_damage_settings = {
			damage_profile = DamageProfileTemplates.powermaul_p3_arc_chain_lightning_link_damage,
			damage_type = damage_types.arc_chain,
			attack_type = attack_types.arc,
		},
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
			special_action = {
				action_name = "action_activate_special_1",
				chain_time = 0.3,
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
		total_time = 0.75,
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
					chain_time = 0.25,
				},
				{
					action_name = "action_pushfollow",
					chain_time = 0.25,
				},
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			start_attack = {
				action_name = "action_melee_start_push_combo",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_activate_special_push",
				chain_time = 0.4,
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
	action_melee_start_push_combo = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right",
		anim_event_3p = "attack_swing_charge_right",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.35,
				t = 0.1,
			},
			{
				modifier = 0.5,
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
				modifier = 0.7,
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
			},
			heavy_attack = {
				action_name = "action_heavy_4",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_activate_special_push",
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_pushfollow = {
		action_priority = 1,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_down",
		anim_event_3p = "attack_swing_right_diagonal",
		attack_direction_override = "down",
		chain_visual_jump_validation_function_name = "target_alive_and_arc_electrocuted",
		damage_window_end = 0.45,
		damage_window_start = 0.375,
		kind = "sweep",
		range_mod = 1.25,
		start_input = nil,
		total_time = 1.5,
		trigger_chain_while_special_active_only = true,
		weapon_chain_lightning_template = "powermaul_p3_arc",
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
				action_name = "action_melee_start_left",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_activate_special_pushfollow",
				chain_time = 0.525,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_anims = HIT_ANIMS,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.15,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/arc_maul/attack_push_follow_up",
				anchor_point_offset = {
					-0.05,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_p3_light_smiter_pushfollow,
		damage_profile_special_active = DamageProfileTemplates.powermaul_p3_light_smiter_pushfollow,
		damage_type = damage_types.blunt_shock,
		damage_type_special_active = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		husk_chain_lightning_template = weapon_chain_lightning_husk_visual_template,
		chain_damage_settings = {
			damage_profile = DamageProfileTemplates.powermaul_p3_arc_chain_lightning_link_damage,
			damage_type = damage_types.arc_chain,
			attack_type = attack_types.arc,
		},
	},
	action_pushfollow_special = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "parry_finished",
		anim_event = "attack_push_follow_special",
		block_duration = 0.65,
		block_during_shout = true,
		chain_visual_jump_validation_function_name = "target_alive_and_arc_electrocuted",
		invalid_start_action_for_stat_calculation = true,
		kind = "weapon_shout",
		range_mod = 1.25,
		shout_at_time = 0.1,
		start_input = nil,
		total_time = 1,
		trigger_chain_while_special_active_only = true,
		uninterruptible = true,
		weapon_chain_lightning_template = "powermaul_p3_arc",
		weapon_handling_template = "time_scale_1_5",
		weapon_shout_template = "powermaul_p3_pushfollow",
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
				action_name = "action_melee_start_right_2_alt",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.65,
			},
			special_action = {
				action_name = "action_activate_special_4_alt",
				chain_time = 0.7,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action"
		end,
		damage_profile = DamageProfileTemplates.powermaul_p3_pushfollow_special,
		damage_profile_special_active = DamageProfileTemplates.powermaul_p3_pushfollow_special,
		damage_type = damage_types.shield_push,
		attack_type = attack_types.shout,
		haptic_trigger_template = HapticTriggerTemplates.melee.push,
		husk_chain_lightning_template = weapon_chain_lightning_husk_visual_template,
		chain_damage_settings = {
			damage_profile = DamageProfileTemplates.powermaul_p3_arc_chain_lightning_link_damage,
			damage_type = damage_types.arc_chain,
			attack_type = attack_types.arc,
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_activate_special_1 = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.55,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate",
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = "special_action",
		total_time = 1.3,
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
				action_name = "action_activate_special_1",
				chain_time = 0.9,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_activate = weapon_special_tweak_data.num_charges_to_activate
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_activate <= num_special_charges

			return enough_charges
		end,
	},
	action_activate_special_2 = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.55,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate_right",
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = nil,
		total_time = 1.3,
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
				action_name = "action_activate_special_2",
				chain_time = 0.9,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_activate = weapon_special_tweak_data.num_charges_to_activate
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_activate <= num_special_charges

			return enough_charges
		end,
	},
	action_activate_special_2_alt = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.55,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate_right",
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = nil,
		total_time = 1.3,
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
				action_name = "action_melee_start_right_alt",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_activate_special_2_alt",
				chain_time = 0.9,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_activate = weapon_special_tweak_data.num_charges_to_activate
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_activate <= num_special_charges

			return enough_charges
		end,
	},
	action_activate_special_3 = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.55,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate",
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = nil,
		total_time = 1.3,
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
				action_name = "action_activate_special_3",
				chain_time = 0.9,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_activate = weapon_special_tweak_data.num_charges_to_activate
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_activate <= num_special_charges

			return enough_charges
		end,
	},
	action_activate_special_4 = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.55,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate_right",
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = nil,
		total_time = 1.3,
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
				action_name = "action_activate_special_4",
				chain_time = 0.9,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_activate = weapon_special_tweak_data.num_charges_to_activate
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_activate <= num_special_charges

			return enough_charges
		end,
	},
	action_activate_special_4_alt = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.55,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate_right",
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = nil,
		total_time = 1.3,
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
				action_name = "action_melee_start_right_2_alt",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_activate_special_4_alt",
				chain_time = 0.9,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_activate = weapon_special_tweak_data.num_charges_to_activate
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_activate <= num_special_charges

			return enough_charges
		end,
	},
	action_activate_special_push = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.55,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate_right",
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = nil,
		total_time = 1.3,
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
				action_name = "action_activate_special_push",
				chain_time = 0.9,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_activate = weapon_special_tweak_data.num_charges_to_activate
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_activate <= num_special_charges

			return enough_charges
		end,
	},
	action_activate_special_pushfollow = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.55,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate",
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = nil,
		total_time = 1.3,
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
				action_name = "action_activate_special_pushfollow",
				chain_time = 0.9,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if not inventory_slot_component then
				return false
			end

			local weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
			local num_charges_to_activate = weapon_special_tweak_data.num_charges_to_activate
			local num_special_charges = inventory_slot_component.num_special_charges
			local enough_charges = num_charges_to_activate <= num_special_charges

			return enough_charges
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/arc_maul"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/arc_maul"
weapon_template.weapon_box = {
	0.15,
	0.35,
	0.15,
}
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.weapon_special_class = "WeaponSpecialHitCharges"
weapon_template.weapon_special_tweak_data = {
	activation_cost_divisor = 8,
	allow_reactivation_while_active = false,
	clear_charges_on_activation = false,
	deactivation_animation = "deactivate_automatic",
	deactivation_animation_delay = 0.4,
	deactivation_animation_on_abort = true,
	hit_num_charges_to_add = 1,
	keep_active_on_sprint = true,
	keep_active_on_stun = true,
	keep_active_on_vault = true,
	max_charges = 40,
	passive_charge_add_interval = 2.5,
	passive_num_charges_to_add = 1,
	thresholds = {
		{
			name = "empty",
			threshold = 0,
		},
		{
			name = "one",
			threshold = 5,
		},
		{
			name = "two",
			threshold = 10,
		},
		{
			name = "three",
			threshold = 15,
		},
		{
			name = "four",
			threshold = 20,
		},
		{
			name = "five",
			threshold = 25,
		},
		{
			name = "six",
			threshold = 30,
		},
		{
			name = "seven",
			threshold = 35,
		},
		{
			name = "eight",
			threshold = 40,
		},
	},
	set_inactive_func = function (inventory_slot_component, reason, tweak_data)
		local disable_special_active = reason == "not_enough_charges" or reason == "manual_toggle" or reason == "unwield"

		if disable_special_active then
			inventory_slot_component.special_active = false
		end

		return true
	end,
}
weapon_template.weapon_special_tweak_data.num_charges_to_activate = weapon_template.weapon_special_tweak_data.max_charges / weapon_template.weapon_special_tweak_data.activation_cost_divisor
weapon_template.weapon_special_tweak_data.num_charges_to_consume_on_sweep = weapon_template.weapon_special_tweak_data.max_charges / weapon_template.weapon_special_tweak_data.activation_cost_divisor
weapon_template.weapon_special_tweak_data.num_charges_to_consume_on_special_active_shout = weapon_template.weapon_special_tweak_data.num_charges_to_consume_on_sweep
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.chain_settings = {
	left_fx_source_name = "_sweep",
	right_fx_source_name = "_sweep",
	skip_link_to_player_effect = true,
	skip_no_target_effect = true,
	triggering_action_kind = "sweep",
	chain_damage_settings = {
		damage_profile = DamageProfileTemplates.powermaul_p3_arc_chain_lightning_link_damage,
		damage_type = damage_types.arc_chain,
		attack_type = attack_types.arc,
	},
}
weapon_template.fx_sources = {
	_block = "fx_block",
	_shout_special_active = "fx_shout_special_active",
	_special_active = "fx_special_active",
	_sticky = "fx_special_active",
	_sweep = "fx_sweep",
	_wielded_idling = "fx_special_active",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.weapon_counter = {
	show_when_unwielded = false,
	weapon_counter_type = "cooldown_charges",
}
weapon_template.keywords = {
	"melee",
	"power_maul",
	"p3",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "linesman_plus"
weapon_template.toughness_template = "assault"
weapon_template.movement_curve_modifier_template = "combataxe_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.medium

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	powermaul_p3_m1_dps_stat = {
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
			action_light_3 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_3 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_4 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_pushfollow_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	powermaul_p3_m1_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.default_armor_pierce_stat,
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
			action_heavy_1 = {
				damage_trait_templates.default_armor_pierce_stat,
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
			action_light_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_3 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_3 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_4 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_pushfollow_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
		},
	},
	powermaul_p3_m1_control_stat = {
		description = "loc_stats_display_control_stat_melee_mouseover",
		display_name = "loc_stats_display_control_stat_melee",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
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
			action_heavy_1 = {
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
			action_light_2 = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_light_3 = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_light_4 = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_heavy_3 = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_heavy_4 = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_pushfollow = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_pushfollow_special = {
				damage_trait_templates.thunderhammer_control_stat,
			},
		},
	},
	powermaul_p3_m1_arc_stat = {
		description = "loc_stats_display_arc_stat_desc",
		display_name = "loc_stats_display_arc_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				overrides = {
					powermaul_p3_arc_chain_lightning_link_damage = {
						damage_trait_templates.powermaul_p3_arc_stat,
						display_data = {
							damage_profile_path = {
								"chain_damage_settings",
								"damage_profile",
							},
							display_stats = {
								targets = {
									{
										power_distribution = {
											attack = {
												display_name = "loc_weapon_stats_display_arc_damage",
											},
										},
									},
								},
							},
						},
					},
				},
			},
			action_light_2 = {
				overrides = {
					powermaul_p3_arc_chain_lightning_link_damage = {
						damage_trait_templates.powermaul_p3_arc_stat,
					},
				},
			},
			action_light_3 = {
				overrides = {
					powermaul_p3_arc_chain_lightning_link_damage = {
						damage_trait_templates.powermaul_p3_arc_stat,
					},
				},
			},
			action_light_4 = {
				overrides = {
					powermaul_p3_arc_chain_lightning_link_damage = {
						damage_trait_templates.powermaul_p3_arc_stat,
					},
				},
			},
			action_heavy_1 = {
				overrides = {
					powermaul_p3_arc_chain_lightning_link_damage = {
						damage_trait_templates.powermaul_p3_arc_stat,
					},
				},
			},
			action_heavy_2 = {
				overrides = {
					powermaul_p3_arc_chain_lightning_link_damage = {
						damage_trait_templates.powermaul_p3_arc_stat,
					},
				},
			},
			action_heavy_3 = {
				overrides = {
					powermaul_p3_arc_chain_lightning_link_damage = {
						damage_trait_templates.powermaul_p3_arc_stat,
					},
				},
			},
			action_heavy_4 = {
				overrides = {
					powermaul_p3_arc_chain_lightning_link_damage = {
						damage_trait_templates.powermaul_p3_arc_stat,
					},
				},
			},
			action_pushfollow = {
				overrides = {
					powermaul_p3_arc_chain_lightning_link_damage = {
						damage_trait_templates.powermaul_p3_arc_stat,
					},
				},
			},
			action_pushfollow_special = {
				overrides = {
					powermaul_p3_pushfollow_special = {
						damage_trait_templates.powermaul_p3_arc_stat,
					},
				},
			},
		},
		weapon_chain_lightning = {
			action_light_1 = {
				weapon_chain_lightning_trait_templates.powermaul_p3_arc_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_light_2 = {
				weapon_chain_lightning_trait_templates.powermaul_p3_arc_stat,
			},
			action_light_3 = {
				weapon_chain_lightning_trait_templates.powermaul_p3_arc_stat,
			},
			action_light_4 = {
				weapon_chain_lightning_trait_templates.powermaul_p3_arc_stat,
			},
			action_heavy_1 = {
				weapon_chain_lightning_trait_templates.powermaul_p3_arc_stat,
			},
			action_heavy_2 = {
				weapon_chain_lightning_trait_templates.powermaul_p3_arc_stat,
			},
			action_heavy_3 = {
				weapon_chain_lightning_trait_templates.powermaul_p3_arc_stat,
			},
			action_heavy_4 = {
				weapon_chain_lightning_trait_templates.powermaul_p3_arc_stat,
			},
			action_pushfollow = {
				weapon_chain_lightning_trait_templates.powermaul_p3_arc_stat,
			},
		},
	},
	powermaul_p3_m1_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = {
					display_stats = {
						diminishing_return_start = {},
						distance_scale = {},
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

local weapon_traits_bespoke_powermaul_p3 = table.ukeys(WeaponTraitsBespokePowermaulP3)

table.append(weapon_template.traits, weapon_traits_bespoke_powermaul_p3)

weapon_template.buffs = {
	on_equip = {
		"powermaul_always_shock_hit",
		"powermaul_inherent_damage_bonus_vs_electrocuted",
	},
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control",
	},
	{
		display_name = "loc_weapon_keyword_arc_weapon",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {
			"tank",
			"tank",
			"smiter",
			"linesman",
		},
	},
	secondary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"smiter",
			"tank",
			"tank",
		},
	},
	special = {
		desc = "loc_stats_special_action_powermaul_p3_desc",
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

weapon_template.action_inspect_3p_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect_3p"
end

weapon_template.action_inspect_3p_base_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect"
end

return weapon_template
