-- chunkname: @scripts/settings/breed/breed_actions/chaos/chaos_hound_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local GroundImpactFxTemplates = require("scripts/settings/fx/ground_impact_fx_templates")
local damage_types = DamageSettings.damage_types
local action_data = {
	name = "chaos_hound",
	idle = {
		anim_events = "idle_bark"
	},
	death = {
		instant_ragdoll_chance = 1
	},
	leap = {
		wall_jump_unobstructed_height = 2.5,
		stop_duration = 0.5,
		land_impact_timing = 0,
		controlled_stagger_min_distance = 0,
		max_pounce_dot = 0.1,
		start_leap_anim_event_short = "attack_leap_short",
		wall_land_length = 3,
		start_leap_anim_event = "attack_leap_start",
		start_duration = 0.6666666666666666,
		push_enemies_radius = 1,
		wall_jump_anim_event = "leap_hit_wall",
		wall_jump_rotation_timing = 0.16666666666666666,
		push_minions_radius = 2,
		start_duration_short = 0.8,
		push_enemies_power_level = 2000,
		wall_land_anim_event = "leap_hit_wall_land",
		wall_land_duration = 0.5333333333333333,
		landing_duration = 1.5,
		controlled_stagger = true,
		start_move_speed = 12,
		wall_jump_speed = 10,
		aoe_bot_threat_duration = 1,
		wall_jump_nav_mesh_offset = 2,
		push_minions_side_relation = "allied",
		wall_jump_align_rotation_speed = 30,
		aoe_bot_threat_timing = 0.5,
		push_minions_power_level = 2000,
		in_air_stagger_duration = 0.9,
		land_anim_event = "leap_land",
		stop_anim = "run_to_stop",
		wall_jump_rotation_duration = 0.5333333333333333,
		stagger_type_reduction = {
			melee = -200,
			ranged = 20
		},
		push_minions_damage_profile = DamageProfileTemplates.chaos_hound_push,
		push_enemies_damage_profile = DamageProfileTemplates.chaos_hound_push,
		aoe_bot_threat_size = Vector3Box(1.5, 2, 2),
		in_air_staggers = {
			"stagger_inair_bwd"
		},
		land_ground_impact_fx_template = GroundImpactFxTemplates.chaos_hound_leap_land
	},
	approach_target = {
		too_close_distance = 1.5,
		trigger_player_alert_vo_distance = 20,
		max_dot_lean_value = 0.1,
		default_lean_value = 1,
		degree_per_direction = 10,
		left_lean_value = 0,
		lean_speed = 5,
		move_to_navmesh_raycast = true,
		controlled_stagger_max_distance = 6,
		running_stagger_anim_right = "stagger_running_right",
		rotation_speed = 20,
		trigger_player_alert_vo_frequency = 5,
		running_stagger_duration = 1.1666666666666667,
		min_distance_to_target = 6.5,
		running_stagger_anim_left = "stagger_running_left",
		path_lean_node_offset = 8,
		max_distance_to_target = 10,
		move_to_fail_cooldown = 0.5,
		randomized_direction_degree_range = 180,
		right_lean_value = 2,
		leave_distance = 16,
		lean_variable_name = "gallop_lean",
		speed = 10,
		controlled_stagger = true,
		start_move_anim_events = {
			bwd = "run_start_bwd",
			fwd = "run_start_fwd",
			left = "run_start_left",
			right = "run_start_right"
		},
		start_move_anim_data = {
			run_start_fwd = {},
			run_start_bwd = {
				sign = 1,
				rad = math.pi
			},
			run_start_left = {
				sign = 1,
				rad = math.pi / 2
			},
			run_start_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			run_start_right = 0.06666666666666667,
			run_start_left = 0.06666666666666667,
			run_start_bwd = 0.06666666666666667,
			run_start_fwd = 0.06666666666666667
		},
		start_rotation_durations = {
			run_start_right = 0.4666666666666667,
			run_start_left = 0.3333333333333333,
			run_start_bwd = 0.4666666666666667,
			run_start_fwd = 0.4666666666666667
		},
		start_move_event_anim_speed_durations = {
			run_start_fwd = 1.2666666666666666
		},
		idle_anim_events = {
			"idle"
		},
		move_to_cooldown = {
			0.6,
			1
		}
	},
	skulking = {
		right_lean_value = 2,
		max_dot_lean_value = 0.25,
		lean_variable_name = "gallop_lean",
		default_lean_value = 1,
		running_stagger_anim_right = "stagger_running_right",
		left_lean_value = 0,
		controlled_stagger_max_distance = 6,
		is_assaulting = true,
		running_stagger_duration = 1.1666666666666667,
		running_stagger_anim_left = "stagger_running_left",
		path_lean_node_offset = 8,
		controlled_stagger_min_speed = 2,
		speed = 10,
		rotation_speed = 10,
		controlled_stagger = true,
		start_move_anim_events = {
			bwd = "run_start_bwd",
			fwd = "run_start_fwd",
			left = "run_start_left",
			right = "run_start_right"
		},
		start_move_anim_data = {
			run_start_fwd = {},
			run_start_bwd = {
				sign = 1,
				rad = math.pi
			},
			run_start_left = {
				sign = 1,
				rad = math.pi / 2
			},
			run_start_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			run_start_right = 0.06666666666666667,
			run_start_left = 0.06666666666666667,
			run_start_bwd = 0.06666666666666667,
			run_start_fwd = 0.06666666666666667
		},
		start_rotation_durations = {
			run_start_right = 0.4666666666666667,
			run_start_left = 0.3333333333333333,
			run_start_bwd = 0.4666666666666667,
			run_start_fwd = 0.4666666666666667
		},
		start_move_event_anim_speed_durations = {
			run_start_fwd = 1.2666666666666666
		},
		idle_anim_events = {
			"idle"
		}
	},
	target_pounced = {
		hit_position_node = "j_jaw",
		tension_to_add = 20,
		explosion_power_level = 500,
		damage_frequency = 1.3333333333333333,
		lerp_position_time = 0.06666666666666667,
		damage_start_time = 1,
		pounce_anim_event = {
			human = "leap_attack",
			ogryn = "leap_attack_ogryn"
		},
		power_level = {
			75,
			100,
			125,
			150,
			175
		},
		impact_power_level = {
			200,
			225,
			250,
			275,
			300
		},
		damage_profile = DamageProfileTemplates.chaos_hound_pounce,
		initial_damage_profile = DamageProfileTemplates.chaos_hound_initial_pounce,
		damage_type = damage_types.chaos_hound_tearing,
		enter_explosion_template = ExplosionTemplates.chaos_hound_pounced_explosion,
		stagger_type_reduction = {
			melee = -30,
			ranged = 40
		}
	},
	climb = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_up_3m = 0.9333333333333333,
			jump_down_land_3m = 1.3333333333333333,
			jump_up_fence_1m = 0.8333333333333334,
			jump_down_fence_land_1m = 0.2,
			jump_down_land = 0.3333333333333333,
			jump_down_land_1m = 1.1666666666666667,
			jump_up_fence_3m = 0.8333333333333334,
			jump_up_5m = 1.4333333333333333,
			jump_up_fence_5m = 1.0333333333333334,
			jump_up_1m = 0.8666666666666667
		},
		ending_move_states = {
			jump_up_3m = "jumping",
			jump_down_fence_land_1m = "moving",
			jump_up_5m = "jumping",
			jump_down_land_5m = "jumping",
			jump_down_land_3m = "jumping",
			jump_down_land = "moving",
			jump_up_1m = "jumping",
			jump_down_land_1m = "moving"
		},
		blend_timings = {
			jump_up_3m = 0.1,
			jump_down_land_3m = 0,
			jump_down = 0,
			jump_down_fence_land_1m = 0,
			jump_down_2 = 0,
			jump_up_fence_1m = 0.1,
			jump_down_land = 0,
			jump_down_land_1m = 0,
			jump_up_fence_3m = 0.1,
			jump_up_5m = 0.1,
			jump_up_fence_5m = 0.1,
			jump_down_1m = 0,
			jump_up_1m = 0.1
		}
	},
	jump_across = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_vault_left_1 = 1,
			jump_over_gap_4m = 0.7333333333333333,
			jump_over_gap_4m_2 = 0.7333333333333333
		},
		ending_move_states = {
			jump_vault_left_1 = "moving",
			jump_over_gap_4m = "moving",
			jump_over_gap_4m_2 = "moving"
		}
	},
	stagger = {
		stagger_duration_mods = {
			stagger_fwd = 1.25
		},
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
					"hit_reaction_forward"
				},
				bwd = {
					"hit_reaction_backward"
				},
				left = {
					"hit_reaction_left"
				},
				right = {
					"hit_reaction_right"
				},
				dwn = {
					"hit_reaction_backward"
				}
			},
			electrocuted = {
				fwd = {
					"hit_reaction_forward"
				},
				bwd = {
					"hit_reaction_backward"
				},
				left = {
					"hit_reaction_left"
				},
				right = {
					"hit_reaction_right"
				},
				dwn = {
					"hit_reaction_backward"
				}
			},
			blinding = {
				fwd = {
					"hit_reaction_forward"
				},
				bwd = {
					"hit_reaction_backward"
				},
				left = {
					"hit_reaction_left"
				},
				right = {
					"hit_reaction_right"
				},
				dwn = {
					"hit_reaction_backward"
				}
			}
		}
	},
	open_door = {
		rotation_duration = 0.1,
		stagger_immune = true
	},
	exit_spawner = {
		run_anim_event = "run_start_fwd"
	}
}

return action_data
