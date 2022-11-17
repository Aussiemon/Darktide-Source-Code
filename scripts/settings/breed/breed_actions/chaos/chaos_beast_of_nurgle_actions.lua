local BreedShootTemplates = require("scripts/settings/breed/breed_shoot_templates")
local ChaosBeastOfNurgleSettings = require("scripts/settings/monster/chaos_beast_of_nurgle_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local GroundImpactFxTemplates = require("scripts/settings/fx/ground_impact_fx_templates")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local action_data = {
	name = "chaos_beast_of_nurgle",
	idle = {
		anim_events = "idle"
	},
	death = {
		explosion_template_power_level = 1,
		explosion_timing = 3,
		instant_ragdoll_chance = 0,
		force_death_animation = true,
		explode_position_node = "j_spine",
		ignore_hit_during_death_ragdoll = true,
		death_animations = {
			default = {
				"death_explode_01"
			}
		},
		death_timings = {
			death_explode_01 = 3.3333333333333335
		},
		specific_gib_settings = {
			random_radius = 2,
			hit_zones = {
				"torso",
				"head",
				"tongue",
				"lower_left_arm",
				"lower_right_arm"
			},
			damage_profile = DamageProfileTemplates.beast_of_nurgle_self_gib
		},
		explosion_template = ExplosionTemplates.beast_of_nurgle_death
	},
	movement = {
		max_distance_to_target = 3.5,
		min_distance_to_target = 3,
		utility_weight = 1,
		idle_anim_events = "idle",
		wanted_distance = 5,
		push_enemies_radius = 2.25,
		degree_per_direction = 10,
		push_nearby_players_frequency = 0.5,
		walk_anim_event = "walk_fwd",
		push_enemies_power_level = 2000,
		move_to_fail_cooldown = 0.05,
		randomized_direction_degree_range = 25,
		run_anim_event = "move_fwd",
		rotation_speed = 6,
		move_to_cooldown = 0.1,
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
			move_start_bwd = 0,
			move_start_left = 0.16666666666666666
		},
		start_rotation_durations = {
			move_start_right = 0.4,
			move_start_fwd = 0,
			move_start_bwd = 1.3333333333333333,
			move_start_left = 0.4
		},
		push_enemies_damage_profile = DamageProfileTemplates.beast_of_nurgle_push_players
	},
	align = {
		rotation_speed = 8,
		align_anim_events = {
			bwd = "turn_bwd",
			fwd = "move_start_fwd",
			left = "turn_left",
			right = "turn_right"
		},
		start_move_anim_data = {
			move_start_fwd = {},
			turn_bwd = {
				sign = 1,
				rad = math.pi
			},
			turn_left = {
				sign = 1,
				rad = math.pi / 2
			},
			turn_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			turn_left = 0,
			turn_bwd = 0,
			move_start_fwd = 0,
			turn_right = 0
		},
		start_rotation_durations = {
			turn_left = 1,
			turn_bwd = 1.3333333333333333,
			move_start_fwd = 0,
			turn_right = 1
		}
	},
	change_target = {
		rotation_speed = 6,
		rotate_towards_target_on_fwd = true,
		dont_set_moving_move_state = true,
		change_target_anim_events = {
			bwd = "change_target_bwd",
			fwd = "change_target_fwd",
			left = "change_target_left",
			right = "change_target_right"
		},
		change_target_anim_data = {
			change_target_fwd = {},
			change_target_bwd = {
				sign = -1,
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
			change_target_right = 1.7666666666666666,
			change_target_fwd = 1.7666666666666666,
			change_target_left = 1.7666666666666666,
			change_target_bwd = 1.7666666666666666
		},
		change_target_event_anim_speed_durations = {
			change_target_fwd = 1.7666666666666666
		}
	},
	alerted = {
		rotation_speed = 8,
		dont_set_moving_move_state = true,
		align_anim_events = {
			bwd = "turn_bwd",
			fwd = "alerted_fwd",
			left = "turn_left",
			right = "turn_right"
		},
		start_move_anim_data = {
			alerted_fwd = {},
			turn_bwd = {
				sign = 1,
				rad = math.pi
			},
			turn_left = {
				sign = 1,
				rad = math.pi / 2
			},
			turn_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			turn_left = 0,
			turn_bwd = 0,
			turn_right = 0,
			alerted_fwd = 0
		},
		start_rotation_durations = {
			turn_left = 1,
			turn_bwd = 1.3333333333333333,
			turn_right = 1,
			alerted_fwd = 0
		},
		align_durations = {
			alerted_fwd = 4
		},
		align_rotation_durations = {
			alerted_fwd = 1.0666666666666667
		}
	},
	fast_movement = {
		idle_anim_events = "idle",
		utility_weight = 1,
		min_distance_to_target = 0.25,
		done_on_arrival = true,
		wanted_distance = 5,
		push_enemies_radius = 2.25,
		degree_per_direction = 10,
		push_nearby_players_frequency = 0.5,
		max_distance_to_target = 1,
		walk_anim_event = "walk_fwd",
		push_enemies_power_level = 2000,
		move_speed = 6,
		move_to_target_absolute_position = false,
		move_to_fail_cooldown = 0.1,
		randomized_direction_degree_range = 20,
		run_anim_event = "move_fwd",
		rotation_speed = 8,
		move_to_cooldown = 0.2,
		considerations = UtilityConsiderations.melee_follow,
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
			run_start_right = 0.16666666666666666,
			run_start_left = 0.16666666666666666,
			run_start_bwd = 0,
			run_start_fwd = 0
		},
		start_rotation_durations = {
			run_start_right = 0.4,
			run_start_left = 0.4,
			run_start_bwd = 1.3333333333333333,
			run_start_fwd = 0
		},
		push_enemies_damage_profile = DamageProfileTemplates.beast_of_nurgle_push_players
	},
	vomit = {
		sphere_cast_frequency = 0.2,
		attack_intensity_type = "ranged",
		max_liquid_paint_distance = 6,
		liquid_paint_id_from_component = "vomit_liquid_paint_id",
		collision_filter = "filter_minion_shooting_no_friendly_fire",
		range_percentage_front = 0.5,
		attack_duration = 1.2,
		place_liquid_timing_speed = 20,
		vo_event = "start_shooting",
		attack_finished_grace_period = 0.35,
		dont_follow_target = true,
		push_minions_radius = 2,
		on_screen_effect = "content/fx/particles/screenspace/screen_corruptor_distortion",
		aoe_bot_threat_timing = 0.05,
		on_hit_buff = "chaos_beast_of_nurgle_hit_by_vomit",
		aoe_bot_threat_duration = 1.5,
		push_minions_side_relation = "allied",
		ground_normal_rotation = true,
		exit_after_cooldown = true,
		push_minions_power_level = 2000,
		rotation_speed = 5,
		range_back = 2.75,
		liquid_paint_brush_size = 2,
		only_apply_buff_once = true,
		aim_anim_events = {
			"attack_vomit_start"
		},
		aim_duration = {
			attack_vomit_start = 0.5
		},
		aim_stances = {
			attack_vomit_start = "standing"
		},
		end_anim_events = {
			"attack_vomit_end"
		},
		end_durations = {
			attack_vomit_end = 0.5
		},
		attack_intensities = {
			ranged = 50,
			elite_ranged = 50
		},
		effect_template = EffectTemplates.chaos_beast_of_nurgle_vomit,
		from_node = ChaosBeastOfNurgleSettings.from_node,
		range = ChaosBeastOfNurgleSettings.range,
		min_range = ChaosBeastOfNurgleSettings.min_range,
		radius = ChaosBeastOfNurgleSettings.radius,
		dodge_radius = ChaosBeastOfNurgleSettings.dodge_radius,
		liquid_area_template = LiquidAreaTemplates.beast_of_nurgle_slime,
		shoot_template = BreedShootTemplates.chaos_beast_of_nurgle_default,
		trajectory_config = ChaosBeastOfNurgleSettings.trajectory_config,
		damage_type = damage_types.minion_vomit,
		stagger_type_reduction = {
			ranged = 20,
			killshot = 20
		},
		push_minions_damage_profile = DamageProfileTemplates.beast_of_nurgle_push_minion,
		aoe_bot_threat_size = Vector3Box(2.5, 8, 3)
	},
	consume = {
		degree_per_throw_direction = 20,
		after_throw_taunt_duration = 1.6666666666666667,
		after_throw_taunt_anim = "change_target_fwd",
		exit_after_consume = true,
		throw_test_distance = 8,
		consume_node = "j_righthand",
		consume_target_node = "j_hips",
		consume_check_radius = 2.75,
		max_tongue_length = 10,
		tongue_length_variable_name = "tongue_length",
		rotation_speed = 6,
		consume_anims = {
			human = "attack_grab_start",
			ogryn = "attack_grab_start"
		},
		consume_timing = {
			human = 0.43333333333333335,
			ogryn = 0.43333333333333335
		},
		drag_in_anims = {
			human = "attack_grab_eat_human",
			ogryn = "attack_grab_eat_ogryn"
		},
		consume_durations = {
			human = 4.1,
			ogryn = 4.766666666666667
		},
		damage_timings = {
			human = {
				1,
				1.2,
				1.4
			},
			ogryn = {
				1,
				1.3333333333333333,
				1.5,
				1.8666666666666667
			}
		},
		anim_data = {
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
		start_rotation_timings = {
			move_start_right = 1.2666666666666666,
			move_start_fwd = 0,
			move_start_bwd = 1.6666666666666667,
			move_start_left = 1.3333333333333333
		},
		throw_anims = {
			human = {
				bwd = "move_start_bwd",
				fwd = "move_start_fwd",
				left = "move_start_left",
				right = "move_start_right"
			},
			ogryn = {
				bwd = "move_start_bwd",
				fwd = "move_start_fwd",
				left = "move_start_left",
				right = "move_start_right"
			}
		},
		throw_timing = {
			human = 1.3333333333333333,
			ogryn = 1.3333333333333333
		},
		throw_duration = {
			human = 1.6666666666666667,
			ogryn = 2.3333333333333335
		},
		catapult_force = {
			human = 13,
			ogryn = 10
		},
		catapult_z_force = {
			human = 3,
			ogryn = 4
		},
		power_level = {
			70,
			100,
			120,
			150,
			200
		},
		damage_profile = DamageProfileTemplates.beast_of_nurgle_hit_by_vomit,
		damage_type = {
			human = damage_types.minion_vomit,
			ogryn = damage_types.minion_vomit
		},
		attack_intensities = {
			melee = 20,
			running_melee = 20,
			elite_ranged = 20,
			ranged = 20,
			moving_melee = 20
		}
	},
	consume_minion = {
		tongue_out_anim = "attack_grab_start_minion",
		tongue_in_anim = "attack_grab_eat_minion",
		consumed_minion_anim = "death_bon_eaten",
		max_tongue_length = 10,
		tongue_length_variable_name = "tongue_length",
		rotation_speed = 6,
		health_percent_threshold = 1,
		num_nearby_units_threshold = 1,
		tongue_out_durations = {
			attack_grab_start_minion = 0.4666666666666667
		},
		tongue_in_durations = {
			attack_grab_eat_minion = 3
		},
		consume_durations = {
			attack_grab_eat_minion = 2.5
		},
		heal_durations = {
			attack_grab_eat_minion = 2
		},
		heal_amount = {
			100,
			200,
			300,
			500
		},
		cooldown = {
			15,
			10,
			8,
			8
		},
		effect_template = EffectTemplates.chaos_beast_of_nurgle_consume_minion
	},
	spit_out = {
		after_throw_taunt_anim = "change_target_fwd",
		after_throw_taunt_duration = 1.7666666666666666,
		throw_test_distance = 13,
		rotation_speed = 10,
		degree_per_throw_direction = 20,
		anim_data = {
			move_start_fwd = {},
			turn_bwd = {
				sign = 1,
				rad = math.pi
			},
			turn_left = {
				sign = 1,
				rad = math.pi / 2
			},
			turn_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_rotation_timings = {
			turn_left = 0,
			turn_bwd = 0,
			move_start_fwd = 0,
			turn_right = 0
		},
		start_rotation_durations = {
			turn_left = 1,
			turn_bwd = 1.3333333333333333,
			move_start_fwd = 0,
			turn_right = 1
		},
		throw_anims = {
			human = "spit_out_player",
			ogryn = "spit_out_player"
		},
		align_anims = {
			bwd = "turn_bwd",
			fwd = "move_start_fwd",
			left = "turn_left",
			right = "turn_right"
		},
		throw_timing = {
			human = 0.7,
			ogryn = 0.7
		},
		throw_duration = {
			human = 1.5666666666666667,
			ogryn = 1.5666666666666667
		},
		align_duration = {
			turn_left = 1,
			turn_bwd = 1.3333333333333333,
			move_start_fwd = 0.3333333333333333,
			turn_right = 1
		},
		catapult_force = {
			human = 13,
			ogryn = 12
		},
		catapult_z_force = {
			human = 3,
			ogryn = 4
		},
		required_permanent_damage_taken_percent = {
			0.25,
			0.35,
			0.5,
			0.5,
			0.65
		}
	},
	run_away = {
		move_anim_event = "assault_fwd",
		dont_rotate_towards_target = true,
		push_enemies_radius = 2.25,
		run_speed = 3.6,
		max_duration = 25,
		dont_push_consumed_unit = true,
		is_assaulting = true,
		ground_normal_rotation = true,
		leave_when_reached_destination = false,
		push_enemies_power_level = 2000,
		move_type = "combat_vector",
		push_nearby_players_frequency = 0.5,
		allow_fallback_movement = true,
		main_path_move_settings = {
			direction = "bwd",
			position_target_side_id = 1,
			min_distance = 2,
			travel_distance_random_range = {
				-20,
				-10
			},
			fallback_distance_random_range = {
				-10,
				0
			}
		},
		disable_nav_tag_layers = {
			"doors",
			"teleporters",
			"jumps",
			"ledges",
			"ledges_with_fence"
		},
		effect_template = EffectTemplates.chaos_beast_of_nurgle_weakspot,
		start_move_anim_events = {
			bwd = "move_start_bwd",
			fwd = "move_start_fwd",
			left = "move_start_left",
			right = "move_start_right"
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
			move_start_bwd = 0,
			move_start_left = 0.16666666666666666
		},
		start_rotation_durations = {
			move_start_right = 0.4,
			move_start_fwd = 0,
			move_start_bwd = 1.3333333333333333,
			move_start_left = 0.4
		},
		push_enemies_damage_profile = DamageProfileTemplates.beast_of_nurgle_push_players
	},
	climb = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_up_3m = 1.2333333333333334,
			jump_down_land_3m = 0.6666666666666666,
			jump_up_fence_1m = 0.7666666666666667,
			jump_down_fence_land_1m = 0.4666666666666667,
			jump_down_fence_land_2m = 0.4666666666666667,
			jump_down_fence_land_5m = 0.6666666666666666,
			jump_down_fence_land_3m = 0.5,
			jump_down_land_1m = 0.5,
			jump_up_fence_3m = 0.7666666666666667,
			jump_up_5m = 1.4333333333333333,
			jump_up_fence_5m = 0.8666666666666667,
			jump_up_fence_2m = 0.7666666666666667,
			jump_up_2m = 1.0333333333333334,
			jump_up_1m = 1.0333333333333334
		},
		ending_move_states = {
			jump_up_3m = "jumping",
			jump_down_land_3m = "jumping",
			jump_up_5m = "jumping",
			jump_down_fence_land_5m = "jumping",
			jump_down_land_1m = "jumping",
			jump_down_fence_land_1m = "jumping",
			jump_down_fence_land_2m = "jumping",
			jump_down_fence_land_3m = "jumping",
			jump_up_2m = "jumping",
			jump_up_1m = "jumping"
		},
		blend_timings = {
			jump_up_3m = 0.2,
			jump_down_land_3m = 0,
			jump_up_fence_1m = 0.2,
			jump_down_fence_land_1m = 0,
			jump_down_fence_land_2m = 0,
			jump_down_fence_land_5m = 0,
			jump_down_fence_land_3m = 0,
			jump_down_land_1m = 0,
			jump_down_3m = 0.4,
			jump_up_fence_3m = 0.2,
			jump_up_5m = 0.2,
			jump_up_fence_5m = 0.2,
			jump_up_fence_2m = 0.2,
			jump_up_2m = 0.2,
			jump_up_1m = 0.2,
			jump_down_1m = 0.4
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
			jump_over_gap_4m = 1.2666666666666666
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
	melee_attack_right = {
		radius = 5,
		utility_weight = 1,
		dont_rotate_towards_target = true,
		ignore_dodge = true,
		collision_filter = "filter_minion_melee_friendly_fire",
		sweep_width = 2,
		sweep_height = 0.25,
		sweep_length = 2,
		max_z_diff = 3,
		sweep_shape = "oobb",
		sweep_node = "j_tail_anim_05",
		dodge_weapon_reach = 0.35,
		up_z_threshold = 2.5,
		considerations = UtilityConsiderations.chaos_plague_ogryn_slam_attack,
		attack_anim_events = {
			"attack_tail_whip_right"
		},
		attack_sweep_damage_timings = {
			attack_tail_whip_right = {
				1.1388888888888888,
				1.5277777777777777
			}
		},
		attack_anim_durations = {
			attack_tail_whip_right = 1.9444444444444444
		},
		attack_intensities = {
			ranged = 5,
			running_melee = 2,
			elite_ranged = 4,
			melee = 0.25,
			moving_melee = 0.1
		},
		damage_profile = DamageProfileTemplates.beast_of_nurgle_tail_whip,
		friendly_fire_damage_profile = DamageProfileTemplates.beast_of_nurgle_melee_friendly_fire,
		damage_type = damage_types.minion_ogryn_kick,
		attack_type = {
			attack_tail_whip_right = "sweep"
		},
		weapon_reach = {
			default = 2
		},
		ground_impact_fx_template = GroundImpactFxTemplates.beast_of_nurgle_tail_whip
	},
	melee_attack_left = {
		radius = 5,
		utility_weight = 1,
		dont_rotate_towards_target = true,
		ignore_dodge = true,
		collision_filter = "filter_minion_melee_friendly_fire",
		sweep_width = 2,
		sweep_height = 0.25,
		sweep_length = 2,
		max_z_diff = 3,
		sweep_shape = "oobb",
		sweep_node = "j_tail_anim_05",
		dodge_weapon_reach = 0.35,
		up_z_threshold = 2.5,
		considerations = UtilityConsiderations.chaos_plague_ogryn_slam_attack,
		attack_anim_events = {
			"attack_tail_whip_left"
		},
		attack_sweep_damage_timings = {
			attack_tail_whip_left = {
				1.0277777777777777,
				1.2777777777777777
			}
		},
		attack_anim_durations = {
			attack_tail_whip_left = 1.9444444444444444
		},
		attack_intensities = {
			ranged = 5,
			running_melee = 2,
			elite_ranged = 4,
			melee = 0.25,
			moving_melee = 0.1
		},
		damage_profile = DamageProfileTemplates.beast_of_nurgle_tail_whip,
		friendly_fire_damage_profile = DamageProfileTemplates.beast_of_nurgle_melee_friendly_fire,
		damage_type = damage_types.minion_ogryn_kick,
		attack_type = {
			attack_tail_whip_left = "sweep"
		},
		weapon_reach = {
			default = 2
		},
		ground_impact_fx_template = GroundImpactFxTemplates.beast_of_nurgle_tail_whip
	},
	melee_attack_bwd = {
		height = 5,
		radius = 5,
		utility_weight = 1,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee_friendly_fire",
		range = 5,
		offset_bwd = 4,
		dont_rotate_towards_target = true,
		width = 4,
		considerations = UtilityConsiderations.chaos_plague_ogryn_slam_attack,
		attack_anim_events = {
			"attack_tail_slam"
		},
		attack_anim_damage_timings = {
			attack_tail_slam = 0.8181818181818182
		},
		attack_anim_durations = {
			attack_tail_slam = 1.5151515151515151
		},
		attack_intensities = {
			ranged = 5,
			running_melee = 2,
			elite_ranged = 4,
			melee = 0.25,
			moving_melee = 0.1
		},
		damage_profile = DamageProfileTemplates.beast_of_nurgle_tail_whip,
		friendly_fire_damage_profile = DamageProfileTemplates.beast_of_nurgle_melee_friendly_fire,
		damage_type = damage_types.minion_ogryn_kick,
		ground_impact_fx_template = GroundImpactFxTemplates.beast_of_nurgle_tail_whip
	},
	melee_attack_fwd_left = {
		radius = 4.25,
		utility_weight = 1,
		attack_type = "broadphase",
		collision_filter = "filter_minion_melee_friendly_fire",
		weapon_reach = 2,
		broadphase_node = "j_lefthand",
		dont_rotate_towards_target = true,
		dodge_weapon_reach = 1.5,
		considerations = UtilityConsiderations.chaos_plague_ogryn_slam_attack,
		attack_anim_events = {
			"attack_slam_left"
		},
		attack_anim_damage_timings = {
			attack_slam_left = 0.8787878787878788
		},
		attack_anim_durations = {
			attack_slam_left = 1.696969696969697
		},
		attack_intensities = {
			ranged = 5,
			running_melee = 2,
			elite_ranged = 4,
			melee = 0.25,
			moving_melee = 0.1
		},
		damage_profile = DamageProfileTemplates.beast_of_nurgle_tail_whip,
		friendly_fire_damage_profile = DamageProfileTemplates.beast_of_nurgle_melee_friendly_fire,
		damage_type = damage_types.minion_ogryn_kick,
		ground_impact_fx_template = GroundImpactFxTemplates.beast_of_nurgle_slam_left
	},
	melee_attack_fwd_right = {
		radius = 4.25,
		utility_weight = 1,
		attack_type = "broadphase",
		collision_filter = "filter_minion_melee_friendly_fire",
		weapon_reach = 2,
		broadphase_node = "j_righthand",
		dont_rotate_towards_target = true,
		dodge_weapon_reach = 1.5,
		considerations = UtilityConsiderations.chaos_plague_ogryn_slam_attack,
		attack_anim_events = {
			"attack_slam_right"
		},
		attack_anim_damage_timings = {
			attack_slam_right = 0.9696969696969697
		},
		attack_anim_durations = {
			attack_slam_right = 1.696969696969697
		},
		attack_intensities = {
			ranged = 5,
			running_melee = 2,
			elite_ranged = 4,
			melee = 0.25,
			moving_melee = 0.1
		},
		damage_profile = DamageProfileTemplates.beast_of_nurgle_tail_whip,
		friendly_fire_damage_profile = DamageProfileTemplates.beast_of_nurgle_melee_friendly_fire,
		damage_type = damage_types.minion_ogryn_kick,
		ground_impact_fx_template = GroundImpactFxTemplates.beast_of_nurgle_slam_right
	},
	melee_attack_body_slam_aoe = {
		radius = 4.75,
		utility_weight = 1,
		attack_type = "broadphase",
		collision_filter = "filter_minion_melee_friendly_fire",
		weapon_reach = 5.25,
		very_close_distance = 2,
		dont_rotate_towards_target = true,
		dodge_weapon_reach = 4.8,
		considerations = UtilityConsiderations.chaos_plague_ogryn_slam_attack,
		attack_anim_events = {
			"attack_body_slam"
		},
		attack_anim_damage_timings = {
			attack_body_slam = 0.9
		},
		attack_anim_durations = {
			attack_body_slam = 1.5666666666666667
		},
		attack_intensities = {
			ranged = 5,
			running_melee = 2,
			elite_ranged = 4,
			melee = 0.25,
			moving_melee = 0.1
		},
		damage_profile = DamageProfileTemplates.beast_of_nurgle_tail_whip,
		friendly_fire_damage_profile = DamageProfileTemplates.beast_of_nurgle_melee_friendly_fire,
		damage_type = damage_types.minion_ogryn_kick,
		ground_impact_fx_template = GroundImpactFxTemplates.beast_of_nurgle_body_slam_aoe
	},
	stagger = {
		stagger_anims = {
			light = {
				fwd = {
					"stagger_fwd_heavy"
				},
				bwd = {
					"stagger_fwd_heavy"
				},
				left = {
					"stagger_fwd_heavy"
				},
				right = {
					"stagger_fwd_heavy"
				},
				dwn = {
					"stagger_fwd_heavy"
				}
			},
			medium = {
				fwd = {
					"stagger_fwd_heavy"
				},
				bwd = {
					"stagger_fwd_heavy"
				},
				left = {
					"stagger_fwd_heavy"
				},
				right = {
					"stagger_fwd_heavy"
				},
				dwn = {
					"stagger_fwd_heavy"
				}
			},
			heavy = {
				fwd = {
					"stagger_spit_out_player"
				},
				bwd = {
					"stagger_spit_out_player"
				},
				left = {
					"stagger_spit_out_player"
				},
				right = {
					"stagger_spit_out_player"
				},
				dwn = {
					"stagger_spit_out_player"
				}
			},
			light_ranged = {
				fwd = {
					"stagger_fwd_heavy"
				},
				bwd = {
					"stagger_fwd_heavy"
				},
				left = {
					"stagger_fwd_heavy"
				},
				right = {
					"stagger_fwd_heavy"
				},
				dwn = {
					"stagger_fwd_heavy"
				}
			},
			explosion = {
				fwd = {
					"stagger_spit_out_player"
				},
				bwd = {
					"stagger_spit_out_player"
				},
				left = {
					"stagger_spit_out_player"
				},
				right = {
					"stagger_spit_out_player"
				},
				dwn = {
					"stagger_spit_out_player"
				}
			},
			killshot = {
				fwd = {
					"stagger_fwd_heavy"
				},
				bwd = {
					"stagger_fwd_heavy"
				},
				left = {
					"stagger_fwd_heavy"
				},
				right = {
					"stagger_fwd_heavy"
				},
				dwn = {
					"stagger_fwd_heavy"
				}
			},
			sticky = {
				fwd = {
					"stagger_fwd_heavy"
				},
				bwd = {
					"stagger_fwd_heavy"
				},
				left = {
					"stagger_fwd_heavy"
				},
				right = {
					"stagger_fwd_heavy"
				},
				dwn = {
					"stagger_fwd_heavy"
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
			"attack_sneeze"
		},
		attack_anim_damage_timings = {
			attack_sneeze = 0.7333333333333333
		},
		attack_anim_durations = {
			attack_sneeze = 2
		},
		damage_profile = DamageProfileTemplates.default
	},
	exit_spawner = {
		run_anim_event = "move_fwd"
	}
}
action_data.weakspot_stagger = table.clone(action_data.stagger)

return action_data
