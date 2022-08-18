local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local action_data = {
	name = "cultist_berzerker",
	idle = {
		rotate_towards_target = true,
		anim_events = {
			"idle",
			"idle_2"
		}
	},
	patrol = {
		anim_events = {
			"move_fwd_1"
		},
		idle_anim_events = {
			"idle",
			"idle_2"
		},
		speeds = {
			move_fwd_1 = 1
		}
	},
	death = {
		instant_ragdoll_chance = 1,
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
				"death_arm_left_2"
			},
			[hit_zone_names.lower_left_arm] = {
				"death_arm_left",
				"death_arm_left_2"
			},
			[hit_zone_names.upper_right_arm] = {
				"death_arm_right",
				"death_arm_right_2"
			},
			[hit_zone_names.lower_right_arm] = {
				"death_arm_right",
				"death_arm_right_2"
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
	combat_idle = {
		utility_weight = 2,
		rotate_towards_target = true,
		considerations = UtilityConsiderations.melee_combat_idle,
		anim_events = {
			"idle"
		}
	},
	alerted = {
		override_aggro_distance = 6,
		vo_event = "alerted_idle",
		instant_aggro_chance = 0,
		moving_alerted_anim_events = {
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
			"alerted",
			"alerted_2"
		},
		start_move_anim_data = {
			alerted_fwd = {},
			alerted_bwd = {
				sign = 1,
				rad = math.pi
			},
			alerted_left = {
				sign = 1,
				rad = math.pi / 2
			},
			alerted_right = {
				sign = -1,
				rad = math.pi / 2
			},
			alerted_fwd_2 = {},
			alerted_bwd_2 = {
				sign = 1,
				rad = math.pi
			},
			alerted_left_2 = {
				sign = 1,
				rad = math.pi / 2
			},
			alerted_right_2 = {
				sign = -1,
				rad = math.pi / 2
			},
			alerted_fwd_3 = {},
			alerted_bwd_3 = {
				sign = 1,
				rad = math.pi
			},
			alerted_left_3 = {
				sign = 1,
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
			alerted_right_3 = 0.7666666666666667,
			alerted_bwd_2 = 3.066666666666667,
			alerted_right_2 = 0.43333333333333335,
			alerted_right = 0.7666666666666667,
			alerted_left = 0.4,
			alerted_bwd = 2.3666666666666667,
			alerted_left_2 = 1.7,
			alerted_bwd_3 = 2.3666666666666667,
			alerted_left_3 = 0.4
		},
		alerted_durations = {
			alerted_fwd_2 = 3.9,
			alerted_bwd_2 = 5.1,
			alerted_bwd_3 = 4.266666666666667,
			alerted_right_2 = 3.8,
			alerted_left_3 = 3.3333333333333335,
			alerted_right = 4.466666666666667,
			alerted_left = 3.3333333333333335,
			alerted_bwd = 4.266666666666667,
			alerted_left_2 = 3.7,
			alerted_right_3 = 4.466666666666667,
			alerted_fwd_3 = 4.5,
			alerted_fwd = 4.5,
			hesitate_1 = {
				2.6666666666666665,
				6.333333333333333
			},
			hesitate_2 = {
				1.3333333333333333,
				5.333333333333333
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
	follow = {
		idle_anim_events = "idle",
		run_anim_event = "move_fwd",
		utility_weight = 1,
		controlled_stagger = true,
		controlled_stagger_min_speed = 2,
		leave_walk_distance = 7,
		controlled_stagger_ignored_combat_range = "melee",
		vo_event = "assault",
		walk_anim_event = "move_fwd_walk_4",
		running_stagger_duration = 1.1666666666666667,
		running_stagger_anim_left = "run_stagger_01",
		move_speed = 5.4,
		use_animation_running_stagger_speed = true,
		rotation_speed = 5,
		running_stagger_anim_right = "run_stagger_02",
		enter_walk_distance = 4,
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			walking = {
				bwd = "move_bwd_walk",
				left = "move_left_walk",
				right = "move_right_walk",
				fwd = {
					"move_fwd_walk",
					"move_fwd_walk_2",
					"move_fwd_walk_4"
				}
			},
			running = {
				bwd = "move_start_bwd",
				fwd = "move_start_fwd",
				left = "move_start_left",
				right = "move_start_right"
			}
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
			move_start_fwd = 0.5
		}
	},
	assault_follow = {
		idle_anim_events = "idle",
		running_stagger_anim_right = "run_stagger_02",
		use_animation_running_stagger_speed = true,
		utility_weight = 1,
		vo_event = "assault",
		leave_walk_distance = 7,
		controlled_stagger_ignored_combat_range = "melee",
		force_move_anim_event = "assault_fwd",
		walk_anim_event = "move_fwd_walk",
		is_assaulting = true,
		running_stagger_duration = 1.1666666666666667,
		running_stagger_anim_left = "run_stagger_01",
		move_speed = 6.2,
		controlled_stagger_min_speed = 2,
		run_anim_event = "assault_fwd",
		rotation_speed = 5,
		controlled_stagger = true,
		enter_walk_distance = 4,
		considerations = UtilityConsiderations.assault_far
	},
	melee_attack = {
		weapon_reach = 3.5,
		utility_weight = 1,
		ignore_blocked = true,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			normal = {
				"attack_01",
				"attack_02",
				"attack_03",
				"attack_04",
				"attack_combo_standing_01",
				"attack_combo_standing_02",
				"attack_combo_standing_03",
				"attack_combo_standing_04",
				"attack_combo_standing_05",
				"attack_combo_standing_06"
			},
			up = {
				"attack_reach_up"
			},
			down = {
				"attack_down_01"
			}
		},
		attack_anim_damage_timings = {
			attack_01 = 0.4523809523809524,
			attack_03 = 0.5714285714285714,
			attack_reach_up = 1.1794871794871795,
			attack_02 = 0.6190476190476191,
			attack_04 = 1.2142857142857142,
			attack_down_01 = 1.3333333333333333,
			attack_combo_standing_01 = {
				0.6666666666666666,
				0.9333333333333333,
				1.6266666666666667,
				2.3466666666666667
			},
			attack_combo_standing_02 = {
				0.5866666666666667,
				1.1733333333333333,
				1.76,
				2.56
			},
			attack_combo_standing_03 = {
				0.48,
				0.9333333333333333,
				1.6266666666666667,
				2.32
			},
			attack_combo_standing_04 = {
				1.1466666666666667,
				1.6,
				1.7333333333333334,
				2.4266666666666667
			},
			attack_combo_standing_05 = {
				0.5333333333333333,
				0.9866666666666667,
				1.2,
				1.5733333333333333,
				1.8666666666666667,
				2.32,
				2.6666666666666665,
				3.3066666666666666
			},
			attack_combo_standing_06 = {
				0.64,
				1.4666666666666666
			}
		},
		attack_anim_durations = {
			attack_01 = 1.1428571428571428,
			attack_combo_standing_01 = 3.493333333333333,
			attack_combo_standing_03 = 3.2,
			attack_combo_standing_04 = 3.52,
			attack_03 = 1.3333333333333333,
			attack_reach_up = 2.6923076923076925,
			attack_02 = 1.380952380952381,
			attack_combo_standing_06 = 2.3733333333333335,
			attack_combo_standing_05 = 4.24,
			attack_04 = 2.2142857142857144,
			attack_down_01 = 3.3333333333333335,
			attack_combo_standing_02 = 3.44
		},
		attack_intensities = {
			ranged = 1,
			melee = 2
		},
		stagger_type_reduction = {
			ranged = 20,
			killshot = 20
		},
		damage_profile = DamageProfileTemplates.melee_fighter_default,
		damage_type = damage_types.minion_melee_sharp
	},
	combo_attack = {
		utility_weight = 1,
		ignore_blocked = true,
		stagger_reduction = 50,
		weapon_reach = 3.75,
		moving_attack = true,
		considerations = UtilityConsiderations.cultist_berzerker_combo_attack,
		attack_anim_events = {
			"attack_combo_01",
			"attack_combo_02",
			"attack_combo_03",
			"attack_combo_04",
			"attack_combo_05",
			"attack_combo_06"
		},
		attack_anim_damage_timings = {
			attack_combo_01 = {
				0.6666666666666666,
				1.12,
				1.6,
				1.9466666666666668,
				3.2
			},
			attack_combo_02 = {
				0.6133333333333333,
				1.36,
				2.1333333333333333,
				2.96
			},
			attack_combo_03 = {
				0.7466666666666667,
				1.5466666666666666,
				2.4,
				3.2533333333333334
			},
			attack_combo_04 = {
				0.72,
				1.8133333333333332,
				2.8533333333333335,
				3.8133333333333335
			},
			attack_combo_05 = {
				0.6666666666666666,
				1.5733333333333333,
				2.4266666666666667,
				3.2
			},
			attack_combo_06 = {
				0.7733333333333333,
				1.6,
				2.1333333333333333,
				3.013333333333333
			}
		},
		move_start_timings = {
			attack_combo_03 = 0,
			attack_combo_05 = 0,
			attack_combo_02 = 0,
			attack_combo_06 = 0,
			attack_combo_01 = 0,
			attack_combo_04 = 0
		},
		attack_anim_durations = {
			attack_combo_03 = 4.053333333333334,
			attack_combo_05 = 4.133333333333334,
			attack_combo_02 = 3.68,
			attack_combo_06 = 4.4,
			attack_combo_01 = 4.8,
			attack_combo_04 = 4.266666666666667
		},
		attack_intensities = {
			ranged = 1,
			melee = 2
		},
		damage_profile = DamageProfileTemplates.melee_fighter_default,
		damage_type = damage_types.minion_melee_sharp
	},
	moving_melee_attack = {
		utility_weight = 1,
		ignore_blocked = true,
		weapon_reach = 3.75,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		considerations = UtilityConsiderations.renegade_melee_moving_melee_attack,
		attack_anim_events = {
			"attack_move_01"
		},
		attack_anim_damage_timings = {
			attack_move_01 = 0.9382716049382716
		},
		move_start_timings = {
			attack_move_01 = 0
		},
		attack_anim_durations = {
			attack_move_01 = 1.728395061728395
		},
		attack_intensities = {
			ranged = 1,
			melee = 2
		},
		damage_profile = DamageProfileTemplates.melee_fighter_default,
		damage_type = damage_types.minion_melee_sharp,
		animation_move_speed_configs = {
			attack_move_01 = {
				{
					value = 4,
					distance = 5.61
				},
				{
					value = 3,
					distance = 4.39
				},
				{
					value = 2,
					distance = 3.12
				},
				{
					value = 1,
					distance = 2.12
				},
				{
					value = 0,
					distance = 0.1
				}
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
				10.5,
				11
			},
			suppressed_loop_02 = {
				10.5,
				11
			},
			suppressed_loop_03 = {
				10.5,
				11
			},
			suppressed_loop_knee_01 = {
				10.5,
				11
			},
			suppressed_loop_knee_02 = {
				10.5,
				11
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
			suppressed_jump_right_01 = 1.36,
			suppressed_jump_fwd_01 = 1.4666666666666666,
			suppressed_jump_right_02 = 0.8533333333333334,
			suppressed_jump_left_01 = 1.2,
			suppressed_jump_fwd_02 = 1.2266666666666666,
			suppressed_jump_left_02 = 1.2,
			suppressed_jump_bwd_01 = 1.1466666666666667
		}
	},
	blocked = {
		blocked_duration = 1.6666666666666667,
		blocked_anims = {
			"blocked"
		}
	},
	stagger = {
		stagger_duration_mods = {
			stagger_explosion_back_2 = 0.9
		},
		stagger_anims = {
			light = {
				fwd = {
					"stagger_fwd_light",
					"stagger_fwd_light_2",
					"stagger_fwd_light_3"
				},
				bwd = {
					"stagger_bwd_light",
					"stagger_bwd_light_2",
					"stagger_bwd_light_3"
				},
				left = {
					"stagger_left_light",
					"stagger_left_light_2",
					"stagger_left_light_3"
				},
				right = {
					"stagger_right_light",
					"stagger_right_light_2",
					"stagger_right_light_3"
				},
				dwn = {
					"stun_down"
				}
			},
			medium = {
				fwd = {
					"stagger_fwd",
					"stagger_fwd_2"
				},
				bwd = {
					"stagger_bwd",
					"stagger_bwd_2"
				},
				left = {
					"stagger_left",
					"stagger_left_2"
				},
				right = {
					"stagger_right",
					"stagger_right_2"
				},
				dwn = {
					"stagger_medium_downward",
					"stagger_medium_downward_2"
				}
			},
			heavy = {
				fwd = {
					"stagger_fwd_heavy",
					"stagger_fwd_heavy_2"
				},
				bwd = {
					"stagger_up_heavy",
					"stagger_up_heavy_2"
				},
				left = {
					"stagger_left_heavy",
					"stagger_left_heavy_2"
				},
				right = {
					"stagger_right_heavy",
					"stagger_right_heavy_2"
				},
				dwn = {
					"stagger_dwn_heavy",
					"stagger_dwn_heavy_2"
				}
			},
			light_ranged = {
				fwd = {
					"stun_fwd_ranged_light",
					"stun_fwd_ranged_light_2"
				},
				bwd = {
					"stun_bwd_ranged_light",
					"stun_bwd_ranged_light_2"
				},
				left = {
					"stun_left_ranged_light",
					"stun_left_ranged_light_2"
				},
				right = {
					"stun_right_ranged_light",
					"stun_right_ranged_light_2"
				}
			},
			explosion = {
				fwd = {
					"stagger_explosion_front"
				},
				bwd = {
					"stagger_explosion_back",
					"stagger_explosion_back_2"
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
					"stagger_fwd_killshot_1"
				},
				bwd = {
					"stagger_bwd_killshot_1"
				},
				left = {
					"stagger_left_killshot_1"
				},
				right = {
					"stagger_right_killshot_1"
				},
				dwn = {
					"stagger_bwd_killshot_1"
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
			}
		}
	},
	smash_obstacle = {
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_01",
			"attack_02",
			"attack_03"
		},
		attack_anim_damage_timings = {
			attack_01 = 1.264367816091954,
			attack_05 = 0.6,
			attack_04 = 0.6,
			attack_06 = 0.6,
			attack_03 = 1.1954022988505748,
			attack_07 = 0.6,
			attack_02 = 1.264367816091954
		},
		attack_anim_durations = {
			attack_01 = 2.413793103448276,
			attack_05 = 2.0987654320987654,
			attack_04 = 1.728395061728395,
			attack_06 = 1.7241379310344827,
			attack_03 = 2.9885057471264367,
			attack_07 = 2.0987654320987654,
			attack_02 = 2.5977011494252875
		},
		damage_profile = DamageProfileTemplates.melee_fighter_default
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
