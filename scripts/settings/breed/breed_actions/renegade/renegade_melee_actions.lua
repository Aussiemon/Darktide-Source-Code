-- chunkname: @scripts/settings/breed/breed_actions/renegade/renegade_melee_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local action_data = {
	name = "renegade_melee",
	idle = {
		vo_event = "passive_idle",
		rotate_towards_target = true,
		anim_events = {
			"idle",
			"idle_2",
			"idle_3",
			"idle_4",
			"idle_5",
			"idle_6",
			"idle_7"
		}
	},
	patrol = {
		anim_events = {
			"move_fwd_1",
			"move_fwd_2",
			"move_fwd_3"
		},
		idle_anim_events = {
			"idle",
			"idle_2",
			"idle_3",
			"idle_4",
			"idle_5",
			"idle_6",
			"idle_7"
		},
		speeds = {
			move_fwd_2 = 0.91,
			move_fwd_3 = 0.87,
			move_fwd_1 = 0.89
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
	combat_idle = {
		utility_weight = 2,
		rotate_towards_target = true,
		vo_event = "melee_idle",
		considerations = UtilityConsiderations.melee_combat_idle,
		anim_events = {
			"idle",
			"idle_2",
			"idle_3",
			"idle_4",
			"idle_6",
			"idle_7",
			"idle_8",
			"idle_9",
			"idle_10"
		}
	},
	alerted = {
		hesitate_chance = 0.5,
		override_aggro_distance = 8,
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
			"hesitate_1",
			"hesitate_2",
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
			alerted_right_3 = 1.4,
			alerted_bwd_2 = 3.5,
			alerted_right_2 = 0.8,
			alerted_right = 1.4,
			alerted_left = 1.5,
			alerted_bwd = 3.8,
			alerted_left_2 = 2.1666666666666665,
			alerted_bwd_3 = 3.8,
			alerted_left_3 = 1.5
		},
		alerted_durations = {
			alerted_fwd_2 = 3.9,
			alerted_bwd_2 = 5.1,
			alerted_bwd_3 = 4.433333333333334,
			alerted_right_2 = 3.9,
			alerted_left_3 = 3.3333333333333335,
			alerted_right = 4.466666666666667,
			alerted_left = 3.3333333333333335,
			alerted_bwd = 4.433333333333334,
			alerted_left_2 = 3.9,
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
	follow = {
		idle_anim_events = "idle",
		utility_weight = 1,
		controlled_stagger = true,
		leave_walk_distance = 6,
		controlled_stagger_ignored_combat_range = "melee",
		controlled_stagger_min_speed = 2,
		vo_event = "melee_idle",
		walk_anim_event = "move_fwd_walk_4",
		move_speed = 4.5,
		use_animation_running_stagger_speed = true,
		follow_vo_interval_t = 1,
		run_anim_event = "move_fwd",
		rotation_speed = 5,
		enter_walk_distance = 3,
		considerations = UtilityConsiderations.melee_follow,
		walk_speeds = {
			move_fwd_walk_5 = 2,
			move_fwd_walk_3 = 2.4,
			move_fwd_walk_2 = 2,
			move_fwd_walk = 2,
			move_fwd_walk_4 = 1.9
		},
		start_move_anim_events = {
			walking = {
				bwd = "move_bwd_walk",
				left = "move_left_walk",
				right = "move_right_walk",
				fwd = {
					"move_fwd_walk",
					"move_fwd_walk_2",
					"move_fwd_walk_3",
					"move_fwd_walk_4",
					"move_fwd_walk_5"
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
			move_start_right = 0.16666666666666666,
			move_start_fwd = 0,
			move_start_bwd = 0.16666666666666666,
			move_start_left = 0.16666666666666666
		},
		start_rotation_durations = {
			move_start_right = 0.7,
			move_start_fwd = 0.26666666666666666,
			move_start_bwd = 1,
			move_start_left = 0.7666666666666667
		},
		start_move_event_anim_speed_durations = {
			move_start_fwd = 1.0666666666666667
		},
		running_stagger_anim_left = {
			"run_stagger_01",
			"run_stagger_03"
		},
		running_stagger_anim_right = {
			"run_stagger_02",
			"run_stagger_03"
		},
		running_stagger_duration = {
			run_stagger_03 = 1.3333333333333333,
			run_stagger_02 = 1.5,
			run_stagger_01 = 1.3666666666666667
		}
	},
	assault_follow = {
		idle_anim_events = "idle",
		controlled_stagger = true,
		controlled_stagger_min_speed = 2,
		vo_event = "assault",
		leave_walk_distance = 4,
		controlled_stagger_ignored_combat_range = "melee",
		force_move_anim_event = "assault_fwd",
		walk_anim_event = "move_fwd_walk",
		is_assaulting = true,
		move_speed = 5.6,
		use_animation_running_stagger_speed = true,
		follow_vo_interval_t = 1,
		run_anim_event = "assault_fwd",
		rotation_speed = 6,
		enter_walk_distance = 2,
		start_move_anim_events = {
			walking = {
				bwd = "move_bwd_walk",
				left = "move_left_walk",
				right = "move_right_walk",
				fwd = {
					"move_fwd_walk",
					"move_fwd_walk_2",
					"move_fwd_walk_3",
					"move_fwd_walk_4",
					"move_fwd_walk_5"
				}
			},
			running = {
				bwd = "move_start_assault_bwd",
				fwd = "move_start_assault_fwd",
				left = "move_start_assault_left",
				right = "move_start_assault_right"
			}
		},
		start_move_anim_data = {
			move_start_assault_fwd = {},
			move_start_assault_bwd = {
				sign = -1,
				rad = math.pi
			},
			move_start_assault_left = {
				sign = 1,
				rad = math.pi / 2
			},
			move_start_assault_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			move_start_assault_right = 0,
			move_start_assault_left = 0,
			move_start_assault_fwd = 0,
			move_start_assault_bwd = 0
		},
		start_rotation_durations = {
			move_start_assault_right = 0.26666666666666666,
			move_start_assault_left = 0.26666666666666666,
			move_start_assault_fwd = 1.0666666666666667,
			move_start_assault_bwd = 0.26666666666666666
		},
		start_move_event_anim_speed_durations = {
			move_start_assault_fwd = 1.0666666666666667
		},
		running_stagger_anim_left = {
			"run_stagger_01",
			"run_stagger_03"
		},
		running_stagger_anim_right = {
			"run_stagger_02",
			"run_stagger_03"
		},
		running_stagger_duration = {
			run_stagger_03 = 1.3333333333333333,
			run_stagger_02 = 1.5,
			run_stagger_01 = 1.3666666666666667
		}
	},
	melee_attack = {
		weapon_reach = 3.5,
		utility_weight = 1,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			normal = {
				"attack_04",
				"attack_05",
				"attack_06",
				"attack_07"
			},
			up = {
				"attack_reach_up"
			},
			down = {
				"attack_down_01"
			}
		},
		attack_anim_damage_timings = {
			attack_05 = 0.8148148148148148,
			attack_down_01 = 1.3333333333333333,
			attack_04 = 0.7654320987654321,
			attack_07 = 0.7,
			attack_reach_up = 1.1794871794871795,
			attack_06 = 0.7126436781609196
		},
		attack_anim_durations = {
			attack_05 = 1.5402298850574712,
			attack_down_01 = 3.3333333333333335,
			attack_04 = 1.3793103448275863,
			attack_07 = 1.8333333333333333,
			attack_reach_up = 2.6923076923076925,
			attack_06 = 1.3793103448275863
		},
		attack_intensities = {
			ranged = 1,
			melee = 0.25
		},
		stagger_type_reduction = {
			ranged = 20,
			killshot = 20
		},
		damage_profile = DamageProfileTemplates.melee_bruiser_default,
		damage_type = damage_types.minion_melee_blunt
	},
	moving_melee_attack = {
		move_speed = 4,
		utility_weight = 1,
		catch_up_movementspeed = true,
		moving_attack = true,
		move_speed_variable_lerp_speed = 4,
		weapon_reach = 3.25,
		move_speed_variable_name = "moving_attack_fwd_speed",
		considerations = UtilityConsiderations.renegade_melee_moving_melee_attack,
		attack_anim_events = {
			"attack_move_01",
			"attack_move_02",
			"attack_move_03",
			"attack_move_04"
		},
		attack_anim_damage_timings = {
			attack_move_03 = 1.1111111111111112,
			attack_move_01 = 0.9382716049382716,
			attack_move_04 = 1.0617283950617284,
			attack_move_02 = 1.1111111111111112
		},
		attack_anim_durations = {
			attack_move_03 = 2.2222222222222223,
			attack_move_01 = 2.123456790123457,
			attack_move_04 = 1.9259259259259258,
			attack_move_02 = 2.049382716049383
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 1,
			moving_melee = 0.5,
			ranged = 1
		},
		move_start_timings = {
			attack_move_03 = 0.12345679012345678,
			attack_move_01 = 0.12345679012345678,
			attack_move_04 = 0.12345679012345678,
			attack_move_02 = 0.12345679012345678
		},
		damage_profile = DamageProfileTemplates.melee_bruiser_default,
		damage_type = damage_types.minion_melee_blunt,
		stagger_type_reduction = {
			ranged = 60,
			killshot = 60
		},
		animation_move_speed_configs = {
			attack_move_01 = {
				{
					value = 4,
					distance = 4.61
				},
				{
					value = 3,
					distance = 3.39
				},
				{
					value = 2,
					distance = 2.12
				},
				{
					value = 1,
					distance = 1.12
				},
				{
					value = 0,
					distance = 0.35
				}
			},
			attack_move_02 = {
				{
					value = 4,
					distance = 4.64
				},
				{
					value = 3,
					distance = 3.31
				},
				{
					value = 2,
					distance = 2.14
				},
				{
					value = 1,
					distance = 1.13
				},
				{
					value = 0,
					distance = 0.35
				}
			},
			attack_move_03 = {
				{
					value = 4,
					distance = 4.53
				},
				{
					value = 3,
					distance = 3.02
				},
				{
					value = 2,
					distance = 2.12
				},
				{
					value = 1,
					distance = 1.09
				},
				{
					value = 0,
					distance = 0.35
				}
			},
			attack_move_04 = {
				{
					value = 4,
					distance = 4.5
				},
				{
					value = 3,
					distance = 3.42
				},
				{
					value = 2,
					distance = 2.12
				},
				{
					value = 1,
					distance = 1
				},
				{
					value = 0,
					distance = 0.35
				}
			}
		}
	},
	running_melee_attack = {
		move_speed = 4,
		utility_weight = 1,
		vo_event = "assault",
		catch_up_movementspeed = true,
		assault_vo_interval_t = 1,
		moving_attack = true,
		move_speed_variable_lerp_speed = 4,
		weapon_reach = 3.25,
		move_speed_variable_name = "moving_attack_fwd_speed",
		considerations = UtilityConsiderations.renegade_melee_running_melee_attack,
		attack_anim_events = {
			"attack_run_01",
			"attack_run_02",
			"attack_run_03"
		},
		attack_anim_damage_timings = {
			attack_run_03 = 1.5,
			attack_run_02 = 1.5666666666666667,
			attack_run_01 = 0.7333333333333333
		},
		attack_anim_durations = {
			attack_run_03 = 2.6666666666666665,
			attack_run_02 = 2.8666666666666667,
			attack_run_01 = 2
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 1,
			moving_melee = 0.5,
			ranged = 1
		},
		move_start_timings = {
			attack_run_03 = 0,
			attack_run_02 = 0,
			attack_run_01 = 0
		},
		damage_profile = DamageProfileTemplates.melee_bruiser_default,
		damage_type = damage_types.minion_melee_blunt,
		stagger_type_reduction = {
			ranged = 60,
			killshot = 60
		},
		animation_move_speed_configs = {
			attack_run_01 = {
				{
					value = 4,
					distance = 5
				},
				{
					value = 3,
					distance = 3.9
				},
				{
					value = 2,
					distance = 2.5
				},
				{
					value = 1,
					distance = 1.5
				},
				{
					value = 0,
					distance = 0.5
				}
			},
			attack_run_02 = {
				{
					value = 4,
					distance = 5
				},
				{
					value = 3,
					distance = 4
				},
				{
					value = 2,
					distance = 2
				},
				{
					value = 1,
					distance = 0.25
				},
				{
					value = 0,
					distance = 0.1
				}
			},
			attack_run_03 = {
				{
					value = 4,
					distance = 4.2
				},
				{
					value = 3,
					distance = 2.9
				},
				{
					value = 2,
					distance = 1.5
				},
				{
					value = 1,
					distance = 0.4
				},
				{
					value = 0,
					distance = 0.2
				}
			}
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
		damage_profile = DamageProfileTemplates.melee_bruiser_default,
		damage_type = damage_types.minion_melee_blunt
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
