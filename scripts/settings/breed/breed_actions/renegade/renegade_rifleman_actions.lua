local BreedShootTemplates = require("scripts/settings/breed/breed_shoot_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local shooting_difficulty_settings = MinionDifficultySettings.shooting.renegade_rifleman
local action_data = {
	name = "renegade_rifleman",
	idle = {
		vo_event = "passive_idle",
		rotate_towards_target = true,
		anim_events = {
			"idle",
			"idle_2",
			"idle_3"
		}
	},
	patrol = {
		idle_anim_events = {
			"idle",
			"idle_2"
		},
		anim_events = {
			"move_fwd_1",
			"move_fwd_2",
			"move_fwd_3",
			"move_fwd_4",
			"move_fwd_5",
			"move_fwd_6",
			"move_fwd_7"
		},
		speeds = {
			move_fwd_4 = 0.78,
			move_fwd_7 = 0.97,
			move_fwd_3 = 0.87,
			move_fwd_6 = 1,
			move_fwd_2 = 0.91,
			move_fwd_5 = 0.73,
			move_fwd_1 = 0.89
		}
	},
	death = {
		instant_ragdoll_chance = 0,
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
			death_decapitate_3 = 1.4,
			death_strike_chest_right = 1.2666666666666666,
			death_strike_chest_back = 3.1666666666666665,
			death_strike_chest_left = 3.2,
			death_leg_right = 4.5,
			death_slash_right = 2.6666666666666665,
			death_arm_left = 3.033333333333333,
			death_strike_chest_front = 1.6666666666666667,
			death_arm_left_2 = 4,
			death_arm_left_3 = 3.9,
			death_arm_right = 5.1,
			death_decapitate = 3.566666666666667,
			death_arm_right_3 = 2.566666666666667,
			death_stab_chest_front = 3.6333333333333333,
			death_leg_left = 3.066666666666667,
			death_stab_chest_back = 2.5,
			death_burn = 2.566666666666667,
			death_burn_2 = 2.566666666666667,
			death_arm_right_2 = 4.233333333333333,
			death_shot_head_bwd = 3.3333333333333335,
			death_shot_head_left = 2.1,
			death_burn_3 = 4.666666666666667,
			death_shot_head_front = 1.4666666666666666,
			death_burn_4 = 4.4,
			death_leg_both = 4.5,
			death_shot_head_fwd = 2.3666666666666667,
			death_decapitate_2 = 3.1666666666666665
		}
	},
	far_combat_idle = {
		utility_weight = 1,
		rotate_towards_target = true,
		vo_event = "ranged_idle",
		considerations = UtilityConsiderations.far_combat_idle,
		anim_events = {
			"idle",
			"idle_2",
			"idle_3"
		}
	},
	close_combat_idle = {
		utility_weight = 1,
		rotate_towards_target = true,
		considerations = UtilityConsiderations.close_combat_idle,
		anim_events = {
			"idle",
			"idle_2",
			"idle_3"
		}
	},
	melee_combat_idle = {
		utility_weight = 1,
		rotate_towards_target = true,
		vo_event = "melee_combat_idle",
		considerations = UtilityConsiderations.melee_combat_idle,
		anim_events = {
			"idle",
			"idle_2",
			"idle_3"
		}
	},
	alerted = {
		hesitate_chance = 0.1,
		override_aggro_distance = 8,
		alert_spread_max_distance_to_target = 30,
		vo_event = "alerted_idle",
		instant_aggro_chance = 0,
		alert_spread_radius = 8,
		alerted_anim_events = {
			"alerted",
			"alerted_2"
		},
		directional_alerted_anim_events = {
			fwd = {
				"alerted_fwd",
				"alerted_fwd_2",
				"alerted_fwd_3"
			},
			bwd = {
				"alerted_bwd",
				"alerted_bwd_2",
				"alerted_bwd_3"
			},
			left = {
				"alerted_left",
				"alerted_left_2",
				"alerted_left_3"
			},
			right = {
				"alerted_right",
				"alerted_right_2",
				"alerted_right_3"
			}
		},
		hesitate_anim_events = {
			"hesitate_1"
		},
		start_move_anim_data = {
			alerted_bwd = {
				sign = -1,
				rad = math.pi
			},
			alerted_bwd_2 = {
				sign = 1,
				rad = math.pi
			},
			alerted_bwd_3 = {
				sign = 1,
				rad = math.pi
			},
			alerted_fwd = {},
			alerted_fwd_2 = {},
			alerted_fwd_3 = {},
			alerted_left = {
				sign = 1,
				rad = math.pi / 2
			},
			alerted_left_2 = {
				sign = 1,
				rad = math.pi / 2
			},
			alerted_left_3 = {
				sign = 1,
				rad = math.pi / 2
			},
			alerted_right = {
				sign = -1,
				rad = math.pi / 2
			},
			alerted_right_2 = {
				sign = -1,
				rad = math.pi / 2
			},
			alerted_right_3 = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			alerted_right_3 = 0,
			alerted_bwd_2 = 0,
			alerted_right_2 = 0,
			alerted_right = 0,
			alerted_left = 0,
			alerted_bwd = 0,
			alerted_left_2 = 0,
			alerted_bwd_3 = 0,
			alerted_left_3 = 0
		},
		start_rotation_durations = {
			alerted_right_3 = 0.8,
			alerted_bwd_2 = 2.2333333333333334,
			alerted_right_2 = 3.466666666666667,
			alerted_right = 0.9666666666666667,
			alerted_left = 1,
			alerted_bwd = 1.0333333333333334,
			alerted_left_2 = 3.066666666666667,
			alerted_bwd_3 = 2.2666666666666666,
			alerted_left_3 = 0.6
		},
		alerted_durations = {
			alerted_bwd_3 = 2.2666666666666666,
			alerted_fwd_2 = 2.466666666666667,
			alerted_bwd_2 = 3.5,
			alerted_right_2 = 3.7,
			alerted_left_3 = 2.3333333333333335,
			alerted_right = 2.566666666666667,
			alerted_right_3 = 3.066666666666667,
			alerted_left = 1.2666666666666666,
			alerted_bwd = 1.2333333333333334,
			alerted_left_2 = 3.3666666666666667,
			alerted_fwd_3 = 2.6666666666666665,
			alerted_fwd = 1.6666666666666667,
			hesitate_1 = {
				6.666666666666667,
				7
			},
			alerted = {
				2,
				6.666666666666667
			},
			alerted_2 = {
				2.6666666666666665,
				6.666666666666667
			}
		}
	},
	suppressed = {
		chance_of_jump_animation = 1,
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
		degree_per_direction = 10,
		utility_weight = 3,
		move_to_cooldown = 0.25,
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 120,
		speed = 4.2,
		move_anim_events = "move_fwd",
		considerations = UtilityConsiderations.move_to_combat_vector,
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
		}
	},
	move_to_combat_vector_far = {
		degree_per_direction = 10,
		utility_weight = 3,
		move_to_cooldown = 0.25,
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 120,
		speed = 4.2,
		move_anim_events = "move_fwd",
		considerations = UtilityConsiderations.move_to_combat_vector_special,
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
		}
	},
	move_to_cover = {
		move_type_switch_stickiness = 2,
		anim_driven_min_distance = 3,
		sprint_anim_event = "assault_fwd",
		use_animation_running_stagger_speed = true,
		controlled_stagger = true,
		controlled_stagger_min_speed = 2,
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
		},
		running_stagger_anim_left = {
			"run_stagger_right",
			"shotgun_run_stagger_01",
			"shotgun_run_stagger_02",
			"shotgun_run_stagger_03",
			"shotgun_run_stagger_04"
		},
		running_stagger_anim_right = {
			"run_stagger_left",
			"shotgun_run_stagger_01",
			"shotgun_run_stagger_02",
			"shotgun_run_stagger_03",
			"shotgun_run_stagger_04"
		},
		running_stagger_duration = {
			shotgun_run_stagger_01 = 1.5333333333333334,
			shotgun_run_stagger_04 = 2,
			run_stagger_left = 1.8333333333333333,
			run_stagger_right = 1.7333333333333334,
			shotgun_run_stagger_03 = 1.7333333333333334,
			shotgun_run_stagger_02 = 1.6333333333333333
		},
		running_stagger_min_duration = {
			shotgun_run_stagger_04 = 1.6666666666666667
		}
	},
	shoot = {
		utility_weight = 30,
		inventory_slot = "slot_ranged_weapon",
		cover_crouch_check_replacement_anim_event = "aim_standing",
		cover_crouch_check = true,
		suppressive_fire = true,
		attack_intensity_type = "ranged",
		fx_source_name = "muzzle",
		considerations = UtilityConsiderations.shoot_far,
		aim_anim_events = {
			"aim_standing",
			"aim_crouching"
		},
		aim_duration = {
			aim_standing = shooting_difficulty_settings.aim_durations,
			aim_crouching = shooting_difficulty_settings.aim_durations,
			turn_shoot_bwd = shooting_difficulty_settings.aim_durations,
			turn_shoot_left = shooting_difficulty_settings.aim_durations,
			turn_shoot_right = shooting_difficulty_settings.aim_durations
		},
		shoot_turn_anims = {
			bwd = "turn_shoot_bwd",
			left = "turn_shoot_left",
			right = "turn_shoot_right"
		},
		start_move_anim_data = {
			turn_shoot_bwd = {
				sign = -1,
				rad = math.pi
			},
			turn_shoot_left = {
				sign = 1,
				rad = math.pi / 2
			},
			turn_shoot_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			turn_shoot_right = 0,
			turn_shoot_bwd = 0,
			turn_shoot_left = 0
		},
		start_rotation_durations = {
			turn_shoot_right = 0.6410256410256411,
			turn_shoot_bwd = 0.5714285714285714,
			turn_shoot_left = 0.6410256410256411
		},
		aim_stances = {
			aim_standing = "standing",
			aim_crouching = "crouching"
		},
		attack_intensities = {
			ranged = 1.5
		},
		idle_anim_events = {
			"idle",
			"idle_2",
			"idle_3"
		},
		dodge_window = shooting_difficulty_settings.shoot_dodge_window,
		shoot_cooldown = shooting_difficulty_settings.shoot_cooldown,
		num_shots = shooting_difficulty_settings.num_shots,
		time_per_shot = shooting_difficulty_settings.time_per_shot,
		shoot_template = BreedShootTemplates.renegade_rifleman_default
	},
	has_cover = {
		utility_weight = 3,
		considerations = UtilityConsiderations.has_cover
	},
	move_to_cover_shoot = {
		utility_weight = 10,
		inventory_slot = "slot_ranged_weapon",
		cover_crouch_check_replacement_anim_event = "aim_standing",
		cover_crouch_check = true,
		suppressive_fire = true,
		attack_intensity_type = "ranged",
		fx_source_name = "muzzle",
		considerations = UtilityConsiderations.move_to_cover_shoot,
		aim_anim_events = {
			"aim_standing",
			"aim_crouching"
		},
		aim_duration = {
			aim_standing = shooting_difficulty_settings.aim_durations,
			aim_crouching = shooting_difficulty_settings.aim_durations,
			turn_shoot_bwd = shooting_difficulty_settings.aim_durations,
			turn_shoot_left = shooting_difficulty_settings.aim_durations,
			turn_shoot_right = shooting_difficulty_settings.aim_durations
		},
		shoot_turn_anims = {
			bwd = "turn_shoot_bwd",
			left = "turn_shoot_left",
			right = "turn_shoot_right"
		},
		start_move_anim_data = {
			turn_shoot_bwd = {
				sign = -1,
				rad = math.pi
			},
			turn_shoot_left = {
				sign = 1,
				rad = math.pi / 2
			},
			turn_shoot_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			turn_shoot_right = 0,
			turn_shoot_bwd = 0,
			turn_shoot_left = 0
		},
		start_rotation_durations = {
			turn_shoot_right = 0.6410256410256411,
			turn_shoot_bwd = 0.5714285714285714,
			turn_shoot_left = 0.6410256410256411
		},
		aim_stances = {
			aim_standing = "standing",
			aim_crouching = "crouching"
		},
		attack_intensities = {
			ranged = 1.5
		},
		idle_anim_events = {
			"idle",
			"idle_2",
			"idle_3"
		},
		dodge_window = shooting_difficulty_settings.shoot_dodge_window,
		shoot_cooldown = shooting_difficulty_settings.shoot_cooldown,
		num_shots = shooting_difficulty_settings.num_shots,
		time_per_shot = shooting_difficulty_settings.time_per_shot,
		shoot_template = BreedShootTemplates.renegade_rifleman_default
	},
	in_cover = {
		enter_cover_speed = 2,
		peek_duration = 0.6666666666666666,
		exit_anim_event = "exit_cover",
		aim_anim_event = "aim",
		suppressive_fire = true,
		attack_intensity_type = "ranged",
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
		aim_duration = {
			0.6666666666666666,
			0.9166666666666666
		},
		start_aiming_at_target_timings = {
			aim = 0.4
		},
		cover_aim_stances = {
			high = "standing",
			low = "crouching"
		},
		attack_intensities = {
			ranged = 2
		},
		dodge_window = shooting_difficulty_settings.shoot_dodge_window,
		num_shots = shooting_difficulty_settings.num_shots_cover,
		time_per_shot = shooting_difficulty_settings.time_per_shot,
		shoot_template = BreedShootTemplates.renegade_rifleman_default,
		clear_shot_offset_from_peeking = {
			high = {
				left = Vector3Box(-0.613639, -0.611683, 1.4754),
				right = Vector3Box(0.641053, -0.445854, 1.46142)
			},
			low = {
				left = Vector3Box(-0.770176, -0.433462, 0.893286),
				right = Vector3Box(0.675663, -0.477724, 0.9158),
				up = Vector3Box(0.00311852, -0.440826, 1.38431)
			}
		}
	},
	melee_follow = {
		enter_walk_distance = 3,
		leave_walk_distance = 5,
		utility_weight = 1,
		vo_event = "ranged_idle",
		run_anim_event = "bayonet_charge_start",
		force_move_anim_event = "bayonet_charge_start",
		walk_anim_event = "move_fwd_walk",
		considerations = UtilityConsiderations.melee_follow,
		idle_anim_events = {
			"idle",
			"idle_2",
			"idle_3"
		},
		start_move_anim_events = {
			walking = {
				bwd = "move_bwd_walk",
				fwd = "move_fwd_walk",
				left = "move_left_walk",
				right = "move_right_walk"
			}
		},
		start_move_event_anim_speed_durations = {
			bayonet_charge_start = 1.2666666666666666
		}
	},
	melee_attack = {
		weapon_reach = 3,
		utility_weight = 1,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			"bayonet_attack_stab",
			"bayonet_attack_stab_02",
			"bayonet_attack_sweep",
			"bayonet_attack_sweep_02"
		},
		attack_anim_damage_timings = {
			bayonet_attack_sweep = 0.6896551724137931,
			bayonet_attack_sweep_02 = 1.4,
			bayonet_attack_stab = 0.4888888888888889,
			bayonet_attack_stab_02 = 1.2222222222222223
		},
		attack_anim_durations = {
			bayonet_attack_sweep = 2.0689655172413794,
			bayonet_attack_sweep_02 = 2.8333333333333335,
			bayonet_attack_stab = 1.4444444444444444,
			bayonet_attack_stab_02 = 2.2222222222222223
		},
		attack_intensities = {
			ranged = 1,
			melee = 0.75
		},
		damage_profile = DamageProfileTemplates.melee_roamer_default,
		damage_type = damage_types.minion_melee_sharp
	},
	bayonet_charge_attack = {
		move_speed = 4,
		utility_weight = 10,
		weapon_reach = 3,
		moving_attack = true,
		considerations = UtilityConsiderations.renegade_rifleman_bayonet_attack,
		attack_anim_events = {
			"bayonet_charge_hit",
			"bayonet_charge_hit_02",
			"bayonet_charge_hit_03",
			"bayonet_charge_hit_04",
			"bayonet_charge_hit_05"
		},
		attack_anim_damage_timings = {
			bayonet_charge_hit_04 = 1.3888888888888888,
			bayonet_charge_hit = 0.4666666666666667,
			bayonet_charge_hit_05 = 1.2222222222222223,
			bayonet_charge_hit_02 = 0.7222222222222222,
			bayonet_charge_hit_03 = 0.6666666666666666
		},
		attack_anim_durations = {
			bayonet_charge_hit_04 = 2.5,
			bayonet_charge_hit = 2.1666666666666665,
			bayonet_charge_hit_05 = 2.361111111111111,
			bayonet_charge_hit_02 = 1.6666666666666667,
			bayonet_charge_hit_03 = 1.6111111111111112
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 1,
			moving_melee = 2,
			ranged = 1
		},
		move_start_timings = {
			bayonet_charge_hit = 0
		},
		damage_profile = DamageProfileTemplates.melee_roamer_default,
		damage_type = damage_types.minion_melee_sharp,
		stagger_type_reduction = {
			ranged = 20
		}
	},
	switch_weapon = {
		slot_melee_weapon = {
			anim_state = "to_melee",
			switch_anim_events = {
				"equip_sword"
			},
			switch_anim_equip_timings = {
				equip_sword = 0.5
			},
			switch_anim_durations = {
				equip_sword = 0.6666666666666666
			}
		},
		slot_ranged_weapon = {
			switch_anim_events = {
				"equip_gun"
			},
			switch_anim_equip_timings = {
				equip_gun = 0.17777777777777778
			},
			switch_anim_durations = {
				equip_gun = 0.4
			}
		}
	},
	blocked = {
		blocked_anims = {
			"blocked",
			"blocked_02"
		},
		blocked_duration = {
			blocked_02 = 1.4102564102564104,
			blocked = 1.2820512820512822
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
					"stagger_fwd_killshot_1",
					"stagger_fwd_killshot_2"
				},
				bwd = {
					"stagger_bwd_killshot_1",
					"stagger_bwd_killshot_2"
				},
				left = {
					"stagger_left_killshot_1",
					"stagger_left_killshot_2"
				},
				right = {
					"stagger_right_killshot_1",
					"stagger_right_killshot_2"
				},
				dwn = {
					"stagger_bwd_killshot_1",
					"stagger_bwd_killshot_2"
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
action_data.shoot_training_grounds_sprint = table.clone_instance(action_data.shoot)
action_data.shoot_training_grounds_sprint.time_per_shot = shooting_difficulty_settings.time_per_shot_tg_sprint

return action_data
