-- chunkname: @scripts/settings/equipment/weapon_templates/thunder_hammers_2h/thunderhammer_2h_p1_m2.lua

local AimAssistTemplates = require("scripts/settings/equipment/aim_assist_templates")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local MeleeActionInputSetupMid = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_mid")
local PushSettings = require("scripts/settings/damage/push_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeThunderhammerP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_thunderhammer_2h_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local push_templates = PushSettings.push_templates
local template_types = WeaponTweakTemplateSettings.template_types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}

weapon_template.action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs)
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)
weapon_template.action_inputs.block.buffer_time = 0.1
weapon_template.action_inputs.block_release.buffer_time = 0.35

local default_weapon_box = {
	0.2,
	0.15,
	1.2,
}
local _force_abort_breed_tags_special_active = {
	"elite",
	"special",
	"monster",
	"captain",
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
		anim_event = "equip",
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
				action_name = "action_activate_special_left",
			},
		},
	},
	action_melee_start_left = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_left_pose",
		kind = "windup",
		proc_time_interval = 0.2,
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
				chain_time = 0.6,
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
	action_left_down_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_left_diagonal_v01",
		anim_event_3p = "attack_swing_left_diagonal",
		damage_window_end = 0.4666666666666667,
		damage_window_start = 0.36666666666666664,
		disorientation_type = "thunder_hammer_m2_light",
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.35,
		special_active_hit_stop_anim = "attack_hit_power",
		special_active_hit_stop_anim_3p = "attack_hit_power",
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
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
				chain_until = 0.2,
			},
			special_action = {
				action_name = "action_activate_special_right",
				chain_time = 0.5,
			},
		},
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/swing_left_diagonal_v01",
				anchor_point_offset = {
					0.65,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.thunderhammer_light_linesman,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_light_linesman_active_sweep,
		damage_profile_special_active_on_abort = DamageProfileTemplates.thunderhammer_m2_light_active,
		damage_type_special_active = damage_types.blunt_thunder,
		damage_type_special_active_on_abort = damage_types.blunt_thunder,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		herding_template = HerdingTemplates.linesman_left_heavy,
		anim_end_event_condition_func = function (unit, data, end_reason)
			if data and data.self_stun then
				return false
			end

			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing,
	},
	action_left_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_heavy_left",
		damage_window_end = 0.5,
		damage_window_start = 0.36666666666666664,
		disorientation_type = "thunder_hammer_m2_heavy",
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.32,
		special_active_hit_stop_anim = "attack_hit_power",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		total_time = 1.75,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_1",
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.1,
			},
			{
				modifier = 1.25,
				t = 0.15,
			},
			{
				modifier = 1.35,
				t = 0.25,
			},
			{
				modifier = 1.35,
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
			start_modifier = 0.5,
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
				chain_time = 0.65,
				chain_until = 0.2,
			},
			special_action = {
				action_name = "action_activate_special_right",
				chain_time = 0.65,
			},
		},
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/heavy_swing_left",
				anchor_point_offset = {
					0,
					0,
					0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.thunderhammer_heavy,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_heavy_active_sweep,
		damage_profile_special_active_on_abort = DamageProfileTemplates.thunderhammer_m2_heavy_active,
		damage_type_special_active = damage_types.blunt_thunder,
		damage_type_special_active_on_abort = damage_types.blunt_thunder,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
		anim_end_event_condition_func = function (unit, data, end_reason)
			if data and data.self_stun then
				return false
			end

			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing_heavy,
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_right_pose",
		kind = "windup",
		proc_time_interval = 0.2,
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
				chain_time = 0.15,
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.6,
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
	action_right_down_light = {
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_right_down",
		anim_event_3p = "attack_swing_right_diagonal",
		attack_direction_override = "push",
		damage_window_end = 0.5333333333333333,
		damage_window_start = 0.43333333333333335,
		disorientation_type = "thunder_hammer_m2_light",
		first_person_hit_anim = "hit_right_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.32,
		special_active_hit_stop_anim = "attack_hit_power",
		special_active_hit_stop_anim_3p = "attack_hit_power",
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
				chain_time = 0.7,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
				chain_until = 0.2,
			},
			special_action = {
				action_name = "action_activate_special_left_2",
				chain_time = 0.5,
			},
		},
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/swing_right_down",
				anchor_point_offset = {
					-0.15,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.thunderhammer_light,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_light,
		damage_profile_special_active_on_abort = DamageProfileTemplates.thunderhammer_m2_light_active,
		damage_type_special_active = damage_types.blunt_thunder,
		damage_type_special_active_on_abort = damage_types.blunt_thunder,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		anim_end_event_condition_func = function (unit, data, end_reason)
			if data and data.self_stun then
				return false
			end

			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing,
	},
	action_right_heavy = {
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_heavy_right",
		anim_event_3p = "attack_swing_heavy_right",
		damage_window_end = 0.5,
		damage_window_start = 0.3333333333333333,
		disorientation_type = "thunder_hammer_m2_heavy",
		first_person_hit_anim = "hit_right_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.2,
		special_active_hit_stop_anim = "attack_hit_power",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		total_time = 1.75,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_1",
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.1,
			},
			{
				modifier = 1.25,
				t = 0.15,
			},
			{
				modifier = 1.35,
				t = 0.25,
			},
			{
				modifier = 1.35,
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
			start_modifier = 0.5,
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
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.65,
				chain_until = 0.2,
			},
			special_action = {
				action_name = "action_activate_special_left",
				chain_time = 0.65,
			},
		},
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/heavy_swing_right",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.thunderhammer_heavy,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_heavy_active_sweep,
		damage_profile_special_active_on_abort = DamageProfileTemplates.thunderhammer_m2_heavy_active,
		damage_type_special_active = damage_types.blunt_thunder,
		damage_type_special_active_on_abort = damage_types.blunt_thunder,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
		anim_end_event_condition_func = function (unit, data, end_reason)
			if data and data.self_stun then
				return false
			end

			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing_heavy,
	},
	action_melee_start_left_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_left_down_pose",
		anim_event_3p = "attack_swing_charge_left_down",
		kind = "windup",
		proc_time_interval = 0.2,
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
				action_name = "action_left_down_light",
				chain_time = 0.15,
			},
			heavy_attack = {
				action_name = "action_left_heavy_2",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special_left_2",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_melee_start_left_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_charge_left_down_pose",
		anim_event_3p = "attack_swing_charge_left_down",
		kind = "windup",
		proc_time_interval = 0.2,
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
				chain_time = 0.15,
			},
			heavy_attack = {
				action_name = "action_left_heavy_2",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_activate_special_left_2",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_heavy_2 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_heavy_left_down",
		damage_window_end = 0.4666666666666667,
		damage_window_start = 0.38333333333333336,
		disorientation_type = "thunder_hammer_m2_heavy",
		first_person_hit_anim = "hit_down_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.3,
		special_active_hit_stop_anim = "attack_hit_power",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		total_time = 1.75,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_1",
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
				action_name = "action_melee_start_left",
				chain_time = 0.9,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.65,
				chain_until = 0.2,
			},
			special_action = {
				action_name = "action_activate_special_right",
				chain_time = 0.65,
			},
		},
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/heavy_swing_left_down",
				anchor_point_offset = {
					0.2,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.thunderhammer_heavy_smiter,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_heavy_active_sweep,
		damage_profile_special_active_on_abort = DamageProfileTemplates.thunderhammer_m2_heavy_active_strikedown,
		damage_type_special_active = damage_types.blunt_thunder,
		damage_type_special_active_on_abort = damage_types.blunt_thunder,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		anim_end_event_condition_func = function (unit, data, end_reason)
			if data and data.self_stun then
				return false
			end

			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing,
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
				action_name = "action_activate_special_left",
			},
		},
	},
	action_left_light_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_swing_left",
		damage_window_end = 0.43333333333333335,
		damage_window_start = 0.35,
		disorientation_type = "thunder_hammer_m2_light",
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.28,
		special_active_hit_stop_anim = "attack_hit_power",
		special_active_hit_stop_anim_3p = "attack_hit_power",
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
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_activate_special_right",
				chain_time = 0.5,
			},
		},
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/swing_left",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.thunderhammer_light_linesman,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_light_linesman_active_sweep,
		damage_profile_special_active_on_abort = DamageProfileTemplates.thunderhammer_m2_pushfollow_active,
		damage_type_special_active = damage_types.blunt_thunder,
		damage_type_special_active_on_abort = damage_types.blunt_thunder,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		herding_template = HerdingTemplates.linesman_left_heavy,
		anim_end_event_condition_func = function (unit, data, end_reason)
			if data and data.self_stun then
				return false
			end

			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing,
	},
	action_push = {
		activation_cooldown = 0.2,
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
				chain_time = 0.4,
			},
			start_attack = {
				action_name = "action_melee_start_left_3",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_activate_special_left",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
			push = {
				action_name = "action_block",
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
	action_activate_special_left = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.3,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate_var_01",
		anim_event_3p = "activate",
		kind = "activate_special",
		skip_3p_anims = false,
		start_input = "special_action",
		total_time = 1.5,
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
				chain_time = 0.85,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.85,
			},
		},
	},
	action_activate_special_right = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.3,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate_var_01",
		anim_event_3p = "activate",
		kind = "activate_special",
		skip_3p_anims = false,
		total_time = 1.5,
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
		},
	},
	action_activate_special_left_2 = {
		abort_fx_source_name = "_special_active",
		abort_sound_alias = "weapon_special_abort",
		activation_time = 0.3,
		allowed_during_sprint = true,
		anim_end_event = "activate_out",
		anim_event = "activate_var_01",
		anim_event_3p = "activate",
		kind = "activate_special",
		skip_3p_anims = false,
		total_time = 1.5,
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
				chain_time = 0.85,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.85,
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
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/thunder_hammer"
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
	"thunder_hammer",
	"p1",
	"activated",
}
weapon_template.dodge_template = "hammer_2h"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "thunderhammer_2h_p1_m1"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.thunderhammer
weapon_template.smart_targeting_template = SmartTargetingTemplates.tank
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.heavy
weapon_template.damage_window_start_sweep_trail_offset = -0.2
weapon_template.damage_window_end_sweep_trail_offset = 0.2
weapon_template.ammo_template = "no_ammo"
weapon_template.sprint_ready_up_time = 0.3
weapon_template.max_first_person_anim_movement_speed = 4.8
weapon_template.weapon_special_class = "WeaponSpecialSelfDisorientation"
weapon_template.weapon_special_tweak_data = {
	active_duration = 5,
	allow_reactivation_while_active = true,
	disorientation_type = "thunder_hammer_m2_light",
	keep_active_on_sprint = true,
	keep_active_on_stun = true,
	keep_active_on_vault = true,
	only_deactive_on_abort = true,
	special_active_hit_extra_time = 0.5,
	push_template = push_templates.medium,
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
	thunderhammer_p1_m2_dps_stat = {
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
			action_left_heavy_2 = {
				damage_trait_templates.thunderhammer_dps_stat,
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_dps_stat,
			},
		},
	},
	thunderhammer_p1_m2_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.thunderhammer_armor_pierce_stat,
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
				damage_trait_templates.thunderhammer_armor_pierce_stat,
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
			action_right_down_light = {
				damage_trait_templates.thunderhammer_armor_pierce_stat,
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_armor_pierce_stat,
			},
			action_left_heavy_2 = {
				damage_trait_templates.thunderhammer_armor_pierce_stat,
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_armor_pierce_stat,
			},
		},
	},
	thunderhammer_p1_m2_control_stat = {
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
			action_right_down_light = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_left_heavy_2 = {
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
			action_left_heavy_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_left_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
		},
	},
	thunderhammer_p1_m2_first_target_stat = {
		display_name = "loc_stats_display_first_target_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
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
			action_right_down_light = {
				damage_trait_templates.default_first_target_stat,
			},
			action_right_heavy = {
				damage_trait_templates.default_first_target_stat,
			},
			action_left_heavy_2 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_left_light_pushfollow = {
				damage_trait_templates.default_first_target_stat,
			},
		},
	},
	thunderhammer_p1_m2_defence_stat = {
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
						sprint_speed_mod = {},
					},
				},
			},
		},
	},
}
weapon_template.traits = {}

local bespoke_thunderhammer_2h_p1_traits = table.ukeys(WeaponTraitsBespokeThunderhammerP1)

table.append(weapon_template.traits, bespoke_thunderhammer_2h_p1_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control",
	},
	{
		description = "loc_weapon_stats_display_thunder_hammer_desc",
		display_name = "loc_weapon_keyword_thunder_hammer",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"linesman",
			"smiter",
		},
	},
	secondary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {
			"tank",
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
