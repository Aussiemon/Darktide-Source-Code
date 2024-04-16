local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MeleeActionInputSetupSlow = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_slow")
local PushSettings = require("scripts/settings/damage/push_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeOgrynClubP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_club_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local push_templates = PushSettings.push_templates
local template_types = WeaponTweakTemplateSettings.template_types
local wounds_shapes = WoundsSettings.shapes
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_template = {
	action_inputs = table.clone(MeleeActionInputSetupSlow.action_inputs),
	action_input_hierarchy = table.clone(MeleeActionInputSetupSlow.action_input_hierarchy)
}
local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.weakspot] = 1,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_wield = {
		allowed_during_sprint = true,
		uninterruptible = true,
		kind = "wield",
		sprint_ready_up_time = 0,
		total_time = 0.1,
		anim_event_func = function (action_settings, condition_func_params)
			local inventory_slot_component = condition_func_params.inventory_slot_component
			local special_active = inventory_slot_component.special_active
			local anim_event = special_active and "equip_activated" or "equip"

			return anim_event
		end,
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
				{
					action_name = "action_melee_start_left_special"
				},
				{
					action_name = "action_melee_start_left"
				}
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_special_activate"
			}
		}
	},
	action_melee_start_left_special = {
		uninterruptible = true,
		anim_end_event = "attack_finished",
		start_input = "start_attack",
		kind = "windup",
		action_priority = 2,
		invalid_start_action_for_stat_calculation = true,
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
				modifier = 0.45,
				t = 0.1
			},
			{
				modifier = 0.4,
				t = 0.25
			},
			{
				modifier = 0.55,
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
				action_name = "action_left_light_special"
			},
			heavy_attack = {
				action_name = "action_left_heavy_special",
				chain_time = 0.5
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.special_active
		end
	},
	action_left_light_special = {
		damage_window_start = 0.4666666666666667,
		range_mod = 1.35,
		sweep_trail_window_end = 0.5666666666666667,
		kind = "sweep",
		first_person_hit_anim = "hit_left_shake",
		invalid_start_action_for_stat_calculation = true,
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		action_priority = 2,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		damage_window_end = 0.5666666666666667,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_down_folded",
		anim_event = "attack_swing_down_folded",
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_2",
		attack_direction_override = "down",
		sweep_trail_window_start = 0.4666666666666667,
		special_active_hit_stop_anim = "attack_hit",
		uninterruptible = true,
		hit_stop_anim = "attack_hit",
		total_time = 2.5,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15
			},
			{
				modifier = 1.25,
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
				action_name = "action_unwield",
				chain_time = 0.8
			},
			start_attack = {
				{
					action_name = "action_melee_start_left_special",
					chain_time = 1.3
				},
				{
					action_name = "action_melee_start_right",
					chain_time = 1.3
				}
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 1.1
			},
			block = {
				action_name = "action_block",
				chain_time = 0.8
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.2,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_down",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		damage_profile = DamageProfileTemplates.ogryn_shovel_light_special,
		damage_type = damage_types.ogryn_shovel_fold_special,
		herding_template = HerdingTemplates.smiter_down,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.special_active
		end
	},
	action_left_heavy_special = {
		damage_window_start = 0.23333333333333334,
		hit_armor_anim = "attack_hit_shield",
		range_mod = 1.15,
		kind = "sweep",
		first_person_hit_anim = "hit_down_shake",
		action_priority = 2,
		invalid_start_action_for_stat_calculation = true,
		anim_event_3p = "attack_swing_heavy_down_folded",
		first_person_hit_stop_anim = "hit_down_shake",
		allowed_during_sprint = true,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		damage_window_end = 0.3333333333333333,
		special_active_hit_stop_anim = "attack_hit",
		anim_end_event = "attack_finished",
		attack_direction_override = "down",
		weapon_handling_template = "time_scale_1_1",
		uninterruptible = true,
		anim_event = "attack_swing_heavy_down_folded",
		hit_stop_anim = "attack_hit",
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
				chain_time = 1.3
			},
			start_attack = {
				{
					action_name = "action_melee_start_left_special",
					chain_time = 1.95
				},
				{
					action_name = "action_melee_start_right",
					chain_time = 1.5
				}
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 1.2
			},
			block = {
				action_name = "action_block",
				chain_time = 1.1
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_down",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_shovel_heavy_special,
		damage_type = damage_types.ogryn_shovel_fold_special,
		herding_template = HerdingTemplates.smiter_down,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.special_active
		end
	},
	action_melee_start_left = {
		uninterruptible = true,
		chain_anim_event = "attack_swing_charge_left_pose",
		start_input = "start_attack",
		kind = "windup",
		anim_event_3p = "attack_swing_charge_down_left",
		action_priority = 1,
		chain_anim_event_3p = "attack_swing_charge_down_left",
		anim_end_event = "attack_finished",
		allowed_during_sprint = true,
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
				action_name = "action_light_1"
			},
			heavy_attack = {
				action_name = "action_left_heavy",
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
	action_light_1 = {
		damage_window_start = 0.4666666666666667,
		hit_armor_anim = "attack_hit_shield",
		range_mod = 1.25,
		weapon_handling_template = "time_scale_1",
		first_person_hit_anim = "hit_left_shake",
		kind = "sweep",
		first_person_hit_stop_anim = "attack_hit",
		anim_event_3p = "attack_swing_left_diagonal_slow",
		allowed_during_sprint = true,
		damage_window_end = 0.6,
		attack_direction_override = "left",
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_left_diagonal",
		hit_stop_anim = "attack_hit",
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
				chain_time = 0.68
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.7
			},
			block = {
				action_name = "action_block",
				chain_time = 0.68
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.2,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_left_diagonal",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_shovel_light_linesman,
		damage_type = damage_types.shovel_heavy,
		herding_template = HerdingTemplates.linesman_left_heavy,
		wounds_shape = wounds_shapes.vertical_slash_coarse
	},
	action_left_heavy = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit_shield",
		range_mod = 1.25,
		weapon_handling_template = "time_scale_1_1",
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		kind = "sweep",
		allowed_during_sprint = true,
		damage_window_end = 0.3333333333333333,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_heavy_down_left",
		hit_stop_anim = "attack_hit",
		total_time = 1.72,
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
				chain_time = 0.17
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.63
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.55
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_down_left",
			anchor_point_offset = {
				-0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_shovel_heavy_smiter,
		damage_type = damage_types.shovel_heavy,
		wounds_shape = wounds_shapes.vertical_slash_coarse
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		chain_anim_event = "attack_swing_charge_down_right_pose",
		kind = "windup",
		anim_event_3p = "attack_swing_charge_down_right",
		action_priority = 2,
		anim_end_event = "attack_finished",
		chain_anim_event_3p = "attack_swing_charge_down_right",
		uninterruptible = true,
		anim_event = "attack_swing_charge_right_diagonal",
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
				action_name = "action_light_2"
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.71
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return not condition_func_params.inventory_slot_component.special_active
		end
	},
	action_light_2 = {
		damage_window_start = 0.4666666666666667,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		anim_event_3p = "attack_swing_right_diagonal_slow",
		weapon_handling_template = "time_scale_1_2",
		damage_window_end = 0.6,
		attack_direction_override = "right",
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_right_diagonal",
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
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.63
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.6
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6
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
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_right_diagonal",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_shovel_light_linesman,
		damage_type = damage_types.shovel_heavy,
		herding_template = HerdingTemplates.linesman_right_heavy,
		wounds_shape = wounds_shapes.horizontal_slash_coarse
	},
	action_right_heavy = {
		damage_window_start = 0.26666666666666666,
		hit_armor_anim = "attack_hit_shield",
		range_mod = 1.25,
		weapon_handling_template = "time_scale_1_2",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		kind = "sweep",
		allowed_during_sprint = true,
		damage_window_end = 0.36666666666666664,
		attack_direction_override = "right",
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_heavy_down_right",
		hit_stop_anim = "attack_hit",
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
				chain_time = 0.56
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.46
			},
			block = {
				action_name = "action_block",
				chain_time = 0.46
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_down_right",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_shovel_heavy_smiter,
		damage_type = damage_types.shovel_heavy,
		herding_template = HerdingTemplates.linesman_right_heavy,
		wounds_shape = wounds_shapes.horizontal_slash_coarse
	},
	action_melee_start_left_2 = {
		anim_end_event = "attack_finished",
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
				action_name = "action_light_3"
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.75
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_light_3 = {
		damage_window_start = 0.43333333333333335,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		anim_event_3p = "attack_swing_left_slow",
		weapon_handling_template = "time_scale_1",
		damage_window_end = 0.5333333333333333,
		attack_direction_override = "left",
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_left",
		hit_stop_anim = "attack_hit",
		total_time = 1,
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
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.66
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.54
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
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_left",
			anchor_point_offset = {
				0,
				0,
				-0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_shovel_light_tank,
		damage_type = damage_types.shovel_heavy,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
		wounds_shape = wounds_shapes.horizontal_slash_coarse
	},
	action_melee_start_right_2 = {
		allowed_during_sprint = true,
		chain_anim_event = "attack_swing_charge_down_right_pose",
		kind = "windup",
		anim_event_3p = "attack_swing_charge_down_right",
		action_priority = 2,
		anim_end_event = "attack_finished",
		chain_anim_event_3p = "attack_swing_charge_down_right",
		uninterruptible = true,
		anim_event = "attack_swing_charge_right_diagonal",
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
				action_name = "action_light_4"
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.71
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return not condition_func_params.inventory_slot_component.special_active
		end
	},
	action_light_4 = {
		damage_window_start = 0.5,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		anim_event_3p = "attack_swing_right_slow",
		weapon_handling_template = "time_scale_1_2",
		attack_direction_override = "right",
		damage_window_end = 0.6,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_right",
		hit_stop_anim = "attack_hit",
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
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.64
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.6
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_right",
			anchor_point_offset = {
				0,
				0,
				-0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_shovel_light_tank,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
		damage_type = damage_types.shovel_heavy,
		wounds_shape = wounds_shapes.horizontal_slash_coarse
	},
	action_special_activate = {
		deactivate_anim_event = "unfold",
		total_time_deactivate = 1,
		activate_anim_event = "fold",
		kind = "toggle_special",
		start_input = "special_action",
		activation_time = 0.3,
		deactivation_time = 0.1,
		allowed_during_sprint = true,
		skip_3p_anims = false,
		total_time = 1,
		allowed_chain_actions = {
			block = {
				action_name = "action_block",
				chain_time = 0.7
			},
			start_attack = {
				{
					action_name = "action_melee_start_left_special",
					chain_time = 0.62
				},
				{
					action_name = "action_melee_start_left",
					chain_time = 0.62
				}
			},
			wield = {
				action_name = "action_unwield"
			}
		}
	},
	action_block = {
		minimum_hold_time = 0.3,
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
				action_name = "action_push"
			},
			special_action = {
				action_name = "action_special_activate"
			}
		}
	},
	action_light_pushfollow = {
		damage_window_start = 0.4,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		weapon_handling_template = "time_scale_1_2",
		first_person_hit_anim = "hit_right_shake",
		action_priority = 1,
		range_mod = 1.25,
		first_person_hit_stop_anim = "attack_hit",
		sprint_requires_press_to_interrupt = "true",
		damage_window_end = 0.5,
		attack_direction_override = "down",
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_down_slow",
		anim_event = "attack_swing_down_right",
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
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.75
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.69
			},
			block = {
				action_name = "action_block",
				chain_time = 0.75
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_down_right",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_shovel_light_smiter,
		damage_type = damage_types.shovel_heavy,
		wounds_shape = wounds_shapes.vertical_slash_coarse
	},
	action_push = {
		push_radius = 3,
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
				{
					action_name = "action_left_light_special",
					chain_time = 0.45
				},
				{
					action_name = "action_light_pushfollow",
					chain_time = 0.45
				}
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5
			},
			start_attack = {
				{
					action_name = "action_melee_start_left_special",
					chain_time = 0.5
				},
				{
					action_name = "action_melee_start_left",
					chain_time = 0.5
				}
			}
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.ogryn_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.default_push,
		outer_damage_type = damage_types.physical
	},
	action_inspect = {
		anim_event = "inspect_start",
		lock_view = true,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect"
		}
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/combat_blade"
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
weapon_template.damage_window_start_sweep_trail_offset = -0.3
weapon_template.damage_window_end_sweep_trail_offset = 0.1
weapon_template.ammo_template = "no_ammo"
weapon_template.allow_sprinting_with_special = true
weapon_template.weapon_special_class = "WeaponSpeciaShovels"
weapon_template.weapon_special_tweak_data = {
	deactivation_animation = "deactivate_automatic",
	deactivation_animation_delay = 0.3
}
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
	"ogryn_club",
	"p1"
}
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn"
weapon_template.stamina_template = "tank"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "ogryn_club_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_club
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
weapon_template.base_stats = {
	ogryn_club_p1_m2_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
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
			action_light_2 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_light_3 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_light_pushfollow = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_left_light_special = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_left_heavy_special = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_light_4 = {
				damage_trait_templates.default_melee_dps_stat
			}
		}
	},
	ogryn_club_p1_m2_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
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
			action_left_heavy = {
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
			action_light_2 = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_light_3 = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_left_light_special = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_left_heavy_special = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_light_4 = {
				damage_trait_templates.default_armor_pierce_stat
			}
		}
	},
	ogryn_club_p1_m2_control_stat = {
		description = "loc_stats_display_control_stat_melee_mouseover",
		display_name = "loc_stats_display_control_stat_melee",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.ogryn_club_control_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								power_distribution = {
									impact = {
										display_name = "loc_weapon_stats_display_stagger"
									}
								}
							}
						},
						cleave_distribution = {
							attack = {},
							impact = {}
						},
						stagger_duration_modifier = {}
					}
				}
			},
			action_left_heavy = {
				damage_trait_templates.ogryn_club_control_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								power_distribution = {
									impact = {
										display_name = "loc_weapon_stats_display_stagger"
									}
								}
							}
						},
						cleave_distribution = {
							attack = {},
							impact = {}
						},
						stagger_duration_modifier = {}
					}
				}
			},
			action_light_2 = {
				damage_trait_templates.ogryn_club_control_stat
			},
			action_right_heavy = {
				damage_trait_templates.ogryn_club_control_stat
			},
			action_light_3 = {
				damage_trait_templates.ogryn_club_control_stat
			},
			action_light_pushfollow = {
				damage_trait_templates.ogryn_club_control_stat
			},
			action_push = {
				damage_trait_templates.ogryn_club_push_control_stat
			},
			action_left_light_special = {
				damage_trait_templates.ogryn_club_control_stat
			},
			action_left_heavy_special = {
				damage_trait_templates.ogryn_club_control_stat
			},
			action_light_4 = {
				damage_trait_templates.ogryn_club_control_stat
			}
		}
	},
	ogryn_club_p1_m2_first_target_stat = {
		display_name = "loc_stats_display_first_target_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.default_first_target_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								power_level_multiplier = {}
							}
						}
					}
				}
			},
			action_left_heavy = {
				damage_trait_templates.default_first_target_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								power_level_multiplier = {}
							}
						}
					}
				}
			},
			action_light_2 = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_first_target_stat
			},
			action_light_3 = {
				damage_trait_templates.default_first_target_stat
			},
			action_light_pushfollow = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_light_special = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_heavy_special = {
				damage_trait_templates.default_first_target_stat
			},
			action_light_4 = {
				damage_trait_templates.default_first_target_stat
			}
		}
	},
	ogryn_club_p1_m2_defence_stat = {
		display_name = "loc_stats_display_defense_stat",
		is_stat_trait = true,
		stamina = {
			base = {
				stamina_trait_templates.ogryn_club_p1_m1_defence_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		},
		dodge = {
			base = {
				dodge_trait_templates.ogryn_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	}
}
weapon_template.traits = {}
local bespoke_ogryn_club_p1 = table.ukeys(WeaponTraitsBespokeOgrynClubP1)

table.append(weapon_template.traits, bespoke_ogryn_club_p1)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control"
	},
	{
		display_name = "loc_weapon_keyword_smiter"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {
			"linesman",
			"linesman",
			"tank",
			"tank"
		}
	},
	secondary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"smiter"
		}
	},
	special = {
		desc = "loc_weapon_special_mode_switch_foldable_desc",
		display_name = "loc_weapon_special_mode_switch",
		type = "activate"
	}
}
weapon_template.special_action_name = "action_special_activate"
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee

return weapon_template
