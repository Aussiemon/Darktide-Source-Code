-- chunkname: @scripts/settings/equipment/weapon_templates/ogryn_hammers_2h/ogryn_hammer_2h_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MeleeActionInputSetupSlow = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_slow")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeOgrynHammer2hP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_hammer_2h_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local buff_stat_buffs = BuffSettings.stat_buffs
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local hit_zone_names = HitZone.hit_zone_names
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}

weapon_template.action_inputs = {
	wield = {
		buffer_time = 0.4,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
	start_attack = {
		buffer_time = 0.4,
		max_queue = 1,
		reevaluation_time = 0.18,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	attack_cancel = {
		buffer_time = 0.1,
		input_sequence = {
			{
				hold_input = "action_one_hold",
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	light_attack = {
		buffer_time = 0.3,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_one_hold",
				time_window = 0.35,
				value = false,
			},
		},
	},
	heavy_attack = {
		buffer_time = 0.5,
		max_queue = 1,
		input_sequence = {
			{
				duration = 0.35,
				input = "action_one_hold",
				value = true,
			},
			{
				auto_complete = true,
				input = "action_one_hold",
				time_window = 1.6,
				value = false,
			},
		},
	},
	attack_release = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	block = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
			},
		},
	},
	block_release = {
		buffer_time = 0.35,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_two_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	push = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "action_two_hold",
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	push_follow_up = {
		buffer_time = 0.3,
		input_sequence = {
			{
				duration = 0.3,
				hold_input = "action_two_hold",
				input = "action_one_hold",
				value = true,
			},
		},
	},
	push_follow_up_release = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				inputs = {
					{
						input = "action_one_hold",
						value = false,
					},
					{
						input = "action_two_hold",
						value = false,
					},
				},
				time_window = math.huge,
			},
		},
	},
	push_follow_up_early_release = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	special_action = {
		buffer_time = 0.4,
		max_queue = 1,
		input_sequence = {
			{
				input = "weapon_extra_pressed",
				value = true,
			},
		},
	},
	start_attack_special = {
		buffer_time = 0.4,
		max_queue = 1,
		reevaluation_time = 0.18,
		input_sequence = {
			{
				input = "weapon_extra_hold",
				value = true,
			},
		},
	},
	attack_cancel_special = {
		buffer_time = 0.1,
		input_sequence = {
			{
				hold_input = "weapon_extra_hold",
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	light_attack_special = {
		buffer_time = 0.3,
		max_queue = 1,
		input_sequence = {
			{
				input = "weapon_extra_hold",
				time_window = 0.35,
				value = false,
			},
		},
	},
	heavy_attack_special = {
		buffer_time = 0.5,
		max_queue = 1,
		input_sequence = {
			{
				duration = 0.35,
				input = "weapon_extra_hold",
				value = true,
			},
			{
				auto_complete = true,
				input = "weapon_extra_hold",
				time_window = 1.6,
				value = false,
			},
		},
	},
	attack_release_special = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				input = "weapon_extra_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupSlow.action_input_hierarchy)

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
		input = "block",
		transition = "base",
	},
}

ActionInputHierarchy.update_hierarchy_entry(weapon_template.action_input_hierarchy, "start_attack", new_start_attack_action_transition)

local new_start_attack_special_action_transition = {
	{
		input = "attack_cancel_special",
		transition = "base",
	},
	{
		input = "light_attack_special",
		transition = "base",
	},
	{
		input = "heavy_attack_special",
		transition = "base",
	},
	{
		input = "wield",
		transition = "base",
	},
	{
		input = "block",
		transition = "base",
	},
}

ActionInputHierarchy.update_hierarchy_entry(weapon_template.action_input_hierarchy, "start_attack_special", new_start_attack_special_action_transition)

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
}

ActionInputHierarchy.update_hierarchy_entry(weapon_template.action_input_hierarchy, "block", new_block_action_transition)

local default_weapon_box = {
	0.225,
	0.225,
	1.25,
}
local light_weapon_box = {
	0.2,
	0.2,
	1.25,
}
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

weapon_template.actions = {
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "equip",
		kind = "wield",
		sprint_ready_up_time = 0,
		total_time = 0.5,
		uninterruptible = true,
		allowed_chain_actions = {
			block = {
				action_name = "action_block",
			},
			start_attack = {
				action_name = "action_melee_start_1",
				chain_time = 0.2,
			},
			start_attack_special = {
				action_name = "action_melee_start_1_special",
				chain_time = 0.35,
			},
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
		},
	},
	action_melee_start_1 = {
		action_priority = 1,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left",
		anim_event_3p = "attack_swing_charge_left",
		kind = "windup",
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 3,
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
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			light_attack = {
				action_name = "action_light_1",
			},
			heavy_attack = {
				action_name = "action_heavy_1",
				chain_time = 0.76,
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
		anim_event = "attack_down_left",
		anim_event_3p = "attack_swing_down_left_slow",
		attack_direction_override = "down",
		damage_window_end = 0.55,
		damage_window_start = 0.43333333333333335,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.38,
		start_input = nil,
		total_time = 2,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.11,
			},
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 1.5,
				t = 0.19,
			},
			{
				modifier = 1.4,
				t = 0.31,
			},
			{
				modifier = 1,
				t = 0.38,
			},
			{
				modifier = 0.5,
				t = 0.46,
			},
			{
				modifier = 1,
				t = 0.77,
			},
			start_modifier = 0.2,
		},
		allowed_chain_actions = {
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			block = {
				action_name = "action_block",
			},
			start_attack = {
				action_name = "action_melee_start_2",
				chain_time = 0.8,
			},
			start_attack_special = {
				action_name = "action_melee_start_2_special",
				chain_time = 0.8,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = light_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/2h_hammer/attack_down_left",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_hammer_light_smiter,
		damage_type = damage_types.ogryn_2h_hammer,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_heavy_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left",
		anim_event_3p = "attack_swing_heavy_left",
		attack_direction_override = "left",
		damage_window_end = 0.21666666666666667,
		damage_window_start = 0.1,
		first_person_hit_anim = "hit_left_down_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.33,
		start_input = nil,
		total_time = 2,
		uninterruptible = true,
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
			wield = BaseTemplateSettings.generate_wield_chain_actions({
				chain_time = 0.5,
			}),
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			start_attack = {
				action_name = "action_melee_start_2",
				chain_time = 0.6,
			},
			start_attack_special = {
				action_name = "action_melee_start_2_special",
				chain_time = 0.6,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/2h_hammer/heavy_attack_left",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_hammer_heavy_tank,
		damage_type = damage_types.ogryn_2h_hammer_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right",
		anim_event_3p = "attack_swing_charge_right",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_stop_anim = "attack_hit_shield",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
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
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			light_attack = {
				action_name = "action_light_2",
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.675,
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
		anim_event = "attack_right_diagonal",
		anim_event_3p = "attack_swing_right_diagonal",
		attack_direction_override = "right",
		damage_window_end = 0.55,
		damage_window_start = 0.4166666666666667,
		first_person_hit_anim = "hit_down_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		start_input = nil,
		total_time = 2,
		weapon_handling_template = "time_scale_1_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.11,
			},
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 1.5,
				t = 0.19,
			},
			{
				modifier = 1.4,
				t = 0.31,
			},
			{
				modifier = 1,
				t = 0.38,
			},
			{
				modifier = 0.5,
				t = 0.46,
			},
			{
				modifier = 1,
				t = 0.77,
			},
			start_modifier = 0.2,
		},
		allowed_chain_actions = {
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			block = {
				action_name = "action_block",
			},
			start_attack = {
				action_name = "action_melee_start_3",
				chain_time = 0.76,
			},
			start_attack_special = {
				action_name = "action_melee_start_1_special",
				chain_time = 0.8,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = light_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/2h_hammer/attack_right_diagonal_down",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_hammer_light_tank,
		damage_type = damage_types.ogryn_2h_hammer,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_heavy_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right",
		anim_event_3p = "attack_swing_heavy_right",
		attack_direction_override = "right",
		damage_window_end = 0.20833333333333334,
		damage_window_start = 0.08333333333333333,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.3,
		start_input = nil,
		total_time = 2,
		uninterruptible = true,
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
			wield = BaseTemplateSettings.generate_wield_chain_actions({
				chain_time = 0.5,
			}),
			block = {
				action_name = "action_block",
				chain_time = 0.525,
			},
			start_attack = {
				action_name = "action_melee_start_3",
				chain_time = 0.6,
			},
			start_attack_special = {
				action_name = "action_melee_start_1_special",
				chain_time = 0.6,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/2h_hammer/heavy_attack_right",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_hammer_heavy_tank,
		damage_type = damage_types.ogryn_2h_hammer_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left",
		anim_event_3p = "attack_swing_charge_left",
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "hit_left_shake",
		hit_stop_anim = "attack_hit_shield",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
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
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			light_attack = {
				action_name = "action_light_3",
			},
			heavy_attack = {
				action_name = "action_heavy_1",
				chain_time = 0.77,
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
		anim_event = "attack_left_diagonal_up",
		anim_event_3p = "attack_swing_up_left_slow",
		attack_direction_override = "up",
		damage_window_end = 0.5333333333333333,
		damage_window_start = 0.4625,
		first_person_hit_anim = "hit_down_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.35,
		start_input = nil,
		total_time = 2,
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
		allowed_chain_actions = {
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			block = {
				action_name = "action_block",
			},
			start_attack = {
				action_name = "action_melee_start_4",
				chain_time = 1,
			},
			start_attack_special = {
				action_name = "action_melee_start_2_special",
				chain_time = 1,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = light_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/2h_hammer/attack_left_diagonal_up",
				anchor_point_offset = {
					-0.15,
					0,
					-0.15,
				},
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_hammer_light_smiter_plus,
		damage_type = damage_types.ogryn_2h_hammer,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_4 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right",
		anim_event_3p = "attack_swing_charge_down",
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "hit_left_shake",
		hit_stop_anim = "attack_hit_shield",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
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
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			light_attack = {
				action_name = "action_light_4",
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.675,
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
		anim_event = "attack_down_right",
		anim_event_3p = "attack_swing_down_slow",
		attack_direction_override = "down",
		damage_window_end = 0.525,
		damage_window_start = 0.4166666666666667,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.38,
		start_input = nil,
		total_time = 2,
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
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			block = {
				action_name = "action_block",
			},
			start_attack = {
				action_name = "action_melee_start_1",
				chain_time = 0.84,
			},
			start_attack_special = {
				action_name = "action_melee_start_1_special",
				chain_time = 0.85,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = light_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/2h_hammer/attack_down_right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_hammer_light_smiter,
		damage_type = damage_types.ogryn_2h_hammer,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_slide = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left",
		anim_event_3p = "attack_swing_charge_left",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 3,
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
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			light_attack = {
				action_name = "action_light_3",
			},
			heavy_attack = {
				action_name = "action_heavy_1",
				chain_time = 0.85,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.movement_state_component.method == "sliding"
		end,
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
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			push = {
				action_name = "action_push",
				chain_time = 0.25,
			},
		},
	},
	action_push = {
		activation_cooldown = 0.2,
		anim_event = "attack_push",
		block_duration = 0.5,
		kind = "push",
		power_level = 500,
		push_radius = 3,
		start_input = nil,
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
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			push_follow_up = {
				action_name = "action_pushfollow",
				chain_time = 0.35,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			start_attack = {
				action_name = "action_melee_start_1",
				chain_time = 0.4,
			},
			start_attack_special = {
				action_name = "action_melee_start_1_special",
				chain_time = 0.4,
			},
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.ogryn_push,
		inner_damage_type = damage_types.ogryn_physical,
		outer_damage_profile = DamageProfileTemplates.default_push,
		outer_damage_type = damage_types.ogryn_physical,
		haptic_trigger_template = HapticTriggerTemplates.melee.push,
	},
	action_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left",
		anim_event_3p = "attack_pushfollow_v02",
		attack_direction_override = "left",
		damage_window_end = 0.55,
		damage_window_start = 0.43333333333333335,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.35,
		start_input = nil,
		total_time = 2,
		weapon_handling_template = "time_scale_1_1",
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.1,
			},
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 0.45,
				t = 0.24,
			},
			{
				modifier = 0.6,
				t = 0.32,
			},
			{
				modifier = 1,
				t = 0.6,
			},
			start_modifier = 1.4,
		},
		allowed_chain_actions = {
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			block = {
				action_name = "action_block",
				chain_time = 0.7,
			},
			start_attack = {
				action_name = "action_melee_start_2",
				chain_time = 0.6,
			},
			start_attack_special = {
				action_name = "action_melee_start_2_special",
				chain_time = 0.7,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/2h_hammer/attack_left",
				anchor_point_offset = {
					0,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_hammer_pushfollowup,
		damage_type = damage_types.ogryn_2h_hammer,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_1_special = {
		action_priority = 3,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_left",
		anim_event_3p = "attack_swing_charge_down",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = "start_attack_special",
		stop_input = "attack_cancel_special",
		total_time = 3,
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
				modifier = 0.6,
				t = 1,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			light_attack_special = {
				action_name = "action_light_1",
			},
			heavy_attack_special = {
				action_name = "action_heavy_1_special",
				chain_time = 0.8,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_heavy_1_special = {
		activate_special_during_sweep = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_down",
		anim_event_3p = "attack_swing_heavy_down",
		attack_direction_override = "down",
		damage_window_end = 0.5333333333333333,
		damage_window_start = 0.44166666666666665,
		first_person_hit_anim = "hit_left_down_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.45,
		start_input = nil,
		total_time = 2,
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
			wield = BaseTemplateSettings.generate_wield_chain_actions({
				chain_time = 0.8,
			}),
			block = {
				action_name = "action_block",
				chain_time = 0.8,
			},
			start_attack = {
				action_name = "action_melee_start_2",
				chain_time = 0.9,
			},
			start_attack_special = {
				action_name = "action_melee_start_2_special",
				chain_time = 0.9,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/2h_hammer/attack_down",
				anchor_point_offset = {
					-0.1,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_hammer_heavy_smiter,
		damage_type = damage_types.ogryn_2h_hammer_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_2_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_right",
		anim_event_3p = "attack_swing_charge_down_right",
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "hit_left_shake",
		hit_stop_anim = "attack_hit_shield",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel_special",
		total_time = 3,
		weapon_handling_template = "time_scale_1",
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
				modifier = 0.6,
				t = 1,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			wield = BaseTemplateSettings.generate_wield_chain_actions(),
			light_attack_special = {
				action_name = "action_light_4",
			},
			heavy_attack_special = {
				action_name = "action_heavy_2_special",
				chain_time = 0.8,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_heavy_2_special = {
		activate_special_during_sweep = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "special_attack_down_right",
		anim_event_3p = "attack_swing_heavy_down",
		attack_direction_override = "down",
		damage_window_end = 0.5666666666666667,
		damage_window_start = 0.4583333333333333,
		first_person_hit_anim = "hit_left_down_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.45,
		start_input = nil,
		total_time = 2,
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
			wield = BaseTemplateSettings.generate_wield_chain_actions({
				chain_time = 0.4,
			}),
			block = {
				action_name = "action_block",
				chain_time = 0.7,
			},
			start_attack = {
				action_name = "action_melee_start_3",
				chain_time = 0.725,
			},
			start_attack_special = {
				action_name = "action_melee_start_1_special",
				chain_time = 0.725,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/2h_hammer/special_attack_down_right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.ogryn_hammer_heavy_smiter,
		damage_type = damage_types.ogryn_2h_hammer_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_inspect = {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		chain_anim_event = "alternative_inspect_stop",
		kind = "inspect",
		lock_view = true,
		skip_3p_anims = false,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete" or data.new_action_kind == "inspect_3p"
		end,
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
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_inspect_alt = {
		anim_end_event = "inspect_end",
		anim_event = "alternative_inspect_start",
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
	action_inspect_3p = BaseTemplateSettings.generate_inspect_3p_action(nil, "inspect_start"),
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/2h_axe"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/2h_hammer"
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
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
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
	"hammer",
	"p1",
}
weapon_template.damage_trait_templates = "ogryn"
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn_sprint_slow"
weapon_template.stamina_template = "tank_pickaxe_m1"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_combat_pickaxe
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.heavy

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	ogryn_hammer_2h_p1_m1_dps_stat = {
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
			action_pushfollow = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	ogryn_hammer_2h_p1_m1_armor_pierce_stat = {
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
			action_light_3 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
		},
	},
	ogryn_hammer_2h_p1_m1_defence_stat = {
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
	ogryn_hammer_2h_p1_m1_first_target_stat = {
		display_name = "loc_stats_display_first_target_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.default_first_target_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_heavy_1 = {
				damage_trait_templates.default_first_target_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_light_2 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_3 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.default_first_target_stat,
			},
		},
	},
	ogryn_hammer_2h_p1_m1_control_stat = {
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
						stagger_duration_modifier = {},
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
						stagger_duration_modifier = {},
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
			action_pushfollow = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.thunderhammer_control_stat,
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
			action_light_3 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_4 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_heavy_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_heavy_1_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_heavy_2_special = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
		},
	},
}
weapon_template.traits = {}

local bespoke_ogryn_hammer_2h_p1 = table.ukeys(WeaponTraitsBespokeOgrynHammer2hP1)

table.append(weapon_template.traits, bespoke_ogryn_hammer_2h_p1)

weapon_template.buffs = {
	on_equip = {
		"windup_increases_power_default_four_steps_parent",
	},
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_heavy_windup",
	},
	{
		display_name = "loc_weapon_keyword_high_damage",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"tank",
			"tank",
			"smiter",
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
		desc = "loc_stats_special_action_ogryn_hammer_2h_p1_desc",
		display_name = "loc_weapon_special_special_attack",
		type = "special_attack",
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
		header = "special_attack",
		icon = "special_attack",
	},
}

weapon_template.weapon_special_action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local scenario_system = Managers.state.extension:system("scripted_scenario_system")
	local correct_scenario = scenario_system:get_current_scenario_name() == "weapon_special"
	local player_unit = player.player_unit
	local unit_data_ext = ScriptUnit.extension(player_unit, "unit_data_system")
	local inventory_slot_component = unit_data_ext:read_component(wielded_slot_id)
	local special_active = inventory_slot_component.special_active

	return correct_scenario and not special_active and (not current_action_name or current_action_name == "none")
end

weapon_template.special_action_name = "action_heavy_1_special"

weapon_template.action_inspect_3p_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect_3p"
end

weapon_template.action_inspect_3p_base_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect"
end

return weapon_template
