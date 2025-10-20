-- chunkname: @scripts/settings/talent/talent_settings_ogryn.lua

local talent_settings = {
	ogryn_shared = {
		tank = {
			damage_taken_multiplier = 0.8,
			static_movement_reduction_multiplier = 0,
			toughness_damage_taken_multiplier = 0.75,
		},
		revive = {
			assist_speed_modifier = 0.25,
			revive_speed_modifier = 0.25,
		},
		radius = {
			coherency_aura_size_increase = 0.5,
		},
		explosions_burn = {
			close_stacks = 2,
			max_stacks = 8,
			stacks = 1,
		},
		frag_bomb_bleed = {
			stacks = 12,
		},
		box_bleed = {
			stacks = 2,
		},
		ogryn_suppression_immunity_on_high_toughness = {
			toughness = 0.5,
		},
		ogryn_movement_boost_on_ranged_damage = {
			cooldown_duration = 6,
			duration = 1,
			ranged_damage_taken_multiplier = 0.25,
		},
		ogryn_protect_allies = {
			cooldown_duration = 20,
			duration = 10,
			power_level_modifier = 0.1,
			revive_speed_modifier = 0.25,
			toughness_damage_reduction = 0.75,
		},
		ogryn_damage_reduction_after_elite_kill = {
			damage_taken_multiplier = 0.9,
			duration = 5,
		},
		ogryn_melee_attacks_give_mtdr = {
			damage_taken_multiplier = 0.96,
			stacks = 5,
		},
		ogryn_reload_speed_on_empty = {
			reload_speed = 0.15,
		},
		ogryn_stagger_cleave_on_third = {
			count = 3,
			max_hit_mass_attack_modifier = 0.25,
			melee_impact_modifier = 0.25,
		},
		ogryn_block_increases_power = {
			duration = 6,
			melee_impact_modifier = 0.1,
			stacks = 8,
		},
		ogryn_stacking_attack_speed = {
			duration = 5,
			max_stacks = 5,
			melee_attack_speed = 0.025,
		},
		ogryn_taking_damage_improves_handling = {
			duration = 5,
			recoil_modifier = -0.35,
			spread_modifier = -0.35,
		},
		ogryn_damage_reduction_on_high_stamina = {
			damage_taken_multiplier = 0.875,
			stamina_threshold = 0.75,
		},
		ogryn_multiple_staggers_restore_stamina = {
			stamina = 0.15,
		},
		ogryn_melee_damage_after_heavy = {
			duration = 5,
			melee_damage_modifier = 0.15,
		},
		ogryn_far_damage = {
			damage_far = 0.15,
		},
		ogryn_corruption_resistance = {
			corruption_taken_multiplier = 0.6,
		},
		ogryn_carapace_explosion = {
			stacks = 5,
			toughness = 0.5,
		},
		ogryn_heavy_hitter = {
			cleave = 0.125,
			heavy_stacks = 2,
			max_stacks = 8,
			melee_damage = 0.03,
			stacks = 1,
			stagger = 0.075,
			tdr = 0.0125,
			toughness_melee_replenish = 0.15,
		},
		toughness_coherency_aura = {
			toughness_replenish_modifier = 0.2,
		},
		special_ammo_armor_pen = {
			damage = 0.15,
			rending_multiplier = 0.15,
		},
		ogryn_weakspot_damage = {
			power = 0.1,
		},
		ogryn_big_box_of_hurt_more_bombs = {
			amount = 3,
		},
		ogryn_staggering_increases_damage_taken = {
			damage = 0.15,
			duration = 5,
		},
		ogryn_drain_stamina_for_handling = {
			recoil_modifier = -0.15,
			spread_modifier = -0.2,
			stamina_per_second = 0.5,
			sway_modifier = 0.4,
		},
		ogryn_wield_speed_increase = {
			wield_speed = 0.2,
		},
		ogryn_ranged_damage_immunity = {
			cooldown = 4,
			duration = 2.5,
			ranged_damage_taken_multiplier = 0.8,
		},
		ogryn_melee_improves_ranged = {
			duration = 10,
			max_stacks = 5,
			ranged_damage = 0.03,
		},
		ogryn_pushing_applies_brittleness = {
			stacks = 4,
		},
		ogryn_taunt_restore_toughness = {
			duration = 3.25,
			instant_toughness = 0.1,
			max_stacks = 20,
			toughness_per_hit = 0.005,
		},
		ogryn_ranged_improves_melee = {
			duration = 6,
			melee_attack_speed = 0.075,
			melee_damage = 0.15,
		},
		ogryn_crit_damage_increase = {
			critical_strike_damage = 0.75,
		},
		ogryn_block_all_attacks = {
			duration = 5,
			melee_damage = 0.2,
		},
		ogryn_blo_melee = {
			chance = 0.1,
			max_stacks = 10,
		},
		ogryn_blo_ally_ranged_buffs = {
			duration = 8,
			ranged_damage = 0.15,
		},
		ogryn_damage_taken_by_all_increases_strength_tdr = {
			duration = 10,
			max_stacks = 5,
			power_level_modifier = 0.02,
			tdr = 0.85,
		},
		ogryn_replenish_rock_on_miss = {
			cooldown_duration = 5,
		},
		ogryn_thrust = {
			max_stacks = 4,
			melee_damage = 0.0375,
			melee_impact_modifier = 0.075,
		},
		ogryn_suppression_increase = {
			suppression = 0.25,
		},
	},
	ogryn_1 = {
		combat_ability = {
			clip_size_visualizer = 3,
			cooldown = 80,
			max_charges = 1,
			resistance_duration = 5,
		},
		passive_1 = {
			duration = 10,
			fire_rate = 0.015,
			free_ammo_proc_chance = 0.15,
			max_stacks = 10,
			ranged_damage = 0.02,
			wield_speed = 0.015,
		},
		passive_2 = {
			reduced_damage_while_braced = 0.75,
		},
		passive_3 = {
			increased_max_ammo = 0.25,
		},
		aura = {
			damage_vs_suppressed = 0.2,
		},
		mixed_1 = {
			damage_after_reload = 0.15,
			duration = 8,
		},
		mixed_2 = {
			percent_toughness_ranged_kill = 0.02,
		},
		mixed_3 = {
			increased_clip_size = 0.25,
		},
		offensive_1 = {
			crit_chance_on_kill = 0.02,
			duration = 12,
			max_stacks = 8,
		},
		offensive_2 = {
			increased_suppression = 0.25,
		},
		offensive_3 = {
			duration = 5,
			multi_hit_window = 0.5,
			num_multi_hit = 3,
			reload_speed_on_multi_hit = 0.15,
		},
		defensive_1 = {},
		defensive_2 = {
			duration = 3,
			move_speed_on_ranged_kill = 0.2,
		},
		defensive_3 = {
			braced_toughness_regen = 0.125,
		},
		coop_1 = {
			team_max_ammo_increase = 0.15,
		},
		coop_2 = {
			damage_vs_suppressed_aura_improved = 0.3,
		},
		coop_3 = {
			duration = 8,
			max_stacks = 4,
			reduced_ranged_damage_per_ally = 0.75,
		},
		spec_passive_1 = {
			duration = 4,
			increased_cooldown_regeneration = 1,
		},
		spec_passive_2 = {
			increased_passive_proc_chance = 0.12,
		},
		spec_passive_3 = {},
		combat_ability_1 = {
			max_stacks = 16,
			num_stacks = 4,
		},
		combat_ability_2 = {
			reduced_clip_size_modifier = -1,
			reduced_clip_visualizer = 2,
		},
		combat_ability_3 = {
			increased_damage_vs_close = 0.15,
			reduced_move_penalty = 0.5,
		},
	},
	ogryn_2 = {
		combat_ability = {
			active_duration = 5,
			cooldown = 30,
			distance = 12,
			max_charges = 1,
			melee_attack_speed = 0.25,
			movement_speed = 0.25,
			on_lunge_end_proc_chance = 1,
			radius = 2,
		},
		grenade = {
			max_charges = 2,
		},
		coherency = {
			max_stacks = 1,
			melee_damage = 0.075,
			melee_damage_improved = 0.1,
		},
		passive_1 = {
			cooldown = 1,
			impact_modifier = 0.25,
			stamina = 0.05,
		},
		passive_2 = {
			damage_taken_multiplier = 0.75,
			melee_heavy_damage = 0.5,
		},
		toughness_1 = {
			toughness_bonus = 1,
		},
		toughness_2 = {
			on_sweep_finish_proc_chance = 1,
			reduced_toughness = 0.05,
			toughness = 0.15,
		},
		toughness_3 = {
			heavy_toughness = 0.15,
			on_sweep_finish_proc_chance = 1,
			toughness = 0.05,
		},
		offensive_1 = {
			damage_vs_ogryn = 0.3,
			ogryn_damage_taken_multiplier = 0.7,
		},
		offensive_2 = {},
		offensive_3 = {
			light_stacks = 1,
			stacks = 4,
		},
		coop_1 = {
			coherency_aura_size_increase = 0.75,
		},
		coop_2 = {
			duration = 6,
			max_stacks = 1,
			movement_speed = 0.2,
			on_lunge_start_proc_chance = 1,
		},
		coop_3 = {
			cooldown = 0.04,
			damage_taken_multiplier = 0.5,
			duration = 3,
			increased_cooldown_regeneration = 1,
		},
		defensive_1 = {
			max = 0.7,
			max_stacks = 6,
			min = 1,
			time = 1,
		},
		defensive_2 = {
			distance = 20,
			max = 0.4,
			min = 1,
		},
		defensive_3 = {
			increased_toughness_health_threshold = 0.5,
			sprinting_cost_multiplier = 0.8,
			toughness_replenish_modifier = 1,
		},
		offensive_2_1 = {
			damage = 0.15,
			time = 5,
		},
		offensive_2_2 = {
			duration = 10,
			max_stacks = 25,
			melee_heavy_damage = 0.01,
		},
		offensive_2_3 = {
			max_targets = 10,
			melee_damage = 0.03,
			on_hit_proc_chance = 1,
			on_sweep_finish_proc_chance = 1,
		},
		combat_ability_1 = {
			cooldown = 30,
			max_charges = 1,
			stacks = 5,
		},
		combat_ability_2 = {
			cooldown = 30,
			distance = 24,
			increase_visualizer = 1,
			max_charges = 1,
		},
		combat_ability_3 = {
			cooldown = 30,
			max_charges = 1,
			toughness = 0.1,
		},
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
		combat_ability_3 = {},
	},
}

return talent_settings
