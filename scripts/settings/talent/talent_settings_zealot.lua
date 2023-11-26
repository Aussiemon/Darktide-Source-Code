-- chunkname: @scripts/settings/talent/talent_settings_zealot.lua

local talent_settings = {
	zealot_1 = {
		combat_ability = {},
		grenade = {},
		coherency = {
			toughness_min_stack_override = 2
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
		combat_ability_3 = {}
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
		throwing_knives = {
			melee_kill_refill_amount = 1
		},
		coherency = {
			max_stacks = 1,
			toughness_damage_taken_multiplier = 0.925
		},
		passive_1 = {
			damage_per_step = 0.08,
			health_step = 0.15,
			toughness_reduction_per_stack = -0.05,
			max_stacks = 3,
			martyrdom_max_stacks = 7
		},
		passive_2 = {
			on_damage_taken_proc_chance = 1,
			cooldown_duration = 120,
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
			ticks_per_second = 3,
			toughness = 0.05,
			num_enemies = 3,
			range = 5
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
			attack_speed_per_segment = 0.04,
			attack_speed_low = 0.2,
			attack_speed = 0.1,
			first_health_threshold = 0.5,
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
			cooldown_duration = 120,
			leech = 0.007,
			on_hit_proc_chance = 1,
			melee_multiplier = 3,
			duration = 5,
			active_duration = 5
		},
		defensive_2 = {
			on_damage_taken_proc_chance = 1,
			movement_speed = 0.15,
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
	zealot_3 = {
		combat_ability = {
			static_power_level = 500,
			radius = 5,
			min_close_radius = 2,
			min_radius = 3,
			cooldown = 45,
			close_radius = 2,
			duration = 5,
			toughness_restored = 1,
			toughness_bonus_flat = 400,
			power_level = 500,
			max_charges = 1,
			explosion_area_suppression = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 15,
				suppression_value = 20
			}
		},
		grenade = {
			max_charges = 3
		},
		coherency = {
			corruption_heal_amount = 0.5,
			interval = 1
		},
		passive_1 = {
			max_dist = 25,
			toughness_on_max_stacks_small = 0.02,
			max_resource = 25,
			toughness_on_max_stacks = 0.5,
			duration = 8,
			crit_chance = 0.15,
			buff_removal_time_modifier = 0.8
		},
		passive_2 = {
			damage_vs_disgusting = 0.2,
			damage_vs_resistant = 0.2
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
			power_level = 2000,
			inner_push_rad = math.pi * 0.125,
			outer_push_rad = math.pi * 0.25
		},
		defensive_2 = {
			health_segment_damage_taken_multiplier = 0.6
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
			damage_taken_multiplier = 0.4
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
		},
		bolstering_prayer = {
			toughness_percentage = 0.2,
			self_toughness = 0.5,
			tick_rate = 0.8,
			team_toughness = 0.25
		},
		combat_ability_cd_restore_on_damage = {
			damage_taken_to_ability_cd_percentage = 0.01
		},
		zealot_backstab_kills_restore_cd = {
			combat_ability_cd_percentage = 0.2
		},
		quickness = {
			toughness_percentage = 0.02,
			dodge_stacks = 3,
			max_stacks = 20
		}
	}
}

return talent_settings
