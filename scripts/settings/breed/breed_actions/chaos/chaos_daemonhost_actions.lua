-- chunkname: @scripts/settings/breed/breed_actions/chaos/chaos_daemonhost_actions.lua

local ChaosDaemonhostSettings = require("scripts/settings/monster/chaos_daemonhost_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local STAGES = ChaosDaemonhostSettings.stages
local action_data = {
	name = "chaos_daemonhost",
	idle = {
		vo_event = "chaos_daemonhost_mantra_low",
		rotate_towards_target = true,
		anim_events = "idle"
	},
	death = {
		vo_event = "chaos_daemonhost_death_long",
		anim_events = {
			"death_01"
		},
		durations = {
			death_01 = 4.666666666666667
		},
		death_component_values = {
			damage_profile_name = "daemonhost_melee",
			hit_zone_name = "center_mass",
			attack_direction = Vector3Box(0, 0, 0)
		}
	},
	death_leave = {
		despawn_on_done = true,
		anim_events = {
			"leave"
		},
		durations = {
			leave = 3.8666666666666667
		},
		anim_driven_until = {
			leave = 2.2
		},
		death_component_values = {
			damage_profile_name = "daemonhost_melee",
			hit_zone_name = "center_mass",
			attack_direction = Vector3Box(0, 0, 0)
		},
		death_type_stage = STAGES.death_leave
	},
	warp_grab_teleport = {
		utility_weight = 10,
		considerations = UtilityConsiderations.chaos_daemonhost_warp_grab
	},
	warp_grab = {
		execute_duration = 4.9,
		execute_anim_event = "grab_execute",
		fire_from_node = "j_righthand",
		vo_event = "chaos_daemonhost_warp_grab",
		shoot_anim_event = "grab_start",
		fire_timing = 0.6666666666666666,
		execute_event_name = "wwise/events/minions/play_enemy_daemonhost_execute_player_impact",
		execute_distance = 3,
		channel_anim_event = "grab_loop",
		power_level = 1000,
		execute_husk_event_name = "wwise/events/minions/play_enemy_daemonhost_execute_player_impact_husk",
		execute_timing = 2.7666666666666666,
		start_execute_at_t = {
			6,
			5,
			5,
			3,
			2
		},
		effect_template = EffectTemplates.chaos_daemonhost_warp_grab,
		damage_profile = DamageProfileTemplates.daemonhost_grab,
		damage_type = damage_types.daemonhost_execute
	},
	warp_teleport = {
		wwise_teleport_in = "wwise/events/minions/play_enemy_daemonhost_teleport_in",
		utility_weight = 10,
		teleport_distance = 4,
		max_distance = 2,
		degree_per_direction = 10,
		wwise_teleport_out = "wwise/events/minions/play_enemy_daemonhost_teleport_out",
		considerations = UtilityConsiderations.chaos_daemonhost_warp_teleport,
		teleport_in_anim_events = {
			"teleport_in"
		},
		teleport_timings = {
			teleport_in = 0.5
		},
		teleport_out_anim_events = {
			"teleport_out"
		},
		teleport_finished_timings = {
			teleport_out = 0.6333333333333333
		}
	},
	passive = {
		nav_cost_map_sphere_cost = 20,
		nav_cost_map_sphere_radius = 5,
		on_leave_buff_name = "daemonhost_corruption_aura",
		stagger_immune = true,
		nav_cost_map_name = "daemonhost",
		spawn_anim_events = {
			"idle",
			"idle_2"
		},
		exit_passive = {
			player_vo_event = "alerted",
			anim_events = {
				idle = "to_alerted",
				idle_2 = "to_alerted_2"
			},
			durations = {
				to_alerted = 2.3333333333333335,
				to_alerted_2 = 2.2222222222222223
			},
			on_finished_anim_events = {
				"alerted_1"
			}
		},
		stage_settings = {
			[STAGES.passive] = {
				vo = {
					on_enter = {
						daemonhost = {
							vo_event = "chaos_daemonhost_mantra_low"
						}
					},
					looping = {
						vo_event = "chaos_daemonhost_mantra_low",
						cooldown_duration = {
							5,
							8
						}
					}
				}
			},
			[STAGES.agitated] = {
				reset_suppression = true,
				anim_events = {
					"alerted_0"
				},
				vo = {
					on_enter = {
						daemonhost = {
							vo_event = "chaos_daemonhost_mantra_medium"
						}
					},
					looping = {
						vo_event = "chaos_daemonhost_mantra_medium",
						cooldown_duration = {
							10,
							12
						}
					}
				}
			},
			[STAGES.disturbed] = {
				anim_events = {
					"alerted_1"
				},
				suppression = {
					distance = 2,
					suppression_value = 5
				},
				vo = {
					on_enter = {
						daemonhost = {
							vo_event = "chaos_daemonhost_mantra_medium"
						}
					},
					looping = {
						vo_event = "chaos_daemonhost_mantra_medium",
						cooldown_duration = {
							9,
							11
						}
					}
				}
			},
			[STAGES.about_to_wake_up] = {
				anim_events = {
					"alerted_2"
				},
				suppression = {
					distance = 5,
					suppression_value = 10
				},
				vo = {
					on_enter = {
						player = {
							vo_event = "alerted",
							is_non_threatening_player = true
						}
					},
					looping = {
						vo_event = "chaos_daemonhost_mantra_high",
						cooldown_duration = {
							8,
							9
						}
					}
				}
			},
			[STAGES.waking_up] = {
				trigger_health_bar = true,
				set_aggro_target = true,
				rotate_towards_target = true,
				damaged_health_percent = 0.95,
				anim_events = {
					default = "alerted_3",
					damaged = "alerted_3_short"
				},
				durations = {
					alerted_3 = 3.111111111111111,
					alerted_3_short = 1.4666666666666666
				},
				suppression = {
					distance = 10,
					suppression_value = 15
				},
				vo = {
					on_enter = {
						player = {
							vo_event = "aggroed"
						}
					},
					looping = {
						vo_event = "chaos_daemonhost_mantra_high",
						cooldown_duration = {
							9,
							11
						}
					}
				}
			}
		},
		anger_settings = {
			tick_interval = 1,
			stages = {
				[STAGES.passive] = -1,
				[STAGES.agitated] = 19,
				[STAGES.disturbed] = 59,
				[STAGES.about_to_wake_up] = 99,
				[STAGES.waking_up] = 100
			},
			decay = {
				[STAGES.passive] = 0,
				[STAGES.agitated] = 4,
				[STAGES.disturbed] = 3,
				[STAGES.about_to_wake_up] = 2,
				[STAGES.waking_up] = 0
			},
			health = {
				max = 100,
				missing_percent = 3
			},
			suppression = {
				suppressed = 100,
				factor = 6,
				max = 40
			},
			flashlight = {
				flat = 20,
				tick = 5
			}
		},
		flashlight_settings = {
			fx_trigger_delay = 4,
			range = 22,
			threat = 200,
			sfx_event = "wwise/events/minions/play_enemy_daemonhost_struggle_vce",
			look_at_rotation_speed = 2,
			look_at_angle = math.degrees_to_radians(10)
		},
		on_enter_buff_names = {
			"renegade_flamer_liquid_immunity",
			"cultist_flamer_liquid_immunity",
			"renegade_grenadier_liquid_immunity"
		}
	},
	climb = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_up_3m = 1.0256410256410255,
			jump_up_3m_2 = 3.051282051282051,
			jump_down_land = 1.3333333333333333,
			jump_up_1m_2 = 1.0303030303030303,
			jump_up_fence_1m = 0.5,
			jump_up_fence_3m = 0.9333333333333333,
			jump_up_5m = 1.3333333333333333,
			jump_up_fence_5m = 1,
			jump_up_1m = 0.7575757575757576
		},
		land_timings = {
			jump_down_1m_2 = 0.16666666666666666,
			jump_down_fence_3m = 0.5,
			jump_down_3m = 0.3333333333333333,
			jump_down_fence_5m = 0.5,
			jump_down_1m = 0.2,
			jump_down_3m_2 = 0.5,
			jump_down_fence_1m = 0.5
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
			jump_over_gap_4m = 1
		},
		ending_move_states = {
			jump_over_gap_4m_2 = "jumping",
			jump_over_gap_4m = "jumping"
		}
	},
	follow = {
		idle_anim_events = "idle",
		lean_variable_name = "lean",
		utility_weight = 1,
		max_dot_lean_value = 0.25,
		run_anim_event = "move_fwd",
		default_lean_value = 1,
		leave_walk_distance = 4,
		left_lean_value = 0,
		lean_speed = 2,
		walk_anim_event = "move_fwd",
		path_lean_node_offset = 8,
		right_lean_value = 2,
		enter_walk_distance = -1,
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
	warp_sweep = {
		utility_weight = 1,
		attack_move_speed = 3,
		hit_zone_name = "center_mass",
		power_level = 2000,
		num_nearby_units_threshold = 2,
		considerations = UtilityConsiderations.warp_sweep,
		attack_anim_events = {
			"push_sweep"
		},
		attack_anim_durations = {
			push_sweep = 1.3888888888888888
		},
		attack_anim_damage_timings = {
			push_sweep = 0.3611111111111111
		},
		suppression = {
			distance = 8,
			suppression_value = 200
		},
		damage_profile = DamageProfileTemplates.daemonhost_warp_sweep,
		damage_type = damage_types.daemonhost_melee,
		effect_template = EffectTemplates.chaos_daemonhost_warp_sweep,
		cooldown_duration = {
			1.5,
			2.5
		}
	},
	melee_attack = {
		ignore_backstab_sfx = true,
		utility_weight = 1,
		ignore_blocked = true,
		ignore_animation_movement_speed = true,
		weapon_reach = 3,
		attack_type = "sweep",
		collision_filter = "filter_minion_melee_friendly_fire",
		moving_attack = true,
		move_speed = 5,
		sweep_node = "j_lefthandmiddle1",
		hit_zone_name = "center_mass",
		considerations = UtilityConsiderations.daemonhost_melee,
		attack_anim_events = {
			normal = {
				"attack_move_01",
				"attack_move_02",
				"attack_move_03"
			},
			up = {
				"attack_up"
			},
			down = {
				"attack_down"
			}
		},
		attack_sweep_damage_timings = {
			attack_move_01 = {
				0.3466666666666667,
				0.64
			},
			attack_move_02 = {
				0.3466666666666667,
				0.6933333333333334
			},
			attack_move_03 = {
				0.8333333333333334,
				1
			},
			attack_up = {
				0.6666666666666666,
				0.9333333333333333
			},
			attack_down = {
				0.4666666666666667,
				0.6333333333333333
			}
		},
		attack_anim_durations = {
			attack_up = 1.8333333333333333,
			attack_move_03 = 1.4,
			attack_down = 1.3333333333333333,
			attack_move_02 = 1.12,
			attack_move_01 = 0.9866666666666667
		},
		attack_intensities = {
			ranged = 1,
			melee = 0.25
		},
		move_start_timings = {
			attack_up = 0,
			attack_move_03 = 0,
			attack_down = 0,
			attack_move_02 = 0,
			attack_move_01 = 0
		},
		damage_profile = DamageProfileTemplates.daemonhost_melee,
		offtarget_damage_profile = DamageProfileTemplates.daemonhost_offtarget_melee,
		damage_type = damage_types.daemonhost_melee,
		effect_template = EffectTemplates.chaos_daemonhost_warp_sweep,
		effect_template_start_timings = {
			attack_up = 0.5,
			attack_move_03 = 0.18666666666666668,
			attack_down = 0.4,
			attack_move_02 = 0.18666666666666668,
			attack_move_01 = 0.18666666666666668
		}
	},
	combo_attack = {
		ignore_backstab_sfx = true,
		ignore_animation_movement_speed = true,
		utility_weight = 10,
		ignore_blocked = true,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee_friendly_fire",
		height = 3,
		moving_attack = true,
		range = 4.5,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		move_speed = 5,
		rotation_speed = 12,
		hit_zone_name = "center_mass",
		width = 2,
		considerations = UtilityConsiderations.chaos_daemonhost_combo_attack,
		attack_anim_events = {
			"attack_combo_3"
		},
		attack_anim_damage_timings = {
			attack_combo = {
				1.0952380952380953,
				2.4523809523809526
			},
			attack_combo_2 = {
				0.6904761904761905,
				1.5
			},
			attack_combo_3 = {
				0.4,
				0.8666666666666667,
				1.2666666666666666,
				1.6,
				2.3333333333333335
			}
		},
		attack_anim_durations = {
			attack_combo_3 = 3.1333333333333333,
			attack_combo = 2.857142857142857,
			attack_combo_2 = 2.142857142857143
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 2,
			moving_melee = 1,
			ranged = 1
		},
		effect_template = EffectTemplates.chaos_daemonhost_warp_sweep,
		effect_template_start_timings = {
			attack_combo_3 = 0.36666666666666664,
			attack_combo = 0.9523809523809523,
			attack_combo_2 = 0.47619047619047616
		},
		move_start_timings = {
			attack_combo_3 = 0,
			attack_combo = 0,
			attack_combo_2 = 0
		},
		damage_profile = DamageProfileTemplates.daemonhost_melee_combo,
		offtarget_damage_profile = DamageProfileTemplates.daemonhost_offtarget_melee,
		damage_type = damage_types.daemonhost_melee,
		stagger_type_reduction = {
			ranged = 100
		},
		animation_move_speed_configs = {
			attack_combo = {
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
		player_vo = {
			vo_event = "combo_attack",
			is_non_threatening_player = false
		}
	},
	blocked = {
		blocked_duration = 1.6666666666666667,
		blocked_anims = {
			"blocked"
		}
	},
	stagger = {
		towards_impact_vector_rotation_overrides = {
			stagger_01 = true
		},
		stagger_anims = {
			light = {
				fwd = {
					"stagger_01"
				},
				bwd = {
					"stagger_01"
				},
				left = {
					"stagger_01"
				},
				right = {
					"stagger_01"
				},
				dwn = {
					"stagger_01"
				}
			},
			medium = {
				fwd = {
					"stagger_01"
				},
				bwd = {
					"stagger_01"
				},
				left = {
					"stagger_01"
				},
				right = {
					"stagger_01"
				},
				dwn = {
					"stagger_01"
				}
			},
			heavy = {
				fwd = {
					"stagger_01"
				},
				bwd = {
					"stagger_01"
				},
				left = {
					"stagger_01"
				},
				right = {
					"stagger_01"
				},
				dwn = {
					"stagger_01"
				}
			},
			light_ranged = {
				fwd = {
					"stagger_01"
				},
				bwd = {
					"stagger_01"
				},
				left = {
					"stagger_01"
				},
				right = {
					"stagger_01"
				}
			},
			explosion = {
				fwd = {
					"stagger_01"
				},
				bwd = {
					"stagger_01"
				},
				left = {
					"stagger_01"
				},
				right = {
					"stagger_01"
				}
			},
			killshot = {
				fwd = {
					"stagger_01"
				},
				bwd = {
					"stagger_01"
				},
				left = {
					"stagger_01"
				},
				right = {
					"stagger_01"
				},
				dwn = {
					"stagger_01"
				}
			},
			sticky = {
				fwd = {
					"stagger_01"
				},
				bwd = {
					"stagger_01"
				},
				left = {
					"stagger_01"
				},
				right = {
					"stagger_01"
				},
				dwn = {
					"stagger_01"
				}
			},
			electrocuted = {
				fwd = {
					"stagger_01"
				},
				bwd = {
					"stagger_01"
				},
				left = {
					"stagger_01"
				},
				right = {
					"stagger_01"
				},
				dwn = {
					"stagger_01"
				}
			},
			blinding = {
				fwd = {
					"stagger_01"
				},
				bwd = {
					"stagger_01"
				},
				left = {
					"stagger_01"
				},
				right = {
					"stagger_01"
				},
				dwn = {
					"stagger_01"
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
