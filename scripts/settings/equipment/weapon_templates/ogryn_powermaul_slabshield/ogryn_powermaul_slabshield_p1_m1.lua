local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DefaultMeleeActionInputSetup = require("scripts/settings/equipment/weapon_templates/default_melee_action_input_setup")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local weapon_template = {
	action_inputs = table.clone(DefaultMeleeActionInputSetup.action_inputs),
	action_input_hierarchy = table.clone(DefaultMeleeActionInputSetup.action_input_hierarchy),
	actions = {
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
			continue_sprinting = true,
			allowed_during_sprint = true,
			kind = "wield",
			uninterruptible = true,
			anim_event = "equip",
			sprint_ready_up_time = 0,
			total_time = 0.1,
			allowed_chain_actions = {}
		},
		action_melee_start_left = {
			anim_end_event = "attack_finished",
			start_input = "start_attack",
			kind = "windup",
			uninterruptible = true,
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
				wield = {
					action_name = "action_unwield"
				},
				light_attack = {
					action_name = "action_left_light"
				},
				heavy_attack = {
					action_name = "action_right_heavy"
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
			damage_window_start = 0.4666666666666667,
			hit_armor_anim = "attack_hit",
			anim_end_event = "attack_finished",
			kind = "sweep",
			range_mod = 1.25,
			first_person_hit_stop_anim = "attack_hit",
			invert_attack_direction = true,
			damage_window_end = 0.6,
			uninterruptible = true,
			anim_event = "attack_swing_left_diagonal",
			power_level = 500,
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
				wield = {
					action_name = "action_unwield"
				},
				start_attack = {
					action_name = "action_melee_start_right",
					chain_time = 0.75
				},
				block = {
					action_name = "action_block"
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end,
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_left_diagonal",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_club_heavy_smiter,
			damage_type = damage_types.shovel_heavy,
			herding_template = HerdingTemplates.thunder_hammer_left_heavy
		},
		action_left_heavy = {
			damage_window_start = 0.4666666666666667,
			hit_armor_anim = "attack_hit",
			range_mod = 1.25,
			weapon_handling_template = "time_scale_1_75",
			first_person_hit_stop_anim = "attack_hit",
			kind = "sweep",
			invert_attack_direction = true,
			damage_window_end = 0.6,
			anim_end_event = "attack_finished",
			uninterruptible = true,
			anim_event = "attack_swing_heavy_right",
			power_level = 500,
			total_time = 3,
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
			powered_weapon_intensity = {
				{
					intensity = 1,
					t = 0.8
				},
				{
					intensity = 0,
					t = 0.8
				},
				start_intensity = 1
			},
			allowed_chain_actions = {
				wield = {
					action_name = "action_unwield"
				},
				start_attack = {
					action_name = "action_melee_start_left",
					chain_time = 0.85
				},
				block = {
					action_name = "action_block"
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end,
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_right",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_shovel_heavy_linesman,
			damage_type = damage_types.shovel_heavy,
			herding_template = HerdingTemplates.smiter_down
		},
		action_melee_start_right = {
			first_person_hit_stop_anim = "attack_hit",
			anim_end_event = "attack_finished",
			kind = "windup",
			first_person_hit_anim = "attack_hit",
			uninterruptible = true,
			anim_event = "attack_swing_charge_right",
			hit_stop_anim = "attack_hit",
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
				wield = {
					action_name = "action_unwield"
				},
				light_attack = {
					action_name = "action_right_light"
				},
				heavy_attack = {
					action_name = "action_left_heavy"
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
			damage_window_start = 0.4666666666666667,
			hit_armor_anim = "attack_hit",
			anim_end_event = "attack_finished",
			kind = "sweep",
			first_person_hit_stop_anim = "attack_hit",
			range_mod = 1.25,
			invert_attack_direction = true,
			weapon_handling_template = "time_scale_1_1",
			damage_window_end = 0.6,
			uninterruptible = true,
			anim_event = "attack_swing_right_diagonal",
			power_level = 500,
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
				wield = {
					action_name = "action_unwield"
				},
				start_attack = {
					action_name = "action_melee_start_left_2",
					chain_time = 0.65
				},
				block = {
					action_name = "action_block",
					chain_time = 0
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end,
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_right_diagonal",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_club_heavy_smiter,
			damage_type = damage_types.shovel_heavy,
			herding_template = HerdingTemplates.thunder_hammer_left_heavy
		},
		action_right_heavy = {
			damage_window_start = 0.4,
			hit_armor_anim = "attack_hit",
			anim_end_event = "attack_finished",
			kind = "sweep",
			first_person_hit_stop_anim = "attack_hit",
			range_mod = 1.25,
			invert_attack_direction = true,
			weapon_handling_template = "time_scale_1_75",
			damage_window_end = 0.5333333333333333,
			uninterruptible = true,
			anim_event = "attack_swing_heavy_down",
			power_level = 500,
			total_time = 3,
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
				wield = {
					action_name = "action_unwield",
					chain_time = 0.3
				},
				start_attack = {
					action_name = "action_melee_start_right",
					chain_time = 0.75
				},
				block = {
					action_name = "action_block",
					chain_time = 0.3
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end,
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_down_left",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_shovel_heavy_linesman,
			damage_type = damage_types.shovel_heavy,
			herding_template = HerdingTemplates.thunder_hammer_right_heavy
		},
		action_melee_start_left_2 = {
			first_person_hit_stop_anim = "attack_hit",
			anim_end_event = "attack_finished",
			kind = "windup",
			first_person_hit_anim = "attack_hit",
			uninterruptible = true,
			anim_event = "attack_swing_charge_down",
			hit_stop_anim = "attack_hit",
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
				wield = {
					action_name = "action_unwield"
				},
				light_attack = {
					action_name = "action_left_light_2"
				},
				heavy_attack = {
					action_name = "action_right_heavy"
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
			damage_window_start = 0.26666666666666666,
			hit_armor_anim = "attack_hit",
			anim_end_event = "attack_finished",
			kind = "sweep",
			first_person_hit_stop_anim = "attack_hit",
			range_mod = 1.25,
			invert_attack_direction = true,
			weapon_handling_template = "time_scale_0_9",
			damage_window_end = 0.4,
			uninterruptible = true,
			anim_event = "attack_swing_stab",
			power_level = 500,
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
				wield = {
					action_name = "action_unwield"
				},
				start_attack = {
					action_name = "action_melee_start_left",
					chain_time = 0.45
				},
				block = {
					action_name = "action_block"
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end,
			weapon_box = {
				0.4,
				1.15,
				0.4
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_stab",
				anchor_point_offset = {
					0.15,
					0.5,
					-0.25
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_club_heavy_smiter,
			damage_type = damage_types.shovel_heavy,
			herding_template = HerdingTemplates.shotgun
		},
		action_weapon_special = {
			damage_window_start = 0.3333333333333333,
			hit_armor_anim = "attack_hit",
			start_input = "special_action",
			kind = "sweep",
			weapon_handling_template = "time_scale_0_9",
			range_mod = 1.25,
			first_person_hit_stop_anim = "attack_hit",
			invert_attack_direction = true,
			damage_window_end = 0.4,
			anim_end_event = "attack_finished",
			uninterruptible = true,
			anim_event = "attack_swing_slap",
			power_level = 500,
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
				wield = {
					action_name = "action_unwield"
				},
				start_attack = {
					action_name = "action_melee_start_left",
					chain_time = 0.45
				},
				block = {
					action_name = "action_block"
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end,
			weapon_box = {
				0.4,
				1.15,
				0.4
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_stab",
				anchor_point_offset = {
					0.15,
					0.5,
					-0.25
				}
			},
			damage_profile = DamageProfileTemplates.push_test,
			damage_type = DamageSettings.damage_types.physical,
			herding_template = HerdingTemplates.shotgun
		},
		action_block = {
			start_input = "block",
			anim_end_event = "parry_finished",
			kind = "block",
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
				wield = {
					action_name = "action_unwield"
				},
				push = {
					action_name = "action_push"
				}
			}
		},
		action_right_light_pushfollow = {
			damage_window_start = 0.4,
			hit_armor_anim = "attack_hit",
			weapon_handling_template = "time_scale_1_75",
			anim_end_event = "attack_finished",
			kind = "sweep",
			range_mod = 1.25,
			first_person_hit_stop_anim = "attack_hit",
			damage_window_end = 0.5333333333333333,
			anim_event = "push_follow_up",
			power_level = 500,
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
				wield = {
					action_name = "action_unwield"
				},
				start_attack = {
					action_name = "action_melee_start_left_2",
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
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_left",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_shovel_heavy_linesman,
			damage_type = damage_types.shovel_heavy
		},
		action_push = {
			push_radius = 2.5,
			block_duration = 0.5,
			kind = "push",
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
				}
			},
			inner_push_rad = math.pi * 0.6,
			outer_push_rad = math.pi * 1,
			inner_damage_profile = DamageProfileTemplates.push_test,
			inner_damage_type = damage_types.physical,
			outer_damage_profile = DamageProfileTemplates.push_test,
			outer_damage_type = damage_types.physical
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
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/combat_blade"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/slab_shield_maul"
weapon_template.weapon_box = {
	0.1,
	0.7,
	0.02
}
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.2
weapon_template.max_first_person_anim_movement_speed = 4.8
weapon_template.has_first_person_dodge_events = true
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {}
weapon_template.crosshair_type = "dot"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"ogryn_powermaul_slabshield",
	"p1"
}
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = {
	crouch_walking = 0.61,
	walking = 0.4,
	sprinting = 0.37
}

return weapon_template
