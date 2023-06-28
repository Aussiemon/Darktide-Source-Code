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
local DEFAULT_SPEED_RUNNING_PREVENTION_BREEDS = {
	"chaos_hound",
	"cultist_mutant",
	"renegade_netgunner"
}
local DEFAULT_MAX_OF_SAME = {
	chaos_poxwalker_bomber = 2,
	renegade_sniper = 2,
	renegade_grenadier = 3,
	renegade_flamer = 2,
	renegade_netgunner = 2,
	chaos_plague_ogryn = 2,
	chaos_spawn = 2,
	cultist_grenadier = 3,
	cultist_mutant = 3,
	chaos_hound = 2,
	chaos_beast_of_nurgle = 1,
	cultist_flamer = 2
}
local HIGH_MAX_OF_SAME = {
	chaos_poxwalker_bomber = 3,
	renegade_sniper = 3,
	renegade_grenadier = 3,
	renegade_flamer = 2,
	renegade_netgunner = 2,
	chaos_plague_ogryn = 2,
	chaos_spawn = 2,
	cultist_grenadier = 3,
	cultist_mutant = 4,
	chaos_hound = 2,
	chaos_beast_of_nurgle = 1,
	cultist_flamer = 2
}
local FACTION_BOUND_BREEDS = {
	flamer = {
		cultist = "cultist_flamer",
		renegade = "renegade_flamer"
	},
	grenadier = {
		cultist = "renegade_grenadier",
		renegade = "renegade_grenadier"
	}
}
local DEFAULT_MIN_DISTANCES_FROM_TARGET = {
	chaos_poxwalker_bomber = 35,
	cultist_flamer = 20,
	renegade_grenadier = 20,
	renegade_flamer = 15,
	renegade_netgunner = 20,
	chaos_plague_ogryn = 30,
	chaos_spawn = 30,
	cultist_grenadier = 20,
	cultist_mutant = 25,
	chaos_hound = 25,
	chaos_beast_of_nurgle = 30,
	renegade_sniper = 30
}
local DEFAULT_MIN_SPAWNERS_RANGES = {
	max = 40,
	min = 12
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
		2,
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
		2,
		3,
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
local specials_pacing_template = {
	name = "renegade_specials",
	resistance_templates = {
		{
			max_spawn_group_offset_range = 6,
			destroy_special_distance = 100,
			first_spawn_timer_modifer = 0.6,
			chance_for_coordinated_strike = 0.1,
			max_alive_specials = 3,
			rushing_distance = 80,
			coordinated_strike_num_breeds = 2,
			spawn_failed_wait_time = 5,
			timer_range = {
				140,
				300
			},
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
				120,
				160
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
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
			max_spawn_group_offset_range = 6,
			first_spawn_timer_modifer = 0.5,
			speed_running_required_challenge_rating = 50,
			rushing_distance = 60,
			coordinated_strike_num_breeds = 3,
			num_required_speed_running_checks = 4,
			chance_for_coordinated_strike = 0.1,
			speed_running_required_distance = 12,
			max_alive_specials = 3,
			speed_running_check_frequency = 5,
			spawn_failed_wait_time = 5,
			timer_range = {
				120,
				280
			},
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
				120
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
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
			max_spawn_group_offset_range = 6,
			first_spawn_timer_modifer = 0.5,
			speed_running_required_challenge_rating = 50,
			rushing_distance = 50,
			coordinated_strike_num_breeds = 4,
			num_required_speed_running_checks = 4,
			chance_for_coordinated_strike = 0.125,
			speed_running_required_distance = 12,
			max_alive_specials = 4,
			speed_running_check_frequency = 5,
			spawn_failed_wait_time = 5,
			timer_range = {
				110,
				250
			},
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
				80,
				100
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
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
			destroy_special_distance = 100,
			max_spawn_group_offset_range = 6,
			first_spawn_timer_modifer = 0.4,
			speed_running_required_challenge_rating = 40,
			rushing_distance = 45,
			coordinated_strike_num_breeds = 5,
			num_required_speed_running_checks = 4,
			chance_for_coordinated_strike = 0.15,
			speed_running_required_distance = 10,
			max_alive_specials = 5,
			speed_running_check_frequency = 5,
			spawn_failed_wait_time = 5,
			timer_range = {
				90,
				230
			},
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
				80,
				160
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
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
				20
			},
			speed_running_prevention_failed_cooldown = {
				5,
				10
			}
		},
		{
			destroy_special_distance = 100,
			max_spawn_group_offset_range = 6,
			first_spawn_timer_modifer = 0.4,
			speed_running_required_challenge_rating = 40,
			rushing_distance = 40,
			coordinated_strike_num_breeds = 6,
			num_required_speed_running_checks = 4,
			chance_for_coordinated_strike = 0.15,
			speed_running_required_distance = 12,
			max_alive_specials = 6,
			speed_running_check_frequency = 5,
			spawn_failed_wait_time = 5,
			timer_range = {
				70,
				200
			},
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
				70,
				140
			},
			coordinated_strike_breeds = DEFAULT_COORDINATED_STRIKE_BREEDS,
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
				5,
				10
			}
		}
	}
}

return specials_pacing_template
