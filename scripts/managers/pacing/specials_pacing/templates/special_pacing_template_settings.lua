-- chunkname: @scripts/managers/pacing/specials_pacing/templates/special_pacing_template_settings.lua

local special_pacing_template_settings = {}

special_pacing_template_settings.interrupter_patrols = INTERRUPTER_PATROLS
special_pacing_template_settings.default_foreshadow_stingers = {
	chaos_hound = "wwise/events/minions/play_enemy_chaos_hound_spawn",
	renegade_netgunner = "wwise/events/minions/play_minion_special_netgunner_spawn",
}
special_pacing_template_settings.default_foreshadow_stinger_timers = {
	chaos_hound = 5,
	cultist_mutant = 5,
	renegade_netgunner = 4,
}
special_pacing_template_settings.default_spawn_stingers = {
	chaos_poxwalker_bomber = "wwise/events/minions/play_minion_special_poxwalker_bomber_spawn",
	cultist_mutant = "wwise/events/minions/play_minion_special_mutant_charger_spawn",
}
special_pacing_template_settings.default_optional_prefered_spawn_direction = {
	cultist_grenadier = "ahead",
	renegade_grenadier = "ahead",
	renegade_sniper = "ahead",
}
special_pacing_template_settings.default_optional_mainpath_offset = {
	cultist_grenadier = 30,
	renegade_grenadier = 30,
	renegade_sniper = 40,
}
special_pacing_template_settings.default_breeds = {
	all = {
		"chaos_hound",
		"chaos_poxwalker_bomber",
		"cultist_mutant",
		"grenadier",
		"renegade_netgunner",
		"renegade_sniper",
		"flamer",
	},
	disablers = {
		"chaos_hound",
		"renegade_netgunner",
		"cultist_mutant",
	},
	scramblers = {
		"chaos_poxwalker_bomber",
		"grenadier",
		"renegade_sniper",
		"flamer",
	},
}
special_pacing_template_settings.default_coordinated_strike_breeds = {
	"chaos_hound",
	"chaos_poxwalker_bomber",
	"cultist_mutant",
	"renegade_netgunner",
	"flamer",
}
special_pacing_template_settings.default_rush_prevention_breeds = {
	"chaos_hound",
	"cultist_mutant",
}
special_pacing_template_settings.default_loner_prevention_breeds = {
	"chaos_hound",
	"cultist_mutant",
	"renegade_netgunner",
}
special_pacing_template_settings.default_speed_running_prevention_breeds = {
	"chaos_hound",
	"cultist_mutant",
	"renegade_netgunner",
}
special_pacing_template_settings.faction_bound_breeds = {
	flamer = {
		cultist = "cultist_flamer",
		renegade = "renegade_flamer",
	},
	grenadier = {
		cultist = "cultist_grenadier",
		renegade = "renegade_grenadier",
	},
}
special_pacing_template_settings.default = {
	default_min_distances_from_target = {
		chaos_beast_of_nurgle = 30,
		chaos_hound = 25,
		chaos_plague_ogryn = 30,
		chaos_poxwalker_bomber = 35,
		chaos_spawn = 30,
		cultist_flamer = 20,
		cultist_grenadier = 20,
		cultist_mutant = 25,
		renegade_flamer = 15,
		renegade_grenadier = 20,
		renegade_netgunner = 28,
		renegade_sniper = 30,
	},
	default_min_spawners_ranges = {
		max = 49,
		min = 20,
	},
	default_num_allowed_disabled_per_alive_targets = {
		{
			0,
			0,
			1,
			1,
		},
		{
			0,
			1,
			1,
			2,
		},
		{
			0,
			1,
			2,
			3,
		},
		{
			1,
			2,
			3,
			3,
		},
		{
			1,
			2,
			3,
			4,
		},
	},
	default_disabler_override_duration = {
		360,
		240,
		160,
		100,
		80,
	},
	default_disabler_target_alone_player_chance = {
		chaos_hound = 0.75,
		cultist_mutant = 0.25,
		renegade_netgunner = 0.5,
	},
	low_max_of_same = {
		chaos_beast_of_nurgle = 1,
		chaos_hound = 1,
		chaos_plague_ogryn = 2,
		chaos_poxwalker_bomber = 1,
		chaos_spawn = 2,
		cultist_flamer = 2,
		cultist_grenadier = 1,
		cultist_mutant = 1,
		flamer = 2,
		grenadier = 2,
		renegade_flamer = 2,
		renegade_grenadier = 2,
		renegade_netgunner = 1,
		renegade_sniper = 2,
	},
	default_max_of_same = {
		chaos_beast_of_nurgle = 1,
		chaos_hound = 2,
		chaos_plague_ogryn = 2,
		chaos_poxwalker_bomber = 2,
		chaos_spawn = 2,
		cultist_flamer = 2,
		cultist_grenadier = 1,
		cultist_mutant = 3,
		flamer = 2,
		grenadier = 2,
		renegade_flamer = 2,
		renegade_grenadier = 2,
		renegade_netgunner = 2,
		renegade_sniper = 2,
	},
	high_max_of_same = {
		chaos_beast_of_nurgle = 1,
		chaos_hound = 2,
		chaos_plague_ogryn = 2,
		chaos_poxwalker_bomber = 3,
		chaos_spawn = 2,
		cultist_flamer = 2,
		cultist_grenadier = 2,
		cultist_mutant = 4,
		flamer = 2,
		grenadier = 3,
		renegade_flamer = 2,
		renegade_grenadier = 2,
		renegade_netgunner = 2,
		renegade_sniper = 3,
	},
	always_update_at_challange_rating_breeds = {
		cultist_grenadier = 2,
		cultist_mutant = 5,
		renegade_grenadier = 2,
		renegade_sniper = 0,
	},
}
special_pacing_template_settings.havoc = {
	default_min_distances_from_target = {
		chaos_beast_of_nurgle = 30,
		chaos_hound = 25,
		chaos_plague_ogryn = 30,
		chaos_poxwalker_bomber = 35,
		chaos_spawn = 30,
		cultist_flamer = 20,
		cultist_grenadier = 20,
		cultist_mutant = 25,
		renegade_flamer = 15,
		renegade_grenadier = 20,
		renegade_netgunner = 28,
		renegade_sniper = 30,
	},
	default_min_spawners_ranges = {
		max = 49,
		min = 20,
	},
	default_num_allowed_disabled_per_alive_targets = {
		{
			0,
			0,
			1,
			1,
		},
		{
			0,
			1,
			1,
			2,
		},
		{
			2,
			2,
			3,
			3,
		},
		{
			3,
			3,
			3,
			3,
		},
		{
			4,
			4,
			4,
			4,
		},
	},
	default_disabler_override_duration = {
		360,
		240,
		160,
		100,
		80,
	},
	default_disabler_target_alone_player_chance = {
		chaos_hound = 0.75,
		cultist_mutant = 0.25,
		renegade_netgunner = 0.5,
	},
	low_max_of_same = {
		chaos_beast_of_nurgle = 1,
		chaos_hound = 1,
		chaos_plague_ogryn = 2,
		chaos_poxwalker_bomber = 1,
		chaos_spawn = 2,
		cultist_flamer = 2,
		cultist_grenadier = 1,
		cultist_mutant = 1,
		flamer = 2,
		grenadier = 2,
		renegade_flamer = 2,
		renegade_grenadier = 2,
		renegade_netgunner = 1,
		renegade_sniper = 2,
	},
	default_max_of_same = {
		chaos_beast_of_nurgle = 1,
		chaos_hound = 2,
		chaos_plague_ogryn = 2,
		chaos_poxwalker_bomber = 2,
		chaos_spawn = 2,
		cultist_flamer = 2,
		cultist_grenadier = 1,
		cultist_mutant = 3,
		flamer = 2,
		grenadier = 2,
		renegade_flamer = 2,
		renegade_grenadier = 2,
		renegade_netgunner = 2,
		renegade_sniper = 2,
	},
	high_max_of_same = {
		chaos_beast_of_nurgle = 1,
		chaos_hound = 2,
		chaos_plague_ogryn = 2,
		chaos_poxwalker_bomber = 3,
		chaos_spawn = 2,
		cultist_flamer = 2,
		cultist_grenadier = 2,
		cultist_mutant = 4,
		flamer = 2,
		grenadier = 3,
		renegade_flamer = 2,
		renegade_grenadier = 2,
		renegade_netgunner = 2,
		renegade_sniper = 3,
	},
	always_update_at_challange_rating_breeds = {
		cultist_grenadier = 2,
		cultist_mutant = 5,
		renegade_grenadier = 2,
		renegade_sniper = 0,
	},
}

return settings("SpecialPacingTemplateSettings", special_pacing_template_settings)
