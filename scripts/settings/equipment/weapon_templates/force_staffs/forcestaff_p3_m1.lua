local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeForcestaffP3 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcestaff_p3")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_keywords = BuffSettings.keywords
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local template_types = WeaponTweakTemplateSettings.template_types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local charge_trait_templates = WeaponTraitTemplates[template_types.charge]
local warp_charge_trait_templates = WeaponTraitTemplates[template_types.warp_charge]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}
local chain_settings_charged = {
	max_jumps_stat_buff = "chain_lightning_staff_max_jumps",
	radius = 8,
	jump_time = 0.1,
	max_jumps = 1,
	max_targets = 1,
	staff = true,
	max_targets_at_depth = {
		{
			num_targets = 1
		}
	},
	max_angle = math.pi * 0.75
}
local chain_settings_charged_targeting = table.clone(chain_settings_charged)
chain_settings_charged_targeting.radius = 20
chain_settings_charged_targeting.max_angle = math.pi * 0.25
chain_settings_charged_targeting.close_max_angle = math.pi * 0.5
weapon_template.smart_targeting_template = SmartTargetingTemplates.force_staff_p1_single_target
weapon_template.action_inputs = {
	shoot_pressed = {
		buffer_time = 0.15,
		max_queue = 2,
		input_sequence = {
			{
				value = true,
				input = "action_one_pressed"
			}
		}
	},
	charge = {
		buffer_time = 0.1,
		input_sequence = {
			{
				value = true,
				input = "action_two_hold"
			}
		}
	},
	charge_release = {
		buffer_time = 0.41,
		input_sequence = {
			{
				value = false,
				input = "action_two_hold",
				time_window = math.huge
			}
		}
	},
	keep_charging = {
		buffer_time = 0,
		input_sequence = {
			{
				value = true,
				input = "action_two_hold"
			}
		}
	},
	shoot_charged = {
		buffer_time = 0.5,
		input_sequence = {
			{
				value = true,
				hold_input = "action_two_hold",
				input = "action_one_pressed"
			}
		}
	},
	shoot_charged_release = {
		buffer_time = 0.41,
		input_sequence = false
	},
	wield = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs
			}
		}
	},
	vent = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				value = true,
				input = "weapon_reload_hold"
			}
		}
	},
	vent_release = {
		buffer_time = 0.1,
		input_sequence = {
			{
				value = false,
				input = "weapon_reload_hold",
				time_window = math.huge
			}
		}
	},
	special_action = {
		buffer_time = 0.2,
		input_sequence = {
			{
				value = true,
				input = "weapon_extra_pressed"
			}
		}
	},
	special_action_hold = {
		buffer_time = 0.2,
		input_sequence = {
			{
				value = true,
				hold_input = "weapon_extra_hold",
				input = "weapon_extra_hold"
			}
		}
	},
	special_action_light = {
		buffer_time = 0.3,
		max_queue = 1,
		input_sequence = {
			{
				value = false,
				time_window = 0.25,
				input = "weapon_extra_hold"
			}
		}
	},
	special_action_heavy = {
		buffer_time = 0.5,
		max_queue = 1,
		input_sequence = {
			{
				value = true,
				duration = 0.25,
				input = "weapon_extra_hold"
			},
			{
				value = false,
				time_window = 1.5,
				auto_complete = false,
				input = "weapon_extra_hold"
			}
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	wield = "stay",
	shoot_pressed = "stay",
	charge = {
		charge_release = "base",
		wield = "base",
		grenade_ability = "base",
		vent = "base",
		combat_ability = "base",
		shoot_charged = {
			keep_charging = "previous",
			wield = "base",
			grenade_ability = "base",
			shoot_charged_release = "base",
			combat_ability = "base"
		}
	},
	vent = {
		wield = "base",
		vent_release = "base",
		combat_ability = "base",
		grenade_ability = "base"
	},
	special_action_hold = {
		special_action = "base",
		special_action_light = "base",
		special_action_heavy = "base",
		wield = "base",
		grenade_ability = "base",
		combat_ability = "base"
	}
}

table.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_unwield = {
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
		total_time = 0.2,
		allowed_chain_actions = {
			special_action_hold = {
				chain_time = 0.4,
				reset_combo = true,
				action_name = "action_stab_start"
			},
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
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 0.2
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0
			}
		}
	},
	rapid_left = {
		projectile_item = "content/items/weapons/player/ranged/bullets/force_staff_projectile_01",
		sprint_requires_press_to_interrupt = true,
		charge_template = "forcestaff_p3_m1_projectile",
		weapon_handling_template = "forcestaff_p3_m1_single_shot",
		fire_time = 0.1,
		start_input = "shoot_pressed",
		kind = "spawn_projectile",
		uninterruptible = true,
		anim_event = "orb_shoot",
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 1.1,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.8
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
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 0.5
			},
			special_action_hold = {
				chain_time = 0.3,
				reset_combo = true,
				action_name = "action_stab_start"
			},
			charge = {
				chain_time = 0.3,
				reset_combo = true,
				action_name = "action_charge"
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.2
			}
		},
		fx = {
			shoot_sfx_alias = "ranged_single_shot"
		},
		projectile_template = ProjectileTemplates.force_staff_ball,
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint
		}
	},
	action_charge = {
		target_finder_module_class_name = "psyker_smite_targeting",
		overload_module_class_name = "warp_charge",
		hold_combo = true,
		start_input = "charge",
		kind = "overload_charge_target_finder",
		sprint_ready_up_time = 0,
		sprint_requires_press_to_interrupt = false,
		allowed_during_sprint = true,
		target_anim_event = "target_start",
		check_crit = true,
		minimum_hold_time = 0.4,
		target_missing_anim_event = "target_end",
		anim_end_event = "attack_cancel",
		charge_template = "forcestaff_p3_m1_charge",
		anim_event_3p = "attack_charge_lightning",
		anim_event = "attack_charge_lightning",
		stop_input = "charge_release",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "charge_up"
		},
		action_movement_curve = {
			{
				modifier = 0.85,
				t = 0.25
			},
			{
				modifier = 0.6,
				t = 0.5
			},
			{
				modifier = 0.7,
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
			shoot_charged = {
				action_name = "action_shoot_charged",
				chain_time = 0.5
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.3
			}
		},
		fx = {
			fx_hand = "left"
		},
		charge_effects = {
			sfx_parameter = "charge_level",
			looping_sound_alias = "ranged_charging",
			sfx_source_name = "_both"
		},
		targeting_fx = {
			orphaned_policy = "destroy",
			attach_node_name = "j_spine",
			max_targets = 2,
			material_emission = true,
			effect_name = "content/fx/particles/enemies/buff_chainlightning"
		},
		chain_settings_targeting = chain_settings_charged_targeting,
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end
	},
	action_shoot_charged = {
		kind = "chain_lightning",
		stop_time_critical_strike = 0.6,
		target_finder_module_class_name = "psyker_smite_targeting",
		weapon_handling_template = "forcestaff_p3_m1_chain_lightning",
		prevent_sprint = true,
		increase_combo = true,
		delay_explosion_to_finish = true,
		anim_time_scale = 1.3,
		minimum_hold_time = 0.05,
		target_buff = "chain_lightning_interval",
		fire_time = 0,
		charge_template = "forcestaff_p3_m1_chain_lightning",
		can_crit = true,
		anim_event = "attack_charge_shoot_lightning",
		anim_event_3p = "attack_charge_shoot_lightning",
		anim_end_event = "attack_cancel",
		no_chain_lightning_procs = true,
		uninterruptible = true,
		stop_input = "shoot_charged_release",
		total_time = math.huge,
		stop_time = {
			0.6,
			0.6
		},
		crosshair = {
			crosshair_type = "dot"
		},
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.2
			},
			{
				modifier = 0.7,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.8
		},
		running_action_state_to_action_input = {
			charge_depleted = {
				input_name = "shoot_charged_release"
			},
			stop_time_reached = {
				input_name = "shoot_charged_release"
			}
		},
		chain_lightning_link_effects = {
			charge_level_to_power = {
				{
					charge_level = 0,
					power = "low"
				},
				{
					charge_level = 0.33,
					power = "mid"
				},
				{
					charge_level = 0.86,
					power = "high"
				}
			}
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
				chain_time = 0.15
			},
			keep_charging = {
				action_name = "action_charge",
				running_action_state_requirement = {
					stop_time_reached = true,
					charge_depleted = true
				}
			}
		},
		fx = {
			fx_hand = "left",
			looping_shoot_critical_strike_sfx_alias = "ranged_braced_shooting",
			looping_shoot_sfx_alias = "ranged_shooting",
			use_charge = true,
			fx_hand_critical_strike = "both"
		},
		damage_profile = DamageProfileTemplates.default_chain_lighting_attack,
		damage_type = damage_types.electrocution,
		chain_settings = chain_settings_charged,
		chain_settings_targeting = chain_settings_charged_targeting
	},
	action_stab_start = {
		anim_end_event = "attack_finished",
		start_input = "special_action_hold",
		kind = "windup",
		allowed_during_sprint = true,
		anim_event = "attack_special_charge",
		total_time = 1.1,
		crosshair = {
			crosshair_type = "dot"
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
				chain_time = 0.15
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.9
			},
			shoot_pressed = {
				chain_time = 1,
				reset_combo = true,
				action_name = "rapid_left"
			},
			charge = {
				chain_time = 0.5,
				reset_combo = true,
				action_name = "action_charge"
			},
			vent = {
				action_name = "action_vent"
			},
			special_action_light = {
				action_name = "action_stab",
				chain_time = 0.2
			},
			special_action_heavy = {
				action_name = "action_stab_heavy",
				chain_time = 0.4
			}
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "special_action_heavy"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_swipe_start = {
		anim_end_event = "attack_finished",
		kind = "windup",
		allowed_during_sprint = true,
		anim_event = "attack_special_swipe_charge",
		total_time = 1.1,
		crosshair = {
			crosshair_type = "dot"
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
				chain_time = 0.15
			},
			shoot_pressed = {
				chain_time = 1,
				reset_combo = true,
				action_name = "rapid_left"
			},
			charge = {
				chain_time = 1,
				reset_combo = true,
				action_name = "action_charge"
			},
			vent = {
				action_name = "action_vent"
			},
			special_action_light = {
				action_name = "action_swipe",
				chain_time = 0.1
			},
			special_action_heavy = {
				action_name = "action_swipe_heavy",
				chain_time = 0.6
			}
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "special_action_heavy"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_stab = {
		damage_window_start = 0.11666666666666667,
		hit_armor_anim = "attack_hit_shield",
		range_mod = 1.15,
		weapon_handling_template = "time_scale_1_3",
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		damage_window_end = 0.26666666666666666,
		uninterruptible = true,
		anim_event = "attack_special",
		total_time = 0.6,
		crosshair = {
			crosshair_type = "dot"
		},
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.1
			},
			{
				modifier = 1.75,
				t = 0.25
			},
			{
				modifier = 1.35,
				t = 0.3
			},
			{
				modifier = 1.2,
				t = 0.35
			},
			{
				modifier = 1.1,
				t = 0.4
			},
			{
				modifier = 1,
				t = 0.6
			},
			{
				modifier = 0.95,
				t = 1
			},
			start_modifier = 0.8
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
				chain_time = 0.15
			},
			shoot_pressed = {
				chain_time = 0.1,
				reset_combo = true,
				action_name = "rapid_left"
			},
			charge = {
				chain_time = 0.45,
				reset_combo = true,
				action_name = "action_charge"
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.45
			},
			special_action_hold = {
				action_name = "action_swipe_start",
				chain_time = 0.4
			}
		},
		weapon_box = {
			0.08,
			2.4,
			0.08
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/attack_special_stab_sweep_bake",
			anchor_point_offset = {
				0.1,
				1.1,
				0
			}
		},
		damage_type = damage_types.blunt_light,
		damage_profile = DamageProfileTemplates.force_staff_bash
	},
	action_stab_heavy = {
		damage_window_start = 0.13333333333333333,
		hit_armor_anim = "attack_hit_shield",
		range_mod = 1.15,
		weapon_handling_template = "time_scale_1_2",
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		damage_window_end = 0.21666666666666667,
		uninterruptible = true,
		anim_event = "attack_special",
		power_level = 800,
		total_time = 0.75,
		crosshair = {
			crosshair_type = "dot"
		},
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.1
			},
			{
				modifier = 1.75,
				t = 0.25
			},
			{
				modifier = 1.35,
				t = 0.3
			},
			{
				modifier = 1.2,
				t = 0.35
			},
			{
				modifier = 1.1,
				t = 0.4
			},
			{
				modifier = 1,
				t = 0.6
			},
			{
				modifier = 0.95,
				t = 1
			},
			start_modifier = 0.8
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
				chain_time = 0.15
			},
			shoot_pressed = {
				chain_time = 0.1,
				reset_combo = true,
				action_name = "rapid_left"
			},
			charge = {
				chain_time = 0.4,
				reset_combo = true,
				action_name = "action_charge"
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.4
			},
			special_action_hold = {
				action_name = "action_swipe_start",
				chain_time = 0.4
			}
		},
		weapon_box = {
			0.08,
			2.75,
			0.08
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/attack_special_stab_sweep_bake",
			anchor_point_offset = {
				0.1,
				1.1,
				0
			}
		},
		damage_type = damage_types.blunt_heavy,
		damage_profile = DamageProfileTemplates.force_staff_bash_stab_heavy
	},
	action_swipe = {
		damage_window_start = 0.6333333333333333,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_2",
		range_mod = 1.15,
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		attack_direction_override = "left",
		damage_window_end = 0.7,
		uninterruptible = true,
		anim_event = "attack_special_swipe",
		power_level = 650,
		total_time = 0.75,
		crosshair = {
			crosshair_type = "dot"
		},
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.5,
				t = 0.3
			},
			{
				modifier = 1.5,
				t = 0.35
			},
			{
				modifier = 1.5,
				t = 0.4
			},
			{
				modifier = 1.05,
				t = 0.6
			},
			{
				modifier = 0.75,
				t = 1
			},
			start_modifier = 0.8
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
				chain_time = 0.15
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.7
			},
			shoot_pressed = {
				chain_time = 1,
				reset_combo = true,
				action_name = "rapid_left"
			},
			charge = {
				chain_time = 1,
				reset_combo = true,
				action_name = "action_charge"
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.6
			}
		},
		weapon_box = {
			0.15,
			0.15,
			1.2
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/attack_special_swipe_sweep_bake",
			anchor_point_offset = {
				0,
				-0.2,
				0
			}
		},
		damage_type = damage_types.blunt_light,
		damage_profile = DamageProfileTemplates.force_staff_bash
	},
	action_swipe_heavy = {
		damage_window_start = 0.31666666666666665,
		hit_armor_anim = "attack_hit_shield",
		first_person_hit_stop_anim = "attack_hit",
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		range_mod = 1.15,
		allowed_during_sprint = true,
		attack_direction_override = "left",
		damage_window_end = 0.35,
		uninterruptible = true,
		anim_event = "attack_special_swipe_heavy",
		power_level = 800,
		total_time = 1.1,
		crosshair = {
			crosshair_type = "dot"
		},
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.5,
				t = 0.3
			},
			{
				modifier = 1.5,
				t = 0.35
			},
			{
				modifier = 1.5,
				t = 0.4
			},
			{
				modifier = 1.05,
				t = 0.6
			},
			{
				modifier = 0.75,
				t = 1
			},
			start_modifier = 0.8
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
				chain_time = 0.15
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.6
			},
			shoot_pressed = {
				chain_time = 0.7,
				reset_combo = true,
				action_name = "rapid_left"
			},
			charge = {
				chain_time = 0.7,
				reset_combo = true,
				action_name = "action_charge"
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.6
			}
		},
		weapon_box = {
			0.15,
			0.15,
			1.2
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/attack_special_swipe_heavy_sweep_bake",
			anchor_point_offset = {
				0,
				-0.2,
				0
			}
		},
		damage_type = damage_types.blunt_heavy,
		damage_profile = DamageProfileTemplates.heavy_force_staff_bash
	},
	action_vent = {
		prevent_sprint = true,
		start_input = "vent",
		vent_source_name = "fx_left_hand",
		kind = "vent_warp_charge",
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		allowed_during_sprint = true,
		anim_end_event = "vent_end",
		vo_tag = "ability_venting",
		abort_sprint = true,
		uninterruptible = true,
		anim_event = "vent_start",
		stop_input = "vent_release",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "none"
		},
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.1
			},
			{
				modifier = 0.6,
				t = 0.15
			},
			{
				modifier = 0.7,
				t = 0.4
			},
			{
				modifier = 0.85,
				t = 5
			},
			start_modifier = 1
		},
		running_action_state_to_action_input = {
			fully_vented = {
				input_name = "vent_release"
			}
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
				chain_time = 0.15
			},
			special_action_hold = {
				action_name = "rapid_left",
				chain_time = 0.4
			}
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/force_staff"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/force_staff"
weapon_template.spread_template = "default_force_staff_killshot"
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_left = "j_leftweaponattach",
	_charge = "j_leftweaponattach",
	_both = "j_leftweaponattach",
	_overheat = "fx_overheat",
	_muzzle = "j_leftweaponattach",
	_right = "fx_overheat"
}
weapon_template.chain_settings = {
	right_fx_source_name = "_right",
	left_fx_source_name_base_unit = "fx_left_hand"
}
weapon_template.crosshair = {
	crosshair_type = "assault"
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"ranged",
	"force_staff",
	"p3"
}
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.warp_charge_template = "forcestaff_p3_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.charge_effects = {
	sfx_parameter = "charge_level",
	sfx_source_name = "_left"
}
weapon_template.overclocks = {}
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
weapon_template.base_stats = {
	forcestaff_p3_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			rapid_left = {
				damage_trait_templates.forcestaff_p3_m1_dps_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						power_distribution = {
							attack = {
								display_name = "loc_weapon_stats_display_base_damage"
							}
						},
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
			action_shoot_charged = {
				damage_trait_templates.forcestaff_p3_m1_dps_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						power_distribution = {
							attack = {
								display_name = "loc_weapon_stats_display_base_damage"
							}
						},
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
			}
		}
	},
	forcestaff_p3_m1_vent_speed_stat = {
		display_name = "loc_stats_display_vent_speed",
		is_stat_trait = true,
		warp_charge = {
			base = {
				warp_charge_trait_templates.forcestaff_p3_m1_vent_speed_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	},
	forcestaff_p3_m1_charge_speed_stat = {
		display_name = "loc_stats_display_charge_speed",
		is_stat_trait = true,
		charge = {
			rapid_left = {
				charge_trait_templates.forcestaff_p3_m1_charge_speed_stat
			},
			action_charge = {
				charge_trait_templates.forcestaff_p3_m1_charge_speed_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_shoot_charged = {
				charge_trait_templates.forcestaff_p3_m1_charge_speed_stat
			}
		}
	},
	forcestaff_p3_m1_warp_charge_cost_stat = {
		display_name = "loc_stats_display_warp_resist_stat",
		is_stat_trait = true,
		charge = {
			rapid_left = {
				charge_trait_templates.forcestaff_p3_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_charge = {
				charge_trait_templates.forcestaff_p3_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_glossary_term_charge",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_shoot_charged = {
				charge_trait_templates.forcestaff_p3_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						__all_basic_stats = true
					}
				}
			}
		}
	},
	forcestaff_p3_m1_crit_stat = {
		display_name = "loc_stats_display_crit_stat",
		is_stat_trait = true,
		weapon_handling = {
			rapid_left = {
				weapon_handling_trait_templates.forcestaff_p3_m1_crit_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_shoot_charged = {
				weapon_handling_trait_templates.forcestaff_p3_m1_crit_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						__all_basic_stats = true
					}
				}
			}
		},
		damage = {
			rapid_left = {
				damage_trait_templates.forcestaff_p3_m1_crit_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_shoot_charged = {
				damage_trait_templates.forcestaff_p3_m1_crit_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						__all_basic_stats = true
					}
				}
			}
		}
	}
}
weapon_template.traits = {}
local bespoke_forcestaff_p3_traits = table.ukeys(WeaponTraitsBespokeForcestaffP3)

table.append(weapon_template.traits, bespoke_forcestaff_p3_traits)

weapon_template.hipfire_inputs = {
	shoot_pressed = true
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_warp_weapon"
	},
	{
		display_name = "loc_weapon_keyword_charged_attack"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		fire_mode = "projectile",
		display_name = "loc_forcestaff_p1_m1_attack_primary",
		type = "hipfire"
	},
	secondary = {
		display_name = "loc_forcestaff_p3_m1_attack_secondary",
		type = "charge"
	},
	special = {
		desc = "loc_stats_special_action_melee_weapon_bash_forcestaff_desc",
		display_name = "loc_forcestaff_p1_m1_attack_special",
		type = "melee_hand"
	}
}
weapon_template.special_action_name = "action_stab"

return weapon_template
