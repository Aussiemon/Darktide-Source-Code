local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MeleeActionInputSetupSlow = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_slow")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTraitsBespokeOgrynClubP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_club_p2")
local WeaponTraitsMeleeCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local template_types = WeaponTweakTemplateSettings.template_types
local wounds_shapes = WoundsSettings.shapes
local buff_stat_buffs = BuffSettings.stat_buffs
local armor_types = ArmorSettings.types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local weapon_template = {}
local hit_zone_names = HitZone.hit_zone_names
local hit_zone_priority = {
	[hit_zone_names.head] = 2,
	[hit_zone_names.torso] = 1,
	[hit_zone_names.weakspot] = 2,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

weapon_template.action_inputs = table.clone(MeleeActionInputSetupSlow.action_inputs)
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupSlow.action_input_hierarchy)
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
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_left_light",
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.6
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.7
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_left_light = {
		damage_window_start = 0.5,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_0_9",
		kind = "sweep",
		first_person_hit_anim = "hit_left_down_shake",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		range_mod = 1.25,
		damage_window_end = 0.6,
		attack_direction_override = "left",
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_left_diagonal",
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.65
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
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
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_left_diagonal",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_club_light_linesman,
		damage_type = damage_types.ogryn_pipe_club,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
		wounds_shape = wounds_shapes.left_45_slash_coarse
	},
	action_left_heavy = {
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		weapon_handling_template = "time_scale_1_3",
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		range_mod = 1.25,
		damage_window_end = 0.4,
		attack_direction_override = "right",
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_heavy_right",
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.65
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.3
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_right",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_club_heavy_tank,
		damage_type = damage_types.ogryn_pipe_club,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
		wounds_shape = wounds_shapes.horizontal_slash_coarse
	},
	action_melee_start_right = {
		anim_end_event = "attack_finished",
		kind = "windup",
		uninterruptible = true,
		anim_event = "attack_swing_charge_right",
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
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_right_light = {
		damage_window_start = 0.4666666666666667,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		weapon_handling_template = "time_scale_1_2",
		attack_direction_override = "right",
		damage_window_end = 0.5666666666666667,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_right_diagonal",
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
				chain_time = 0.65
			},
			block = {
				action_name = "action_block",
				chain_time = 0
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
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
		damage_profile = DamageProfileTemplates.ogryn_club_light_linesman,
		damage_type = damage_types.ogryn_pipe_club,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
		wounds_shape = wounds_shapes.right_45_slash_coarse
	},
	action_right_heavy = {
		damage_window_start = 0.23333333333333334,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		weapon_handling_template = "time_scale_1",
		first_person_hit_anim = "hit_down_shake",
		first_person_hit_stop_anim = "hit_down_shake",
		allowed_during_sprint = true,
		range_mod = 1.25,
		damage_window_end = 0.3333333333333333,
		attack_direction_override = "push",
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_heavy_down",
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
				chain_time = 0.17
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.5
			},
			block = {
				action_name = "action_block",
				chain_time = 0.15
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.1
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.2,
			0.15,
			1.25
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/heavy_swing_down",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_club_heavy_smiter,
		damage_type = damage_types.ogryn_pipe_club,
		herding_template = HerdingTemplates.smiter_down,
		wounds_shape = wounds_shapes.vertical_slash_coarse
	},
	action_melee_start_left_2 = {
		anim_end_event = "attack_finished",
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
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_left_light_2"
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.75
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_left_light_2 = {
		damage_window_start = 0.26666666666666666,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1_1",
		kind = "sweep",
		first_person_hit_anim = "hit_left_shake",
		range_mod = 1.25,
		first_person_hit_stop_anim = "attack_hit",
		anim_event_3p = "attack_swing_punch",
		damage_window_end = 0.3333333333333333,
		attack_direction_override = "push",
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_stab",
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.65
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.25,
			0.25,
			1.25
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_stab",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_club_light_smiter,
		damage_type = damage_types.ogryn_pipe_club,
		herding_template = HerdingTemplates.ogryn_punch,
		wounds_shape = wounds_shapes.default
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
				action_name = "grenade_ability"
			},
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
		damage_window_start = 0.36666666666666664,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1",
		anim_end_event = "attack_finished",
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		range_mod = 1.25,
		first_person_hit_stop_anim = "attack_hit",
		attack_direction_override = "right",
		damage_window_end = 0.4666666666666667,
		anim_event_3p = "attack_swing_right",
		anim_event = "push_follow_up_01",
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
				chain_time = 0.65
			},
			block = {
				action_name = "action_block",
				chain_time = 0.65
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.65
			},
			grenade_ability = {
				action_name = "grenade_ability"
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
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/push_follow_up",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_club_smiter_pushfollow,
		damage_type = damage_types.ogryn_pipe_club,
		wounds_shape = wounds_shapes.horizontal_slash_coarse
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
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.5
			}
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.ogryn_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.default_push,
		outer_damage_type = damage_types.physical
	},
	action_weapon_special = {
		damage_window_start = 0.34,
		hit_armor_anim = "attack_hit",
		start_input = "special_action",
		range_mod = 1.25,
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		weapon_handling_template = "time_scale_0_9",
		allowed_during_sprint = true,
		activation_cooldown = 6,
		first_person_hit_stop_anim = "hit_right_shake",
		damage_window_end = 0.39,
		anim_end_event = "attack_finished",
		activate_special = true,
		attack_direction_override = "right",
		uninterruptible = true,
		anim_event = "attack_swing_slap",
		total_time = 1.4,
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
				chain_time = 0.4
			},
			block = {
				action_name = "action_block",
				chain_time = 0.8
			},
			special_action = {
				action_name = "action_weapon_special_2",
				chain_time = 0.7
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.4,
			0.45,
			1
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_slap",
			anchor_point_offset = {
				0.15,
				-0.3,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_club_special,
		damage_type = damage_types.ogryn_slap,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy
	},
	action_weapon_special_2 = {
		damage_window_start = 0.3333333333333333,
		hit_armor_anim = "attack_hit",
		uninterruptible = true,
		kind = "sweep",
		first_person_hit_anim = "hit_left_shake",
		weapon_handling_template = "time_scale_0_9",
		allowed_during_sprint = true,
		activation_cooldown = 6,
		first_person_hit_stop_anim = "hit_left_shake",
		damage_window_end = 0.4,
		anim_end_event = "attack_finished",
		activate_special = true,
		range_mod = 1.25,
		attack_direction_override = "left",
		anim_event_3p = "attack_swing_slap_left",
		anim_event = "attack_swing_slap_left",
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
				chain_time = 0.7
			},
			block = {
				action_name = "action_block",
				chain_time = 1.2
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 1
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = {
			0.4,
			0.56,
			1
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/club_ogryn/swing_slap_left",
			anchor_point_offset = {
				0.15,
				-0.3,
				-0.15
			}
		},
		damage_profile = DamageProfileTemplates.ogryn_club_special,
		damage_type = damage_types.ogryn_slap,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy
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
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
weapon_template.base_stats = {
	ogryn_club_p2_m1_dps_stat = {
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
			action_weapon_special_2 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_stat
			}
		}
	},
	ogryn_club_p2_m1_armor_pierce_stat = {
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
			action_left_light_2 = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_weapon_special = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_weapon_special_2 = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat
			}
		}
	},
	ogryn_club_p2_m1_finesse_stat = {
		display_name = "loc_stats_display_finesse_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_finesse_stat
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
			action_weapon_special = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_weapon_special_2 = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_finesse_stat
			}
		},
		weapon_handling = {
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
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
			action_weapon_special_2 = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat
			}
		}
	},
	ogryn_club_p2_m1_defence_stat = {
		display_name = "loc_stats_display_defense_stat",
		is_stat_trait = true,
		stamina = {
			base = {
				stamina_trait_templates.thunderhammer_p1_m1_defence_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	},
	ogryn_club_p2_m1_mobility_stat = {
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
local melee_common_traits = table.keys(WeaponTraitsMeleeCommon)

table.append(weapon_template.traits, melee_common_traits)

local bespoke_ogryn_club_p2 = table.keys(WeaponTraitsBespokeOgrynClubP2)

table.append(weapon_template.traits, bespoke_ogryn_club_p2)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_versatile"
	},
	{
		display_name = "loc_weapon_keyword_smiter"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_linesman",
		type = "linesman",
		attack_chain = {
			"linesman",
			"linesman",
			"smiter"
		}
	},
	secondary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"tank"
		}
	},
	special = {
		desc = "loc_stats_special_action_special_attack_ogryn_club_p2m1_desc",
		display_name = "loc_weapon_special_fist_attack",
		type = "melee_hand"
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
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_block",
	_sweep = "fx_sweep"
}
weapon_template.crosshair_type = "dot"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"ogryn_club",
	"p2"
}
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn"
weapon_template.stamina_template = "tank"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "ogryn_club_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_club
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.special_action_name = "action_weapon_special"

return weapon_template
