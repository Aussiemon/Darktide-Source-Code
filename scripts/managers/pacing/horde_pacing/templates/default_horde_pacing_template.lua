-- chunkname: @scripts/managers/pacing/horde_pacing/templates/default_horde_pacing_template.lua

local HordeCompositions = require("scripts/managers/pacing/horde_pacing/horde_compositions")
local HordeSettings = require("scripts/settings/horde/horde_settings")
local HordeTemplates = require("scripts/managers/horde/horde_templates")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local COORDINATED_HORDE_STRIKE_TYPES = HordeSettings.coordinated_horde_strike_types
local STINGER_SOUND_EVENTS = {
	infected_large = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
	infected_medium = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
	renegade_large = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
	renegade_medium = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
}
local PRE_STINGER_DELAYS = {
	ambush_horde = 7,
	far_vector_horde = 7,
}
local PRE_STINGER_SOUND_EVENTS = {
	infected_large = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
	infected_medium = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
	renegade_large = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
	renegade_medium = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
}
local HORDE_GROUP_SOUND_EVENTS = {
	renegade_medium = {
		start = "wwise/events/minions/play_horde_group_sfx_poxwalkers",
		stop = "wwise/events/minions/stop_horde_group_sfx_poxwalkers",
	},
	infected_medium = {
		start = "wwise/events/minions/play_horde_group_sfx_newly_infected",
		stop = "wwise/events/minions/stop_horde_group_sfx_newly_infected",
	},
	renegade_large = {
		start = "wwise/events/minions/play_horde_group_sfx_poxwalkers",
		stop = "wwise/events/minions/stop_horde_group_sfx_poxwalkers",
	},
	infected_large = {
		start = "wwise/events/minions/play_horde_group_sfx_newly_infected",
		stop = "wwise/events/minions/stop_horde_group_sfx_newly_infected",
	},
}
local DEFAULT_TRICKLE_HORDE_COMPOSITIONS = {
	renegade = {
		none = {
			HordeCompositions.renegade_trickle_melee,
			HordeCompositions.renegade_trickle_riflemen,
		},
		low = {
			HordeCompositions.renegade_trickle_melee,
			HordeCompositions.renegade_trickle_riflemen,
		},
		high = {
			HordeCompositions.renegade_trickle_riflemen_high,
		},
		poxwalkers = {
			HordeCompositions.renegade_trickle_melee,
		},
		waiting_for_ramp_clear = {
			HordeCompositions.renegade_trickle_ogryns_high_3,
			HordeCompositions.renegade_trickle_ogryns_high_4,
			HordeCompositions.renegade_trickle_high_1,
			HordeCompositions.renegade_trickle_high_2,
		},
	},
	cultist = {
		none = {
			HordeCompositions.cultist_trickle_melee,
		},
		low = {
			HordeCompositions.cultist_trickle_assaulters,
			HordeCompositions.cultist_trickle_melee,
		},
		high = {
			HordeCompositions.cultist_trickle_assaulters_high,
		},
		poxwalkers = {
			HordeCompositions.cultist_trickle_melee,
		},
		waiting_for_ramp_clear = {
			HordeCompositions.cultist_trickle_ogryns_high_3,
			HordeCompositions.cultist_trickle_ogryns_high_4,
			HordeCompositions.cultist_trickle_high_1,
			HordeCompositions.cultist_trickle_high_2,
		},
	},
}
local HIGH_TRICKLE_HORDE_COMPOSITIONS = {
	renegade = {
		none = {
			HordeCompositions.renegade_trickle_melee,
			HordeCompositions.renegade_trickle_riflemen,
		},
		low = {
			HordeCompositions.renegade_trickle_riflemen,
			HordeCompositions.renegade_trickle_assault,
		},
		high = {
			HordeCompositions.renegade_trickle_riflemen_high,
			HordeCompositions.renegade_trickle_gunners,
			HordeCompositions.renegade_trickle_melee_elites,
			HordeCompositions.renegade_trickle_ogryn_gunners,
			HordeCompositions.renegade_trickle_ogryn_bulwarks,
			HordeCompositions.renegade_trickle_ogryn_executors,
		},
		waiting_for_ramp_clear = {
			HordeCompositions.renegade_trickle_ogryns_high_3,
			HordeCompositions.renegade_trickle_ogryns_high_4,
			HordeCompositions.renegade_trickle_high_1,
			HordeCompositions.renegade_trickle_high_2,
		},
		poxwalkers = {
			HordeCompositions.renegade_trickle_melee,
		},
	},
	cultist = {
		none = {
			HordeCompositions.cultist_trickle_melee,
			HordeCompositions.cultist_trickle_assaulters,
		},
		low = {
			HordeCompositions.cultist_trickle_melee,
			HordeCompositions.cultist_trickle_assaulters,
		},
		high = {
			HordeCompositions.cultist_trickle_assaulters_high,
			HordeCompositions.cultist_trickle_gunners,
			HordeCompositions.cultist_trickle_melee_elites,
			HordeCompositions.cultist_trickle_ogryn_gunners,
			HordeCompositions.cultist_trickle_ogryn_bulwarks,
			HordeCompositions.cultist_trickle_ogryn_executors,
		},
		waiting_for_ramp_clear = {
			HordeCompositions.cultist_trickle_ogryns_high_3,
			HordeCompositions.cultist_trickle_ogryns_high_4,
			HordeCompositions.cultist_trickle_high_1,
			HordeCompositions.cultist_trickle_high_2,
		},
		poxwalkers = {
			HordeCompositions.cultist_trickle_melee,
		},
	},
}

local function has_build_up_tension_or_low()
	local pacing_state = Managers.state.pacing:state()
	local has_correct_pacing_state = pacing_state == "build_up_tension_low" or pacing_state == "build_up_tension"

	return has_correct_pacing_state
end

local function has_build_up_tension_or_high()
	local pacing_state = Managers.state.pacing:state()
	local has_correct_pacing_state = pacing_state == "build_up_tension" or pacing_state == "build_up_tension_high"

	return has_correct_pacing_state
end

local MEDIUM_CHALLENGE_RATING = 8
local HIGH_CHALLENGE_RATING = 35

local function has_medium_challenge_rating()
	local total_challenge_rating = Managers.state.pacing:total_challenge_rating()

	return total_challenge_rating >= MEDIUM_CHALLENGE_RATING and total_challenge_rating < HIGH_CHALLENGE_RATING
end

local function has_high_challenge_rating()
	local total_challenge_rating = Managers.state.pacing:total_challenge_rating()

	return total_challenge_rating >= HIGH_CHALLENGE_RATING
end

local function has_below_high_challenge_rating()
	local total_challenge_rating = Managers.state.pacing:total_challenge_rating()

	return total_challenge_rating < HIGH_CHALLENGE_RATING
end

local function long_low_period()
	local pacing_state = Managers.state.pacing:state()

	if pacing_state ~= "build_up_tension_low" and pacing_state ~= "build_up_tension" then
		return
	end

	local state_duration = Managers.state.pacing:low_state_duration()
	local long_low = state_duration > 50

	return long_low
end

local function has_high_combat_vector_minions()
	local combat_vector_system = Managers.state.extension:system("combat_vector_system")
	local num_aggroed_combat_vector_minions = combat_vector_system:num_aggroed_combat_vector_minions()

	return num_aggroed_combat_vector_minions > 8
end

local function more_than_one_num_alive_players(target_side_id)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(target_side_id)
	local target_units = side.valid_player_units
	local num_target_units = #target_units
	local num_non_disabled_players = 0

	for i = 1, num_target_units do
		local player_unit = target_units[i]
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local requires_help = PlayerUnitStatus.requires_help(character_state_component)

		if not requires_help then
			num_non_disabled_players = num_non_disabled_players + 1
		end
	end

	return num_non_disabled_players > 1
end

local function low_coherency(target_side_id)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(target_side_id)
	local target_units = side.valid_player_units
	local num_target_units = #target_units

	for i = 1, num_target_units do
		local possible_target = target_units[i]
		local coherency_extension = ScriptUnit.has_extension(possible_target, "coherency_system")
		local num_units_in_coherency = coherency_extension:num_units_in_coherency()

		if num_units_in_coherency <= 2 then
			return true
		end
	end

	return false
end

local horde_pacing_template = {
	name = "default_horde",
	resistance_templates = {
		{
			aggro_nearby_roamers_zone_range = 1,
			max_active_minions = 70,
			max_active_minions_for_ambush = 50,
			num_trickle_hordes_active_for_cooldown = 2,
			time_between_waves = 17,
			travel_distance_spawning = true,
			trigger_heard_dialogue = true,
			horde_timer_range = {
				220,
				360,
			},
			first_spawn_timer_modifer = {
				0.4,
				0.8,
			},
			num_waves = {
				ambush_horde = 1,
				far_vector_horde = 3,
			},
			max_active_hordes = {
				ambush_horde = 1,
				far_vector_horde = 3,
			},
			travel_distance_required_for_horde = {
				120,
				190,
			},
			horde_templates = {
				HordeTemplates.far_vector_horde,
				HordeTemplates.ambush_horde,
			},
			horde_compositions = {
				far_vector_horde = {
					HordeCompositions.renegade_medium,
					HordeCompositions.infected_medium,
				},
				ambush_horde = {
					HordeCompositions.infected_large,
				},
				trickle_horde = DEFAULT_TRICKLE_HORDE_COMPOSITIONS,
				flood_horde = {
					HordeCompositions.renegade_flood,
				},
			},
			stinger_sound_events = STINGER_SOUND_EVENTS,
			pre_stinger_sound_events = PRE_STINGER_SOUND_EVENTS,
			horde_group_sound_events = HORDE_GROUP_SOUND_EVENTS,
			pre_stinger_delays = PRE_STINGER_DELAYS,
			trickle_horde_travel_distance_range = {
				120,
				240,
			},
			trickle_horde_cooldown = {
				40,
				45,
			},
		},
		{
			aggro_nearby_roamers_zone_range = 1,
			max_active_minions = 70,
			max_active_minions_for_ambush = 50,
			num_trickle_hordes_active_for_cooldown = 3,
			time_between_waves = 15,
			travel_distance_spawning = true,
			trigger_heard_dialogue = true,
			horde_timer_range = {
				220,
				360,
			},
			first_spawn_timer_modifer = {
				0.4,
				0.8,
			},
			num_waves = {
				ambush_horde = 1,
				far_vector_horde = 3,
			},
			max_active_hordes = {
				ambush_horde = 1,
				far_vector_horde = 3,
			},
			travel_distance_required_for_horde = {
				80,
				130,
			},
			horde_templates = {
				HordeTemplates.far_vector_horde,
				HordeTemplates.ambush_horde,
			},
			horde_compositions = {
				far_vector_horde = {
					HordeCompositions.renegade_medium,
					HordeCompositions.infected_medium,
				},
				ambush_horde = {
					HordeCompositions.infected_large,
				},
				trickle_horde = DEFAULT_TRICKLE_HORDE_COMPOSITIONS,
				flood_horde = {
					HordeCompositions.renegade_flood,
				},
			},
			stinger_sound_events = STINGER_SOUND_EVENTS,
			pre_stinger_sound_events = PRE_STINGER_SOUND_EVENTS,
			horde_group_sound_events = HORDE_GROUP_SOUND_EVENTS,
			pre_stinger_delays = PRE_STINGER_DELAYS,
			trickle_horde_travel_distance_range = {
				120,
				220,
			},
			trickle_horde_cooldown = {
				40,
				45,
			},
			coordinated_horde_strike_settings = {
				[COORDINATED_HORDE_STRIKE_TYPES.long_horde] = {
					chance = 0.2,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_high,
						has_high_challenge_rating,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						1,
						3,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 10,
							time_to_first_wave = 7,
							num_waves = {
								6,
								7,
							},
							composition = HordeCompositions.renegade_medium,
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.coordinated_special_attack] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_below_high_challenge_rating,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						0,
						2,
					},
					horde_setup = {
						{
							horde_type = "ambush_horde",
							stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
							time_between_waves = 12,
							time_to_first_wave = 7,
							trigger_special_coordinated_attack_num_breeds = 10,
							trigger_special_coordinated_attack_on_first_wave = true,
							trigger_special_coordinated_attack_timer_offset = 5,
							num_waves = {
								3,
								4,
							},
							composition = HordeCompositions.infected_medium,
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.push_from_behind] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_high,
						more_than_one_num_alive_players,
						has_high_challenge_rating,
						has_high_combat_vector_minions,
					},
					high_chance_conditions = {
						has_high_combat_vector_minions,
					},
					total_num_allowed = {
						0,
						2,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							prefered_direction = "behind",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 9,
							time_to_first_wave = 7,
							num_waves = {
								7,
								8,
							},
							composition = HordeCompositions.renegade_small,
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.ranged_push_from_behind] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_medium_challenge_rating,
					},
					high_chance_conditions = {
						has_high_combat_vector_minions,
					},
					total_num_allowed = {
						0,
						2,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							prefered_direction = "behind",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 9,
							time_to_first_wave = 7,
							num_waves = {
								4,
								5,
							},
							composition = HordeCompositions.renegade_small,
						},
						{
							horde_type = "far_vector_horde",
							prefered_direction = "ahead",
							time_between_waves = 9,
							time_to_first_wave = 12,
							num_waves = {
								2,
								3,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_coordinated_ranged_horde,
								},
								cultist = {
									HordeCompositions.cultist_coordinated_ranged_horde,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.spread_ambush] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
					},
					high_chance_conditions = {
						low_coherency,
					},
					total_num_allowed = {
						1,
						2,
					},
					horde_setup = {
						{
							horde_type = "ambush_horde",
							random_targets = true,
							stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
							time_between_waves = 5,
							time_to_first_wave = 3,
							num_waves = {
								6,
								7,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.infected_small,
								},
								cultist = {
									HordeCompositions.infected_small,
								},
							},
						},
					},
				},
			},
		},
		{
			aggro_nearby_roamers_zone_range = 1,
			max_active_minions = 85,
			max_active_minions_for_ambush = 50,
			num_trickle_hordes_active_for_cooldown = 3,
			time_between_waves = 10,
			travel_distance_spawning = true,
			trigger_heard_dialogue = true,
			horde_timer_range = {
				210,
				340,
			},
			first_spawn_timer_modifer = {
				0.4,
				0.8,
			},
			num_waves = {
				ambush_horde = 1,
				far_vector_horde = 3,
			},
			max_active_hordes = {
				ambush_horde = 1,
				far_vector_horde = 3,
			},
			travel_distance_required_for_horde = {
				80,
				130,
			},
			horde_templates = {
				HordeTemplates.far_vector_horde,
				HordeTemplates.ambush_horde,
			},
			horde_compositions = {
				far_vector_horde = {
					HordeCompositions.renegade_medium,
					HordeCompositions.infected_medium,
				},
				ambush_horde = {
					HordeCompositions.infected_large,
				},
				trickle_horde = DEFAULT_TRICKLE_HORDE_COMPOSITIONS,
				flood_horde = {
					HordeCompositions.renegade_flood,
				},
			},
			stinger_sound_events = STINGER_SOUND_EVENTS,
			pre_stinger_sound_events = PRE_STINGER_SOUND_EVENTS,
			horde_group_sound_events = HORDE_GROUP_SOUND_EVENTS,
			pre_stinger_delays = PRE_STINGER_DELAYS,
			trickle_horde_travel_distance_range = {
				100,
				200,
			},
			trickle_horde_cooldown = {
				40,
				45,
			},
			coordinated_horde_strike_settings = {
				[COORDINATED_HORDE_STRIKE_TYPES.long_horde] = {
					chance = 0.2,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_high,
						has_high_challenge_rating,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						1,
						3,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 5,
							time_to_first_wave = 7,
							num_waves = {
								6,
								7,
							},
							composition = HordeCompositions.renegade_medium,
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.coordinated_special_attack] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_below_high_challenge_rating,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						0,
						2,
					},
					horde_setup = {
						{
							horde_type = "ambush_horde",
							stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
							time_between_waves = 12,
							time_to_first_wave = 7,
							trigger_special_coordinated_attack_num_breeds = 10,
							trigger_special_coordinated_attack_on_first_wave = true,
							trigger_special_coordinated_attack_timer_offset = 5,
							num_waves = {
								3,
								4,
							},
							composition = HordeCompositions.infected_medium,
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.push_from_behind] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_high,
						more_than_one_num_alive_players,
						has_high_challenge_rating,
						has_high_combat_vector_minions,
					},
					high_chance_conditions = {
						has_high_combat_vector_minions,
					},
					total_num_allowed = {
						0,
						2,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							prefered_direction = "behind",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 9,
							time_to_first_wave = 7,
							num_waves = {
								7,
								8,
							},
							composition = HordeCompositions.renegade_small,
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.ranged_push_from_behind] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_medium_challenge_rating,
					},
					high_chance_conditions = {
						has_high_combat_vector_minions,
					},
					total_num_allowed = {
						0,
						2,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							prefered_direction = "behind",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 9,
							time_to_first_wave = 7,
							num_waves = {
								4,
								5,
							},
							composition = HordeCompositions.renegade_small,
						},
						{
							horde_type = "far_vector_horde",
							prefered_direction = "ahead",
							time_between_waves = 9,
							time_to_first_wave = 12,
							num_waves = {
								2,
								3,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_coordinated_ranged_horde,
								},
								cultist = {
									HordeCompositions.cultist_coordinated_ranged_horde,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.elite_roamer_mix_vector] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_below_high_challenge_rating,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						0,
						2,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 7,
							time_to_first_wave = 6,
							num_waves = {
								3,
								4,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_coordinated_melee_mix,
								},
								cultist = {
									HordeCompositions.cultist_coordinated_melee_mix,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.spread_ambush] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
					},
					high_chance_conditions = {
						low_coherency,
					},
					total_num_allowed = {
						1,
						2,
					},
					horde_setup = {
						{
							horde_type = "ambush_horde",
							random_targets = true,
							stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
							time_between_waves = 5,
							time_to_first_wave = 3,
							num_waves = {
								6,
								7,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.infected_small,
								},
								cultist = {
									HordeCompositions.infected_small,
								},
							},
						},
					},
				},
			},
		},
		{
			aggro_nearby_roamers_zone_range = 2,
			max_active_minions = 90,
			max_active_minions_for_ambush = 50,
			num_trickle_hordes_active_for_cooldown = 3,
			time_between_waves = 10,
			travel_distance_spawning = true,
			trigger_heard_dialogue = true,
			horde_timer_range = {
				210,
				340,
			},
			first_spawn_timer_modifer = {
				0.4,
				0.8,
			},
			num_waves = {
				ambush_horde = 1,
				far_vector_horde = 3,
			},
			max_active_hordes = {
				ambush_horde = 1,
				far_vector_horde = 3,
			},
			travel_distance_required_for_horde = {
				50,
				80,
			},
			horde_templates = {
				HordeTemplates.far_vector_horde,
				HordeTemplates.ambush_horde,
			},
			horde_compositions = {
				far_vector_horde = {
					HordeCompositions.renegade_medium,
					HordeCompositions.infected_medium,
				},
				ambush_horde = {
					HordeCompositions.infected_large,
				},
				trickle_horde = HIGH_TRICKLE_HORDE_COMPOSITIONS,
				flood_horde = {
					HordeCompositions.renegade_flood,
				},
			},
			stinger_sound_events = STINGER_SOUND_EVENTS,
			pre_stinger_sound_events = PRE_STINGER_SOUND_EVENTS,
			horde_group_sound_events = HORDE_GROUP_SOUND_EVENTS,
			pre_stinger_delays = PRE_STINGER_DELAYS,
			trickle_horde_travel_distance_range = {
				60,
				160,
			},
			trickle_horde_cooldown = {
				40,
				45,
			},
			coordinated_horde_strike_settings = {
				[COORDINATED_HORDE_STRIKE_TYPES.long_horde] = {
					chance = 0.2,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_high,
						has_high_challenge_rating,
					},
					total_num_allowed = {
						1,
						3,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 5,
							time_to_first_wave = 7,
							num_waves = {
								6,
								7,
							},
							composition = HordeCompositions.renegade_medium,
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.coordinated_special_attack] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_below_high_challenge_rating,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						1,
						3,
					},
					horde_setup = {
						{
							horde_type = "ambush_horde",
							stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
							time_between_waves = 12,
							time_to_first_wave = 7,
							trigger_special_coordinated_attack_num_breeds = 10,
							trigger_special_coordinated_attack_on_first_wave = true,
							trigger_special_coordinated_attack_timer_offset = 5,
							num_waves = {
								3,
								4,
							},
							composition = HordeCompositions.infected_medium,
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.push_from_behind] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_high,
						more_than_one_num_alive_players,
						has_high_challenge_rating,
						has_high_combat_vector_minions,
					},
					high_chance_conditions = {
						has_high_combat_vector_minions,
					},
					total_num_allowed = {
						1,
						3,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							prefered_direction = "behind",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 9,
							time_to_first_wave = 7,
							num_waves = {
								7,
								8,
							},
							composition = HordeCompositions.renegade_small,
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.ranged_push_from_behind] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_medium_challenge_rating,
					},
					high_chance_conditions = {
						has_high_combat_vector_minions,
					},
					total_num_allowed = {
						1,
						3,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							prefered_direction = "behind",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 9,
							time_to_first_wave = 7,
							num_waves = {
								4,
								5,
							},
							composition = HordeCompositions.renegade_small,
						},
						{
							horde_type = "far_vector_horde",
							prefered_direction = "ahead",
							time_between_waves = 9,
							time_to_first_wave = 12,
							num_waves = {
								2,
								3,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_coordinated_ranged_horde,
								},
								cultist = {
									HordeCompositions.cultist_coordinated_ranged_horde,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.elite_roamer_mix_vector] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_below_high_challenge_rating,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						1,
						3,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 7,
							time_to_first_wave = 6,
							num_waves = {
								3,
								4,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_coordinated_melee_mix,
								},
								cultist = {
									HordeCompositions.cultist_coordinated_melee_mix,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.spread_ambush] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
					},
					high_chance_conditions = {
						low_coherency,
					},
					total_num_allowed = {
						2,
						4,
					},
					horde_setup = {
						{
							horde_type = "ambush_horde",
							random_targets = true,
							stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
							time_between_waves = 5,
							time_to_first_wave = 3,
							num_waves = {
								6,
								7,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.infected_small,
								},
								cultist = {
									HordeCompositions.infected_small,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.sandwich] = {
					chance = 0.3,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_below_high_challenge_rating,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						2,
						4,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 7,
							time_to_first_wave = 6,
							two_waves_ahead_and_behind = true,
							num_waves = {
								5,
								6,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_medium,
								},
								cultist = {
									HordeCompositions.infected_medium,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.ranged_trickle_forward_horde_push_from_behind] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						1,
						3,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							prefered_direction = "behind",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 9,
							time_to_first_wave = 7,
							num_waves = {
								4,
								5,
							},
							composition = HordeCompositions.renegade_small,
						},
						{
							horde_type = "far_vector_horde",
							prefered_direction = "ahead",
							time_between_waves = 9,
							time_to_first_wave = 8,
							num_waves = {
								4,
								5,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_small_coordinated_ranged_horde,
								},
								cultist = {
									HordeCompositions.cultist_small_coordinated_ranged_horde,
								},
							},
						},
					},
				},
			},
		},
		{
			aggro_nearby_roamers_zone_range = 3,
			max_active_minions = 95,
			max_active_minions_for_ambush = 50,
			num_trickle_hordes_active_for_cooldown = 4,
			time_between_waves = 10,
			travel_distance_spawning = true,
			trigger_heard_dialogue = true,
			horde_timer_range = {
				160,
				320,
			},
			first_spawn_timer_modifer = {
				0.4,
				0.8,
			},
			num_waves = {
				ambush_horde = 1,
				far_vector_horde = 3,
			},
			max_active_hordes = {
				ambush_horde = 1,
				far_vector_horde = 3,
			},
			travel_distance_required_for_horde = {
				40,
				70,
			},
			horde_templates = {
				HordeTemplates.far_vector_horde,
				HordeTemplates.ambush_horde,
			},
			horde_compositions = {
				far_vector_horde = {
					HordeCompositions.renegade_medium,
					HordeCompositions.infected_medium,
				},
				ambush_horde = {
					HordeCompositions.infected_large,
				},
				trickle_horde = HIGH_TRICKLE_HORDE_COMPOSITIONS,
				flood_horde = {
					HordeCompositions.renegade_flood,
				},
			},
			stinger_sound_events = STINGER_SOUND_EVENTS,
			pre_stinger_sound_events = PRE_STINGER_SOUND_EVENTS,
			horde_group_sound_events = HORDE_GROUP_SOUND_EVENTS,
			pre_stinger_delays = PRE_STINGER_DELAYS,
			trickle_horde_travel_distance_range = {
				40,
				120,
			},
			trickle_horde_cooldown = {
				30,
				45,
			},
			coordinated_horde_strike_settings = {
				[COORDINATED_HORDE_STRIKE_TYPES.long_horde] = {
					chance = 0.2,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_high,
						has_high_challenge_rating,
					},
					total_num_allowed = {
						0,
						2,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 5,
							time_to_first_wave = 7,
							num_waves = {
								6,
								7,
							},
							composition = HordeCompositions.renegade_medium,
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.coordinated_special_attack] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						3,
						6,
					},
					horde_setup = {
						{
							horde_type = "ambush_horde",
							stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
							time_between_waves = 12,
							time_to_first_wave = 7,
							trigger_special_coordinated_attack_num_breeds = 10,
							trigger_special_coordinated_attack_on_first_wave = true,
							trigger_special_coordinated_attack_timer_offset = 5,
							num_waves = {
								3,
								4,
							},
							composition = HordeCompositions.infected_medium,
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.push_from_behind] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_high,
						more_than_one_num_alive_players,
						has_high_challenge_rating,
						has_high_combat_vector_minions,
					},
					high_chance_conditions = {
						has_high_combat_vector_minions,
					},
					total_num_allowed = {
						1,
						3,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							prefered_direction = "behind",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 9,
							time_to_first_wave = 7,
							num_waves = {
								7,
								8,
							},
							composition = HordeCompositions.renegade_small,
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.ranged_push_from_behind] = {
					chance = 0.05,
					high_chance = 0.5,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_medium_challenge_rating,
					},
					high_chance_conditions = {
						has_high_combat_vector_minions,
					},
					total_num_allowed = {
						1,
						3,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							prefered_direction = "behind",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 9,
							time_to_first_wave = 7,
							num_waves = {
								4,
								5,
							},
							composition = HordeCompositions.renegade_small,
						},
						{
							horde_type = "far_vector_horde",
							prefered_direction = "ahead",
							time_between_waves = 9,
							time_to_first_wave = 12,
							num_waves = {
								2,
								3,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_coordinated_ranged_horde,
								},
								cultist = {
									HordeCompositions.cultist_coordinated_ranged_horde,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.elite_roamer_mix_vector] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_below_high_challenge_rating,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						1,
						3,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 7,
							time_to_first_wave = 6,
							num_waves = {
								3,
								4,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_coordinated_melee_mix,
								},
								cultist = {
									HordeCompositions.cultist_coordinated_melee_mix,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.spread_ambush] = {
					chance = 0.5,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
					},
					high_chance_conditions = {
						low_coherency,
					},
					total_num_allowed = {
						2,
						4,
					},
					horde_setup = {
						{
							horde_type = "ambush_horde",
							random_targets = true,
							stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
							time_between_waves = 5,
							time_to_first_wave = 3,
							num_waves = {
								6,
								7,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.infected_small,
								},
								cultist = {
									HordeCompositions.infected_small,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.sandwich] = {
					chance = 0.3,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_below_high_challenge_rating,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						2,
						4,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 7,
							time_to_first_wave = 6,
							two_waves_ahead_and_behind = true,
							num_waves = {
								5,
								6,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_medium,
								},
								cultist = {
									HordeCompositions.infected_medium,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.elite_sandwich_waves] = {
					chance = 0.3,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_below_high_challenge_rating,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						2,
						4,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 7,
							time_to_first_wave = 6,
							two_waves_ahead_and_behind = true,
							num_waves = {
								5,
								6,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_coordinated_melee_mix,
									HordeCompositions.renegade_coordinated_melee_mix_2,
								},
								cultist = {
									HordeCompositions.cultist_coordinated_melee_mix,
									HordeCompositions.renegade_coordinated_melee_mix_2,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.elite_coordinated_special_attack] = {
					chance = 0.3,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
						has_below_high_challenge_rating,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						2,
						4,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 7,
							time_to_first_wave = 6,
							trigger_special_coordinated_attack_num_breeds = 10,
							trigger_special_coordinated_attack_on_first_wave = true,
							trigger_special_coordinated_attack_timer_offset = 5,
							two_waves_ahead_and_behind = true,
							num_waves = {
								3,
								4,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_coordinated_melee_mix,
									HordeCompositions.renegade_coordinated_melee_mix_2,
								},
								cultist = {
									HordeCompositions.cultist_coordinated_melee_mix,
									HordeCompositions.renegade_coordinated_melee_mix_2,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.ranged_trickle_forward_horde_push_from_behind] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_signal_horde_poxwalkers_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						1,
						3,
					},
					horde_setup = {
						{
							horde_type = "far_vector_horde",
							prefered_direction = "behind",
							stinger = "wwise/events/minions/play_signal_horde_poxwalkers_3d",
							time_between_waves = 9,
							time_to_first_wave = 7,
							num_waves = {
								4,
								5,
							},
							composition = HordeCompositions.renegade_small,
						},
						{
							horde_type = "far_vector_horde",
							prefered_direction = "ahead",
							time_between_waves = 9,
							time_to_first_wave = 8,
							num_waves = {
								4,
								5,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_small_coordinated_ranged_horde,
								},
								cultist = {
									HordeCompositions.cultist_small_coordinated_ranged_horde,
								},
							},
						},
					},
				},
				[COORDINATED_HORDE_STRIKE_TYPES.elite_spread_ambush] = {
					chance = 0.2,
					high_chance = 0.8,
					pre_stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d",
					conditions = {
						has_build_up_tension_or_low,
						more_than_one_num_alive_players,
					},
					high_chance_conditions = {
						long_low_period,
					},
					total_num_allowed = {
						2,
						4,
					},
					horde_setup = {
						{
							horde_type = "ambush_horde",
							random_targets = true,
							skip_spawners = true,
							stinger = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d",
							time_between_waves = 2,
							time_to_first_wave = 4,
							num_waves = {
								6,
								7,
							},
							faction_composition = {
								renegade = {
									HordeCompositions.renegade_elite_poxwalkers_small,
								},
								cultist = {
									HordeCompositions.cultist_elite_poxwalkers_small,
								},
							},
						},
					},
				},
			},
		},
	},
}

for _, resistance_composition in pairs(horde_pacing_template.resistance_templates) do
	if resistance_composition.coordinated_horde_strike_settings then
		for coordinated_horde_strike_setting_name, coordinated_horde_strike_setting in pairs(resistance_composition.coordinated_horde_strike_settings) do
			coordinated_horde_strike_setting.name = coordinated_horde_strike_setting_name
		end
	end
end

return horde_pacing_template
