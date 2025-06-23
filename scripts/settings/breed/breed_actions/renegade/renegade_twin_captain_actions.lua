-- chunkname: @scripts/settings/breed/breed_actions/renegade/renegade_twin_captain_actions.lua

local BreedShootTemplates = require("scripts/settings/breed/breed_shoot_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local shooting_difficulty_settings = MinionDifficultySettings.shooting
local shooting_difficulty_settings_plasma_pistol = shooting_difficulty_settings.renegade_twin_captain_plasma_pistol
local action_data = {
	name = "renegade_twin_captain",
	idle = {
		anim_events = "idle"
	},
	disappear_idle = {
		anim_events = {
			{
				"foff_rodin_is_that"
			},
			{
				"foff_rodin_almost"
			}
		},
		durations = {
			foff_rodin_is_that = 7.333333333333333,
			foff_rodin_almost = 7.166666666666667
		},
		vo_trigger_timings = {
			foff_rodin_is_that = 0.06666666666666667,
			foff_rodin_almost = 0.6666666666666666
		}
	},
	disappear = {
		explode_position_node = "j_spine",
		power_level = 5,
		anim_events = "foff",
		disappear_timings = {
			foff = 0.9333333333333333
		},
		explosion_template = ExplosionTemplates.twin_disappear_explosion
	},
	disappear_instant = {
		explode_position_node = "j_spine",
		power_level = 5,
		anim_events = "foff",
		disappear_timings = {
			foff = 0
		},
		explosion_template = ExplosionTemplates.twin_disappear_explosion
	},
	move_to_position = {
		idle_anim_events = "idle",
		move_anim_event = "move_fwd_heads",
		speeds = {
			move_fwd_heads = 2
		}
	},
	intro = {
		idle_anim_events = "idle",
		duration = 6,
		move_anim_event = "move_fwd_walk",
		speeds = {
			move_fwd_walk = 0.9
		}
	},
	death = {
		ignore_hit_during_death_ragdoll = true,
		instant_ragdoll_chance = 0,
		death_animations = {
			default = {
				"death_burn_3"
			},
			[hit_zone_names.head] = {
				"death_burn_3"
			},
			[hit_zone_names.torso] = {
				"death_burn_3"
			},
			[hit_zone_names.upper_left_arm] = {
				"death_arm_left"
			},
			[hit_zone_names.lower_left_arm] = {
				"death_burn_3"
			},
			[hit_zone_names.upper_right_arm] = {
				"death_burn_3"
			},
			[hit_zone_names.lower_right_arm] = {
				"death_burn_3"
			},
			[hit_zone_names.upper_left_leg] = {
				"death_burn_3"
			},
			[hit_zone_names.lower_left_leg] = {
				"death_burn_3"
			},
			[hit_zone_names.upper_right_leg] = {
				"death_burn_3"
			},
			[hit_zone_names.lower_right_leg] = {
				"death_burn_3"
			},
			[hit_zone_names.captain_void_shield] = {
				"death_burn_3"
			},
			[hit_zone_names.afro] = {
				"death_burn_3"
			},
			[hit_zone_names.center_mass] = {
				"death_burn_3"
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
		},
		death_animation_vo = {
			death_burn_3 = "long_death",
			death_arm_left = "long_death"
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
		move_anim_events = "move_fwd",
		check_grenade_trajectory_frequency = 0.25,
		new_location_combat_range = "close",
		speed = 4.2,
		vo_event = "skulking",
		throw_position_distance_fwd_dot = 0.75,
		min_distance_from_target = 6,
		new_location_min_dist = 2,
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
			move_start_right = 0.26666666666666666,
			move_start_fwd = 0.26666666666666666,
			move_start_bwd = 0.26666666666666666,
			move_start_left = 0.26666666666666666
		},
		throw_distance_thresholds = {
			medium = 10,
			close = 4
		},
		throw_anim_events = {
			close = {
				"attack_throw_backhand_01"
			},
			medium = {
				"attack_throw_low_01"
			},
			long = {
				"cultist_grenadier_throw"
			}
		},
		throw_node_local_offset = {
			attack_throw_backhand_01 = Vector3Box(-0.3496, 0.6266, 1.3162),
			attack_throw_low_01 = Vector3Box(0.2501, 0.6223, 0.4472),
			attack_throw_long_01 = Vector3Box(0.1338, 0.854, 1.8289),
			cultist_grenadier_throw = Vector3Box(0.3618, 0.8799, 1.8387)
		},
		throw_config = {
			acceptable_accuracy = 1,
			item = "content/items/weapons/minions/ranged/cultist_grenade",
			unit_node = "j_lefthand",
			projectile_template = ProjectileTemplates.cultist_grenadier_grenade
		},
		throw_position_distance_fwd = {
			4,
			15
		},
		throw_position_distance = {
			1,
			5
		},
		new_location_max_dist = math.huge
	},
	move_to_combat_vector = {
		idle_anim_events = "idle",
		degree_per_direction = 10,
		utility_weight = 10,
		move_to_cooldown = 0.25,
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 120,
		speed = 4.2,
		move_anim_events = "move_fwd",
		considerations = UtilityConsiderations.move_to_combat_vector_special,
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
			move_start_right = 0.7,
			move_start_fwd = 0.26666666666666666,
			move_start_bwd = 1,
			move_start_left = 0.7666666666666667
		}
	},
	quick_throw_grenade = {
		utility_weight = 5,
		vo_event = "throwing_grenade",
		multiple_throw_chance = 0,
		considerations = UtilityConsiderations.twin_captain_quickthrow,
		aim_anim_events = {
			"throw_grenade"
		},
		throw_timing = {
			throw_grenade = 1.2083333333333333,
			throw_grenade_five = {
				1.4871794871794872,
				2.051282051282051,
				2.8461538461538463,
				3.7948717948717947,
				4.256410256410256
			},
			throw_grenade_five_02 = {
				1.641025641025641,
				2.5384615384615383,
				3.5384615384615383,
				4.051282051282051,
				4.615384615384615
			}
		},
		action_durations = {
			throw_grenade = 2.5,
			throw_grenade_five_02 = 5.128205128205129,
			throw_grenade_five = 4.871794871794871
		},
		effect_template = EffectTemplates.renegade_captain_grenade,
		effect_template_timings = {
			throw_grenade = 0.4375,
			throw_grenade_five_02 = 1.641025641025641,
			throw_grenade_five = 1.4871794871794872
		},
		throw_config = {
			acceptable_accuracy = 1,
			item = "content/items/weapons/minions/ranged/twin_grenade",
			unit_node = "j_lefthand",
			projectile_template = ProjectileTemplates.twin_grenade
		},
		cooldown = {
			8,
			8,
			8,
			8,
			8
		},
		multiple_aim_anim_events = {
			"throw_grenade_five",
			"throw_grenade_five_02"
		},
		unit_nodes = {
			throw_grenade_five = {
				"j_righthand",
				"j_lefthand",
				"j_righthand",
				"j_righthand",
				"j_lefthand"
			},
			throw_grenade_five_02 = {
				"j_righthand",
				"j_righthand",
				"j_lefthand",
				"j_righthand",
				"j_lefthand"
			}
		},
		random_throw_offset_config = {
			throw_grenade_five = {
				offset_radius_range = {
					3,
					6
				}
			},
			throw_grenade_five_02 = {
				offset_radius_range = {
					3,
					6
				}
			}
		}
	},
	multiple_quick_throw_grenade = {
		utility_weight = 200,
		vo_event = "throwing_grenade",
		multiple_throw_chance = 1,
		considerations = UtilityConsiderations.twin_captain_multithrow,
		aim_anim_events = {
			"throw_grenade"
		},
		throw_timing = {
			throw_grenade = 1.2083333333333333,
			throw_grenade_five = {
				1.4871794871794872,
				2.051282051282051,
				2.8461538461538463,
				3.7948717948717947,
				4.256410256410256
			},
			throw_grenade_five_02 = {
				1.641025641025641,
				2.5384615384615383,
				3.5384615384615383,
				4.051282051282051,
				4.615384615384615
			},
			captain_heads_barrage = {
				1.3333333333333333,
				1.4333333333333333,
				1.5333333333333334,
				1.6333333333333333
			}
		},
		action_durations = {
			throw_grenade = 2.5,
			throw_grenade_five_02 = 5.128205128205129,
			captain_heads_barrage = 3.066666666666667,
			throw_grenade_five = 4.871794871794871
		},
		effect_template = EffectTemplates.renegade_captain_grenade,
		effect_template_timings = {
			throw_grenade = 0.4375,
			throw_grenade_five_02 = 1.641025641025641,
			captain_heads_barrage = 1.3333333333333333,
			throw_grenade_five = 1.4871794871794872
		},
		throw_config = {
			acceptable_accuracy = 1,
			item = "content/items/weapons/minions/ranged/twin_grenade",
			unit_node = "j_lefthand",
			projectile_template = ProjectileTemplates.twin_grenade
		},
		cooldown = {
			8,
			8,
			8,
			8,
			8
		},
		multiple_aim_anim_events = {
			"captain_heads_barrage"
		},
		unit_nodes = {
			throw_grenade_five = {
				"j_righthand",
				"j_lefthand",
				"j_righthand",
				"j_righthand",
				"j_lefthand"
			},
			throw_grenade_five_02 = {
				"j_righthand",
				"j_righthand",
				"j_lefthand",
				"j_righthand",
				"j_lefthand"
			},
			captain_heads_barrage = {
				"j_lefthand",
				"j_lefthand",
				"j_lefthand",
				"j_lefthand",
				"j_lefthand"
			}
		},
		random_throw_offset_config = {
			throw_grenade_five = {
				offset_radius_range = {
					3,
					6
				}
			},
			throw_grenade_five_02 = {
				offset_radius_range = {
					3,
					6
				}
			},
			captain_heads_barrage = {
				fan_pattern = true,
				offset = 3
			}
		}
	},
	multiple_quick_throw_grenade_empowered = {
		utility_weight = 2000,
		vo_event = "throwing_grenade",
		multiple_throw_chance = 1,
		considerations = UtilityConsiderations.twin_captain_multithrow_empowered,
		aim_anim_events = {
			"throw_grenade"
		},
		throw_timing = {
			throw_grenade = 1.2083333333333333,
			throw_grenade_five = {
				1.4871794871794872,
				2.051282051282051,
				2.8461538461538463,
				3.7948717948717947,
				4.256410256410256
			},
			throw_grenade_five_02 = {
				1.641025641025641,
				2.5384615384615383,
				3.5384615384615383,
				4.051282051282051,
				4.615384615384615
			},
			captain_heads_barrage = {
				1.3333333333333333,
				1.4333333333333333,
				1.5333333333333334,
				1.6333333333333333
			}
		},
		action_durations = {
			throw_grenade = 2.5,
			throw_grenade_five_02 = 5.128205128205129,
			captain_heads_barrage = 3.066666666666667,
			throw_grenade_five = 4.871794871794871
		},
		effect_template = EffectTemplates.renegade_captain_grenade,
		effect_template_timings = {
			throw_grenade = 0.4375,
			throw_grenade_five_02 = 1.641025641025641,
			captain_heads_barrage = 1.3333333333333333,
			throw_grenade_five = 1.4871794871794872
		},
		throw_config = {
			acceptable_accuracy = 1,
			item = "content/items/weapons/minions/ranged/twin_grenade",
			unit_node = "j_lefthand",
			projectile_template = ProjectileTemplates.twin_grenade
		},
		cooldown = {
			4,
			4,
			4,
			4,
			4
		},
		multiple_aim_anim_events = {
			"captain_heads_barrage"
		},
		unit_nodes = {
			throw_grenade_five = {
				"j_righthand",
				"j_lefthand",
				"j_righthand",
				"j_righthand",
				"j_lefthand"
			},
			throw_grenade_five_02 = {
				"j_righthand",
				"j_righthand",
				"j_lefthand",
				"j_righthand",
				"j_lefthand"
			},
			captain_heads_barrage = {
				"j_lefthand",
				"j_lefthand",
				"j_lefthand",
				"j_lefthand",
				"j_lefthand"
			}
		},
		random_throw_offset_config = {
			throw_grenade_five = {
				offset_radius_range = {
					3,
					6
				}
			},
			throw_grenade_five_02 = {
				offset_radius_range = {
					3,
					6
				}
			},
			captain_heads_barrage = {
				fan_pattern = true,
				offset = 2.5
			}
		}
	},
	melee_attack = {
		weapon_reach = 4,
		utility_weight = 20,
		ignore_blocked = true,
		considerations = UtilityConsiderations.ranged_elite_melee,
		attack_anim_events = {
			"attack_kick_01",
			"attack_kick_02"
		},
		attack_anim_damage_timings = {
			attack_kick_01 = 0.6944444444444444,
			attack_kick_02 = 0.4444444444444444
		},
		attack_anim_durations = {
			attack_kick_01 = 1.5555555555555556,
			attack_kick_02 = 1.0555555555555556
		},
		attack_intensities = {
			ranged = 2,
			melee = 0.5
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_gunner_melee,
		damage_type = damage_types.minion_ogryn_kick
	},
	ranged_follow = {
		idle_anim_events = "idle",
		min_distance_to_target = 4.5,
		utility_weight = 5,
		vo_event = "taunt_combat",
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 120,
		degree_per_direction = 10,
		move_anim_events = "move_fwd",
		move_to_cooldown = 0.25,
		speed = 4.2,
		max_distance_to_target = 8,
		considerations = UtilityConsiderations.ranged_follow_no_los,
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
			move_start_right = 0.26666666666666666,
			move_start_fwd = 0.26666666666666666,
			move_start_bwd = 0.26666666666666666,
			move_start_left = 0.26666666666666666
		}
	},
	plasma_pistol_shoot = {
		max_distance_to_target = 12,
		strafe_speed = 2.3,
		can_strafe_shoot = true,
		strafe_shoot_distance = 3,
		degree_per_direction = 10,
		strafe_end_anim_event = "aim_standing",
		inventory_slot = "slot_plasma_pistol",
		utility_weight = 2,
		move_to_fail_cooldown = 1,
		exit_after_cooldown = true,
		before_shoot_effect_template_timing = 0.75,
		strafe_shoot_ranged_position_fallback = true,
		suppressive_fire = true,
		randomized_direction_degree_range = 180,
		reset_dodge_check_after_each_shot = true,
		move_to_cooldown = 0.25,
		min_distance_to_target = 6,
		fx_source_name = "muzzle",
		considerations = UtilityConsiderations.renegade_captain_plasma_pistol_shoot,
		aim_anim_events = {
			"aim_standing"
		},
		aim_duration = {
			aim_standing = shooting_difficulty_settings_plasma_pistol.aim_durations
		},
		aim_stances = {
			aim_standing = "pistol_standing"
		},
		shoot_cooldown = shooting_difficulty_settings_plasma_pistol.shoot_cooldown,
		num_shots = shooting_difficulty_settings_plasma_pistol.num_shots,
		time_per_shot = shooting_difficulty_settings_plasma_pistol.time_per_shot,
		dodge_window = shooting_difficulty_settings_plasma_pistol.shoot_dodge_window,
		attack_intensities = {
			ranged = 6
		},
		shoot_template = BreedShootTemplates.renegade_captain_plasma_pistol,
		strafe_anim_events = {
			bwd = "move_bwd_walk_aim",
			fwd = "move_fwd_walk_aim",
			left = "move_left_walk_aim",
			right = "move_right_walk_aim"
		},
		before_shoot_effect_template = EffectTemplates.renegade_captain_plasma_pistol_charge_up
	},
	throw_grenade = {
		utility_weight = 20,
		considerations = UtilityConsiderations.has_line_of_sight
	},
	kick = {
		height = 2.5,
		ignore_blocked = true,
		utility_weight = 20,
		aoe_threat_timing = 0.3,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee",
		moving_attack = true,
		range = 3,
		ignore_dodge = true,
		width = 2.25,
		considerations = UtilityConsiderations.ranged_elite_melee,
		attack_anim_events = {
			"attack_kick_01",
			"attack_kick_02"
		},
		attack_anim_damage_timings = {
			attack_kick_01 = 0.6666666666666666,
			attack_kick_02 = 0.4266666666666667
		},
		attack_anim_durations = {
			attack_kick_01 = 1.2,
			attack_kick_02 = 0.6666666666666666
		},
		attack_intensities = {
			ranged = 1,
			running_melee = 2,
			moving_melee = 0.1,
			melee = 0.25
		},
		damage_profile = DamageProfileTemplates.renegade_captain_kick,
		damage_type = damage_types.minion_ogryn_kick
	},
	exit_anim_states = {
		slot_plasma_pistol = "to_pistol"
	},
	shield_down_recharge = {
		shield_break_duration = 10,
		vo_event = "taunt_shield",
		stand_up_anim_duration = 1.3333333333333333,
		anim_events = {
			"stagger_shield_break_charge_into"
		},
		stand_up_anim_events = {
			"stagger_shield_break_charge_outof"
		},
		regen_speed = {
			300,
			400,
			500,
			600,
			800
		},
		charge_effect_template = EffectTemplates.linked_beam,
		regenerate_full_delay = {
			20,
			18,
			16,
			14,
			12
		}
	},
	void_shield_explosion = {
		radius = 5,
		utility_weight = 10,
		hit_effect = "content/fx/particles/screenspace/screen_disturbance_scanlines_pulse",
		relation = "enemy",
		hit_zone_name = "center_mass",
		power_level = 100,
		considerations = UtilityConsiderations.twin_captain_void_shield_explosion,
		attack_anim_events = {
			"force_shield_knockback"
		},
		attack_anim_damage_timings = {
			force_shield_knockback = 0.5523809523809524
		},
		attack_anim_durations = {
			force_shield_knockback = 1.1428571428571428
		},
		damage_profile = DamageProfileTemplates.renegade_captain_void_shield_explosion,
		damage_type = damage_types.minion_powered_sharp,
		effect_template = EffectTemplates.void_shield_explosion
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
					"stagger_bwd_light"
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
					"stagger_fwd_heavy"
				},
				bwd = {
					"stagger_bwd_heavy"
				},
				left = {
					"stagger_left_heavy"
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
					"stagger_fwd_light"
				},
				bwd = {
					"stagger_bwd_light"
				},
				left = {
					"stagger_left_light"
				},
				right = {
					"stagger_right_light"
				}
			},
			explosion = {
				fwd = {
					"stagger_fwd_heavy"
				},
				bwd = {
					"stagger_bwd_heavy"
				},
				left = {
					"stagger_left_heavy"
				},
				right = {
					"stagger_right_heavy"
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
					"stagger_bwd_light"
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
			shield_broken = {
				fwd = {
					"stagger_shield_break"
				},
				bwd = {
					"stagger_shield_break"
				},
				left = {
					"stagger_shield_break"
				},
				right = {
					"stagger_shield_break"
				},
				dwn = {
					"stagger_shield_break"
				}
			},
			wall_collision = {
				fwd = {
					"stagger_wall_hit"
				},
				bwd = {
					"stagger_wall_hit"
				},
				left = {
					"stagger_wall_hit"
				},
				right = {
					"stagger_wall_hit"
				},
				dwn = {
					"stagger_wall_hit"
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
					"stagger_bwd_light"
				}
			}
		}
	},
	smash_obstacle = {
		power_level = 1000,
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_kick_01"
		},
		attack_anim_damage_timings = {
			attack_kick_01 = 0.6666666666666666
		},
		attack_anim_durations = {
			attack_kick_01 = 1.0666666666666667
		},
		damage_profile = DamageProfileTemplates.default
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
