local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local action_data = {
	name = "renegade_grenadier",
	idle = {
		anim_events = "idle"
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
		check_grenade_trajectory_frequency = 0.25,
		new_location_min_dist = 2,
		new_location_combat_range = "close",
		idle_anim_events = "idle",
		vo_event = "skulking",
		move_anim_events = "move_fwd",
		min_distance_from_target = 6,
		speed = 4.2,
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
		},
		throw_distance_thresholds = {
			medium = 10,
			close = 4
		},
		throw_anim_events = {
			close = {
				"attack_throw_backhand_01",
				"attack_throw_backhand_02",
				"attack_throw_backhand_03"
			},
			medium = {
				"attack_throw_low_01"
			},
			long = {
				"attack_throw_long_01",
				"attack_throw_long_02"
			}
		},
		throw_node_local_offset = {
			attack_throw_backhand_01 = Vector3Box(-0.3496, 0.6266, 1.3162),
			attack_throw_backhand_02 = Vector3Box(-0.1743, 0.7025, 1.141),
			attack_throw_backhand_03 = Vector3Box(-0.2337, 0.6418, 1.6299),
			attack_throw_low_01 = Vector3Box(0.2501, 0.6223, 0.4472),
			attack_throw_long_01 = Vector3Box(0.1338, 0.854, 1.8289),
			attack_throw_long_02 = Vector3Box(0.3618, 0.8799, 1.8387)
		},
		throw_config = {
			acceptable_accuracy = 0.5,
			item = "content/items/weapons/minions/ranged/renegade_grenade",
			unit_node = "j_rightweaponattach",
			projectile_template = ProjectileTemplates.renegade_grenadier_fire_grenade
		},
		throw_position_distance = {
			1,
			2.5
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
	throw_grenade = {
		vo_event = "throwing_grenade",
		effect_template = EffectTemplates.renegade_grenadier_grenade,
		effect_template_timings = {
			attack_throw_long_02 = 0.20512820512820512,
			attack_throw_backhand_01 = 0.28205128205128205,
			attack_throw_backhand_02 = 0.1794871794871795,
			attack_throw_low_01 = 0.358974358974359,
			attack_throw_backhand_03 = 0.20512820512820512,
			attack_throw_long_01 = 0.2564102564102564
		},
		throw_timings = {
			attack_throw_long_02 = 2.3076923076923075,
			attack_throw_backhand_01 = 2.128205128205128,
			attack_throw_backhand_02 = 2.076923076923077,
			attack_throw_low_01 = 2.1794871794871793,
			attack_throw_backhand_03 = 2.3846153846153846,
			attack_throw_long_01 = 2.3076923076923075
		},
		action_durations = {
			attack_throw_long_02 = 3.2051282051282053,
			attack_throw_backhand_01 = 2.641025641025641,
			attack_throw_backhand_02 = 2.769230769230769,
			attack_throw_low_01 = 2.871794871794872,
			attack_throw_backhand_03 = 3.076923076923077,
			attack_throw_long_01 = 3.1538461538461537
		},
		throw_config = {
			unit_node = "j_rightweaponattach",
			item = "content/items/weapons/minions/ranged/renegade_grenade",
			projectile_template = ProjectileTemplates.renegade_grenadier_fire_grenade
		}
	},
	quick_throw_grenade = {
		utility_weight = 20,
		vo_event = "throwing_grenade",
		considerations = UtilityConsiderations.grenadier_quick_throw,
		aim_anim_events = {
			"attack_throw_low_01"
		},
		aim_duration = {
			attack_throw_low_01 = 2.230769230769231
		},
		action_durations = {
			attack_throw_low_01 = 2.923076923076923
		},
		effect_template = EffectTemplates.renegade_grenadier_grenade,
		effect_template_timings = {
			attack_throw_low_01 = 0.358974358974359
		},
		throw_config = {
			acceptable_accuracy = 1,
			item = "content/items/weapons/minions/ranged/renegade_grenade",
			unit_node = "j_rightweaponattach",
			projectile_template = ProjectileTemplates.renegade_grenadier_fire_grenade
		},
		cooldown = MinionDifficultySettings.cooldowns.grenadier_throw
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
					"stagger_fwd_killshot_1"
				},
				bwd = {
					"stagger_bwd_killshot_1"
				},
				left = {
					"stagger_left_killshot_1"
				},
				right = {
					"stagger_right_killshot_1"
				},
				dwn = {
					"stagger_bwd_killshot_1"
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
	open_door = {
		rotation_duration = 0.1,
		stagger_immune = true
	},
	exit_spawner = {
		run_anim_event = "move_fwd"
	}
}

return action_data
