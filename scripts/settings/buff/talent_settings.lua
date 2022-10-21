local DamageSettings = require("scripts/settings/damage/damage_settings")
local talent_settings = {
	shared = {
		venting = {
			vent_to_toughness = 0.5
		}
	},
	veteran_2 = {
		combat_ability = {
			duration = 4,
			ranged_damage = 0.5,
			outline_highlight_offset_total_max_time = 0.6,
			outline_duration = 12,
			cooldown = 18,
			fov_multiplier = 0.85,
			push_speed_modifier = -0.5,
			outline_angle = 0.5,
			movement_speed = 1,
			outline_highlight_offset = 0.15,
			outline_distance = 50,
			max_stacks = 1,
			on_hit_proc_chance = 1,
			ranged_impact_modifier = 1,
			max_charges = 1
		},
		grenade = {
			max_charges = 4
		},
		coherency = {
			ammo_replenishment_percent = 0.02
		},
		passive_1 = {
			weakspot_damage = 0.15
		},
		passive_2 = {
			ammo_reserve_capacity = 0.75
		},
		toughness_1 = {
			toughness = 0.05,
			duration = 10,
			instant_toughness = 0.5
		},
		toughness_2 = {
			toughness = 0.2
		},
		toughness_3 = {
			toughness = 0.0075,
			time = 0.1,
			range = DamageSettings.in_melee_range
		},
		offensive_1_1 = {
			damage_far = 0.25
		},
		offensive_1_2 = {
			reload_speed = 0.2
		},
		offensive_1_3 = {
			grenade_restored = 1,
			grenade_replenishment_cooldown = 45
		},
		defensive_1 = {
			toughness_damage_taken_multiplier = 0.25
		},
		defensive_2 = {
			stamina_percent = 0.2
		},
		defensive_3 = {
			threat_weight_multiplier = 0.1
		},
		coop_1 = {
			outline_short_duration = 6
		},
		coop_2 = {
			proc_chance = 0.08
		},
		coop_3 = {
			toughness_percent = 0.04,
			range = 5
		},
		offensive_2_1 = {
			stacks = 1
		},
		offensive_2_2 = {
			shot_stamina_percent = 0.05,
			critical_strike_chance = 0.25,
			stamina = 0.1,
			sway_modifier = 0.05
		},
		offensive_2_3 = {
			reload_speed = 0.5
		},
		combat_ability_1 = {
			rending = 0.75
		},
		combat_ability_2 = {},
		combat_ability_3 = {
			spread_modifier = -0.95,
			sway_modifier = 0.05,
			recoil_modifier = -0.75
		}
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
			damage_taken_multiplier = 1.15,
			on_tag_unit_proc_chance = 1
		},
		mixed_1 = {},
		mixed_2 = {
			krak_damage = 0.5
		},
		mixed_3 = {},
		offensive_1 = {
			ranged_damage = 0.15,
			duration = 8
		},
		offensive_2 = {
			max_charges = 4
		},
		offensive_3 = {
			suppression_dealt = 0.2,
			on_minion_death_proc_chance = 0.05,
			damage = 0.2,
			active_duration = 10
		},
		defensive_1 = {
			movement_speed = 1.2
		},
		defensive_2 = {
			damage = -0.5,
			damage_monsters = -0.3
		},
		defensive_3 = {
			stamina_modifier = 2,
			toughness = 100
		},
		coop_1 = {},
		coop_2 = {
			max_stacks = 1,
			damage = 0.08
		},
		coop_3 = {
			percent = 0.1
		},
		spec_passive_1 = {
			damage_taken_multiplier = 1.3
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
			free_ammo_proc_chance = 0.08
		},
		passive_2 = {
			reduced_damage_while_braced = 0.75
		},
		passive_3 = {
			increased_max_ammo = 0.5
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
			max_stacks = 12,
			duration = 6,
			crit_chance_on_kill = 0.01
		},
		offensive_2 = {
			increased_suppression = 0.25
		},
		offensive_3 = {
			reload_speed_on_multi_hit = 0.3,
			duration = 5,
			num_multi_hit = 5,
			multi_hit_window = 0.5
		},
		defensive_1 = {},
		defensive_2 = {
			move_speed_on_ranged_kill = 1.2,
			duration = 5
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
			duration = 8,
			increased_cooldown_regeneration = 0.15
		},
		spec_passive_2 = {
			increased_passive_proc_chance = 0.12
		},
		spec_passive_3 = {},
		combat_ability_1 = {
			increased_fire_rate = 0.15
		},
		combat_ability_2 = {
			reduced_clip_visualizer = 2,
			reduced_clip_size_modifier = -1
		},
		combat_ability_3 = {
			increased_damage_vs_close = 0.25
		}
	},
	ogryn_2 = {
		combat_ability = {
			active_duration = 5,
			movement_speed = 1.25,
			on_lunge_end_proc_chance = 1,
			melee_attack_speed = 0.25,
			cooldown = 30,
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
			impact_modifier = 0.25
		},
		passive_2 = {
			melee_heavy_damage = 0.5,
			damage_taken_multiplier = 0.75
		},
		toughness_1 = {
			toughness_multiplier = 1
		},
		toughness_2 = {
			toughness = 0.15,
			on_sweep_finish_proc_chance = 1
		},
		toughness_3 = {
			toughness = 0.15,
			on_sweep_finish_proc_chance = 1
		},
		offensive_1 = {
			ogryn_damage_taken_multiplier = 0.5,
			damage_vs_ogryn = 0.5
		},
		offensive_2 = {},
		offensive_3 = {},
		coop_1 = {
			coherency_aura_size_increase = 0.5
		},
		coop_2 = {
			on_lunge_start_proc_chance = 1,
			duration = 4,
			max_stacks = 1,
			movement_speed = 1.25
		},
		coop_3 = {
			damage_taken_multiplier = 0.5
		},
		defensive_1 = {
			cooldown = 0.1
		},
		defensive_2 = {
			damage_taken_multiplier = 0.25
		},
		defensive_3 = {
			toughness_replenish_multiplier = 2,
			sprinting_cost_multiplier = 0.8,
			increased_toughness_health_threshold = 0.25
		},
		spec_passive_1 = {},
		spec_passive_2 = {
			toughness_to_restore = 0.05,
			on_hit_proc_chance = 1
		},
		spec_passive_3 = {
			melee_fully_charged_damage = 0.25
		},
		offensive_2_1 = {
			time = 5,
			damage = 0.2
		},
		offensive_2_3 = {
			max_targets = 10,
			on_hit_proc_chance = 1,
			melee_damage = 0.1,
			on_sweep_finish_proc_chance = 1
		},
		combat_ability_1 = {
			cooldown = 30,
			stacks = 1,
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
	zealot_2 = {
		combat_ability = {
			has_target_distance = 15,
			radius = 3,
			distance = 10,
			melee_damage = 0.25,
			cooldown = 25,
			duration = 3,
			melee_critical_strike_chance = 1,
			max_stacks = 1,
			on_hit_proc_chance = 1,
			max_charges = 1
		},
		grenade = {
			max_charges = 3
		},
		coherency = {
			max_stacks = 1,
			toughness_damage_taken_multiplier = 0.9
		},
		passive_1 = {
			max_stacks = 3,
			health_step = 0.15,
			damage_per_step = 0.05
		},
		passive_2 = {
			on_damage_taken_proc_chance = 1,
			cooldown_duration = 90,
			active_duration = 5
		},
		passive_3 = {
			melee_attack_speed = 0.1
		},
		toughness_1 = {
			toughness_melee_replenish = 1
		},
		toughness_2 = {
			toughness_damage_taken_multiplier = 0.67,
			duration = 3
		},
		toughness_3 = {
			toughness = 0.0075,
			time = 0.1,
			range = DamageSettings.in_melee_range
		},
		offensive_1 = {
			melee_critical_strike_chance = 0.1
		},
		offensive_2 = {
			damage = 0.2
		},
		offensive_3 = {
			attack_speed = 0.1,
			first_health_threshold = 0.5,
			attack_speed_low = 0.2,
			second_health_threshold = 0.2
		},
		coop_1 = {
			crit_chance = 0.015
		},
		coop_2 = {
			max_stacks = 1,
			toughness_damage_taken_multiplier = 0.8
		},
		coop_3 = {
			toughness = 0.15
		},
		defensive_1 = {
			on_damage_taken_proc_chance = 1,
			cooldown_duration = 90,
			leech = 0.03,
			on_hit_proc_chance = 1,
			melee_multiplier = 3,
			duration = 5,
			active_duration = 5
		},
		defensive_2 = {
			on_damage_taken_proc_chance = 1,
			movement_speed = 1.3,
			active_duration = 2
		},
		defensive_3 = {
			recuperate_percentage = 0.3,
			duration = 5,
			on_damage_taken_proc_chance = 1
		},
		offensive_2_1 = {
			damage = 0.2
		},
		offensive_2_2 = {
			on_hit_proc_chance = 1,
			max_stacks = 5,
			melee_damage = 0.05,
			max_stacks_cap = 5,
			duration = 5
		},
		offensive_2_3 = {
			max_stacks = 6
		},
		combat_ability_1 = {
			time = 1
		},
		combat_ability_2 = {
			attack_speed = 0.2,
			on_lunge_end_proc_chance = 1,
			active_duration = 5
		},
		combat_ability_3 = {
			cooldown = 25,
			max_charges = 2
		}
	},
	zealot_3 = {
		combat_ability = {
			static_power_level = 500,
			radius = 5,
			toughness_restored = 1,
			min_radius = 3,
			cooldown = 45,
			close_radius = 2,
			min_close_radius = 2,
			power_level = 500,
			toughness_bonus = 400,
			duration = 5,
			max_charges = 1,
			explosion_area_suppression = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 15,
				suppression_value = 20
			}
		},
		grenade = {
			max_charges = 2
		},
		coherency = {
			corruption_heal_amount = 0.5,
			interval = 1
		},
		passive_1 = {
			max_dist = 25,
			max_resource = 25,
			duration = 8,
			crit_chance = 0.15,
			buff_removal_time_modifier = 0.8
		},
		passive_2 = {
			damage_vs_disgusting = 0.2
		},
		passive_3 = {
			corruption_taken_multiplier = 0.5
		},
		mixed_1 = {
			impact_modifier = 0.3
		},
		mixed_2 = {
			toughness = 75
		},
		mixed_3 = {
			extra_max_amount_of_wounds = 2
		},
		offensive_1 = {
			max_stacks = 5,
			melee_damage = 0.05
		},
		offensive_2 = {
			crit_share = 0.3333333333333333
		},
		offensive_3 = {
			max_hit_mass_impact_modifier = 0.5
		},
		defensive_1 = {
			cooldown_duration = 10,
			push_radius = 2.75,
			power_level = 500,
			inner_push_rad = math.pi * 0.125,
			outer_push_rad = math.pi * 0.25
		},
		defensive_2 = {
			health_segment_damage_taken_multiplier = 0.5
		},
		defensive_3 = {
			toughness_damage_taken_modifier = -0.15
		},
		coop_1 = {
			toughness_percent_regenerated = 0.5,
			duration = 5,
			damage = 0.15
		},
		coop_2 = {
			interval = 1,
			percent_increase_visualizer = 0.5,
			corruption_heal_amount_increased = 1.5
		},
		coop_3 = {
			duration = 4,
			cooldown_duration = 10,
			damage_taken_multiplier = 0.25
		},
		spec_passive_1 = {
			cooldown_time = 0.5
		},
		spec_passive_2 = {
			crit_chance = 0.1
		},
		spec_passive_3 = {},
		combat_ability_1 = {
			max_time_per_hit = 2,
			multiplier_per_hit = 0.9
		},
		combat_ability_2 = {},
		combat_ability_3 = {
			duration = 8
		}
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
			damage = 0.18,
			base_max_souls = 4,
			on_combat_ability_proc_chance = 1,
			on_hit_proc_chance = 1
		},
		passive_2 = {
			warp_charge_amount = 0.9
		},
		toughness_1 = {
			on_hit_proc_chance = 1,
			max_stacks_cap = 1,
			max_stacks = 1,
			duration = 5,
			percent_toughness = 0.1
		},
		toughness_2 = {
			percent_toughness = 0.15
		},
		toughness_3 = {
			multiplier = 0.75
		},
		offensive_1_1 = {
			damage_min = 0.05,
			damage = 0.15
		},
		offensive_1_2 = {
			vent_speed = 0.64,
			warp_charge_capacity = 0.64
		},
		offensive_1_3 = {
			distance = 3
		},
		coop_1 = {
			on_kill_proc_chance = 0.05
		},
		coop_2 = {
			percent = 0.15
		},
		coop_3 = {
			damage_taken_multiplier = 1.15,
			duration = 5
		},
		defensive_1 = {
			warp_charge_cost_multiplier = 0.5
		},
		defensive_2 = {
			min_toughness_damage_multiplier = 0.9,
			max_toughness_damage_multiplier = 0.67
		},
		defensive_3 = {
			vent_warp_charge_decrease_movement_reduction = 0
		},
		offensive_2_1 = {
			max_souls_talent = 6
		},
		offensive_2_2 = {
			distance = 15
		},
		offensive_2_3 = {
			cooldown = 15,
			smite_chance = 0.1
		},
		combat_ability_1 = {
			cooldown_reduction_percent = 0.125
		},
		combat_ability_2 = {
			soul_chance = 0.1
		},
		combat_ability_3 = {
			smite_attack_speed = 0.75,
			duration = 10,
			warp_charge_amount_smite = 0.5
		}
	}
}

return talent_settings
