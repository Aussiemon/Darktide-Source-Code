-- chunkname: @scripts/settings/equipment/weapon_templates/power_maul_shields/powermaul_shield_p1_m2.lua

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
local WeaponTraitsBespokePowermaulShieldP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_shield_p1")
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
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_shout_trait_templates = WeaponTraitTemplates[template_types.weapon_shout]
local weapon_template = {}
local action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs)

action_inputs.special_action = {
	buffer_time = 0.2,
	input_sequence = {
		{
			value = true,
			input = "weapon_extra_pressed"
		}
	}
}
action_inputs.special_action_hold = {
	buffer_time = 0.2,
	input_sequence = {
		{
			value = true,
			hold_input = "weapon_extra_hold",
			input = "weapon_extra_hold"
		}
	}
}
action_inputs.special_action_release = {
	buffer_time = 0.4,
	input_sequence = {
		{
			value = true,
			duration = 0.25,
			input = "weapon_extra_hold"
		},
		{
			value = false,
			time_window = 1.25,
			auto_complete = true,
			input = "weapon_extra_hold"
		}
	}
}
action_inputs.special_action_cancel = {
	buffer_time = 0.1,
	input_sequence = {
		{
			value = true,
			hold_input = "weapon_extra_hold",
			input = "action_two_pressed"
		}
	}
}
action_inputs.block_hold = {
	buffer_time = 0.1,
	input_sequence = {
		{
			value = true,
			input = "action_two_hold"
		}
	}
}
action_inputs.block_pressed = {
	buffer_time = 0.1,
	input_sequence = {
		{
			value = true,
			input = "action_two_pressed"
		}
	}
}
action_inputs.block_release = {
	buffer_time = 0.35,
	max_queue = 1,
	input_sequence = {
		{
			value = false,
			input = "action_two_hold",
			time_window = math.huge
		}
	}
}

local action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)
local new_special_action_transition = {
	{
		transition = "base",
		input = "special_action_release"
	},
	{
		transition = "base",
		input = "special_action_cancel"
	}
}

ActionInputHierarchy.update_hierarchy_entry(action_input_hierarchy, "special_action", new_special_action_transition)

local new_block_hold_transition = {
	{
		input = "block_hold",
		transition = {
			{
				transition = "base",
				input = "block_release"
			},
			{
				transition = "base",
				input = "special_action"
			},
			{
				transition = "base",
				input = "wield"
			},
			{
				transition = "base",
				input = "combat_ability"
			},
			{
				transition = "base",
				input = "grenade_ability"
			}
		}
	}
}

ActionInputHierarchy.update_hierarchy_entry(action_input_hierarchy, "block_hold", new_block_hold_transition)

weapon_template.action_inputs = action_inputs
weapon_template.action_input_hierarchy = action_input_hierarchy

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

local new_start_attack_action_transition = {
	{
		transition = "base",
		input = "attack_cancel"
	},
	{
		transition = "base",
		input = "light_attack"
	},
	{
		transition = "base",
		input = "heavy_attack"
	},
	{
		transition = "base",
		input = "wield"
	},
	{
		transition = "base",
		input = "grenade_ability"
	},
	{
		transition = "base",
		input = "block"
	}
}

ActionInputHierarchy.update_hierarchy_entry(weapon_template.action_input_hierarchy, "start_attack", new_start_attack_action_transition)
ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_wield = {
		kind = "wield",
		allowed_during_sprint = true,
		uninterruptible = true,
		anim_event = "equip",
		sprint_ready_up_time = 0,
		total_time = 0.43,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.3
			},
			start_modifier = 0.9
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left"
			},
			block = {
				action_name = "action_block"
			}
		}
	},
	action_melee_start_left = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		start_input = "start_attack",
		kind = "windup",
		anim_event_3p = "attack_swing_charge_down_left",
		uninterruptible = true,
		anim_event = "heavy_charge_left_diagonal_down",
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.35,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.65,
				t = 0.5
			},
			{
				modifier = 0.635,
				t = 0.55
			},
			{
				modifier = 0.8,
				t = 1.2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_light_1"
			},
			heavy_attack = {
				action_name = "action_heavy_1",
				chain_time = 0.43
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_light_1 = {
		damage_window_start = 0.31666666666666665,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		weapon_handling_template = "time_scale_1",
		attack_direction_override = "left",
		first_person_hit_stop_anim = "hit_stop",
		anim_event_3p = "attack_swing_left",
		allowed_during_sprint = true,
		range_mod = 1.2,
		damage_window_end = 0.4,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_left",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 0.8,
				t = 0.35
			},
			{
				modifier = 0.5,
				t = 0.5
			},
			{
				modifier = 0.45,
				t = 0.55
			},
			{
				modifier = 0.65,
				t = 0.6
			},
			{
				modifier = 0.7,
				t = 1
			},
			{
				modifier = 1,
				t = 1.3
			},
			start_modifier = 1.1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.57
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_special_start",
				chain_time = 0.55
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.2,
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/assault_shield_maul/attack_left",
			anchor_point_offset = {
				0.1,
				0,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.powermaul_shield_light_tank,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse
	},
	action_heavy_1 = {
		damage_window_start = 0.16666666666666666,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1",
		kind = "sweep",
		attack_direction_override = "left",
		first_person_hit_stop_anim = "attack_hit",
		anim_event_3p = "attack_swing_left_diagonal",
		allowed_during_sprint = true,
		range_mod = 1.3,
		damage_window_end = 0.275,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "heavy_attack_left_diagonal_down",
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15
			},
			{
				modifier = 1.25,
				t = 0.4
			},
			{
				modifier = 0.5,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.5
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.4
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45
			},
			special_action = {
				action_name = "action_special_start",
				chain_time = 0.4
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.2,
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/assault_shield_maul/heavy_attack_left_diagonal_down",
			anchor_point_offset = {
				0,
				0,
				-0.25
			}
		},
		damage_profile = DamageProfileTemplates.powermaul_shield_heavy_tank,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		kind = "windup",
		first_person_hit_anim = "attack_hit",
		anim_event_3p = "heavy_charge_shield_slam",
		anim_event = "heavy_charge_shield_slam_pose",
		hit_stop_anim = "attack_hit",
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.35,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.65,
				t = 0.5
			},
			{
				modifier = 0.635,
				t = 0.55
			},
			{
				modifier = 0.8,
				t = 1.2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_light_2"
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.51
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_light_2 = {
		damage_window_start = 0.3333333333333333,
		hit_armor_anim = "attack_hit_shield",
		range_mod = 1.35,
		kind = "sweep",
		max_num_saved_entries = 20,
		weapon_handling_template = "time_scale_1",
		uninterruptible = true,
		num_frames_before_process = 0,
		allowed_during_sprint = true,
		first_person_hit_stop_anim = "hit_stop",
		damage_window_end = 0.43333333333333335,
		attack_direction_override = "right",
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_right",
		anim_event = "attack_right",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 0.8,
				t = 0.35
			},
			{
				modifier = 0.7,
				t = 0.5
			},
			{
				modifier = 0.65,
				t = 0.55
			},
			{
				modifier = 0.75,
				t = 0.6
			},
			{
				modifier = 0.8,
				t = 1
			},
			{
				modifier = 1,
				t = 1.3
			},
			start_modifier = 1.1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.56
			},
			special_action = {
				action_name = "action_special_start",
				chain_time = 0.54
			},
			block = {
				action_name = "action_block",
				chain_time = 0.1
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.2,
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/assault_shield_maul/attack_right",
			anchor_point_offset = {
				0,
				0,
				-0.15
			}
		},
		damage_profile = DamageProfileTemplates.powermaul_shield_light_tank,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse
	},
	action_heavy_2 = {
		damage_window_start = 0.21666666666666667,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		weapon_handling_template = "time_scale_1",
		attack_direction_override = "push",
		range_mod = 1.275,
		allowed_during_sprint = true,
		first_person_hit_stop_anim = "attack_hit",
		damage_window_end = 0.26666666666666666,
		anim_end_event = "attack_finished",
		anim_event_3p = "heavy_attack_shield_slam",
		anim_event = "heavy_attack_shield_slam",
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15
			},
			{
				modifier = 1.25,
				t = 0.4
			},
			{
				modifier = 0.5,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.5
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.4
			},
			start_attack = {
				action_name = "action_melee_start_left_3",
				chain_time = 0.6
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45
			},
			special_action = {
				action_name = "action_special_start",
				chain_time = 0.45
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.35,
			0.45,
			1.2
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/assault_shield_maul/heavy_attack_shieldslam",
			anchor_point_offset = {
				-0.15,
				0,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.powermaul_shield_heavy_smiter_shield,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_melee_start_left_2 = {
		allowed_during_sprint = true,
		chain_anim_event_3p = "attack_swing_charge_down_left",
		anim_event_3p = "attack_swing_charge_down",
		kind = "windup",
		first_person_hit_anim = "attack_hit",
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "heavy_charge_left_diagonal_down",
		hit_stop_anim = "attack_hit",
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.35,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.65,
				t = 0.5
			},
			{
				modifier = 0.635,
				t = 0.55
			},
			{
				modifier = 0.8,
				t = 1.2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_light_3"
			},
			heavy_attack = {
				action_name = "action_heavy_1",
				chain_time = 0.43
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_light_3 = {
		damage_window_start = 0.2783333333333333,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1",
		kind = "sweep",
		max_num_saved_entries = 20,
		range_mod = 1.2,
		first_person_hit_stop_anim = "hit_stop",
		num_frames_before_process = 0,
		allowed_during_sprint = true,
		damage_window_end = 0.3333333333333333,
		attack_direction_override = "up",
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_up_left",
		anim_event = "attack_left_up",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 0.8,
				t = 0.35
			},
			{
				modifier = 0.7,
				t = 0.5
			},
			{
				modifier = 0.65,
				t = 0.55
			},
			{
				modifier = 0.75,
				t = 0.6
			},
			{
				modifier = 0.8,
				t = 1
			},
			{
				modifier = 1,
				t = 1.3
			},
			start_modifier = 1.1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.58
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_special_start",
				chain_time = 0.56
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.15,
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/assault_shield_maul/attack_left_up",
			anchor_point_offset = {
				-0.1,
				0,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.powermaul_shield_light_smiter,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse
	},
	action_heavy_3 = {
		damage_window_start = 0.24166666666666667,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		weapon_handling_template = "time_scale_1",
		attack_direction_override = "down",
		range_mod = 1.275,
		allowed_during_sprint = true,
		first_person_hit_stop_anim = "attack_hit",
		damage_window_end = 0.2833333333333333,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_heavy_down_right",
		anim_event = "heavy_attack_right_down",
		power_level = 525,
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15
			},
			{
				modifier = 1.25,
				t = 0.4
			},
			{
				modifier = 0.5,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.5
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.3
			},
			start_attack = {
				action_name = "action_melee_start_left_4",
				chain_time = 0.6
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45
			},
			special_action = {
				action_name = "action_special_start",
				chain_time = 0.45
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.15,
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/assault_shield_maul/heavy_attack_right_down",
			anchor_point_offset = {
				0.05,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.powermaul_shield_heavy_smiter,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse
	},
	action_melee_start_right_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		proc_time_interval = 0.2,
		kind = "windup",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		anim_event_3p = "heavy_charge_shield_slam",
		anim_event = "heavy_charge_shield_slam_pose",
		hit_stop_anim = "attack_hit_shield",
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.35,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.65,
				t = 0.5
			},
			{
				modifier = 0.635,
				t = 0.55
			},
			{
				modifier = 0.8,
				t = 1.2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_light_4"
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.4
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_light_4 = {
		damage_window_start = 0.3416666666666667,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_1",
		kind = "sweep",
		attack_direction_override = "down",
		range_mod = 1.28,
		allowed_during_sprint = true,
		first_person_hit_stop_anim = "hit_stop",
		damage_window_end = 0.44166666666666665,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_right_diagonal",
		anim_event = "attack_right_down",
		power_level = 545,
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15
			},
			{
				modifier = 0.8,
				t = 0.2
			},
			{
				modifier = 1.5,
				t = 0.25
			},
			{
				modifier = 1.4,
				t = 0.4
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.2
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.69
			},
			special_action = {
				action_name = "action_special_start",
				chain_time = 0.6
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.15,
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/assault_shield_maul/attack_right_down",
			anchor_point_offset = {
				0.05,
				0,
				-0.15
			}
		},
		damage_profile = DamageProfileTemplates.powermaul_shield_light_smiter,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse
	},
	action_melee_start_left_3 = {
		allowed_during_sprint = true,
		chain_anim_event_3p = "attack_swing_charge_down_right",
		anim_end_event = "attack_finished",
		kind = "windup",
		first_person_hit_anim = "attack_hit",
		anim_event_3p = "attack_swing_charge_down_right",
		anim_event = "heavy_charge_right_down_pose",
		hit_stop_anim = "attack_hit",
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.35,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.65,
				t = 0.5
			},
			{
				modifier = 0.635,
				t = 0.55
			},
			{
				modifier = 1,
				t = 1.2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_light_3"
			},
			heavy_attack = {
				action_name = "action_heavy_3",
				chain_time = 0.43
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_melee_start_left_4 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		proc_time_interval = 0.2,
		kind = "windup",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		anim_event_3p = "heavy_charge_shield_slam",
		anim_event = "heavy_charge_shield_slam_pose",
		hit_stop_anim = "attack_hit_shield",
		stop_input = "attack_cancel",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.35,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.65,
				t = 0.5
			},
			{
				modifier = 0.635,
				t = 0.55
			},
			{
				modifier = 0.8,
				t = 1.2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_light_3"
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.4
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_block = {
		block_unblockable = true,
		weapon_handling_template = "time_scale_1_4",
		start_input = "block",
		anim_end_event = "parry_finished",
		kind = "block",
		minimum_hold_time = 0.3,
		uninterruptible = true,
		anim_event = "parry_pose",
		stop_input = "block_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.2
			},
			{
				modifier = 0.32,
				t = 0.3
			},
			{
				modifier = 0.4,
				t = 0.325
			},
			{
				modifier = 0.45,
				t = 0.35
			},
			{
				modifier = 0.55,
				t = 0.5
			},
			{
				modifier = 0.75,
				t = 0.7
			},
			{
				modifier = 0.8,
				t = 1
			},
			{
				modifier = 0.85,
				t = 1.5
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			special_action = {
				action_name = "action_special_start"
			},
			push = {
				action_name = "action_push"
			}
		},
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true
		}
	},
	action_push = {
		push_radius = 3.25,
		block_duration = 0.4,
		kind = "push",
		anim_event = "attack_push",
		total_time = 0.8,
		action_movement_curve = {
			{
				modifier = 1.4,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.5,
				t = 0.4
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.4
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			push_follow_up = {
				action_name = "action_pushfollow",
				chain_time = 0.25
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.4
			},
			special_action = {
				action_name = "action_special_start",
				chain_time = 0.4
			}
		},
		inner_push_rad = math.pi * 0.55,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.human_shield_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.default_shield_push,
		outer_damage_type = damage_types.physical,
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true
		},
		haptic_trigger_template = HapticTriggerTemplates.melee.push
	},
	action_pushfollow = {
		damage_window_start = 0.2783333333333333,
		hit_armor_anim = "attack_hit_shield",
		max_num_saved_entries = 20,
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		weapon_handling_template = "time_scale_1",
		anim_event_3p = "attack_swing_up_left",
		num_frames_before_process = 0,
		allowed_during_sprint = true,
		first_person_hit_stop_anim = "hit_stop",
		range_mod = 1.25,
		damage_window_end = 0.3333333333333333,
		anim_end_event = "attack_finished",
		attack_direction_override = "up",
		uninterruptible = true,
		anim_event = "attack_left_up",
		power_level = 540,
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.2
			},
			{
				modifier = 1.15,
				t = 0.4
			},
			{
				modifier = 0.45,
				t = 0.45
			},
			{
				modifier = 0.6,
				t = 0.65
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.4
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.58
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55
			},
			special_action = {
				action_name = "action_special_start",
				chain_time = 0.55
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.15,
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/assault_shield_maul/attack_left_up",
			anchor_point_offset = {
				-0.1,
				0,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.powermaul_shield_light_smiter,
		damage_type = damage_types.blunt_shock,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse
	},
	action_special_start = {
		anim_event = "charge_special",
		anim_event_3p = "charge_special",
		start_input = "special_action",
		kind = "block_windup",
		weapon_handling_template = "time_scale_1",
		prevent_sprint = true,
		block_unblockable = true,
		anim_end_event = "parry_finished",
		abort_sprint = true,
		uninterruptible = true,
		stop_input = "special_action_cancel",
		total_time = 1.8,
		wieldable_slot_script_tweak_data = {
			start_time = 0.5,
			play_windup_effects = true
		},
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.2
			},
			{
				modifier = 0.32,
				t = 0.3
			},
			{
				modifier = 0.3,
				t = 0.325
			},
			{
				modifier = 0.31,
				t = 0.35
			},
			{
				modifier = 0.55,
				t = 0.5
			},
			{
				modifier = 0.75,
				t = 1
			},
			{
				modifier = 0.7,
				t = 2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			block = {
				action_name = "action_block",
				chain_time = 0.1
			},
			special_action_release = {
				action_name = "action_special_activation",
				chain_time = 0.4
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action"
		end,
		damage_profile = DamageProfileTemplates.powermaul_shield_block_special,
		damage_type = damage_types.shield_push,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
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
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true
		}
	},
	action_special_activation = {
		anim_event_3p = "attack_special",
		block_duration = 0.4,
		kind = "weapon_shout",
		weapon_handling_template = "time_scale_1",
		block_unblockable = true,
		anim_end_event = "parry_finished",
		weapon_shout_template = "powermaul_shield_p1_block_special",
		abort_sprint = true,
		shout_at_time = 0.25,
		uninterruptible = true,
		anim_event = "attack_special",
		prevent_sprint = true,
		total_time = 0.6,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15
			},
			{
				modifier = 0.3,
				t = 0.75
			},
			{
				modifier = 0.5,
				t = 1
			},
			{
				modifier = 0.6,
				t = 1.25
			},
			{
				modifier = 0.9,
				t = 1.5
			},
			{
				modifier = 1,
				t = 2.5
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action"
		end,
		damage_profile = DamageProfileTemplates.powermaul_shield_block_special,
		damage_type = damage_types.shield_push,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true
		}
	},
	action_inspect = {
		skip_3p_anims = false,
		lock_view = true,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect"
		}
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/assault_shield_maul"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/assault_shield_maul"
weapon_template.weapon_box = {
	0.15,
	0.65,
	0.15
}
weapon_template.hud_configuration = {
	uses_overheat = false,
	uses_ammunition = false
}
weapon_template.weapon_special_class = "WeaponSpecialBlockCharges"
weapon_template.weapon_special_tweak_data = {
	passive_num_charges_to_add = 1,
	passive_charge_add_interval = 1.5,
	default_num_charges_to_add = 1,
	num_activations = 2,
	max_charges = 50,
	num_charges_to_add_per_breed = {
		chaos_plague_ogryn = 5,
		chaos_spawn = 4,
		chaos_ogryn_bulwark = 3,
		chaos_beast_of_nurgle = 5,
		renegade_captain = 4,
		renegade_executor = 2,
		cultist_captain = 4,
		chaos_ogryn_executor = 4
	},
	thresholds = {
		{
			threshold = 0,
			name = "low"
		},
		{
			threshold = 25,
			name = "middle"
		},
		{
			threshold = 50,
			name = "high"
		}
	}
}
weapon_template.weapon_special_tweak_data.num_charges_to_consume_on_activation = weapon_template.weapon_special_tweak_data.max_charges / weapon_template.weapon_special_tweak_data.num_activations
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_display = "fx_display",
	_special_active = "fx_special_active",
	_shield_special_active = "fx_shield_special_active",
	_block = "fx_block",
	_melee_idling = "fx_special_active",
	_sweep = "fx_sweep",
	_shield_melee_idling = "fx_shield_special_active"
}
weapon_template.crosshair = {
	crosshair_type = "dot"
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"powermaul_shield",
	"p1"
}
weapon_template.dodge_template = "smiter"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "powermaul_shield_p1_m1"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.medium

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	powermaul_shield_p1_m1_dps_stat = {
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
										display_name = "loc_weapon_stats_display_base_damage"
									}
								}
							}
						}
					}
				}
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
										display_name = "loc_weapon_stats_display_base_damage"
									}
								}
							}
						}
					}
				}
			},
			action_light_2 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_heavy_2 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_light_3 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_heavy_3 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_light_4 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_pushfollow = {
				damage_trait_templates.default_melee_dps_stat
			}
		}
	},
	powermaul_shield_p1_m1_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.powermaul_shield_p1_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						armor_damage_modifier = {
							attack = {
								[armor_types.armored] = {},
								[armor_types.super_armor] = {}
							}
						}
					}
				}
			},
			action_heavy_1 = {
				damage_trait_templates.powermaul_shield_p1_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						armor_damage_modifier = {
							attack = {
								[armor_types.armored] = {},
								[armor_types.super_armor] = {}
							}
						}
					}
				}
			},
			action_light_2 = {
				damage_trait_templates.powermaul_shield_p1_armor_pierce_stat
			},
			action_heavy_2 = {
				damage_trait_templates.powermaul_shield_p1_armor_pierce_stat
			},
			action_light_3 = {
				damage_trait_templates.powermaul_shield_p1_armor_pierce_stat
			},
			action_heavy_3 = {
				damage_trait_templates.powermaul_shield_p1_armor_pierce_stat
			},
			action_light_4 = {
				damage_trait_templates.powermaul_shield_p1_armor_pierce_stat
			},
			action_pushfollow = {
				damage_trait_templates.powermaul_shield_p1_armor_pierce_stat
			}
		}
	},
	powermaul_shield_p1_m1_control_stat = {
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
										display_name = "loc_weapon_stats_display_stagger"
									}
								}
							}
						},
						cleave_distribution = {
							attack = {},
							impact = {}
						}
					}
				}
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
										display_name = "loc_weapon_stats_display_stagger"
									}
								}
							}
						},
						cleave_distribution = {
							attack = {},
							impact = {}
						}
					}
				}
			},
			action_light_2 = {
				damage_trait_templates.thunderhammer_control_stat
			},
			action_heavy_2 = {
				damage_trait_templates.thunderhammer_control_stat
			},
			action_light_3 = {
				damage_trait_templates.thunderhammer_control_stat
			},
			action_heavy_3 = {
				damage_trait_templates.thunderhammer_control_stat
			},
			action_light_4 = {
				damage_trait_templates.thunderhammer_control_stat
			},
			action_pushfollow = {
				damage_trait_templates.thunderhammer_control_stat
			}
		}
	},
	powermaul_shield_p1_m1_defence_stat = {
		display_name = "loc_stats_display_defense_stat",
		is_stat_trait = true,
		stamina = {
			base = {
				stamina_trait_templates.thunderhammer_p1_m1_defence_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		},
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	},
	powermaul_shield_p1_m1_power_output_stat = {
		display_name = "loc_stats_display_power_output_powermaul_shield_p1",
		is_stat_trait = true,
		weapon_shout = {
			action_special_activation = {
				weapon_shout_trait_templates.powermaul_shield_p1_block_special_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	}
}
weapon_template.traits = {}

local weapon_traits_bespoke_powermaul_shield_p1 = table.ukeys(WeaponTraitsBespokePowermaulShieldP1)

table.append(weapon_template.traits, weapon_traits_bespoke_powermaul_shield_p1)

weapon_template.buffs = {
	on_equip = {
		"power_maul_shock_hit"
	}
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control"
	},
	{
		display_name = "loc_weapon_keyword_shock_weapon"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {
			"tank",
			"tank",
			"smiter",
			"smiter"
		}
	},
	secondary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {
			"tank",
			"smiter",
			"smiter"
		}
	},
	special = {
		desc = "loc_stats_special_action_special_attack_powermaul_shield_p1m1_desc",
		display_name = "loc_weapon_special_activate",
		type = "activate"
	}
}
weapon_template.weapon_card_data = {
	main = {
		{
			icon = "tank",
			value_func = "primary_attack",
			header = "light"
		},
		{
			icon = "tank",
			value_func = "secondary_attack",
			header = "heavy"
		}
	},
	weapon_special = {
		icon = "activate",
		header = "activate"
	}
}

return weapon_template
