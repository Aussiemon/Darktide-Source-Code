local buff_settings = {
	keywords = table.enum("allow_backstabbing", "allow_flanking", "allow_hipfire_during_sprint", "armor_penetrating", "beast_of_nurgle_liquid_immunity", "beast_of_nurgle_vomit", "bleeding", "block_gives_warp_charge", "burning", "can_block_ranged", "cluster_explode_on_super_armored", "coherency_with_all_no_chain", "count_as_dodge_vs_all", "count_as_dodge_vs_melee", "count_as_dodge_vs_ranged", "critical_hit_second_projectile", "critical_hit_infinite_hit_mass", "cultist_flamer_liquid_immunity", "renegade_flamer_liquid_immunity", "damage_immune", "deterministic_recoil", "electrocuted", "fully_charged_attacks_infinite_cleave", "guaranteed_critical_strike", "guaranteed_melee_critical_strike", "guaranteed_ranged_critical_strike", "guaranteed_smite_critical_strike", "health_segment_breaking_reduce_damage_taken", "ignore_armor_aborts_attack", "improved_ammo_pickups", "improved_medical_crate", "invisible", "knock_down_on_slide", "melee_alternate_fire_interrupt_immune", "melee_infinite_cleave", "melee_push_immune", "no_ammo_consumption", "no_coherency_stickiness_limit", "ogryn_improved_lunge", "psychic_fortress", "ranged_alternate_fire_interrupt_immune", "ranged_counts_as_weakspot", "ranged_push_immune", "reduced_ammo_consumption", "renegade_grenadier_liquid_immunity", "resist_death", "shock_grenade_shock", "slowdown_immune", "special_ammo", "sprint_dodge_in_overtime", "sticky_projectiles", "stun_immune", "suppression_immune", "uninterruptible", "unperceivable", "use_reduced_hit_mass", "veteran_ranger_combat_ability", "warpfire_burning", "weakspot_hit_gains_armor_penetration", "zealot_toughness", "zero_slide_friction")
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
	on_ammo_consumed = {
		charged_ammo = "bool",
		num_shots_fired = "number",
		ammo_usage = "number",
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
		unit = "unit"
	},
	on_critical_strike = {
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
	on_hit = {
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
	on_player_hit_recieved = {
		attack_instigator_unit = "unit",
		hit_weakspot = "bool",
		damage = "number",
		damage_efficiency = "string",
		alternative_fire = "bool",
		permanent_damage = "number",
		attack_type = "string",
		is_backstab = "bool",
		melee_attack_strength = "string",
		result = "string",
		sticky_attack = "bool",
		damage_type = "string",
		is_critical_strike = "bool",
		attacking_unit = "unit",
		attacked_unit = "unit",
		attack_direction = "Vector3"
	},
	on_minion_death = {
		side_name = "string",
		breed_name = "string",
		position = "Vector3",
		damage_profile_name = "string",
		dying_unit = "unit",
		attacking_unit = "unit",
		attack_type = "string"
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
		block_broken = "bool",
		attacking_unit = "unit"
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
		num_shots_fired = "number",
		attacking_unit = "unit",
		combo_count = "number"
	},
	on_shoot_projectile = {
		projectile_template_name = "string",
		attacking_unit = "unit",
		combo_count = "number",
		num_shots_fired = "number"
	},
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
	on_wield_ranged = {
		weapon_template = "table"
	},
	on_wield_melee = {
		weapon_template = "table"
	},
	on_sweep_start = {
		is_weapon_special_active = "bool",
		is_chain_action = "bool",
		combo_count = "number",
		is_heavy = "bool"
	},
	on_sweep_finish = {
		num_hit_units = "number",
		hit_weakspot = "bool",
		combo_count = "number",
		is_heavy = "bool"
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
		tagger_unit = "unit"
	},
	on_untag_unit = {
		unit = "unit",
		tagger_unit = "unit"
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
	on_warp_charge_changed = {
		percentage_change = "number"
	}
}
local proc_event_names = table.keys(buff_settings.proc_event_validation)
buff_settings.proc_events = table.enum(unpack(proc_event_names))
buff_settings.stat_buff_types = {
	ranged_weakspot_damage = "additive_multiplier",
	ranged_critical_strike_damage = "additive_multiplier",
	sprint_movement_speed = "multiplicative_multiplier",
	damage_taken_multiplier = "multiplicative_multiplier",
	consumed_hit_mass_modifier = "multiplicative_multiplier",
	rending_multiplier = "additive_multiplier",
	stagger_duration_multiplier = "multiplicative_multiplier",
	damage_far = "additive_multiplier",
	movement_speed = "multiplicative_multiplier",
	dodge_linger_time_modifier = "additive_multiplier",
	push_speed_modifier = "additive_multiplier",
	toughness_bonus_flat = "value",
	overheat_over_time_amount = "multiplicative_multiplier",
	overheat_immediate_amount = "multiplicative_multiplier",
	outer_push_angle_modifier = "additive_multiplier",
	melee_impact_modifier = "additive_multiplier",
	minion_accuracy_modifier = "multiplicative_multiplier",
	clip_size_modifier = "additive_multiplier",
	max_health_multiplier = "multiplicative_multiplier",
	melee_weakspot_damage_vs_bleeding = "additive_multiplier",
	damage_vs_unaggroed = "additive_multiplier",
	finesse_modifier_bonus = "additive_multiplier",
	stagger_burning_reduction_modifier = "multiplicative_multiplier",
	opt_in_stagger_duration_multiplier = "multiplicative_multiplier",
	charge_level_modifier = "additive_multiplier",
	ranged_weakspot_damage_vs_staggered = "additive_multiplier",
	damage_vs_horde = "additive_multiplier",
	extra_max_amount_of_grenades = "value",
	elusiveness_modifier = "multiplicative_multiplier",
	charge_up_time = "additive_multiplier",
	damage_vs_ogryn_and_monsters = "additive_multiplier",
	ammo_reserve_capacity = "additive_multiplier",
	force_staff_single_target_damage = "additive_multiplier",
	overheat_amount = "multiplicative_multiplier",
	damage_vs_suppressed = "additive_multiplier",
	critical_strike_weakspot_damage = "additive_multiplier",
	power_level_modifier = "additive_multiplier",
	critical_strike_rending_multiplier = "additive_multiplier",
	ranged_damage = "additive_multiplier",
	melee_damage = "additive_multiplier",
	toughness_replenish_multiplier = "additive_multiplier",
	sprinting_cost_multiplier = "multiplicative_multiplier",
	melee_attack_speed = "additive_multiplier",
	coherency_radius_modifier = "additive_multiplier",
	reload_speed = "additive_multiplier",
	damage_vs_ogryn = "additive_multiplier",
	ranged_impact_modifier = "additive_multiplier",
	super_armor_damage = "additive_multiplier",
	sway_modifier = "multiplicative_multiplier",
	permanent_damage_converter = "value",
	toughness_coherency_regen_rate_modifier = "value",
	toughness_damage_taken_modifier = "additive_multiplier",
	ranged_attack_speed = "additive_multiplier",
	toughness_damage_taken_multiplier = "multiplicative_multiplier",
	increased_suppression = "additive_multiplier",
	toughness_melee_replenish = "additive_multiplier",
	toughness_regen_delay_modifier = "additive_multiplier",
	toughness_regen_rate_multiplier = "multiplicative_multiplier",
	block_angle_modifier = "additive_multiplier",
	unarmored_damage = "additive_multiplier",
	vent_overheat_speed = "multiplicative_multiplier",
	power_level = "value",
	vent_warp_charge_multiplier = "multiplicative_multiplier",
	toughness_damage = "additive_multiplier",
	vent_warp_charge_speed = "multiplicative_multiplier",
	sprint_dodge_reduce_angle_threshold_rad = "max_value",
	warp_charge_amount_smite = "multiplicative_multiplier",
	stagger_weakspot_reduction_modifier = "multiplicative_multiplier",
	warp_charge_over_time_amount = "multiplicative_multiplier",
	warp_damage = "additive_multiplier",
	warp_damage_taken_multiplier = "multiplicative_multiplier",
	warp_charge_amount = "multiplicative_multiplier",
	smite_same_target_discount = "multiplicative_multiplier",
	weakspot_damage = "additive_multiplier",
	weapon_action_movespeed_reduction_multiplier = "multiplicative_multiplier",
	static_movement_reduction_multiplier = "multiplicative_multiplier",
	block_cost_modifier = "additive_multiplier",
	weapon_special_max_activations = "value",
	melee_heavy_damage = "additive_multiplier",
	melee_critical_strike_chance = "value",
	alternate_fire_movement_speed_reduction_modifier = "multiplicative_multiplier",
	melee_weakspot_damage_vs_staggered = "additive_multiplier",
	stagger_count_damage = "additive_multiplier",
	warp_charge_dissipation_multiplier = "multiplicative_multiplier",
	revive_speed_modifier = "additive_multiplier",
	ranged_power_level_modifier = "additive_multiplier",
	impact_modifier = "additive_multiplier",
	ranged_damage_taken_multiplier = "multiplicative_multiplier",
	stamina_regeneration_modifier = "additive_multiplier",
	finesse_ability_multiplier = "multiplicative_multiplier",
	disgustingly_resilient_damage = "additive_multiplier",
	dodge_linger_time_ranged_modifier = "additive_multiplier",
	explosion_impact_modifier = "additive_multiplier",
	flanking_damage = "additive_multiplier",
	toughness = "value",
	ability_cooldown_flat_reduction = "value",
	ammo_usage = "multiplicative_multiplier",
	shout_damage = "additive_multiplier",
	damage_vs_stunned = "additive_multiplier",
	block_cost_ranged_modifier = "additive_multiplier",
	dodge_linger_time_melee_modifier = "additive_multiplier",
	max_hit_mass_impact_modifier = "additive_multiplier",
	dodge_speed_multiplier = "multiplicative_multiplier",
	smite_damage = "additive_multiplier",
	warp_charge_immediate_amount = "multiplicative_multiplier",
	resistant_damage = "additive_multiplier",
	recoil_modifier = "additive_multiplier",
	suppression_dealt = "additive_multiplier",
	max_hit_mass_attack_modifier = "additive_multiplier",
	permanent_damage_converter_resistance = "value",
	toughness_extra_regen_rate = "value",
	melee_weakspot_impact_modifier = "additive_multiplier",
	assist_speed_modifier = "additive_multiplier",
	vent_warp_charge_decrease_movement_reduction = "multiplicative_multiplier",
	ogryn_damage_taken_multiplier = "multiplicative_multiplier",
	extra_consecutive_dodges = "value",
	flanking_rending_multiplier = "additive_multiplier",
	non_warp_damage_taken_multiplier = "multiplicative_multiplier",
	critical_strike_damage = "additive_multiplier",
	melee_fully_charged_damage = "additive_multiplier",
	corruption_taken_multiplier = "multiplicative_multiplier",
	critical_strike_chance = "value",
	block_cost_ranged_multiplier = "multiplicative_multiplier",
	max_health_modifier = "additive_multiplier",
	ability_cooldown_modifier = "additive_multiplier",
	melee_power_level_modifier = "additive_multiplier",
	weakspot_damage_taken = "additive_multiplier",
	toughness_bonus = "additive_multiplier",
	toughness_regen_delay_multiplier = "multiplicative_multiplier",
	damage_vs_staggered = "additive_multiplier",
	revive_duration_multiplier = "multiplicative_multiplier",
	coherency_radius_multiplier = "multiplicative_multiplier",
	backstab_rending_multiplier = "additive_multiplier",
	force_weapon_damage = "additive_multiplier",
	medical_crate_healing_modifier = "additive_multiplier",
	melee_weakspot_damage = "additive_multiplier",
	stamina_regeneration_multiplier = "multiplicative_multiplier",
	health_segment_damage_taken_multiplier = "multiplicative_multiplier",
	warp_charge_block_cost = "multiplicative_multiplier",
	ranged_critical_strike_chance = "value",
	fully_charged_damage = "additive_multiplier",
	damage = "additive_multiplier",
	krak_damage = "additive_multiplier",
	smite_attack_speed = "additive_multiplier",
	damage_near = "additive_multiplier",
	threat_weight_multiplier = "multiplicative_multiplier",
	damage_vs_elites = "additive_multiplier",
	melee_critical_strike_damage = "additive_multiplier",
	berserker_damage = "additive_multiplier",
	attack_speed = "additive_multiplier",
	toughness_coherency_regen_rate_multiplier = "additive_multiplier",
	spread_modifier = "additive_multiplier",
	vent_overheat_damage_multiplier = "multiplicative_multiplier",
	healing_recieved_modifier = "additive_multiplier",
	fov_multiplier = "multiplicative_multiplier",
	block_cost_multiplier = "multiplicative_multiplier",
	armored_damage = "additive_multiplier",
	vent_warp_charge_damage_multiplier = "multiplicative_multiplier",
	stamina_modifier = "value",
	backstab_damage = "additive_multiplier",
	inner_push_angle_modifier = "additive_multiplier",
	coherency_stickiness_time_value = "value",
	leech = "value",
	toughness_regen_rate_modifier = "additive_multiplier",
	extra_max_amount_of_wounds = "value",
	shout_impact_modifier = "additive_multiplier",
	damage_vs_specials = "additive_multiplier"
}
local breed_names = {
	"chaos_beast_of_nurgle",
	"chaos_daemonhost",
	"chaos_hound",
	"chaos_newly_infected",
	"chaos_ogryn_bulwark",
	"chaos_ogryn_executor",
	"chaos_ogryn_gunner",
	"chaos_plague_ogryn",
	"chaos_plague_ogryn_sprayer",
	"chaos_poxwalker_bomber",
	"chaos_poxwalker",
	"cultist_assault",
	"cultist_berzerker",
	"cultist_flamer",
	"cultist_grenadier",
	"cultist_gunner",
	"cultist_melee",
	"cultist_mutant",
	"cultist_shocktrooper",
	"renegade_assault",
	"renegade_captain",
	"renegade_executor",
	"renegade_grenadier",
	"renegade_gunner",
	"renegade_melee",
	"renegade_netgunner",
	"renegade_rifleman",
	"renegade_shocktrooper",
	"renegade_sniper",
	"renegade_flamer",
	"renegade_berzerker"
}

for i = 1, #breed_names do
	buff_settings.stat_buff_types["damage_vs_" .. breed_names[i]] = "additive_multiplier"
end

for i = 1, #breed_names do
	buff_settings.stat_buff_types["damage_taken_by_" .. breed_names[i] .. "_multiplier"] = "multiplicative_multiplier"
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

return buff_settings
