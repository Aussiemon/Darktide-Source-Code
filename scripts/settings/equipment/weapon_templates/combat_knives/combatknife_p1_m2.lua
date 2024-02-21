local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MeleeActionInputSetupFast = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_fast")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local WeaponTraitsBespokeCombatknifeP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatknife_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
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
	action_inputs = table.clone(MeleeActionInputSetupFast.action_inputs),
	action_input_hierarchy = table.clone(MeleeActionInputSetupFast.action_input_hierarchy)
}
local short_weapon_box = {
	0.1,
	0.075,
	0.9
}
local default_weapon_box = {
	0.1,
	0.075,
	1.1
}
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
		kind = "wield",
		allowed_during_sprint = true,
		uninterruptible = true,
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
				action_name = "action_special_jab"
			}
		}
	},
	action_melee_start_left = {
		anim_end_event = "attack_finished",
		start_input = "start_attack",
		kind = "windup",
		allowed_during_sprint = true,
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
				modifier = 1,
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
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_left_light"
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.3
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
		damage_window_start = 0.24,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_1_ninja",
		anim_end_event = "attack_finished",
		kind = "sweep",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		allowed_during_sprint = true,
		damage_window_end = 0.35,
		anim_event = "attack_swing_left_diagonal",
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
			special_action = {
				action_name = "action_special_jab",
				chain_time = 0.45
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/swing_left_diagonal",
			anchor_point_offset = {
				0.2,
				0,
				-0.44
			}
		},
		damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
		damage_type = damage_types.knife,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.left_45_slash_clean
	},
	action_left_heavy = {
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_2_ninja",
		anim_end_event = "attack_finished",
		kind = "sweep",
		attack_direction_override = "push",
		range_mod = 1.25,
		allowed_during_sprint = true,
		first_person_hit_stop_anim = "attack_hit",
		damage_window_end = 0.4,
		anim_event = "attack_swing_heavy_left",
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
				chain_time = 0.5
			},
			special_action = {
				action_name = "action_special_jab",
				chain_time = 0.55
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/heavy_swing_left",
			anchor_point_offset = {
				0,
				-0.2,
				-0.3
			}
		},
		damage_profile = DamageProfileTemplates.medium_combat_knife_linesman,
		damage_type = damage_types.knife,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.default
	},
	action_melee_start_right = {
		anim_end_event = "attack_finished",
		kind = "windup",
		first_person_hit_anim = "attack_hit",
		allowed_during_sprint = true,
		anim_event = "attack_swing_charge_right",
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
				action_name = "action_right_heavy",
				chain_time = 0.3
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
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_2_ninja",
		anim_end_event = "attack_finished",
		kind = "sweep",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		allowed_during_sprint = true,
		damage_window_end = 0.39,
		anim_event = "attack_swing_right_diagonal_up",
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
				chain_time = 0.4
			},
			special_action = {
				action_name = "action_special_jab",
				chain_time = 0.45
			},
			block = {
				action_name = "action_block",
				chain_time = 0
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/swing_ninja_right_01",
			anchor_point_offset = {
				0,
				0,
				-0.09
			}
		},
		damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
		damage_type = damage_types.knife,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.right_45_slash_clean
	},
	action_right_heavy = {
		damage_window_start = 0.36666666666666664,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_2_ninja",
		anim_end_event = "attack_finished",
		kind = "sweep",
		attack_direction_override = "push",
		range_mod = 1.25,
		allowed_during_sprint = true,
		first_person_hit_stop_anim = "attack_hit",
		damage_window_end = 0.43333333333333335,
		anim_event = "attack_swing_heavy_right",
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
				action_name = "action_melee_start_left_2",
				chain_time = 0.5
			},
			special_action = {
				action_name = "action_special_jab",
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
		weapon_box = short_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/heavy_swing_right",
			anchor_point_offset = {
				0,
				0,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.medium_combat_knife_linesman,
		damage_type = damage_types.knife,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.default
	},
	action_melee_start_left_2 = {
		kind = "windup",
		anim_end_event = "attack_finished",
		weapon_handling_template = "time_scale_1_5_ninja",
		first_person_hit_anim = "attack_hit",
		allowed_during_sprint = true,
		anim_event = "attack_swing_charge_down_left",
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
				action_name = "action_heavy_3",
				chain_time = 0.3
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
		damage_window_start = 0.29,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_ninja",
		kind = "sweep",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		allowed_during_sprint = true,
		damage_window_end = 0.35,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_up_left",
		anim_event = "attack_swing_left_diagonal_up",
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
				action_name = "action_special_jab",
				chain_time = 0.5
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.45
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/swing_left_diagonal_up",
			anchor_point_offset = {
				0,
				0,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
		damage_type = damage_types.knife,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.default
	},
	action_melee_start_right_2 = {
		anim_end_event = "attack_finished",
		kind = "windup",
		first_person_hit_anim = "attack_hit",
		allowed_during_sprint = true,
		anim_event = "attack_swing_charge_down_diagonal_right",
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
				action_name = "action_right_light_2"
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.3
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
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_2_ninja",
		anim_end_event = "attack_finished",
		kind = "sweep",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		allowed_during_sprint = true,
		damage_window_end = 0.39,
		anim_event = "attack_swing_right",
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
				action_name = "action_special_jab",
				chain_time = 0.6
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
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/swing_ninja_right",
			anchor_point_offset = {
				0,
				0,
				-0.22
			}
		},
		damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
		damage_type = damage_types.knife,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.right_45_slash_clean
	},
	action_heavy_3 = {
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_2_ninja",
		anim_end_event = "attack_finished",
		kind = "sweep",
		attack_direction_override = "push",
		range_mod = 1.25,
		allowed_during_sprint = true,
		first_person_hit_stop_anim = "attack_hit",
		damage_window_end = 0.4666666666666667,
		anim_event = "attack_swing_heavy_down_left",
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
				action_name = "action_melee_start_left",
				chain_time = 0.53
			},
			special_action = {
				action_name = "action_special_jab",
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
		weapon_box = short_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/heavy_swing_down_left",
			anchor_point_offset = {
				0.25,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.medium_combat_knife_ninja_fencer,
		damage_type = damage_types.knife,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.default
	},
	action_block = {
		weapon_handling_template = "time_scale_1_5_ninja",
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
				action_name = "action_special_jab",
				chain_time = 0.25
			}
		}
	},
	action_right_light_pushfollow = {
		damage_window_start = 0.266,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		weapon_handling_template = "time_scale_1_3_ninja",
		attack_direction_override = "push",
		sprint_requires_press_to_interrupt = "true",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		damage_window_end = 0.38,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_stab",
		anim_event = "attack_swing_stab",
		total_time = 1.33,
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
				action_name = "action_special_jab",
				chain_time = 0.44
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.44
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
			0.15,
			0.15,
			1.1
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/swing_stab_01",
			anchor_point_offset = {
				0,
				0,
				-0.17
			}
		},
		damage_profile = DamageProfileTemplates.medium_combat_knife_linesman,
		damage_type = damage_types.knife,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash_clean
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
				chain_time = 0.25
			},
			push_follow_up = {
				action_name = "action_right_light_pushfollow",
				chain_time = 0.25
			},
			block = {
				action_name = "action_block",
				chain_time = 0.32
			}
		},
		inner_push_rad = math.pi * 0.1,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.ninja_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical
	},
	action_special_jab = {
		damage_window_start = 0.24,
		hit_armor_anim = "attack_hit_shield",
		start_input = "special_action",
		kind = "sweep",
		attack_direction_override = "push",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		weapon_handling_template = "time_scale_1_ninja",
		damage_window_end = 0.35,
		anim_end_event = "attack_finished",
		anim_event = "attack_special",
		total_time = 2.33,
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
				action_name = "action_melee_start_left_jab_combo",
				chain_time = 0.32
			},
			special_action = {
				action_name = "action_special_jab",
				chain_time = 0.6
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
			0.6
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/attack_special_jab",
			anchor_point_offset = {
				-0.35,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.jab_special,
		damage_type = damage_types.punch,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_melee_start_left_jab_combo = {
		anim_event = "attack_swing_charge_down_left",
		allowed_during_sprint = true,
		kind = "windup",
		anim_end_event = "attack_finished",
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
				action_name = "action_left_heavy_jab_combo"
			},
			heavy_attack = {
				action_name = "action_left_heavy_jab_combo",
				chain_time = 0.3
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_left_heavy_jab_combo = {
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_2_ninja",
		anim_end_event = "attack_finished",
		kind = "sweep",
		attack_direction_override = "push",
		range_mod = 1.25,
		allowed_during_sprint = false,
		first_person_hit_stop_anim = "attack_hit",
		damage_window_end = 0.4666666666666667,
		anim_event = "attack_swing_heavy_down_left",
		power_level = 400,
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
				chain_time = 0.5
			},
			special_action = {
				action_name = "action_special_jab",
				chain_time = 0.85
			},
			block = {
				action_name = "action_block"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/combat_knife/heavy_swing_down_left",
			anchor_point_offset = {
				0.25,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.medium_combat_knife_ninja_fencer,
		damage_type = damage_types.knife,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.default
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
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.15
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
	"combat_knife",
	"p1"
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.dodge_template = "ninja_knife"
weapon_template.sprint_template = "ninja_l"
weapon_template.stamina_template = "combat_knife_p1"
weapon_template.toughness_template = "assault"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.combat_knife
weapon_template.overclocks = {
	armor_pierce_up_dps_down = {
		combatknife_p1_m1_dps_stat = -0.1,
		combatknife_p1_m1_armor_pierce_stat = 0.1
	},
	finesse_up_armor_pierce_down = {
		combatknife_p1_m1_armor_pierce_stat = -0.2,
		combatknife_p1_m1_finesse_stat = 0.2
	},
	first_target_up_armor_pierce_down = {
		combatknife_p1_m1_first_target_stat = 0.1,
		combatknife_p1_m1_armor_pierce_stat = -0.1
	},
	mobility_up_first_target_down = {
		combatknife_p1_m1_first_target_stat = -0.1,
		combatknife_p1_m1_mobility_stat = 0.1
	},
	dps_up_mobility_down = {
		combatknife_p1_m1_mobility_stat = -0.1,
		combatknife_p1_m1_dps_stat = 0.1
	}
}
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
weapon_template.base_stats = {
	combatknife_p1_m2_dps_stat = {
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
										display_name = "loc_weapon_stats_display_power"
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
										display_name = "loc_weapon_stats_display_power"
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
			action_right_light_2 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_special_jab = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_left_heavy_jab_combo = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_heavy_3 = {
				damage_trait_templates.default_melee_dps_stat
			}
		}
	},
	combatknife_p1_m2_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
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
			action_right_light = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_left_light_2 = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_light_2 = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_special_jab = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_left_heavy_jab_combo = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_heavy_3 = {
				damage_trait_templates.default_armor_pierce_stat
			}
		}
	},
	combatknife_p1_m2_finesse_stat = {
		display_name = "loc_stats_display_finesse_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.default_melee_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								boost_curve_multiplier_finesse = {}
							}
						}
					}
				}
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								boost_curve_multiplier_finesse = {}
							}
						}
					}
				}
			},
			action_right_light = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_left_light_2 = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_light_2 = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_special_jab = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_left_heavy_jab_combo = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_heavy_3 = {
				damage_trait_templates.default_melee_finesse_stat
			}
		},
		weapon_handling = {
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_left_heavy = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true
					}
				}
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
			},
			action_special_jab = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_left_heavy_jab_combo = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_heavy_3 = {
				weapon_handling_trait_templates.default_finesse_stat
			}
		}
	},
	combatknife_p1_m2_first_target_stat = {
		display_name = "loc_stats_display_first_target_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
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
			action_right_light = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_light_2 = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_light_2 = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_first_target_stat
			},
			action_special_jab = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_heavy_jab_combo = {
				damage_trait_templates.default_first_target_stat
			},
			action_heavy_3 = {
				damage_trait_templates.default_first_target_stat
			}
		}
	},
	combatknife_p1_m2_mobility_stat = {
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
local bespoke_combatknife_p1_traits = table.ukeys(WeaponTraitsBespokeCombatknifeP1)

table.append(weapon_template.traits, bespoke_combatknife_p1_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_very_fast_attack",
		description = "loc_weapon_stats_display_very_fast_attack_desc"
	},
	{
		display_name = "loc_weapon_keyword_ninja_fencer",
		description = "loc_weapon_stats_display_ninja_fencer_desc"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_ninja_fencer",
		type = "ninja_fencer",
		attack_chain = {
			"ninja_fencer",
			"ninja_fencer",
			"ninja_fencer",
			"ninja_fencer"
		}
	},
	secondary = {
		display_name = "loc_gestalt_linesman",
		type = "linesman",
		attack_chain = {
			"linesman",
			"linesman",
			"smiter"
		}
	},
	special = {
		desc = "loc_stats_special_action_special_attack_combatknife_p1m1_desc",
		display_name = "loc_weapon_special_fist_attack",
		type = "melee_hand"
	}
}
weapon_template.special_action_name = "action_special_jab"

return weapon_template
