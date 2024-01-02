local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GroundImpactFxTemplates = require("scripts/settings/fx/ground_impact_fx_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local action_data = {
	name = "renegade_executor",
	idle = {
		anim_events = "idle"
	},
	patrol = {
		idle_anim_events = "patrol_idle",
		anim_events = {
			"move_fwd_1"
		},
		speeds = {
			move_fwd_1 = 1.25
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
	alerted = {
		override_aggro_distance = 8,
		vo_event = "alerted_idle",
		moving_alerted_anim_events = {
			bwd = "alerted_bwd",
			fwd = "alerted_fwd",
			left = "alerted_left",
			right = "alerted_right"
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
			}
		},
		start_move_rotation_timings = {
			alerted_bwd = 0.4,
			alerted_right = 0.5,
			alerted_left = 0.5
		},
		start_rotation_durations = {
			alerted_bwd = 1,
			alerted_right = 0.7666666666666667,
			alerted_left = 0.7666666666666667
		},
		alerted_durations = {
			alerted_bwd = 1.6666666666666667,
			alerted_right = 1.4333333333333333,
			alerted_left = 1.5,
			alerted_fwd = 1.2666666666666666
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
			jump_over_gap_4m_2 = 1.4,
			jump_over_gap_4m = 1.2333333333333334
		},
		ending_move_states = {
			jump_over_gap_4m_2 = "jumping",
			jump_over_gap_4m = "jumping"
		}
	},
	follow = {
		idle_anim_events = "idle",
		utility_weight = 1,
		enter_walk_distance = 4,
		leave_walk_distance = 6,
		run_anim_event = "move_fwd",
		vo_event = "melee_idle",
		walk_anim_event = "move_fwd_walk",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			walking = {
				bwd = "move_bwd_walk",
				fwd = "move_fwd_walk",
				left = "move_left_walk",
				right = "move_right_walk"
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
				sign = 1,
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
			move_start_right = 1.72,
			move_start_fwd = 0.32,
			move_start_bwd = 1.72,
			move_start_left = 1.7999999999999998
		},
		start_move_event_anim_speed_durations = {
			move_start_fwd = 1.2666666666666666
		}
	},
	melee_attack = {
		weapon_reach = 3.25,
		utility_weight = 2,
		vo_event = "assault",
		set_weapon_intensity = true,
		considerations = UtilityConsiderations.melee_attack_elite,
		attack_anim_events = {
			normal = {
				"attack_03",
				"attack_04"
			},
			up = {
				"attack_reach_up"
			},
			down = {
				"attack_down_01"
			}
		},
		attack_anim_damage_timings = {
			attack_03 = 0.6133333333333333,
			attack_reach_up = 0.6923076923076923,
			attack_04 = 0.6933333333333334,
			attack_down_01 = 2.1666666666666665
		},
		attack_anim_durations = {
			attack_03 = 1.7333333333333334,
			attack_reach_up = 1.7435897435897436,
			attack_04 = 1.4666666666666666,
			attack_down_01 = 4.5
		},
		attack_intensities = {
			ranged = 1,
			melee = 3
		},
		stagger_type_reduction = {
			ranged = 30,
			melee = 30
		},
		damage_profile = DamageProfileTemplates.melee_executor_default,
		damage_type = damage_types.minion_melee_blunt_elite
	},
	moving_melee_attack = {
		utility_weight = 3,
		vo_event = "assault",
		set_weapon_intensity = true,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		move_speed_variable_lerp_speed = 4,
		weapon_reach = 3,
		move_speed = 4,
		considerations = UtilityConsiderations.renegade_executor_moving_melee_attack,
		attack_anim_events = {
			"attack_move_02"
		},
		attack_anim_damage_timings = {
			attack_move_02 = 1.1851851851851851
		},
		attack_anim_durations = {
			attack_move_02 = 2.3703703703703702
		},
		attack_intensities = {
			melee = 3,
			running_melee = 3,
			moving_melee = 3,
			ranged = 1
		},
		move_start_timings = {
			attack_move_02 = 0.12345679012345678
		},
		damage_profile = DamageProfileTemplates.melee_executor_default,
		damage_type = damage_types.minion_melee_blunt_elite,
		stagger_type_reduction = {
			ranged = 60,
			killshot = 60
		},
		animation_move_speed_configs = {
			attack_move_02 = {
				{
					value = 4,
					distance = 7.7
				},
				{
					value = 3,
					distance = 5.18
				},
				{
					value = 2,
					distance = 3.53
				},
				{
					value = 1,
					distance = 1.79
				},
				{
					value = 0,
					distance = 0.84
				}
			}
		}
	},
	melee_cleave_attack = {
		weapon_reach = 3.5,
		bot_power_level_modifier = 0.25,
		vo_event = "special_atack",
		utility_weight = 2,
		set_weapon_intensity = true,
		aoe_threat_timing = 0.3,
		considerations = UtilityConsiderations.melee_attack_elite,
		attack_anim_events = {
			normal = {
				"attack_01",
				"attack_02"
			},
			up = {
				"attack_reach_up"
			},
			down = {
				"attack_down_01"
			}
		},
		attack_anim_damage_timings = {
			attack_01 = 1.471264367816092,
			attack_reach_up = 0.6923076923076923,
			attack_02 = 1.2413793103448276,
			attack_down_01 = 2.1666666666666665
		},
		attack_anim_durations = {
			attack_01 = 2.4367816091954024,
			attack_reach_up = 1.7435897435897436,
			attack_02 = 2.0689655172413794,
			attack_down_01 = 4.5
		},
		attack_intensities = {
			ranged = 1,
			melee = 3
		},
		damage_profile = DamageProfileTemplates.melee_executor_cleave,
		damage_type = damage_types.minion_melee_blunt_elite,
		stagger_type_reduction = {
			ranged = 30,
			melee = 30
		},
		ground_impact_fx_template = GroundImpactFxTemplates.renegade_executor_cleave
	},
	moving_melee_cleave_attack = {
		aoe_threat_timing = 0.3,
		utility_weight = 4,
		vo_event = "assault",
		set_weapon_intensity = true,
		move_speed_variable_name = "moving_attack_fwd_speed",
		move_speed = 4,
		moving_attack = true,
		move_speed_variable_lerp_speed = 4,
		weapon_reach = 3.5,
		bot_power_level_modifier = 0.25,
		considerations = UtilityConsiderations.renegade_executor_moving_melee_attack,
		attack_anim_events = {
			"attack_move_01"
		},
		attack_anim_damage_timings = {
			attack_move_01 = 1.4814814814814814
		},
		attack_anim_durations = {
			attack_move_01 = 2.8395061728395063
		},
		attack_intensities = {
			melee = 3,
			running_melee = 3,
			moving_melee = 3,
			ranged = 1
		},
		move_start_timings = {
			attack_move_01 = 0.12345679012345678
		},
		damage_profile = DamageProfileTemplates.melee_executor_cleave,
		damage_type = damage_types.minion_melee_blunt_elite,
		stagger_type_reduction = {
			ranged = 60,
			killshot = 60
		},
		animation_move_speed_configs = {
			attack_move_01 = {
				{
					value = 4,
					distance = 5.47
				},
				{
					value = 3,
					distance = 4.08
				},
				{
					value = 2,
					distance = 3.04
				},
				{
					value = 1,
					distance = 1.86
				},
				{
					value = 0,
					distance = 0.95
				}
			}
		},
		ground_impact_fx_template = GroundImpactFxTemplates.renegade_executor_cleave
	},
	blocked = {
		blocked_duration = 1.6666666666666667,
		blocked_anims = {
			"blocked"
		}
	},
	stagger = {
		stagger_anims = {
			light = {
				fwd = {
					"stagger_fwd_light_2",
					"stagger_fwd_light_5",
					"stagger_fwd_light_6"
				},
				bwd = {
					"stagger_bwd_light_5",
					"stagger_bwd_light_7",
					"stagger_bwd_light_8"
				},
				left = {
					"stagger_left_light_2",
					"stagger_left_light_3",
					"stagger_left_light_4"
				},
				right = {
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
					"stagger_fwd_2",
					"stagger_fwd_3"
				},
				bwd = {
					"stagger_bwd_3",
					"stagger_bwd_4"
				},
				left = {
					"stagger_left_3",
					"stagger_left_4"
				},
				right = {
					"stagger_right",
					"stagger_right_2"
				},
				dwn = {
					"stagger_medium_downward_2",
					"stagger_medium_downward_3"
				}
			},
			heavy = {
				fwd = {
					"stagger_fwd_heavy_3"
				},
				bwd = {
					"stagger_bwd_heavy",
					"stagger_bwd_heavy_2"
				},
				left = {
					"stagger_left_heavy_3"
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
					"stagger_fwd_light_2",
					"stagger_fwd_light_5",
					"stagger_fwd_light_6"
				},
				bwd = {
					"stagger_bwd_light_5",
					"stagger_bwd_light_7",
					"stagger_bwd_light_8"
				},
				left = {
					"stagger_left_light_2",
					"stagger_left_light_3",
					"stagger_left_light_4"
				},
				right = {
					"stagger_right_light_2",
					"stagger_right_light_3",
					"stagger_right_light_4"
				},
				dwn = {
					"stun_down"
				}
			},
			explosion = {
				fwd = {
					"stagger_fwd_heavy_3"
				},
				bwd = {
					"stagger_bwd_heavy",
					"stagger_bwd_heavy_2"
				},
				left = {
					"stagger_left_heavy_3"
				},
				right = {
					"stagger_right_heavy"
				},
				dwn = {
					"stagger_dwn_heavy"
				}
			},
			killshot = {
				fwd = {
					"stagger_fwd_light_2",
					"stagger_fwd_light_5",
					"stagger_fwd_light_6"
				},
				bwd = {
					"stagger_bwd_light_5",
					"stagger_bwd_light_7",
					"stagger_bwd_light_8"
				},
				left = {
					"stagger_left_light_2",
					"stagger_left_light_3",
					"stagger_left_light_4"
				},
				right = {
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
					"stagger_front_sticky_2"
				},
				fwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2"
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2"
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2"
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2"
				}
			},
			electrocuted = {
				bwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2"
				},
				fwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2"
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2"
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2"
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2"
				}
			},
			blinding = {
				fwd = {
					"stagger_fwd_light_2",
					"stagger_fwd_light_5",
					"stagger_fwd_light_6"
				},
				bwd = {
					"stagger_bwd_light_5",
					"stagger_bwd_light_7",
					"stagger_bwd_light_8"
				},
				left = {
					"stagger_left_light_2",
					"stagger_left_light_3",
					"stagger_left_light_4"
				},
				right = {
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
	smash_obstacle = {
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_01",
			"attack_02",
			"attack_03",
			"attack_04"
		},
		attack_anim_damage_timings = {
			attack_01 = 0.6,
			attack_03 = 0.6,
			attack_02 = 0.6,
			attack_04 = 0.6
		},
		attack_anim_durations = {
			attack_01 = 1.7241379310344827,
			attack_03 = 1.7241379310344827,
			attack_02 = 1.7241379310344827,
			attack_04 = 1.728395061728395
		},
		damage_profile = DamageProfileTemplates.melee_executor_default,
		damage_type = damage_types.minion_melee_blunt_elite
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
