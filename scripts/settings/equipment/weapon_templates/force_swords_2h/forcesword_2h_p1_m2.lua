-- chunkname: @scripts/settings/equipment/weapon_templates/force_swords_2h/forcesword_2h_p1_m2.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local ForceswordMeleeActionInputSetup = require("scripts/settings/equipment/weapon_templates/forcesword_melee_action_input_setup")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeForcesword2hP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcesword_2h_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local wounds_shapes = WoundsSettings.shapes
local charge_trait_templates = WeaponTraitTemplates[template_types.charge]
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}

weapon_template.action_inputs = table.clone(ForceswordMeleeActionInputSetup.action_inputs)
weapon_template.action_input_hierarchy = table.clone(ForceswordMeleeActionInputSetup.action_input_hierarchy)
weapon_template.action_inputs.vent = {
	buffer_time = 0,
	clear_input_queue = true,
	input_sequence = {
		{
			input = "weapon_reload_hold",
			value = true,
		},
	},
}
weapon_template.action_inputs.vent_release = {
	buffer_time = 0.1,
	input_sequence = {
		{
			input = "weapon_reload_hold",
			value = false,
			time_window = math.huge,
		},
	},
}
weapon_template.action_inputs.special_action_release = {
	buffer_time = 0.42,
	input_sequence = {
		{
			input = "weapon_extra_hold",
			value = false,
			time_window = math.huge,
		},
	},
}

ActionInputHierarchy.update_hierarchy_entry(weapon_template.action_input_hierarchy, "vent", {
	{
		input = "vent_release",
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
})

weapon_template.action_inputs.block.buffer_time = 0.1
weapon_template.action_inputs.block_release.buffer_time = 0.35
weapon_template.action_inputs.start_attack.buffer_time = 0.4

local base_sweep_box = {
	0.15,
	0.15,
	1.2,
}
local stab_sweep_box = {
	0.15,
	0.15,
	1.2,
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
		total_time = 0.3,
		uninterruptible = true,
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.4,
			},
			start_modifier = 0.8,
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
				action_name = "action_melee_start_wield",
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special",
			},
			vent = {
				action_name = "action_vent",
			},
		},
	},
	action_melee_start_left = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_diagonal_down",
		chain_anim_event = "heavy_charge_left_diagonal_down_pose",
		chain_anim_event_3p = "heavy_charge_down_left",
		kind = "windup",
		sprint_enabled_time = 0.5,
		sprint_ready_up_time = 0,
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.65,
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
				t = 1.5,
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
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special",
			},
			vent = {
				action_name = "action_vent",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_melee_start_sprint = {
		action_priority = 3,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down_sprint",
		anim_event_3p = "heavy_charge_right_diagonal_down",
		chain_anim_event = "heavy_charge_down_left_pose",
		chain_anim_event_3p = "heavy_charge_right_diagonal_down",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		sprint_requires_press_to_interrupt = true,
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.95,
				t = 0.05,
			},
			{
				modifier = 0.8,
				t = 0.25,
			},
			{
				modifier = 0.9,
				t = 0.35,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			{
				modifier = 1.1,
				t = 0.6,
			},
			{
				modifier = 1.2,
				t = 0.75,
			},
			{
				modifier = 1.1,
				t = 1,
			},
			{
				modifier = 1,
				t = 1.5,
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
				action_name = "action_light_sprint",
			},
			heavy_attack = {
				action_name = "action_heavy_sprint",
				chain_time = 0.62,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special",
			},
			vent = {
				action_name = "action_vent",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.sprint_character_state_component.is_sprinting
		end,
	},
	action_melee_start_wield = {
		action_priority = 1,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down_sprint",
		anim_event_3p = "heavy_charge_right_diagonal_down",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.65,
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
				t = 1.5,
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
				action_name = "action_light_sprint",
			},
			heavy_attack = {
				action_name = "action_heavy_sprint",
				chain_time = 0.62,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special",
			},
			vent = {
				action_name = "action_vent",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_melee_start_slide = {
		action_priority = 4,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down",
		chain_anim_event = "heavy_charge_down_left_pose",
		chain_anim_event_3p = "heavy_charge_left",
		invalid_start_action_for_stat_calculation = true,
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
				modifier = 0.65,
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
				modifier = 0.75,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 1.5,
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
				chain_time = 0.15,
			},
			heavy_attack = {
				action_name = "action_heavy_sprint",
				chain_time = 0.62,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special",
			},
			vent = {
				action_name = "action_vent",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.movement_state_component.method == "sliding"
		end,
	},
	action_light_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left",
		charge_template = "forcesword_p1_m1_weapon_special_hit",
		damage_window_end = 0.36666666666666664,
		damage_window_start = 0.16666666666666666,
		first_person_hit_anim = "hit_left_down_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.5,
		total_time = 0.9,
		uninterruptible = true,
		weapon_handling_template = "time_scale_0_85",
		action_movement_curve = {
			{
				modifier = 1.15,
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
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.38,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.38,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.38,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = base_sweep_box,
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/attack_left",
			anchor_point_offset = {
				0,
				0,
				-0.125,
			},
		},
		damage_profile = DamageProfileTemplates.light_force_sword_2h_linesman,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean,
	},
	action_heavy_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_diagonal_down",
		charge_template = "forcesword_p1_m1_weapon_special_hit",
		damage_window_end = 0.3333333333333333,
		damage_window_start = 0.18333333333333332,
		first_person_hit_anim = "hit_down_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.5,
		total_time = 0.8,
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
				chain_time = 0.52,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.45,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.45,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = base_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/heavy_attack_left_diagonal_down",
			anchor_point_offset = {
				0,
				0,
				-0.1,
			},
		},
		damage_profile = DamageProfileTemplates.heavy_force_sword_2h_linesman,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.left_45_slash_clean,
	},
	action_light_sprint = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_diagonal_down",
		charge_template = "forcesword_p1_m1_weapon_special_hit",
		damage_window_end = 0.31666666666666665,
		damage_window_start = 0.2,
		first_person_hit_anim = "hit_right_down_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.5,
		total_time = 0.9,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
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
				action_name = "action_melee_start_left_2_heavy",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.4,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = base_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/attack_right_diagonal_down",
			anchor_point_offset = {
				0,
				0,
				-0.05,
			},
		},
		damage_profile = DamageProfileTemplates.light_force_sword_2h_linesman,
		damage_type = damage_types.metal_slashing_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.right_45_slash_clean,
	},
	action_heavy_sprint = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_diagonal_down",
		anim_event_3p = "heavy_attack_right_diagonal_down",
		attack_direction_override = "right",
		damage_window_end = 0.3,
		damage_window_start = 0.18333333333333332,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.4,
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
				action_name = "action_melee_start_left_2_heavy",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
				chain_until = 0.2,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.4,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = base_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/heavy_attack_right_diagonal_down",
			anchor_point_offset = {
				0,
				0,
				-0.15,
			},
		},
		damage_profile = DamageProfileTemplates.heavy_force_sword_2h_linesman,
		damage_type = damage_types.metal_slashing_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.right_45_slash_clean,
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_right",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.65,
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
				t = 1.5,
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
				chain_time = 0.3,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special",
			},
			vent = {
				action_name = "action_vent",
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
		charge_template = "forcesword_p1_m1_weapon_special_hit",
		damage_window_end = 0.3333333333333333,
		damage_window_start = 0.16666666666666666,
		first_person_hit_anim = "hit_right_down_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.5,
		total_time = 0.9,
		uninterruptible = true,
		weapon_handling_template = "time_scale_0_85",
		action_movement_curve = {
			{
				modifier = 1.15,
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
				chain_time = 0.56,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.38,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.38,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.38,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = base_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/attack_right",
			anchor_point_offset = {
				0,
				0,
				-0.1,
			},
		},
		damage_profile = DamageProfileTemplates.light_force_sword_2h_linesman,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean,
	},
	action_heavy_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_down",
		attack_direction_override = "down",
		charge_template = "forcesword_p1_m1_weapon_special_hit",
		damage_window_end = 0.3,
		damage_window_start = 0.18333333333333332,
		first_person_hit_anim = "hit_down_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.5,
		total_time = 0.7,
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
				chain_time = 0.2,
			},
			start_attack = {
				action_name = "action_melee_start_left_2_heavy",
				chain_time = 0.53,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.45,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.45,
			},
		},
		hit_zone_priority = hit_zone_priority,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = base_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/heavy_attack_down_right",
			anchor_point_offset = {
				0.1,
				0,
				-0.075,
			},
		},
		damage_profile = DamageProfileTemplates.heavy_force_sword_2h_smiter,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_clean,
	},
	action_melee_start_left_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_diagonal_down_pose",
		chain_anim_event = "heavy_charge_left_diagonal_down_pose",
		chain_anim_event_3p = "heavy_charge_left_diagonal_down",
		kind = "windup",
		sprint_enabled_time = 0.5,
		sprint_ready_up_time = 0,
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.65,
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
				t = 1.5,
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
				action_name = "action_heavy_1",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special",
			},
			vent = {
				action_name = "action_vent",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_diagonal_up",
		charge_template = "forcesword_p1_m1_weapon_special_hit",
		damage_window_end = 0.43333333333333335,
		damage_window_start = 0.3,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.45,
		total_time = 0.75,
		uninterruptible = true,
		weapon_handling_template = "time_scale_0_85",
		action_movement_curve = {
			{
				modifier = 1.15,
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
				modifier = 1,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			{
				modifier = 1.6,
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
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.38,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.38,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.38,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = stab_sweep_box,
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/attack_left_diagonal_up",
			anchor_point_offset = {
				0,
				0,
				-0.15,
			},
		},
		damage_profile = DamageProfileTemplates.light_force_sword_2h_uppercut,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.right_45_slash_clean,
	},
	action_melee_start_left_2_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_left_pose",
		chain_anim_event = "heavy_charge_down_left_pose",
		chain_anim_event_3p = "heavy_charge_down_left",
		kind = "windup",
		sprint_enabled_time = 0.5,
		sprint_ready_up_time = 0,
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.65,
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
				t = 1.5,
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
				action_name = "action_heavy_3",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special",
			},
			vent = {
				action_name = "action_vent",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_heavy_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_down",
		attack_direction_override = "down",
		charge_template = "forcesword_p1_m1_weapon_special_hit",
		damage_window_end = 0.3,
		damage_window_start = 0.18333333333333332,
		first_person_hit_anim = "hit_down_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.5,
		total_time = 0.7,
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
				chain_time = 0.2,
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.53,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.45,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.45,
			},
		},
		hit_zone_priority = hit_zone_priority,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = base_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/heavy_attack_down_left",
			anchor_point_offset = {
				0.1,
				0,
				-0.075,
			},
		},
		damage_profile = DamageProfileTemplates.heavy_force_sword_2h_smiter,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_clean,
	},
	action_melee_start_right_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_right",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.65,
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
				t = 1.5,
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
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special",
			},
			vent = {
				action_name = "action_vent",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_4 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_diagonal_up",
		charge_template = "forcesword_p1_m1_weapon_special_hit",
		damage_window_end = 0.43333333333333335,
		damage_window_start = 0.2833333333333333,
		first_person_hit_anim = "hit_right_down_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.4,
		total_time = 0.9,
		uninterruptible = true,
		weapon_handling_template = "time_scale_0_85",
		action_movement_curve = {
			{
				modifier = 1.15,
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
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.4,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = base_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/attack_right_diagonal_up",
			anchor_point_offset = {
				0,
				0,
				-0.15,
			},
		},
		damage_profile = DamageProfileTemplates.light_force_sword_2h_uppercut,
		damage_type = damage_types.metal_slashing_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.left_45_slash_clean,
	},
	action_block = {
		anim_end_event = "parry_finished",
		anim_event = "parry_pose",
		kind = "block",
		minimum_hold_time = 0.3,
		start_input = "block",
		stop_input = "block_release",
		weapon_handling_template = "time_scale_1_65",
		total_time = math.huge,
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
				action_name = "action_activate_special",
				chain_time = 0.3,
			},
		},
	},
	action_push = {
		anim_event = "attack_push",
		block_duration = 0.5,
		kind = "push",
		push_radius = 2.75,
		total_time = 0.6,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.1,
			},
			{
				modifier = 0.8,
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
				action_name = "action_find_target",
				chain_time = 0.1,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.4,
			},
			start_attack = {
				{
					action_name = "action_melee_start_special",
					chain_time = 0.45,
				},
				{
					action_name = "action_melee_start_left",
					chain_time = 0.45,
				},
			},
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.warp,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.warp,
		fx = {
			fx_source = "fx_left_hand_offset_fwd",
			vfx_effect = "content/fx/particles/weapons/swords/forcesword/psyker_parry",
		},
		haptic_trigger_template = HapticTriggerTemplates.melee.push,
	},
	action_find_target = {
		allowed_during_sprint = false,
		charge_template = "forcesword_p1_m1_charge_single_target",
		kind = "target_finder",
		prevent_sprint = true,
		sprint_ready_up_time = 0.25,
		stop_input = "find_target_release",
		target_finder_module_class_name = "smart_target_targeting",
		total_time = 0.15,
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.1,
			},
			{
				modifier = 0.4,
				t = 0.15,
			},
			{
				modifier = 0.6,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 1,
			},
			start_modifier = 1,
		},
		targeting_fx = {
			effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge",
			has_husk_events = false,
			husk_effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge_husk",
			wwise_event_start = "wwise/events/weapon/play_force_staff_single_target",
			wwise_event_stop = "wwise/events/weapon/stop_force_staff_single_target",
			wwise_parameter_name = "charge_level",
		},
		smart_targeting_template = SmartTargetingTemplates.force_sword_single_target,
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "fling_target",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			fling_target = {
				action_name = "action_fling_target",
				chain_time = 0.1,
			},
			block = {
				action_name = "action_block",
			},
		},
	},
	action_fling_target = {
		anim_event = "parry_push_finish",
		charge_template = "forcesword_p1_m1_fling",
		kind = "damage_target",
		pay_warp_charge_time = 0.15,
		prevent_sprint = true,
		total_time = 0.7,
		use_charge_level = false,
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
				{
					action_name = "action_melee_start_special",
					chain_time = 0.45,
				},
				{
					action_name = "action_melee_start_push_follow_combo",
					chain_time = 0.45,
				},
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.45,
			},
		},
		damage_profile = DamageProfileTemplates.force_sword_push_followup_fling,
		damage_type = damage_types.warp,
		herding_template = HerdingTemplates.force_push,
		fx = {
			fx_source = "fx_left_hand_offset_fwd",
			vfx_effect = "content/fx/particles/weapons/swords/forcesword/psyker_push",
		},
	},
	action_melee_start_push_follow_combo = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_stab",
		chain_anim_event = "heavy_charge_stab",
		chain_anim_event_3p = "heavy_charge_stab",
		kind = "windup",
		sprint_enabled_time = 0.5,
		sprint_ready_up_time = 0,
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.65,
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
				t = 1.5,
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
				action_name = "action_light_stab",
			},
			heavy_attack = {
				action_name = "action_heavy_stab",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special",
			},
			vent = {
				action_name = "action_vent",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_stab = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_stab_pushfollow",
		anim_event_3p = "attack_stab_01",
		attack_direction_override = "push",
		charge_template = "forcesword_p1_m1_weapon_special_hit",
		damage_window_end = 0.23333333333333334,
		damage_window_start = 0.16666666666666666,
		first_person_hit_anim = "hit_left_down_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.5,
		total_time = 0.9,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
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
				chain_time = 0.42,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.38,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.38,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.38,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = base_sweep_box,
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/attack_stab_pushfollow",
			anchor_point_offset = {
				0.1,
				0,
				-0.1,
			},
		},
		damage_profile = DamageProfileTemplates.light_force_sword_stab_2h,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.default,
	},
	action_heavy_stab = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_stab",
		attack_direction_override = "push",
		charge_template = "forcesword_p1_m1_weapon_special_hit",
		damage_window_end = 0.16666666666666666,
		damage_window_start = 0.11666666666666667,
		first_person_hit_anim = "hit_down_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.5,
		total_time = 0.8,
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
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.45,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.45,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = base_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/heavy_attack_stab",
			anchor_point_offset = {
				0,
				0,
				-0.1,
			},
		},
		damage_profile = DamageProfileTemplates.heavy_force_sword_stab_2h,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.default,
	},
	action_vent = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_end_event = "vent_end",
		anim_event = "vent_start",
		kind = "vent_warp_charge",
		prevent_sprint = true,
		start_input = "vent",
		stop_input = "vent_release",
		uninterruptible = true,
		vent_source_name = "fx_left_hand",
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		vo_tag = "ability_venting",
		weapon_handling_template = "time_scale_1",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.1,
			},
			{
				modifier = 0.3,
				t = 0.15,
			},
			{
				modifier = 0.5,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 5,
			},
			start_modifier = 1,
		},
		running_action_state_to_action_input = {
			fully_vented = {
				input_name = "vent_release",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
		},
		haptic_trigger_template = HapticTriggerTemplates.melee.none,
	},
	action_activate_special = {
		activation_cooldown = 3,
		activation_time = 0.5,
		allowed_during_sprint = true,
		anim_end_event = "activate_end",
		anim_event = "activate",
		charge_template = "forcesword_2h_p1_m1_weapon_special",
		kind = "activate_special",
		skip_3p_anims = false,
		start_input = "special_action",
		total_time = 2.1,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			start_attack = {
				action_name = "action_melee_start_special",
				chain_time = 0.7,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
		},
	},
	action_melee_start_special = {
		action_priority = 5,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left",
		chain_anim_event = "heavy_charge_left",
		chain_anim_event_3p = "heavy_charge_left",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		sprint_enabled_time = 0.5,
		sprint_ready_up_time = 0,
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.65,
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
				t = 1.5,
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
				action_name = "action_left_light_special",
			},
			heavy_attack = {
				action_name = "action_left_heavy_special",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_left_light_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_special",
		anim_event_3p = "heavy_attack_left",
		charge_template = "forcesword_p1_m1_weapon_special_hit",
		damage_window_end = 0.43333333333333335,
		damage_window_start = 0.26666666666666666,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.5,
		total_time = 1.3,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.15,
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
				chain_time = 0.85,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.85,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.95,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.85,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = base_sweep_box,
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/heavy_attack_left_special",
			anchor_point_offset = {
				0,
				0,
				-0.125,
			},
		},
		damage_profile = DamageProfileTemplates.light_force_sword_2h_special,
		damage_type = damage_types.force_sword_cleave,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean,
		wounds_shape_special_active = wounds_shapes.horizontal_slash_clean,
	},
	action_left_heavy_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_special",
		anim_event_3p = "heavy_attack_left",
		charge_template = "forcesword_p1_m1_weapon_special_hit",
		damage_window_end = 0.43333333333333335,
		damage_window_start = 0.26666666666666666,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.5,
		total_time = 1.2,
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
				chain_time = 0.87,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.87,
			},
			special_action = {
				action_name = "action_activate_special",
				chain_time = 0.95,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.87,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = base_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_force_sword/heavy_attack_left_special",
			anchor_point_offset = {
				0,
				0,
				0,
			},
		},
		damage_profile = DamageProfileTemplates.heavy_force_sword_2h_special,
		damage_type = damage_types.force_sword_cleave,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean,
		wounds_shape_special_active = wounds_shapes.horizontal_slash_clean,
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/2h_force_sword"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/2h_force_sword"
weapon_template.weapon_box = base_sweep_box
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.weapon_special_class = "WeaponSpecialKillCountCharges"
weapon_template.weapon_special_tweak_data = {
	active_duration = 3,
	charge_remove_time = 8.5,
	clear_charges_on_activation = true,
	keep_active_on_sprint = true,
	keep_active_on_stun = true,
	keep_charges_on_active_duration_end = true,
	max_charges = 20,
	num_charges_to_remove = 1,
	set_inactive_func = function (inventory_slot_component, reason, tweak_data)
		local keep_special_active = reason == "started_sprint" or reason == "ledge_vaulting" or reason == "stunned"

		if not keep_special_active then
			inventory_slot_component.special_active = false
		end

		local keep_num_special_charges = reason ~= "dead"

		if not keep_num_special_charges then
			inventory_slot_component.num_special_charges = 0
		end

		return not keep_special_active
	end,
	thresholds = {
		{
			name = "low",
			threshold = 0,
		},
		{
			name = "middle",
			threshold = 10,
		},
		{
			name = "high",
			threshold = 20,
		},
	},
	slash_settings = {
		attack_type = "shout",
		dot_check = 0.9,
		hit_zone_name = "torso",
		particle_alias = "wind_slash",
		range = 30,
		sound_alias = "wind_slash",
		start_time = 0.25,
		target_enemies = true,
		thickness = 0.25,
		total_time = 0.75,
		levels = {
			low = {
				buff_to_add = "forcesword_wind_slash_weapon_special_trigger_low",
				damage_profile = DamageProfileTemplates.forcesword_force_slash_low,
				damage_type = damage_types.forcesword_force_slash_low,
			},
			middle = {
				buff_to_add = "forcesword_wind_slash_weapon_special_trigger_middle",
				damage_profile = DamageProfileTemplates.forcesword_force_slash_middle,
				damage_type = damage_types.forcesword_force_slash_middle,
			},
			high = {
				buff_to_add = "forcesword_wind_slash_weapon_special_trigger_high",
				damage_profile = DamageProfileTemplates.forcesword_force_slash_high,
				damage_type = damage_types.forcesword_force_slash_high,
			},
		},
	},
}
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
weapon_template.weapon_counter = {
	show_when_unwielded = false,
	weapon_counter_type = "kill_charges",
}
weapon_template.keywords = {
	"melee",
	"force_sword",
	"p1",
	"activated",
}
weapon_template.dodge_template = "psyker_heavy"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "linesman_rangedblock"
weapon_template.toughness_template = "default"
weapon_template.warp_charge_template = "forcesword_2h"
weapon_template.movement_curve_modifier_template = "forcesword_2h"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.forcesword
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.medium
weapon_template.overclocks = {
	warp_charge_cost_up_dps_down = {
		forcesword_p1_m1_dps_stat = -0.1,
		forcesword_p1_m1_warp_charge_cost_stat = 0.1,
	},
	finesse_up_warp_charge_cost_down = {
		forcesword_p1_m1_finesse_stat = 0.2,
		forcesword_p1_m1_warp_charge_cost_stat = -0.2,
	},
	first_target_up_warp_charge_cost_down = {
		forcesword_p1_m1_first_target_stat = 0.1,
		forcesword_p1_m1_warp_charge_cost_stat = -0.1,
	},
	mobility_up_first_target_down = {
		forcesword_p1_m1_first_target_stat = -0.1,
		forcesword_p1_m1_mobility_stat = 0.1,
	},
	dps_up_mobility_down = {
		forcesword_p1_m1_dps_stat = 0.1,
		forcesword_p1_m1_mobility_stat = -0.1,
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	forcesword_2h_p1_m2_dps_stat = {
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
			action_heavy_3 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_stab = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_3 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_left_light_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_left_heavy_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_sprint = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_sprint = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_stab = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	forcesword_2h_p1_m2_weapon_special_warp_charge_cost = {
		display_name = "loc_stats_display_warp_resist_stat",
		is_stat_trait = true,
		charge = {
			action_activate_special = {
				charge_trait_templates.forcesword_2h_p1_m1_weapon_special_warp_charge_cost,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	forcesword_2h_p1_m2_finesse_stat = {
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
			action_heavy_3 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_heavy_stab = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_3 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_left_light_special = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_left_heavy_special = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_sprint = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_heavy_sprint = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_stab = {
				damage_trait_templates.default_melee_finesse_stat,
			},
		},
		weapon_handling = {
			action_light_1 = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						time_scale = {},
					},
				},
			},
			action_heavy_1 = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						time_scale = {},
					},
				},
			},
			action_light_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_heavy_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_heavy_3 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_heavy_stab = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_3 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_4 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_left_light_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_left_heavy_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_sprint = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_heavy_sprint = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_stab = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
		},
	},
	forcesword_2h_p1_m2_cleave_damage_stat = {
		display_name = "loc_stats_display_cleave_damage_stat",
		is_stat_trait = true,
		damage = {
			action_heavy_1 = {
				damage_trait_templates.powersword_cleave_damage_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_heavy_2 = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_heavy_3 = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_heavy_stab = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_light_1 = {
				damage_trait_templates.powersword_cleave_damage_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_light_2 = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_light_3 = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_light_4 = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_left_light_special = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_left_heavy_special = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_light_sprint = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_heavy_sprint = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
			action_light_stab = {
				damage_trait_templates.powersword_cleave_damage_stat,
			},
		},
	},
	forcesword_2h_p1_m2_defence_stat = {
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

local bespoke_forcesword_2h_p1_traits = table.ukeys(WeaponTraitsBespokeForcesword2hP1)

table.append(weapon_template.traits, bespoke_forcesword_2h_p1_traits)

weapon_template.buffs = {
	on_equip = {
		"forcesword_wind_slash_weapon_special_primer",
	},
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control",
	},
	{
		display_name = "loc_weapon_keyword_warp_weapon",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_linesman",
		type = "linesman",
		attack_chain = {
			"linesman",
			"linesman",
			"linesman",
			"linesman",
		},
	},
	secondary = {
		display_name = "loc_gestalt_linesman",
		type = "linesman",
		attack_chain = {
			"linesman",
			"smiter",
			"smiter",
		},
	},
	special = {
		desc = "loc_stats_special_action_powerup_forcesword_2h_desc",
		display_name = "loc_forcesword_2h_weapon_special",
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

weapon_template.weapon_special_action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local scenario_system = Managers.state.extension:system("scripted_scenario_system")
	local correct_scenario = scenario_system:get_current_scenario_name() == "weapon_special"
	local player_unit = player.player_unit
	local unit_data_ext = ScriptUnit.extension(player_unit, "unit_data_system")
	local inventory_slot_component = unit_data_ext:read_component(wielded_slot_id)
	local special_active = inventory_slot_component.special_active

	return correct_scenario and not special_active
end

weapon_template.weapon_special_action_revved_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local scenario_system = Managers.state.extension:system("scripted_scenario_system")
	local correct_scenario = scenario_system:get_current_scenario_name() == "weapon_special"
	local player_unit = player.player_unit
	local unit_data_ext = ScriptUnit.extension(player_unit, "unit_data_system")
	local inventory_slot_component = unit_data_ext:read_component(wielded_slot_id)
	local special_active = inventory_slot_component.special_active

	return correct_scenario and special_active
end

return weapon_template
