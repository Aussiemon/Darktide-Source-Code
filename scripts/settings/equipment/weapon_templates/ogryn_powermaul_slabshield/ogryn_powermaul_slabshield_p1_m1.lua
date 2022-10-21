local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DefaultMeleeActionInputSetup = require("scripts/settings/equipment/weapon_templates/default_melee_action_input_setup")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
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
			total_time = 0.3,
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
					action_name = "action_weapon_special"
				}
			}
		},
		action_melee_start_left = {
			allowed_during_sprint = true,
			anim_end_event = "attack_finished",
			start_input = "start_attack",
			kind = "windup",
			uninterruptible = true,
			anim_event = "heavy_charge_shieldstab",
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
			first_person_hit_stop_anim = "attack_hit",
			kind = "sweep",
			range_mod = 1.25,
			allowed_during_sprint = true,
			anim_end_event = "attack_finished",
			damage_window_end = 0.6,
			uninterruptible = true,
			anim_event = "attack_left_down",
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
				},
				special_action = {
					action_name = "action_weapon_special",
					chain_time = 0.9
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
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/swing_left_diagonal",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_light_smiter,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_smiter_active,
			damage_type_special_active = damage_types.ogryn_pipe_club,
			herding_template = HerdingTemplates.ogryn_punch
		},
		action_left_heavy = {
			damage_window_start = 0.4666666666666667,
			hit_armor_anim = "attack_hit",
			range_mod = 1.25,
			weapon_handling_template = "time_scale_1",
			first_person_hit_stop_anim = "attack_hit",
			kind = "sweep",
			invert_attack_direction = false,
			damage_window_end = 0.6,
			anim_end_event = "attack_finished",
			uninterruptible = true,
			anim_event = "heavy_attack_shieldslam",
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
					action_name = "action_melee_start_left_2",
					chain_time = 0.85
				},
				block = {
					action_name = "action_block"
				},
				special_action = {
					action_name = "action_weapon_special",
					chain_time = 1
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
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/heavy_swing_shieldslam",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_heavy_tank,
			damage_type = damage_types.ogryn_pipe_club,
			herding_template = HerdingTemplates.linesman_left_heavy
		},
		action_melee_start_right = {
			first_person_hit_stop_anim = "attack_hit",
			anim_end_event = "attack_finished",
			kind = "windup",
			first_person_hit_anim = "attack_hit",
			uninterruptible = true,
			anim_event = "heavy_charge_shieldslam",
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
			weapon_handling_template = "time_scale_1",
			anim_end_event = "attack_finished",
			kind = "sweep",
			attack_direction_override = "up",
			range_mod = 1.25,
			first_person_hit_stop_anim = "attack_hit",
			damage_window_end = 0.6,
			uninterruptible = true,
			anim_event = "attack_right_up",
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
					chain_time = 0.75
				},
				block = {
					action_name = "action_block",
					chain_time = 0
				},
				special_action = {
					action_name = "action_weapon_special",
					chain_time = 0.9
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
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/swing_right_up",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_light_smiter,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_smiter_active,
			damage_type_special_active = damage_types.ogryn_pipe_club
		},
		action_right_heavy = {
			damage_window_start = 0.4,
			hit_armor_anim = "attack_hit",
			range_mod = 1.25,
			weapon_handling_template = "time_scale_1",
			kind = "sweep",
			first_person_hit_stop_anim = "attack_hit",
			invert_attack_direction = false,
			allowed_during_sprint = true,
			damage_window_end = 0.5333333333333333,
			anim_end_event = "attack_finished",
			uninterruptible = true,
			anim_event = "heavy_attack_shieldstab",
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
				},
				special_action = {
					action_name = "action_weapon_special",
					chain_time = 1
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
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/heavy_swing_shieldstab",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_heavy_tank,
			damage_type = damage_types.ogryn_pipe_club,
			herding_template = HerdingTemplates.linesman_left_heavy
		},
		action_melee_start_left_2 = {
			chain_anim_event_3p = "heavy_charge_shieldstab",
			chain_anim_event = "heavy_charge_shieldstab_pose",
			anim_end_event = "attack_finished",
			kind = "windup",
			first_person_hit_anim = "attack_hit",
			first_person_hit_stop_anim = "attack_hit",
			uninterruptible = true,
			anim_event = "heavy_charge_shieldstab",
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
			damage_window_start = 0.4,
			hit_armor_anim = "attack_hit",
			anim_end_event = "attack_finished",
			kind = "sweep",
			attack_direction_override = "left",
			range_mod = 1.25,
			weapon_handling_template = "time_scale_1",
			first_person_hit_stop_anim = "attack_hit",
			damage_window_end = 0.6,
			uninterruptible = true,
			anim_event = "attack_left_diagonal_down",
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
					action_name = "action_melee_start_right_2",
					chain_time = 0.7
				},
				block = {
					action_name = "action_block"
				},
				special_action = {
					action_name = "action_weapon_special",
					chain_time = 0.9
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
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/swing_left_diagonal",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_linesman_active,
			damage_type_special_active = damage_types.ogryn_pipe_club,
			herding_template = HerdingTemplates.linesman_left_heavy
		},
		action_melee_start_right_2 = {
			first_person_hit_stop_anim = "attack_hit",
			anim_end_event = "attack_finished",
			kind = "windup",
			first_person_hit_anim = "attack_hit",
			uninterruptible = true,
			anim_event = "heavy_charge_shieldslam",
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
					action_name = "action_right_light_2"
				},
				heavy_attack = {
					action_name = "action_left_heavy",
					chain_time = 0.8
				},
				block = {
					action_name = "action_block"
				},
				special_action = {
					action_name = "action_weapon_special",
					chain_time = 0.8
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end
		},
		action_right_light_2 = {
			damage_window_start = 0.4666666666666667,
			hit_armor_anim = "attack_hit_shield",
			weapon_handling_template = "time_scale_1_2",
			first_person_hit_anim = "hit_right_shake",
			first_person_hit_stop_anim = "attack_hit",
			stagger_duration_modifier_template = "default",
			range_mod = 1.25,
			damage_window_end = 0.6,
			kind = "sweep",
			attack_direction_override = "right",
			anim_end_event = "attack_finished",
			uninterruptible = true,
			anim_event = "attack_right_diagonal_down",
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
					chain_time = 1.4
				},
				block = {
					action_name = "action_block",
					chain_time = 0
				},
				special_action = {
					action_name = "action_weapon_special",
					chain_time = 1.3
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
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/swing_right_diagonal",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_linesman_active,
			damage_type_special_active = damage_types.ogryn_pipe_club,
			herding_template = HerdingTemplates.linesman_right_heavy
		},
		action_melee_start_left_activated = {
			anim_end_event = "attack_finished",
			kind = "windup",
			uninterruptible = true,
			anim_event = "heavy_charge_down",
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
					action_name = "action_left_heavy_activated",
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
		action_left_heavy_activated = {
			damage_window_start = 0.4,
			hit_armor_anim = "attack_hit_shield",
			weapon_handling_template = "time_scale_1_3",
			first_person_hit_anim = "hit_left_shake",
			stagger_duration_modifier_template = "default",
			first_person_hit_stop_anim = "attack_hit",
			range_mod = 1.25,
			allowed_during_sprint = true,
			damage_window_end = 0.6,
			kind = "sweep",
			anim_end_event = "attack_finished",
			attack_direction_override = "left",
			uninterruptible = true,
			anim_event = "heavy_attack_down",
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
					action_name = "action_melee_start_left_2",
					chain_time = 0.91
				},
				block = {
					action_name = "action_block",
					chain_time = 0.7
				},
				special_action = {
					action_name = "action_weapon_special",
					chain_time = 1.2
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
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/heavy_swing_down_left",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_heavy_tank,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_heavy_tank_active,
			damage_type_special_active = damage_types.ogryn_pipe_club,
			herding_template = HerdingTemplates.linesman_left_heavy
		},
		action_weapon_special = {
			kind = "activate_special",
			start_input = "special_action",
			activation_time = 1.3,
			allowed_during_sprint = true,
			anim_event = "activate",
			skip_3p_anims = false,
			total_time = 2.8,
			action_movement_curve = {
				{
					modifier = 0.8,
					t = 0.15
				},
				{
					modifier = 0.5,
					t = 0.2
				},
				{
					modifier = 0.3,
					t = 0.3
				},
				{
					modifier = 0.1,
					t = 0.6
				},
				{
					modifier = 0.55,
					t = 1.2
				},
				{
					modifier = 0.9,
					t = 1.3
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
					action_name = "action_melee_start_left_activated",
					chain_time = 1.4
				},
				block = {
					action_name = "action_block",
					chain_time = 1.4
				}
			}
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
					modifier = 0.45,
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
			damage_window_start = 0.16666666666666666,
			hit_armor_anim = "attack_hit",
			anim_end_event = "attack_finished",
			kind = "sweep",
			attack_direction_override = "left",
			range_mod = 1.25,
			weapon_handling_template = "time_scale_1",
			first_person_hit_stop_anim = "attack_hit",
			damage_window_end = 0.3,
			anim_event_3p = "attack_left",
			anim_event = "push_follow_up",
			total_time = 0.9,
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
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/push_follow_up",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_linesman_active,
			damage_type_special_active = damage_types.ogryn_pipe_club,
			herding_template = HerdingTemplates.linesman_left_heavy
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
				wield = {
					action_name = "action_unwield"
				},
				push_follow_up = {
					action_name = "action_right_light_pushfollow",
					chain_time = 0.45
				},
				block = {
					action_name = "action_block",
					chain_time = 0.4
				}
			},
			inner_push_rad = math.pi * 0.55,
			outer_push_rad = math.pi * 1,
			inner_damage_profile = DamageProfileTemplates.ogryn_push,
			inner_damage_type = damage_types.physical,
			outer_damage_profile = DamageProfileTemplates.default_push,
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

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/slab_shield"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/slab_shield_maul"
weapon_template.weapon_box = {
	0.1,
	0.7,
	0.02
}
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.allow_sprinting_with_special = true
weapon_template.weapon_special_class = "WeaponSpecialExplodeOnImpact"
weapon_template.weapon_special_tweak_data = {
	disorientation_type = "ogryn_powermaul_disorientation",
	active_duration = 4,
	explosion_template = ExplosionTemplates.powermaul_activated_impact
}
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
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control"
	},
	{
		display_name = "loc_weapon_keyword_power_weapon"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"smiter",
			"linesman",
			"linesman"
		}
	},
	secondary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {}
	},
	special = {
		display_name = "loc_weapon_special_activate",
		type = "activate"
	}
}

return weapon_template
