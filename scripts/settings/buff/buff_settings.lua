local buff_settings = {
	keywords = table.enum("armor_penetrating", "bleeding", "burning", "coherency_with_all_no_chain", "cultist_flamer_liquid_immunity", "damage_immune", "deterministic_recoil", "electrocuted", "fully_charged_attacks_infinite_cleave", "guaranteed_melee_critical_strike", "guaranteed_ranged_critical_strike", "guaranteed_smite_critical_strike", "improved_ammo_pickups", "improved_medical_crate", "invisible", "knock_down_on_slide", "melee_alternate_fire_interrupt_immune", "melee_backstab_enabled", "melee_push_immune", "no_ammo_consumption", "no_coherency_stickiness_limit", "ogryn_improved_lunge", "override_dodging", "psychic_fortress", "psyker_force_field_ranged_damage", "psyker_protectorate_shield_proximity_buffs", "ranged_alternate_fire_interrupt_immune", "ranged_backstab_enabled", "ranged_counts_as_weakspot", "ranged_push_immune", "renegade_grenadier_liquid_immunity", "resist_death", "slowdown_immune", "sprint_dodge_in_overtime", "stun_immune", "suppression_immune", "uninterruptible", "veteran_ranger_combat_ability", "weakspot_hit_gains_armor_penetration"),
	targets = table.enum("player_only", "minion_only", "any"),
	max_proc_events = 200,
	max_stack_count = 31,
	proc_event_validation = {
		on_ammo_consumed = {
			charged_ammo = "bool",
			ammo_usage = "number",
			t = "number"
		},
		on_coherency_enter = {
			enter_unit = "unit",
			number_of_unit_in_coherency = "unit"
		},
		on_coherency_exit = {
			number_of_unit_in_coherency = "unit",
			exit_unit = "unit"
		},
		on_combat_ability = {
			unit = "unit"
		},
		on_critical_strike = {
			attacking_unit = "unit"
		},
		on_damage_taken = {
			attack_type = "string",
			attacking_unit = "unit",
			damage_amount = "number"
		},
		on_dodge_end = {},
		on_explosion_hit = {
			number_of_hit_units = "number",
			attacking_unit = "unit",
			attack_instigator_unit = "unit",
			item_slot_origin = "string"
		},
		on_start_lunge = {
			lunge_template_name = "string",
			lunging_unit = "unit",
			lunge_direction = "Vector3"
		},
		on_finished_lunge = {
			lunge_template_name = "string",
			last_hit_unit = "unit",
			lunging_unit = "unit",
			lunge_direction = "Vector3"
		},
		on_healing_taken = {
			heal_amount = "number",
			heal_type = "string"
		},
		on_hit = {
			is_backstab = "bool",
			hit_weakspot = "bool",
			damage = "number",
			attack_instigator_unit = "unit",
			alternative_fire = "bool",
			result = "string",
			attack_type = "string",
			sticky_attack = "bool",
			melee_attack_strength = "string",
			damage_efficiency = "string",
			damage_type = "string",
			is_critical_strike = "bool",
			attacking_unit = "unit",
			attacked_unit = "unit",
			attack_direction = "Vector3"
		},
		on_minion_death = {
			breed_name = "string",
			dying_unit = "unit",
			damage_profile_name = "string",
			attacking_unit = "unit",
			attack_type = "string"
		},
		on_push = {
			pushed_unit = "unit",
			pushing_unit = "unit"
		},
		on_block = {
			block_broken = "bool",
			attacking_unit = "unit"
		},
		on_reload = {
			weapon_template = "table",
			shotgun = "bool"
		},
		on_shoot = {
			attacking_unit = "unit"
		},
		on_shoot_projectile = {
			projectile_template_name = "string",
			attacking_unit = "unit"
		},
		on_action_damage_target = {
			attacking_unit = "unit",
			attacked_unit = "unit",
			damage_type = "string"
		},
		on_stamina_depleted = {
			unit = "unit"
		},
		on_successful_dodge = {
			attacking_unit = "unit",
			dodging_unit = "unit",
			attack_type = "string"
		},
		on_suppress = {
			suppressed_unit = "unit"
		},
		on_weapon_special = {
			t = "number"
		},
		on_wield_ranged = {
			weapon_template = "table"
		},
		on_wield_melee = {
			weapon_template = "table"
		},
		on_sweep = {
			num_hit_units = "number"
		},
		on_mission_objective_complete = {
			unit = "unit"
		},
		on_all_grimoires_picked_up = {
			unit = "unit"
		},
		on_tag_unit = {
			unit = "unit"
		},
		on_untag_unit = {
			unit = "unit"
		},
		on_revive = {
			revived_unit = "unit",
			unit = "unit"
		},
		on_ally_knocked_down = {
			downed_unit = "unit"
		},
		on_player_toughness_broken = {
			unit = "unit"
		},
		on_alternative_fire_start = {
			unit = "unit"
		},
		on_chain_lightning_start = {
			unit = "unit"
		},
		on_chain_lightning_finished = {
			unit = "unit"
		},
		on_psyker_force_field_equip = {},
		on_psyker_force_field_unequip = {},
		on_unit_enter_force_field = {
			force_field_unit = "unit",
			passing_unit = "unit",
			force_field_owner_unit = "unit",
			is_player_unit = "bool"
		},
		on_unit_leave_force_field = {
			force_field_unit = "unit",
			passing_unit = "unit",
			force_field_owner_unit = "unit",
			is_player_unit = "bool"
		}
	}
}
local proc_event_names = table.keys(buff_settings.proc_event_validation)
buff_settings.proc_events = table.enum(unpack(proc_event_names))
buff_settings.stat_buff_types = {
	ranged_weakspot_damage = "additive_multiplier",
	ranged_critical_strike_damage = "additive_multiplier",
	toughness_damage_taken_multiplier = "multiplicative_multiplier",
	chain_lightning_cost_multiplier = "multiplicative_multiplier",
	super_armor_damage = "additive_multiplier",
	chain_lightning_max_radius = "value",
	push_speed_modifier = "additive_multiplier",
	melee_weakspot_damage = "additive_multiplier",
	stamina_modifier = "value",
	toughness_damage_taken_modifier = "additive_multiplier",
	stagger_duration_multiplier = "multiplicative_multiplier",
	sprint_movement_speed = "multiplicative_multiplier",
	inner_push_angle_modifier = "additive_multiplier",
	ranged_damage = "additive_multiplier",
	damage_vs_elites = "additive_multiplier",
	ranged_critical_strike_chance = "value",
	coherency_radius_modifier = "additive_multiplier",
	backstab_melee_damage = "additive_multiplier",
	max_health_multiplier = "multiplicative_multiplier",
	permanent_damage_converter = "value",
	overheat_over_time_amount = "multiplicative_multiplier",
	overheat_immediate_amount = "multiplicative_multiplier",
	sprinting_cost_multiplier = "multiplicative_multiplier",
	opt_in_stagger_duration_multiplier = "multiplicative_multiplier",
	ogryn_damage_taken_multiplier = "multiplicative_multiplier",
	clip_size_modifier = "additive_multiplier",
	dodge_linger_time_modifier = "additive_multiplier",
	minion_accuracy_modifier = "multiplicative_multiplier",
	elusiveness_modifier = "multiplicative_multiplier",
	charge_up_time = "additive_multiplier",
	melee_impact_modifier = "additive_multiplier",
	fov_multiplier = "multiplicative_multiplier",
	force_staff_single_target_damage = "additive_multiplier",
	overheat_amount = "multiplicative_multiplier",
	extra_max_amount_of_grenades = "value",
	ammo_reserve_capacity = "additive_multiplier",
	power_level_modifier = "additive_multiplier",
	sway_modifier = "multiplicative_multiplier",
	damage_far = "additive_multiplier",
	melee_damage = "additive_multiplier",
	toughness_replenish_multiplier = "multiplicative_multiplier",
	block_angle_modifier = "additive_multiplier",
	melee_attack_speed = "additive_multiplier",
	toughness_coherency_regen_rate_modifier = "value",
	reload_speed = "additive_multiplier",
	dodge_linger_time_ranged_modifier = "additive_multiplier",
	ranged_impact_modifier = "additive_multiplier",
	block_cost_multiplier = "multiplicative_multiplier",
	vent_warp_charge_multiplier = "multiplicative_multiplier",
	vent_warp_charge_speed = "multiplicative_multiplier",
	warp_charge_over_time_amount = "multiplicative_multiplier",
	warp_damage = "additive_multiplier",
	ranged_attack_speed = "additive_multiplier",
	backstab_ranged_damage = "additive_multiplier",
	increased_suppression = "additive_multiplier",
	weakspot_damage = "additive_multiplier",
	weapon_special_max_activations = "value",
	outer_push_angle_modifier = "additive_multiplier",
	power_level = "value",
	toughness_damage = "additive_multiplier",
	warp_charge_amount = "multiplicative_multiplier",
	smite_same_target_discount = "multiplicative_multiplier",
	block_cost_modifier = "additive_multiplier",
	melee_heavy_damage = "additive_multiplier",
	melee_critical_strike_chance = "value",
	alternate_fire_movement_speed_reduction_modifier = "multiplicative_multiplier",
	warp_charge_dissipation_multiplier = "multiplicative_multiplier",
	revive_speed_modifier = "additive_multiplier",
	impact_modifier = "additive_multiplier",
	ranged_damage_taken_multiplier = "multiplicative_multiplier",
	stamina_regeneration_modifier = "additive_multiplier",
	finesse_ability_multiplier = "multiplicative_multiplier",
	disgustingly_resilient_damage = "additive_multiplier",
	unarmored_damage = "additive_multiplier",
	explosion_impact_modifier = "additive_multiplier",
	toughness = "value",
	ability_cooldown_flat_reduction = "value",
	shout_damage = "additive_multiplier",
	dodge_linger_time_melee_modifier = "additive_multiplier",
	movement_speed = "multiplicative_multiplier",
	dodge_speed_multiplier = "multiplicative_multiplier",
	smite_damage = "additive_multiplier",
	warp_charge_immediate_amount = "multiplicative_multiplier",
	resistant_damage = "additive_multiplier",
	recoil_modifier = "additive_multiplier",
	suppression_dealt = "additive_multiplier",
	weapon_action_movespeed_reduction_multiplier = "multiplicative_multiplier",
	permanent_damage_converter_resistance = "value",
	chain_lightning_max_jumps = "value",
	toughness_melee_replenish = "additive_multiplier",
	melee_weakspot_impact_modifier = "additive_multiplier",
	assist_speed_modifier = "additive_multiplier",
	vent_warp_charge_decrease_movement_reduction = "multiplicative_multiplier",
	chain_lightning_damage = "additive_multiplier",
	extra_consecutive_dodges = "value",
	damage_vs_suppressed = "additive_multiplier",
	critical_strike_damage = "additive_multiplier",
	melee_fully_charged_damage = "additive_multiplier",
	corruption_taken_multiplier = "multiplicative_multiplier",
	critical_strike_chance = "value",
	melee_weakspot_damage_vs_staggered_ = "additive_multiplier",
	max_health_modifier = "additive_multiplier",
	ability_cooldown_modifier = "additive_multiplier",
	weakspot_damage_taken = "additive_multiplier",
	chain_lightning_max_angle = "value",
	toughness_regen_delay_multiplier = "multiplicative_multiplier",
	revive_duration_multiplier = "multiplicative_multiplier",
	coherency_radius_multiplier = "multiplicative_multiplier",
	damage_vs_unaggroed = "additive_multiplier",
	medical_crate_healing_modifier = "additive_multiplier",
	toughness_regen_delay_modifier = "additive_multiplier",
	stamina_regeneration_multiplier = "multiplicative_multiplier",
	warp_charge_amount_smite = "multiplicative_multiplier",
	damage_vs_horde = "additive_multiplier",
	fully_charged_damage = "additive_multiplier",
	damage = "additive_multiplier",
	krak_damage = "additive_multiplier",
	smite_attack_speed = "additive_multiplier",
	damage_near = "additive_multiplier",
	threat_weight_multiplier = "multiplicative_multiplier",
	vent_overheat_speed = "multiplicative_multiplier",
	melee_critical_strike_damage = "additive_multiplier",
	berserker_damage = "additive_multiplier",
	attack_speed = "additive_multiplier",
	psyker_force_field_movespeed_reduction_multiplier = "multiplicative_multiplier",
	spread_modifier = "additive_multiplier",
	vent_overheat_damage_multiplier = "multiplicative_multiplier",
	healing_recieved_modifier = "additive_multiplier",
	finesse_modifier_bonus = "additive_multiplier",
	ranged_weakspot_damage_vs_staggered_ = "additive_multiplier",
	toughness_regen_rate_multiplier = "multiplicative_multiplier",
	armored_damage = "additive_multiplier",
	vent_warp_charge_damage_multiplier = "multiplicative_multiplier",
	damage_vs_ogryn = "additive_multiplier",
	damage_taken_multiplier = "multiplicative_multiplier",
	coherency_stickiness_time_value = "value",
	leech = "value",
	toughness_regen_rate_modifier = "additive_multiplier",
	extra_max_amount_of_wounds = "value",
	shout_impact_modifier = "additive_multiplier",
	damage_vs_staggered_ = "additive_multiplier",
	damage_vs_specials = "additive_multiplier"
}
local stat_buff_names = table.keys(buff_settings.stat_buff_types)
buff_settings.stat_buffs = table.enum(unpack(stat_buff_names))
buff_settings.stat_buff_base_values = {
	additive_multiplier = 1,
	value = 0,
	multiplicative_multiplier = 1
}
buff_settings.meta_stat_buff_types = {
	mission_reward_xp_modifier = "additive_multiplier",
	mission_reward_rare_loot_modifier = "additive_multiplier",
	mission_reward_credit_modifier = "additive_multiplier",
	mission_reward_drop_chance_modifier = "additive_multiplier",
	mission_reward_gear_instead_of_weapon_modifier = "additive_multiplier",
	mission_reward_weapon_drop_rarity_modifier = "additive_multiplier",
	side_mission_reward_xp_modifier = "additive_multiplier",
	side_mission_reward_credit_modifier = "additive_multiplier"
}
local meta_stat_buff_names = table.keys(buff_settings.meta_stat_buff_types)
buff_settings.meta_stat_buffs = table.enum(unpack(meta_stat_buff_names))

return buff_settings
