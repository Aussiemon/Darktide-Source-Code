local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MeleeActionInputSetupFast = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_fast")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeCombataxeP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combataxe_p2")
local WeaponTraitsMeleeCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local wounds_shapes = WoundsSettings.shapes
local weapon_template = {
	action_inputs = table.clone(MeleeActionInputSetupFast.action_inputs),
	action_input_hierarchy = table.clone(MeleeActionInputSetupFast.action_input_hierarchy)
}
local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

local default_weapon_box = {
	0.15,
	0.15,
	1
}
weapon_template.actions = {
	action_unwield = {
		continue_sprinting = true,
		allowed_during_sprint = true,
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_wield = {
		allowed_during_sprint = true,
		kind = "wield",
		sprint_ready_up_time = 0,
		continue_sprinting = true,
		uninterruptible = true,
		anim_event = "equip",
		total_time = 0.3,
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.4
			},
			start_modifier = 0.8
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left"
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_special_down_right"
			}
		}
	},
	action_melee_start_left = {
		anim_event_3p = "attack_swing_charge_down_left",
		chain_anim_event = "heavy_charge_left_diagonal_down_pose",
		start_input = "start_attack",
		kind = "windup",
		chain_anim_event_3p = "attack_swing_charge_down_left",
		anim_end_event = "attack_finished",
		allowed_during_sprint = true,
		anim_event = "heavy_charge_left_diagonal_down",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 1.1,
				t = 0.05
			},
			{
				modifier = 1.05,
				t = 0.1
			},
			{
				modifier = 0.95,
				t = 0.25
			},
			{
				modifier = 0.85,
				t = 0.4
			},
			{
				modifier = 0.8,
				t = 0.5
			},
			{
				modifier = 0.8,
				t = 0.55
			},
			{
				modifier = 1.05,
				t = 1.2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_left_down_light",
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.35
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_left_down_light = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		weapon_handling_template = "time_scale_1_hatchet",
		range_mod = 1.25,
		first_person_hit_stop_anim = "hit_stop",
		anim_event_3p = "attack_swing_down_ninja",
		allowed_during_sprint = true,
		damage_window_end = 0.3,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_down",
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.17
			},
			{
				modifier = 0.5,
				t = 0.28
			},
			{
				modifier = 0.55,
				t = 0.4
			},
			{
				modifier = 0.75,
				t = 0.45
			},
			{
				modifier = 0.7,
				t = 0.5
			},
			{
				modifier = 0.8,
				t = 0.7
			},
			{
				modifier = 1,
				t = 103
			},
			start_modifier = 1.1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.34
			},
			special_action = {
				action_name = "action_special_down_right",
				chain_time = 0.38
			},
			block = {
				action_name = "action_block",
				chain_time = 0.3
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/hatchet/attack_down",
			anchor_point_offset = {
				0.15,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.default_light_hatchet_smiter,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash_clean
	},
	action_left_heavy = {
		damage_window_start = 0.13333333333333333,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_hatchet",
		kind = "sweep",
		first_person_hit_anim = "hit_left_down_shake",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		allowed_during_sprint = true,
		damage_window_end = 0.21666666666666667,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_heavy_down_left",
		anim_event = "heavy_attack_left_diagonal_down",
		total_time = 0.77,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.46
			},
			special_action = {
				action_name = "action_special_down_right",
				chain_time = 0.46
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/hatchet/heavy_attack_left_diagonal_down",
			anchor_point_offset = {
				0,
				0,
				-0.15
			}
		},
		damage_profile = DamageProfileTemplates.medium_hatchet,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.left_45_slash_clean
	},
	action_melee_start_right = {
		chain_anim_event_3p = "attack_swing_charge_down",
		chain_anim_event = "heavy_charge_down_left_pose",
		anim_end_event = "attack_finished",
		kind = "windup",
		anim_event_3p = "attack_swing_charge_down",
		anim_event = "heavy_charge_down_left",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.65,
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
				modifier = 0.3,
				t = 1.2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_right_diagonal_light",
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.35
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_right_diagonal_light = {
		damage_window_start = 0.2833333333333333,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_0_9_hatchet",
		kind = "sweep",
		max_num_saved_entries = 20,
		first_person_hit_stop_anim = "hit_stop",
		anim_event_3p = "attack_swing_up_right_ninja",
		num_frames_before_process = 2,
		range_mod = 1.25,
		damage_window_end = 0.36666666666666664,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_right_diagonal_up_ninja",
		total_time = 1.15,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.18
			},
			{
				modifier = 0.8,
				t = 0.28
			},
			{
				modifier = 0.7,
				t = 0.35
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.75,
				t = 0.5
			},
			{
				modifier = 0.8,
				t = 0.9
			},
			{
				modifier = 1,
				t = 1.05
			},
			start_modifier = 1.1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.35
			},
			special_action = {
				action_name = "action_special_down_right",
				chain_time = 0.57
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/hatchet/attack_right_diagonal_up_ninja",
			anchor_point_offset = {
				0,
				0,
				-0.375
			}
		},
		damage_profile = DamageProfileTemplates.default_light_hatchet_smiter,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.right_45_slash_clean
	},
	action_right_heavy = {
		damage_window_start = 0.18333333333333332,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_3_hatchet",
		anim_end_event = "attack_finished",
		kind = "sweep",
		first_person_hit_anim = "hit_down_shake",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		damage_window_end = 0.23333333333333334,
		anim_event_3p = "attack_swing_heavy_down",
		anim_event = "heavy_attack_down",
		total_time = 0.78,
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.11
			},
			{
				modifier = 1.25,
				t = 0.29
			},
			{
				modifier = 0.5,
				t = 0.4
			},
			{
				modifier = 1,
				t = 0.77
			},
			start_modifier = 1.5
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.25
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.5
			},
			special_action = {
				action_name = "action_special_down_right",
				chain_time = 0.5
			},
			block = {
				action_name = "action_block",
				chain_time = 0.25
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/hatchet/heavy_attack_down",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.medium_hatchet,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.horizontal_slash_clean
	},
	action_melee_start_left_2 = {
		chain_anim_event_3p = "attack_swing_charge_down_left",
		chain_anim_event = "heavy_charge_left_diagonal_down_pose",
		anim_end_event = "attack_finished",
		kind = "windup",
		anim_event_3p = "attack_swing_charge_down_left",
		anim_event = "heavy_charge_left_diagonal_down",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.65,
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
				modifier = 0.3,
				t = 1.2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_left_light",
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.25
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_left_light = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_hatchet",
		kind = "sweep",
		anim_event_3p = "attack_swing_left_diagonal_ninja",
		first_person_hit_stop_anim = "hit_stop",
		range_mod = 1.25,
		damage_window_end = 0.3,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_left_diagonal_down_ninja",
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.16
			},
			{
				modifier = 0.8,
				t = 0.25
			},
			{
				modifier = 0.7,
				t = 0.37
			},
			{
				modifier = 0.65,
				t = 0.45
			},
			{
				modifier = 0.75,
				t = 0.5
			},
			{
				modifier = 0.8,
				t = 0.85
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.53
			},
			special_action = {
				action_name = "action_special_down_right",
				chain_time = 0.5
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/hatchet/attack_left_diagonal_down_ninja",
			anchor_point_offset = {
				0,
				0,
				-0.45
			}
		},
		damage_profile = DamageProfileTemplates.default_light_hatchet_smiter,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash_clean
	},
	action_block = {
		minimum_hold_time = 0.3,
		start_input = "block",
		anim_end_event = "parry_finished",
		kind = "block",
		anim_event = "parry_pose",
		stop_input = "block_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.2
			},
			{
				modifier = 0.72,
				t = 0.3
			},
			{
				modifier = 0.7,
				t = 0.325
			},
			{
				modifier = 0.71,
				t = 0.35
			},
			{
				modifier = 0.75,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			push = {
				action_name = "action_push"
			},
			special_action = {
				action_name = "action_special_down_right"
			}
		}
	},
	action_right_light_pushfollow = {
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_hatchet",
		kind = "sweep",
		anim_event_3p = "attack_swing_right_diagonal",
		first_person_hit_stop_anim = "hit_stop",
		range_mod = 1.35,
		damage_window_end = 0.4,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_right_diagonal_down_ninja",
		total_time = 1.5,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.37
			},
			special_action = {
				action_name = "action_special_down_right",
				chain_time = 0.55
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/hatchet/attack_right_diagonal_down_ninja",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.medium_hatchet,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.left_45_slash_clean
	},
	action_push = {
		push_radius = 2.5,
		block_duration = 0.5,
		kind = "push",
		anim_event = "attack_push",
		power_level = 400,
		total_time = 1,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			push_follow_up = {
				action_name = "action_right_light_pushfollow",
				chain_time = 0.3
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.35
			}
		},
		inner_push_rad = math.pi * 0.1,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.ninja_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical
	},
	action_special_down_right = {
		damage_window_start = 0.18333333333333332,
		hit_armor_anim = "attack_hit_shield",
		start_input = "special_action",
		kind = "sweep",
		attack_direction_override = "push",
		first_person_hit_stop_anim = "hit_stop",
		range_mod = 1.2,
		allowed_during_sprint = true,
		weapon_handling_template = "time_scale_1_3_hatchet",
		damage_window_end = 0.3,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_stab_ninja",
		anim_event = "attack_special_stab",
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.5
			},
			special_action = {
				action_name = "action_special_down_left",
				chain_time = 0.5
			},
			block = {
				action_name = "action_block",
				chain_time = 0
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			1,
			0.3
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/hatchet/special_attack_stab",
			anchor_point_offset = {
				0,
				0.55,
				-0.2
			}
		},
		damage_profile = DamageProfileTemplates.light_axe_p2_special,
		damage_type = damage_types.blunt,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_special_down_left = {
		damage_window_start = 0.3333333333333333,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		weapon_handling_template = "time_scale_1_3_hatchet",
		max_num_saved_entries = 20,
		range_mod = 1.25,
		first_person_hit_stop_anim = "hit_stop",
		num_frames_before_process = 0,
		allowed_during_sprint = true,
		damage_window_end = 0.43333333333333335,
		attack_direction_override = "push",
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_left_diagonal",
		anim_event = "attack_special_down_left",
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 0.9,
				t = 0.35
			},
			{
				modifier = 0.6,
				t = 0.5
			},
			{
				modifier = 0.55,
				t = 0.55
			},
			{
				modifier = 0.7,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.5
			},
			special_action = {
				action_name = "action_special_down_right",
				chain_time = 0.75
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/hatchet/special_attack_backside_down_left",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.light_axe_p2_special_2,
		damage_type = damage_types.blunt_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_inspect = {
		skip_3p_anims = true,
		lock_view = true,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		crosshair_type = "none",
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/power_sword"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/hatchet"
weapon_template.weapon_box = {
	0.1,
	0.1,
	0.7
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_block",
	_sweep = "fx_sweep"
}
weapon_template.crosshair_type = "dot"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"combat_axe",
	"p2"
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.dodge_template = "ninjafencer"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "ninjafencer"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "combataxe_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.base_stats = {
	combataxe_p2_m3_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_left_light = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_special_down_left = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_special_down_right = {
				damage_trait_templates.default_melee_dps_stat
			}
		}
	},
	combataxe_p2_m3_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_left_heavy = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_left_light = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_special_down_left = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_special_down_right = {
				damage_trait_templates.default_armor_pierce_stat
			}
		}
	},
	combataxe_p2_m3_finesse_stat = {
		display_name = "loc_stats_display_finesse_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_left_light = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_special_down_right = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_special_down_left = {
				damage_trait_templates.default_melee_finesse_stat
			}
		},
		weapon_handling = {
			action_left_down_light = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_left_heavy = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_diagonal_light = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_heavy = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_special_down_right = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_special_down_left = {
				weapon_handling_trait_templates.default_finesse_stat
			}
		}
	},
	combataxe_p2_p3_crit_stat = {
		display_name = "loc_stats_display_crit_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_left_down_light = {
				weapon_handling_trait_templates.stubrevolver_crit_stat
			},
			action_left_heavy = {
				weapon_handling_trait_templates.stubrevolver_crit_stat
			},
			action_right_diagonal_light = {
				weapon_handling_trait_templates.stubrevolver_crit_stat
			},
			action_right_heavy = {
				weapon_handling_trait_templates.stubrevolver_crit_stat
			},
			action_left_light = {
				weapon_handling_trait_templates.stubrevolver_crit_stat
			},
			action_special_down_left = {
				weapon_handling_trait_templates.stubrevolver_crit_stat
			},
			action_right_light_pushfollow = {
				weapon_handling_trait_templates.stubrevolver_crit_stat
			},
			action_special_down_right = {
				weapon_handling_trait_templates.stubrevolver_crit_stat
			}
		},
		damage = {
			action_left_down_light = {
				damage_trait_templates.stubrevolver_crit_stat
			},
			action_left_heavy = {
				damage_trait_templates.stubrevolver_crit_stat
			},
			action_right_diagonal_light = {
				damage_trait_templates.stubrevolver_crit_stat
			},
			action_right_heavy = {
				damage_trait_templates.stubrevolver_crit_stat
			},
			action_left_light = {
				damage_trait_templates.stubrevolver_crit_stat
			},
			action_special_down_left = {
				damage_trait_templates.stubrevolver_crit_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.stubrevolver_crit_stat
			},
			action_special_down_right = {
				damage_trait_templates.stubrevolver_crit_stat
			}
		}
	},
	combataxe_p2_m3_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat
			}
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat
			}
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat
			}
		}
	}
}
weapon_template.traits = {}
local melee_common_traits = table.keys(WeaponTraitsMeleeCommon)

table.append(weapon_template.traits, melee_common_traits)

local bespoke_combataxe_p2_traits = table.keys(WeaponTraitsBespokeCombataxeP2)

table.append(weapon_template.traits, bespoke_combataxe_p2_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_fast_attack"
	},
	{
		display_name = "loc_weapon_keyword_ninja_fencer"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_ninja_fencer",
		type = "ninja_fencer",
		attack_chain = {
			"smiter",
			"ninja_fencer",
			"ninja_fencer"
		}
	},
	secondary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"ninja_fencer",
			"smiter"
		}
	},
	special = {
		display_name = "loc_weapon_special_special_attack",
		type = "special_attack"
	}
}

return weapon_template
