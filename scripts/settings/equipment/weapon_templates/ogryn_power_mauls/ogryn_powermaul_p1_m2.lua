local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MeleeActionInputSetupSlow = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_slow")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsMeleeCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
local WeaponTraitsBespokeOgrynPowerMaulP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_powermaul_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_template = {
	action_inputs = table.clone(MeleeActionInputSetupSlow.action_inputs),
	action_input_hierarchy = table.clone(MeleeActionInputSetupSlow.action_input_hierarchy),
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
		action_left_light = {
			damage_window_start = 0.4666666666666667,
			hit_armor_anim = "attack_hit_shield",
			weapon_handling_template = "time_scale_1",
			kind = "sweep",
			first_person_hit_anim = "hit_left_shake",
			first_person_hit_stop_anim = "attack_hit",
			allowed_during_sprint = true,
			range_mod = 1.25,
			damage_window_end = 0.6,
			uninterruptible = true,
			anim_event = "attack_swing_left_down",
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
					chain_time = 0.72
				},
				block = {
					action_name = "action_block"
				},
				special_action = {
					action_name = "action_weapon_special_right",
					chain_time = 1
				}
			},
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/swing_down_left",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_light_smiter,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_smiter_active,
			herding_template = HerdingTemplates.ogryn_punch
		},
		action_left_heavy = {
			damage_window_start = 0.4,
			hit_armor_anim = "attack_hit_shield",
			kind = "sweep",
			weapon_handling_template = "time_scale_1_3",
			first_person_hit_anim = "hit_left_shake",
			first_person_hit_stop_anim = "attack_hit",
			allowed_during_sprint = true,
			range_mod = 1.25,
			attack_direction_override = "left",
			damage_window_end = 0.6,
			uninterruptible = true,
			anim_event = "attack_swing_heavy_left",
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
					action_name = "action_unwield"
				},
				start_attack = {
					action_name = "action_melee_start_heavy_follow_up_part_1",
					chain_time = 0.91
				},
				block = {
					action_name = "action_block",
					chain_time = 0.7
				},
				special_action = {
					action_name = "action_weapon_special_right",
					chain_time = 1.2
				}
			},
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/heavy_swing_left",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_heavy_tank,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_heavy_tank_active,
			herding_template = HerdingTemplates.linesman_left_heavy
		},
		action_melee_start_right = {
			allowed_during_sprint = true,
			anim_end_event = "attack_finished",
			kind = "windup",
			first_person_hit_anim = "attack_hit",
			first_person_hit_stop_anim = "attack_hit",
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
					chain_time = 0.86
				},
				block = {
					action_name = "action_block"
				},
				special_action = {
					action_name = "action_weapon_special_right",
					chain_time = 0.8
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end
		},
		action_right_light = {
			damage_window_start = 0.4666666666666667,
			hit_armor_anim = "attack_hit_shield",
			weapon_handling_template = "time_scale_1",
			first_person_hit_stop_anim = "attack_hit",
			kind = "sweep",
			first_person_hit_anim = "hit_right_shake",
			range_mod = 1.25,
			anim_event = "attack_swing_up",
			attack_direction_override = "push",
			damage_window_end = 0.6,
			uninterruptible = true,
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
					chain_time = 1
				}
			},
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/swing_up",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_light_smiter,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_smiter_active
		},
		action_right_heavy = {
			damage_window_start = 0.4,
			hit_armor_anim = "attack_hit_shield",
			first_person_hit_stop_anim = "attack_hit",
			kind = "sweep",
			first_person_hit_anim = "hit_right_shake",
			range_mod = 1.25,
			anim_event = "attack_swing_heavy_right",
			weapon_handling_template = "time_scale_1_3",
			attack_direction_override = "right",
			damage_window_end = 0.5333333333333333,
			uninterruptible = true,
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
					chain_time = 0.7
				},
				special_action = {
					action_name = "action_weapon_special",
					chain_time = 1.2
				}
			},
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/heavy_swing_right",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_heavy_tank,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_heavy_tank_active,
			herding_template = HerdingTemplates.linesman_right_heavy
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
		action_left_light_2 = {
			damage_window_start = 0.4666666666666667,
			hit_armor_anim = "attack_hit_shield",
			first_person_hit_stop_anim = "attack_hit",
			kind = "sweep",
			first_person_hit_anim = "hit_left_shake",
			range_mod = 1.25,
			anim_event = "attack_swing_left_diagonal",
			weapon_handling_template = "time_scale_1",
			attack_direction_override = "left",
			damage_window_end = 0.6,
			uninterruptible = true,
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
					chain_time = 1
				}
			},
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/swing_left_diagonal",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_linesman_active,
			herding_template = HerdingTemplates.linesman_left_heavy
		},
		action_melee_start_right_2 = {
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
					action_name = "action_right_light_2"
				},
				heavy_attack = {
					action_name = "action_right_heavy",
					chain_time = 0.8
				},
				block = {
					action_name = "action_block"
				},
				special_action = {
					action_name = "action_weapon_special_right",
					chain_time = 0.8
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end
		},
		action_right_light_2 = {
			damage_window_start = 0.36666666666666664,
			hit_armor_anim = "attack_hit_shield",
			first_person_hit_stop_anim = "attack_hit",
			kind = "sweep",
			first_person_hit_anim = "hit_right_shake",
			range_mod = 1.25,
			anim_event = "attack_swing_right_diagonal",
			weapon_handling_template = "time_scale_1_2",
			attack_direction_override = "right",
			damage_window_end = 0.5333333333333333,
			uninterruptible = true,
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
					chain_time = 1.5
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
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/swing_right_diagonal",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_linesman_active,
			herding_template = HerdingTemplates.linesman_right_heavy
		},
		action_melee_start_heavy_follow_up_part_1 = {
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
					action_name = "action_right_light_heavy_follow_up_2"
				},
				heavy_attack = {
					action_name = "action_right_heavy",
					chain_time = 0.8
				},
				block = {
					action_name = "action_block"
				},
				special_action = {
					action_name = "action_weapon_special_right",
					chain_time = 0.8
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end
		},
		action_right_light_heavy_follow_up_2 = {
			damage_window_start = 0.36666666666666664,
			hit_armor_anim = "attack_hit_shield",
			first_person_hit_stop_anim = "attack_hit",
			kind = "sweep",
			first_person_hit_anim = "hit_right_shake",
			range_mod = 1.25,
			anim_event = "attack_swing_right_diagonal",
			weapon_handling_template = "time_scale_1_1",
			attack_direction_override = "right",
			damage_window_end = 0.5333333333333333,
			uninterruptible = true,
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
					chain_time = 0.5
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
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/swing_right_diagonal",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
			damage_type = damage_types.ogryn_pipe_club,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_linesman_active,
			herding_template = HerdingTemplates.linesman_right_heavy
		},
		action_weapon_special = {
			kind = "activate_special",
			start_input = "special_action",
			activation_time = 1.3,
			allowed_during_sprint = true,
			anim_event = "activate",
			skip_3p_anims = false,
			total_time = 2.6,
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
					action_name = "action_melee_start_left",
					chain_time = 1.4
				},
				block = {
					action_name = "action_block",
					chain_time = 1.4
				}
			}
		},
		action_weapon_special_right = {
			kind = "activate_special",
			anim_event = "activate",
			allowed_during_sprint = true,
			activation_time = 1.1,
			skip_3p_anims = false,
			total_time = 2.5,
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
					action_name = "action_melee_start_right_2",
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
				},
				special_action = {
					action_name = "action_weapon_special"
				}
			}
		},
		action_right_light_pushfollow = {
			hit_armor_anim = "attack_hit_shield",
			range_mod = 1.25,
			weapon_handling_template = "time_scale_1_2",
			kind = "sweep",
			first_person_hit_anim = "hit_right_shake",
			first_person_hit_stop_anim = "attack_hit",
			damage_window_start = 0.4,
			attack_direction_override = "right",
			damage_window_end = 0.5333333333333333,
			anim_event = "push_follow_up",
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
					chain_time = 0.37
				},
				block = {
					action_name = "action_block",
					chain_time = 0.9
				}
			},
			weapon_box = {
				0.2,
				0.15,
				1
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/ogryn/first_person/animations/power_maul/push_follow_up",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
			damage_profile_special_active = DamageProfileTemplates.ogryn_powermaul_light_linesman_active,
			damage_type = damage_types.ogryn_pipe_club
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
					chain_time = 0.5
				}
			},
			inner_push_rad = math.pi * 0.35,
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
	},
	base_stats = {
		ogryn_powermaul_dps_stat = {
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
											display_name = "loc_weapon_stats_display_base_damage"
										}
									}
								}
							}
						}
					}
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
				},
				action_right_light_2 = {
					damage_trait_templates.default_melee_dps_stat
				}
			}
		},
		ogryn_powermaul_armor_pierce_stat = {
			display_name = "loc_stats_display_ap_stat",
			is_stat_trait = true,
			damage = {
				action_left_light = {
					damage_trait_templates.default_armor_pierce_stat,
					display_data = {
						prefix = "loc_weapon_action_title_light",
						display_stats = {
							targets = {
								armor_damage_modifier = {
									attack = {
										[armor_types.armored] = {},
										[armor_types.super_armor] = {}
									}
								}
							}
						}
					}
				},
				action_left_heavy = {
					damage_trait_templates.default_armor_pierce_stat,
					display_data = {
						prefix = "loc_weapon_action_title_heavy",
						display_stats = {
							targets = {
								armor_damage_modifier = {
									attack = {
										[armor_types.armored] = {},
										[armor_types.super_armor] = {}
									}
								}
							}
						}
					}
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
				},
				action_right_light_2 = {
					damage_trait_templates.default_armor_pierce_stat
				}
			}
		},
		ogryn_powermaul_control_stat = {
			description = "loc_stats_display_control_stat_melee_mouseover",
			display_name = "loc_stats_display_control_stat_melee",
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
				action_right_light_2 = {
					damage_trait_templates.thunderhammer_control_stat
				},
				action_right_light_pushfollow = {
					damage_trait_templates.thunderhammer_control_stat
				}
			},
			weapon_handling = {
				action_left_light = {
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
				action_right_light_2 = {
					weapon_handling_trait_templates.default_finesse_stat
				},
				action_right_light_pushfollow = {
					weapon_handling_trait_templates.default_finesse_stat
				}
			}
		},
		ogryn_powermaul_cleave_damage_stat = {
			display_name = "loc_stats_display_cleave_damage_stat",
			is_stat_trait = true,
			damage = {
				action_left_light = {
					damage_trait_templates.combatsword_cleave_damage_stat
				},
				action_left_heavy = {
					damage_trait_templates.combatsword_cleave_damage_stat
				},
				action_right_light = {
					damage_trait_templates.combatsword_cleave_damage_stat
				},
				action_right_heavy = {
					damage_trait_templates.combatsword_cleave_damage_stat
				},
				action_left_light_2 = {
					damage_trait_templates.combatsword_cleave_damage_stat
				},
				action_right_light_2 = {
					damage_trait_templates.combatsword_cleave_damage_stat
				},
				action_right_light_pushfollow = {
					damage_trait_templates.combatsword_cleave_damage_stat
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
	},
	traits = {}
}
local melee_common_traits = table.keys(WeaponTraitsMeleeCommon)

table.append(weapon_template.traits, melee_common_traits)

local bespoke_ogryn_powermaul_traits = table.keys(WeaponTraitsBespokeOgrynPowerMaulP1)

table.append(weapon_template.traits, bespoke_ogryn_powermaul_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_high_damage"
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
		attack_chain = {
			"tank",
			"tank"
		}
	},
	special = {
		desc = "loc_stats_special_action_powerup_desc",
		display_name = "loc_weapon_special_activate",
		type = "activate"
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/combat_blade"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/power_maul"
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
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_sweep = "fx_sweep",
	_special_active = "fx_special_active",
	_block = "fx_block"
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
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_powermaul
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee

return weapon_template
