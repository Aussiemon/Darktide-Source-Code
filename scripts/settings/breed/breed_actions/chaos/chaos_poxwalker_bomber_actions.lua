local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local action_data = {
	name = "chaos_poxwalker_bomber",
	idle = {
		anim_events = "idle"
	},
	death = {
		instant_ragdoll_chance = 1
	},
	combat_idle = {
		utility_weight = 2,
		anim_events = "idle",
		rotate_towards_target = true,
		considerations = UtilityConsiderations.melee_combat_idle
	},
	climb = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_up_3m = 4,
			jump_down_land_3m = 1.3333333333333333,
			jump_up_fence_1m = 0.4666666666666667,
			jump_down_fence_land_1m = 0.13333333333333333,
			jump_down_land = 6.166666666666667,
			jump_down_land_1m = 1.1666666666666667,
			jump_up_fence_3m = 1.4,
			jump_up_5m = 5,
			jump_up_fence_5m = 1.2,
			jump_up_1m = 1.6666666666666667
		},
		ending_move_states = {
			jump_up_3m = "jumping",
			jump_down_fence_land_1m = "jumping",
			jump_up_5m = "jumping",
			jump_down_land_5m = "jumping",
			jump_down_land_3m = "jumping",
			jump_down_land = "jumping",
			jump_up_1m = "jumping",
			jump_down_land_1m = "jumping"
		},
		blend_timings = {
			jump_up_3m = 0,
			jump_down_land_3m = 0,
			jump_down = 0.2,
			jump_down_fence_land_1m = 0,
			jump_down_2 = 0,
			jump_up_fence_1m = 0.2,
			jump_down_land = 0,
			jump_down_land_1m = 0,
			jump_up_fence_3m = 0.1,
			jump_up_5m = 0,
			jump_up_fence_5m = 0.1,
			jump_down_1m = 0.2,
			jump_up_1m = 0
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
	approach = {
		idle_anim_events = "idle",
		leave_walk_distance = 6.5,
		walk_anim_event = "walk_fwd",
		move_to_distance = 0.05,
		effect_template_start_distance = 15,
		move_during_lunge_duration = 0.6666666666666666,
		controlled_stagger = true,
		controlled_stagger_ignored_combat_range = "melee",
		stagger_duration_modifier_during_lunge = 0.175,
		controlled_stagger_min_speed = 2,
		lunge_duration = 1.2222222222222223,
		enter_lunge_distance = 6,
		use_animation_running_stagger_speed = true,
		effect_template_stop_distance = 18,
		run_anim_event = "move_fwd",
		lunge_anim_event = "attack_lunge",
		move_to_cooldown = 0.075,
		enter_walk_distance = 5,
		effect_template = EffectTemplates.chaos_poxwalker_bomber_foley,
		stagger_type_reduction = {
			melee = -20,
			ranged = 20
		},
		running_stagger_anim_left = {
			"run_stagger_1",
			"run_stagger_2",
			"run_stagger_3"
		},
		running_stagger_anim_right = {
			"run_stagger_1",
			"run_stagger_2",
			"run_stagger_3"
		},
		running_stagger_duration = {
			run_stagger_3 = 1.4333333333333333,
			run_stagger_2 = 1.4333333333333333,
			run_stagger_1 = 1.3666666666666667
		}
	},
	explode = {
		explode_position_node = "j_spine2",
		utility_weight = 1,
		considerations = UtilityConsiderations.chaos_poxwalker_bomber_explode,
		explosion_template = ExplosionTemplates.poxwalker_bomber
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
					"stun_down"
				}
			},
			heavy = {
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
					"stun_down"
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
					"stun_down"
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
					"stun_down"
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
					"stun_down"
				}
			}
		}
	},
	smash_obstacle = {
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_01"
		},
		attack_anim_damage_timings = {
			attack_01 = 0.6
		},
		attack_anim_durations = {
			attack_01 = 1.2
		},
		attack_intensities = {
			ranged = 1,
			melee = 0.25
		},
		damage_profile = DamageProfileTemplates.default
	},
	open_door = {
		stagger_immune = true,
		open_door_time = 2.5,
		rotation_duration = 0.1
	},
	exit_spawner = {
		run_anim_event = "move_fwd"
	},
	teleport = {
		min_wait_time = 6,
		max_wait_time = 8
	}
}

return action_data
