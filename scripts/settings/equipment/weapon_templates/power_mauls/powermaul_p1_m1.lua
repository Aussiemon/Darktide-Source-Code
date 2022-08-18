local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DefaultMeleeActionInputSetup = require("scripts/settings/equipment/weapon_templates/default_melee_action_input_setup")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsMeleeCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
local damage_types = DamageSettings.damage_types
local buff_stat_buffs = BuffSettings.stat_buffs
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
			start_input = "start_attack",
			anim_end_event = "attack_finished",
			kind = "windup",
			anim_event = "attack_swing_charge_left",
			stop_input = "attack_cancel",
			total_time = 3,
			action_movement_curve = {
				{
					modifier = 0.7,
					t = 0.05
				},
				{
					modifier = 0.95,
					t = 0.1
				},
				{
					modifier = 1,
					t = 0.25
				},
				{
					modifier = 1.15,
					t = 0.4
				},
				{
					modifier = 1.2,
					t = 1
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
				light_attack = {
					action_name = "action_left_light"
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
		action_left_light = {
			damage_window_start = 0.1,
			hit_armor_anim = "attack_hit",
			weapon_handling_template = "time_scale_1_2",
			anim_end_event = "attack_finished",
			kind = "sweep",
			range_mod = 1.25,
			first_person_hit_stop_anim = "attack_hit",
			damage_window_end = 0.45,
			anim_event = "attack_swing_up_left",
			power_level = 500,
			total_time = 2,
			action_movement_curve = {
				{
					modifier = 1.25,
					t = 0.1
				},
				{
					modifier = 1.15,
					t = 0.15
				},
				{
					modifier = 0.8,
					t = 0.2
				},
				{
					modifier = 0.8,
					t = 0.25
				},
				{
					modifier = 1,
					t = 0.55
				},
				start_modifier = 0.9
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
					chain_time = 0.3
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
				1.15
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/swing_left_diagonal_up",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
			damage_type = damage_types.knife,
			stat_buff_keywords = {
				buff_stat_buffs.attack_speed,
				buff_stat_buffs.melee_attack_speed
			}
		},
		action_left_heavy = {
			damage_window_start = 0.1,
			hit_armor_anim = "attack_hit",
			anim_end_event = "attack_finished",
			first_person_hit_stop_anim = "attack_hit",
			kind = "sweep",
			range_mod = 1.25,
			damage_window_end = 0.3,
			anim_event = "attack_swing_heavy_left",
			power_level = 500,
			total_time = 1,
			action_movement_curve = {
				{
					modifier = 1.3,
					t = 0.15
				},
				{
					modifier = 1.5,
					t = 0.4
				},
				{
					modifier = 0.85,
					t = 0.6
				},
				{
					modifier = 1,
					t = 1
				},
				start_modifier = 1.25
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
					chain_time = 0.4
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
				1.15
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/heavy_swing_stab_01",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.medium_combat_knife_ninja_fencer,
			damage_type = damage_types.knife,
			stat_buff_keywords = {
				buff_stat_buffs.attack_speed,
				buff_stat_buffs.melee_attack_speed
			}
		},
		action_melee_start_right = {
			anim_end_event = "attack_finished",
			kind = "windup",
			first_person_hit_anim = "attack_hit",
			anim_event = "attack_swing_charge_down",
			hit_stop_anim = "attack_hit",
			stop_input = "attack_cancel",
			total_time = 3,
			action_movement_curve = {
				{
					modifier = 0.7,
					t = 0.05
				},
				{
					modifier = 0.95,
					t = 0.1
				},
				{
					modifier = 1,
					t = 0.25
				},
				{
					modifier = 1.15,
					t = 0.4
				},
				{
					modifier = 1.2,
					t = 1
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
				light_attack = {
					action_name = "action_right_light"
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
		action_right_light = {
			damage_window_start = 0.1,
			hit_armor_anim = "attack_hit",
			weapon_handling_template = "time_scale_1_2",
			anim_end_event = "attack_finished",
			kind = "sweep",
			range_mod = 1.25,
			first_person_hit_stop_anim = "attack_hit",
			damage_window_end = 0.45,
			anim_event = "attack_swing_right",
			power_level = 500,
			total_time = 2,
			action_movement_curve = {
				{
					modifier = 1.25,
					t = 0.1
				},
				{
					modifier = 1.15,
					t = 0.15
				},
				{
					modifier = 0.8,
					t = 0.2
				},
				{
					modifier = 0.8,
					t = 0.25
				},
				{
					modifier = 1,
					t = 0.55
				},
				start_modifier = 0.9
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
					chain_time = 0.4
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
				1.15
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/swing_right",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
			damage_type = damage_types.knife,
			stat_buff_keywords = {
				buff_stat_buffs.attack_speed,
				buff_stat_buffs.melee_attack_speed
			}
		},
		action_right_heavy = {
			damage_window_start = 0.2,
			hit_armor_anim = "attack_hit",
			anim_end_event = "attack_finished",
			first_person_hit_stop_anim = "attack_hit",
			kind = "sweep",
			range_mod = 1.25,
			damage_window_end = 0.5,
			anim_event = "attack_swing_heavy_down",
			power_level = 500,
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
					chain_time = 0.4
				},
				block = {
					action_name = "action_block",
					chain_time = 0.4
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end,
			weapon_box = {
				0.2,
				0.15,
				0.7
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/heavy_swing_down_left",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.medium_combat_knife_ninja_fencer,
			damage_type = damage_types.knife,
			stat_buff_keywords = {
				buff_stat_buffs.attack_speed,
				buff_stat_buffs.melee_attack_speed
			}
		},
		action_melee_start_left_2 = {
			kind = "windup",
			anim_end_event = "attack_finished",
			weapon_handling_template = "time_scale_1_5",
			first_person_hit_anim = "attack_hit",
			anim_event = "attack_swing_charge_left",
			hit_stop_anim = "attack_hit",
			stop_input = "attack_cancel",
			total_time = 3,
			action_movement_curve = {
				{
					modifier = 0.7,
					t = 0.05
				},
				{
					modifier = 0.95,
					t = 0.1
				},
				{
					modifier = 1,
					t = 0.25
				},
				{
					modifier = 1.15,
					t = 0.4
				},
				{
					modifier = 1.2,
					t = 1
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
				light_attack = {
					action_name = "action_left_light_2"
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
		action_left_light_2 = {
			damage_window_start = 0.1,
			hit_armor_anim = "attack_hit",
			weapon_handling_template = "time_scale_1_3",
			anim_end_event = "attack_finished",
			kind = "sweep",
			range_mod = 1.25,
			first_person_hit_stop_anim = "attack_hit",
			damage_window_end = 0.45,
			anim_event = "attack_swing_stab",
			power_level = 500,
			total_time = 2,
			action_movement_curve = {
				{
					modifier = 1.25,
					t = 0.1
				},
				{
					modifier = 1.15,
					t = 0.15
				},
				{
					modifier = 0.8,
					t = 0.2
				},
				{
					modifier = 0.8,
					t = 0.25
				},
				{
					modifier = 1,
					t = 0.55
				},
				start_modifier = 0.9
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
					chain_time = 0.25
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
				1.15
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/swing_stab_01",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
			damage_type = damage_types.knife,
			stat_buff_keywords = {
				buff_stat_buffs.attack_speed,
				buff_stat_buffs.melee_attack_speed
			}
		},
		action_melee_start_right_2 = {
			anim_end_event = "attack_finished",
			kind = "windup",
			first_person_hit_anim = "attack_hit",
			anim_event = "attack_swing_charge_down",
			hit_stop_anim = "attack_hit",
			stop_input = "attack_cancel",
			total_time = 3,
			action_movement_curve = {
				{
					modifier = 0.6,
					t = 0.05
				},
				{
					modifier = 0.75,
					t = 0.1
				},
				{
					modifier = 0.8,
					t = 0.25
				},
				{
					modifier = 0.85,
					t = 0.4
				},
				{
					modifier = 1,
					t = 1
				},
				start_modifier = 0.7
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
					action_name = "action_right_light_2"
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
		action_right_light_2 = {
			damage_window_start = 0.1,
			hit_armor_anim = "attack_hit",
			weapon_handling_template = "time_scale_1_2",
			anim_end_event = "attack_finished",
			kind = "sweep",
			range_mod = 1.25,
			first_person_hit_stop_anim = "attack_hit",
			damage_window_end = 0.4,
			anim_event = "attack_swing_right_diagonal",
			power_level = 500,
			total_time = 2,
			action_movement_curve = {
				{
					modifier = 1,
					t = 0.1
				},
				{
					modifier = 0.95,
					t = 0.15
				},
				{
					modifier = 0.7,
					t = 0.2
				},
				{
					modifier = 0.65,
					t = 0.25
				},
				{
					modifier = 1,
					t = 0.55
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
					action_name = "action_melee_start_left",
					chain_time = 0.55
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
				1.15
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/swing_right_diagonal",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
			damage_type = damage_types.knife,
			stat_buff_keywords = {
				buff_stat_buffs.attack_speed,
				buff_stat_buffs.melee_attack_speed
			}
		},
		action_block = {
			weapon_handling_template = "time_scale_1_5",
			start_input = "block",
			anim_end_event = "parry_finished",
			kind = "block",
			anim_event = "parry_pose",
			stop_input = "block_release",
			total_time = math.huge,
			action_movement_curve = {
				{
					modifier = 0.85,
					t = 0.2
				},
				{
					modifier = 0.62,
					t = 0.3
				},
				{
					modifier = 0.6,
					t = 0.325
				},
				{
					modifier = 0.61,
					t = 0.35
				},
				{
					modifier = 0.85,
					t = 0.5
				},
				{
					modifier = 0.95,
					t = 1
				},
				{
					modifier = 0.9,
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
				}
			}
		},
		action_right_light_pushfollow = {
			damage_window_start = 0.2,
			hit_armor_anim = "attack_hit",
			weapon_handling_template = "time_scale_1_2",
			anim_end_event = "attack_finished",
			kind = "sweep",
			range_mod = 1.25,
			first_person_hit_stop_anim = "attack_hit",
			damage_window_end = 0.5,
			anim_event = "attack_swing_heavy_down",
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
					chain_time = 0.35
				},
				block = {
					action_name = "action_block",
					chain_time = 0.4
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end,
			weapon_box = {
				0.2,
				0.15,
				0.7
			},
			spline_settings = {
				matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/heavy_swing_down_left",
				anchor_point_offset = {
					0,
					0,
					0
				}
			},
			damage_profile = DamageProfileTemplates.medium_combat_knife_ninja_fencer,
			damage_type = damage_types.knife,
			stat_buff_keywords = {
				buff_stat_buffs.attack_speed,
				buff_stat_buffs.melee_attack_speed
			}
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
					chain_time = 0.25
				},
				block = {
					action_name = "action_block",
					chain_time = 0.3
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
			skip_3p_anims = false,
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/combat_knife"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/combat_knife"
weapon_template.weapon_box = {
	0.15,
	0.65,
	0.15
}
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_sweep = "fx_sweep"
}
weapon_template.crosshair_type = "dot"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"power_maul",
	"p1"
}
weapon_template.dodge_template = "assault"
weapon_template.sprint_template = "ninja_l"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "assault"
weapon_template.footstep_intervals = {
	crouch_walking = 0.61,
	walking = 0.4,
	sprinting = 0.37
}
weapon_template.traits = {}
local melee_common_traits = table.keys(WeaponTraitsMeleeCommon)

table.append(weapon_template.traits, melee_common_traits)

return weapon_template
