local BreedQueries = require("scripts/utilities/breed_queries")
local minion_breeds = BreedQueries.minion_breeds()
local buff_settings = {
	buff_categories = table.enum("generic", "talents", "weapon_traits")
}
buff_settings.buff_categort_order = {
	buff_settings.buff_categories.generic,
	buff_settings.buff_categories.talents,
	buff_settings.buff_categories.weapon_traits
}
buff_settings.keywords = table.enum("allow_backstabbing", "allow_flanking", "allow_hipfire_during_sprint", "armor_penetrating", "beast_of_nurgle_liquid_immunity", "beast_of_nurgle_vomit", "bleeding", "block_gives_warp_charge", "bolstered", "bolter_proficiency", "burning", "can_block_ranged", "cluster_explode_on_super_armored", "coherency_with_all_no_chain", "concealed", "count_as_dodge_vs_all", "count_as_dodge_vs_melee", "count_as_dodge_vs_ranged", "critical_hit_infinite_cleave", "critical_strike_second_projectile", "cultist_flamer_liquid_immunity", "damage_immune", "despawn_on_death", "deterministic_recoil", "electrocuted", "empowered", "fully_charged_attacks_infinite_cleave", "guaranteed_critical_strike", "guaranteed_melee_critical_strike", "guaranteed_ranged_critical_strike", "guaranteed_smite_critical_strike", "health_segment_breaking_reduce_damage_taken", "hit_mass_reduction_on_weakspot_hit", "hud_nameplates_disabled", "ignore_armor_aborts_attack_critical_strike", "ignore_armor_aborts_attack", "improved_ammo_pickups", "improved_medical_crate", "in_toxic_gas", "invisible", "knock_down_on_slide", "melee_alternate_fire_interrupt_immune", "melee_infinite_cleave_critical_strike", "melee_infinite_cleave_on_headshot", "melee_infinite_cleave", "melee_push_immune", "no_ammo_consumption_on_crits", "no_ammo_consumption", "no_coherency_stickiness_limit", "no_parry_block_cost", "ogryn_combat_ability_stance", "ogryn_improved_lunge", "plasma_proficiency", "power_weapon_proficiency", "prevent_toughness_replenish", "psychic_fortress", "psyker_empowered_grenade", "psyker_overcharge", "ranged_alternate_fire_interrupt_immune", "ranged_push_immune", "reduced_ammo_consumption", "renegade_flamer_liquid_immunity", "renegade_grenadier_liquid_immunity", "resist_death", "shock_grenade_shock", "slowdown_immune", "special_ammo", "sprint_dodge_in_overtime", "sticky_projectiles", "stimmed", "stun_immune", "super_armor_override", "suppression_immune", "syringe_ability", "syringe_power", "syringe_speed", "taunted", "uninterruptible", "unperceivable", "use_reduced_hit_mass", "uses_nearby_broadphase", "veteran_combat_ability_stance", "veteran_tag", "warpfire_burning", "weakspot_hit_gains_armor_penetration", "zealot_maniac_empowered_martyrdom", "zealot_toughness", "zero_slide_friction")
buff_settings.network_synced_keywords = {
	[buff_settings.keywords.invisible] = true
}
local group_keywords = table.enum("allow_action_during_sprint")
local group_to_keywords = {
	[group_keywords.allow_action_during_sprint] = {
		[buff_settings.keywords.allow_hipfire_during_sprint] = true
	}
}
buff_settings.group_keywords = group_keywords
buff_settings.group_to_keywords = group_to_keywords
buff_settings.targets = table.enum("player_only", "minion_only", "any")
buff_settings.min_proc_events_size = 20
buff_settings.max_proc_events = 300
buff_settings.proc_events_stride = 2
buff_settings.max_stack_count = 31
buff_settings.proc_event_validation = {
	on_action_start = {
		action_name = "string",
		action_settings = "table"
	},
	on_ammo_consumed = {
		charged_ammo = "bool",
		is_critical_strike = "bool",
		ammo_usage = "number",
		num_shots_fired = "number",
		t = "number"
	},
	on_ammo_pickup = {
		pickup_name = "string",
		pickup_amount = "number",
		new_ammo_amount = "number"
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
		warp_charge_percent = "number",
		unit = "unit"
	},
	on_critical_strike = {
		attack_type = "string",
		attacking_unit = "unit"
	},
	on_damage_taken = {
		attack_type = "string",
		damage_amount = "number",
		attacking_unit_owner_unit = "unit",
		damage_profile_name = "string",
		permanent_damage = "number",
		attacking_unit = "unit",
		attacked_unit = "unit"
	},
	on_dodge_start = {},
	on_dodge_end = {},
	on_explosion_hit = {
		attack_instigator_unit = "unit",
		charge_level = "number",
		item_slot_origin = "string",
		number_of_hit_units = "number",
		attacking_unit = "unit"
	},
	on_lunge_start = {
		lunge_template_name = "string",
		lunging_unit = "unit",
		lunge_direction = "Vector3"
	},
	on_lunge_end = {
		lunge_template_name = "string",
		last_hit_unit = "unit",
		lunging_unit = "unit",
		lunge_direction = "Vector3"
	},
	on_slide_start = {},
	on_slide_end = {},
	on_healing_taken = {
		heal_amount = "number",
		heal_type = "string"
	},
	on_pellet_hits = {
		number_of_pellets_hit = "number",
		max_number_of_pellets = "number",
		damage = "number",
		is_critical_strike = "bool",
		attacked_unit = "unit"
	},
	on_psyker_shout_finish = {
		num_hits = "number"
	},
	on_hit = {
		one_hit_kill = "bool",
		hit_weakspot = "bool",
		charge_level = "number",
		damage_efficiency = "string",
		attack_instigator_unit = "unit",
		melee_attack_strength = "string",
		hit_world_position = "Vector3",
		target_index = "number",
		sticky_attack = "bool",
		stagger_result = "string",
		attack_type = "string",
		damage_type = "string",
		weapon_special = "bool",
		attacking_unit = "unit",
		attacked_unit = "unit",
		is_backstab = "bool",
		damage = "number",
		tags = "table",
		alternative_fire = "bool",
		attack_result = "string",
		breed_name = "string",
		hit_zone_name = "string",
		is_critical_strike = "bool",
		attack_direction = "Vector3"
	},
	on_direct_flamer_hit = {},
	on_kill = {
		one_hit_kill = "bool",
		hit_weakspot = "bool",
		charge_level = "number",
		hit_world_position = "Vector3",
		attack_instigator_unit = "unit",
		attack_result = "string",
		attack_type = "string",
		target_index = "number",
		sticky_attack = "bool",
		stagger_result = "string",
		weapon_special = "bool",
		damage_type = "string",
		damage_efficiency = "string",
		attacking_unit = "unit",
		attacked_unit = "unit",
		is_backstab = "bool",
		damage = "number",
		tags = "table",
		alternative_fire = "bool",
		melee_attack_strength = "string",
		breed_name = "string",
		is_critical_strike = "bool",
		attack_direction = "Vector3"
	},
	on_damage_dealt = {
		one_hit_kill = "bool",
		hit_weakspot = "bool",
		charge_level = "number",
		hit_world_position = "Vector3",
		attack_instigator_unit = "unit",
		attack_result = "string",
		attack_type = "string",
		target_index = "number",
		sticky_attack = "bool",
		stagger_result = "string",
		weapon_special = "bool",
		damage_type = "string",
		damage_efficiency = "string",
		attacking_unit = "unit",
		attacked_unit = "unit",
		is_backstab = "bool",
		damage = "number",
		tags = "table",
		alternative_fire = "bool",
		melee_attack_strength = "string",
		breed_name = "string",
		is_critical_strike = "bool",
		attack_direction = "Vector3"
	},
	on_player_hit_received = {
		sticky_attack = "bool",
		hit_weakspot = "bool",
		damage_efficiency = "string",
		damage_absorbed = "number",
		permanent_damage = "number",
		attack_instigator_unit = "unit",
		attack_type = "string",
		result = "string",
		damage_type = "string",
		attacking_unit = "unit",
		attacked_unit = "unit",
		is_backstab = "bool",
		damage = "number",
		alternative_fire = "bool",
		melee_attack_strength = "string",
		is_critical_strike = "bool",
		attack_direction = "Vector3"
	},
	on_minion_death = {
		side_name = "string",
		dying_unit = "unit",
		position = "Vector3",
		damage_profile_name = "string",
		tags = "table",
		attack_type = "string",
		breed_name = "string",
		damage_type = "string",
		attacking_unit = "unit"
	},
	on_push_hit = {
		stagger_result = "string",
		pushed_unit = "unit",
		pushing_unit = "unit"
	},
	on_push_finish = {
		num_hit_units = "number"
	},
	on_block = {
		block_cost = "number",
		attacking_unit = "unit",
		block_broken = "bool",
		attack_type = "string"
	},
	on_perfect_block = {
		block_broken = "bool",
		attacking_unit = "unit",
		action_name = "string",
		block_cost = "number"
	},
	on_reload = {
		weapon_template = "table",
		shotgun = "bool"
	},
	on_reload_start = {
		weapon_template = "table",
		shotgun = "bool"
	},
	on_shoot = {
		num_hit_units = "number",
		hit_weakspot = "bool",
		hit_all_pellets = "bool",
		hit_all_pellets_on_same = "bool",
		num_shots_fired = "number",
		attacking_unit = "unit",
		combo_count = "number",
		is_critical_strike = "bool"
	},
	on_shoot_projectile = {
		projectile_template_name = "string",
		attacking_unit = "unit",
		combo_count = "number",
		num_shots_fired = "number"
	},
	on_shoot_finish = {},
	on_action_damage_target = {
		attacking_unit = "unit",
		attacked_unit = "unit",
		damage_type = "string"
	},
	on_ranged_dodge = {},
	on_sprint_dodge = {},
	on_stamina_depleted = {
		unit = "unit"
	},
	on_successful_dodge = {
		dodging_unit = "unit",
		attacking_unit = "unit",
		attack_type = "string"
	},
	on_weapon_special = {
		t = "number"
	},
	on_wield = {
		weapon_template = "table"
	},
	on_wield_ranged = {
		weapon_template = "table",
		previously_wielded_slot = "string"
	},
	on_wield_melee = {
		weapon_template = "table",
		previously_wielded_slot = "string"
	},
	on_sweep_start = {
		is_weapon_special_active = "bool",
		combo_count = "number",
		is_auto_completed = "bool",
		is_chain_action = "bool",
		is_heavy = "bool"
	},
	on_sweep_finish = {
		num_hit_units = "number",
		hit_weakspot = "bool",
		combo_count = "number",
		is_heavy = "bool"
	},
	on_windup_start = {
		combo_count = "number"
	},
	on_windup_trigger = {},
	on_side_mission_objective_complete = {
		unit = "unit"
	},
	on_all_grimoires_picked_up = {
		unit = "unit"
	},
	on_tag_unit = {
		unit = "unit",
		tagger_unit = "unit",
		tag_name = "string"
	},
	on_untag_unit = {
		unit = "unit",
		tagger_unit = "unit"
	},
	on_revive = {
		target_unit = "unit",
		unit = "unit"
	},
	on_rescue = {
		target_unit = "unit",
		unit = "unit"
	},
	on_pull_up = {
		target_unit = "unit",
		unit = "unit"
	},
	on_remove_net = {
		target_unit = "unit",
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
	on_chain_lightning_finish = {
		unit = "unit"
	},
	on_chain_lightning_jump = {
		unit = "unit"
	},
	on_psyker_force_field_equip = {},
	on_psyker_force_field_unequip = {},
	on_unit_touch_force_field = {
		force_field_unit = "unit",
		force_field_owner_unit = "unit",
		is_player_unit = "bool",
		passing_unit = "unit"
	},
	on_unit_leave_force_field = {
		force_field_unit = "unit",
		force_field_owner_unit = "unit",
		is_player_unit = "bool",
		passing_unit = "unit"
	},
	on_force_field_death = {
		force_field_unit = "unit"
	},
	on_warp_charge_changed = {
		percentage_change = "number"
	},
	on_toughness_replenished = {
		recovered_amount = "number",
		reason = "string",
		amount = "number"
	}
}
local proc_event_names = table.keys(buff_settings.proc_event_validation)
buff_settings.proc_events = table.enum(unpack(proc_event_names))
buff_settings.stat_buff_types = {
	ranged_weakspot_damage = "additive_multiplier",
	ranged_critical_strike_damage = "additive_multiplier",
	chain_lightning_staff_max_jumps = "value",
	extra_consecutive_dodges = "value",
	consumed_hit_mass_modifier = "multiplicative_multiplier",
	push_cost_multiplier = "multiplicative_multiplier",
	ammo_reserve_capacity = "additive_multiplier",
	block_cost_ranged_modifier = "additive_multiplier",
	melee_weakspot_damage_vs_bleeding = "additive_multiplier",
	extra_max_amount_of_grenades = "value",
	force_weapon_damage = "additive_multiplier",
	smoke_fog_duration_modifier = "additive_multiplier",
	psyker_throwing_knife_speed_modifier = "additive_multiplier",
	dodge_cooldown_reset_modifier = "additive_multiplier",
	damage_vs_unaggroed = "additive_multiplier",
	fov_multiplier = "multiplicative_multiplier",
	critical_strike_chance = "value",
	melee_impact_modifier = "additive_multiplier",
	max_health_multiplier = "multiplicative_multiplier",
	damage_near = "additive_multiplier",
	damage_vs_suppressed = "additive_multiplier",
	extra_grenade_throw_chance = "value",
	sprinting_cost_multiplier = "multiplicative_multiplier",
	opt_in_stagger_duration_multiplier = "multiplicative_multiplier",
	explosion_radius_modifier_shock = "additive_multiplier",
	clip_size_modifier = "additive_multiplier",
	outer_push_angle_modifier = "additive_multiplier",
	charge_up_time = "additive_multiplier",
	elusiveness_modifier = "multiplicative_multiplier",
	damage_vs_ogryn_and_monsters = "additive_multiplier",
	damage_vs_staggered = "additive_multiplier",
	ability_extra_charges = "value",
	force_staff_single_target_damage = "additive_multiplier",
	overheat_amount = "multiplicative_multiplier",
	charge_level_modifier = "additive_multiplier",
	critical_strike_weakspot_damage = "additive_multiplier",
	power_level_modifier = "additive_multiplier",
	critical_strike_rending_multiplier = "additive_multiplier",
	dodge_linger_time_modifier = "additive_multiplier",
	psyker_smite_cost_multiplier = "multiplicative_multiplier",
	toughness_replenish_multiplier = "additive_multiplier",
	chain_lightning_max_radius = "value",
	melee_attack_speed = "additive_multiplier",
	coherency_radius_modifier = "additive_multiplier",
	reload_speed = "additive_multiplier",
	block_angle_modifier = "additive_multiplier",
	permanent_damage_converter = "value",
	ammo_usage = "multiplicative_multiplier",
	push_speed_modifier = "additive_multiplier",
	ranged_critical_strike_chance = "value",
	disgustingly_resilient_damage = "additive_multiplier",
	ranged_damage = "additive_multiplier",
	ranged_attack_speed = "additive_multiplier",
	ranged_finesse_modifier_bonus = "additive_multiplier",
	increased_suppression = "additive_multiplier",
	ranged_impact_modifier = "additive_multiplier",
	psyker_smite_max_hit_mass_attack_modifier = "additive_multiplier",
	ranged_weakspot_damage_vs_staggered = "additive_multiplier",
	recoil_modifier = "additive_multiplier",
	consumed_hit_mass_modifier_on_weakspot_hit = "multiplicative_multiplier",
	movement_speed = "additive_multiplier",
	power_level = "value",
	rending_multiplier = "additive_multiplier",
	toughness_damage = "additive_multiplier",
	resistant_damage = "additive_multiplier",
	consumed_hit_mass_modifier_on_kill = "multiplicative_multiplier",
	shout_impact_modifier = "additive_multiplier",
	explosion_radius_modifier = "additive_multiplier",
	dodge_distance_modifier = "additive_multiplier",
	shout_radius_modifier = "additive_multiplier",
	inner_push_angle_modifier = "additive_multiplier",
	warp_charge_amount = "multiplicative_multiplier",
	smite_same_target_discount = "multiplicative_multiplier",
	chain_lightning_damage = "additive_multiplier",
	stagger_burning_reduction_modifier = "multiplicative_multiplier",
	static_movement_reduction_multiplier = "multiplicative_multiplier",
	block_cost_modifier = "additive_multiplier",
	stagger_weakspot_reduction_modifier = "multiplicative_multiplier",
	melee_heavy_damage = "additive_multiplier",
	melee_critical_strike_chance = "value",
	alternate_fire_movement_speed_reduction_modifier = "multiplicative_multiplier",
	stamina_modifier = "value",
	stagger_count_damage = "additive_multiplier",
	warp_charge_dissipation_multiplier = "multiplicative_multiplier",
	stamina_regeneration_modifier = "additive_multiplier",
	revive_speed_modifier = "additive_multiplier",
	ranged_power_level_modifier = "additive_multiplier",
	stamina_regeneration_multiplier = "multiplicative_multiplier",
	explosion_radius_modifier_frag = "additive_multiplier",
	stagger_duration_multiplier = "multiplicative_multiplier",
	super_armor_damage = "additive_multiplier",
	impact_modifier = "additive_multiplier",
	suppressor_decay_multiplier = "multiplicative_multiplier",
	grenade_ability_cooldown_modifier = "additive_multiplier",
	ranged_damage_taken_multiplier = "multiplicative_multiplier",
	sway_modifier = "multiplicative_multiplier",
	threat_weight_multiplier = "multiplicative_multiplier",
	minion_num_shots_modifier = "multiplicative_multiplier",
	toughness_bonus_flat = "value",
	sprint_movement_speed = "additive_multiplier",
	toughness_coherency_regen_rate_modifier = "value",
	finesse_ability_multiplier = "multiplicative_multiplier",
	toughness_coherency_regen_rate_multiplier = "additive_multiplier",
	overheat_over_time_amount = "multiplicative_multiplier",
	dodge_linger_time_ranged_modifier = "additive_multiplier",
	explosion_impact_modifier = "additive_multiplier",
	flanking_damage = "additive_multiplier",
	rending_vs_staggered_multiplier = "additive_multiplier",
	toughness_damage_taken_modifier = "additive_multiplier",
	toughness = "value",
	ability_cooldown_flat_reduction = "value",
	toughness_damage_taken_multiplier = "multiplicative_multiplier",
	toughness_melee_replenish = "additive_multiplier",
	toughness_regen_delay_modifier = "additive_multiplier",
	melee_weakspot_damage_vs_staggered = "additive_multiplier",
	toughness_regen_rate_multiplier = "multiplicative_multiplier",
	melee_weakspot_damage = "additive_multiplier",
	shout_damage = "additive_multiplier",
	unarmored_damage = "additive_multiplier",
	damage_taken_modifier = "additive_multiplier",
	dodge_linger_time_melee_modifier = "additive_multiplier",
	max_hit_mass_impact_modifier = "additive_multiplier",
	dodge_speed_multiplier = "multiplicative_multiplier",
	smite_damage = "additive_multiplier",
	vent_overheat_speed = "multiplicative_multiplier",
	vent_warp_charge_multiplier = "multiplicative_multiplier",
	vent_warp_charge_speed = "multiplicative_multiplier",
	sprint_dodge_reduce_angle_threshold_rad = "max_value",
	warp_charge_amount_smite = "multiplicative_multiplier",
	warp_charge_immediate_amount = "multiplicative_multiplier",
	psyker_smite_max_hit_mass_impact_modifier = "additive_multiplier",
	melee_damage = "additive_multiplier",
	suppression_dealt = "additive_multiplier",
	stamina_regeneration_delay = "value",
	max_hit_mass_attack_modifier = "additive_multiplier",
	permanent_damage_converter_resistance = "value",
	chain_lightning_max_jumps = "value",
	warp_charge_over_time_amount = "multiplicative_multiplier",
	toughness_extra_regen_rate = "value",
	melee_weakspot_impact_modifier = "additive_multiplier",
	assist_speed_modifier = "additive_multiplier",
	warp_damage = "additive_multiplier",
	warp_damage_taken_multiplier = "multiplicative_multiplier",
	weakspot_damage = "additive_multiplier",
	weakspot_power_level_modifier = "additive_multiplier",
	weapon_action_movespeed_reduction_multiplier = "multiplicative_multiplier",
	weapon_special_max_activations = "value",
	frag_damage = "additive_multiplier",
	vent_warp_charge_decrease_movement_reduction = "multiplicative_multiplier",
	ogryn_damage_taken_multiplier = "multiplicative_multiplier",
	overheat_immediate_amount_critical_strike = "multiplicative_multiplier",
	flanking_rending_multiplier = "additive_multiplier",
	non_warp_damage_taken_multiplier = "multiplicative_multiplier",
	critical_strike_damage = "additive_multiplier",
	melee_fully_charged_damage = "additive_multiplier",
	corruption_taken_multiplier = "multiplicative_multiplier",
	knocked_down_health_modifier = "additive_multiplier",
	block_cost_ranged_multiplier = "multiplicative_multiplier",
	combat_ability_cooldown_modifier = "additive_multiplier",
	max_health_modifier = "additive_multiplier",
	ability_cooldown_modifier = "additive_multiplier",
	melee_power_level_modifier = "additive_multiplier",
	psyker_throwing_knives_damage_multiplier = "additive_multiplier",
	weakspot_damage_taken = "additive_multiplier",
	chain_lightning_max_angle = "value",
	toughness_bonus = "additive_multiplier",
	toughness_regen_delay_multiplier = "multiplicative_multiplier",
	melee_finesse_modifier_bonus = "additive_multiplier",
	revive_duration_multiplier = "multiplicative_multiplier",
	coherency_radius_multiplier = "multiplicative_multiplier",
	backstab_rending_multiplier = "additive_multiplier",
	permanent_damage_ratio = "value",
	medical_crate_healing_modifier = "additive_multiplier",
	overheat_immediate_amount = "multiplicative_multiplier",
	damage_far = "additive_multiplier",
	chain_lightning_jump_time_multiplier = "multiplicative_multiplier",
	health_segment_damage_taken_multiplier = "multiplicative_multiplier",
	warp_charge_block_cost = "multiplicative_multiplier",
	corruption_taken_grimoire_multiplier = "multiplicative_multiplier",
	damage_vs_horde = "additive_multiplier",
	fully_charged_damage = "additive_multiplier",
	damage = "additive_multiplier",
	krak_damage = "additive_multiplier",
	smite_attack_speed = "additive_multiplier",
	minion_accuracy_modifier = "multiplicative_multiplier",
	stamina_cost_multiplier = "multiplicative_multiplier",
	damage_vs_elites = "additive_multiplier",
	melee_critical_strike_damage = "additive_multiplier",
	berserker_damage = "additive_multiplier",
	attack_speed = "additive_multiplier",
	psyker_force_field_movespeed_reduction_multiplier = "multiplicative_multiplier",
	spread_modifier = "additive_multiplier",
	vent_overheat_damage_multiplier = "multiplicative_multiplier",
	healing_recieved_modifier = "additive_multiplier",
	finesse_modifier_bonus = "additive_multiplier",
	block_cost_multiplier = "multiplicative_multiplier",
	armored_damage = "additive_multiplier",
	vent_warp_charge_damage_multiplier = "multiplicative_multiplier",
	damage_vs_ogryn = "additive_multiplier",
	backstab_damage = "additive_multiplier",
	damage_taken_multiplier = "multiplicative_multiplier",
	coherency_stickiness_time_value = "value",
	leech = "value",
	toughness_regen_rate_modifier = "additive_multiplier",
	extra_max_amount_of_wounds = "value",
	damage_vs_electrocuted = "additive_multiplier",
	damage_vs_specials = "additive_multiplier"
}

for name, _ in pairs(minion_breeds) do
	buff_settings.stat_buff_types["damage_vs_" .. name] = "additive_multiplier"
	buff_settings.stat_buff_types["damage_taken_by_" .. name .. "_multiplier"] = "multiplicative_multiplier"
end

local stat_buff_names = table.keys(buff_settings.stat_buff_types)
buff_settings.stat_buffs = table.enum(unpack(stat_buff_names))
buff_settings.stat_buff_base_values = {
	additive_multiplier = 1,
	max_value = 0,
	multiplicative_multiplier = 1,
	value = 0
}
buff_settings.stat_buff_type_base_values = Script.new_map(256)

for name, buff_type in pairs(buff_settings.stat_buff_types) do
	buff_settings.stat_buff_type_base_values[name] = buff_settings.stat_buff_base_values[buff_type]
end

buff_settings.meta_stat_buff_types = {
	mission_reward_gear_instead_of_weapon_modifier = "additive_multiplier",
	mission_reward_rare_loot_modifier = "additive_multiplier",
	mission_reward_credit_modifier = "value",
	mission_reward_drop_chance_modifier = "additive_multiplier",
	mission_reward_xp_modifier = "value",
	mission_reward_weapon_drop_rarity_modifier = "additive_multiplier",
	side_mission_reward_xp_modifier = "value",
	side_mission_reward_credit_modifier = "value"
}
local meta_stat_buff_names = table.keys(buff_settings.meta_stat_buff_types)
buff_settings.meta_stat_buffs = table.enum(unpack(meta_stat_buff_names))
buff_settings.meta_stat_buff_type_base_values = Script.new_map(32)

for name, buff_type in pairs(buff_settings.meta_stat_buff_types) do
	buff_settings.meta_stat_buff_type_base_values[name] = buff_settings.stat_buff_base_values[buff_type]
end

buff_settings.keyword_settings = {
	[buff_settings.keywords.improved_medical_crate] = {
		heal_multiplier = 2,
		permanent_damage_multiplier = 0.5,
		toughness_percentage_per_second = 0.01
	}
}

return buff_settings
