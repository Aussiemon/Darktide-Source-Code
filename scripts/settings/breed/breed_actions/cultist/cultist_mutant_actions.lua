-- chunkname: @scripts/settings/breed/breed_actions/cultist/cultist_mutant_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local MinionPushFxTemplates = require("scripts/settings/fx/minion_push_fx_templates")
local damage_types = DamageSettings.damage_types
local action_data = {
	name = "cultist_mutant",
	idle = {
		anim_events = "idle",
	},
	death = {
		instant_ragdoll_chance = 1,
	},
	charge = {
		after_throw_taunt_anim = "idle_shout",
		after_throw_taunt_duration = 2.5,
		animation_charge_speed = 8,
		aoe_bot_threat_distance = 8,
		aoe_bot_threat_duration = 1,
		charge_max_speed_at = 4.5,
		charge_speed_max = 12,
		charge_speed_min = 8,
		charged_past_dot_threshold = 0.1,
		close_distance = 5,
		close_rotation_speed = 3,
		collision_radius = 1,
		degree_per_throw_direction = 20,
		dodge_collision_radius = 0.5,
		dodge_rotation_speed = 0.01,
		grab_close_up_distance = 3,
		max_animation_variable = 1.2,
		max_slowdown_angle = 60,
		max_slowdown_percentage = 0.5,
		min_animation_variable = 0.9,
		min_slowdown_angle = 20,
		min_time_navigating = 0.2,
		min_time_spent_charging = 0.1,
		navigating_anim = "charge_fwd",
		navigating_rotation_speed = 6,
		prepare_grab_anim = "charge_grab_prep",
		push_minions_damage_type = nil,
		push_minions_power_level = 2000,
		push_minions_radius = 2,
		push_minions_side_relation = "allied",
		rotation_speed = 4.5,
		target_extrapolation_length_scale = 0.25,
		throw_test_distance = 8,
		wall_raycast_distance = 2,
		wall_raycast_node_name = "j_spine",
		wall_stun_time = 3.5,
		charge_anims = {
			bwd = "change_target_bwd",
			fwd = "change_target_fwd",
			left = "change_target_left",
			right = "change_target_right",
		},
		miss_animations = {
			"charge_grab_miss",
		},
		miss_durations = {
			charge_grab_miss = 2.1,
		},
		grab_anims = {
			human = "attack_grab_human",
			ogryn = "attack_grab_ogryn",
		},
		grab_anim_duration = {
			human = 1.5,
			ogryn = 0.8333333333333334,
		},
		smash_anims = {
			human = "attack_smash_human",
			ogryn = "attack_smash_ogryn",
		},
		smash_anim_duration = {
			human = 1.8333333333333333,
			ogryn = 1.6666666666666667,
		},
		smash_damage_timings = {
			human = {
				0.3,
				0.7333333333333333,
				1.4,
			},
			ogryn = {
				0.16666666666666666,
				0.5666666666666667,
				1.0666666666666667,
				1.4666666666666666,
			},
		},
		anim_data = {
			attack_throw_human = {
				rad = nil,
				sign = nil,
			},
			attack_throw_human_bwd = {
				sign = -1,
				rad = math.pi,
			},
			attack_throw_human_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			attack_throw_human_right = {
				sign = -1,
				rad = math.pi / 2,
			},
			attack_throw_ogryn = {
				rad = nil,
				sign = nil,
			},
			attack_throw_ogryn_bwd = {
				sign = 1,
				rad = math.pi,
			},
			attack_throw_ogryn_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			attack_throw_ogryn_right = {
				sign = -1,
				rad = math.pi / 2,
			},
			change_target_bwd = {
				sign = -1,
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
		anim_move_speed_durations = {
			change_target_fwd = 1.3,
		},
		anim_driven_charge_anim_durations = {
			change_target_bwd = 1.7333333333333334,
			change_target_left = 1.4,
			change_target_right = 1.4,
		},
		start_rotation_timings = {
			change_target_bwd = 0.6666666666666666,
			change_target_left = 0.3333333333333333,
			change_target_right = 0.4666666666666667,
		},
		throw_anims = {
			human = {
				bwd = "attack_throw_human_bwd",
				fwd = "attack_throw_human",
				left = "attack_throw_human_left",
				right = "attack_throw_human_right",
			},
			ogryn = {
				bwd = "attack_throw_ogryn_bwd",
				fwd = "attack_throw_ogryn",
				left = "attack_throw_ogryn_left",
				right = "attack_throw_ogryn_right",
			},
		},
		throw_timing = {
			human = 0.7333333333333333,
			ogryn = 1.3,
		},
		throw_duration = {
			human = 1.5666666666666667,
			ogryn = 2.3333333333333335,
		},
		catapult_force = {
			human = 13,
			ogryn = 10,
		},
		catapult_z_force = {
			human = 3,
			ogryn = 4,
		},
		disallowed_hit_zones_for_gibbing = {
			"lower_left_arm",
			"upper_left_arm",
			"torso",
			"center_mass",
		},
		power_level = {
			150,
			250,
			300,
			350,
			400,
		},
		grab_power_level = {
			5,
			7,
			10,
			12,
			15,
		},
		damage_profile = DamageProfileTemplates.cultist_mutant_smash,
		damage_type = {
			human = damage_types.minion_mutant_smash,
			ogryn = damage_types.minion_mutant_smash_ogryn,
		},
		push_minions_damage_profile = DamageProfileTemplates.cultist_mutant_minion_charge_push,
		push_minions_ignored_breeds = {
			chaos_poxwalker_bomber = true,
		},
		attack_intensities = {
			elite_ranged = 20,
			melee = 20,
			moving_melee = 20,
			ranged = 20,
			ranged_close = 20,
			running_melee = 20,
		},
		start_colliding_with_players_timing = {
			change_target_bwd = 1.6666666666666667,
			change_target_fwd = 1.3333333333333333,
			change_target_left = 1.3333333333333333,
			change_target_right = 1.3333333333333333,
			charge_fwd = 0.3333333333333333,
		},
		effect_template = EffectTemplates.cultist_mutant_charge_foley,
		start_effect_timing = {
			change_target_bwd = 1.6666666666666667,
			change_target_fwd = 1.3333333333333333,
			change_target_left = 1.3333333333333333,
			change_target_right = 1.3333333333333333,
			charge_fwd = 0.3333333333333333,
		},
		push_minions_fx_template = MinionPushFxTemplates.cultist_mutant_push,
		push_minions_fx_cooldown = {
			0.03,
			0.18,
		},
		aoe_bot_threat_size = Vector3Box(1.5, 2, 2),
	},
	climb = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_down_land = 0.7666666666666667,
			jump_up_1m = 0.5666666666666667,
			jump_up_3m = 1,
			jump_up_5m = 1.2666666666666666,
			jump_up_fence_1m = 0.43333333333333335,
			jump_up_fence_3m = 0.7083333333333334,
			jump_up_fence_5m = 0.9166666666666666,
		},
		land_timings = {
			jump_down_1m = 0.7666666666666667,
			jump_down_3m = 0.3333333333333333,
			jump_down_fence_1m = 0.3333333333333333,
			jump_down_fence_3m = 0.3333333333333333,
			jump_down_fence_5m = 0.3333333333333333,
		},
		ending_move_states = {
			jump_down_fence_1m = "moving",
			jump_down_fence_3m = "jumping",
			jump_down_fence_5m = "jumping",
			jump_down_land = "moving",
			jump_up_1m = "moving",
			jump_up_3m = "moving",
			jump_up_5m = "moving",
			jump_up_fence_1m = "jumping",
			jump_up_fence_3m = "jumping",
			jump_up_fence_5m = "jumping",
		},
		blend_timings = {
			jump_down_1m = 0.1,
			jump_down_3m = 0.1,
			jump_down_land = 0,
			jump_up_1m = 0.1,
			jump_up_3m = 0.1,
			jump_up_5m = 0.1,
			jump_up_fence_1m = 0.1,
			jump_up_fence_3m = 0.1,
			jump_up_fence_5m = 0.1,
		},
	},
	jump_across = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_over_gap_4m = 0.6333333333333333,
		},
		ending_move_states = {
			jump_over_gap_4m = "moving",
		},
	},
	stagger = {
		stagger_anims = {
			light = {
				fwd = {
					"stagger_medium_fwd_01",
				},
				bwd = {
					"stagger_medium_bwd_01",
				},
				left = {
					"stagger_medium_left_01",
				},
				right = {
					"stagger_medium_right_01",
				},
				dwn = {
					"stagger_medium_bwd_01",
				},
			},
			medium = {
				fwd = {
					"stagger_medium_fwd_01",
				},
				bwd = {
					"stagger_medium_bwd_01",
				},
				left = {
					"stagger_medium_left_01",
				},
				right = {
					"stagger_medium_right_01",
				},
				dwn = {
					"stagger_medium_bwd_01",
				},
			},
			heavy = {
				fwd = {
					"stagger_medium_fwd_01",
				},
				bwd = {
					"stagger_medium_bwd_01",
				},
				left = {
					"stagger_medium_left_01",
				},
				right = {
					"stagger_medium_right_01",
				},
				dwn = {
					"stagger_medium_bwd_01",
				},
			},
			light_ranged = {
				fwd = {
					"stagger_medium_fwd_01",
				},
				bwd = {
					"stagger_medium_bwd_01",
				},
				left = {
					"stagger_medium_left_01",
				},
				right = {
					"stagger_medium_right_01",
				},
				dwn = {
					"stagger_medium_bwd_01",
				},
			},
			explosion = {
				fwd = {
					"stagger_expl_fwd_01",
				},
				bwd = {
					"stagger_expl_bwd_01",
				},
				left = {
					"stagger_expl_left_01",
				},
				right = {
					"stagger_expl_right_01",
				},
				dwn = {
					"stagger_expl_bwd_01",
				},
			},
			killshot = {
				fwd = {
					"stagger_medium_fwd_01",
				},
				bwd = {
					"stagger_medium_bwd_01",
				},
				left = {
					"stagger_medium_left_01",
				},
				right = {
					"stagger_medium_right_01",
				},
				dwn = {
					"stagger_medium_bwd_01",
				},
			},
			sticky = {
				fwd = {
					"stagger_medium_fwd_01",
				},
				bwd = {
					"stagger_medium_bwd_01",
				},
				left = {
					"stagger_medium_left_01",
				},
				right = {
					"stagger_medium_right_01",
				},
				dwn = {
					"stagger_medium_bwd_01",
				},
			},
			electrocuted = {
				fwd = {
					"stagger_medium_fwd_01",
				},
				bwd = {
					"stagger_medium_bwd_01",
				},
				left = {
					"stagger_medium_left_01",
				},
				right = {
					"stagger_medium_right_01",
				},
				dwn = {
					"stagger_medium_bwd_01",
				},
			},
			wall_collision = {
				fwd = {
					"stagger_hit_wall",
				},
				bwd = {
					"stagger_hit_wall",
				},
				left = {
					"stagger_hit_wall",
				},
				right = {
					"stagger_hit_wall",
				},
				dwn = {
					"stagger_hit_wall",
				},
			},
			blinding = {
				fwd = {
					"stagger_medium_fwd_01",
				},
				bwd = {
					"stagger_medium_bwd_01",
				},
				left = {
					"stagger_medium_left_01",
				},
				right = {
					"stagger_medium_right_01",
				},
				dwn = {
					"stagger_medium_bwd_01",
				},
			},
		},
	},
	open_door = {
		open_door_time_offset = 2,
		rotation_duration = 0.1,
		stagger_immune = true,
	},
	exit_spawner = {
		run_anim_event = "charge_start_fwd",
	},
}

return action_data
