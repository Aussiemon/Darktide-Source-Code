﻿-- chunkname: @scripts/settings/breed/breed_actions/chaos/chaos_plague_ogryn_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local GroundImpactFxTemplates = require("scripts/settings/fx/ground_impact_fx_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local action_data = {
	name = "chaos_plague_ogryn",
	idle = {
		anim_events = "idle",
	},
	death = {
		instant_ragdoll_chance = 1,
	},
	change_target = {
		rotate_towards_target_on_fwd = true,
		rotation_speed = 6,
		change_target_anim_events = {
			bwd = "change_target_bwd",
			fwd = "change_target_fwd",
			left = "change_target_left",
			right = "change_target_right",
		},
		change_target_anim_data = {
			change_target_fwd = {},
			change_target_bwd = {
				sign = 1,
				rad = math.pi,
			},
			change_target_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			change_target_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		change_target_rotation_timings = {
			change_target_bwd = 0,
			change_target_fwd = 0,
			change_target_left = 0,
			change_target_right = 0,
		},
		change_target_rotation_durations = {
			change_target_bwd = 1.6666666666666667,
			change_target_fwd = 1.2666666666666666,
			change_target_left = 1.3333333333333333,
			change_target_right = 1.3333333333333333,
		},
		change_target_event_anim_speed_durations = {
			change_target_fwd = 1.2666666666666666,
		},
	},
	follow = {
		default_lean_value = 1,
		enter_walk_distance = 2,
		idle_anim_events = "idle",
		lean_speed = 1,
		lean_variable_name = "lean",
		leave_walk_distance = 4,
		left_lean_value = 0,
		max_dot_lean_value = 0.25,
		path_lean_node_offset = 8,
		right_lean_value = 2,
		run_anim_event = "move_fwd",
		utility_weight = 1,
		walk_anim_event = "move_fwd",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			walking = {
				bwd = "move_fwd",
				fwd = "move_fwd",
				left = "move_fwd",
				right = "move_fwd",
			},
			running = {
				bwd = "move_start_bwd",
				fwd = "move_start_fwd",
				left = "move_start_left",
				right = "move_start_right",
			},
		},
		start_move_anim_data = {
			move_start_fwd = {},
			move_start_bwd = {
				sign = -1,
				rad = math.pi,
			},
			move_start_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			move_start_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			move_start_bwd = 0,
			move_start_fwd = 0,
			move_start_left = 0,
			move_start_right = 0,
		},
		start_rotation_durations = {
			move_start_bwd = 0.9333333333333333,
			move_start_fwd = 0,
			move_start_left = 0.9,
			move_start_right = 0.9,
		},
		start_move_event_anim_speed_durations = {
			move_start_fwd = 0.9333333333333333,
		},
	},
	climb = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_down_fence_land_1m = 0.5666666666666667,
			jump_down_land = 1.2,
			jump_down_land_1m = 0.8333333333333334,
			jump_down_land_3m = 1.5,
			jump_up_1m = 1.2333333333333334,
			jump_up_2m = 2.066666666666667,
			jump_up_3m = 2.566666666666667,
			jump_up_4m = 2.533333333333333,
			jump_up_5m = 2.7333333333333334,
			jump_up_fence_1m = 0.36666666666666664,
			jump_up_fence_3m = 1,
			jump_up_fence_5m = 1.2,
		},
		ending_move_states = {
			jump_down_fence_land_1m = "jumping",
			jump_down_land = "jumping",
			jump_down_land_1m = "jumping",
			jump_down_land_3m = "jumping",
			jump_down_land_5m = "jumping",
			jump_up_1m = "jumping",
			jump_up_2m = "jumping",
			jump_up_3m = "jumping",
			jump_up_4m = "jumping",
			jump_up_5m = "jumping",
		},
		blend_timings = {
			jump_down = 0.4,
			jump_down_1m = 0.4,
			jump_down_fence_land_1m = 0,
			jump_down_land = 0,
			jump_down_land_1m = 0,
			jump_down_land_3m = 0,
			jump_up_1m = 0.4,
			jump_up_2m = 0.4,
			jump_up_3m = 0.5,
			jump_up_4m = 0.4,
			jump_up_5m = 0.4,
			jump_up_fence_1m = 0.2,
			jump_up_fence_3m = 0.4,
			jump_up_fence_5m = 0.4,
		},
		catapult_units = {
			radius = 2,
			speed = 7,
			angle = math.pi / 6,
		},
	},
	jump_across = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_over_gap_4m = 1.4333333333333333,
		},
		ending_move_states = {
			jump_over_gap_4m = "jumping",
		},
		blend_timings = {
			jump_over_gap_4m = 0.2,
		},
	},
	melee_slam = {
		aoe_threat_duration = 0.75,
		aoe_threat_timing = 0.4,
		attack_type = "oobb",
		bot_power_level_modifier = 0.4,
		collision_filter = "filter_minion_melee_friendly_fire",
		height = 5,
		range = 3.5,
		utility_weight = 1,
		width = 1.25,
		considerations = UtilityConsiderations.chaos_plague_ogryn_slam_attack,
		attack_anim_events = {
			normal = {
				"attack_slam",
			},
			up = {
				"attack_reach_up",
			},
		},
		attack_anim_damage_timings = {
			attack_reach_up = 0.9666666666666667,
			attack_slam = 0.6518518518518519,
		},
		attack_anim_durations = {
			attack_reach_up = 2.3333333333333335,
			attack_slam = 1.7777777777777777,
		},
		attack_intensities = {
			elite_ranged = 4,
			melee = 0.25,
			moving_melee = 0.1,
			ranged = 5,
			running_melee = 2,
		},
		damage_profile = DamageProfileTemplates.monster_slam,
		damage_type = damage_types.minion_monster_blunt,
		aoe_bot_threat_oobb_size = Vector3Box(1.5, 2.25, 2.5),
		ground_impact_fx_template = GroundImpactFxTemplates.chaos_plague_ogryn_slam,
	},
	plague_stomp = {
		anim_driven = true,
		aoe_bot_threat_broadphase_size = 5,
		aoe_threat_duration = 1.5,
		aoe_threat_timing = 0.2,
		attack_type = "broadphase",
		bot_power_level_modifier = 0.5,
		broadphase_node = "j_leftfoot",
		dodge_weapon_reach = 3.5,
		utility_weight = 10,
		weapon_reach = 4.25,
		considerations = UtilityConsiderations.chaos_plague_ogryn_plague_stomp,
		attack_anim_events = {
			"attack_stomp",
		},
		attack_anim_damage_timings = {
			attack_stomp = 1.0606060606060606,
		},
		attack_anim_durations = {
			attack_stomp = 1.9696969696969697,
		},
		attack_intensities = {
			melee = 0.25,
			moving_melee = 1,
			ranged = 1,
			running_melee = 2,
		},
		damage_profile = DamageProfileTemplates.chaos_plague_ogryn_plague_stomp,
		damage_type = damage_types.minion_monster_blunt,
		ground_impact_fx_template = GroundImpactFxTemplates.chaos_plague_ogryn_plague_stomp,
		stagger_type_reduction = {
			explosion = 100,
			ranged = 100,
		},
	},
	charge = {
		attack_anim = "attack_charge_hit_player",
		attack_anim_damage_timing = 0.06060606060606061,
		attack_anim_duration = 1.2121212121212122,
		charge_max_speed_at = 2,
		charge_speed_max = 12.100000000000001,
		charge_speed_min = 7.700000000000001,
		charged_past_dot = 0.1,
		charged_past_duration = 1.5,
		close_distance = 8,
		close_rotation_speed = 5,
		collision_radius = 2,
		default_lean_value = 1,
		dodge_rotation_speed = 0.01,
		lean_speed = 1,
		lean_variable_name = "lean",
		left_lean_value = 0,
		max_dot_lean_value = 0.1,
		max_duration = 8,
		max_slowdown_angle = 40,
		max_slowdown_percentage = 0.25,
		min_slowdown_angle = 20,
		min_time_navigating = 0.5,
		min_time_spent_charging = 1,
		power_level = 150,
		push_minions_power_level = 2000,
		push_minions_radius = 4,
		push_minions_side_relation = "allied",
		right_lean_value = 2,
		rotation_speed = 6,
		target_extrapolation_length_scale = 0.5,
		utility_weight = 1,
		wall_raycast_distance = 4.25,
		wall_raycast_node_name = "j_spine",
		wall_stun_time = 3,
		considerations = UtilityConsiderations.chaos_plague_ogryn_charge,
		charge_direction_anim_events = {
			bwd = "attack_charge_start_bwd",
			fwd = "attack_charge_start_fwd",
			left = "attack_charge_start_left",
			right = "attack_charge_start_right",
		},
		start_move_anim_data = {
			attack_charge_start_fwd = {},
			attack_charge_start_bwd = {
				sign = 1,
				rad = math.pi,
			},
			attack_charge_start_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			attack_charge_start_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			attack_charge_start_bwd = 0.16,
			attack_charge_start_left = 0.16,
			attack_charge_start_right = 0.16,
		},
		start_rotation_durations = {
			attack_charge_start_bwd = 0.96,
			attack_charge_start_left = 0.5333333333333333,
			attack_charge_start_right = 0.6933333333333334,
		},
		charge_direction_durations = {
			attack_charge_start_bwd = 2.1866666666666665,
			attack_charge_start_fwd = 1.92,
			attack_charge_start_left = 2.08,
			attack_charge_start_right = 1.92,
		},
		push_minions_damage_profile = DamageProfileTemplates.chaos_plague_ogryn_minion_charge_push,
		collision_angle = math.degrees_to_radians(100),
		effect_template = EffectTemplates.chaos_plague_ogryn_charge_impact,
		miss_animations = {
			"attack_charge_miss",
		},
		miss_durations = {
			attack_charge_miss = 2.2666666666666666,
		},
		can_hit_wall_durations = {
			attack_charge_miss = 1.0666666666666667,
		},
		damage_profile = DamageProfileTemplates.chaos_plague_ogryn_charge,
		damage_type = damage_types.minion_monster_blunt,
	},
	combo_attack = {
		aoe_bot_threat_sweep_reach = 5,
		aoe_threat_duration = 2.074074074074074,
		aoe_threat_timing = 0,
		attack_type = "sweep",
		bot_power_level_modifier = 0.5,
		collision_filter = "filter_minion_melee",
		dodge_weapon_reach = 1.25,
		ignore_blocked = true,
		move_speed = 4,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		rotation_speed = 5,
		sweep_ground_impact_fx_timing = 2.785185185185185,
		sweep_node = "j_righthandmiddle1",
		utility_weight = 3,
		weapon_reach = 2,
		considerations = UtilityConsiderations.chaos_plague_ogryn_combo_attack,
		attack_anim_events = {
			"attack_sword_combo",
		},
		attack_anim_durations = {
			attack_sword_combo = 3.5555555555555554,
		},
		attack_sweep_damage_timings = {
			attack_sword_combo = {
				{
					1.0962962962962963,
					1.2148148148148148,
				},
				{
					1.8074074074074074,
					1.9259259259259258,
				},
				{
					2.696296296296296,
					2.8444444444444446,
				},
			},
		},
		attack_intensities = {
			melee = 0.25,
			moving_melee = 1,
			ranged = 1,
			running_melee = 2,
		},
		move_start_timings = {
			attack_sword_combo = 0.7703703703703704,
		},
		damage_profile = DamageProfileTemplates.chaos_plague_ogryn_scythe,
		damage_type = damage_types.minion_monster_sharp,
		stagger_type_reduction = {
			explosion = 100,
			ranged = 100,
		},
		animation_move_speed_configs = {
			attack_sword_combo = {
				{
					distance = 8,
					value = 4,
				},
				{
					distance = 6.4,
					value = 3,
				},
				{
					distance = 4,
					value = 2,
				},
				{
					distance = 2,
					value = 1,
				},
				{
					distance = 0.8,
					value = 0,
				},
			},
		},
		sweep_ground_impact_fx_template = GroundImpactFxTemplates.chaos_plague_ogryn_combo_end,
	},
	catapult_attack = {
		aoe_threat_duration = 1.9,
		aoe_threat_timing = 0.6,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee",
		dont_lock_slot_system = true,
		height = 3,
		ignore_blocked = true,
		ignore_dodge = true,
		move_speed = 4,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		range = 4,
		rotate_towards_velocity_after_attack = true,
		rotation_speed = 5,
		utility_weight = 2.5,
		width = 2,
		considerations = UtilityConsiderations.chaos_plague_ogryn_catapult_attack,
		attack_anim_events = {
			"attack_catapult",
		},
		attack_anim_damage_timings = {
			attack_catapult = 0.8253968253968254,
		},
		attack_anim_durations = {
			attack_catapult = 2.2857142857142856,
		},
		attack_intensities = {
			melee = 0.25,
			moving_melee = 1,
			ranged = 1,
			running_melee = 2,
		},
		move_start_timings = {
			attack_catapult = 0,
		},
		damage_profile = DamageProfileTemplates.chaos_plague_ogryn_catapult,
		damage_type = damage_types.minion_monster_blunt,
		aoe_bot_threat_oobb_size = Vector3Box(1.5, 2.25, 2.5),
		stagger_type_reduction = {
			explosion = 100,
			ranged = 100,
		},
		animation_move_speed_configs = {
			attack_sword_combo = {
				{
					distance = 8,
					value = 4,
				},
				{
					distance = 6.4,
					value = 3,
				},
				{
					distance = 4,
					value = 2,
				},
				{
					distance = 2,
					value = 1,
				},
				{
					distance = 0,
					value = 0,
				},
			},
		},
	},
	stagger = {
		stagger_anims = {
			light = {
				fwd = {
					"stagger_fwd_heavy",
				},
				bwd = {
					"stagger_bwd_heavy",
				},
				left = {
					"stagger_left_heavy",
				},
				right = {
					"stagger_right_heavy",
				},
				dwn = {
					"stagger_bwd_heavy",
				},
			},
			medium = {
				fwd = {
					"stagger_fwd_heavy",
				},
				bwd = {
					"stagger_bwd_heavy",
				},
				left = {
					"stagger_left_heavy",
				},
				right = {
					"stagger_right_heavy",
				},
				dwn = {
					"stagger_bwd_heavy",
				},
			},
			heavy = {
				fwd = {
					"stagger_fwd_heavy",
				},
				bwd = {
					"stagger_bwd_heavy",
				},
				left = {
					"stagger_left_heavy",
				},
				right = {
					"stagger_right_heavy",
				},
				dwn = {
					"stagger_bwd_heavy",
				},
			},
			light_ranged = {
				fwd = {
					"stagger_fwd_heavy",
				},
				bwd = {
					"stagger_bwd_heavy",
				},
				left = {
					"stagger_left_heavy",
				},
				right = {
					"stagger_right_heavy",
				},
				dwn = {
					"stagger_bwd_heavy",
				},
			},
			explosion = {
				fwd = {
					"stagger_fwd_heavy",
				},
				bwd = {
					"stagger_bwd_heavy",
				},
				left = {
					"stagger_left_heavy",
				},
				right = {
					"stagger_right_heavy",
				},
				dwn = {
					"stagger_bwd_heavy",
				},
			},
			killshot = {
				fwd = {
					"stagger_fwd_heavy",
				},
				bwd = {
					"stagger_bwd_heavy",
				},
				left = {
					"stagger_left_heavy",
				},
				right = {
					"stagger_right_heavy",
				},
				dwn = {
					"stagger_bwd_heavy",
				},
			},
			sticky = {
				fwd = {
					"stagger_fwd_heavy",
				},
				bwd = {
					"stagger_bwd_heavy",
				},
				left = {
					"stagger_left_heavy",
				},
				right = {
					"stagger_right_heavy",
				},
				dwn = {
					"stagger_bwd_heavy",
				},
			},
			electrocuted = {
				fwd = {
					"stagger_fwd_heavy",
				},
				bwd = {
					"stagger_bwd_heavy",
				},
				left = {
					"stagger_left_heavy",
				},
				right = {
					"stagger_right_heavy",
				},
				dwn = {
					"stagger_bwd_heavy",
				},
			},
			wall_collision = {
				fwd = {
					"attack_charge_hit_wall",
				},
				bwd = {
					"attack_charge_hit_wall",
				},
				left = {
					"attack_charge_hit_wall",
				},
				right = {
					"attack_charge_hit_wall",
				},
				dwn = {
					"attack_charge_hit_wall",
				},
			},
			blinding = {
				fwd = {
					"stagger_fwd_heavy",
				},
				bwd = {
					"stagger_bwd_heavy",
				},
				left = {
					"stagger_left_heavy",
				},
				right = {
					"stagger_right_heavy",
				},
				dwn = {
					"stagger_bwd_heavy",
				},
			},
		},
	},
	open_door = {
		rotation_duration = 0.1,
		stagger_immune = true,
	},
	smash_obstacle = {
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_slam",
		},
		attack_anim_damage_timings = {
			attack_slam = 0.7333333333333333,
		},
		attack_anim_durations = {
			attack_slam = 2,
		},
		damage_profile = DamageProfileTemplates.default,
	},
	exit_spawner = {
		run_anim_event = "move_fwd",
	},
}

return action_data
