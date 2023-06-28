local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local MeleeActionInputSetupSlow = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_slow")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTraitsBespokeOgrynPowerMaulSlabshieldP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_powermaul_slabshield_p1")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local armor_types = ArmorSettings.types
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_template = {
	action_inputs = table.clone(MeleeActionInputSetupSlow.action_inputs),
	action_input_hierarchy = table.clone(MeleeActionInputSetupSlow.action_input_hierarchy)
}
weapon_template.action_input_hierarchy.special_action_hold = {
	special_action_release = "base"
}
local hit_zone_priority = {
	[hit_zone_names.head] = 2,
	[hit_zone_names.torso] = 1,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

weapon_template.actions = {
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
			special_action_hold = {
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
				modifier = 0.7,
				t = 1
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
			light_attack = {
				action_name = "action_left_light"
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
	action_left_light = {
		damage_window_start = 0.43333333333333335,
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		attack_direction_override = "left",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		allowed_during_sprint = true,
		weapon_handling_template = "time_scale_1",
		damage_window_end = 0.5333333333333333,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_left",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 0.5,
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
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
				chain_time = 0.6
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5
			},
			special_action_hold = {
				action_name = "action_weapon_special",
				chain_time = 0.6
			}
		},
		hit_zone_priority = hit_zone_priority,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.2,
			0.15,
			1
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/swing_left",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
		damage_profile = DamageProfileTemplates.ogryn_powermaul_light_tank,
		damage_type = damage_types.ogryn_pipe_club
	},
	action_left_heavy = {
		damage_window_start = 0.4666666666666667,
		hit_armor_anim = "attack_hit",
		weapon_handling_template = "time_scale_1",
		kind = "sweep",
		attack_direction_override = "left",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
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
				modifier = 0.45,
				t = 0.7
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.5
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
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
				action_name = "action_melee_start_left_3",
				chain_time = 0.85
			},
			block = {
				action_name = "action_block",
				chain_time = 0.7
			},
			special_action_hold = {
				action_name = "action_weapon_special",
				chain_time = 0.8
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.9,
			0.3,
			1.25
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/heavy_swing_shieldslam",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_powermaul_slabshield_tank,
		damage_type = damage_types.ogryn_pipe_club
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
				modifier = 0.7,
				t = 1
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
		damage_window_start = 0.4666666666666667,
		hit_armor_anim = "attack_hit",
		range_mod = 1.25,
		kind = "sweep",
		weapon_handling_template = "time_scale_1",
		attack_direction_override = "right",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		damage_window_end = 0.6,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_right",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 0.5,
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
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
				chain_time = 0.75
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6
			},
			special_action_hold = {
				action_name = "action_weapon_special",
				chain_time = 0.9
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
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/swing_right",
			anchor_point_offset = {
				0,
				0,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_powermaul_light_tank,
		damage_type = damage_types.ogryn_pipe_club
	},
	action_right_heavy = {
		damage_window_start = 0.5,
		hit_armor_anim = "attack_hit",
		range_mod = 1.25,
		kind = "sweep",
		weapon_handling_template = "time_scale_1",
		attack_direction_override = "push",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		damage_window_end = 0.6333333333333333,
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
				modifier = 0.4,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.5
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
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
				action_name = "action_melee_start_right_3",
				chain_time = 0.75
			},
			block = {
				action_name = "action_block",
				chain_time = 0.65
			},
			special_action_hold = {
				action_name = "action_weapon_special",
				chain_time = 1
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			1,
			0.4,
			1.25
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/heavy_swing_shieldstab",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_powermaul_slabshield_smite,
		damage_type = damage_types.ogryn_pipe_club
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
				modifier = 0.7,
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
				modifier = 0.7,
				t = 1
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
			light_attack = {
				action_name = "action_left_light_2"
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
	action_left_light_2 = {
		damage_window_start = 0.4,
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		attack_direction_override = "left",
		first_person_hit_stop_anim = "attack_hit",
		weapon_handling_template = "time_scale_1_1",
		range_mod = 1.25,
		damage_window_end = 0.6,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_left_diagonal_down",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 0.5,
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
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
				chain_time = 0.6
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55
			},
			special_action_hold = {
				action_name = "action_weapon_special",
				chain_time = 0.9
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.1,
			1.15
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/swing_left_diagonal",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
		damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
		damage_type = damage_types.ogryn_pipe_club
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
				modifier = 0.7,
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
				modifier = 0.7,
				t = 1
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
			light_attack = {
				action_name = "action_right_light_2"
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.5
			},
			block = {
				action_name = "action_block"
			},
			special_action_hold = {
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
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		weapon_handling_template = "time_scale_1_2",
		attack_direction_override = "right",
		damage_window_end = 0.6,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_right_diagonal_down",
		total_time = 1.8,
		action_movement_curve = {
			{
				modifier = 0.5,
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
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
				chain_time = 0.85
			},
			block = {
				action_name = "action_block",
				chain_time = 0.7
			},
			special_action_hold = {
				action_name = "action_weapon_special",
				chain_time = 1.3
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
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/slab_shield/slab_shield_maul/swing_right_diagonal",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
		damage_profile = DamageProfileTemplates.ogryn_powermaul_light_linesman,
		damage_type = damage_types.ogryn_pipe_club
	},
	action_melee_start_right_3 = {
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
				modifier = 0.7,
				t = 1
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
			light_attack = {
				action_name = "action_left_light_2"
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
	action_melee_start_left_3 = {
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
				modifier = 0.7,
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
				modifier = 0.7,
				t = 1
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
			light_attack = {
				action_name = "action_left_light"
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
	action_weapon_special = {
		anim_event = "special_parry_pose",
		can_crouch = false,
		uninterruptible = true,
		kind = "block",
		start_input = "special_action_hold",
		crosshair_type = "none",
		block_goes_brrr = true,
		weapon_special = true,
		anim_end_event = "parry_finished",
		lock_view_at_time = 0.8,
		can_jump = false,
		disallow_dodging = true,
		force_look = true,
		stop_input = "special_action_release",
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
				modifier = 0.2,
				t = 0.35
			},
			{
				modifier = 0,
				t = 0.5
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
			}
		},
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true
		}
	},
	action_block = {
		block_unblockable = true,
		start_input = "block",
		anim_end_event = "parry_finished",
		kind = "block",
		uninterruptible = true,
		anim_event = "parry_pose",
		stop_input = "block_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.2,
				t = 0.2
			},
			{
				modifier = 0.35,
				t = 0.3
			},
			{
				modifier = 0.35,
				t = 0.325
			},
			{
				modifier = 0.35,
				t = 0.5
			},
			{
				modifier = 0.8,
				t = 1
			},
			{
				modifier = 0.9,
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
		},
		block_attack_types = {
			[attack_types.melee] = true,
			[attack_types.ranged] = true
		}
	},
	action_right_light_pushfollow = {
		damage_window_start = 0.16666666666666666,
		hit_armor_anim = "attack_hit",
		weapon_handling_template = "time_scale_1",
		kind = "sweep",
		attack_direction_override = "push",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		damage_window_end = 0.3,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_left_down",
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
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
		hit_zone_priority = default_hit_zone_priority,
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
		damage_profile = DamageProfileTemplates.ogryn_powermaul_shield_light_smiter,
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
				chain_time = 0.4
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.4
			}
		},
		inner_push_rad = math.pi * 0.55,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.ogryn_shield_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.default_shield_push,
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
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
weapon_template.base_stats = {
	ogryn_powermaul_slabshield_dps_stat = {
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
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_light = {
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
	ogryn_powermaul_slabshield_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						armor_damage_modifier = {
							attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers
						}
					}
				}
			},
			action_left_heavy = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_light = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						armor_damage_modifier = {
							attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers
						}
					}
				}
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
	ogryn_powermaul_slabshield_control_stat = {
		description = "loc_stats_display_control_stat_melee_mouseover",
		display_name = "loc_stats_display_control_stat_melee",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.thunderhammer_control_stat,
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
				damage_trait_templates.thunderhammer_control_stat,
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
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_left_heavy = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_light = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_heavy = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true
					}
				}
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
	ogryn_powermaul_slabshield_cleave_damage_stat = {
		display_name = "loc_stats_display_cleave_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.combatsword_cleave_damage_stat,
				display_data = {
					display_stats = {
						armor_damage_modifier = {
							attack = {
								[armor_types.armored] = {
									display_name = "loc_weapon_stats_display_cleave_armored"
								},
								[armor_types.unarmored] = {
									display_name = "loc_weapon_stats_display_cleave_unarmored"
								},
								[armor_types.disgustingly_resilient] = {
									display_name = "loc_weapon_stats_display_cleave_disgustingly_resilient"
								}
							}
						}
					}
				}
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
	ogryn_powermaul_slabshield_defence_stat = {
		display_name = "loc_stats_display_defense_stat",
		is_stat_trait = true,
		stamina = {
			base = {
				stamina_trait_templates.thunderhammer_p1_m1_defence_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		},
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
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
weapon_template.sprint_ready_up_time = 0.2
weapon_template.max_first_person_anim_movement_speed = 4.8
weapon_template.has_first_person_dodge_events = true
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_shield",
	_sweep = "fx_sweep"
}
weapon_template.shield_block_source_name = "_block"
weapon_template.crosshair_type = "dot"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"ogryn_powermaul_slabshield",
	"p1"
}
weapon_template.dodge_template = "support"
weapon_template.sprint_template = "ogryn"
weapon_template.stamina_template = "ogryn_powermaul_slabshield_p1_m1"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.slabshield
weapon_template.traits = {}
local bespoke_ogryn_powermaul_slabshield_traits = table.keys(WeaponTraitsBespokeOgrynPowerMaulSlabshieldP1)

table.append(weapon_template.traits, bespoke_ogryn_powermaul_slabshield_traits)

weapon_template.buffs = {
	on_equip = {
		"ogryn_slabshield_shield_plant"
	}
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control"
	},
	{
		display_name = "loc_achievement_category_defensive_label",
		description = "loc_weapon_stats_display_defensive_desc"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {
			"tank",
			"tank",
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
		desc = "loc_weapon_special_defensive_stance_desc",
		display_name = "loc_weapon_special_defensive_stance",
		type = "activate"
	}
}
weapon_template.block_override_anims = {
	[attack_types.ranged] = {
		parry_hit_reaction = "parry_hit_reaction_ranged"
	}
}

return weapon_template
