local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GroundImpactFxTemplates = require("scripts/settings/fx/ground_impact_fx_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local action_data = {
	name = "chaos_spawn",
	idle = {
		anim_events = "idle"
	},
	death = {
		instant_ragdoll_chance = 1
	},
	change_target = {
		rotation_speed = 6,
		dont_set_moving_move_state = true,
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
			change_target_right = 1.3888888888888888,
			change_target_fwd = 0.9722222222222222,
			change_target_left = 1.3888888888888888,
			change_target_bwd = 1.3888888888888888
		},
		change_target_event_anim_speed_durations = {
			change_target_fwd = 0.9722222222222222
		}
	},
	leap = {
		start_move_speed = 1,
		push_minions_radius = 2,
		land_impact_timing = 0.16666666666666666,
		utility_weight = 1,
		push_enemies_radius = 2,
		aoe_bot_threat_duration = 1,
		start_leap_anim_event = "attack_leap_start",
		start_duration = 1.1111111111111112,
		push_minions_side_relation = "allied",
		aoe_bot_threat_timing = 0.5,
		gravity = 20,
		push_enemies_power_level = 2000,
		push_minions_power_level = 2000,
		landing_duration = 0.8333333333333334,
		speed = 18,
		land_anim_event = "attack_leap_land",
		considerations = UtilityConsiderations.chaos_spawn_leap,
		stagger_type_reduction = {
			melee = -20,
			ranged = 20
		},
		push_minions_damage_profile = DamageProfileTemplates.chaos_hound_push,
		push_enemies_damage_profile = DamageProfileTemplates.chaos_hound_push,
		aoe_bot_threat_size = Vector3Box(1.5, 2, 2),
		land_ground_impact_fx_template = GroundImpactFxTemplates.chaos_spawn_leap,
		catapult_units = {
			speed = 10,
			radius = 5,
			angle = math.pi / 6
		}
	},
	follow = {
		idle_anim_events = "idle",
		utility_weight = 1,
		enter_walk_distance = 0,
		leave_walk_distance = 4,
		run_anim_event = "move_fwd",
		walk_anim_event = "move_fwd",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			walking = {
				bwd = "walk_start_bwd",
				fwd = "walk_start_fwd",
				left = "walk_start_left",
				right = "walk_start_right"
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
			},
			walk_start_fwd = {},
			walk_start_bwd = {
				sign = -1,
				rad = math.pi
			},
			walk_start_left = {
				sign = 1,
				rad = math.pi / 2
			},
			walk_start_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			move_start_right = 0,
			move_start_fwd = 0,
			walk_start_fwd = 0,
			move_start_left = 0,
			walk_start_bwd = 0,
			walk_start_left = 0,
			move_start_bwd = 0,
			walk_start_right = 0
		},
		start_rotation_durations = {
			move_start_right = 0.9,
			move_start_fwd = 0,
			walk_start_fwd = 0,
			move_start_left = 0.9,
			walk_start_bwd = 0.7666666666666667,
			walk_start_left = 0.7,
			move_start_bwd = 0.9333333333333333,
			walk_start_right = 0.7666666666666667
		},
		start_move_event_anim_speed_durations = {
			walk_start_right = 0.7666666666666667,
			walk_start_fwd = 0.9333333333333333,
			walk_start_bwd = 0.7666666666666667,
			walk_start_left = 0.7,
			move_start_fwd = 0.9333333333333333
		}
	},
	climb = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_up_3m = 2.566666666666667,
			jump_down_land_3m = 1.5,
			jump_down_land_1m = 0.8333333333333334,
			jump_down_fence_land_1m = 0.5666666666666667,
			jump_down_land = 0.26666666666666666,
			jump_up_fence_1m = 0.36666666666666664,
			jump_up_fence_3m = 1,
			jump_up_5m = 2.7333333333333334,
			jump_up_fence_5m = 1.2,
			jump_up_2m = 2.066666666666667,
			jump_up_1m = 1.2333333333333334,
			jump_up_4m = 2.533333333333333
		},
		ending_move_states = {
			jump_up_3m = "jumping",
			jump_down_land_3m = "jumping",
			jump_down_land = "jumping",
			jump_down_land_1m = "jumping",
			jump_down_fence_land_1m = "jumping",
			jump_up_5m = "jumping",
			jump_down_land_5m = "jumping",
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
			jump_over_gap_4m = 1.4333333333333333
		},
		ending_move_states = {
			jump_over_gap_4m = "jumping"
		},
		blend_timings = {
			jump_over_gap_4m = 0.2
		}
	},
	claw_attack = {
		height = 5,
		ignore_blocked = true,
		utility_weight = 1,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee",
		range = 3.5,
		bot_power_level_modifier = 0.4,
		aoe_threat_timing = 0.4,
		width = 1.25,
		aoe_threat_duration = 0.75,
		considerations = UtilityConsiderations.chaos_spawn_claw_attack,
		attack_anim_events = {
			normal = {
				"attack_melee_claw"
			}
		},
		attack_anim_damage_timings = {
			attack_melee_claw = 0.5
		},
		attack_anim_durations = {
			attack_melee_claw = 0.9666666666666667
		},
		attack_intensities = {
			ranged = 5,
			running_melee = 2,
			elite_ranged = 4,
			melee = 0.25,
			moving_melee = 0.1
		},
		damage_profile = DamageProfileTemplates.chaos_spawn_claw,
		damage_type = damage_types.minion_monster_sharp,
		aoe_bot_threat_oobb_size = Vector3Box(1.5, 2.25, 2.5),
		ground_impact_fx_template = GroundImpactFxTemplates.chaos_spawn_claw
	},
	tentacle_attack = {
		utility_weight = 2.5,
		ignore_blocked = true,
		attack_type = "sweep",
		collision_filter = "filter_minion_melee_friendly_fire",
		rotate_towards_velocity_after_attack = true,
		move_speed_variable_lerp_speed = 4,
		weapon_reach = 1.5,
		move_speed_variable_name = "moving_attack_fwd_speed",
		sweep_node = "j_leftfinger4_jnt",
		rotation_speed = 5,
		ignore_dodge = true,
		dodge_weapon_reach = 0.35,
		considerations = UtilityConsiderations.chaos_spawn_tentacle_attack,
		attack_anim_events = {
			"attack_melee_sweep",
			"attack_melee_sweep_2"
		},
		attack_sweep_damage_timings = {
			attack_melee_sweep = {
				1,
				1.2
			},
			attack_melee_sweep_2 = {
				0.8666666666666667,
				1.0333333333333334
			}
		},
		attack_anim_durations = {
			attack_melee_sweep = 1.8333333333333333,
			attack_melee_sweep_2 = 1.7333333333333334
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 2,
			moving_melee = 1,
			ranged = 1
		},
		move_start_timings = {
			attack_catapult = 0
		},
		damage_profile = DamageProfileTemplates.chaos_spawn_tentacle,
		damage_type = {
			human = damage_types.minion_mutant_smash,
			ogryn = damage_types.minion_mutant_smash_ogryn
		},
		stagger_type_reduction = {
			ranged = 100,
			explosion = 100
		},
		animation_move_speed_configs = {
			attack_sword_combo = {
				{
					value = 4,
					distance = 8
				},
				{
					value = 3,
					distance = 6.4
				},
				{
					value = 2,
					distance = 4
				},
				{
					value = 1,
					distance = 2
				},
				{
					value = 0,
					distance = 0
				}
			}
		}
	},
	moving_tentacle_attack = {
		ignore_blocked = true,
		utility_weight = 2.5,
		weapon_reach = 1.5,
		attack_type = "sweep",
		dont_lock_slot_system = true,
		collision_filter = "filter_minion_melee_friendly_fire",
		rotate_towards_velocity_after_attack = true,
		moving_attack = true,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		sweep_node = "j_leftfinger4_jnt",
		rotation_speed = 5,
		ignore_dodge = true,
		dodge_weapon_reach = 0.35,
		considerations = UtilityConsiderations.chaos_spawn_tentacle_attack,
		attack_anim_events = {
			"attack_melee_sweep_move"
		},
		attack_sweep_damage_timings = {
			attack_melee_sweep_move = {
				0.8611111111111112,
				1.0277777777777777
			}
		},
		attack_anim_durations = {
			attack_melee_sweep_move = 1.6944444444444444
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 2,
			moving_melee = 1,
			ranged = 1
		},
		move_start_timings = {
			attack_catapult = 0
		},
		damage_profile = DamageProfileTemplates.chaos_spawn_tentacle,
		damage_type = damage_types.minion_monster_blunt,
		stagger_type_reduction = {
			ranged = 100,
			explosion = 100
		},
		animation_move_speed_configs = {
			attack_sword_combo = {
				{
					value = 4,
					distance = 8
				},
				{
					value = 3,
					distance = 6.4
				},
				{
					value = 2,
					distance = 4
				},
				{
					value = 1,
					distance = 2
				},
				{
					value = 0,
					distance = 0
				}
			}
		}
	},
	grab = {
		aoe_threat_timing = 0.4,
		degree_per_throw_direction = 20,
		after_throw_taunt_duration = 0,
		collision_filter = "filter_minion_melee",
		grab_node = "j_leftfinger4_jnt",
		dodge_grab_check_radius = 1,
		oobb_use_unit_rotation = true,
		range = 2,
		bot_power_level_modifier = 0.4,
		ignore_blocked = true,
		grab_target_node = "j_hips",
		width = 2,
		aoe_threat_duration = 0.75,
		height = 2,
		utility_weight = 10,
		cooldown = 30,
		check_for_smash_radius = 3,
		attack_type = "oobb",
		throw_test_distance = 8,
		grab_check_radius = 2.25,
		oobb_node = "j_leftfinger4_jnt",
		rotation_speed = 6,
		after_throw_taunt_anim = "change_target_fwd",
		considerations = UtilityConsiderations.chaos_spawn_grab_attack,
		grab_anims = {
			human = "attack_grab",
			ogryn = "attack_grab"
		},
		drag_in_anims = {
			human = "attack_grab_player",
			ogryn = "attack_grab_player_ogryn"
		},
		grab_timings = {
			human = 0.8,
			ogryn = 0.8
		},
		total_grab_durations = {
			human = 10.666666666666666,
			ogryn = 10.666666666666666
		},
		grab_durations = {
			human = 1.6666666666666667,
			ogryn = 1.6666666666666667
		},
		smash_anims = {
			human = "attack_grabbed_smash",
			ogryn = "attack_grabbed_smash"
		},
		smash_durations = {
			human = 1.8333333333333333,
			ogryn = 1.5
		},
		smash_timings = {
			human = {
				0.5,
				1,
				1.4333333333333333
			},
			ogryn = {
				1.0333333333333334
			}
		},
		damage_profile = DamageProfileTemplates.chaos_spawn_tentacle,
		damage_type = damage_types.minion_monster_blunt,
		aoe_bot_threat_oobb_size = Vector3Box(1.5, 2.25, 2.5),
		ground_impact_fx_template = GroundImpactFxTemplates.chaos_spawn_tentacle,
		damage_timings = {
			human = {
				5.533333333333333,
				8.033333333333333,
				10.533333333333333
			},
			ogryn = {
				5.533333333333333,
				8.033333333333333,
				10.533333333333333
			}
		},
		anim_data = {
			attack_grabbed_throw = {},
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
			move_start_left = 1.3333333333333333,
			move_start_bwd = 1.6666666666666667,
			attack_grabbed_throw = 0
		},
		throw_anims = {
			human = {
				bwd = "attack_grabbed_throw",
				fwd = "attack_grabbed_throw",
				left = "attack_grabbed_throw",
				right = "attack_grabbed_throw"
			},
			ogryn = {
				bwd = "attack_grabbed_throw",
				fwd = "attack_grabbed_throw",
				left = "attack_grabbed_throw",
				right = "attack_grabbed_throw"
			}
		},
		throw_timing = {
			human = 1.3333333333333333,
			ogryn = 1
		},
		throw_duration = {
			human = 2.1666666666666665,
			ogryn = 2
		},
		catapult_force = {
			human = 14,
			ogryn = 12
		},
		catapult_z_force = {
			human = 3,
			ogryn = 4
		},
		power_level = {
			120,
			150,
			200,
			250,
			300
		},
		heal_amount = {
			200,
			300,
			450,
			600,
			750
		},
		eat_damage_profile = DamageProfileTemplates.beast_of_nurgle_hit_by_vomit,
		eat_damage_type = {
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
	combo_attack = {
		ignore_blocked = true,
		utility_weight = 8,
		attack_type = "sweep",
		collision_filter = "filter_minion_melee",
		aoe_threat_timing = 0,
		moving_attack = true,
		bot_power_level_modifier = 0.5,
		aoe_bot_threat_sweep_reach = 5,
		weapon_reach = 2,
		move_speed = 4,
		sweep_node = "j_righthandmiddle1",
		rotation_speed = 5,
		dodge_weapon_reach = 1.25,
		aoe_threat_duration = 2.074074074074074,
		considerations = UtilityConsiderations.chaos_spawn_combo_attack,
		attack_anim_events = {
			"attack_melee_combo",
			"attack_melee_combo_2"
		},
		attack_anim_durations = {
			attack_melee_combo_2 = 1.8055555555555556,
			attack_melee_combo = 1.8333333333333333
		},
		attack_sweep_damage_timings = {
			attack_melee_combo = {
				{
					0.3333333333333333,
					0.4666666666666667
				},
				{
					0.7333333333333333,
					0.8666666666666667,
					"j_leftfinger3_jnt"
				},
				{
					1.1666666666666667,
					1.3
				},
				{
					1.5666666666666667,
					1.7,
					"j_leftfinger3_jnt"
				}
			},
			attack_melee_combo_2 = {
				{
					0.4444444444444444,
					0.5555555555555556
				},
				{
					1.0555555555555556,
					1.1666666666666667,
					"j_leftfinger3_jnt"
				},
				{
					1.6111111111111112,
					1.7222222222222223
				}
			}
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 2,
			moving_melee = 1,
			ranged = 1
		},
		move_start_timings = {
			attack_melee_combo_2 = 0.7222222222222222,
			attack_melee_combo = 0.8666666666666667
		},
		damage_profile = DamageProfileTemplates.chaos_spawn_combo,
		damage_type = damage_types.minion_monster_sharp,
		attack_override_damage_data = {
			attack_melee_combo = {
				[2] = {
					override_damage_type = damage_types.minion_monster_blunt
				},
				[4] = {
					override_damage_type = damage_types.minion_monster_blunt
				}
			},
			attack_melee_combo_2 = {
				[2] = {
					override_damage_type = damage_types.minion_monster_blunt
				}
			}
		},
		stagger_type_reduction = {
			ranged = 100,
			explosion = 100
		},
		sweep_ground_impact_fx_timing = {
			attack_melee_combo = {
				0.3333333333333333,
				0.7333333333333333,
				1.1666666666666667,
				1.5666666666666667
			},
			attack_melee_combo_2 = {
				0.6,
				1.56,
				2.32
			}
		},
		sweep_ground_impact_fx_templates = {
			attack_melee_combo = {
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle
			},
			attack_melee_combo_2 = {
				false,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
				GroundImpactFxTemplates.chaos_spawn_claw
			}
		}
	},
	stagger = {
		stagger_anims = {
			light = {
				fwd = {
					"stagger_fwd_exp"
				},
				bwd = {
					"stagger_bwd_exp"
				},
				left = {
					"stagger_left_exp"
				},
				right = {
					"stagger_right_exp"
				},
				dwn = {
					"stagger_bwd_exp"
				}
			},
			medium = {
				fwd = {
					"stagger_fwd_exp"
				},
				bwd = {
					"stagger_bwd_exp"
				},
				left = {
					"stagger_left_exp"
				},
				right = {
					"stagger_right_exp"
				},
				dwn = {
					"stagger_bwd_exp"
				}
			},
			heavy = {
				fwd = {
					"stagger_fwd_exp"
				},
				bwd = {
					"stagger_bwd_exp"
				},
				left = {
					"stagger_left_exp"
				},
				right = {
					"stagger_right_exp"
				},
				dwn = {
					"stagger_bwd_exp"
				}
			},
			light_ranged = {
				fwd = {
					"stagger_fwd_exp"
				},
				bwd = {
					"stagger_bwd_exp"
				},
				left = {
					"stagger_left_exp"
				},
				right = {
					"stagger_right_exp"
				},
				dwn = {
					"stagger_bwd_exp"
				}
			},
			explosion = {
				fwd = {
					"stagger_fwd_exp"
				},
				bwd = {
					"stagger_bwd_exp"
				},
				left = {
					"stagger_left_exp"
				},
				right = {
					"stagger_right_exp"
				},
				dwn = {
					"stagger_bwd_exp"
				}
			},
			killshot = {
				fwd = {
					"stagger_fwd_exp"
				},
				bwd = {
					"stagger_bwd_exp"
				},
				left = {
					"stagger_left_exp"
				},
				right = {
					"stagger_right_exp"
				},
				dwn = {
					"stagger_bwd_exp"
				}
			},
			sticky = {
				fwd = {
					"stagger_fwd_exp"
				},
				bwd = {
					"stagger_bwd_exp"
				},
				left = {
					"stagger_left_exp"
				},
				right = {
					"stagger_right_exp"
				},
				dwn = {
					"stagger_bwd_exp"
				}
			}
		}
	},
	open_door = {
		rotation_duration = 0.1,
		stagger_immune = true
	},
	smash_obstacle = {
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_melee_claw"
		},
		attack_anim_damage_timings = {
			attack_melee_claw = 0.5
		},
		attack_anim_durations = {
			attack_melee_claw = 1.6666666666666667
		},
		damage_profile = DamageProfileTemplates.default
	},
	exit_spawner = {
		run_anim_event = "move_fwd"
	}
}

return action_data
