﻿-- chunkname: @scripts/managers/pacing/specials_pacing/templates/default_specials_pacing_template.lua

local DEFAULT_FORESHADOW_STINGERS = {
	renegade_netgunner = "wwise/events/minions/play_minion_special_netgunner_spawn",
	chaos_hound = "wwise/events/minions/play_enemy_chaos_hound_spawn"
}
local DEFAULT_FORESHADOW_STINGER_TIMERS = {
	cultist_mutant = 5,
	chaos_hound = 5,
	renegade_netgunner = 4
}
local DEFAULT_SPAWN_STINGERS = {
	cultist_mutant = "wwise/events/minions/play_minion_special_mutant_charger_spawn",
	chaos_poxwalker_bomber = "wwise/events/minions/play_minion_special_poxwalker_bomber_spawn"
}
local DEFAULT_OPTIONAL_PREFERED_SPAWN_DIRECTION = {
	renegade_sniper = "ahead",
	renegade_grenadier = "ahead",
	cultist_grenadier = "ahead"
}
local DEFAULT_OPTIONAL_MAINPATH_OFFSET = {
	renegade_sniper = 40,
	renegade_grenadier = 30,
	cultist_grenadier = 30
}
local DEFAULT_BREEDS = {
	all = {
		"chaos_hound",
		"chaos_poxwalker_bomber",
		"cultist_mutant",
		"grenadier",
		"renegade_netgunner",
		"renegade_sniper",
		"flamer"
	},
	disablers = {
		"chaos_hound",
		"renegade_netgunner",
		"cultist_mutant"
	},
	scramblers = {
		"chaos_poxwalker_bomber",
		"grenadier",
		"renegade_sniper",
		"flamer"
	}
}
local DEFAULT_COORDINATED_STRIKE_BREEDS = {
	"chaos_hound",
	"chaos_poxwalker_bomber",
	"cultist_mutant",
	"renegade_netgunner",
	"flamer"
}
local DEFAULT_RUSH_PREVENTION_BREEDS = {
	"chaos_hound",
	"cultist_mutant"
}
local DEFAULT_LONER_PREVENTION_BREEDS = {
	"chaos_hound",
	"cultist_mutant",
	"renegade_netgunner"
}
local DEFAULT_SPEED_RUNNING_PREVENTION_BREEDS = {
	"chaos_hound",
	"cultist_mutant",
	"renegade_netgunner"
}
local FACTION_BOUND_BREEDS = {
	flamer = {
		cultist = "cultist_flamer",
		renegade = "renegade_flamer"
	},
	grenadier = {
		cultist = "cultist_grenadier",
		renegade = "renegade_grenadier"
	}
}
local DEFAULT_MIN_DISTANCES_FROM_TARGET = {
	chaos_poxwalker_bomber = 35,
	chaos_hound = 25,
	renegade_grenadier = 20,
	renegade_flamer = 15,
	renegade_netgunner = 28,
	cultist_grenadier = 20,
	renegade_sniper = 30,
	chaos_plague_ogryn = 30,
	cultist_mutant = 25,
	chaos_spawn = 30,
	chaos_beast_of_nurgle = 30,
	cultist_flamer = 20
}
local DEFAULT_MIN_SPAWNERS_RANGES = {
	max = 49,
	min = 20
}
local DEFAULT_NUM_ALLOWED_DISABLED_PER_ALIVE_TARGETS = {
	{
		0,
		0,
		1,
		1
	},
	{
		0,
		1,
		1,
		2
	},
	{
		0,
		1,
		2,
		3
	},
	{
		1,
		2,
		3,
		3
	},
	{
		1,
		2,
		3,
		4
	}
}
local DEFAULT_DISABLER_OVERRIDE_DURATION = {
	360,
	240,
	160,
	100,
	80
}
local DEFAULT_DISABLER_TARGET_ALONE_PLAYER_CHANCE = {
	renegade_netgunner = 0.5,
	chaos_hound = 0.75,
	cultist_mutant = 0.25
}
local LOW_MAX_OF_SAME = {
	chaos_poxwalker_bomber = 1,
	grenadier = 2,
	renegade_grenadier = 2,
	renegade_flamer = 2,
	renegade_netgunner = 1,
	renegade_sniper = 2,
	chaos_plague_ogryn = 2,
	cultist_grenadier = 1,
	cultist_mutant = 1,
	chaos_hound = 1,
	chaos_beast_of_nurgle = 1,
	flamer = 2,
	chaos_spawn = 2,
	cultist_flamer = 2
}
local DEFAULT_MAX_OF_SAME = {
	chaos_poxwalker_bomber = 2,
	grenadier = 2,
	renegade_grenadier = 2,
	renegade_flamer = 2,
	renegade_netgunner = 2,
	renegade_sniper = 2,
	chaos_plague_ogryn = 2,
	cultist_grenadier = 1,
	cultist_mutant = 3,
	chaos_hound = 2,
	chaos_beast_of_nurgle = 1,
	flamer = 2,
	chaos_spawn = 2,
	cultist_flamer = 2
}
local HIGH_MAX_OF_SAME = {
	chaos_poxwalker_bomber = 3,
	grenadier = 3,
	renegade_grenadier = 2,
	renegade_flamer = 2,
	renegade_netgunner = 2,
	renegade_sniper = 3,
	chaos_plague_ogryn = 2,
	cultist_grenadier = 2,
	cultist_mutant = 4,
	chaos_hound = 2,
	chaos_beast_of_nurgle = 1,
	flamer = 2,
	chaos_spawn = 2,
	cultist_flamer = 2
}
local ALWAYS_UPDATE_AT_CHALLANGE_RATING_BREEDS = {
	cultist_mutant = 5,
	renegade_sniper = 0,
	renegade_grenadier = 2,
	cultist_grenadier = 2
}
local specials_pacing_template = {
	name = "default_specials",
	resistance_templates = {
		{
			destroy_special_distance = 100,
			move_timer_when_challenge_rating_above = 30,
			first_spawn_timer_modifer = 0.75,
			rushing_distance = 80,
			travel_distance_spawning = true,
			move_timer_when_challenge_rating_above_delay = 20,
			coordinated_strike_challenge_rating = 5,
			chance_for_coordinated_strike = 0.1,
			max_alive_specials = 3,
			max_spawn_group_offset_range = 6,
			move_timer_when_horde_active = false,
			move_timer_when_monster_active = false,
			spawn_failed_wait_time = 5,
			timer_range = {
				200,
				420
			},
			always_update_breeds = ALWAYS_UPDATE_AT_CHALLANGE_RATING_BREEDS,
			max_of_same = LOW_MAX_OF_SAME,
			min_distances_from_target = DEFAULT_MIN_DISTANCES_FROM_TARGET,
			breeds = DEFAULT_BREEDS,
			disabler_target_alone_player_chance = DEFAULT_DISABLER_TARGET_ALONE_PLAYER_CHANCE,
			num_allowed_disablers_per_alive_targets = DEFAULT_NUM_ALLOWED_DISABLED_PER_ALIVE_TARGETS,
			disabler_override_duration = DEFAULT_DISABLER_OVERRIDE_DURATION,
			foreshadow_stingers = DEFAULT_FORESHADOW_STINGERS,
			foreshadow_stinger_timers = DEFAULT_FORESHADOW_STINGER_TIMERS,
			optional_prefered_spawn_direction = DEFAULT_OPTIONAL_PREFERED_SPAWN_DIRECTION,
			optional_mainpath_offset = DEFAULT_OPTIONAL_MAINPATH_OFFSET,
			spawn_stingers = DEFAULT_SPAWN_STINGERS,
			spawners_min_range = DEFAULT_MIN_SPAWNERS_RANGES.min,
			spawners_max_range = DEFAULT_MIN_SPAWNERS_RANGES.max,
			coordinated_strike_timer_range = {
				180,
				240
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
			coordinated_strike_num_breeds = {
				2,
				3
			},
			rush_prevention_breeds = DEFAULT_RUSH_PREVENTION_BREEDS,
			rush_prevention_cooldown = {
				150,
				250
			},
			rush_prevention_failed_cooldown = {
				5,
				10
			},
			faction_bound_breeds = FACTION_BOUND_BREEDS
		},
		{
			destroy_special_distance = 100,
			move_timer_when_challenge_rating_above = 30,
			first_spawn_timer_modifer = 0.65,
			speed_running_required_challenge_rating = 50,
			speed_running_required_distance = 12,
			rushing_distance = 60,
			travel_distance_spawning = true,
			num_required_speed_running_checks = 4,
			move_timer_when_challenge_rating_above_delay = 20,
			coordinated_strike_challenge_rating = 5,
			chance_for_coordinated_strike = 0.15,
			max_alive_specials = 4,
			max_spawn_group_offset_range = 6,
			speed_running_check_frequency = 5,
			move_timer_when_horde_active = false,
			move_timer_when_monster_active = false,
			spawn_failed_wait_time = 5,
			timer_range = {
				200,
				420
			},
			always_update_breeds = ALWAYS_UPDATE_AT_CHALLANGE_RATING_BREEDS,
			max_of_same = LOW_MAX_OF_SAME,
			min_distances_from_target = DEFAULT_MIN_DISTANCES_FROM_TARGET,
			breeds = DEFAULT_BREEDS,
			disabler_target_alone_player_chance = DEFAULT_DISABLER_TARGET_ALONE_PLAYER_CHANCE,
			num_allowed_disablers_per_alive_targets = DEFAULT_NUM_ALLOWED_DISABLED_PER_ALIVE_TARGETS,
			disabler_override_duration = DEFAULT_DISABLER_OVERRIDE_DURATION,
			foreshadow_stingers = DEFAULT_FORESHADOW_STINGERS,
			foreshadow_stinger_timers = DEFAULT_FORESHADOW_STINGER_TIMERS,
			optional_prefered_spawn_direction = DEFAULT_OPTIONAL_PREFERED_SPAWN_DIRECTION,
			optional_mainpath_offset = DEFAULT_OPTIONAL_MAINPATH_OFFSET,
			spawn_stingers = DEFAULT_SPAWN_STINGERS,
			spawners_min_range = DEFAULT_MIN_SPAWNERS_RANGES.min,
			spawners_max_range = DEFAULT_MIN_SPAWNERS_RANGES.max,
			coordinated_strike_timer_range = {
				100,
				350
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
			coordinated_strike_num_breeds = {
				3,
				4
			},
			rush_prevention_breeds = DEFAULT_RUSH_PREVENTION_BREEDS,
			rush_prevention_cooldown = {
				80,
				120
			},
			rush_prevention_failed_cooldown = {
				5,
				10
			},
			faction_bound_breeds = FACTION_BOUND_BREEDS,
			speed_running_prevention_breeds = DEFAULT_SPEED_RUNNING_PREVENTION_BREEDS,
			speed_running_prevention_cooldown = {
				20,
				40
			},
			speed_running_prevention_failed_cooldown = {
				5,
				10
			}
		},
		{
			destroy_special_distance = 100,
			move_timer_when_challenge_rating_above = 30,
			first_spawn_timer_modifer = 0.65,
			speed_running_required_challenge_rating = 30,
			speed_running_required_distance = 12,
			rushing_distance = 50,
			travel_distance_spawning = true,
			num_required_speed_running_checks = 4,
			move_timer_when_challenge_rating_above_delay = 20,
			coordinated_strike_challenge_rating = 5,
			chance_for_coordinated_strike = 0.2,
			max_alive_specials = 5,
			max_spawn_group_offset_range = 6,
			speed_running_check_frequency = 5,
			move_timer_when_horde_active = true,
			move_timer_when_monster_active = true,
			spawn_failed_wait_time = 5,
			timer_range = {
				180,
				400
			},
			always_update_breeds = ALWAYS_UPDATE_AT_CHALLANGE_RATING_BREEDS,
			max_of_same = DEFAULT_MAX_OF_SAME,
			min_distances_from_target = DEFAULT_MIN_DISTANCES_FROM_TARGET,
			breeds = DEFAULT_BREEDS,
			disabler_target_alone_player_chance = DEFAULT_DISABLER_TARGET_ALONE_PLAYER_CHANCE,
			num_allowed_disablers_per_alive_targets = DEFAULT_NUM_ALLOWED_DISABLED_PER_ALIVE_TARGETS,
			disabler_override_duration = DEFAULT_DISABLER_OVERRIDE_DURATION,
			foreshadow_stingers = DEFAULT_FORESHADOW_STINGERS,
			foreshadow_stinger_timers = DEFAULT_FORESHADOW_STINGER_TIMERS,
			optional_prefered_spawn_direction = DEFAULT_OPTIONAL_PREFERED_SPAWN_DIRECTION,
			optional_mainpath_offset = DEFAULT_OPTIONAL_MAINPATH_OFFSET,
			spawn_stingers = DEFAULT_SPAWN_STINGERS,
			spawners_min_range = DEFAULT_MIN_SPAWNERS_RANGES.min,
			spawners_max_range = DEFAULT_MIN_SPAWNERS_RANGES.max,
			coordinated_strike_timer_range = {
				100,
				280
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
			coordinated_strike_num_breeds = {
				4,
				5
			},
			rush_prevention_breeds = DEFAULT_RUSH_PREVENTION_BREEDS,
			rush_prevention_cooldown = {
				60,
				100
			},
			rush_prevention_failed_cooldown = {
				5,
				10
			},
			faction_bound_breeds = FACTION_BOUND_BREEDS,
			speed_running_prevention_breeds = DEFAULT_SPEED_RUNNING_PREVENTION_BREEDS,
			speed_running_prevention_cooldown = {
				20,
				40
			},
			speed_running_prevention_failed_cooldown = {
				5,
				10
			}
		},
		{
			coordinated_surge_chance = 0.1,
			move_timer_when_terror_event_active = true,
			first_spawn_timer_modifer = 0.6,
			move_timer_when_challenge_rating_above_delay = 20,
			destroy_special_distance = 100,
			rushing_distance = 45,
			travel_distance_spawning = true,
			speed_running_required_challenge_rating = 10,
			num_required_speed_running_checks = 2,
			speed_running_required_distance = 10,
			move_timer_when_challenge_rating_above = 30,
			coordinated_strike_challenge_rating = 5,
			chance_for_coordinated_strike = 0.225,
			max_alive_specials = 6,
			max_spawn_group_offset_range = 6,
			speed_running_check_frequency = 5,
			move_timer_when_horde_active = true,
			move_timer_when_monster_active = true,
			spawn_failed_wait_time = 5,
			timer_range = {
				120,
				320
			},
			always_update_breeds = ALWAYS_UPDATE_AT_CHALLANGE_RATING_BREEDS,
			max_of_same = HIGH_MAX_OF_SAME,
			min_distances_from_target = DEFAULT_MIN_DISTANCES_FROM_TARGET,
			breeds = DEFAULT_BREEDS,
			disabler_target_alone_player_chance = DEFAULT_DISABLER_TARGET_ALONE_PLAYER_CHANCE,
			num_allowed_disablers_per_alive_targets = DEFAULT_NUM_ALLOWED_DISABLED_PER_ALIVE_TARGETS,
			disabler_override_duration = DEFAULT_DISABLER_OVERRIDE_DURATION,
			foreshadow_stingers = DEFAULT_FORESHADOW_STINGERS,
			foreshadow_stinger_timers = DEFAULT_FORESHADOW_STINGER_TIMERS,
			optional_prefered_spawn_direction = DEFAULT_OPTIONAL_PREFERED_SPAWN_DIRECTION,
			optional_mainpath_offset = DEFAULT_OPTIONAL_MAINPATH_OFFSET,
			spawn_stingers = DEFAULT_SPAWN_STINGERS,
			spawners_min_range = DEFAULT_MIN_SPAWNERS_RANGES.min,
			spawners_max_range = DEFAULT_MIN_SPAWNERS_RANGES.max,
			coordinated_strike_timer_range = {
				100,
				200
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
			coordinated_strike_num_breeds = {
				4,
				6
			},
			coordinated_surge_timer_range = {
				8,
				16
			},
			coordinated_surge_duration_range = {
				20,
				60
			},
			num_coordinated_surges_range = {
				0,
				3
			},
			loner_prevention_breeds = DEFAULT_LONER_PREVENTION_BREEDS,
			loner_prevention_cooldown = {
				40,
				60
			},
			loner_prevention_failed_cooldown = {
				3,
				7
			},
			loner_time = {
				10,
				14
			},
			rush_prevention_breeds = DEFAULT_RUSH_PREVENTION_BREEDS,
			rush_prevention_cooldown = {
				50,
				80
			},
			rush_prevention_failed_cooldown = {
				5,
				10
			},
			faction_bound_breeds = FACTION_BOUND_BREEDS,
			speed_running_prevention_breeds = DEFAULT_SPEED_RUNNING_PREVENTION_BREEDS,
			speed_running_prevention_cooldown = {
				10,
				15
			},
			speed_running_prevention_failed_cooldown = {
				2,
				8
			}
		},
		{
			coordinated_surge_chance = 0.2,
			move_timer_when_terror_event_active = true,
			first_spawn_timer_modifer = 0.6,
			move_timer_when_challenge_rating_above_delay = 20,
			destroy_special_distance = 100,
			rushing_distance = 40,
			travel_distance_spawning = true,
			speed_running_required_challenge_rating = 8,
			num_required_speed_running_checks = 2,
			speed_running_required_distance = 10,
			move_timer_when_challenge_rating_above = 20,
			coordinated_strike_challenge_rating = 5,
			chance_for_coordinated_strike = 0.25,
			max_alive_specials = 8,
			max_spawn_group_offset_range = 6,
			speed_running_check_frequency = 5,
			move_timer_when_horde_active = true,
			move_timer_when_monster_active = true,
			spawn_failed_wait_time = 5,
			timer_range = {
				80,
				240
			},
			always_update_breeds = ALWAYS_UPDATE_AT_CHALLANGE_RATING_BREEDS,
			max_of_same = HIGH_MAX_OF_SAME,
			min_distances_from_target = DEFAULT_MIN_DISTANCES_FROM_TARGET,
			breeds = DEFAULT_BREEDS,
			disabler_target_alone_player_chance = DEFAULT_DISABLER_TARGET_ALONE_PLAYER_CHANCE,
			num_allowed_disablers_per_alive_targets = DEFAULT_NUM_ALLOWED_DISABLED_PER_ALIVE_TARGETS,
			disabler_override_duration = DEFAULT_DISABLER_OVERRIDE_DURATION,
			foreshadow_stingers = DEFAULT_FORESHADOW_STINGERS,
			foreshadow_stinger_timers = DEFAULT_FORESHADOW_STINGER_TIMERS,
			optional_prefered_spawn_direction = DEFAULT_OPTIONAL_PREFERED_SPAWN_DIRECTION,
			optional_mainpath_offset = DEFAULT_OPTIONAL_MAINPATH_OFFSET,
			spawn_stingers = DEFAULT_SPAWN_STINGERS,
			spawners_min_range = DEFAULT_MIN_SPAWNERS_RANGES.min,
			spawners_max_range = DEFAULT_MIN_SPAWNERS_RANGES.max,
			coordinated_strike_timer_range = {
				100,
				200
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
			coordinated_strike_num_breeds = {
				6,
				8
			},
			coordinated_surge_timer_range = {
				8,
				16
			},
			coordinated_surge_duration_range = {
				40,
				80
			},
			num_coordinated_surges_range = {
				3,
				6
			},
			loner_prevention_breeds = DEFAULT_LONER_PREVENTION_BREEDS,
			loner_prevention_cooldown = {
				20,
				40
			},
			loner_prevention_failed_cooldown = {
				3,
				7
			},
			loner_time = {
				6,
				10
			},
			rush_prevention_breeds = DEFAULT_RUSH_PREVENTION_BREEDS,
			rush_prevention_cooldown = {
				30,
				50
			},
			rush_prevention_failed_cooldown = {
				5,
				10
			},
			faction_bound_breeds = FACTION_BOUND_BREEDS,
			speed_running_prevention_breeds = DEFAULT_SPEED_RUNNING_PREVENTION_BREEDS,
			speed_running_prevention_cooldown = {
				10,
				15
			},
			speed_running_prevention_failed_cooldown = {
				2,
				8
			}
		}
	}
}

return specials_pacing_template
