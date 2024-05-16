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
		anim_events = "idle",
		rotate_towards_target = true,
		vo_event = "chaos_daemonhost_mantra_low",
	},
	death = {
		vo_event = "chaos_daemonhost_death_long",
		anim_events = {
			"death_01",
		},
		durations = {
			death_01 = 4.666666666666667,
		},
		death_component_values = {
			damage_profile_name = "daemonhost_melee",
			hit_zone_name = "center_mass",
			attack_direction = Vector3Box(0, 0, 0),
		},
	},
	death_leave = {
		despawn_on_done = true,
		anim_events = {
			"leave",
		},
		durations = {
			leave = 3.8666666666666667,
		},
		anim_driven_until = {
			leave = 2.2,
		},
		death_component_values = {
			damage_profile_name = "daemonhost_melee",
			hit_zone_name = "center_mass",
			attack_direction = Vector3Box(0, 0, 0),
		},
		death_type_stage = STAGES.death_leave,
	},
	warp_grab_teleport = {
		utility_weight = 10,
		considerations = UtilityConsiderations.chaos_daemonhost_warp_grab,
	},
	warp_grab = {
		channel_anim_event = "grab_loop",
		execute_anim_event = "grab_execute",
		execute_distance = 3,
		execute_duration = 4.9,
		execute_event_name = "wwise/events/minions/play_enemy_daemonhost_execute_player_impact",
		execute_husk_event_name = "wwise/events/minions/play_enemy_daemonhost_execute_player_impact_husk",
		execute_timing = 2.7666666666666666,
		fire_from_node = "j_righthand",
		fire_timing = 0.6666666666666666,
		power_level = 1000,
		shoot_anim_event = "grab_start",
		vo_event = "chaos_daemonhost_warp_grab",
		start_execute_at_t = {
			6,
			5,
			5,
			3,
			2,
		},
		effect_template = EffectTemplates.chaos_daemonhost_warp_grab,
		damage_profile = DamageProfileTemplates.daemonhost_grab,
		damage_type = damage_types.daemonhost_execute,
	},
	warp_teleport = {
		degree_per_direction = 10,
		max_distance = 2,
		teleport_distance = 4,
		utility_weight = 10,
		wwise_teleport_in = "wwise/events/minions/play_enemy_daemonhost_teleport_in",
		wwise_teleport_out = "wwise/events/minions/play_enemy_daemonhost_teleport_out",
		considerations = UtilityConsiderations.chaos_daemonhost_warp_teleport,
		teleport_in_anim_events = {
			"teleport_in",
		},
		teleport_timings = {
			teleport_in = 0.5,
		},
		teleport_out_anim_events = {
			"teleport_out",
		},
		teleport_finished_timings = {
			teleport_out = 0.6333333333333333,
		},
	},
	passive = {
		nav_cost_map_name = "daemonhost",
		nav_cost_map_sphere_cost = 20,
		nav_cost_map_sphere_radius = 5,
		on_leave_buff_name = "daemonhost_corruption_aura",
		stagger_immune = true,
		spawn_anim_events = {
			"idle",
			"idle_2",
		},
		exit_passive = {
			player_vo_event = "alerted",
			anim_events = {
				idle = "to_alerted",
				idle_2 = "to_alerted_2",
			},
			durations = {
				to_alerted = 2.3333333333333335,
				to_alerted_2 = 2.2222222222222223,
			},
			on_finished_anim_events = {
				"alerted_1",
			},
		},
		stage_settings = {
			[STAGES.passive] = {
				vo = {
					on_enter = {
						daemonhost = {
							vo_event = "chaos_daemonhost_mantra_low",
						},
					},
					looping = {
						vo_event = "chaos_daemonhost_mantra_low",
						cooldown_duration = {
							5,
							8,
						},
					},
				},
			},
			[STAGES.agitated] = {
				reset_suppression = true,
				anim_events = {
					"alerted_0",
				},
				vo = {
					on_enter = {
						daemonhost = {
							vo_event = "chaos_daemonhost_mantra_medium",
						},
					},
					looping = {
						vo_event = "chaos_daemonhost_mantra_medium",
						cooldown_duration = {
							10,
							12,
						},
					},
				},
			},
			[STAGES.disturbed] = {
				anim_events = {
					"alerted_1",
				},
				suppression = {
					distance = 2,
					suppression_value = 5,
				},
				vo = {
					on_enter = {
						daemonhost = {
							vo_event = "chaos_daemonhost_mantra_medium",
						},
					},
					looping = {
						vo_event = "chaos_daemonhost_mantra_medium",
						cooldown_duration = {
							9,
							11,
						},
					},
				},
			},
			[STAGES.about_to_wake_up] = {
				anim_events = {
					"alerted_2",
				},
				suppression = {
					distance = 5,
					suppression_value = 10,
				},
				vo = {
					on_enter = {
						player = {
							is_non_threatening_player = true,
							vo_event = "alerted",
						},
					},
					looping = {
						vo_event = "chaos_daemonhost_mantra_high",
						cooldown_duration = {
							8,
							9,
						},
					},
				},
			},
			[STAGES.waking_up] = {
				damaged_health_percent = 0.95,
				rotate_towards_target = true,
				set_aggro_target = true,
				trigger_health_bar = true,
				anim_events = {
					damaged = "alerted_3_short",
					default = "alerted_3",
				},
				durations = {
					alerted_3 = 3.111111111111111,
					alerted_3_short = 1.4666666666666666,
				},
				suppression = {
					distance = 10,
					suppression_value = 15,
				},
				vo = {
					on_enter = {
						player = {
							vo_event = "aggroed",
						},
					},
					looping = {
						vo_event = "chaos_daemonhost_mantra_high",
						cooldown_duration = {
							9,
							11,
						},
					},
				},
			},
		},
		anger_settings = {
			tick_interval = 1,
			stages = {
				[STAGES.passive] = -1,
				[STAGES.agitated] = 19,
				[STAGES.disturbed] = 59,
				[STAGES.about_to_wake_up] = 99,
				[STAGES.waking_up] = 100,
			},
			decay = {
				[STAGES.passive] = 0,
				[STAGES.agitated] = 4,
				[STAGES.disturbed] = 3,
				[STAGES.about_to_wake_up] = 2,
				[STAGES.waking_up] = 0,
			},
			health = {
				max = 100,
				missing_percent = 3,
			},
			suppression = {
				factor = 6,
				max = 40,
				suppressed = 100,
			},
			flashlight = {
				flat = 20,
				tick = 5,
			},
		},
		flashlight_settings = {
			fx_trigger_delay = 4,
			look_at_rotation_speed = 2,
			range = 22,
			sfx_event = "wwise/events/minions/play_enemy_daemonhost_struggle_vce",
			threat = 200,
			look_at_angle = math.degrees_to_radians(10),
		},
		on_enter_buff_names = {
			"renegade_flamer_liquid_immunity",
			"cultist_flamer_liquid_immunity",
			"renegade_grenadier_liquid_immunity",
		},
	},
	climb = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_down_land = 1.3333333333333333,
			jump_up_1m = 0.7575757575757576,
			jump_up_1m_2 = 1.0303030303030303,
			jump_up_3m = 1.0256410256410255,
			jump_up_3m_2 = 3.051282051282051,
			jump_up_5m = 1.3333333333333333,
			jump_up_fence_1m = 0.5,
			jump_up_fence_3m = 0.9333333333333333,
			jump_up_fence_5m = 1,
		},
		land_timings = {
			jump_down_1m = 0.2,
			jump_down_1m_2 = 0.16666666666666666,
			jump_down_3m = 0.3333333333333333,
			jump_down_3m_2 = 0.5,
			jump_down_fence_1m = 0.5,
			jump_down_fence_3m = 0.5,
			jump_down_fence_5m = 0.5,
		},
		ending_move_states = {
			jump_down_land = "jumping",
			jump_up_1m = "jumping",
			jump_up_1m_2 = "jumping",
			jump_up_3m = "jumping",
			jump_up_3m_2 = "jumping",
			jump_up_5m = "jumping",
		},
		blend_timings = {
			jump_down_1m = 0.1,
			jump_down_1m_2 = 0.1,
			jump_down_3m = 0.1,
			jump_down_3m_2 = 0.1,
			jump_down_land = 0,
			jump_up_1m = 0.1,
			jump_up_1m_2 = 0.1,
			jump_up_3m = 0.1,
			jump_up_3m_2 = 0.1,
			jump_up_5m = 0.1,
			jump_up_fence_1m = 0.2,
			jump_up_fence_3m = 0.2,
			jump_up_fence_5m = 0.2,
		},
	},
	jump_across = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_over_gap_4m = 1,
			jump_over_gap_4m_2 = 1.1333333333333333,
		},
		ending_move_states = {
			jump_over_gap_4m = "jumping",
			jump_over_gap_4m_2 = "jumping",
		},
	},
	follow = {
		default_lean_value = 1,
		enter_walk_distance = -1,
		idle_anim_events = "idle",
		lean_speed = 2,
		lean_variable_name = "lean",
		leave_walk_distance = 4,
		left_lean_value = 0,
		max_dot_lean_value = 0.25,
		path_lean_node_offset = 8,
		right_lean_value = 2,
		run_anim_event = "move_fwd",
		utility_weight = 1,
		walk_anim_event = "move_fwd",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			running = {
				bwd = "move_start_bwd",
				fwd = "move_start_fwd",
				left = "move_start_left",
				right = "move_start_right",
			},
		},
		start_move_anim_data = {
			move_start_fwd = {},
			move_start_bwd = {
				sign = -1,
				rad = math.pi,
			},
			move_start_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			move_start_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			move_start_bwd = 0,
			move_start_fwd = 0,
			move_start_left = 0,
			move_start_right = 0,
		},
		start_rotation_durations = {
			move_start_bwd = 0.26666666666666666,
			move_start_fwd = 0.26666666666666666,
			move_start_left = 0.26666666666666666,
			move_start_right = 0.26666666666666666,
		},
	},
	warp_sweep = {
		attack_move_speed = 3,
		hit_zone_name = "center_mass",
		num_nearby_units_threshold = 2,
		power_level = 2000,
		utility_weight = 1,
		considerations = UtilityConsiderations.warp_sweep,
		attack_anim_events = {
			"push_sweep",
		},
		attack_anim_durations = {
			push_sweep = 1.3888888888888888,
		},
		attack_anim_damage_timings = {
			push_sweep = 0.3611111111111111,
		},
		suppression = {
			distance = 8,
			suppression_value = 200,
		},
		damage_profile = DamageProfileTemplates.daemonhost_warp_sweep,
		damage_type = damage_types.daemonhost_melee,
		effect_template = EffectTemplates.chaos_daemonhost_warp_sweep,
		cooldown_duration = {
			1.5,
			2.5,
		},
	},
	melee_attack = {
		attack_type = "sweep",
		collision_filter = "filter_minion_melee_friendly_fire",
		hit_zone_name = "center_mass",
		ignore_animation_movement_speed = true,
		ignore_backstab_sfx = true,
		ignore_blocked = true,
		move_speed = 5,
		moving_attack = true,
		sweep_node = "j_lefthandmiddle1",
		utility_weight = 1,
		weapon_reach = 3,
		considerations = UtilityConsiderations.daemonhost_melee,
		attack_anim_events = {
			normal = {
				"attack_move_01",
				"attack_move_02",
				"attack_move_03",
			},
			up = {
				"attack_up",
			},
			down = {
				"attack_down",
			},
		},
		attack_sweep_damage_timings = {
			attack_move_01 = {
				0.3466666666666667,
				0.64,
			},
			attack_move_02 = {
				0.3466666666666667,
				0.6933333333333334,
			},
			attack_move_03 = {
				0.8333333333333334,
				1,
			},
			attack_up = {
				0.6666666666666666,
				0.9333333333333333,
			},
			attack_down = {
				0.4666666666666667,
				0.6333333333333333,
			},
		},
		attack_anim_durations = {
			attack_down = 1.3333333333333333,
			attack_move_01 = 0.9866666666666667,
			attack_move_02 = 1.12,
			attack_move_03 = 1.4,
			attack_up = 1.8333333333333333,
		},
		attack_intensities = {
			melee = 0.25,
			ranged = 1,
		},
		move_start_timings = {
			attack_down = 0,
			attack_move_01 = 0,
			attack_move_02 = 0,
			attack_move_03 = 0,
			attack_up = 0,
		},
		damage_profile = DamageProfileTemplates.daemonhost_melee,
		offtarget_damage_profile = DamageProfileTemplates.daemonhost_offtarget_melee,
		damage_type = damage_types.daemonhost_melee,
		effect_template = EffectTemplates.chaos_daemonhost_warp_sweep,
		effect_template_start_timings = {
			attack_down = 0.4,
			attack_move_01 = 0.18666666666666668,
			attack_move_02 = 0.18666666666666668,
			attack_move_03 = 0.18666666666666668,
			attack_up = 0.5,
		},
	},
	combo_attack = {
		attack_type = "oobb",
		collision_filter = "filter_minion_melee_friendly_fire",
		height = 3,
		hit_zone_name = "center_mass",
		ignore_animation_movement_speed = true,
		ignore_backstab_sfx = true,
		ignore_blocked = true,
		move_speed = 5,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		range = 4.5,
		rotation_speed = 12,
		utility_weight = 10,
		width = 2,
		considerations = UtilityConsiderations.chaos_daemonhost_combo_attack,
		attack_anim_events = {
			"attack_combo_3",
		},
		attack_anim_damage_timings = {
			attack_combo = {
				1.0952380952380953,
				2.4523809523809526,
			},
			attack_combo_2 = {
				0.6904761904761905,
				1.5,
			},
			attack_combo_3 = {
				0.4,
				0.8666666666666667,
				1.2666666666666666,
				1.6,
				2.3333333333333335,
			},
		},
		attack_anim_durations = {
			attack_combo = 2.857142857142857,
			attack_combo_2 = 2.142857142857143,
			attack_combo_3 = 3.1333333333333333,
		},
		attack_intensities = {
			melee = 0.25,
			moving_melee = 1,
			ranged = 1,
			running_melee = 2,
		},
		effect_template = EffectTemplates.chaos_daemonhost_warp_sweep,
		effect_template_start_timings = {
			attack_combo = 0.9523809523809523,
			attack_combo_2 = 0.47619047619047616,
			attack_combo_3 = 0.36666666666666664,
		},
		move_start_timings = {
			attack_combo = 0,
			attack_combo_2 = 0,
			attack_combo_3 = 0,
		},
		damage_profile = DamageProfileTemplates.daemonhost_melee_combo,
		offtarget_damage_profile = DamageProfileTemplates.daemonhost_offtarget_melee,
		damage_type = damage_types.daemonhost_melee,
		stagger_type_reduction = {
			ranged = 100,
		},
		animation_move_speed_configs = {
			attack_combo = {
				{
					distance = 5.47,
					value = 4,
				},
				{
					distance = 4.08,
					value = 3,
				},
				{
					distance = 3.04,
					value = 2,
				},
				{
					distance = 1.86,
					value = 1,
				},
				{
					distance = 0.95,
					value = 0,
				},
			},
		},
		player_vo = {
			is_non_threatening_player = false,
			vo_event = "combo_attack",
		},
	},
	blocked = {
		blocked_duration = 1.6666666666666667,
		blocked_anims = {
			"blocked",
		},
	},
	stagger = {
		towards_impact_vector_rotation_overrides = {
			stagger_01 = true,
		},
		stagger_anims = {
			light = {
				fwd = {
					"stagger_01",
				},
				bwd = {
					"stagger_01",
				},
				left = {
					"stagger_01",
				},
				right = {
					"stagger_01",
				},
				dwn = {
					"stagger_01",
				},
			},
			medium = {
				fwd = {
					"stagger_01",
				},
				bwd = {
					"stagger_01",
				},
				left = {
					"stagger_01",
				},
				right = {
					"stagger_01",
				},
				dwn = {
					"stagger_01",
				},
			},
			heavy = {
				fwd = {
					"stagger_01",
				},
				bwd = {
					"stagger_01",
				},
				left = {
					"stagger_01",
				},
				right = {
					"stagger_01",
				},
				dwn = {
					"stagger_01",
				},
			},
			light_ranged = {
				fwd = {
					"stagger_01",
				},
				bwd = {
					"stagger_01",
				},
				left = {
					"stagger_01",
				},
				right = {
					"stagger_01",
				},
			},
			explosion = {
				fwd = {
					"stagger_01",
				},
				bwd = {
					"stagger_01",
				},
				left = {
					"stagger_01",
				},
				right = {
					"stagger_01",
				},
			},
			killshot = {
				fwd = {
					"stagger_01",
				},
				bwd = {
					"stagger_01",
				},
				left = {
					"stagger_01",
				},
				right = {
					"stagger_01",
				},
				dwn = {
					"stagger_01",
				},
			},
			sticky = {
				fwd = {
					"stagger_01",
				},
				bwd = {
					"stagger_01",
				},
				left = {
					"stagger_01",
				},
				right = {
					"stagger_01",
				},
				dwn = {
					"stagger_01",
				},
			},
			electrocuted = {
				fwd = {
					"stagger_01",
				},
				bwd = {
					"stagger_01",
				},
				left = {
					"stagger_01",
				},
				right = {
					"stagger_01",
				},
				dwn = {
					"stagger_01",
				},
			},
			blinding = {
				fwd = {
					"stagger_01",
				},
				bwd = {
					"stagger_01",
				},
				left = {
					"stagger_01",
				},
				right = {
					"stagger_01",
				},
				dwn = {
					"stagger_01",
				},
			},
		},
	},
	smash_obstacle = {
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_01",
			"attack_02",
			"attack_03",
		},
		attack_anim_damage_timings = {
			attack_01 = 1.264367816091954,
			attack_02 = 1.264367816091954,
			attack_03 = 1.1954022988505748,
			attack_04 = 0.6,
			attack_05 = 0.6,
			attack_06 = 0.6,
			attack_07 = 0.6,
		},
		attack_anim_durations = {
			attack_01 = 2.413793103448276,
			attack_02 = 2.5977011494252875,
			attack_03 = 2.9885057471264367,
			attack_04 = 1.728395061728395,
			attack_05 = 2.0987654320987654,
			attack_06 = 1.7241379310344827,
			attack_07 = 2.0987654320987654,
		},
		damage_profile = DamageProfileTemplates.melee_fighter_default,
	},
	open_door = {
		rotation_duration = 0.1,
		stagger_immune = true,
	},
	exit_spawner = {
		run_anim_event = "move_fwd",
	},
}

return action_data
