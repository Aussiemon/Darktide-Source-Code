local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DefaultMeleeActionInputSetup = require("scripts/settings/equipment/weapon_templates/default_melee_action_input_setup")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local WeaponTraitsMeleeCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local stagger_duration_modifier_trait_templates = WeaponTraitTemplates[template_types.stagger_duration_modifier]
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
			anim_event = "attack_swing_charge_left",
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
					action_name = "action_left_heavy",
					chain_time = 0.78
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
			hit_armor_anim = "attack_hit_shield",
			anim_end_event = "attack_finished",
			weapon_handling_template = "time_scale_1",
			first_person_hit_anim = "hit_left_shake",
			range_mod = 1.25,
			first_person_hit_stop_anim = "attack_hit",
			invert_attack_direction = true,
			kind = "sweep",
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
			damage_profile = DamageProfileTemplates.ogryn_club_light_linesman,
			damage_type = damage_types.ogryn_pipe_club,
			herding_template = HerdingTemplates.linesman_left_heavy_inverted
		},
		action_left_heavy = {
			damage_window_start = 0.4666666666666667,
			hit_armor_anim = "attack_hit_shield",
			range_mod = 1.25,
			weapon_handling_template = "time_scale_1",
			first_person_hit_anim = "hit_left_shake",
			kind = "sweep",
			first_person_hit_stop_anim = "attack_hit",
			invert_attack_direction = true,
			damage_window_end = 0.6,
			anim_end_event = "attack_finished",
			uninterruptible = true,
			anim_event = "attack_swing_heavy_left",
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
					action_name = "action_melee_start_right",
					chain_time = 0.9
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
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_left",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_club_heavy_tank,
			damage_type = damage_types.ogryn_pipe_club,
			herding_template = HerdingTemplates.linesman_left_heavy_inverted
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
					action_name = "action_right_heavy",
					chain_time = 0.78
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
			hit_armor_anim = "attack_hit_shield",
			anim_end_event = "attack_finished",
			kind = "sweep",
			first_person_hit_anim = "hit_right_shake",
			range_mod = 1.25,
			first_person_hit_stop_anim = "hit_right_shake",
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
			damage_profile = DamageProfileTemplates.ogryn_club_light_linesman,
			damage_type = damage_types.ogryn_pipe_club,
			herding_template = HerdingTemplates.linesman_right_heavy_inverted
		},
		action_right_heavy = {
			damage_window_start = 0.4,
			hit_armor_anim = "attack_hit_shield",
			anim_end_event = "attack_finished",
			kind = "sweep",
			first_person_hit_anim = "hit_right_shake",
			range_mod = 1.25,
			first_person_hit_stop_anim = "attack_hit",
			invert_attack_direction = true,
			weapon_handling_template = "time_scale_1_5",
			damage_window_end = 0.5333333333333333,
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
			allowed_chain_actions = {
				wield = {
					action_name = "action_unwield",
					chain_time = 0.3
				},
				start_attack = {
					action_name = "action_melee_start_left",
					chain_time = 1
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
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_left",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_club_heavy_tank,
			damage_type = damage_types.ogryn_pipe_club,
			herding_template = HerdingTemplates.linesman_right_heavy_inverted
		},
		action_melee_start_left_2 = {
			first_person_hit_stop_anim = "attack_hit",
			anim_end_event = "attack_finished",
			kind = "windup",
			first_person_hit_anim = "attack_hit",
			uninterruptible = true,
			anim_event = "attack_swing_charge_left",
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
					action_name = "action_left_heavy",
					chain_time = 0.78
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
			damage_window_start = 0.4,
			hit_armor_anim = "attack_hit_shield",
			anim_end_event = "attack_finished",
			kind = "sweep",
			first_person_hit_anim = "hit_left_shake",
			range_mod = 1.25,
			first_person_hit_stop_anim = "attack_hit",
			invert_attack_direction = true,
			weapon_handling_template = "time_scale_0_9",
			damage_window_end = 0.5333333333333333,
			uninterruptible = true,
			anim_event = "attack_swing_down",
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
					chain_time = 0.7
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
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_down_left",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_club_heavy_smiter,
			damage_type = damage_types.ogryn_pipe_club,
			herding_template = HerdingTemplates.linesman_left_heavy_inverted
		},
		action_weapon_special = {
			damage_window_start = 0.3333333333333333,
			hit_armor_anim = "attack_hit_shield",
			start_input = "special_action",
			kind = "sweep",
			first_person_hit_anim = "hit_right_shake",
			range_mod = 1.25,
			first_person_hit_stop_anim = "hit_right_shake",
			weapon_handling_template = "time_scale_0_9",
			invert_attack_direction = true,
			activation_cooldown = 6,
			damage_window_end = 0.4,
			anim_end_event = "attack_finished",
			activate_special = true,
			uninterruptible = true,
			anim_event = "attack_swing_slap",
			power_level = 500,
			total_time = 1.8,
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
					chain_time = 0.7
				},
				block = {
					action_name = "action_block",
					chain_time = 0.81
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
			damage_profile = DamageProfileTemplates.ogryn_club_special,
			damage_type = damage_types.ogryn_slap,
			herding_template = HerdingTemplates.linesman_right_heavy_inverted
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
			hit_armor_anim = "attack_hit_shield",
			anim_end_event = "attack_finished",
			range_mod = 1.25,
			kind = "sweep",
			first_person_hit_anim = "hit_right_shake",
			weapon_handling_template = "time_scale_1",
			first_person_hit_stop_anim = "hit_right_shake",
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
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_right",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_club_smiter_pushfollow,
			damage_type = damage_types.ogryn_pipe_club
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
	},
	base_stats = {
		ogryn_powermaul_dps_stat = {
			display_name = "loc_stats_display_damage_stat",
			is_stat_trait = true,
			damage = {
				action_left_light = {
					damage_trait_templates.default_melee_dps_stat
				},
				action_left_heavy = {
					damage_trait_templates.default_melee_dps_stat
				},
				action_right_light = {
					damage_trait_templates.default_melee_dps_stat
				},
				action_right_heavy = {
					damage_trait_templates.default_melee_dps_stat
				},
				action_left_light_2 = {
					damage_trait_templates.default_melee_dps_stat
				},
				action_weapon_special = {
					damage_trait_templates.default_melee_dps_stat
				},
				action_right_light_pushfollow = {
					damage_trait_templates.default_melee_dps_stat
				}
			}
		},
		ogryn_powermaul_armor_pierce_stat = {
			display_name = "loc_stats_display_ap_stat",
			is_stat_trait = true,
			damage = {
				action_left_light = {
					damage_trait_templates.default_armor_pierce_stat
				},
				action_left_heavy = {
					damage_trait_templates.default_armor_pierce_stat
				},
				action_right_light = {
					damage_trait_templates.default_armor_pierce_stat
				},
				action_right_heavy = {
					damage_trait_templates.default_armor_pierce_stat
				},
				action_left_light_2 = {
					damage_trait_templates.default_armor_pierce_stat
				},
				action_weapon_special = {
					damage_trait_templates.default_armor_pierce_stat
				},
				action_right_light_pushfollow = {
					damage_trait_templates.default_armor_pierce_stat
				}
			}
		},
		ogryn_powermaul_control_stat = {
			display_name = "loc_stats_display_control_stat",
			is_stat_trait = true,
			damage = {
				action_left_light = {
					damage_trait_templates.thunderhammer_control_stat
				},
				action_left_heavy = {
					damage_trait_templates.thunderhammer_control_stat
				},
				action_right_light = {
					damage_trait_templates.thunderhammer_control_stat
				},
				action_right_heavy = {
					damage_trait_templates.thunderhammer_control_stat
				},
				action_left_light_2 = {
					damage_trait_templates.thunderhammer_control_stat
				},
				action_weapon_special = {
					damage_trait_templates.thunderhammer_control_stat
				},
				action_right_light_pushfollow = {
					damage_trait_templates.thunderhammer_control_stat
				}
			},
			weapon_handling = {
				action_left_down_light = {
					weapon_handling_trait_templates.default_finesse_stat
				},
				action_left_heavy = {
					weapon_handling_trait_templates.default_finesse_stat
				},
				action_right_light = {
					weapon_handling_trait_templates.default_finesse_stat
				},
				action_right_heavy = {
					weapon_handling_trait_templates.default_finesse_stat
				},
				action_left_light_2 = {
					weapon_handling_trait_templates.default_finesse_stat
				},
				action_weapon_special = {
					weapon_handling_trait_templates.default_finesse_stat
				},
				action_right_light_pushfollow = {
					weapon_handling_trait_templates.default_finesse_stat
				}
			},
			stagger_duration_modifier = {
				action_left_down_light = {
					stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
				},
				action_left_heavy = {
					stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
				},
				action_right_light = {
					stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
				},
				action_right_heavy = {
					stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
				},
				action_left_light_2 = {
					stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
				},
				action_weapon_special = {
					stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
				},
				action_right_light_pushfollow = {
					stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
				}
			}
		},
		ogryn_powermaul_first_target_stat = {
			display_name = "loc_stats_display_first_target_stat",
			is_stat_trait = true,
			damage = {
				action_left_light = {
					damage_trait_templates.default_first_target_stat
				},
				action_left_heavy = {
					damage_trait_templates.default_first_target_stat
				},
				action_right_light = {
					damage_trait_templates.default_first_target_stat
				},
				action_right_heavy = {
					damage_trait_templates.default_first_target_stat
				},
				action_left_light_2 = {
					damage_trait_templates.default_first_target_stat
				},
				action_weapon_special = {
					damage_trait_templates.default_first_target_stat
				},
				action_right_light_pushfollow = {
					damage_trait_templates.default_first_target_stat
				}
			}
		},
		ogryn_powermaul_defence_stat = {
			display_name = "loc_stats_display_defense_stat",
			is_stat_trait = true,
			stamina = {
				base = {
					stamina_trait_templates.thunderhammer_p1_m1_defence_stat
				}
			},
			dodge = {
				base = {
					dodge_trait_templates.default_dodge_stat
				}
			}
		}
	}
}
local melee_common_traits = table.keys(WeaponTraitsMeleeCommon)

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/power_maul"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/club_ogryn"
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
weapon_template.fx_sources = {
	_block = "fx_block",
	_sweep = "fx_sweep"
}
weapon_template.crosshair_type = "dot"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"ogryn_power_maul",
	"p1"
}
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "ogryn_club_p1_m1"
weapon_template.footstep_intervals = {
	crouch_walking = 0.61,
	walking = 0.6,
	sprinting = 0.37
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee

return weapon_template
