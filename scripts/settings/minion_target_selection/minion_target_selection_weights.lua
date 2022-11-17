local minion_target_selection_weights = {
	chaos_beast_of_nurgle = {
		occupied_slots = -1,
		stickiness_duration = 20,
		disabled = -200,
		max_distance = 50,
		stickiness_bonus = 50,
		inverted_permanent_damage_taken = 20,
		threat_multiplier = 1.25,
		distance_to_target = 50
	},
	chaos_daemonhost = {
		occupied_slots = -1,
		max_distance = 500,
		disabled = -5,
		threat_multiplier = 3,
		distance_to_target = 2,
		stickiness_bonus = math.huge,
		stickiness_duration = math.huge
	},
	chaos_hound = {
		occupied_slots = -1,
		disabled = -5,
		inverse_coherency_weight = 5,
		max_distance = 50,
		threat_multiplier = 1.5,
		distance_to_target = 3
	},
	chaos_newly_infected = {
		occupied_slots = -2,
		disabled = -1,
		distance_to_target = 2,
		disabling_type = {
			netted = 1
		}
	},
	chaos_ogryn_bulwark = {
		near_distance = 6,
		stickiness_duration = 8,
		disabled = -2,
		max_distance = 40,
		threat_multiplier = 0.75,
		distance_to_target = 3,
		occupied_slots = -2,
		stickiness_bonus = 12,
		near_distance_bonus = 5
	},
	chaos_ogryn_executor = {
		near_distance = 6,
		stickiness_duration = 8,
		disabled = -2,
		occupied_slots = -2,
		stickiness_bonus = 12,
		near_distance_bonus = 5,
		threat_multiplier = 0.75,
		distance_to_target = 3
	},
	cultist_berzerker = {
		disabled = -2,
		stickiness_duration = 8,
		occupied_slots = -2,
		stickiness_bonus = 12,
		distance_to_target = 3
	},
	renegade_executor = {
		disabled = -2,
		stickiness_duration = 8,
		occupied_slots = -1,
		stickiness_bonus = 12,
		distance_to_target = 3
	},
	chaos_ogryn_gunner = {
		near_distance = 10,
		line_of_sight_weight = 15,
		disabled = -5,
		max_distance = 50,
		attack_not_allowed = -5,
		near_distance_bonus = 30,
		occupied_slots = -2,
		distance_to_target = 22
	},
	chaos_plague_ogryn = {
		occupied_slots = -2,
		stickiness_duration = 10,
		disabled = -80,
		max_distance = 20,
		stickiness_bonus = 100,
		ledge_hanging_weight = -20,
		threat_multiplier = 1.75,
		distance_to_target = 40
	},
	chaos_poxwalker_bomber = {
		distance_to_target = 2,
		occupied_slots = -0.1,
		disabled = -10,
		max_distance = 50
	},
	chaos_poxwalker = {
		occupied_slots = -2,
		disabled = -1,
		distance_to_target = 2,
		disabling_type = {
			netted = 1
		}
	},
	cultist_assault = {
		near_distance = 10,
		line_of_sight_weight = 8,
		disabled = -5,
		max_distance = 50,
		attack_not_allowed = -5,
		near_distance_bonus = 30,
		occupied_slots = -2,
		distance_to_target = 22
	},
	cultist_flamer = {
		near_distance = 10,
		disabled = -8,
		attack_not_allowed = -5,
		max_distance = 50,
		near_distance_bonus = 30,
		distance_to_target = 22
	},
	renegade_flamer = {
		near_distance = 10,
		disabled = -8,
		attack_not_allowed = -5,
		max_distance = 50,
		near_distance_bonus = 30,
		distance_to_target = 22
	},
	cultist_grenadier = {
		distance_to_target = 2,
		occupied_slots = -0.1,
		disabled = -8,
		max_distance = 50
	},
	cultist_gunner = {
		near_distance = 10,
		line_of_sight_weight = 8,
		occupied_slots = -1,
		attack_not_allowed = -2,
		disabled = -8,
		distance_to_target = 22,
		max_distance = 50,
		near_distance_bonus = 30,
		combat_vector_main_aggro_weight = 1
	},
	cultist_melee = {
		occupied_slots = -2,
		disabled = -2,
		distance_to_target = 2,
		disabling_type = {
			netted = 2
		}
	},
	cultist_mutant = {
		disabled = -5,
		line_of_sight_weight = 8,
		occupied_slots = -1,
		max_distance = 50,
		distance_to_target = 2
	},
	cultist_shocktrooper = {
		near_distance = 10,
		line_of_sight_weight = 8,
		attack_not_allowed = -5,
		max_distance = 50,
		disabled = -8,
		near_distance_bonus = 30,
		distance_to_target = 22
	},
	renegade_assault = {
		near_distance = 10,
		line_of_sight_weight = 8,
		disabled = -5,
		max_distance = 50,
		attack_not_allowed = -5,
		near_distance_bonus = 30,
		occupied_slots = -1,
		distance_to_target = 22
	},
	renegade_captain = {
		occupied_slots = -1,
		stickiness_duration = 10,
		max_distance = 20,
		stickiness_bonus = 100,
		threat_multiplier = 1.5,
		distance_to_target = 50
	},
	renegade_grenadier = {
		disabled = -8,
		distance_to_target = 2,
		occupied_slots = -0.1,
		max_distance = 50
	},
	renegade_gunner = {
		near_distance = 10,
		line_of_sight_weight = 8,
		disabled = -8,
		max_distance = 50,
		attack_not_allowed = -2,
		near_distance_bonus = 30,
		occupied_slots = -1,
		distance_to_target = 22
	},
	renegade_melee = {
		occupied_slots = -2,
		disabled = -2,
		distance_to_target = 2,
		disabling_type = {
			netted = 2
		}
	},
	renegade_netgunner = {
		occupied_slots = 1,
		disabled = -5,
		max_distance = 50,
		distance_to_target = 5,
		archetypes = {
			veteran = 1,
			psyker = 1,
			zealot = 1,
			ogryn = 1
		}
	},
	renegade_rifleman = {
		near_distance = 10,
		line_of_sight_weight = 8,
		disabled = -8,
		max_distance = 50,
		attack_not_allowed = -2,
		knocked_down_weight = -2,
		distance_to_target = 22,
		occupied_slots = -1,
		near_distance_bonus = 30
	},
	renegade_shocktrooper = {
		near_distance = 10,
		occupied_slots = -1,
		disabled = -8,
		max_distance = 50,
		attack_not_allowed = -5,
		near_distance_bonus = 30,
		distance_to_target = 22
	},
	renegade_sniper = {
		near_distance = 10,
		line_of_sight_weight = 40,
		occupied_slots = -1,
		attack_not_allowed = -2,
		disabled = -8,
		knocked_down_weight = -30,
		distance_to_target = 22,
		max_distance = 50,
		near_distance_bonus = 30,
		combat_vector_main_aggro_weight = 0
	}
}

return settings("MinionTargetSelectionWeights", minion_target_selection_weights)
