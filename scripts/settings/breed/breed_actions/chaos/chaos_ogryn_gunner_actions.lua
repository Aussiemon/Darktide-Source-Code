-- chunkname: @scripts/settings/breed/breed_actions/chaos/chaos_ogryn_gunner_actions.lua

local BreedShootTemplates = require("scripts/settings/breed/breed_shoot_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local shooting_difficulty_settings = MinionDifficultySettings.shooting.chaos_ogryn_gunner
local action_data = {
	name = "chaos_ogryn_gunner",
	idle = {
		anim_events = "idle"
	},
	patrol = {
		anim_events = {
			"move_fwd"
		},
		speeds = {
			move_fwd = 2
		}
	},
	death = {
		instant_ragdoll_chance = 0.5,
		death_animations = {
			[hit_zone_names.head] = {
				"death_shot_head_left",
				"death_decapitate"
			},
			[hit_zone_names.torso] = {
				"death_strike_chest_front",
				"death_strike_chest_back",
				"death_burn"
			},
			[hit_zone_names.upper_left_arm] = {
				"death_arm_left"
			},
			[hit_zone_names.lower_left_arm] = {
				"death_arm_left"
			},
			[hit_zone_names.upper_right_arm] = {
				"death_arm_right"
			},
			[hit_zone_names.lower_right_arm] = {
				"death_arm_right"
			},
			[hit_zone_names.upper_left_leg] = {
				"death_leg_left"
			},
			[hit_zone_names.lower_left_leg] = {
				"death_leg_left"
			},
			[hit_zone_names.upper_right_leg] = {
				"death_leg_right"
			},
			[hit_zone_names.lower_right_leg] = {
				"death_leg_right"
			}
		},
		ragdoll_timings = {
			death_leg_left = 0.8333333333333334,
			death_leg_right = 0.6666666666666666,
			death_strike_chest_front = 1.6666666666666667,
			death_decapitate = 2.1333333333333333,
			death_strike_chest_back = 2.7666666666666666,
			death_burn = 6.333333333333333,
			death_shot_head_left = 3.066666666666667,
			death_arm_left = 6,
			death_arm_right = 3.8666666666666667
		}
	},
	melee_combat_idle = {
		utility_weight = 2,
		anim_events = "idle",
		rotate_towards_target = true,
		considerations = UtilityConsiderations.melee_combat_idle
	},
	alerted = {
		alerted_duration = 0.75,
		alerted_anim_events = {
			"alerted"
		}
	},
	suppressed = {
		anim_events = {
			"suppressed_loop_01",
			"suppressed_loop_02"
		},
		durations = {
			suppressed_loop_01 = {
				0.3,
				5
			},
			suppressed_loop_02 = {
				0.3,
				5
			}
		},
		out_of_suppression_anim_event = {
			suppressed_loop_01 = "out_of_suppressed_01",
			suppressed_loop_02 = "out_of_suppressed_02"
		}
	},
	melee_attack = {
		weapon_reach = 4,
		utility_weight = 1,
		considerations = UtilityConsiderations.chaos_ogryn_gunner_melee,
		attack_anim_events = {
			"attack_push_kick_01",
			"attack_push_punch_01"
		},
		attack_anim_damage_timings = {
			attack_push_punch_01 = 0.5679012345679012,
			attack_push_kick_01 = 0.7654320987654321
		},
		attack_anim_durations = {
			attack_push_punch_01 = 1.9753086419753085,
			attack_push_kick_01 = 2.4691358024691357
		},
		attack_intensities = {
			ranged = 2,
			melee = 0.5
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_gunner_melee,
		damage_type = damage_types.minion_ogryn_kick
	},
	melee_attack_push = {
		weapon_reach = 4,
		utility_weight = 1,
		considerations = UtilityConsiderations.chaos_ogryn_gunner_melee,
		attack_anim_events = {
			"attack_push_01"
		},
		attack_anim_damage_timings = {
			attack_push_01 = 0.691358024691358
		},
		attack_anim_durations = {
			attack_push_01 = 1.728395061728395
		},
		attack_intensities = {
			ranged = 2,
			melee = 0.5
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_gunner_melee,
		damage_type = damage_types.minion_melee_blunt
	},
	climb = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_up_3m = 2.923076923076923,
			jump_up_fence_5m = 1.3,
			jump_down_land = 1.3333333333333333,
			jump_up_1m_2 = 1.2424242424242424,
			jump_up_fence_1m = 0.6,
			jump_up_fence_3m = 1.4,
			jump_up_5m = 4.166666666666667,
			jump_up_3m_2 = 2.923076923076923,
			jump_up_fence_2m = 0.6,
			jump_up_2m = 1.2424242424242424,
			jump_up_1m = 1.2424242424242424
		},
		land_timings = {
			jump_down_1m_2 = 0.2,
			jump_down_fence_3m = 0.3333333333333333,
			jump_down_3m = 0.3333333333333333,
			jump_down_fence_5m = 0.3333333333333333,
			jump_down_1m = 0.2,
			jump_down_3m_2 = 0.3333333333333333,
			jump_down_fence_1m = 0.26666666666666666
		},
		ending_move_states = {
			jump_up_3m = "jumping",
			jump_up_3m_2 = "jumping",
			jump_up_5m = "jumping",
			jump_up_1m_2 = "jumping",
			jump_down_land = "jumping",
			jump_up_2m = "jumping",
			jump_up_1m = "jumping"
		},
		blend_timings = {
			jump_up_3m = 0.1,
			jump_up_fence_5m = 0.2,
			jump_down_land = 0,
			jump_up_1m_2 = 0.1,
			jump_down_3m = 0.1,
			jump_down_3m_2 = 0.1,
			jump_down_1m = 0.1,
			jump_up_fence_1m = 0.2,
			jump_down_1m_2 = 0.1,
			jump_up_fence_3m = 0.2,
			jump_up_5m = 0.1,
			jump_up_3m_2 = 0.1,
			jump_up_fence_2m = 0.2,
			jump_up_2m = 0.1,
			jump_up_1m = 0.1
		}
	},
	disable = {
		disable_anims = {
			pounced = {
				fwd = {
					"dog_leap_pinned"
				},
				bwd = {
					"dog_leap_pinned"
				},
				left = {
					"dog_leap_pinned"
				},
				right = {
					"dog_leap_pinned"
				}
			}
		},
		stand_anim = {
			duration = 4,
			name = "dog_leap_pinned_stand"
		}
	},
	jump_across = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_over_gap_4m_2 = 1.1333333333333333,
			jump_over_gap_4m = 1.1666666666666667
		},
		ending_move_states = {
			jump_over_gap_4m_2 = "jumping",
			jump_over_gap_4m = "jumping"
		}
	},
	move_to_combat_vector = {
		max_distance_to_target = 18,
		move_anim_event = "move_fwd",
		utility_weight = 2,
		idle_anim_events = "idle",
		speed = 4.2,
		degree_per_direction = 10,
		range = "far",
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 120,
		move_to_cooldown = 0.25,
		min_distance_to_target = 10,
		considerations = UtilityConsiderations.move_to_combat_vector_special,
		start_move_anim_events = {
			bwd = "move_start_bwd",
			fwd = "move_start_fwd",
			left = "move_start_left",
			right = "move_start_right"
		},
		start_move_anim_data = {
			move_start_fwd = {},
			move_start_bwd = {
				sign = -1,
				rad = math.pi
			},
			move_start_left = {
				sign = 1,
				rad = math.pi / 2
			},
			move_start_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			move_start_right = 0,
			move_start_fwd = 0,
			move_start_bwd = 0,
			move_start_left = 0
		},
		start_rotation_durations = {
			move_start_right = 1.0333333333333334,
			move_start_fwd = 1,
			move_start_bwd = 1.2,
			move_start_left = 0.7
		},
		start_move_event_anim_speed_durations = {
			move_start_fwd = 2.3333333333333335
		}
	},
	ranged_follow = {
		max_distance_to_target = 10,
		min_distance_to_target = 4,
		utility_weight = 1,
		idle_anim_events = "idle",
		degree_per_direction = 10,
		line_of_sight_id = "gun",
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 210,
		move_anim_event = "move_fwd",
		speed = 4.2,
		move_to_cooldown = 0.25,
		considerations = UtilityConsiderations.ranged_follow,
		start_move_anim_events = {
			bwd = "move_start_bwd",
			fwd = "move_start_fwd",
			left = "move_start_left",
			right = "move_start_right"
		},
		start_move_anim_data = {
			move_start_fwd = {},
			move_start_bwd = {
				sign = -1,
				rad = math.pi
			},
			move_start_left = {
				sign = 1,
				rad = math.pi / 2
			},
			move_start_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			move_start_right = 0,
			move_start_fwd = 0,
			move_start_bwd = 0,
			move_start_left = 0
		},
		start_rotation_durations = {
			move_start_right = 1.0333333333333334,
			move_start_fwd = 1,
			move_start_bwd = 1.2,
			move_start_left = 0.7
		},
		start_move_event_anim_speed_durations = {
			move_start_fwd = 2.3333333333333335
		}
	},
	shoot = {
		can_strafe_shoot = true,
		randomized_direction_degree_range = 240,
		degree_per_direction = 10,
		move_to_cooldown = 0.1,
		strafe_end_anim_event = "hip_fire",
		out_of_aim_anim_event = "out_of_aim",
		not_allowed_cooldown = 0.5,
		move_to_fail_cooldown = 0.2,
		attack_intensity_type = "elite_ranged",
		reposition_if_not_clear_shot = true,
		inventory_slot = "slot_ranged_weapon",
		max_distance_to_target = 12,
		utility_weight = 15,
		vo_event = "start_shooting",
		strafe_shoot_distance = 3,
		min_clear_shot_combat_vector_distance = 8,
		exit_after_cooldown = false,
		strafe_shoot_ranged_position_fallback = true,
		skip_attack_intensity_during_aim = true,
		suppressive_fire = true,
		rotation_speed = 2,
		clear_shot_line_of_sight_id = "gun",
		min_distance_to_target = 3,
		fx_source_name = "muzzle",
		considerations = UtilityConsiderations.chaos_ogryn_gunner_shoot,
		aim_anim_events = {
			"aim_standing"
		},
		aim_duration = {
			aim_standing = shooting_difficulty_settings.aim_durations,
			aim_standing_bwd = shooting_difficulty_settings.aim_durations,
			aim_standing_left = shooting_difficulty_settings.aim_durations,
			aim_standing_right = shooting_difficulty_settings.aim_durations
		},
		aim_rotation_anims = {
			fwd = "hip_fire",
			left = "aim_turn_left",
			right = "aim_turn_right"
		},
		shoot_turn_anims = {
			bwd = "aim_standing_bwd",
			left = "aim_standing_left",
			right = "aim_standing_right"
		},
		start_move_anim_data = {
			aim_standing_bwd = {
				sign = -1,
				rad = math.pi
			},
			aim_standing_left = {
				sign = 1,
				rad = math.pi / 2
			},
			aim_standing_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			aim_standing_left = 0,
			aim_standing_bwd = 0,
			aim_standing_right = 0
		},
		start_rotation_durations = {
			aim_standing_left = 1.4,
			aim_standing_bwd = 1.4,
			aim_standing_right = 1.3333333333333333
		},
		cooldown_anim_events = {
			"gun_jam_start"
		},
		attack_intensities = {
			ranged = 12,
			elite_ranged = 8
		},
		shoot_cooldown = shooting_difficulty_settings.shoot_cooldown,
		num_shots = shooting_difficulty_settings.num_shots,
		time_per_shot = shooting_difficulty_settings.time_per_shot,
		shoot_template = BreedShootTemplates.chaos_ogryn_gunner,
		stagger_type_reduction = {
			ranged = 50,
			melee = 10,
			killshot = 50
		},
		strafe_anim_events = {
			bwd = "move_bwd_walk_aim",
			fwd = "move_fwd_walk_aim",
			left = "move_left_walk_aim",
			right = "move_right_walk_aim"
		},
		strafe_speeds = {
			move_left_walk_aim = 1.68,
			move_fwd_walk_aim = 2.4,
			move_bwd_walk_aim = 1.32,
			move_right_walk_aim = 1.92
		}
	},
	blocked = {
		blocked_duration = 1,
		blocked_anims = {
			"blocked"
		}
	},
	stagger = {
		stagger_duration_mods = {
			stagger_right_heavy = 0.5,
			stagger_fwd_heavy = 0.5
		},
		stagger_anims = {
			light = {
				fwd = {
					"stagger_fwd_light"
				},
				bwd = {
					"stagger_bwd_light"
				},
				left = {
					"stagger_left_light"
				},
				right = {
					"stagger_right_light"
				},
				dwn = {
					"stun_down"
				}
			},
			medium = {
				fwd = {
					"stagger_fwd"
				},
				bwd = {
					"stagger_bwd"
				},
				left = {
					"stagger_left"
				},
				right = {
					"stagger_right"
				},
				dwn = {
					"stagger_medium_downward"
				}
			},
			heavy = {
				fwd = {
					"stagger_fwd_heavy"
				},
				bwd = {
					"stagger_bwd_heavy"
				},
				left = {
					"stagger_left_heavy"
				},
				right = {
					"stagger_right_heavy"
				},
				dwn = {
					"stagger_dwn_heavy"
				}
			},
			light_ranged = {
				fwd = {
					"stagger_fwd_light"
				},
				bwd = {
					"stagger_bwd_light"
				},
				left = {
					"stagger_left_light"
				},
				right = {
					"stagger_right_light"
				}
			},
			explosion = {
				fwd = {
					"stagger_explosion_front"
				},
				bwd = {
					"stagger_explosion_back"
				},
				left = {
					"stagger_explosion_left"
				},
				right = {
					"stagger_explosion_right"
				}
			},
			killshot = {
				fwd = {
					"stagger_fwd_light"
				},
				bwd = {
					"stagger_bwd_light"
				},
				left = {
					"stagger_left_light"
				},
				right = {
					"stagger_right_light"
				}
			},
			sticky = {
				bwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3"
				},
				fwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3"
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3"
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3"
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3"
				}
			},
			electrocuted = {
				bwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3"
				},
				fwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3"
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3"
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3"
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3"
				}
			},
			blinding = {
				fwd = {
					"stagger_fwd_light"
				},
				bwd = {
					"stagger_bwd_light"
				},
				left = {
					"stagger_left_light"
				},
				right = {
					"stagger_right_light"
				},
				dwn = {
					"stun_down"
				}
			}
		}
	},
	open_door = {
		rotation_duration = 0.1,
		stagger_immune = true
	},
	exit_spawner = {
		run_anim_event = "move_fwd"
	}
}

return action_data
