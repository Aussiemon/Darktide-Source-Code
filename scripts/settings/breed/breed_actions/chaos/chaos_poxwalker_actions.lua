local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local action_data = {
	name = "chaos_poxwalker",
	idle = {
		rotate_towards_target = true,
		anim_events = "idle"
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
				"death_decapitate",
				"death_decapitate_2",
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
			},
			burning = {
				"death_burn",
				"death_burn_2"
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
		anim_events = "idle",
		rotate_towards_target = true,
		considerations = UtilityConsiderations.melee_combat_idle
	},
	alerted = {
		hesitate_chance = 0.15,
		override_aggro_distance = 6,
		alert_spread_radius = 8,
		alert_spread_max_distance_to_target = 30,
		instant_aggro_chance = 0.1,
		moving_alerted_anim_events = {
			bwd = "alerted_bwd",
			fwd = "alerted_fwd",
			left = "alerted_left",
			right = "alerted_right"
		},
		hesitate_anim_events = {
			"hesitate_01",
			"hesitate_02",
			"alerted_01",
			"alerted_02"
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
			alerted_bwd = 0,
			alerted_right = 0,
			alerted_left = 0
		},
		start_rotation_durations = {
			alerted_bwd = 1.4333333333333333,
			alerted_right = 1.6,
			alerted_left = 1.3333333333333333
		},
		alerted_durations = {
			alerted_bwd = 3,
			alerted_left = 2.8333333333333335,
			alerted_right = 3.933333333333333,
			alerted_fwd = 2.6666666666666665,
			hesitate_01 = {
				2.6666666666666665,
				6.666666666666667
			},
			hesitate_02 = {
				2.6666666666666665,
				6.666666666666667
			},
			alerted_01 = {
				2,
				6
			},
			alerted_02 = {
				4,
				6.666666666666667
			}
		}
	},
	blocked = {
		blocked_duration = 1.1666666666666667,
		blocked_anims = {
			"blocked"
		}
	},
	climb = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_up_3m_4 = 2.717948717948718,
			jump_up_3m = 3.076923076923077,
			jump_up_fence_1m = 0.6,
			jump_up_1m_2 = 1.0303030303030303,
			jump_up_fence_3m_2 = 1.5,
			jump_up_3m_3 = 4.769230769230769,
			jump_up_fence_5m = 1.3,
			jump_up_1m_4 = 1.606060606060606,
			jump_down_land = 1,
			jump_up_fence_3m = 1.4,
			jump_up_5m = 3.75,
			jump_up_3m_2 = 3.3333333333333335,
			jump_up_1m_3 = 1.3333333333333333,
			jump_up_1m = 1.2121212121212122
		},
		land_timings = {
			jump_down_1m_3 = 1.0666666666666667,
			jump_down_fence_3m = 0.5,
			jump_down_3m_4 = 1.6666666666666667,
			jump_down_fence_5m = 0.5,
			jump_down_3m_3 = 2.5,
			jump_down_3m = 0.4,
			jump_down_3m_2 = 0.4666666666666667,
			jump_down_1m_4 = 0.5666666666666667,
			jump_down_3m_5 = 1.6666666666666667,
			jump_up_fence_3m_2 = 1.3333333333333333,
			jump_down_1m = 0.3333333333333333,
			jump_down_1m_2 = 0.3333333333333333,
			jump_down_fence_1m = 0.5
		},
		ending_move_states = {
			jump_up_3m_4 = "jumping",
			jump_up_3m = "jumping",
			jump_down_land = "jumping",
			jump_up_1m_2 = "jumping",
			jump_up_3m_3 = "jumping",
			jump_up_1m_4 = "jumping",
			jump_up_5m = "jumping",
			jump_up_3m_2 = "jumping",
			jump_up_1m_3 = "jumping",
			jump_up_1m = "jumping"
		},
		blend_timings = {
			jump_down_3m = 0.2,
			jump_up_fence_5m = 0.2,
			jump_down_3m_4 = 0.2,
			jump_up_3m_4 = 0,
			jump_down_3m_3 = 0.2,
			jump_up_3m_3 = 0.2,
			jump_up_1m_2 = 0.2,
			jump_up_1m_4 = 0.2,
			jump_down_1m_2 = 0.2,
			jump_down_1m_3 = 0.3,
			jump_down_land = 0,
			jump_down_1m_4 = 0.3,
			jump_down_1m = 0.2,
			jump_over_gap_4m = 0.2,
			jump_down_3m_2 = 0.2,
			jump_over_gap_4m_2 = 0.2,
			jump_up_3m = 0.2,
			jump_up_fence_3m_2 = 0.2,
			jump_up_fence_1m = 0.2,
			jump_down_3m_5 = 0.2,
			jump_up_fence_3m = 0.2,
			jump_up_5m = 0.2,
			jump_up_3m_2 = 0.2,
			jump_up_1m_3 = 0.2,
			jump_up_1m = 0.2
		}
	},
	jump_across = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_vault_right_1 = 2.5,
			jump_vault_left_2 = 3,
			jump_vault_right_2 = 3.533333333333333,
			jump_vault_left_1 = 3.033333333333333,
			jump_over_gap_4m = 1.2333333333333334,
			jump_over_gap_4m_2 = 1.4
		},
		ending_move_states = {
			jump_vault_right_1 = "jumping",
			jump_vault_left_2 = "jumping",
			jump_vault_right_2 = "jumping",
			jump_vault_left_1 = "jumping",
			jump_over_gap_4m = "jumping",
			jump_over_gap_4m_2 = "jumping"
		}
	},
	follow = {
		idle_anim_events = "idle",
		run_anim_event = "move_fwd",
		utility_weight = 1,
		controlled_stagger_min_speed = 3,
		controlled_stagger = true,
		leave_walk_distance = 7,
		controlled_stagger_ignored_combat_range = "melee",
		walk_anim_event = "walk_fwd",
		use_animation_running_stagger_speed = true,
		rotation_speed = 5,
		enter_walk_distance = 4,
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			walking = {
				bwd = "walk_bwd",
				fwd = "walk_fwd",
				left = "walk_left",
				right = "walk_right"
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
			move_start_right = 0.9333333333333333,
			move_start_fwd = 0,
			move_start_bwd = 2,
			move_start_left = 0.8
		},
		start_move_event_anim_speed_durations = {
			move_start_fwd = 1.0666666666666667
		},
		running_stagger_anim_left = {
			"run_stagger",
			"run_stagger_2",
			"run_stagger_3",
			"run_stagger_4",
			"run_stagger_5",
			"run_stagger_6",
			"run_stagger_7"
		},
		running_stagger_anim_right = {
			"run_stagger",
			"run_stagger_2",
			"run_stagger_3",
			"run_stagger_4",
			"run_stagger_5",
			"run_stagger_6",
			"run_stagger_7"
		},
		running_stagger_duration = {
			run_stagger_6 = 3.076923076923077,
			run_stagger_2 = 2.3076923076923075,
			run_stagger_5 = 3.3333333333333335,
			run_stagger_3 = 1.794871794871795,
			run_stagger_4 = 3.3333333333333335,
			run_stagger_7 = 2.948717948717949,
			run_stagger = 2.051282051282051
		},
		running_stagger_min_duration = {
			run_stagger_6 = 2.5641025641025643,
			run_stagger_2 = 1.794871794871795,
			run_stagger_5 = 2.8205128205128207,
			run_stagger_3 = 1.2820512820512822,
			run_stagger_4 = 2.8205128205128207,
			run_stagger_7 = 2.3076923076923075,
			run_stagger = 1.5384615384615385
		}
	},
	melee_attack = {
		weapon_reach = 3,
		utility_weight = 1,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			normal = {
				"attack_01",
				"attack_02",
				"attack_03",
				"attack_04",
				"attack_05"
			},
			up = {
				"attack_reach_up_01"
			},
			down = {
				"attack_down_01"
			}
		},
		attack_anim_damage_timings = {
			attack_01 = 1.7037037037037037,
			attack_05 = 0.9876543209876543,
			attack_04 = 1.2345679012345678,
			attack_reach_up_01 = 1.1794871794871795,
			attack_03 = 1.2592592592592593,
			attack_down_01 = 1.3333333333333333,
			attack_02 = 1.4074074074074074
		},
		attack_anim_durations = {
			attack_01 = 2.740740740740741,
			attack_05 = 2.246913580246914,
			attack_04 = 2.617283950617284,
			attack_reach_up_01 = 2.6923076923076925,
			attack_03 = 2.246913580246914,
			attack_down_01 = 3.3333333333333335,
			attack_02 = 2.3209876543209877
		},
		attack_intensities = {
			ranged = 1.5,
			melee = 0.1
		},
		stagger_type_reduction = {
			ranged = 20,
			killshot = 20
		},
		damage_profile = DamageProfileTemplates.poxwalker,
		damage_type = damage_types.minion_melee_sharp
	},
	moving_melee_attack = {
		move_speed = 5,
		utility_weight = 1,
		catch_up_movementspeed = true,
		moving_attack = true,
		move_speed_variable_lerp_speed = 4,
		weapon_reach = 3,
		move_speed_variable_name = "moving_attack_fwd_speed",
		considerations = UtilityConsiderations.chaos_poxwalker_moving_melee_attack,
		attack_anim_events = {
			"attack_move_01",
			"attack_move_02",
			"attack_move_03"
		},
		attack_anim_damage_timings = {
			attack_move_03 = 1.7777777777777777,
			attack_move_01 = 1.7777777777777777,
			attack_move_02 = 1.7471264367816093
		},
		attack_anim_durations = {
			attack_move_03 = 2.9876543209876543,
			attack_move_01 = 2.962962962962963,
			attack_move_02 = 2.8045977011494254
		},
		attack_intensities = {
			melee = 0.1,
			ranged = 1.5,
			moving_melee = 0.25
		},
		move_start_timings = {
			attack_move_03 = 0,
			attack_move_01 = 0,
			attack_move_02 = 0
		},
		damage_profile = DamageProfileTemplates.poxwalker,
		damage_type = damage_types.minion_melee_sharp,
		stagger_type_reduction = {
			ranged = 30,
			killshot = 20
		},
		animation_move_speed_configs = {
			attack_move_01 = {
				{
					value = 4,
					distance = 4
				},
				{
					value = 3,
					distance = 3.44
				},
				{
					value = 2,
					distance = 2
				},
				{
					value = 1,
					distance = 0.9
				},
				{
					value = 0,
					distance = 0.49
				}
			},
			attack_move_02 = {
				{
					value = 4,
					distance = 3.5
				},
				{
					value = 3,
					distance = 2.9
				},
				{
					value = 2,
					distance = 1.9
				},
				{
					value = 1,
					distance = 0.9
				},
				{
					value = 0,
					distance = 0.49
				}
			},
			attack_move_03 = {
				{
					value = 4,
					distance = 4
				},
				{
					value = 3,
					distance = 3.2
				},
				{
					value = 2,
					distance = 2
				},
				{
					value = 1,
					distance = 0.9
				},
				{
					value = 0,
					distance = 0.48
				}
			}
		}
	},
	running_melee_attack = {
		move_speed = 5,
		utility_weight = 1,
		catch_up_movementspeed = true,
		moving_attack = true,
		move_speed_variable_lerp_speed = 4,
		weapon_reach = 3,
		move_speed_variable_name = "moving_attack_fwd_speed",
		considerations = UtilityConsiderations.chaos_poxwalker_running_melee_attack,
		attack_anim_events = {
			"attack_run_01",
			"attack_run_02"
		},
		attack_anim_damage_timings = {
			attack_run_02 = 1.8461538461538463,
			attack_run_01 = 2.282051282051282
		},
		attack_anim_durations = {
			attack_run_02 = 2.5384615384615383,
			attack_run_01 = 3.2564102564102564
		},
		attack_intensities = {
			melee = 0.1,
			running_melee = 0.1,
			ranged = 1.5
		},
		move_start_timings = {
			attack_run_02 = 0,
			attack_run_01 = 0
		},
		damage_profile = DamageProfileTemplates.poxwalker,
		damage_type = damage_types.minion_melee_sharp,
		stagger_type_reduction = {
			ranged = 30,
			killshot = 20
		},
		animation_move_speed_configs = {
			attack_run_01 = {
				{
					value = 4,
					distance = 5.59
				},
				{
					value = 3,
					distance = 4.59
				},
				{
					value = 2,
					distance = 3
				},
				{
					value = 1,
					distance = 1.94
				},
				{
					value = 0,
					distance = 0.88
				}
			},
			attack_run_02 = {
				{
					value = 4,
					distance = 6.58
				},
				{
					value = 3,
					distance = 4.59
				},
				{
					value = 2,
					distance = 3
				},
				{
					value = 1,
					distance = 2.24
				},
				{
					value = 0,
					distance = 0.72
				}
			}
		}
	},
	stagger = {
		stagger_duration_mods = {
			run_stagger = 1.25,
			run_stagger_2 = 1.25,
			run_stagger_5 = 2.5,
			stagger_bwd_6 = 1.5,
			stagger_fwd_heavy_5 = 2,
			stagger_left_7 = 0.6,
			stagger_fwd_5 = 0.6,
			stagger_bwd_heavy_8 = 1.7,
			stagger_right_heavy_7 = 1.5,
			stagger_bwd_heavy_7 = 1.7,
			stagger_right_7 = 0.6,
			stagger_right_heavy_6 = 2.5,
			run_stagger_4 = 2.5,
			stagger_bwd_5 = 1.7,
			run_stagger_7 = 2.4,
			stagger_bwd_heavy_6 = 1.9,
			stagger_right_6 = 1.5,
			stagger_left_5 = 1.3,
			stagger_left_heavy_5 = 2,
			stagger_fwd_6 = 0.6,
			stagger_right_heavy_5 = 2.5,
			stagger_left_heavy_6 = 2,
			run_stagger_3 = 1.25,
			run_stagger_6 = 2.3,
			stagger_fwd_7 = 1.5,
			stagger_left_6 = 0.6,
			stagger_fwd_heavy_6 = 1.7,
			stagger_left_8 = 1.75
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
					"stagger_fwd_4",
					"stagger_fwd_5",
					"stagger_fwd_6",
					"stagger_fwd_7"
				},
				bwd = {
					"stagger_bwd",
					"stagger_bwd_2",
					"stagger_bwd_3",
					"stagger_bwd_4",
					"stagger_bwd_5",
					"stagger_bwd_6"
				},
				left = {
					"stagger_left",
					"stagger_left_2",
					"stagger_left_3",
					"stagger_left_4",
					"stagger_left_5",
					"stagger_left_6",
					"stagger_left_7",
					"stagger_left_8"
				},
				right = {
					"stagger_right",
					"stagger_right_2",
					"stagger_right_3",
					"stagger_right_4",
					"stagger_right_5",
					"stagger_right_6",
					"stagger_right_7"
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
					"stagger_fwd_heavy_4",
					"stagger_fwd_heavy_5",
					"stagger_fwd_heavy_6"
				},
				bwd = {
					"stagger_up_heavy",
					"stagger_up_heavy_2",
					"stagger_up_heavy_3",
					"stagger_bwd_heavy",
					"stagger_bwd_heavy_2",
					"stagger_bwd_heavy_3",
					"stagger_bwd_heavy_4",
					"stagger_bwd_heavy_5",
					"stagger_bwd_heavy_6",
					"stagger_bwd_heavy_7",
					"stagger_bwd_heavy_8",
					"stagger_bwd_heavy_9"
				},
				left = {
					"stagger_left_heavy",
					"stagger_left_heavy_2",
					"stagger_left_heavy_3",
					"stagger_left_heavy_4",
					"stagger_left_heavy_5",
					"stagger_left_heavy_6"
				},
				right = {
					"stagger_right_heavy",
					"stagger_right_heavy_2",
					"stagger_right_heavy_3",
					"stagger_right_heavy_4",
					"stagger_right_heavy_5",
					"stagger_right_heavy_6"
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
			}
		}
	},
	smash_obstacle = {
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_01",
			"attack_02"
		},
		attack_anim_damage_timings = {
			attack_01 = 0.6,
			attack_02 = 0.6
		},
		attack_anim_durations = {
			attack_01 = 1.2,
			attack_02 = 1.35
		},
		attack_intensities = {
			ranged = 1,
			melee = 0.1
		},
		damage_profile = DamageProfileTemplates.poxwalker
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
