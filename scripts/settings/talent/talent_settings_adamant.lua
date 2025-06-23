-- chunkname: @scripts/settings/talent/talent_settings_adamant.lua

local talent_settings = {
	adamant = {
		combat_ability = {
			shout = {
				cooldown = 60,
				range = 6,
				far_range = 12,
				max_charges = 1
			},
			shout_improved = {
				far_range = 16,
				range = 6,
				cooldown = 60,
				toughness = 0.3,
				max_charges = 1
			},
			charge = {
				toughness_max = 1,
				range = 3.75,
				damage = 0.25,
				impact = 0.5,
				cooldown = 20,
				cooldown_max = 5,
				toughness = 0.2,
				stamina = 0.15,
				cooldown_reduction = 0.5,
				distance_increase = 3.75,
				cooldown_elite = 1,
				duration = 6,
				stamina_max = 0.75,
				max_charges = 1
			},
			stance = {
				duration = 10,
				movement_speed_reduction_multiplier = 0,
				damage_taken_multiplier = 0.2,
				max_charges = 1,
				cooldown = 45,
				ammo_percent = 0.1,
				damage_talent_stacks = 10,
				ammo_icd = 1.5,
				damage_talent_damage = 0.05,
				movement_speed = 0.15,
				damage = 0.25,
				companion_damage = 0.75,
				linger_time = 2,
				damage_talent_duration = 10,
				cooldown_reduction = 0.05
			}
		},
		coherency = {
			adamant_wield_speed_aura = {
				wield_speed = 0.1
			},
			adamant_damage_vs_staggered_aura = {
				damage_vs_staggered = 0.1
			},
			companion = {
				tdr = -0.075
			},
			reload_speed_aura = {
				reload_speed = 0.075
			}
		},
		blitz_ability = {
			drone = {
				duration = 20,
				range = 7.5,
				tdr = 0.3,
				recoil_modifier = -0.25,
				impact = 0.3,
				revive_speed_modifier = 0.3,
				enemy_melee_damage = -0.25,
				attack_speed = 0.1,
				enemy_melee_attack_speed = -0.25,
				suppression = 0.3,
				damage_taken = 1.15,
				toughness = 0.05,
				toughness_improved = 0.075
			},
			shock_mine = {
				duration = 15,
				range = 5
			},
			whistle = {
				movement_speed = 0.25,
				damage = 0.5,
				charges = 3,
				cooldown = 60,
				duration = 8
			},
			grenade = {
				radius_increase = 0.5,
				improved_charges = 4,
				base_charges = 3,
				damage_increase = 0.5
			}
		},
		execution_order = {
			time = 8,
			monster_damage = -0.25,
			target_time = 3,
			crit_damage = 0.25,
			crit_chance = 0.1,
			damage = 0.15,
			damage_vs_monsters = 0.01,
			cdr_time = 3,
			cdr = 0.5,
			damage_taken_vs_monsters = 0.99,
			perma_max_stack = 30,
			companion_damage = 1.5,
			ally_toughness = 0.1,
			toughness = 0.15,
			attack_speed = 0.1,
			rending = 0.1
		},
		elite_special_kills_offensive_boost = {
			duration = 4,
			movement_speed = 0.1,
			damage = 0.1
		},
		damage_after_reloading = {
			ranged_damage = 0.15,
			duration = 5
		},
		multiple_hits_attack_speed = {
			duration = 3,
			melee_attack_speed = 0.1,
			num_hits = 3
		},
		dog_kills_replenish_toughness = {
			duration = 5,
			toughness = 0.05
		},
		elite_special_kills_replenish_toughness = {
			duration = 4,
			toughness = 0.025,
			instant_toughness = 0.1
		},
		close_kills_restore_toughness = {
			toughness = 0.05
		},
		staggers_replenish_toughness = {
			toughness = 0.1
		},
		dog_attacks_electrocute = {
			power_level = 500,
			duration = 5
		},
		electrocuted_targets_deal_less_damage = {
			damage_modifier = -0.15,
			duration = 8
		},
		melee_weakspot_stagger = {},
		increased_damage_vs_horde = {
			damage = 0.2
		},
		limit_dmg_taken_from_hits = {
			limit = 50
		},
		armor = {
			toughness = 25
		},
		mag_strips = {
			wield_speed = 0.25
		},
		plasteel_plates = {
			toughness = 25
		},
		verispex = {
			range = 25
		},
		ammo_belt = {
			ammo_reserve_capacity = 0.25
		},
		rebreather = {
			damage_taken_from_toxic_gas_multiplier = 0.25,
			corruption_taken_multiplier = 0.8
		},
		riot_pads = {
			stacks = 5,
			cooldown = 5
		},
		gutter_forged = {
			tdr = -0.15,
			movement_speed = -0.1
		},
		shield_plates = {
			duration = 3,
			toughness = 0.15,
			perfect_toughness = 0.1,
			icd = 1
		},
		disable_companion = {
			damage = 0.1,
			extra_max_amount_of_grenades = 1,
			tdr = -0.15,
			blitz_replenish_time = 60,
			attack_speed = 0.1
		},
		damage_reduction_after_elite_kill = {
			damage_taken_multiplier = 0.75,
			duration = 5
		},
		toughness_regen_near_companion = {
			range = 8,
			toughness_percentage_per_second = 0.05
		},
		perfect_block_damage_boost = {
			damage = 0.15,
			duration = 8,
			attack_speed = 0.1,
			block_cost = 0.85
		},
		staggers_reduce_damage_taken = {
			ogryn_stacks = 5,
			duration = 8,
			damage_taken_multiplier = 0.97,
			max_stacks = 5,
			normal_stacks = 1
		},
		cleave_after_push = {
			cleave = 0.75,
			duration = 5
		},
		melee_attacks_on_staggered_rend = {
			rending_multiplier = 0.15
		},
		ranged_damage_on_melee_stagger = {
			duration = 5,
			ranged_damage = 0.15
		},
		wield_speed_on_melee_kill = {
			max_stacks = 5,
			duration = 8,
			wield_speed_per_stack = 0.05
		},
		heavy_attacks_increase_damage = {
			damage = 0.15,
			duration = 5
		},
		dog_damage_after_ability = {
			damage = 0.5,
			duration = 12
		},
		hitting_multiple_gives_tdr = {
			duration = 5,
			tdr = 0.8,
			num_hits = 3
		},
		dog_pounces_bleed_nearby = {
			bleed_stacks = 8
		},
		dog_applies_brittleness = {
			stacks = 6
		},
		no_movement_penalty = {
			reduced_move_penalty = 0.5
		},
		restore_toughness_to_allies_on_combat_ability = {
			toughness_percent = 0.2
		},
		forceful = {
			cleave = 0.5,
			stack_duration = 5,
			strength_duration = 10,
			dr = 0.975,
			impact = 0.05,
			internal_cd = 5,
			low_stacks = 0,
			ranged_attack_speed = 0.025,
			stacks = 10,
			stun_immune_linger_time = 3,
			high_stacks = 10,
			reload_speed = 0.02,
			toughness = 0.005,
			attack_speed = 0.1,
			strength = 0.025
		},
		forceful_ranged = {
			reload_speed = 0.15,
			ranged_attack_speed = 0.1
		},
		forceful_melee = {
			cleave = 0.5,
			melee_attack_speed = 0.1
		},
		forceful_companion = {
			companion_damage = 0.25
		},
		forceful_toughness_regen = {
			instant_toughness = 0.25,
			toughness_per_second = 0.03
		},
		stance_dance = {
			power = 0.15,
			fire_rate = 0.15,
			crit_chance = 0.1,
			melee_damage = 0.15,
			suppression_dealt = 0.5,
			hits = 3,
			toughness_share = 0.15,
			damage_reduction = 0.85,
			weakspot_damage = 0.25,
			melee_attack_speed = 0.1,
			reload_speed = 0.2,
			ranged_damage = 0.15,
			cleave = 0.75,
			time = 5,
			crit_damage = 0.25,
			sprint_cost = 0.8,
			shared_power = 0.1
		},
		exterminator = {
			duration = 12,
			stamina = 0.1,
			damage = 0.04,
			boss_damage = 0.04,
			cooldown = 0.25,
			ammo = 0.1,
			stacks = 2,
			companion_damage = 0.04,
			max_stacks = 10,
			toughness = 0.1
		},
		terminus_warrant = {
			max_stacks = 30,
			fire_rate = 0.15,
			melee_attack_speed = 0.15,
			melee_damage = 0.15,
			suppression_dealt = 0.5,
			duration = 8,
			ranged_remove = 1,
			ranged_rending = 0.15,
			swap_stacks_talent = 30,
			max_stacks_talent = 30,
			melee_cleave = 0.15,
			swap_stacks = 15,
			reload_speed = 0.2,
			ranged_damage = 0.15,
			weakspot_damage = 0.25,
			toughness_shared = 0.25,
			melee_rending = 0.15,
			bonus_stacks = 10,
			melee_impact = 0.25,
			crit_damage = 0.25,
			melee_toughness = 1,
			melee_remove = 1,
			ranged_max_hit_mass_attack_modifier = 0.5
		},
		crit_chance_on_kill = {
			max_stacks = 8,
			duration = 10,
			crit_chance = 0.02
		},
		crits_rend = {
			rending = 0.2
		},
		elite_special_kills_reload_speed = {
			reload_speed = 0.2
		},
		dodge_grants_damage = {
			damage = 0.15,
			duration = 5
		},
		stacking_weakspot_strength = {
			max_stacks = 8,
			duration = 10,
			strength = 0.02
		},
		stacking_damage = {
			stacks = 5,
			duration = 5,
			damage = 0.03
		},
		increased_damage_to_high_health = {
			damage = 0.15,
			health = 0.75
		},
		staggering_enemies_take_more_damage = {
			damage = 0.15,
			duration = 5
		},
		staggered_enemies_deal_less_damage = {
			damage = -0.2,
			duration = 5
		},
		melee_weakspot_hits_count_as_stagger = {
			duration = 4
		},
		companion_focus_melee = {
			damage = 0.25
		},
		companion_focus_ranged = {
			damage = 0.5
		},
		companion_focus_elite = {
			damage = 0.25
		},
		bullet_rain = {
			duration = 6,
			stack_duration = 8,
			tdr = 0.5,
			ranged_damage = 0.15,
			suppression_dealt = 1,
			fire_rate = 0.25,
			tdr_per_stack = 0.01,
			max_stacks = 30,
			toughness_replenish = 0.75
		},
		movement_speed_on_block = {
			duration = 3,
			movement_speed = 0.15
		},
		damage_vs_suppressed = {
			damage_vs_suppressed = 0.25
		},
		clip_size = {
			clip_size_modifier = 0.15
		},
		pinning_dog_kills_cdr = {
			time = 3,
			regen = 0.5
		},
		pinning_dog_kills_buff_allies = {
			duration = 5,
			toughness = 0.1,
			tdr = 0.8
		},
		pinning_dog_permanent_stacks = {
			damage = 0.025,
			stacks = 30
		},
		pinning_dog_elite_damage = {
			damage = 0.15,
			duration = 8
		},
		pinning_dog_cleave_bonus = {
			cleave = 0.5,
			time = 5
		},
		pinning_dog_bonus_moving_towards = {
			time = 5,
			movement_speed = 0.1,
			damage = 0.1
		},
		weapon_handling = {
			spread = -0.075,
			recoil = -0.075,
			time = 0.1,
			stacks = 10
		},
		sprinting_sliding = {
			speed = 0.05,
			duration = 5,
			cd = 0.75,
			stamina = 0.05
		},
		uninterruptible_heavies = {},
		monster_hunter = {
			damage = 0.2
		},
		stamina_spent_replenish_toughness = {
			toughness = 0.15,
			stamina = 1,
			duration = 3
		},
		dodge_improvement = {
			dodge_duration = 0.25,
			dodge = 1
		},
		first_melee_hit_increased_damage = {
			damage = 0.15,
			impact = 0.3
		}
	}
}

return talent_settings
