local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MeleeActionInputSetupSlow = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_slow")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local WeaponTraitsBespokeOgrynCombatbladeP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_combatblade_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local buff_stat_buffs = BuffSettings.stat_buffs
local template_types = WeaponTweakTemplateSettings.template_types
local wounds_shapes = WoundsSettings.shapes
local armor_types = ArmorSettings.types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local weapon_template = {}
local hit_zone_names = HitZone.hit_zone_names
local melee_sticky_disallowed_hit_zones = {
	hit_zone_names.lower_left_arm,
	hit_zone_names.lower_right_arm,
	hit_zone_names.lower_left_leg,
	hit_zone_names.lower_right_leg
}
local default_weapon_box = {
	0.2,
	0.15,
	1.1
}
weapon_template.action_inputs = table.clone(MeleeActionInputSetupSlow.action_inputs)
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupSlow.action_input_hierarchy)
local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.weakspot] = 2,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

weapon_template.action_inputs.block.buffer_time = 0.3
weapon_template.action_inputs.start_attack.buffer_time = 0.5
weapon_template.action_inputs.push_follow_up.buffer_time = 0.5
weapon_template.action_inputs.push.buffer_time = 0.8
weapon_template.action_inputs.special_action.buffer_time = 0.5
weapon_template.actions = {
	action_unwield = {
		start_input = "wield",
		allowed_during_sprint = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_wield = {
		kind = "wield",
		allowed_during_sprint = true,
		anim_event = "equip",
		sprint_ready_up_time = 0,
		total_time = 0.1,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			block = {
				action_name = "action_block"
			},
			start_attack = {
				action_name = "action_melee_start_right"
			},
			special_action = {
				action_name = "action_special_uppercut"
			}
		}
	},
	action_melee_start_left = {
		anim_event_3p = "attack_swing_charge_down_left",
		chain_anim_event = "attack_swing_charge_down_pose",
		start_input = "start_attack",
		kind = "windup",
		chain_anim_event_3p = "attack_swing_charge_down_left",
		anim_end_event = "attack_finished",
		allowed_during_sprint = true,
		anim_event = "attack_swing_charge_down",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05
			},
			{
				modifier = 0.25,
				t = 0.1
			},
			{
				modifier = 0.2,
				t = 0.25
			},
			{
				modifier = 0.35,
				t = 0.4
			},
			{
				modifier = 0.8,
				t = 1
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_left_light"
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.65
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
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		first_person_hit_anim = "hit_left_shake",
		range_mod = 1.25,
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		weapon_handling_template = "time_scale_1",
		damage_window_end = 0.4666666666666667,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_left_diagonal",
		anim_event = "attack_swing_left",
		power_level = 500,
		total_time = 1.15,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.11
			},
			{
				modifier = 0.8,
				t = 0.15
			},
			{
				modifier = 1.5,
				t = 0.19
			},
			{
				modifier = 1.4,
				t = 0.31
			},
			{
				modifier = 1,
				t = 0.38
			},
			{
				modifier = 0.5,
				t = 0.46
			},
			{
				modifier = 1,
				t = 0.77
			},
			start_modifier = 0.2
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			block = {
				action_name = "action_block",
				chain_time = 0.42
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.65
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.23
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.4
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/combat_blade/swing_left",
			anchor_point_offset = {
				0.08,
				-0.8,
				-0.3
			}
		},
		damage_profile = DamageProfileTemplates.combat_blade_light_linesman,
		damage_type = damage_types.combat_blade,
		herding_template = HerdingTemplates.linesman_left_heavy,
		wounds_shape = wounds_shapes.horizontal_slash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_left_heavy = {
		damage_window_start = 0.26666666666666666,
		hit_armor_anim = "attack_hit_shield",
		anim_end_event = "attack_finished",
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		range_mod = 1.25,
		first_person_hit_stop_anim = "attack_hit",
		weapon_handling_template = "time_scale_1",
		damage_window_end = 0.36666666666666664,
		anim_event_3p = "attack_swing_heavy_down_right",
		anim_event = "attack_swing_heavy_right",
		power_level = 500,
		total_time = 2,
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
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.75
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.42
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
		weapon_box = {
			0.2,
			0.5,
			1.35
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/combat_blade/heavy_swing_right",
			anchor_point_offset = {
				0,
				-0.4,
				-0.2
			}
		},
		damage_profile = DamageProfileTemplates.combat_blade_heavy_linesman,
		damage_type = damage_types.combat_blade,
		herding_template = HerdingTemplates.linesman_right_heavy,
		wounds_shape = wounds_shapes.right_45_slash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		chain_anim_event = "attack_swing_charge_right_pose",
		chain_anim_event_3p = "attack_swing_charge_down_right",
		kind = "windup",
		first_person_hit_anim = "hit_right_shake",
		anim_end_event = "attack_finished",
		first_person_hit_stop_anim = "attack_hit",
		anim_event_3p = "attack_swing_charge_down_right",
		anim_event = "attack_swing_charge_right",
		hit_stop_anim = "attack_hit_shield",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05
			},
			{
				modifier = 0.25,
				t = 0.1
			},
			{
				modifier = 0.2,
				t = 0.25
			},
			{
				modifier = 0.35,
				t = 0.4
			},
			{
				modifier = 0.8,
				t = 1
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_right_light"
			},
			heavy_attack = {
				action_name = "action_left_heavy",
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
	action_right_light = {
		damage_window_start = 0.26666666666666666,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		range_mod = 1.25,
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		weapon_handling_template = "time_scale_1",
		damage_window_end = 0.4,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_right_diagonal",
		anim_event = "attack_swing_right_diagonal",
		power_level = 500,
		total_time = 1.5,
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
			{
				modifier = 0.5,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 0.2
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.6
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.3
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.2
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/combat_blade/swing_right_diagonal",
			anchor_point_offset = {
				-0.05,
				-0.2,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.combat_blade_light_linesman,
		damage_type = damage_types.combat_blade,
		herding_template = HerdingTemplates.linesman_right_heavy,
		wounds_shape = wounds_shapes.right_45_slash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_right_heavy = {
		damage_window_start = 0.23333333333333334,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		range_mod = 1.25,
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		weapon_handling_template = "time_scale_1",
		damage_window_end = 0.3333333333333333,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_heavy_down_left",
		anim_event = "attack_swing_heavy_down_left",
		power_level = 500,
		total_time = 2,
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
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.3
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.8
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.42
			},
			block = {
				action_name = "action_block",
				chain_time = 0.65
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/combat_blade/heavy_swing_down_left",
			anchor_point_offset = {
				0.3,
				-0.4,
				0
			}
		},
		damage_profile = DamageProfileTemplates.combat_blade_heavy_smiter,
		damage_type = damage_types.combat_blade,
		herding_template = HerdingTemplates.smiter_down,
		wounds_shape = wounds_shapes.horizontal_slash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_melee_start_left_2 = {
		kind = "windup",
		chain_anim_event = "attack_swing_charge_down_pose",
		chain_anim_event_3p = "attack_swing_charge_down_left",
		weapon_handling_template = "time_scale_1_3",
		first_person_hit_anim = "hit_left_shake",
		anim_end_event = "attack_finished",
		first_person_hit_stop_anim = "hit_left_shake",
		anim_event_3p = "attack_swing_charge_down_left",
		anim_event = "attack_swing_charge_down",
		hit_stop_anim = "attack_hit_shield",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05
			},
			{
				modifier = 0.25,
				t = 0.1
			},
			{
				modifier = 0.2,
				t = 0.25
			},
			{
				modifier = 0.35,
				t = 0.4
			},
			{
				modifier = 0.8,
				t = 1
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_left_light_2"
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.55
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_left_light_2 = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit_shield",
		range_mod = 1.25,
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		weapon_handling_template = "time_scale_1",
		anim_end_event = "attack_finished",
		damage_window_end = 0.3333333333333333,
		anim_event = "attack_swing_down_left",
		power_level = 500,
		total_time = 1.5,
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
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 0.2
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.4
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.5
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
		weapon_box = {
			0.25,
			0.25,
			1.1
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/combat_blade/swing_left_down",
			anchor_point_offset = {
				0,
				0,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.combat_blade_light_linesman,
		damage_type = damage_types.combat_blade,
		herding_template = HerdingTemplates.stab,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
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
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			push = {
				action_name = "action_push",
				chain_time = 0.25
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.25
			}
		}
	},
	action_right_light_pushfollow = {
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1",
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "hit_left_shake",
		sprint_requires_press_to_interrupt = "true",
		range_mod = 1.4,
		kind = "sweep",
		damage_window_end = 0.36666666666666664,
		anim_end_event = "attack_finished",
		attack_direction_override = "push",
		anim_event_3p = "attack_swing_left_diagonal",
		anim_event = "attack_swing_up_left",
		power_level = 500,
		total_time = 1.42,
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.1
			},
			{
				modifier = 1.15,
				t = 0.2
			},
			{
				modifier = 0.45,
				t = 0.24
			},
			{
				modifier = 0.6,
				t = 0.32
			},
			{
				modifier = 1,
				t = 0.6
			},
			start_modifier = 1.4
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.4
			},
			block = {
				action_name = "action_block",
				chain_time = 1.05
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.43
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/combat_blade/swing_left_diagonal_up",
			anchor_point_offset = {
				-0.05,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.combat_blade_light_linesman,
		damage_type = damage_types.combat_blade,
		herding_template = HerdingTemplates.uppercut,
		wounds_shape = wounds_shapes.right_45_slash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_push = {
		block_duration = 0.5,
		push_radius = 3,
		weapon_handling_template = "time_scale_1_3",
		kind = "push",
		activation_cooldown = 0.2,
		anim_event = "attack_push",
		power_level = 500,
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
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			push_follow_up = {
				action_name = "action_right_light_pushfollow",
				chain_time = 0.45
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 0.45
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.5
			}
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.ogryn_push,
		inner_damage_type = damage_types.ogryn_physical,
		outer_damage_profile = DamageProfileTemplates.default_push,
		outer_damage_type = damage_types.ogryn_physical
	},
	action_special_uppercut = {
		damage_window_start = 0.4,
		hit_armor_anim = "attack_hit_shield",
		start_input = "special_action",
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		range_mod = 1.25,
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		allowed_during_sprint = true,
		weapon_handling_template = "time_scale_1",
		damage_window_end = 0.4666666666666667,
		anim_end_event = "attack_finished",
		attack_direction_override = "push",
		anim_event_3p = "attack_special_uppercut",
		anim_event = "attack_special_uppercut",
		power_level = 500,
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 0.25,
				t = 0.2
			},
			{
				modifier = 1.5,
				t = 0.225
			},
			{
				modifier = 1.5,
				t = 0.35
			},
			{
				modifier = 0.75,
				t = 1
			},
			start_modifier = 0.2
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.7
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55
			},
			special_action = {
				action_name = "action_special_uppercut",
				chain_time = 1
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.4,
			0.35,
			1.2
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/combat_blade/uppercut",
			anchor_point_offset = {
				0.2,
				0.5,
				0
			}
		},
		herding_template = HerdingTemplates.uppercut,
		damage_profile = DamageProfileTemplates.special_uppercut,
		damage_type = damage_types.ogryn_punch,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
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

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/combat_blade"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/combat_blade"
weapon_template.weapon_box = {
	0.1,
	0.7,
	0.02
}
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.2
weapon_template.max_first_person_anim_movement_speed = 4.8
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_block",
	_sweep = "fx_sweep"
}
weapon_template.crosshair = {
	crosshair_type = "dot"
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"combat_blade",
	"p1"
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.damage_trait_templates = "ogryn"
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn_assault"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_combat_blade
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
weapon_template.base_stats = {
	ogryn_combatblade_p1_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_heavy = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_heavy = {
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
			action_left_light = {
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
			action_right_light = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_left_light_2 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_special_uppercut = {
				damage_trait_templates.default_melee_dps_stat
			}
		}
	},
	ogryn_combatblade_p1_m1_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_left_heavy = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								armor_damage_modifier = {
									attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers
								}
							}
						}
					}
				}
			},
			action_left_light = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								armor_damage_modifier = {
									attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers
								}
							}
						}
					}
				}
			},
			action_right_light = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_left_light_2 = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_special_uppercut = {
				damage_trait_templates.default_armor_pierce_stat
			}
		}
	},
	ogryn_combatblade_p1_m1_cleave_stat = {
		display_name = "loc_stats_display_cleave_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_heavy = {
				damage_trait_templates.ogryn_combatblade_p1_m1_cleave_stat
			},
			action_right_heavy = {
				damage_trait_templates.ogryn_combatblade_p1_m1_cleave_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_left_light = {
				damage_trait_templates.ogryn_combatblade_p1_m1_cleave_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_right_light = {
				damage_trait_templates.ogryn_combatblade_p1_m1_cleave_stat
			},
			action_left_light_2 = {
				damage_trait_templates.ogryn_combatblade_p1_m1_cleave_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.ogryn_combatblade_p1_m1_cleave_stat
			}
		}
	},
	ogryn_combatblade_p1_m1_first_target_stat = {
		display_name = "loc_stats_display_first_target_stat",
		is_stat_trait = true,
		damage = {
			action_left_heavy = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_first_target_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_left_light = {
				damage_trait_templates.default_first_target_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_right_light = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_light_2 = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_first_target_stat
			},
			action_special_uppercut = {
				damage_trait_templates.default_first_target_stat
			}
		}
	},
	ogryn_combatblade_p1_m1_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	}
}
weapon_template.traits = {}
local bespoke_ogryn_combatblade_p1 = table.ukeys(WeaponTraitsBespokeOgrynCombatbladeP1)

table.append(weapon_template.traits, bespoke_ogryn_combatblade_p1)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_fast_attack"
	},
	{
		display_name = "loc_weapon_keyword_high_cleave",
		description = "loc_weapon_stats_display_high_cleave_desc"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"linesman",
			"linesman",
			"linesman"
		}
	},
	secondary = {
		display_name = "loc_gestalt_linesman",
		type = "linesman",
		attack_chain = {
			"smiter",
			"linesman"
		}
	},
	special = {
		desc = "loc_stats_special_action_special_attack_ogryn_combatblade_p1m1_desc",
		display_name = "loc_weapon_special_fist_attack",
		type = "melee_hand"
	}
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

weapon_template.special_action_name = "action_special_uppercut"

return weapon_template
