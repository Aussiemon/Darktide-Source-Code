local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MeleeActionInputSetupMid = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_mid")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeCombataxeP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combataxe_p1")
local WeaponTraitsMeleeCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
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
local weapon_template = {
	action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs),
	action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)
}
weapon_template.action_inputs.block.buffer_time = 0.1
weapon_template.action_inputs.block_release.buffer_time = 0.35
local combat_axe_sweep_box = {
	0.15,
	0.15,
	1
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
				modifier = 1,
				t = 0.3
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
				action_name = "action_melee_start_left"
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_special_uppercut"
			}
		}
	},
	action_melee_start_left = {
		anim_event_3p = "attack_swing_charge_left",
		chain_anim_event = "heavy_charge_left",
		start_input = "start_attack",
		kind = "windup",
		chain_anim_event_3p = "attack_swing_charge_left",
		anim_end_event = "attack_finished",
		allowed_during_sprint = true,
		anim_event = "heavy_charge_left_backside",
		stop_input = "attack_cancel",
		total_time = 3,
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
	action_left_down_light = {
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		weapon_handling_template = "time_scale_1",
		max_num_saved_entries = 20,
		first_person_hit_stop_anim = "hit_stop",
		range_mod = 1.25,
		num_frames_before_process = 0,
		allowed_during_sprint = true,
		anim_event_3p = "attack_swing_down",
		damage_window_end = 0.38333333333333336,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_left_down",
		total_time = 1.3,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.55
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.55
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = combat_axe_sweep_box,
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/axe/attack_left_down",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.light_axe_smiter,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash
	},
	action_left_heavy = {
		damage_window_start = 0.16666666666666666,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		weapon_handling_template = "time_scale_1",
		first_person_hit_anim = "hit_left_shake",
		max_num_saved_entries = 20,
		range_mod = 1.25,
		num_frames_before_process = 0,
		allowed_during_sprint = true,
		attack_direction_override = "left",
		damage_window_end = 0.26666666666666666,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_heavy_left",
		anim_event = "heavy_attack_left_backside",
		hit_stop_anim = "attack_hit",
		total_time = 1,
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
				chain_time = 0.63
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.63
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = combat_axe_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/axe/heavy_attack_left",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.heavy_axe_spike,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.horizontal_slash,
		herding_template = HerdingTemplates.linesman_left_heavy
	},
	action_melee_start_right = {
		anim_end_event = "attack_finished",
		kind = "windup",
		anim_event_3p = "attack_swing_charge_down",
		anim_event = "heavy_charge_down_right_backside",
		stop_input = "attack_cancel",
		total_time = 3,
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
				chain_time = 0.5
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
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_0_9",
		kind = "sweep",
		max_num_saved_entries = 20,
		first_person_hit_stop_anim = "hit_stop",
		anim_event_3p = "attack_swing_left_diagonal",
		num_frames_before_process = 0,
		range_mod = 1.25,
		damage_window_end = 0.43333333333333335,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_left_diagonal_down",
		hit_stop_anim = "attack_hit",
		total_time = 1.5,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.7
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.7
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = combat_axe_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/axe/attack_left_diagonal_down",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.light_axe_smiter,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash
	},
	action_right_heavy = {
		damage_window_start = 0.13333333333333333,
		hit_armor_anim = "attack_hit_shield",
		range_mod = 1.25,
		kind = "sweep",
		weapon_handling_template = "time_scale_0_9",
		max_num_saved_entries = 20,
		attack_direction_override = "push",
		num_frames_before_process = 0,
		damage_window_end = 0.43333333333333335,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_heavy_down",
		anim_event = "heavy_attack_right_down_backside",
		hit_stop_anim = "attack_hit",
		total_time = 1,
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
				action_name = "action_unwield",
				chain_time = 0.3
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.5
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.5
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4
			}
		},
		hit_zone_priority = hit_zone_priority,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = combat_axe_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/axe/heavy_attack_down_right",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.heavy_axe,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash
	},
	action_melee_start_left_2 = {
		anim_end_event = "attack_finished",
		chain_anim_event_3p = "attack_swing_charge_down",
		kind = "windup",
		anim_event_3p = "attack_swing_charge_down",
		anim_event = "heavy_charge_down_left_backside",
		stop_input = "attack_cancel",
		total_time = 3,
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
				action_name = "action_left_heavy_last",
				chain_time = 0.6
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
		damage_window_start = 0.32,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1",
		kind = "sweep",
		max_num_saved_entries = 20,
		first_person_hit_stop_anim = "hit_stop",
		anim_event_3p = "attack_swing_right_diagonal",
		num_frames_before_process = 0,
		range_mod = 1.25,
		damage_window_end = 0.45,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_right_down",
		total_time = 1.3,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.8
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.8
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = combat_axe_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/axe/attack_right_down",
			anchor_point_offset = {
				0,
				0,
				-0.2
			}
		},
		damage_profile = DamageProfileTemplates.light_axe_smiter,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.left_45_slash
	},
	action_left_heavy_last = {
		damage_window_start = 0.16666666666666666,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		weapon_handling_template = "time_scale_1",
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		allowed_during_sprint = true,
		range_mod = 1.25,
		attack_direction_override = "push",
		damage_window_end = 0.5,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_heavy_down",
		anim_event = "heavy_attack_left_down_backside",
		total_time = 1,
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
				chain_time = 0.73
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.73
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = combat_axe_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/axe/heavy_attack_down_left",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.heavy_axe,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash
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
				action_name = "action_special_uppercut",
				chain_time = 0.3
			}
		}
	},
	action_right_light_pushfollow = {
		damage_window_start = 0.26666666666666666,
		hit_armor_anim = "hit_stop",
		anim_event_3p = "attack_swing_right",
		weapon_handling_template = "time_scale_1",
		max_num_saved_entries = 20,
		kind = "sweep",
		first_person_hit_stop_anim = "hit_stop",
		num_frames_before_process = 0,
		attack_direction_override = "right",
		range_mod = 1.35,
		damage_window_end = 0.5,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_right",
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
				action_name = "action_melee_start_left_2",
				chain_time = 0.55
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.55
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = combat_axe_sweep_box,
		herding_template = HerdingTemplates.linesman_right_heavy,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/axe/attack_right",
			anchor_point_offset = {
				0,
				0,
				-0.15
			}
		},
		damage_profile = DamageProfileTemplates.medium_axe_tank,
		damage_type = damage_types.blunt,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_push = {
		push_radius = 2.5,
		block_duration = 0.5,
		kind = "push",
		anim_event = "attack_push",
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
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical
	},
	action_special_uppercut = {
		damage_window_start = 0.5666666666666667,
		hit_armor_anim = "attack_hit_shield",
		start_input = "special_action",
		kind = "sweep",
		max_num_saved_entries = 20,
		first_person_hit_stop_anim = "hit_stop",
		weapon_handling_template = "time_scale_1_3",
		num_frames_before_process = 0,
		allowed_during_sprint = true,
		attack_direction_override = "up",
		damage_window_end = 0.7666666666666667,
		anim_end_event = "attack_finished",
		range_mod = 1.25,
		anim_event_3p = "attack_swing_up_left",
		anim_event = "attack_special_uppercut",
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
				action_name = "action_melee_start_right",
				chain_time = 1
			},
			push_follow_up = {
				action_name = "action_right_light_pushfollow",
				chain_time = 1
			},
			block = {
				action_name = "action_block",
				chain_time = 1.2
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = combat_axe_sweep_box,
		herding_template = HerdingTemplates.uppercut,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/axe/special_attack_uppercut",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.axe_uppercut,
		damage_type = damage_types.axe_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash
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
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/axe"
weapon_template.weapon_box = combat_axe_sweep_box
weapon_template.sprint_ready_up_time = 0.1
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
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
	"p1"
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "smiter"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "combataxe_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.combat_axe
weapon_template.overclocks = {
	armor_pierce_up_dps_down = {
		combataxe_p1_m1_armor_pierce_stat = 0.1,
		combataxe_p1_m1_dps_stat = -0.1
	},
	finesse_up_armor_pierce_down = {
		combataxe_p1_m1_armor_pierce_stat = -0.2,
		combataxe_p1_m1_finesse_stat = 0.2
	},
	first_target_up_armor_pierce_down = {
		combataxe_p1_m1_armor_pierce_stat = -0.1,
		combataxe_p1_m1_first_target_stat = 0.1
	},
	mobility_up_first_target_down = {
		combataxe_p1_m1_mobility_stat = 0.1,
		combataxe_p1_m1_first_target_stat = -0.1
	},
	dps_up_mobility_down = {
		combataxe_p1_m1_mobility_stat = -0.1,
		combataxe_p1_m1_dps_stat = 0.1
	}
}
weapon_template.base_stats = {
	combataxe_p1_m1_dps_stat = {
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
			action_special_uppercut = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_stat
			}
		}
	},
	combataxe_p1_m1_armor_pierce_stat = {
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
			action_special_uppercut = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat
			}
		}
	},
	combataxe_p1_m1_finesse_stat = {
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
			action_special_uppercut = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_light_pushfollow = {
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
			action_special_uppercut = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat
			}
		}
	},
	combataxe_p1_m1_first_target_stat = {
		display_name = "loc_stats_display_first_target_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_heavy = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_light = {
				damage_trait_templates.default_first_target_stat
			},
			action_special_uppercut = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_first_target_stat
			}
		}
	},
	combataxe_p1_m1_mobility_stat = {
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

local bespoke_combataxe_p1_traits = table.keys(WeaponTraitsBespokeCombataxeP1)

table.append(weapon_template.traits, bespoke_combataxe_p1_traits)

weapon_template.perks = {
	combataxe_p1_m1_dps_perk = {
		description = "loc_trait_description_combataxe_p1_m1_dps_perk",
		display_name = "loc_trait_display_combataxe_p1_m1_dps_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_left_light = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_special_uppercut = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_perk
			}
		}
	},
	default_armor_pierce_perk = {
		description = "loc_trait_description_combataxe_p1_m1_armor_pierce_perk",
		display_name = "loc_trait_display_combataxe_p1_m1_armor_pierce_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_left_heavy = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_right_heavy = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_left_light = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_special_uppercut = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_perk
			}
		}
	},
	combataxe_p1_m1_finesse_perk = {
		description = "loc_trait_description_combataxe_p1_m1_finesse_perk",
		display_name = "loc_trait_display_combataxe_p1_m1_finesse_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_left_light = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_special_uppercut = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_finesse_perk
			}
		},
		weapon_handling = {
			action_left_down_light = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_left_heavy = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_right_diagonal_light = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_right_heavy = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_special_uppercut = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_right_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_perk
			}
		}
	},
	combataxe_p1_m1_first_target_perk = {
		description = "loc_trait_description_combataxe_p1_m1_first_target_perk",
		display_name = "loc_trait_display_combataxe_p1_m1_first_target_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_left_light = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_special_uppercut = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_first_target_perk
			}
		}
	},
	combataxe_p1_m1_mobility_perk = {
		description = "loc_trait_description_combataxe_p1_m1_mobility_perk",
		display_name = "loc_trait_display_combataxe_p1_m1_mobility_perk",
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_perk
			}
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_perk
			}
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_perk
			}
		}
	}
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_smiter"
	},
	{
		display_name = "loc_weapon_keyword_armor_piercing"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
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
		display_name = "loc_weapon_special_special_attack",
		type = "special_attack"
	}
}

return weapon_template
