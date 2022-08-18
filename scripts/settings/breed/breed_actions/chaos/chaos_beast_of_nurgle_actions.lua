local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local action_data = {
	name = "chaos_beast_of_nurgle",
	idle = {
		anim_events = "idle_happy"
	},
	death = {
		instant_ragdoll_chance = 1
	},
	change_target = {
		rotation_speed = 2,
		rotate_towards_target_on_fwd = true,
		change_target_anim_events = {
			bwd = "change_target_bwd",
			fwd = "change_target_fwd",
			left = "change_target_left",
			right = "change_target_right"
		},
		change_target_anim_data = {
			change_target_fwd = {},
			change_target_bwd = {
				sign = 1,
				rad = math.pi
			},
			change_target_left = {
				sign = 1,
				rad = math.pi / 2
			},
			change_target_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		change_target_rotation_timings = {
			change_target_right = 0,
			change_target_fwd = 0,
			change_target_left = 0,
			change_target_bwd = 0
		},
		change_target_rotation_durations = {
			change_target_right = 2.533333333333333,
			change_target_fwd = 2.5,
			change_target_left = 2.533333333333333,
			change_target_bwd = 3.1
		},
		change_target_event_anim_speed_durations = {
			change_target_fwd = 2.3333333333333335
		}
	},
	follow = {
		idle_anim_events = "idle_happy",
		enter_walk_distance = 5.5,
		run_anim_event = "move_fwd",
		utility_weight = 1,
		leave_walk_distance = 8,
		rotation_speed = 4,
		walk_anim_event = "walk_fwd",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
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
			move_start_right = 0.16666666666666666,
			move_start_fwd = 0,
			move_start_bwd = 0.26666666666666666,
			move_start_left = 0.36666666666666664
		},
		start_rotation_durations = {
			move_start_right = 1.2666666666666666,
			move_start_fwd = 0,
			move_start_bwd = 1.3333333333333333,
			move_start_left = 1.3333333333333333
		}
	},
	movement = {
		idle_anim_events = "idle_happy",
		utility_weight = 1,
		min_distance_to_target = 3,
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 280,
		run_anim_event = "move_fwd",
		rotation_speed = 4,
		move_to_cooldown = 1,
		max_distance_to_target = 10,
		walk_anim_event = "walk_fwd",
		degree_per_direction = 10,
		considerations = UtilityConsiderations.melee_follow,
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
			move_start_right = 1.2666666666666666,
			move_start_fwd = 0,
			move_start_bwd = 1.6666666666666667,
			move_start_left = 1.3333333333333333
		}
	},
	climb = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_up_3m = 1,
			jump_down_land_3m = 0.6666666666666666,
			jump_up_fence_1m = 0.9333333333333333,
			jump_up_fence_5m = 0.8666666666666667,
			jump_down_fence_land_1m = 0.5666666666666667,
			jump_down_fence_land_5m = 0.26666666666666666,
			jump_down_fence_land_3m = 0.5,
			jump_down_land_1m = 0.5,
			jump_down_land = 1.2,
			jump_up_fence_3m = 1,
			jump_up_5m = 1,
			jump_down_land_5m = 0.4666666666666667,
			jump_up_2m = 1,
			jump_up_1m = 1,
			jump_up_4m = 1
		},
		ending_move_states = {
			jump_up_3m = "jumping",
			jump_down_land_3m = "jumping",
			jump_down_land_5m = "jumping",
			jump_down_land = "jumping",
			jump_down_fence_land_5m = "jumping",
			jump_down_land_1m = "jumping",
			jump_down_fence_land_1m = "jumping",
			jump_up_5m = "jumping",
			jump_down_fence_land_3m = "jumping",
			jump_up_2m = "jumping",
			jump_up_1m = "jumping",
			jump_up_4m = "jumping"
		},
		blend_timings = {
			jump_up_3m = 0.5,
			jump_down_land_3m = 0,
			jump_down = 0.4,
			jump_down_fence_land_1m = 0,
			jump_down_land = 0,
			jump_down_land_1m = 0,
			jump_up_fence_1m = 0.2,
			jump_up_fence_3m = 0.4,
			jump_up_5m = 0.4,
			jump_up_fence_5m = 0.4,
			jump_down_1m = 0.4,
			jump_up_2m = 0.4,
			jump_up_1m = 0.4,
			jump_up_4m = 0.4
		},
		catapult_units = {
			speed = 7,
			radius = 2,
			angle = math.pi / 6
		}
	},
	jump_across = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_over_cover = 1.9333333333333333,
			jump_over_gap_4m = 1.4333333333333333
		},
		ending_move_states = {
			jump_over_cover = "moving",
			jump_over_gap_4m = "jumping"
		},
		blend_timings = {
			jump_over_cover = 0.2,
			jump_over_gap_4m = 0.2
		}
	},
	stagger = {
		stagger_anims = {
			light = {
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
					"stagger_bwd"
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
					"stagger_bwd"
				}
			},
			heavy = {
				fwd = {
					"stagger_bwd_heavy"
				},
				bwd = {
					"stagger_bwd_heavy"
				},
				left = {
					"stagger_bwd_heavy"
				},
				right = {
					"stagger_bwd_heavy"
				},
				dwn = {
					"stagger_bwd_heavy"
				}
			},
			light_ranged = {
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
					"stagger_bwd"
				}
			},
			explosion = {
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
					"stagger_bwd"
				}
			},
			killshot = {
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
					"stagger_bwd"
				}
			},
			sticky = {
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
					"stagger_bwd"
				}
			}
		}
	},
	open_door = {
		rotation_duration = 0.1,
		stagger_immune = true
	},
	smash_obstacle = {
		rotation_duration = 0,
		attack_anim_events = {
			"stagger_fwd"
		},
		attack_anim_damage_timings = {
			attack_slam = 0.7333333333333333
		},
		attack_anim_durations = {
			attack_slam = 2
		},
		damage_profile = DamageProfileTemplates.default
	},
	exit_spawner = {
		run_anim_event = "move_fwd"
	}
}

return action_data
