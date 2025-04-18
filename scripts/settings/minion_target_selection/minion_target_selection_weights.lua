-- chunkname: @scripts/settings/minion_target_selection/minion_target_selection_weights.lua

local minion_target_selection_weights = {}

minion_target_selection_weights.chaos_beast_of_nurgle = {
	disabled = -200,
	distance_to_target = 50,
	inverted_permanent_damage_taken = 20,
	max_distance = 50,
	occupied_slots = -1,
	stickiness_bonus = 50,
	stickiness_duration = 20,
	taunt_weight_multiplier = 2,
	threat_multiplier = 1.25,
}
minion_target_selection_weights.chaos_daemonhost = {
	disabled = -5,
	distance_to_target = 2,
	max_distance = 500,
	occupied_slots = -1,
	taunt_weight_multiplier = 2,
	threat_multiplier = 3,
	stickiness_bonus = math.huge,
	stickiness_duration = math.huge,
}
minion_target_selection_weights.chaos_hound = {
	disabled = -5,
	distance_to_target = 3,
	inverse_coherency_weight = 5,
	max_distance = 50,
	occupied_slots = -1,
	threat_multiplier = 1.5,
}
minion_target_selection_weights.chaos_newly_infected = {
	disabled = -1,
	distance_to_target = 2,
	occupied_slots = -2,
	disabling_type = {
		netted = 1,
	},
}
minion_target_selection_weights.chaos_ogryn_bulwark = {
	disabled = -2,
	distance_to_target = 3,
	max_distance = 40,
	near_distance = 6,
	near_distance_bonus = 5,
	occupied_slots = -2,
	stickiness_bonus = 12,
	stickiness_duration = 8,
	threat_multiplier = 0.75,
}
minion_target_selection_weights.chaos_ogryn_executor = {
	disabled = -2,
	distance_to_target = 3,
	near_distance = 6,
	near_distance_bonus = 5,
	occupied_slots = -2,
	stickiness_bonus = 12,
	stickiness_duration = 8,
	threat_multiplier = 0.75,
}
minion_target_selection_weights.cultist_berzerker = {
	disabled = -2,
	distance_to_target = 3,
	occupied_slots = -2,
	stickiness_bonus = 12,
	stickiness_duration = 8,
}
minion_target_selection_weights.renegade_executor = {
	disabled = -2,
	distance_to_target = 3,
	occupied_slots = -1,
	stickiness_bonus = 12,
	stickiness_duration = 8,
}
minion_target_selection_weights.chaos_ogryn_gunner = {
	attack_not_allowed = -5,
	disabled = -5,
	distance_to_target = 22,
	line_of_sight_weight = 15,
	max_distance = 50,
	near_distance = 10,
	near_distance_bonus = 30,
	occupied_slots = -2,
}
minion_target_selection_weights.chaos_plague_ogryn = {
	disabled = -80,
	distance_to_target = 40,
	ledge_hanging_weight = -20,
	max_distance = 20,
	occupied_slots = -2,
	stickiness_bonus = 100,
	stickiness_duration = 10,
	taunt_weight_multiplier = 2,
	threat_multiplier = 1.75,
}
minion_target_selection_weights.chaos_spawn = {
	disabled = -5000,
	distance_to_target = 20,
	knocked_down_weight = -5000,
	ledge_hanging_weight = -20,
	max_distance = 20,
	occupied_slots = -2,
	stickiness_bonus = 5000,
	stickiness_duration = 8,
	taunt_weight_multiplier = 2,
	threat_multiplier = 5,
}
minion_target_selection_weights.chaos_poxwalker_bomber = {
	disabled = -10,
	distance_to_target = 2,
	max_distance = 50,
	near_distance = 5,
	near_distance_bonus = 30,
	occupied_slots = -0.1,
}
minion_target_selection_weights.chaos_poxwalker = {
	disabled = -1,
	distance_to_target = 2,
	occupied_slots = -2,
	disabling_type = {
		netted = 1,
	},
}
minion_target_selection_weights.cultist_assault = {
	attack_not_allowed = -5,
	disabled = -5,
	distance_to_target = 22,
	line_of_sight_weight = 8,
	max_distance = 50,
	near_distance = 10,
	near_distance_bonus = 30,
	occupied_slots = -2,
}
minion_target_selection_weights.cultist_flamer = {
	attack_not_allowed = -5,
	disabled = -8,
	distance_to_target = 22,
	max_distance = 50,
	near_distance = 10,
	near_distance_bonus = 30,
}
minion_target_selection_weights.renegade_flamer = {
	attack_not_allowed = -5,
	disabled = -8,
	distance_to_target = 22,
	max_distance = 50,
	near_distance = 10,
	near_distance_bonus = 30,
}
minion_target_selection_weights.cultist_grenadier = {
	disabled = -8,
	distance_to_target = 2,
	max_distance = 50,
	occupied_slots = -0.1,
}
minion_target_selection_weights.cultist_gunner = {
	attack_not_allowed = -2,
	combat_vector_main_aggro_weight = 1,
	disabled = -8,
	distance_to_target = 22,
	line_of_sight_weight = 8,
	max_distance = 50,
	near_distance = 10,
	near_distance_bonus = 30,
	occupied_slots = -1,
}
minion_target_selection_weights.cultist_melee = {
	disabled = -2,
	distance_to_target = 2,
	occupied_slots = -2,
	disabling_type = {
		netted = 2,
	},
}
minion_target_selection_weights.cultist_mutant = {
	disabled = -5,
	distance_to_target = 2,
	line_of_sight_weight = 8,
	max_distance = 50,
	occupied_slots = -1,
	stickiness_bonus = 20,
	stickiness_duration = 10,
}
minion_target_selection_weights.cultist_shocktrooper = {
	attack_not_allowed = -5,
	disabled = -8,
	distance_to_target = 22,
	line_of_sight_weight = 8,
	max_distance = 50,
	near_distance = 10,
	near_distance_bonus = 30,
}
minion_target_selection_weights.renegade_assault = {
	attack_not_allowed = -5,
	disabled = -5,
	distance_to_target = 22,
	line_of_sight_weight = 8,
	max_distance = 50,
	near_distance = 10,
	near_distance_bonus = 30,
	occupied_slots = -1,
}
minion_target_selection_weights.renegade_captain = {
	distance_to_target = 50,
	max_distance = 20,
	occupied_slots = -1,
	stickiness_bonus = 100,
	stickiness_duration = 10,
	taunt_weight_multiplier = 2,
	threat_multiplier = 1.5,
}
minion_target_selection_weights.renegade_grenadier = {
	disabled = -8,
	distance_to_target = 2,
	max_distance = 50,
	occupied_slots = -0.1,
}
minion_target_selection_weights.renegade_gunner = {
	attack_not_allowed = -2,
	disabled = -8,
	distance_to_target = 22,
	line_of_sight_weight = 8,
	max_distance = 50,
	near_distance = 10,
	near_distance_bonus = 30,
	occupied_slots = -1,
}
minion_target_selection_weights.renegade_radio_operator = {
	attack_not_allowed = -2,
	disabled = -8,
	distance_to_target = 22,
	line_of_sight_weight = 8,
	max_distance = 50,
	near_distance = 10,
	near_distance_bonus = 30,
	occupied_slots = -1,
}
minion_target_selection_weights.renegade_melee = {
	disabled = -2,
	distance_to_target = 2,
	occupied_slots = -2,
	disabling_type = {
		netted = 2,
	},
}
minion_target_selection_weights.renegade_netgunner = {
	disabled = -5,
	distance_to_target = 5,
	max_distance = 50,
	occupied_slots = 1,
	archetypes = {
		ogryn = 1,
		psyker = 1,
		veteran = 1,
		zealot = 1,
	},
}
minion_target_selection_weights.renegade_rifleman = {
	attack_not_allowed = -2,
	disabled = -8,
	distance_to_target = 22,
	knocked_down_weight = -2,
	line_of_sight_weight = 8,
	max_distance = 50,
	near_distance = 10,
	near_distance_bonus = 30,
	occupied_slots = -1,
}
minion_target_selection_weights.renegade_shocktrooper = {
	attack_not_allowed = -5,
	disabled = -8,
	distance_to_target = 22,
	max_distance = 50,
	near_distance = 10,
	near_distance_bonus = 30,
	occupied_slots = -1,
}
minion_target_selection_weights.renegade_sniper = {
	attack_not_allowed = -2,
	combat_vector_main_aggro_weight = 0,
	disabled = -8,
	distance_to_target = 22,
	knocked_down_weight = -30,
	line_of_sight_weight = 40,
	max_distance = 50,
	near_distance = 10,
	near_distance_bonus = 30,
	occupied_slots = -1,
}
minion_target_selection_weights.renegade_twin_captain = {
	distance_to_target = 50,
	max_distance = 20,
	occupied_slots = -1,
	stickiness_bonus = 10,
	stickiness_duration = 8,
	taunt_weight_multiplier = 2,
	threat_multiplier = 1.5,
}
minion_target_selection_weights.twin_captain_two = {
	disabled = -5000,
	distance_to_target = 1,
	knocked_down_weight = -5000,
	ledge_hanging_weight = -20,
	max_distance = 20,
	occupied_slots = -2,
	stickiness_bonus = 5000,
	stickiness_duration = 6,
	taunt_weight_multiplier = 20,
	threat_multiplier = 5,
}

return settings("MinionTargetSelectionWeights", minion_target_selection_weights)
