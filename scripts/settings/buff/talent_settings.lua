local talent_settings = {
	veteran_1 = {
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
	},
	veteran_2 = {
		combat_ability = {
			spread_modifier = -0.95,
			sway_modifier = 0.05,
			ranged_damage = 0.5,
			recoil_modifier = -0.75,
			cooldown = 18,
			fov_multiplier = 0.85,
			push_speed_modifier = -0.5,
			duration = 3,
			outline_angle = 0.5,
			elusiveness_modifier = 2.5,
			outline_highlight_offset_total_max_time = 0.6,
			outline_duration = 10,
			on_hit_proc_chance = 1,
			ranged_impact_modifier = 1,
			max_charges = 1,
			movement_speed = 1,
			outline_highlight_offset = 0.15,
			outline_distance = 50,
			max_stacks = 1,
			toughness_damage = -0.75
		},
		grenade = {
			max_charges = 4
		},
		coherency = {
			on_ammo_consumed_proc_chance = 0.04
		},
		passive_1 = {
			weakspot_damage = 0.15
		},
		passive_2 = {
			ammo_reserve_capacity = 0.75
		},
		mixed_1 = {
			damage_vs_unaggroed = 1
		},
		mixed_2 = {
			grenade_restored = 1,
			grenade_replenishment_cooldown = 45
		},
		mixed_3 = {
			threat_weight_multiplier = 0.5
		},
		offensive_1 = {
			damage_far = 0.25
		},
		offensive_2 = {
			reload_speed = 0.25
		},
		offensive_3 = {
			ranged_damage = 0.1
		},
		defensive_1 = {
			on_hit_proc_chance = 1
		},
		defensive_2 = {
			dodge_linger_time_ranged_modifier = 1
		},
		defensive_3 = {
			alternate_fire_movement_speed_reduction_modifier = 0.8
		},
		coop_1 = {
			outline_short_duration = 5
		},
		coop_2 = {
			on_ammo_consumed_proc_chance = 0.07
		},
		coop_3 = {
			toughness_replenish_multiplier = 1.3
		},
		spec_passive_1 = {
			weakspot_damage = 0.25
		},
		spec_passive_2 = {},
		spec_passive_3 = {
			on_hit_proc_chance = 0.2
		},
		combat_ability_1 = {
			ranged_weakspot_damage = 1
		},
		combat_ability_2 = {},
		combat_ability_3 = {}
	},
	veteran_3 = {
		combat_ability = {
			cone_dot = 0.95,
			radius = 15,
			cone_range = 30,
			cooldown = 45,
			power_level = 1000,
			max_charges = 1
		},
		grenade = {
			max_charges = 2
		},
		coherency = {
			max_stacks = 1,
			damage = 0.05
		},
		passive_1 = {
			talent_cooldown_reduction = 10,
			on_hit_proc_chance = 1,
			cooldown_reduction = 6
		},
		passive_2 = {
			on_untag_unit_proc_chance = 1,
			damage_taken_multiplier = 1.25,
			on_tag_unit_proc_chance = 1
		},
		mixed_1 = {},
		mixed_2 = {
			krak_damage = 0.5
		},
		mixed_3 = {
			max_stacks = 1,
			crit_cooldown = 30,
			critical_strike_chance = 1,
			max_stacks_cap = 1,
			on_hit_proc_chance = 1
		},
		offensive_1 = {
			super_armor_damage = 0.15,
			armored_damage = 0.15
		},
		offensive_2 = {
			max_charges = 4
		},
		offensive_3 = {
			suppression_dealt = 0.5,
			on_minion_death_proc_chance = 0.05,
			damage = 0.5,
			active_duration = 10
		},
		defensive_1 = {
			movement_speed = 1.2
		},
		defensive_2 = {
			damage_taken_multiplier = 0.5
		},
		defensive_3 = {
			stamina_modifier = 2,
			toughness = 50
		},
		coop_1 = {
			max_stacks = 1,
			duration = 10,
			damage = 0.12
		},
		coop_2 = {
			max_stacks = 1,
			damage = 0.08
		},
		coop_3 = {
			max_stacks = 1,
			toughness_regen_rate_modifier = 0.25
		},
		spec_passive_1 = {
			talent_cooldown_reduction = 10
		},
		spec_passive_2 = {
			suppression_cooldown = 6
		},
		spec_passive_3 = {
			cooldown_reduction = 2,
			on_minion_death_proc_chance = 1
		},
		combat_ability_1 = {
			spread_modifier = -0.85,
			sway_modifier = 0.15,
			charge_up_time = -0.25,
			recoil_modifier = -0.85,
			reload_speed = 0.6,
			duration = 10
		},
		combat_ability_2 = {
			impact_modifier = 0.3,
			movement_speed = 1.1,
			block_cost_multiplier = 0.2,
			melee_damage = 0.1,
			duration = 10,
			attack_speed = 0.1
		},
		combat_ability_3 = {}
	},
	ogryn_shared = {
		tank = {
			toughness_damage_taken_multiplier = 0.5,
			damage_taken_multiplier = 0.75
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
		combat_ability = {},
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
	},
	ogryn_2 = {
		combat_ability = {
			active_duration = 5,
			on_finished_lunge_proc_chance = 1,
			melee_attack_speed = 0.25,
			movement_speed = 1.25,
			cooldown = 20,
			distance = 12,
			radius = 2,
			max_charges = 1
		},
		grenade = {
			max_charges = 1
		},
		coherency = {
			max_stacks = 1,
			melee_damage = 0.1
		},
		passive_1 = {
			toughness_melee_replenish = 0.25,
			melee_heavy_damage = 0.25
		},
		passive_2 = {
			melee_heavy_damage = 0.5,
			damage_taken_multiplier = 0.75
		},
		mixed_1 = {
			on_hit_proc_chance = 1,
			on_sweep_proc_chance = 1,
			num_enemies = 3,
			melee_damage = 0.5
		},
		mixed_2 = {
			toughness_replenish_multiplier = 2,
			increased_toughnes_health_threshold = 0.25
		},
		mixed_3 = {
			max_stacks = 1,
			on_start_lunge_proc_chance = 1,
			duration = 4,
			movement_speed = 1.25
		},
		offensive_1 = {
			ogryn_damage_taken_multiplier = 0.5,
			damage_vs_ogryn = 0.5
		},
		offensive_2 = {
			super_armor_damage = 0.25,
			armored_damage = 0.25
		},
		offensive_3 = {
			cooldown_percent = 0.33,
			on_hit_proc_chance = 1
		},
		defensive_1 = {
			max_stacks_cap = 1,
			stamina_regeneration_modifier = 0.5,
			max_stacks = 1,
			duration = 3,
			on_damage_taken_proc_chance = 1
		},
		defensive_2 = {
			sprinting_cost_multiplier = 0.8
		},
		defensive_3 = {
			on_hit_proc_chance = 1,
			damage_taken_multiplier = 0.7,
			active_duration = 2
		},
		coop_1 = {
			on_hit_proc_chance = 1
		},
		coop_2 = {
			max_stacks = 1,
			melee_damage = 0.15
		},
		coop_3 = {},
		spec_passive_1 = {},
		spec_passive_2 = {
			on_hit_proc_chance = 1
		},
		spec_passive_3 = {
			melee_fully_charged_damage = 0.25
		},
		combat_ability_1 = {
			cooldown = 20,
			max_charges = 1
		},
		combat_ability_2 = {
			cooldown = 20,
			distance = 24,
			max_charges = 1
		},
		combat_ability_3 = {
			cooldown = 10,
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
	},
	zealot_1 = {
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
	},
	zealot_2 = {
		combat_ability = {
			has_target_distance = 15,
			radius = 3,
			distance = 10,
			melee_damage = 0.25,
			cooldown = 10,
			duration = 3,
			melee_critical_strike_chance = 1,
			max_stacks = 1,
			on_hit_proc_chance = 1,
			max_charges = 1
		},
		grenade = {
			max_charges = 2
		},
		coherency = {
			max_stacks = 1,
			toughness_damage_taken_multiplier = 0.9
		},
		passive_1 = {
			damage_per_step = 0.025,
			health_step = 0.1
		},
		passive_2 = {
			on_damage_taken_proc_chance = 1,
			cooldown_duration = 90,
			active_duration = 5
		},
		passive_3 = {
			melee_attack_speed = 0.1
		},
		mixed_1 = {
			max_charges = 4
		},
		mixed_2 = {
			on_hit_proc_chance = 1
		},
		mixed_3 = {
			recuperate_percentage = 0.3,
			duration = 5,
			on_damage_taken_proc_chance = 1
		},
		offensive_1 = {
			melee_critical_strike_chance = 0.1
		},
		offensive_2 = {
			on_hit_proc_chance = 1,
			max_stacks = 5,
			melee_damage = 0.05,
			max_stacks_cap = 5,
			duration = 5
		},
		offensive_3 = {
			attack_speed = 0.1,
			first_health_threshold = 0.5,
			attack_speed_low = 0.2,
			second_health_threshold = 0.2
		},
		defensive_1 = {
			toughness_melee_replenish = 0.5
		},
		defensive_2 = {
			on_hit_proc_chance = 1,
			max_stacks = 3,
			max_stacks_cap = 3,
			duration = 5,
			toughness_damage_taken_multiplier = 0.85
		},
		defensive_3 = {
			on_damage_taken_proc_chance = 1,
			movement_speed = 1.3,
			active_duration = 1
		},
		coop_1 = {
			on_player_toughness_broken_proc_chance = 1,
			replenish_percentage = 0.25
		},
		coop_2 = {
			max_stacks = 1,
			toughness_damage_taken_multiplier = 0.8
		},
		coop_3 = {
			max_stacks = 1,
			on_hit_proc_chance = 1,
			damage = 0.2,
			duration = 5
		},
		spec_passive_1 = {
			damage_per_step = 0.04
		},
		spec_passive_2 = {
			movement_per_step = 0.015
		},
		spec_passive_3 = {
			damage_reduction_per_step = 0.05
		},
		combat_ability_1 = {
			on_damage_taken_proc_chance = 1,
			cooldown_duration = 90,
			leech = 0.05,
			on_hit_proc_chance = 1,
			melee_multiplier = 2,
			duration = 10,
			active_duration = 10
		},
		combat_ability_2 = {
			on_finished_lunge_proc_chance = 1,
			attack_speed = 0.2,
			active_duration = 5
		},
		combat_ability_3 = {
			cooldown = 10,
			max_charges = 2
		}
	},
	zealot_3 = {
		combat_ability = {
			cooldown = 45,
			max_charges = 1
		},
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
		combat_ability_1 = {
			cooldown = 45,
			max_charges = 2
		},
		combat_ability_2 = {},
		combat_ability_3 = {}
	},
	psyker_1 = {
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
	},
	psyker_2 = {
		combat_ability = {
			cooldown = 30,
			override_min_radius = 5,
			radius = 5,
			min_radius = 5,
			override_max_radius = 12.5,
			shout_dot = 0.9,
			shout_range = 30,
			power_level = 500,
			override_radius = 5,
			max_radius = 8.75,
			max_charges = 1
		},
		grenade = {
			cooldown = 1,
			max_charges = 1
		},
		coherency = {
			max_stacks = 1,
			damage_vs_elites = 0.1
		},
		passive_1 = {
			soul_duration = 20,
			smite_damage = 0.4,
			base_max_souls = 4,
			on_combat_ability_proc_chance = 1,
			on_hit_proc_chance = 1
		},
		passive_2 = {
			warp_charge_amount = 0.9
		},
		mixed_1 = {
			on_hit_proc_chance = 1,
			max_stacks_cap = 3,
			max_stacks = 3,
			duration = 10,
			percent_toughness = 0.0125
		},
		mixed_2 = {
			all_kills_proc_chance = 0.08
		},
		mixed_3 = {
			damage = 0.3,
			max_threshold_health = 0.9
		},
		offensive_1 = {
			warp_percent = 0.1,
			on_hit_proc_chance = 0.2
		},
		offensive_2 = {
			damage = 0.2
		},
		offensive_3 = {
			shout_damage = 2
		},
		defensive_1 = {
			vent_warp_charge_decrease_movement_reduction = 0
		},
		defensive_2 = {
			toughness_replenish_multiplier = 1.5
		},
		defensive_3 = {
			warp_charge_dissipation_multiplier = 2
		},
		coop_1 = {
			percent = 0.05,
			on_hit_proc_chance = 1
		},
		coop_2 = {
			max_stacks = 1,
			damage_vs_elites = 0.2
		},
		coop_3 = {
			max_stacks = 1,
			on_hit_proc_chance = 1,
			damage_taken_multiplier = 1.2,
			duration = 5
		},
		spec_passive_1 = {
			max_souls_talent = 5
		},
		spec_passive_2 = {
			increased_capacity = 0.5
		},
		spec_passive_3 = {
			talent_soul_duration = 60
		},
		combat_ability_1 = {
			cooldown_reduction_percent = 0.125
		},
		combat_ability_2 = {
			interval = 0.75,
			max_targets_of_warpfire = 10,
			max_stacks = 1,
			duration = 4,
			warpfire_power_level = 500
		},
		combat_ability_3 = {
			smite_attack_speed = 0.75,
			duration = 10,
			warp_charge_amount_smite = 0.5
		}
	},
	psyker_3 = {
		combat_ability = {
			cooldown = 30,
			max_charges = 1
		},
		grenade = {
			max_stacks_cap = 1,
			quick_max_stacks_cap = 1,
			quick_max_stacks = 1,
			default_power_level = 500,
			max_stacks = 1,
			quick_multiplier = 0.25,
			max_charges = 1,
			interval = {
				0.3,
				0.8
			},
			quick_interval = {
				0.1,
				0.3
			}
		},
		coherency = {
			damage = 0.05,
			max_stacks = 1
		},
		passive_1 = {
			max_stacks = 1,
			empowered_chain_lightning_chance = 0.075,
			chain_lightning_damage = 0.3,
			chain_lightning_cost_multiplier = 0
		},
		passive_2 = {},
		mixed_1 = {
			fixed_percentage = 0.05,
			on_hit_proc_chance = 1
		},
		mixed_2 = {
			on_hit_proc_chance = 1,
			movement_speed = 0.7,
			max_stacks = 1,
			max_stacks_cap = 1,
			duration = 3
		},
		mixed_3 = {
			vent_warp_charge_speed = 1.5
		},
		offensive_1 = {
			chain_lightning_max_jumps = 1,
			chain_lightning_max_radius = 1,
			chain_lightning_max_angle = math.pi * 0.05
		},
		offensive_2 = {
			max_stacks_talent = 3
		},
		offensive_3 = {
			power_level = 500
		},
		defensive_1 = {
			max_stacks = 1,
			duration = 6,
			toughness_damage_taken_multiplier = 0.8,
			movement_speed = 1.1
		},
		defensive_2 = {
			toughness_damage_taken_multiplier = 0.7
		},
		defensive_3 = {
			on_chain_lighting_start_proc_chance = 1,
			movement_speed = 1.15,
			active_duration = 2.5
		},
		coop_1 = {
			toughness_percent = 1
		},
		coop_2 = {
			damage = 0.08,
			max_stacks = 1
		},
		coop_3 = {
			interval = 1,
			toughness_percentage = 0.05,
			distance = 5
		},
		spec_passive_1 = {
			toughness_for_allies = 0.15
		},
		spec_passive_2 = {
			warp_charge_removal = 0.2
		},
		spec_passive_3 = {
			attack_speed = 0.15,
			duration = 3
		},
		combat_ability_1 = {
			cooldown = 30,
			max_charges = 2
		},
		combat_ability_2 = {},
		combat_ability_3 = {}
	}
}

return talent_settings
