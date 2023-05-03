local DamageSettings = require("scripts/settings/damage/damage_settings")
local talent_settings = {
	shared = {
		venting = {
			vent_to_toughness = 0.5
		}
	},
	veteran_2 = {
		combat_ability = {
			spread_modifier = -0.38,
			ranged_damage = 0.5,
			sway_modifier = 0.4,
			recoil_modifier = -0.24,
			cooldown = 25,
			fov_multiplier = 0.85,
			push_speed_modifier = -0.5,
			toughness = 0.6,
			outline_angle = 0.5,
			ranged_weakspot_damage = 0.25,
			duration = 5,
			outline_highlight_offset_total_max_time = 0.6,
			outline_duration = 5,
			on_hit_proc_chance = 1,
			ranged_impact_modifier = 1,
			max_charges = 1,
			movement_speed = 1,
			outline_highlight_offset = 0.15,
			outline_distance = 50,
			max_stacks = 1
		},
		grenade = {
			max_charges = 4
		},
		coherency = {
			ammo_replenishment_percent = 0.01
		},
		passive_1 = {
			weakspot_damage = 0.15
		},
		passive_2 = {
			ammo_reserve_capacity = 0.4
		},
		toughness_1 = {
			toughness = 0.025,
			duration = 10,
			instant_toughness = 0.25
		},
		toughness_2 = {
			max_stacks = 3,
			toughness = 0.2,
			toughness_damage_taken_multiplier = 0.9,
			duration = 8
		},
		toughness_3 = {
			toughness = 0.005,
			time = 0.1,
			range = DamageSettings.in_melee_range
		},
		offensive_1_1 = {
			damage_far = 0.2
		},
		offensive_1_2 = {
			reload_speed = 0.2
		},
		offensive_1_3 = {
			grenade_restored = 1,
			grenade_replenishment_cooldown = 60
		},
		defensive_1 = {
			toughness_damage_taken_multiplier = 0.25
		},
		defensive_2 = {
			stamina_percent = 0.3
		},
		defensive_3 = {
			threat_weight_multiplier = 0.1
		},
		coop_1 = {
			outline_short_duration = 5
		},
		coop_2 = {
			proc_chance = 0.05
		},
		coop_3 = {
			duration = 3,
			range = 5,
			toughness_percent = 0.15,
			damage = 0.1
		},
		offensive_2_1 = {
			stacks = 8
		},
		offensive_2_2 = {
			spread_modifier = -0.19,
			stamina = 0.08,
			critical_strike_chance = 0.25,
			recoil_modifier = -0.12,
			shot_stamina_percent = 0.04,
			sway_modifier = 0.4
		},
		offensive_2_3 = {
			reload_speed = 0.3
		},
		combat_ability_1 = {},
		combat_ability_2 = {
			weakspot_damage = 0.5
		},
		combat_ability_3 = {
			damage_vs_ogryn_and_monsters = 0.75
		}
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
			max_charges = 2
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
			toughness_bonus = 1
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
			ogryn_damage_taken_multiplier = 0.5,
			damage_vs_ogryn = 0.5
		},
		offensive_2 = {},
		offensive_3 = {
			stacks = 6
		},
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
			damage_taken_multiplier = 0.5,
			cooldown = 0.1
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
			melee_heavy_damage = 0.02
		},
		offensive_2_3 = {
			max_targets = 10,
			on_hit_proc_chance = 1,
			melee_damage = 0.025,
			on_sweep_finish_proc_chance = 1
		},
		combat_ability_1 = {
			cooldown = 30,
			stacks = 4,
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
			has_target_distance = 21,
			radius = 3,
			distance = 7,
			melee_damage = 0.25,
			cooldown = 30,
			melee_critical_strike_chance = 1,
			duration = 3,
			on_hit_proc_chance = 1,
			max_stacks = 1,
			toughness = 0.5,
			max_charges = 1
		},
		grenade = {
			max_charges = 3
		},
		coherency = {
			max_stacks = 1,
			toughness_damage_taken_multiplier = 0.925
		},
		passive_1 = {
			max_stacks = 3,
			health_step = 0.15,
			damage_per_step = 0.08
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
			toughness_damage_taken_multiplier = 0.5,
			duration = 4
		},
		toughness_3 = {
			num_ticks_to_trigger = 3,
			range = 5,
			time = 0.1,
			toughness = 0.025,
			num_enemies = 3
		},
		offensive_1 = {
			stacks = 2,
			duration = 3,
			melee_critical_strike_chance = 0.1
		},
		offensive_2 = {
			duration = 5,
			damage = 0.2,
			impact_modifier = 0.3,
			max_stacks = 5,
			min_hits = 3
		},
		offensive_3 = {
			attack_speed = 0.1,
			first_health_threshold = 0.5,
			attack_speed_low = 0.2,
			second_health_threshold = 0.2
		},
		coop_1 = {
			power_level_modifier = 0.2,
			duration = 5,
			crit_chance = 0.02
		},
		coop_2 = {
			max_stacks = 1,
			toughness_damage_taken_multiplier = 0.85
		},
		coop_3 = {
			toughness = 0.2
		},
		defensive_1 = {
			on_damage_taken_proc_chance = 1,
			cooldown_duration = 90,
			leech = 0.02,
			on_hit_proc_chance = 1,
			melee_multiplier = 3,
			duration = 5,
			active_duration = 5
		},
		defensive_2 = {
			on_damage_taken_proc_chance = 1,
			movement_speed = 1.2,
			active_duration = 2
		},
		defensive_3 = {
			recuperate_percentage = 0.25,
			duration = 5,
			on_damage_taken_proc_chance = 1
		},
		offensive_2_1 = {
			damage = 0.25
		},
		offensive_2_2 = {
			on_hit_proc_chance = 1,
			max_stacks = 5,
			melee_damage = 0.04,
			max_stacks_cap = 5,
			duration = 5
		},
		offensive_2_3 = {
			max_stacks = 6
		},
		combat_ability_1 = {
			time = 1.5
		},
		combat_ability_2 = {
			attack_speed = 0.2,
			on_lunge_end_proc_chance = 1,
			active_duration = 10
		},
		combat_ability_3 = {
			max_charges = 2
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
			warpcharge_vent = 0.5,
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
			soul_duration = 25,
			damage = 0.24,
			base_max_souls = 4,
			on_combat_ability_proc_chance = 1,
			on_hit_proc_chance = 1
		},
		passive_2 = {
			warp_charge_percent = 0.1,
			on_hit_proc_chance = 0.1,
			warp_charge_amount = 0.9
		},
		toughness_1 = {
			on_hit_proc_chance = 1,
			max_stacks_cap = 1,
			max_stacks = 1,
			duration = 5,
			percent_toughness = 0.06
		},
		toughness_2 = {
			percent_toughness = 0.15
		},
		toughness_3 = {
			multiplier = 0.5
		},
		offensive_1_1 = {
			damage_min = 0.1,
			damage = 0.25
		},
		offensive_1_2 = {
			vent_speed = 1,
			warp_charge_capacity = 0.64
		},
		offensive_1_3 = {
			num_stacks = 4,
			distance = 4
		},
		coop_1 = {
			on_kill_proc_chance = 0.04
		},
		coop_2 = {
			percent = 0.15
		},
		coop_3 = {
			damage_taken_multiplier = 1.25,
			duration = 5
		},
		defensive_1 = {
			warp_charge_cost_multiplier = 0.25
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
			num_stacks = 4,
			distance = 15,
			stacks_to_share = 4
		},
		offensive_2_3 = {
			cooldown = 15,
			smite_chance = 0.1
		},
		combat_ability_1 = {
			stacks = 2,
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
