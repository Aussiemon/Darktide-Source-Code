-- chunkname: @scripts/settings/talent/talent_settings_zealot.lua

local talent_settings = {
	zealot = {
		crits_grants_cd = {
			cooldown_regen = 1,
			duration = 3.25,
		},
		zealot_cleave_impact_post_push = {
			cleave = 0.25,
			duration = 5,
			impact_modifier = 0.25,
			max_stacks = 1,
		},
		zealot_damage_after_heavy_attack = {
			damage = 0.15,
			duration = 5,
			max_stacks = 1,
		},
		zealot_kills_increase_damage_of_next_melee = {
			duration = 5,
			max_stacks = 5,
			melee_damage = 0.1,
		},
		zealot_multihits_reduce_damage_of_next_attack = {
			damage_taken_multiplier = 0.8,
			duration = 8,
			max_stacks = 1,
			min_hits = 3,
		},
		zealot_blocking_increases_damage_of_next_melee = {
			duration = 8,
			max_stacks = 1,
			melee_damage = 0.15,
		},
		zealot_multihits_restore_stamina = {
			min_hits = 3,
			stamina = 0.1,
		},
		zealot_crits_rend = {
			rending_multiplier = 0.15,
		},
		zealot_elite_kills_empowers = {
			damage = 0.1,
			duration = 5,
			max_stacks = 1,
			toughness = 0.15,
		},
		zealot_uninterruptible_no_slow_heavies = {
			multiplier = 0,
		},
		zealot_stacking_weakspot_power = {
			duration = 5,
			max_stacks = 5,
			melee_weakspot_power_modifier = 0.05,
		},
		zealot_damage_vs_elites = {
			damage_vs_elites = 0.15,
		},
		zealot_weakspot_damage_reduction = {
			damage_taken_multiplier = 0.85,
			duration = 4,
			max_stacks = 1,
		},
		zealot_stacking_melee_damage_after_dodge = {
			duration = 8,
			max_stacks = 5,
			melee_damage = 0.03,
		},
		zealot_bled_enemies_take_more_damage = {
			damage_taken_multiplier = 1.15,
			duration = 5,
			max_stacks = 1,
		},
		zealot_damage_vs_nonthreat = {
			damage_vs_nonthreat = 0.15,
		},
		zealot_dodge_improvements = {
			dodge_distance_modifier = 0.25,
			extra_consecutive_dodges = 1,
		},
		zealot_revive_speed = {
			duration = 5,
			max_stacks = 1,
			movement_speed = 0.1,
			revive_speed_modifier = 0.25,
			toughness_damage_taken_multiplier = 0.85,
		},
		zealot_melee_crits_restore_stamina = {
			cooldown_duration = 1,
			stamina = 0.1,
		},
		zealot_heavy_multihits_increase_melee_damage = {
			duration = 5,
			max_stacks = 5,
			melee_damage = 0.04,
			min_hits = 3,
		},
		zealot_stamina_cost_multiplier_aura = {
			stamina_cost_multiplier = 0.85,
		},
		zealot_backstabs_increase_backstab_damage = {
			backstab_damage = 0.1,
			duration = 5,
			max_stacks = 2,
		},
		zealot_reduced_threat_after_backstab_kill = {
			duration = 5,
			max_stacks = 1,
			threat_weight_multiplier = 0.25,
		},
		zealot_melee_crits_reduce_damage_dealt = {
			damage_multiplier = -0.1,
			duration = 5,
			max_stacks = 1,
		},
		zealot_stamina_on_block_break = {
			cooldown_duration = 12,
			stamina = 0.5,
		},
		zealot_martyrdom_toughness_modifier = {
			toughness_modifier = 0.05,
		},
		zealot_dash_increased_duration = {
			duration = 20,
		},
		zealot_toughness_reduction_on_high_toughness = {
			tdr = 0.67,
			threshold = 0.75,
		},
		zealot_until_death_ability_cooldown = {},
		zealot_sprint_improvements = {
			slowdown_immune_start_t = 1,
			sprint_cost = 0.9,
			sprint_speed = 0.1,
		},
		zealot_weakspot_kills_restore_dodge = {},
		zealot_push_attacks_attack_speed = {
			duration = 5,
			melee_attack_speed = 0.1,
		},
		zealot_stacking_rending = {
			duration = 5,
			max_stacks = 10,
			rending = 0.01,
			stacks_gain = 2,
			stacks_lost = 1,
		},
		zealot_stealth_cooldown_regeneration = {
			monster = 0.5,
			ogryn = 0.3,
			other = 0.15,
		},
		zealot_sprint_angle_improvements = {
			sprint_dodge_reduce_angle_threshold_rad = math.rad(15),
		},
		zealot_leave_stealth_toughness_regen = {
			damage_reduction_duration = 8,
			damage_reduction_percentage = 0.7,
			toughness_to_restore = 0.5,
		},
		zealot_increased_duration = {
			backstab_damage = 0.5,
			duration = 5,
			threat_weight_multiplier = 0.25,
		},
		zealot_suppress_on_backstab_kill = {
			cooldown_duration = 5,
			suppression = {
				distance = 8,
				suppression_falloff = true,
				suppression_value = 200000,
			},
		},
		zealot_combat_ability_weakspot_backstab_hit_cooldown = {
			cooldown = 0.75,
			duration = 2,
		},
		zealot_fotf_refund_cooldown = {
			duration = 5,
			restored_percentage = 0.2,
		},
		zealot_martyrdom_cdr = {
			ability_cooldown_regeneration_per_stack = 0.1,
		},
		zealot_block_dodging_synergy = {
			number_of_restored_dodges = 3,
			on_dodge_block_cost_multiplier = 0.75,
			on_dodge_block_cost_multiplier_duration = 2,
			on_perfect_blocking_cooldown = 8,
		},
		zealot_momentum_toughness_replenish = {
			toughness_to_restore = 0.004,
		},
		zealot_reload_from_backstab = {
			ammo_percentage_for_stack = 0.05,
			max_stacks = 5,
		},
		zealot_toughness_in_melee = {
			initial_percentage_toughness = 0.025,
			max_percentage_toughness = 0.075,
			monster_count = 5,
			percentage_toughness_per_enemy = 0.01,
			range = 5,
		},
		zealot_backstab_allied_toughness = {
			duration = 5,
			toughness_damage_taken_modifier = 0.1,
			toughness_replenish_percentage = 0.1,
		},
		zealot_corruption_resistance_stacking = {
			corruption_taken_multiplier_per_stack = 0.1,
		},
		zealot_offensive_vs_many = {
			additional_number_of_enemies = 2,
			cleave = 0.1,
			damage = 0.02,
			initial_number_of_enemies = 2,
			max_stack = 5,
			range = 5,
		},
		zealot_backstab_periodic_damage = {
			backstab_damage = 0.5,
			cooldown_duration = 8,
		},
		zealot_more_damage_when_low_on_stamina = {
			melee_damage = 0.2,
			power_level_modifier = 0.2,
		},
	},
	zealot_1 = {
		combat_ability = {},
		grenade = {},
		coherency = {
			toughness_min_stack_override = 2,
		},
		passive_1 = {},
		passive_2 = {},
		mixed_1 = {},
		mixed_2 = {},
		mixed_3 = {},
		offensive_1 = {},
		offensive_2 = {},
		offensive_3 = {},
		defensive_1 = {},
		defensive_2 = {},
		defensive_3 = {},
		coop_1 = {},
		coop_2 = {},
		coop_3 = {},
		spec_passive_1 = {},
		spec_passive_2 = {},
		spec_passive_3 = {},
		combat_ability_1 = {},
		combat_ability_2 = {},
		combat_ability_3 = {},
	},
	zealot_2 = {
		combat_ability = {
			cooldown = 30,
			distance = 7,
			duration = 3,
			has_target_distance = 21,
			max_charges = 1,
			max_stacks = 1,
			melee_critical_strike_chance = 1,
			melee_damage = 0.25,
			melee_rending_multiplier = 1,
			on_hit_proc_chance = 1,
			radius = 3,
			toughness = 0.5,
		},
		grenade = {
			max_charges = 3,
		},
		throwing_knives = {
			melee_kill_refill_amount = 1,
		},
		coherency = {
			max_stacks = 1,
			toughness_damage_taken_multiplier = 0.925,
		},
		passive_1 = {
			damage_per_step = 0.1,
			health_step = 0.15,
			martyrdom_max_stacks = 5,
			toughness_reduction_per_stack = -0.075,
		},
		passive_2 = {
			active_duration = 5,
			cooldown_duration = 120,
			on_damage_taken_proc_chance = 1,
		},
		passive_3 = {
			melee_attack_speed = 0.1,
		},
		toughness_1 = {
			toughness_melee_replenish = 1,
		},
		toughness_2 = {
			duration = 4,
			toughness_damage_taken_multiplier = 0.6,
		},
		toughness_3 = {
			num_enemies = 3,
			range = 5,
			ticks_per_second = 3,
			toughness = 0.05,
		},
		offensive_1 = {
			duration = 3,
			melee_critical_strike_chance = 0.1,
			stacks = 2,
		},
		offensive_2 = {
			damage = 0.2,
			duration = 8,
			impact_modifier = 0.08,
			max_stacks = 5,
			min_hits = 3,
		},
		offensive_3 = {
			attack_speed = 0.1,
			attack_speed_low = 0.2,
			attack_speed_per_segment = 0.06,
			first_health_threshold = 0.5,
			second_health_threshold = 0.2,
		},
		coop_1 = {
			crit_chance = 0.02,
			duration = 5,
			power_level_modifier = 0.2,
		},
		coop_2 = {
			max_stacks = 1,
			toughness_damage_taken_multiplier = 0.85,
		},
		coop_3 = {
			toughness = 0.2,
		},
		defensive_1 = {
			active_duration = 5,
			cooldown_duration = 120,
			duration = 5,
			leech = 0.007,
			melee_multiplier = 3,
			on_damage_taken_proc_chance = 1,
			on_hit_proc_chance = 1,
		},
		defensive_2 = {
			active_duration = 2,
			movement_speed = 0.15,
			on_damage_taken_proc_chance = 1,
		},
		defensive_3 = {
			duration = 4,
			on_damage_taken_proc_chance = 1,
			recuperate_percentage = 0.2,
		},
		offensive_2_1 = {
			damage = 0.25,
		},
		offensive_2_2 = {
			duration = 5,
			max_stacks = 5,
			max_stacks_cap = 5,
			melee_damage = 0.04,
			on_hit_proc_chance = 1,
		},
		offensive_2_3 = {
			max_stacks = 6,
		},
		combat_ability_1 = {
			time = 1.5,
		},
		combat_ability_2 = {
			active_duration = 10,
			attack_speed = 0.2,
			on_lunge_end_proc_chance = 1,
		},
		combat_ability_3 = {
			max_charges = 2,
		},
	},
	zealot_3 = {
		combat_ability = {
			close_radius = 2,
			cooldown = 45,
			duration = 5,
			max_charges = 1,
			min_close_radius = 2,
			min_radius = 3,
			power_level = 500,
			radius = 5,
			static_power_level = 500,
			toughness_bonus_flat = 400,
			toughness_restored = 1,
			explosion_area_suppression = {
				distance = 15,
				instant_aggro = true,
				suppression_falloff = true,
				suppression_value = 20,
			},
		},
		grenade = {
			max_charges = 3,
		},
		coherency = {
			corruption_heal_amount = 0.5,
			interval = 1,
		},
		passive_1 = {
			buff_removal_time_modifier = 0.8,
			crit_chance = 0.15,
			duration = 8,
			max_dist = 25,
			max_resource = 25,
			toughness_on_max_stacks = 0.5,
			toughness_on_max_stacks_small = 0.02,
			toughness_over_time = 0.02,
		},
		passive_2 = {
			damage_vs_disgusting = 0.2,
			damage_vs_resistant = 0.2,
		},
		passive_3 = {
			corruption_taken_multiplier = 0.5,
		},
		mixed_1 = {
			impact_modifier = 0.3,
		},
		mixed_2 = {
			toughness = 75,
		},
		mixed_3 = {
			extra_max_amount_of_wounds = 2,
		},
		offensive_1 = {
			max_stacks = 5,
			melee_damage = 0.05,
		},
		offensive_2 = {
			crit_chance = 0.1,
			crit_share = 0.6666666666666666,
		},
		offensive_3 = {
			max_hit_mass_impact_modifier = 0.5,
		},
		defensive_1 = {
			cooldown_duration = 8,
			power_level = 2000,
			push_radius = 2.75,
			inner_push_rad = math.pi * 0.125,
			outer_push_rad = math.pi * 0.25,
		},
		defensive_2 = {
			health_segment_damage_taken_multiplier = 0.6,
		},
		defensive_3 = {
			toughness_damage_taken_modifier = -0.15,
		},
		coop_1 = {
			damage = 0.15,
			duration = 5,
			toughness_percent_regenerated = 0.5,
		},
		coop_2 = {
			corruption_heal_amount_increased = 1.5,
			interval = 1,
			percent_increase_visualizer = 0.5,
		},
		coop_3 = {
			cooldown_duration = 8,
			damage_taken_multiplier = 0.4,
			duration = 4,
		},
		spec_passive_1 = {
			cooldown_time = 0.5,
		},
		spec_passive_2 = {
			crit_chance = 0.1,
		},
		spec_passive_3 = {},
		combat_ability_1 = {
			max_time_per_hit = 2,
			multiplier_per_hit = 0.9,
		},
		combat_ability_2 = {},
		combat_ability_3 = {
			duration = 8,
		},
		bolstering_prayer = {
			self_toughness = 0.5,
			team_toughness = 0.25,
			tick_rate = 0.8,
			toughness_bonus = 15,
			toughness_duration = 10,
			toughness_percentage = 0.2,
			toughness_stacks = 5,
		},
		combat_ability_cd_restore_on_damage = {
			cooldown_regen = 0.5,
			damage_taken_to_ability_cd_percentage = 0.01,
			max_health = 0.25,
		},
		zealot_backstab_kills_restore_cd = {
			combat_ability_cd_percentage = 0.1,
		},
		quickness = {
			dodge_stacks = 3,
			increased_duration = 10,
			max_stacks = 20,
			toughness_percentage = 0.02,
		},
	},
}

return talent_settings
