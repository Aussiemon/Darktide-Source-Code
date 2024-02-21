local BreedShootTemplates = require("scripts/settings/breed/breed_shoot_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local shooting_difficulty_settings = MinionDifficultySettings.shooting.renegade_gunner
local action_data = {
	name = "renegade_gunner",
	idle = {
		anim_events = "idle"
	},
	patrol = {
		anim_events = {
			"move_fwd_1"
		},
		speeds = {
			move_fwd_1 = 0.97
		}
	},
	death = {
		instant_ragdoll_chance = 0.5,
		death_animations = {
			[hit_zone_names.head] = {
				"death_shot_head_front",
				"death_shot_head_fwd",
				"death_shot_head_left",
				"death_shot_head_right",
				"death_shot_head_bwd",
				"death_decapitate_3"
			},
			[hit_zone_names.torso] = {
				"death_stab_chest_front",
				"death_stab_chest_back",
				"death_slash_left",
				"death_slash_right",
				"death_strike_chest_front",
				"death_strike_chest_back",
				"death_strike_chest_left",
				"death_strike_chest_right"
			},
			[hit_zone_names.upper_left_arm] = {
				"death_arm_left",
				"death_arm_left_2",
				"death_arm_left_3"
			},
			[hit_zone_names.lower_left_arm] = {
				"death_arm_left",
				"death_arm_left_2",
				"death_arm_left_3"
			},
			[hit_zone_names.upper_right_arm] = {
				"death_arm_right",
				"death_arm_right_2",
				"death_arm_right_3"
			},
			[hit_zone_names.lower_right_arm] = {
				"death_arm_right",
				"death_arm_right_2",
				"death_arm_right_3"
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
			death_shot_head_right = 4.566666666666666,
			death_slash_left = 3.2666666666666666,
			death_strike_chest_back = 3.1666666666666665,
			death_strike_chest_right = 1.2666666666666666,
			death_decapitate_3 = 1.4,
			death_strike_chest_left = 3.2,
			death_leg_right = 4.5,
			death_slash_right = 2.6666666666666665,
			death_arm_left = 3.033333333333333,
			death_arm_left_3 = 3.9,
			death_arm_left_2 = 4,
			death_strike_chest_front = 1.6666666666666667,
			death_arm_right_3 = 2.566666666666667,
			death_stab_chest_front = 3.6333333333333333,
			death_leg_left = 3.066666666666667,
			death_stab_chest_back = 2.5,
			death_arm_right_2 = 4.233333333333333,
			death_shot_head_bwd = 3.3333333333333335,
			death_shot_head_left = 2.1,
			death_shot_head_front = 1.4666666666666666,
			death_shot_head_fwd = 2.3666666666666667,
			death_arm_right = 5.1
		}
	},
	alerted = {
		hesitate_chance = 0.25,
		override_aggro_distance = 8,
		instant_aggro_chance = 0,
		hesitate_anim_events = {
			"alerted",
			"hesitate_1"
		},
		directional_alerted_anim_events = {
			fwd = {
				"alerted_fwd"
			},
			bwd = {
				"alerted_bwd"
			},
			left = {
				"alerted_left"
			},
			right = {
				"alerted_right"
			}
		},
		start_move_anim_data = {
			alerted_bwd = {
				sign = -1,
				rad = math.pi
			},
			alerted_fwd = {},
			alerted_left = {
				sign = 1,
				rad = math.pi / 2
			},
			alerted_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			alerted_bwd = 0,
			alerted_right = 0,
			alerted_left = 0
		},
		start_rotation_durations = {
			alerted_bwd = 1.0333333333333334,
			alerted_right = 0.9666666666666667,
			alerted_left = 1
		},
		alerted_durations = {
			alerted_bwd = 3.3,
			alerted_left = 3,
			alerted_right = 3.433333333333333,
			alerted_fwd = 2.1,
			alerted = {
				1,
				1.5
			},
			hesitate_1 = {
				1,
				1.5
			}
		}
	},
	suppressed = {
		chance_of_jump_animation = 0.5,
		anim_events = {
			"suppressed_loop_01",
			"suppressed_loop_02",
			"suppressed_loop_03",
			"suppressed_loop_knee_01",
			"suppressed_loop_knee_02"
		},
		durations = {
			suppressed_loop_01 = {
				0.5,
				0.75
			},
			suppressed_loop_02 = {
				0.5,
				0.75
			},
			suppressed_loop_03 = {
				0.5,
				0.75
			},
			suppressed_loop_knee_01 = {
				0.5,
				0.75
			},
			suppressed_loop_knee_02 = {
				0.5,
				0.75
			}
		},
		jump_anim_events = {
			fwd = {
				"suppressed_jump_fwd_01",
				"suppressed_jump_fwd_02"
			},
			right = {
				"suppressed_jump_right_01",
				"suppressed_jump_right_02"
			},
			bwd = {
				"suppressed_jump_bwd_01",
				"suppressed_jump_bwd_02",
				"suppressed_jump_bwd_03"
			},
			left = {
				"suppressed_jump_left_01",
				"suppressed_jump_left_02"
			}
		},
		jump_durations = {
			suppressed_jump_bwd_02 = 1.8933333333333333,
			suppressed_jump_bwd_03 = 2,
			suppressed_jump_right_01 = 1.0666666666666667,
			suppressed_jump_fwd_01 = 1.1466666666666667,
			suppressed_jump_right_02 = 0.8533333333333334,
			suppressed_jump_left_01 = 0.88,
			suppressed_jump_fwd_02 = 1.2266666666666666,
			suppressed_jump_left_02 = 1.2,
			suppressed_jump_bwd_01 = 1.0666666666666667
		}
	},
	climb = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_up_3m = 2.923076923076923,
			jump_up_3m_2 = 3.051282051282051,
			jump_down_land = 1.3333333333333333,
			jump_up_1m_2 = 1.0303030303030303,
			jump_up_fence_1m = 0.6,
			jump_up_fence_3m = 1.4,
			jump_up_5m = 4.166666666666667,
			jump_up_fence_5m = 1.3,
			jump_up_1m = 1.2424242424242424
		},
		land_timings = {
			jump_down_1m_2 = 0.16666666666666666,
			jump_down_fence_3m = 0.3333333333333333,
			jump_down_3m = 0.3333333333333333,
			jump_down_fence_5m = 0.3333333333333333,
			jump_down_1m = 0.2,
			jump_down_3m_2 = 0.5,
			jump_down_fence_1m = 0.26666666666666666
		},
		ending_move_states = {
			jump_up_3m = "jumping",
			jump_up_3m_2 = "jumping",
			jump_up_5m = "jumping",
			jump_up_1m_2 = "jumping",
			jump_down_land = "jumping",
			jump_up_1m = "jumping"
		},
		blend_timings = {
			jump_up_3m = 0.1,
			jump_up_3m_2 = 0.1,
			jump_down_land = 0,
			jump_up_1m_2 = 0.1,
			jump_down_3m = 0.1,
			jump_down_3m_2 = 0.1,
			jump_down_1m_2 = 0.1,
			jump_up_fence_1m = 0.2,
			jump_up_fence_3m = 0.2,
			jump_up_5m = 0.1,
			jump_up_fence_5m = 0.2,
			jump_down_1m = 0.1,
			jump_up_1m = 0.1
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
		idle_anim_events = "idle",
		min_distance_to_target = 15,
		utility_weight = 1,
		max_distance_to_target = 30,
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 120,
		degree_per_direction = 10,
		move_anim_events = "move_fwd",
		move_to_cooldown = 0.25,
		speed = 4.2,
		considerations = UtilityConsiderations.move_to_combat_vector,
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
			move_start_right = 0.26666666666666666,
			move_start_fwd = 0.26666666666666666,
			move_start_bwd = 0.26666666666666666,
			move_start_left = 0.26666666666666666
		}
	},
	escape_to_combat_vector = {
		idle_anim_events = "idle",
		min_distance_to_target = 15,
		utility_weight = 1,
		max_distance_to_target = 30,
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 120,
		degree_per_direction = 10,
		move_anim_events = "move_fwd",
		move_to_cooldown = 0.25,
		speed = 4.2,
		considerations = UtilityConsiderations.escape_to_combat_vector,
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
			move_start_right = 0.26666666666666666,
			move_start_fwd = 0.26666666666666666,
			move_start_bwd = 0.26666666666666666,
			move_start_left = 0.26666666666666666
		}
	},
	move_to_cover = {
		move_type_switch_stickiness = 2,
		anim_driven_min_distance = 3,
		sprint_anim_event = "assault_fwd",
		idle_anim_events = {
			"idle",
			"idle_2",
			"idle_3"
		},
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
			move_start_right = 0.26666666666666666,
			move_start_fwd = 0.26666666666666666,
			move_start_bwd = 0.26666666666666666,
			move_start_left = 0.26666666666666666
		},
		speeds = {
			jogging = 4.2,
			sprinting = 5.6
		}
	},
	shoot_spray_n_pray = {
		utility_weight = 10,
		vo_event = "start_shooting",
		suppressive_fire_spread_multiplier = 4,
		rotation_speed = 2,
		out_of_aim_anim_event = "out_of_aim",
		suppressive_fire = true,
		attack_intensity_type = "elite_ranged",
		clear_shot_line_of_sight_id = "gun",
		inventory_slot = "slot_ranged_weapon",
		fx_source_name = "muzzle",
		considerations = UtilityConsiderations.shoot_spray_n_pray,
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
		cooldown_anim_events = {
			"out_of_aim"
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
			aim_standing_left = 0.8333333333333334,
			aim_standing_bwd = 1,
			aim_standing_right = 0.8333333333333334
		},
		shoot_cooldown = shooting_difficulty_settings.shoot_cooldown,
		num_shots = shooting_difficulty_settings.num_shots,
		time_per_shot = shooting_difficulty_settings.time_per_shot,
		attack_intensities = {
			ranged = 2,
			elite_ranged = 10
		},
		shoot_template = BreedShootTemplates.renegade_gunner_shoot_spray_n_pray,
		stagger_type_reduction = {
			ranged = 60,
			killshot = 60
		}
	},
	in_cover = {
		peek_duration = 1.1666666666666667,
		suppressive_fire_spread_multiplier = 4,
		enter_cover_speed = 2,
		aim_duration = 1,
		exit_anim_event = "exit_cover",
		aim_anim_event = "aim",
		suppressive_fire = true,
		attack_intensity_type = "elite_ranged",
		suppressed_anim = "suppressed_loop",
		clear_shot_line_of_sight_id = "gun",
		inventory_slot = "slot_ranged_weapon",
		fx_source_name = "muzzle",
		enter_cover_anim_states = {
			high = "to_high_cover",
			low = "to_low_cover"
		},
		enter_cover_durations = {
			to_low_cover = 1.6666666666666667,
			to_high_cover = 1.6666666666666667
		},
		peek_anim_events = {
			up = "peek_up",
			left = "peek_left",
			right = "peek_right"
		},
		start_aiming_at_target_timings = {
			aim = 0.5
		},
		num_shots = shooting_difficulty_settings.num_shots_cover,
		time_per_shot = shooting_difficulty_settings.time_per_shot,
		attack_intensities = {
			ranged = 2,
			elite_ranged = 10
		},
		shoot_template = BreedShootTemplates.renegade_gunner_aimed,
		stagger_type_reduction = {
			ranged = 60,
			killshot = 60
		},
		clear_shot_offset_from_peeking = {
			high = {
				left = Vector3Box(-0.496811, -0.555117, 1.45703),
				right = Vector3Box(0.710413, -0.420349, 1.45625)
			},
			low = {
				left = Vector3Box(-0.765147, -0.43428, 0.888766),
				right = Vector3Box(0.716341, -0.391699, 0.919069),
				up = Vector3Box(0.00867844, -0.426697, 1.32044)
			}
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
			move_start_right = 0.26666666666666666,
			move_start_fwd = 0.26666666666666666,
			move_start_bwd = 0.26666666666666666,
			move_start_left = 0.26666666666666666
		},
		start_move_event_anim_speed_durations = {
			move_start_fwd = 2.3333333333333335
		}
	},
	melee_attack = {
		weapon_reach = 4,
		utility_weight = 1,
		considerations = UtilityConsiderations.ranged_elite_melee,
		attack_anim_events = {
			"attack_push_kick_01",
			"attack_pommel_01"
		},
		attack_anim_damage_timings = {
			attack_pommel_01 = 0.5185185185185185,
			attack_push_kick_01 = 0.7654320987654321
		},
		attack_anim_durations = {
			attack_pommel_01 = 1.728395061728395,
			attack_push_kick_01 = 2.4691358024691357
		},
		attack_intensities = {
			ranged = 2,
			melee = 0.5
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_gunner_melee,
		damage_type = damage_types.minion_melee_blunt
	},
	blocked = {
		blocked_duration = 2.6666666666666665,
		blocked_anims = {
			"blocked"
		}
	},
	stagger = {
		stagger_duration_mods = {
			stagger_explosion_front_2 = 0.8
		},
		stagger_anims = {
			light = {
				fwd = {
					"stagger_fwd_light",
					"stagger_fwd_light_2",
					"stagger_fwd_light_3",
					"stagger_fwd_light_4",
					"stagger_fwd_light_5",
					"stagger_fwd_light_6"
				},
				bwd = {
					"stagger_bwd_light",
					"stagger_bwd_light_2",
					"stagger_bwd_light_3",
					"stagger_bwd_light_4",
					"stagger_bwd_light_5",
					"stagger_bwd_light_6",
					"stagger_bwd_light_7",
					"stagger_bwd_light_8"
				},
				left = {
					"stagger_left_light",
					"stagger_left_light_2",
					"stagger_left_light_3",
					"stagger_left_light_4"
				},
				right = {
					"stagger_right_light",
					"stagger_right_light_2",
					"stagger_right_light_3",
					"stagger_right_light_4"
				},
				dwn = {
					"stun_down"
				}
			},
			medium = {
				fwd = {
					"stagger_fwd",
					"stagger_fwd_2",
					"stagger_fwd_3",
					"stagger_fwd_4"
				},
				bwd = {
					"stagger_bwd",
					"stagger_bwd_2",
					"stagger_bwd_3",
					"stagger_bwd_4"
				},
				left = {
					"stagger_left",
					"stagger_left_2",
					"stagger_left_3",
					"stagger_left_4",
					"stagger_left_5"
				},
				right = {
					"stagger_right",
					"stagger_right_2",
					"stagger_right_3",
					"stagger_right_4",
					"stagger_right_5"
				},
				dwn = {
					"stagger_medium_downward",
					"stagger_medium_downward_2",
					"stagger_medium_downward_3"
				}
			},
			heavy = {
				fwd = {
					"stagger_fwd_heavy",
					"stagger_fwd_heavy_2",
					"stagger_fwd_heavy_3",
					"stagger_fwd_heavy_4"
				},
				bwd = {
					"stagger_up_heavy",
					"stagger_up_heavy_2",
					"stagger_up_heavy_3",
					"stagger_bwd_heavy",
					"stagger_bwd_heavy_2",
					"stagger_bwd_heavy_3",
					"stagger_bwd_heavy_4"
				},
				left = {
					"stagger_left_heavy",
					"stagger_left_heavy_2",
					"stagger_left_heavy_3",
					"stagger_left_heavy_4"
				},
				right = {
					"stagger_right_heavy",
					"stagger_right_heavy_2",
					"stagger_right_heavy_3",
					"stagger_right_heavy_4"
				},
				dwn = {
					"stagger_dwn_heavy",
					"stagger_dwn_heavy_2",
					"stagger_dwn_heavy_3"
				}
			},
			light_ranged = {
				fwd = {
					"stun_fwd_ranged_light",
					"stun_fwd_ranged_light_2",
					"stun_fwd_ranged_light_3"
				},
				bwd = {
					"stun_bwd_ranged_light",
					"stun_bwd_ranged_light_2",
					"stun_bwd_ranged_light_3"
				},
				left = {
					"stun_left_ranged_light",
					"stun_left_ranged_light_2",
					"stun_left_ranged_light_3"
				},
				right = {
					"stun_right_ranged_light",
					"stun_right_ranged_light_2",
					"stun_right_ranged_light_3"
				}
			},
			explosion = {
				fwd = {
					"stagger_explosion_front",
					"stagger_explosion_front_2"
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
					"stagger_fwd_light",
					"stagger_fwd_light_2",
					"stagger_fwd_light_3",
					"stagger_fwd_light_4",
					"stagger_fwd_light_5",
					"stagger_fwd_light_6"
				},
				bwd = {
					"stagger_bwd_light",
					"stagger_bwd_light_2",
					"stagger_bwd_light_3",
					"stagger_bwd_light_4",
					"stagger_bwd_light_5",
					"stagger_bwd_light_6",
					"stagger_bwd_light_7",
					"stagger_bwd_light_8"
				},
				left = {
					"stagger_left_light",
					"stagger_left_light_2",
					"stagger_left_light_3",
					"stagger_left_light_4"
				},
				right = {
					"stagger_right_light",
					"stagger_right_light_2",
					"stagger_right_light_3",
					"stagger_right_light_4"
				},
				dwn = {
					"stun_down"
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
					"stagger_fwd_light",
					"stagger_fwd_light_2",
					"stagger_fwd_light_3",
					"stagger_fwd_light_4",
					"stagger_fwd_light_5",
					"stagger_fwd_light_6"
				},
				bwd = {
					"stagger_bwd_light",
					"stagger_bwd_light_2",
					"stagger_bwd_light_3",
					"stagger_bwd_light_4",
					"stagger_bwd_light_5",
					"stagger_bwd_light_6",
					"stagger_bwd_light_7",
					"stagger_bwd_light_8"
				},
				left = {
					"stagger_left_light",
					"stagger_left_light_2",
					"stagger_left_light_3",
					"stagger_left_light_4"
				},
				right = {
					"stagger_right_light",
					"stagger_right_light_2",
					"stagger_right_light_3",
					"stagger_right_light_4"
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
