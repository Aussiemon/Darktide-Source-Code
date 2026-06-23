-- chunkname: @scripts/settings/talent/talent_settings_cryptic.lua

local PASSIVE_COOLDOWN_REGENERATION_PERCENT_PER_SECOND = 0.02
local COMBAT_ABILITY_COOLDOWN = 1 / PASSIVE_COOLDOWN_REGENERATION_PERCENT_PER_SECOND
local talent_settings = {
	cryptic = {
		general = {
			passive_cooldown_regeneration_percent_per_second = PASSIVE_COOLDOWN_REGENERATION_PERCENT_PER_SECOND,
			combat_ability_cooldown_time = COMBAT_ABILITY_COOLDOWN,
		},
		cryptic_passive_cooldown_regen = {
			base_charges = 3,
			charge_gain = 1,
			max_charge = 3,
			max_power = 1,
			min_charge = 1,
			cooldown_percent_regen_per_second = PASSIVE_COOLDOWN_REGENERATION_PERCENT_PER_SECOND,
		},
		combat_ability_cooldown_recharge_on_kill = {
			cooldown_replenish_base = 0.02,
			cooldown_replenish_elite_or_special = 0.04,
		},
		cryptic_aura_blitz_charges = {
			extra_max_amount_of_grenades = 1,
			toughness = 25,
		},
		cryptic_aura_weapon_improved = {
			max_hit_mass_attack_modifier = 0.15,
			rending_multiplier = 0.075,
			toughness = 25,
		},
		cryptic_coherency_regen_aura = {
			min_toughness_coherency_regen_rate_modifier = 0.25,
		},
		cryptic_coherency_regen_aura_improved = {
			min_toughness_coherency_regen_rate_modifier = 0.5,
			toughness = 25,
		},
		cryptic_ammo_aura = {
			ammo_reserve_capacity = 0.1,
			toughness = 25,
		},
		servo_skull_medicae = {
			duration = 5,
			instant_toughness_percent = 0.5,
			tdr = 0.25,
			toughness_bonus = 50,
			toughness_percent = 0.2,
		},
		servo_skull_shooting_base = {
			burn_stacks = 1,
			cooldown = 16,
			cooldown_modifier = 0.5,
			damage_modifier = 0.25,
			damage_taken_multiplier = 0.15,
			debuff_duration = 5,
			duration = 8,
			max_burn_stacks = 8,
		},
		servo_skull_shooting_tagging = {
			capacitance = 0.25,
			cooldown_modifier = 0.15,
			duration = 2,
		},
		discharge_ability = {
			buff_duration = 15,
			electrocute_enemies_radius = 12,
			max_charges = 3,
			stun_duration_base = 2,
			stun_duration_weapon = 2,
			weapon_malfunction_radius = 30,
			cooldown = COMBAT_ABILITY_COOLDOWN,
			one_charge_bonus = {
				duration = 15,
				num_charges_used_required = 1,
				toughness_replenish_modifier = 0.5,
			},
			two_charge_bonus = {
				attack_speed = 0.15,
				duration = 15,
				num_charges_used_required = 2,
			},
			cryptic_discharge_toughness = {
				toughness_percent_on_use = 0.25,
				toughness_percent_per_hit = 0.01,
			},
			cryptic_discharge_arc_bonus = {
				broadphase_radius = 12,
				max_arcs = 5,
				num_arcs_per_charge_used = 1,
			},
		},
		precision_stance = {
			cooldown_percent_cost_on_activation = 0.25,
			cooldown_percent_lost_per_second = 0.1,
			cooldown_percent_used_on_shoot = 0.01,
			max_charges = 3,
			recoil_modifier = -0.6,
			spread_modifier = -0.9,
			weakspot_damage = 0.25,
			cooldown = COMBAT_ABILITY_COOLDOWN,
			cryptic_precision_stance_toughness_suppression = {
				toughness_regen_per_second = 0.1,
			},
			cryptic_precision_stance_fire_rate_increased = {
				buff_start_delay = 4,
				increased_ranged_attack_speed = 0.3,
				ranged_attack_speed = 0.15,
			},
			cryptic_precision_stance_reload_speed_delayed = {
				buff_start_delay = 0,
				lingering_buff_time = 5,
				reload_speed = 0.25,
			},
			cryptic_precision_stance_damage_on_elite_kill = {
				damage = 0.05,
				duration = 10,
				max_stacks = 5,
			},
			cryptic_precision_stance_crit_cleave = {
				increased_boost_delay = 4,
				increased_ranged_critical_strike_chance = 0.3,
				increased_ranged_max_hit_mass_attack_modifier = 0.6,
				ranged_critical_strike_chance = 0.15,
				ranged_max_hit_mass_attack_modifier = 0.3,
			},
		},
		chordclaw_ability = {
			buff_after_attack_duration = 10,
			cooldown_percent_restored_on_full_use = 0.5,
			damage_taken_multipler_while_wielding = 0.25,
			duration = 20,
			max_charges = 3,
			max_melee_hit_mass_attack_modifier = 0.5,
			melee_damage = 0.3,
			num_charges_replenished_on_kill = 1,
			rending = 0.5,
			unused_charge_restored_multiplier = 1,
			cooldown = COMBAT_ABILITY_COOLDOWN,
			dash = {
				distance = 4,
				has_target_distance = 5,
				melee_damage = 0.25,
				num_charges_used_required = 2,
				num_hits = 3,
				radius = 3,
				rending_multiplier = 0.5,
			},
			cooldown_restoration = {
				cooldown_percent_over_time = 0.25,
				cooldown_regen_time = 5,
			},
			consecutive_bonus = {
				chordclaw_damage = 0.2,
				duration = 5,
				max_stacks = 3,
			},
		},
		force_field = {
			cooldown = 45,
			duration = 8,
			increased_duration = 12,
			max_charges = 3,
			max_health_damage_taken_per_hit = 50,
			range = 5,
			force_field_arcs = {
				broadphase_radius = 12,
				max_arcs = 4,
				num_hits_needed_per_arc = 10,
			},
		},
		force_field_extra_charges = {
			charges = 1,
		},
		arc_grenade = {
			base_num_arcs = 4,
			charges = 3,
			extra_arcs = 2,
			radius = 8,
			rending_stacks_on_minions_hit_by_arc = 8,
		},
		monster_hunter = {
			bionic_sense_attack_speed = 0.15,
			bionic_sense_reload_speed = 0.25,
			cooldown_over_time_duration = 5,
			cooldown_over_time_percent_gained = 0.15,
			damage_active_time_out = 2.5,
			damage_inactive = 0.3,
			hit_tracking_time = 3,
			instant_cooldown_percent_gained = 0.05,
			limit_dmg_taken_from_hits = 50,
			toughness_restored_captain_or_monster = 0.5,
			toughness_restored_ogryn_kill = 0.1,
		},
		bionic_senses = {
			damage = 0.2,
			duration = 10,
			stamina_cost_multiplier = 0.75,
		},
		surge = {
			cooldown_per_kill_modifier = 0.075,
			critical_strike_chance = 0.1,
			damage = 0.01,
			duration = 8,
			max_hit_mass_attack_modifier = 0.1,
			max_stacks = 10,
			power_level_modifier = 0.2,
			power_level_modifier_duration = 10,
			rending_multiplier = 0.01,
			stacks_on_combat_ability_used = 10,
			stacks_per_elite_kill = 10,
			stacks_per_kill = 1,
			toughness_regen_per_second = 0.04,
			weakspot_damage = 0.3,
			resist_death = {
				active_duration = 10,
				cooldown_duration = 10,
				rending_multiplier = 0.8,
			},
		},
		power_generation = {
			combat_ability_extra_charges = 1,
			cooldown_per_max_charge_modifier = 0.05,
			power_level_on_ability_activation_duration = 10,
			power_level_on_ability_activation_per_charge = 0.04,
			resist_death = {
				active_duration = 10,
				cooldown_duration = 300,
				power_level_modifier = 0.5,
				toughness_restored_on_proc = 1,
			},
			cryptic_power_generation_one_more_charge = {
				combat_ability_extra_charge_talent = 1,
			},
			cryptic_power_generation_toughness = {
				toughness_replenish_modifier_per_max_charge = 0.075,
			},
		},
		dissector = {
			critical_strike_chance = 0.015,
			damage = 0.025,
			extra_cooldown_on_elite_or_special_kills = 0.05,
			extra_max_stacks = 2,
			max_stacks = 6,
			melee_attack_speed = 0.015,
			stacks_lost_on_damage_taken = 1,
			stacks_lost_on_damage_taken_cooldown = 1,
			stacks_per_elite_or_special_kill = 2,
			toughness_damage_taken_multiplier = 0.025,
			toughness_regen_percent_per_elite_or_special_kill = 0.15,
		},
		overload = {
			allies_buff_duration = 8,
			aoe_damage_taken_multiplier_debuff = 1.15,
			aoe_damage_taken_multiplier_debuff_duration = 8,
			aoe_radius = 8,
			cooldown_percent_restored_per_charge = 0.05,
			damage = 0.15,
			max_stacks = 30,
			num_stacks_gained_per_combat_ability_charge = 5,
			num_stacks_per_elite_or_special_kill = 2,
			num_stacks_per_hit_on_monster_or_captains = 1,
			num_stacks_per_kill = 1,
			permanent_combat_ability_cooldown_regen_modifier = 0.25,
			permanent_damage = 0.15,
			permanent_toughness_damage_taken_multiplier = 0.8,
			stamina_percent_restored = 0.2,
			toughness_damage_taken_multiplier = 0.85,
			toughness_percent_restored = 0.2,
			permanent_buffs_to_give_per_trigger_count = {
				{
					buff_to_give = "cryptic_overload_keystone_permanent_increase_damage",
					num_triggers_needed = 8,
				},
				{
					buff_to_give = "cryptic_overload_keystone_permanent_reduce_toughness_damage_taken",
					num_triggers_needed = 16,
				},
				{
					buff_to_give = "cryptic_overload_keystone_permanent_increase_cooldown_regen",
					num_triggers_needed = 24,
				},
			},
		},
		power_generation_strength = {
			base_power_level_modifier = 0.1,
			duration = 10,
			max_stacks = 5,
			power_level_modifier_per_stack = 0.05,
			cryptic_power_generation_stats_for_charge = {
				damage = 0.1,
				damage_taken_multiplier = 0.8,
				num_reduced_ability_charges = 1,
			},
			cryptic_power_generation_capacitance_for_charge = {
				blitz_charges = 1,
				interval = 90,
				num_reduced_ability_charges = 1,
			},
			cryptic_power_generation_charges_mini_bonus = {
				damage = 0.15,
				damage_bonus_valid_charge_one = 0,
				damage_bonus_valid_charge_three = 4,
				damage_bonus_valid_charge_two = 2,
				num_increased_ability_charges = 1,
				toughness_regen_bonus_valid_charge_one = 1,
				toughness_regen_bonus_valid_charge_three = 5,
				toughness_regen_bonus_valid_charge_two = 3,
				toughness_replenish_modifier = 0.25,
			},
			cryptic_power_generation_capacitance_bonuses = {
				cooldown_regen_modifier_high = -0.15,
				cooldown_regen_modifier_low = 0.15,
				increased_cooldown_regen_target_charges = 2,
				num_increased_ability_charges = 1,
				reduced_cooldown_regen_target_charges = 2,
			},
		},
		redline = {
			ability_extra_charges = 1,
			combat_ability_cooldown_regen_modifier = 0.05,
			duration = 12,
			max_stacks = 4,
			toughness_damage_taken_multiplier_step = 0.05,
			cryptic_redline_strength = {
				duration = 10,
				max_stacks = 5,
				power_level_modifier_per_stack = 0.05,
			},
			cryptic_redline_extra_max_stacks = {
				ability_extra_charges = 1,
				extra_redline_max_stacks = 1,
			},
			cryptic_redline_toughness = {
				duration = 5,
				toughness_restored = 0.25,
			},
			cryptic_redline_rending = {
				num_stacks_needed = 3,
				rending_multiplier = 0.15,
			},
		},
		cryptic_multi_hits_grant_stamina_reduction = {
			duration = 8,
			max_stacks = 3,
			num_hits = 3,
			stamina_cost_multiplier_step = 0.15,
		},
		cryptic_multi_hits_restore_toughness = {
			multi_hit_window = 0.25,
			num_hits = 3,
			toughness_regen = 0.1,
			toughness_regen_time = 3,
		},
		cryptic_weakspot_kills_restore_toughness = {
			toughness_restored = 0.05,
		},
		cryptic_crits_grant_tdr = {
			duration = 3,
			toughness_damage_taken_multiplier = 0.85,
			toughness_restored = 0.075,
		},
		cryptic_pushing_grants_tdr = {
			duration = 8,
			toughness_damage_taken_multiplier = 0.8,
		},
		cryptic_coherency_toughness_increase = {
			toughness_coherency_regen_rate_multiplier = 0.5,
		},
		cryptic_block_grants_attack_speed = {
			melee_attack_speed = 0.15,
			num_attacks = 3,
		},
		cryptic_ammo_reserve = {
			ammo_reserve_capacity = 0.25,
		},
		cryptic_ranged_kills_tdr = {
			duration = 8,
			max_stacks = 5,
			toughness_damage_taken_multiplier_step = 0.04,
		},
		cryptic_elite_kills_damage = {
			damage = 0.05,
			duration = 15,
			max_stacks = 4,
		},
		cryptic_weakspot_damage = {
			weakspot_damage = 0.25,
		},
		cryptic_elite_kills_toughness = {
			toughness_regen = 0.15,
			toughness_regen_time = 3,
		},
		cryptic_electrocution_defense = {
			cooldown_duration = 15,
			electrocution_radius = 2.5,
		},
		cryptic_mobile_defense = {
			damage_taken_multiplier = 0.75,
		},
		cryptic_stacking_tdr = {
			duration = 5,
			max_stacks = 6,
			toughness_damage_taken_multiplier = 0.025,
		},
		cryptic_stun_suppression_immune = {
			duration = 4,
		},
		cryptic_successful_dodge_stamina = {
			stamina_replenished_percent = 0.1,
		},
		cryptic_pushing_grants_cleave = {
			duration = 8,
			max_melee_hit_mass_attack_modifier = 0.5,
		},
		cryptic_cleave_and_impact = {
			impact_modifier = 0.3,
			max_hit_mass_attack_modifier = 0.3,
			stamina_threshold = 0.5,
		},
		cryptic_crits_grant_power = {
			cooldown_regen = 0.05,
			cooldown_regen_time = 4,
		},
		cryptic_weakspot_kills_grant_power = {
			cooldown_replenished_on_proc = 0.02,
		},
		cryptic_pushing_grants_power = {
			cooldown_regen = 0.1,
			cooldown_regen_time = 8,
		},
		cryptic_increased_passive_cooldown_regen = {
			cooldown_percent_regen_per_second = 0.01,
		},
		cryptic_multi_hits_grant_power = {
			cooldown_replenished_on_proc = 0.01,
			multi_hit_window = 0.25,
			num_hits = 3,
		},
		cryptic_ranged_kills_coherency_toughness = {
			duration = 10,
			max_stacks = 5,
			min_toughness_coherency_regen_rate_modifier = 0.075,
		},
		cryptic_coherency_toughness_on_ability = {
			toughness_replenish_percent = 0.2,
		},
		cryptic_hybrid_damage = {
			melee_damage = 0.03,
			melee_duration = 8,
			melee_max_stacks = 5,
			ranged_damage = 0.03,
			ranged_duration = 8,
			ranged_max_stacks = 5,
		},
		cryptic_next_hit_damage_on_dodge = {
			melee_damage = 0.2,
		},
		cryptic_stagger_increase = {
			impact_modifier = 0.3,
			impact_modifier_per_charge = 0.1,
		},
		cryptic_electrocution_toughness = {
			toughness_regen = 0.12,
			toughness_regen_time = 4,
		},
		cryptic_afflicted_increased_damage = {
			damage = 0.1,
			duration = 8,
		},
		cryptic_allies_broken = {
			cooldown_duration_stamina = 20,
			cooldown_duration_toughness = 20,
			stamina_replenish_percent = 0.3,
			toughness_replenish_percent = 0.2,
		},
		cryptic_stacking_melee_damage = {
			damage = 0.03,
			duration = 8,
			max_stacks = 5,
		},
		cryptic_shared_toughness = {
			toughness_replenish_percent = 0.25,
		},
		cryptic_electrocution_applies_brittleness = {
			stacks = 4,
		},
		cryptic_stamina_increases_damage = {
			damage = 0.15,
			duration = 4,
			stamina_consumed_to_proc = 1,
		},
		cryptic_melee_kills_coherency_toughness = {
			duration = 5,
			max_stacks = 5,
			min_toughness_coherency_regen_rate_modifier = 0.075,
		},
		cryptic_dodge_improvements = {
			dodge_linger_time_modifier = 0.25,
			extra_consecutive_dodges = 1,
		},
		cryptic_stacking_ranged_damage = {
			max_stacks = 2,
			ranged_damage_per_stack = 0.1,
			time_between_stacks = 1,
			time_since_last_shot_before_stacking = 1,
		},
		cryptic_passive_ammo_replenishment = {
			interval = 15,
			percent_ammo_replenish_per_tick = 0.01,
		},
		cryptic_better_heavies = {
			melee_heavy_damage = 0.15,
		},
		cryptic_stun_dr_power = {
			damage_taken_multiplier = 0.85,
			percent_cooldown_spent_per_melee_hit_taken = 0.05,
		},
		cryptic_revive_speed_and_dr = {
			damage_taken_multiplier = 0.8,
			revive_speed_modifier = 0.2,
		},
		cryptic_stacking_ranged_dr_on_melee = {
			duration = 5,
			max_stacks = 10,
			ranged_toughness_damage_taken_multiplier_per_stack = 0.05,
		},
		cryptic_move_speed_on_charge = {
			duration = 5,
			movement_speed = 0.15,
			stamina_cost_multiplier = 0.75,
		},
		cryptic_reload_speed_based_on_charge = {
			extra_reload_speed = 0.15,
			low_charges = 0,
			reload_speed = 0.15,
		},
		cryptic_damage_vs_electrocuted_based_on_charge = {
			damage_vs_electrocuted = 0.1,
			extra_damage_vs_electrocuted = 0.15,
			min_num_charges = 2,
		},
		cryptic_arc_increases_damage = {
			damage = 0.15,
			duration = 12,
		},
		cryptic_cycler = {
			blitz_charges = 1,
			damage = 0.2,
			damage_duration = 10,
			low_range_limit = 5,
			max_stacks = 15,
			mid_range_limit = 10,
			stack_interval = 0.4,
			toughness_percent_regen = 0.5,
		},
		cryptic_corruption_resistance_doom = {
			corruption_damage_taken = 1,
			corruption_taken_multiplier = 0.1,
			interval = 20,
		},
		cryptic_ranged_stacking_toughness = {
			duration = 8,
			max_stacks = 5,
			toughness_regen_per_second_per_stack = 0.01,
		},
		cryptic_toughness_on_damage_taken = {
			cooldown = 10,
			toughness_regen = 0.25,
			toughness_regen_time = 5,
		},
		cryptic_ranged_vs_bfg = {
			ranged_damage_vs_captains = 0.25,
			ranged_damage_vs_monsters = 0.25,
			ranged_damage_vs_ogryn = 0.25,
		},
		cryptic_crit_chance_based_on_charge = {
			critical_strike_chance = 0.06,
			extra_critical_strike_chance = 0.04,
			low_charges = 0,
		},
		cryptic_melee_attacks_give_melee_attack_speed = {
			duration = 3,
			max_stacks = 5,
			melee_attack_speed = 0.025,
		},
		cryptic_tdr_based_on_charge = {
			toughness_damage_taken_multiplier_base = 0.1,
			toughness_damage_taken_multiplier_per_charge = 0.025,
		},
		cryptic_toughness_per_charge = {
			increased_toughness_regen_per_charge = 0.005,
			toughness_regen_per_second = 0.03,
		},
		cryptic_no_braced_movement_penalty = {
			alternate_fire_movement_speed_reduction_modifier = 0.5,
			spread_modifier = -0.3,
		},
		cryptic_damage_on_ability = {
			damage = 0.15,
			duration = 10,
		},
		cryptic_dr_on_toughness_break = {
			active_duration = 5,
			cooldown_duration = 15,
			damage_taken_multiplier = 0.7,
		},
		cryptic_push_stagger_stamina = {
			push_impact_modifier = 0.75,
			target_stamina_percent = 0.75,
		},
		cryptic_specials_marking = {
			outline_range = 12.5,
		},
		cryptic_electrocution_push = {
			cooldown_duration = 15,
		},
		cryptic_toughness_replenishment_on_kill_bonus = {
			improved_min_charges = 0,
			improved_toughness_melee_replenish = 0.5,
			toughness_melee_replenish = 0.25,
		},
		cryptic_strength_on_charge_gain = {
			active_duration = 10,
			power_level_modifier = 0.125,
		},
		cryptic_disabled_allies_defense = {
			damage_taken_multiplier = 0.75,
			damage_taken_multiplier_post = 0.75,
			duration = 6,
		},
		cryptic_assisted_allies_defense = {
			damage_taken_multiplier = 0.5,
			duration = 6,
		},
		cryptic_environmental_defense = {
			corruption_taken_multiplier = 0.75,
			environmental_damage_taken_modifier = 0.2,
		},
		cryptic_auto_reload = {
			ammo_replenish_percent = 0.075,
			cooldown_duration = 5,
			reload_speed = 0.15,
		},
		cryptic_damage_vs_electrocuted_scaling_on_charge = {
			base_damage_vs_electrocuted = 0.1,
			damage_per_charge = 0.05,
		},
		cryptic_ally_coherency_defenses = {
			stamina_cooldown_duration = 15,
			stamina_percent_restored = 0.25,
			toughness_cooldown_duration = 15,
			toughness_percent_to_regen = 0.25,
		},
		cryptic_next_hit_all_damage_on_dodge = {
			damage = 0.15,
		},
	},
}

return talent_settings
