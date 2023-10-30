local talent_settings = {
	ogryn_shared = {
		tank = {
			toughness_damage_taken_multiplier = 0.8,
			damage_taken_multiplier = 0.8,
			static_movement_reduction_multiplier = 0
		},
		revive = {
			assist_speed_modifier = 0.25,
			revive_speed_modifier = 0.25
		},
		radius = {
			coherency_aura_size_increase = 0.5
		}
	},
	ogryn_1 = {
		combat_ability = {
			cooldown = 80,
			clip_size_visualizer = 3,
			resistance_duration = 5,
			max_charges = 1
		},
		passive_1 = {
			free_ammo_proc_chance = 0.05
		},
		passive_2 = {
			reduced_damage_while_braced = 0.75
		},
		passive_3 = {
			increased_max_ammo = 0.25
		},
		aura = {
			damage_vs_suppressed = 0.2
		},
		mixed_1 = {
			duration = 6,
			damage_after_reload = 0.12
		},
		mixed_2 = {
			percent_toughness_ranged_kill = 0.02
		},
		mixed_3 = {
			increased_clip_size = 0.25
		},
		offensive_1 = {
			max_stacks = 8,
			duration = 6,
			crit_chance_on_kill = 0.01
		},
		offensive_2 = {
			increased_suppression = 0.25
		},
		offensive_3 = {
			reload_speed_on_multi_hit = 0.25,
			duration = 5,
			num_multi_hit = 5,
			multi_hit_window = 0.5
		},
		defensive_1 = {},
		defensive_2 = {
			move_speed_on_ranged_kill = 0.2,
			duration = 2
		},
		defensive_3 = {
			braced_toughness_regen = 0.02
		},
		coop_1 = {
			team_max_ammo_increase = 0.15
		},
		coop_2 = {
			damage_vs_suppressed_aura_improved = 0.3
		},
		coop_3 = {
			max_stacks = 4,
			duration = 8,
			reduced_ranged_damage_per_ally = 0.75
		},
		spec_passive_1 = {
			duration = 2,
			increased_cooldown_regeneration = 2
		},
		spec_passive_2 = {
			increased_passive_proc_chance = 0.08
		},
		spec_passive_3 = {},
		combat_ability_1 = {
			num_stacks = 2
		},
		combat_ability_2 = {
			reduced_clip_visualizer = 2,
			reduced_clip_size_modifier = -1
		},
		combat_ability_3 = {
			reduced_move_penalty = 0.5,
			increased_damage_vs_close = 0.15
		}
	},
	ogryn_2 = {
		combat_ability = {
			active_duration = 5,
			movement_speed = 0.25,
			on_lunge_end_proc_chance = 1,
			melee_attack_speed = 0.25,
			cooldown = 30,
			distance = 12,
			radius = 2,
			max_charges = 1
		},
		grenade = {
			max_charges = 2
		},
		coherency = {
			max_stacks = 1,
			melee_damage_improved = 0.1,
			melee_damage = 0.075
		},
		passive_1 = {
			impact_modifier = 0.25
		},
		passive_2 = {
			melee_heavy_damage = 0.5,
			damage_taken_multiplier = 0.75
		},
		toughness_1 = {
			toughness_bonus = 0.5
		},
		toughness_2 = {
			toughness = 0.25,
			on_sweep_finish_proc_chance = 1
		},
		toughness_3 = {
			toughness = 0.25,
			on_sweep_finish_proc_chance = 1
		},
		offensive_1 = {
			ogryn_damage_taken_multiplier = 0.7,
			damage_vs_ogryn = 0.3
		},
		offensive_2 = {},
		offensive_3 = {
			stacks = 4
		},
		coop_1 = {
			coherency_aura_size_increase = 0.5
		},
		coop_2 = {
			on_lunge_start_proc_chance = 1,
			duration = 4,
			max_stacks = 1,
			movement_speed = 0.2
		},
		coop_3 = {
			damage_taken_multiplier = 0.5,
			cooldown = 0.05
		},
		defensive_1 = {
			max_stacks = 6,
			min = 1,
			time = 1,
			max = 0.4
		},
		defensive_2 = {
			min = 1,
			distance = 20,
			max = 0.4
		},
		defensive_3 = {
			toughness_replenish_multiplier = 1,
			sprinting_cost_multiplier = 0.8,
			increased_toughness_health_threshold = 0.25
		},
		offensive_2_1 = {
			time = 5,
			damage = 0.2
		},
		offensive_2_2 = {
			max_stacks = 25,
			duration = 10,
			melee_heavy_damage = 0.01
		},
		offensive_2_3 = {
			max_targets = 10,
			on_hit_proc_chance = 1,
			melee_damage = 0.025,
			on_sweep_finish_proc_chance = 1
		},
		combat_ability_1 = {
			cooldown = 30,
			stacks = 5,
			max_charges = 1
		},
		combat_ability_2 = {
			cooldown = 30,
			distance = 24,
			increase_visualizer = 1,
			max_charges = 1
		},
		combat_ability_3 = {
			cooldown = 30,
			toughness = 0.1,
			max_charges = 1
		}
	},
	ogryn_3 = {
		combat_ability = {},
		grenade = {},
		coherency = {},
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
		combat_ability_3 = {}
	}
}

return talent_settings
