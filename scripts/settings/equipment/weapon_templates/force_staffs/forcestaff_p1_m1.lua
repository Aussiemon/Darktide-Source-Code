-- chunkname: @scripts/settings/equipment/weapon_templates/force_staffs/forcestaff_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeForcestaffP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcestaff_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local template_types = WeaponTweakTemplateSettings.template_types
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_keywords = BuffSettings.keywords
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local explosion_trait_templates = WeaponTraitTemplates[template_types.explosion]
local charge_trait_templates = WeaponTraitTemplates[template_types.charge]
local warp_charge_trait_templates = WeaponTraitTemplates[template_types.warp_charge]
local weapon_template = {}

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
		buffer_time = 0.31,
		input_sequence = {
			{
				value = false,
				input = "action_two_hold",
				time_window = math.huge
			}
		}
	},
	trigger_explosion = {
		buffer_time = 0.5,
		input_sequence = {
			{
				value = true,
				hold_input = "action_two_hold",
				input = "action_one_pressed"
			}
		}
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
		buffer_time = 0.261,
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
	{
		transition = "stay",
		input = "wield"
	},
	{
		transition = "stay",
		input = "shoot_pressed"
	},
	{
		input = "charge",
		transition = {
			{
				transition = "base",
				input = "charge_release"
			},
			{
				transition = "base",
				input = "trigger_explosion"
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
			},
			{
				transition = "base",
				input = "vent"
			}
		}
	},
	{
		input = "vent",
		transition = {
			{
				transition = "base",
				input = "vent_release"
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
	},
	{
		input = "special_action_hold",
		transition = {
			{
				transition = "base",
				input = "wield"
			},
			{
				transition = "base",
				input = "special_action"
			},
			{
				transition = "base",
				input = "special_action_light"
			},
			{
				transition = "base",
				input = "special_action_heavy"
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

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
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
		start_input = "shoot_pressed",
		sprint_requires_press_to_interrupt = true,
		charge_template = "forcestaff_p1_m1_projectile",
		fire_time = 0.1,
		weapon_handling_template = "time_scale_1_5",
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
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
			vent = {
				action_name = "action_vent",
				chain_time = 0.29
			},
			charge = {
				chain_time = 0.3,
				reset_combo = true,
				action_name = "action_charge"
			}
		},
		fx = {
			shoot_sfx_alias = "ranged_single_shot"
		},
		projectile_template = ProjectileTemplates.force_staff_ball,
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_charge = {
		position_finder_module_class_name = "ballistic_raycast_position_finder",
		sprint_requires_press_to_interrupt = false,
		start_input = "charge",
		overload_module_class_name = "warp_charge",
		kind = "overload_charge_position_finder",
		sprint_ready_up_time = 0,
		anim_end_event = "attack_finished",
		hold_combo = true,
		allowed_during_sprint = true,
		minimum_hold_time = 0.3,
		charge_template = "forcestaff_p1_m1_charge_aoe",
		anim_event = "explosion_start",
		stop_input = "charge_release",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "charge_up"
		},
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1
			},
			{
				modifier = 0.3,
				t = 0.15
			},
			{
				modifier = 0.6,
				t = 0.25
			},
			{
				modifier = 0.6,
				t = 0.5
			},
			{
				modifier = 0.4,
				t = 1
			},
			{
				modifier = 0.3,
				t = 2
			},
			start_modifier = 1
		},
		position_finder_fx = {
			decal_unit_name = "content/fx/units/weapons/decal_force_staff_explosion_marker",
			wwise_event_stop = "wwise/events/weapon/stop_force_staff_charge_loop",
			scale_variable_name = "radius",
			has_husk_events = true,
			explode_action_name = "action_trigger_explosion",
			scaling_effect_name_3p = "content/fx/particles/weapons/force_staff/3p_force_staff_explosion_indicator",
			wwise_parameter_name = "charge_level",
			wwise_event_start = "wwise/events/weapon/play_force_staff_charge_loop",
			decal_unit_name_3p = "content/fx/units/weapons/decal_force_staff_explosion_marker_3p",
			scaling_effect_name = "content/fx/particles/weapons/force_staff/force_staff_explosion_indicator"
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
				reset_combo = true
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions({
				reset_combo = true
			}),
			wield = {
				action_name = "action_unwield",
				reset_combo = true
			},
			trigger_explosion = {
				action_name = "action_trigger_explosion",
				chain_time = 0.5
			},
			special_action_hold = {
				chain_time = 0.2,
				reset_combo = true,
				action_name = "action_stab_start"
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.3
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end,
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.charge_up_time
		}
	},
	action_trigger_explosion = {
		use_charge = true,
		charge_template = "forcestaff_p1_m1_use_aoe",
		kind = "trigger_explosion",
		sprint_ready_up_time = 0,
		increase_combo = true,
		allowed_during_sprint = true,
		anim_event = "explosion_explode",
		total_time = 0.75,
		crosshair = {
			crosshair_type = "dot"
		},
		action_movement_curve = {
			{
				modifier = 0.1,
				t = 0.35
			},
			{
				modifier = 0.1,
				t = 0.55
			},
			{
				modifier = 1,
				t = 0.75
			},
			start_modifier = 0.1
		},
		explosion_template = ExplosionTemplates.default_force_staff_demolition,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
				reset_combo = true
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				reset_combo = true
			},
			shoot_pressed = {
				chain_time = 0.6,
				reset_combo = true,
				action_name = "rapid_left"
			},
			charge = {
				action_name = "action_charge",
				chain_time = 0.6
			},
			special_action_hold = {
				chain_time = 0.2,
				reset_combo = true,
				action_name = "action_stab_start"
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.3
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
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
		end,
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
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
		end,
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
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
		damage_profile = DamageProfileTemplates.force_staff_bash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
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
				modifier = 1.85,
				t = 0.25
			},
			{
				modifier = 1.45,
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
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
		damage_profile = DamageProfileTemplates.force_staff_bash_stab_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
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
		damage_profile = DamageProfileTemplates.force_staff_bash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
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
		damage_profile = DamageProfileTemplates.heavy_force_staff_bash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
	},
	action_vent = {
		allowed_during_sprint = true,
		start_input = "vent",
		vent_source_name = "fx_left_hand",
		kind = "vent_warp_charge",
		prevent_sprint = true,
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		minimum_hold_time = 0.26,
		anim_end_event = "vent_end",
		vo_tag = "ability_venting",
		abort_sprint = true,
		uninterruptible = true,
		anim_event = "vent_start",
		stop_input = "vent_release",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "dot"
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.4
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.vent_warp_charge_multiplier
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
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
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/force_staff"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/force_staff"
weapon_template.spread_template = "default_force_staff_killshot"
weapon_template.hud_configuration = {
	uses_overheat = false,
	uses_ammunition = false
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_overheat = "fx_overheat",
	_muzzle = "fx_overheat"
}
weapon_template.crosshair = {
	crosshair_type = "dot"
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"ranged",
	"force_staff",
	"p1"
}
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.warp_charge_template = "forcestaff_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.force_staff_single_target
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.forcestaff
weapon_template.overclocks = {}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	forcestaff_p1_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			rapid_left = {
				damage_trait_templates.forcestaff_p1_m1_dps_stat,
				display_data = {
					prefix = "loc_weapon_action_title_primary",
					display_stats = {
						power_distribution = {
							attack = {}
						}
					}
				}
			},
			action_trigger_explosion = {
				overrides = {
					default_force_staff_demolition = {
						damage_trait_templates.forcestaff_p1_m1_dps_stat,
						display_data = {
							prefix = "loc_weapon_stats_display_outer_blast",
							damage_profile_path = {
								"explosion_template",
								"damage_profile"
							},
							display_stats = {
								power_distribution = {
									attack = {}
								}
							}
						}
					},
					close_force_staff_demolition = {
						damage_trait_templates.forcestaff_p1_m1_dps_stat,
						display_data = {
							prefix = "loc_weapon_stats_display_inner_blast",
							damage_profile_path = {
								"explosion_template",
								"close_damage_profile"
							},
							display_stats = {
								power_distribution = {
									attack = {}
								}
							}
						}
					}
				}
			}
		}
	},
	forcestaff_p1_m1_explosion_size_stat = {
		display_name = "loc_stats_display_explosion_stat",
		is_stat_trait = true,
		explosion = {
			action_trigger_explosion = {
				explosion_trait_templates.forcestaff_p1_m1_explosion_size_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	},
	forcestaff_p1_m1_vent_speed_stat = {
		display_name = "loc_stats_display_vent_speed",
		is_stat_trait = true,
		warp_charge = {
			base = {
				warp_charge_trait_templates.forcestaff_p1_m1_vent_speed_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	},
	forcestaff_p1_m1_charge_speed_stat = {
		display_name = "loc_stats_display_charge_speed",
		is_stat_trait = true,
		charge = {
			rapid_left = {
				charge_trait_templates.forcestaff_p1_m1_charge_speed_stat
			},
			action_charge = {
				charge_trait_templates.forcestaff_p1_m1_charge_speed_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	},
	forcestaff_p1_m1_warp_charge_cost_stat = {
		display_name = "loc_stats_display_warp_resist_stat",
		is_stat_trait = true,
		charge = {
			rapid_left = {
				charge_trait_templates.forcestaff_p1_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_charge = {
				charge_trait_templates.forcestaff_p1_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_glossary_term_charge",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_trigger_explosion = {
				charge_trait_templates.forcestaff_secondary_action_charge_cost_stat,
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

local bespoke_forcestaff_p1_traits = table.ukeys(WeaponTraitsBespokeForcestaffP1)

table.append(weapon_template.traits, bespoke_forcestaff_p1_traits)

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
		display_name = "loc_forcestaff_p1_m1_attack_secondary",
		type = "charge"
	},
	special = {
		desc = "loc_stats_special_action_melee_weapon_bash_forcestaff_desc",
		display_name = "loc_forcestaff_p1_m1_attack_special",
		type = "melee_hand"
	}
}
weapon_template.weapon_card_data = {
	main = {
		{
			value_func = "primary_attack",
			icon = "charge",
			sub_icon = "projectile",
			header = "primary_attack"
		},
		{
			icon = "charge",
			value_func = "secondary_attack",
			header = "secondary_attack"
		}
	},
	weapon_special = {
		icon = "melee_hand",
		header = "weapon_bash"
	}
}
weapon_template.special_action_name = "action_stab"

return weapon_template
