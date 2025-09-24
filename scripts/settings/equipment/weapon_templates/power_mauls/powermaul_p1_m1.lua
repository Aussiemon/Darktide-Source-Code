-- chunkname: @scripts/settings/equipment/weapon_templates/power_mauls/powermaul_p1_m1.lua

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
local WeaponTraitsBespokePowermaulP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_p1")
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
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local weapon_template = {}

weapon_template.action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs)
weapon_template.action_inputs.start_attack.buffer_time = 0.4
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)

local melee_sticky_disallowed_hit_zones = {}
local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3,
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

local hit_stickyness_settings_light = {
	always_sticky = true,
	buff_to_add_tick = "power_maul_sticky_tick",
	disallow_chain_actions = true,
	duration = 1,
	min_sticky_time = 0.2,
	sensitivity_modifier = 0.9,
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	damage = {
		instances = 5,
		damage_profile = DamageProfileTemplates.powermaul_weapon_special,
		damage_type = damage_types.shock_stuck,
		last_damage_profile = DamageProfileTemplates.powermaul_weapon_special,
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	movement_curve = {
		{
			modifier = 0.3,
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
		start_modifier = 0.1,
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
				action_name = "action_special_action",
			},
			block = {
				action_name = "action_block",
			},
		},
	},
	action_melee_start_left = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down",
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
			light_attack = {
				action_name = "action_left_light",
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.43,
			},
			special_action = {
				action_name = "action_special_action",
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left",
		anim_event_3p = "attack_swing_left",
		attack_direction_override = "left",
		damage_window_end = 0.43333333333333335,
		damage_window_start = 0.26666666666666666,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.2,
		total_time = 1.4,
		uninterruptible = true,
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
				action_name = "action_special_action",
				chain_time = 0.57,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.2,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_maul/attack_left",
				anchor_point_offset = {
					0.1,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_light_linesman,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_left_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_down",
		anim_event_3p = "attack_swing_heavy_down",
		attack_direction_override = "down",
		damage_window_end = 0.3,
		damage_window_start = 0.185,
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.3,
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
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_special_action",
				chain_time = 0.42,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.2,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_maul/heavy_attack_down",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_heavy_smite,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down",
		anim_event_3p = "attack_swing_charge_down_right",
		first_person_hit_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "windup",
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
			light_attack = {
				action_name = "action_right_light",
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.51,
			},
			special_action = {
				action_name = "action_special_action",
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_light = {
		anim_end_event = "attack_finished",
		anim_event = "attack_right_down",
		anim_event_3p = "attack_swing_right_diagonal",
		attack_direction_override = "down",
		damage_window_end = 0.48,
		damage_window_start = 0.32,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.2,
		total_time = 2,
		uninterruptible = true,
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
				action_name = "action_special_action",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.1,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_maul/attack_right_down",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_light_smiter,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse,
	},
	action_right_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_diagonal_down",
		anim_event_3p = "attack_swing_heavy_down_right",
		attack_direction_override = "right",
		damage_window_end = 0.27,
		damage_window_start = 0.15,
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.3,
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
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_special_action",
				chain_time = 0.6,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.2,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_maul/heavy_attack_right_diagonal_down",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_heavy_tank,
		damage_type = damage_types.blunt_shock,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_left_2 = {
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down",
		anim_event_3p = "attack_swing_charge_down",
		chain_anim_event = "heavy_charge_down_pose",
		chain_anim_event_3p = "attack_swing_charge_down",
		first_person_hit_anim = "attack_hit",
		hit_stop_anim = "attack_hit",
		kind = "windup",
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
			light_attack = {
				action_name = "action_left_light_2",
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.43,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_special_action",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_light_2 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_left_down",
		anim_event_3p = "attack_swing_down_left",
		attack_direction_override = "down",
		damage_window_end = 0.45,
		damage_window_start = 0.28,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		power_level = 530,
		range_mod = 1.2,
		total_time = 1.5,
		uninterruptible = true,
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
				action_name = "action_melee_start_right_2",
				chain_time = 0.58,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_special_action",
				chain_time = 0.59,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_maul/attack_left_down",
				anchor_point_offset = {
					0.15,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_light_smiter,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_right_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down",
		anim_event_3p = "attack_swing_charge_down_right",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_stop_anim = "attack_hit_shield",
		kind = "windup",
		proc_time_interval = 0.2,
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
			light_attack = {
				action_name = "action_light_4",
			},
			heavy_attack = {
				action_name = "action_left_heavy",
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
	action_light_4 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_right_up",
		anim_event_3p = "attack_swing_up_right",
		attack_direction_override = "up",
		damage_window_end = 0.35,
		damage_window_start = 0.28,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		power_level = 550,
		range_mod = 1.2,
		total_time = 1.8,
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
				chain_time = 0.4,
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.69,
			},
			special_action = {
				action_name = "action_special_action",
				chain_time = 0.71,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.2,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_maul/attack_up_right",
				anchor_point_offset = {
					0.15,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_light_smiter,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
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
				action_name = "action_special_action",
				chain_time = 0.3,
			},
			push = {
				action_name = "action_push",
			},
		},
	},
	action_right_light_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_up",
		anim_event_3p = "attack_swing_up_left",
		attack_direction_override = "up",
		damage_window_end = 0.3,
		damage_window_start = 0.2,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		total_time = 1.5,
		weapon_handling_template = "time_scale_0_8",
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
				action_name = "action_melee_start_right",
				chain_time = 0.34,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_special_action",
				chain_time = 0.33,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.25,
			0.25,
			1.1,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_maul/attack_up_left",
				anchor_point_offset = {
					0,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.powermaul_light_smiter,
		damage_type = damage_types.blunt_shock,
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
				chain_time = 0.4,
			},
			start_attack = {
				action_name = "action_melee_start_left",
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
	action_special_action = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special",
		anim_event_3p = "attack_swing_stab_02",
		attack_direction_override = "push",
		damage_window_end = 0.6666666666666666,
		damage_window_start = 0.3333333333333333,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		power_level = 30,
		range_mod = 1.1,
		start_input = "special_action",
		stat_power_level = 500,
		total_time = 2.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15,
			},
			{
				modifier = 0.3,
				t = 0.75,
			},
			{
				modifier = 0.5,
				t = 1,
			},
			{
				modifier = 0.6,
				t = 1.25,
			},
			{
				modifier = 0.9,
				t = 1.5,
			},
			{
				modifier = 1,
				t = 2.5,
			},
			start_modifier = 1,
		},
		hit_stickyness_settings = hit_stickyness_settings_light,
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
				chain_time = 1,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.8,
			},
			special_action = {
				action_name = "action_special_action",
				chain_time = 0.8,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/power_maul/attack_special_poke",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.axe_uppercut,
		damage_type = damage_types.blunt_shock,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/power_sword"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/power_maul"
weapon_template.weapon_box = {
	0.15,
	0.65,
	0.15,
}
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_block",
	_melee_idling = "fx_special_active",
	_special_active = "fx_special_active",
	_sticky = "fx_special_active",
	_sweep = "fx_sweep",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"power_maul",
	"p1",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "linesman_plus"
weapon_template.toughness_template = "assault"
weapon_template.movement_curve_modifier_template = "combataxe_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.medium
weapon_template.base_stats = {
	powermaul_dps_stat = {
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
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_special_action = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	powermaul_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
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
			action_left_heavy = {
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
			action_right_light = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_right_heavy = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_special_action = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
		},
	},
	powermaul_control_stat = {
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
			action_right_light = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_special_action = {
				damage_trait_templates.thunderhammer_control_stat,
			},
			action_light_4 = {
				damage_trait_templates.thunderhammer_control_stat,
			},
		},
	},
	powermaul_finesse_stat = {
		display_name = "loc_stats_display_finesse_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
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
			action_left_heavy = {
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
			action_right_light = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_left_light_2 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_special_action = {
				damage_trait_templates.default_melee_finesse_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_melee_finesse_stat,
			},
		},
		weapon_handling = {
			action_left_light = {
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
			action_right_light = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_right_heavy = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_left_light_2 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_right_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_special_action = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
			action_light_4 = {
				weapon_handling_trait_templates.default_finesse_stat,
			},
		},
	},
	powermaul_mobility_stat = {
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

local weapon_traits_bespoke_powermaul_p1 = table.ukeys(WeaponTraitsBespokePowermaulP1)

table.append(weapon_template.traits, weapon_traits_bespoke_powermaul_p1)

weapon_template.buffs = {
	on_equip = {
		"power_maul_shock_hit",
	},
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control",
	},
	{
		display_name = "loc_weapon_keyword_shock_weapon",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"linesman",
			"smiter",
			"smiter",
			"smiter",
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
		desc = "loc_stats_special_action_special_attack_powermaul_p1m1_desc",
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
weapon_template.special_actions = {
	{
		action_name = "action_special_action",
		use_special_damage = true,
	},
}

return weapon_template
