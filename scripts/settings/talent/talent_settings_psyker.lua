-- chunkname: @scripts/settings/talent/talent_settings_psyker.lua

local talent_settings = {
	shared = {
		venting = {
			vent_to_toughness = 0.5,
		},
	},
	overcharge_stance = {
		base_damage = 0.1,
		cooloff_duration = 1.5,
		crit_chance = 0.2,
		damage_per_stack = 0.01,
		finesse_damage_per_stack = 0.01,
		max_stacks = 30,
		post_stance_duration = 10,
		second_per_weakspot = 1,
	},
	mark_passive = {
		weakspot_stacks = 3,
	},
	psyker = {
		throwing_knives = {
			charges_restored = 5,
		},
		nearby_soublaze_defense = {
			max = 0.5,
			max_stacks = 5,
			min = 1,
		},
		cleave_from_peril = {
			max = 1,
			min = 0,
		},
		blocking_soulbaze = {
			stacks = 1,
		},
		melee_weaving = {
			duration = 4,
			vent_percentage = 0.05,
			warp_generation = 0.8,
		},
		melee_attack_speed = {
			attack_speed = 0.1,
		},
		glass_cannon = {
			toughness_replenish_multiplier = 0.7,
			warp_charge_amount = 0.6,
		},
		warp_attacks_rending = {
			threshold = 0.75,
			warp_rending = 0.1,
		},
		ranged_shots_soulblaze = {
			proc_chance = 1,
			stacks = 1,
		},
		ranged_crits_vent = {
			proc_chance = 1,
			warp_charge_percent = 0.04,
		},
		reload_speed_warp = {
			reload_speed = 0.25,
			threshold = 0.75,
			warp_charge = 0.25,
		},
		soulblaze_reduces_damage_taken = {
			toughness_damage_taken_multiplier = 0.67,
		},
		psyker_force_staff_melee_attack_bonus = {
			max = 1,
			min = 0,
			venting = 0.1,
		},
		psyker_force_staff_wield_speed = {
			max = 0.5,
			min = 0,
		},
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
		combat_ability_3 = {},
	},
	psyker_2 = {
		combat_ability = {
			cooldown = 30,
			max_charges = 1,
			max_radius = 8.75,
			min_radius = 5,
			override_max_radius = 12.5,
			override_min_radius = 5,
			override_radius = 5,
			power_level = 500,
			radius = 5,
			shout_dot = 0.9,
			shout_range = 30,
			warpcharge_vent_base = 0.1,
			warpcharge_vent_improved = 0.5,
		},
		grenade = {
			cooldown = 1,
			max_charges = 1,
		},
		coherency = {
			damage_vs_elites = 0.075,
			max_stacks = 1,
		},
		passive_1 = {
			base_max_souls = 4,
			damage = 0.24,
			on_combat_ability_proc_chance = 1,
			on_hit_proc_chance = 1,
			soul_duration = 25,
		},
		passive_2 = {
			on_hit_proc_chance = 0.1,
			warp_charge_amount = 0.9,
			warp_charge_percent = 0.1,
		},
		toughness_1 = {
			duration = 5,
			max_stacks = 1,
			max_stacks_cap = 1,
			on_hit_proc_chance = 1,
			percent_toughness = 0.06,
		},
		toughness_2 = {
			percent_toughness = 0.075,
		},
		toughness_3 = {
			multiplier = 0.5,
		},
		toughness_4 = {
			multiplier = 0.25,
		},
		offensive_1_1 = {
			damage = 0.2,
			damage_min = 0,
		},
		offensive_1_2 = {
			warp_charge_capacity = 0.64,
		},
		offensive_1_3 = {
			distance = 4,
			num_stacks = 3,
		},
		coop_1 = {
			on_kill_proc_chance = 0.04,
		},
		coop_2 = {
			percent = 0.05,
		},
		coop_3 = {
			damage_taken_multiplier = 1.25,
			duration = 5,
		},
		defensive_1 = {
			warp_charge_cost_multiplier = 0.25,
		},
		defensive_2 = {
			max_toughness_damage_multiplier = 0.67,
			min_toughness_damage_multiplier = 0.9,
		},
		defensive_3 = {
			vent_warp_charge_decrease_movement_reduction = 0,
		},
		offensive_2_1 = {
			max_souls_talent = 6,
		},
		offensive_2_2 = {
			distance = 15,
			num_stacks = 4,
			stacks_to_share = 4,
		},
		offensive_2_3 = {
			cooldown = 15,
			smite_chance = 0.1,
		},
		combat_ability_1 = {
			cooldown_reduction_percent = 0.075,
			stacks = 2,
		},
		combat_ability_2 = {
			soul_chance = 0.1,
		},
		combat_ability_3 = {
			duration = 10,
			smite_attack_speed = 0.75,
			warp_charge_amount_smite = 0.5,
		},
	},
	psyker_3 = {
		combat_ability = {
			cooldown = 40,
			damage_cooldown = 0.33,
			damage_per_hit = 1,
			duration = 17.5,
			health = 20,
			max_charges = 1,
			sphere_duration = 25,
			sphere_health = 20,
			toughness_damage_reduction = 0.5,
			toughness_duration = 5,
			toughness_for_allies = 0.1,
		},
		grenade = {
			default_power_level = 500,
			duration = 3,
			max_charges = 1,
			max_stacks = 1,
			max_stacks_cap = 1,
			on_hit_proc_chance = 0.15,
			quick_max_stacks = 1,
			quick_max_stacks_cap = 1,
			quick_multiplier = 0.25,
			interval = {
				0.3,
				0.8,
			},
			quick_interval = {
				0.1,
				0.3,
			},
			stun_interval = {
				0.3,
				0.8,
			},
		},
		coherency = {
			ability_cooldown_modifier = -0.075,
			ability_cooldown_modifier_improved = -0.1,
			max_stacks = 1,
		},
		passive_1 = {
			chain_lightning_damage = 2,
			empowered_chain_lightning_chance = 0.075,
			max_stacks = 1,
			psyker_smite_cost_multiplier = 0,
		},
		passive_2 = {},
		passive_3 = {
			proc_chance = 0.15,
		},
		passive_4 = {
			damage = 0.25,
		},
		mixed_1 = {
			fixed_percentage = 0.05,
			on_hit_proc_chance = 1,
		},
		mixed_2 = {
			warp_charge_removal = 0.2,
		},
		mixed_3 = {
			vent_warp_charge_speed = 0.7,
		},
		offensive_1 = {
			chain_lightning_max_angle = 0,
			chain_lightning_max_jumps = 1,
			chain_lightning_max_radius = 1,
			chain_lightning_ranged_visuzalier = 0.2,
		},
		offensive_2 = {
			max_stacks_talent = 3,
		},
		offensive_3 = {
			power_level = 500,
			proc_chance = 0.1,
			special_proc_chance = 1,
		},
		defensive_1 = {
			duration = 6,
			max_stacks = 1,
			movement_speed = 0.1,
			toughness_damage_taken_multiplier = 0.8,
		},
		defensive_2 = {
			toughness_damage_taken_multiplier = 0.7,
		},
		defensive_3 = {
			active_duration = 2.5,
			movement_speed = 0.15,
			on_chain_lighting_start_proc_chance = 1,
		},
		coop_1 = {
			toughness_percent = 1,
		},
		coop_2 = {
			ability_cooldown_modifier = -0.15,
			max_stacks = 1,
		},
		coop_3 = {
			distance = 5,
			interval = 1,
			toughness_percentage = 0.05,
		},
		spec_passive_1 = {
			toughness_for_allies = 0.15,
		},
		spec_passive_2 = {
			empowered_chain_lightning_chance = 0.125,
		},
		spec_passive_3 = {
			attack_speed = 0.15,
			duration = 3,
		},
		combat_ability_1 = {
			cooldown = 45,
			max_charges = 2,
		},
		combat_ability_2 = {
			damage_cooldown = 0.5,
			damage_per_hit = 1,
			duration = 30,
			health = 30,
		},
		combat_ability_3 = {},
	},
}

return talent_settings
