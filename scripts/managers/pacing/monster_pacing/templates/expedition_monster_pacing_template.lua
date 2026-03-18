-- chunkname: @scripts/managers/pacing/monster_pacing/templates/expedition_monster_pacing_template.lua

local BossPatrols = require("scripts/managers/pacing/monster_pacing/boss_patrols")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local AggroStates = PerceptionSettings.aggro_states
local SPAWN_STINGERS = {
	cultist_captain = "wwise/events/minions/play_minion_captain_spawn_stinger",
	renegade_captain = "wwise/events/minions/play_minion_captain_spawn_stinger",
	renegade_twin_captain = "wwise/events/minions/play_minion_twins_ambush_spawn_impact_hit",
	renegade_twin_captain_two = "wwise/events/minions/play_minion_twins_ambush_spawn_impact_hit",
}
local MAX_ALLOWED_BY_HEAT = {
	{
		boss_patrols = 0,
		monsters = 1,
	},
	{
		boss_patrols = 0,
		monsters = 1,
	},
	{
		boss_patrols = 1,
		monsters = 1,
	},
	{
		boss_patrols = 1,
		monsters = 1,
	},
	{
		boss_patrols = 1,
		monsters = 1,
	},
}
local monster_pacing_template = {
	name = "expedition_monsters",
	challenge_templates = {
		{
			pacing_type = "timer_based",
			spawn_with_loot = true,
			max_allowed_by_heat = MAX_ALLOWED_BY_HEAT,
			monster_timer_range = {
				120,
				130,
			},
			num_spawns = {
				witches = 0,
				monsters = {
					0,
					1,
				},
			},
			breed_names = {
				monsters = {
					"chaos_beast_of_nurgle",
					"chaos_spawn",
					"chaos_ogryn_houndmaster",
					"chaos_ogryn_houndmaster",
					"chaos_ogryn_houndmaster",
				},
				witches = {
					"chaos_daemonhost",
				},
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed,
				chaos_beast_of_nurgle = AggroStates.passive,
				chaos_spawn = AggroStates.passive,
				chaos_ogryn_houndmaster = AggroStates.passive,
			},
			pause_pacing_on_spawn = {
				chaos_plague_ogryn = {
					hordes = 60,
					specials = 50,
					trickle_hordes = 40,
				},
				chaos_beast_of_nurgle = {
					hordes = 60,
					specials = 20,
					trickle_hordes = 40,
				},
				chaos_spawn = {
					hordes = 60,
					specials = 50,
					trickle_hordes = 40,
				},
			},
			despawn_distance_when_passive = {
				chaos_daemonhost = 65,
			},
			spawn_stingers = SPAWN_STINGERS,
		},
		{
			pacing_type = "timer_based",
			spawn_with_loot = true,
			max_allowed_by_heat = MAX_ALLOWED_BY_HEAT,
			monster_timer_range = {
				120,
				130,
			},
			num_spawns = {
				witches = 0,
				monsters = {
					0,
					1,
				},
			},
			breed_names = {
				monsters = {
					"chaos_beast_of_nurgle",
					"chaos_spawn",
					"chaos_ogryn_houndmaster",
					"chaos_ogryn_houndmaster",
					"chaos_ogryn_houndmaster",
				},
				witches = {
					"chaos_daemonhost",
				},
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed,
				chaos_beast_of_nurgle = AggroStates.passive,
				chaos_spawn = AggroStates.passive,
				chaos_ogryn_houndmaster = AggroStates.passive,
			},
			pause_pacing_on_spawn = {},
			despawn_distance_when_passive = {
				chaos_daemonhost = 65,
			},
			spawn_stingers = SPAWN_STINGERS,
		},
		{
			pacing_type = "timer_based",
			spawn_with_loot = true,
			max_allowed_by_heat = MAX_ALLOWED_BY_HEAT,
			monster_timer_range = {
				120,
				130,
			},
			num_spawns = {
				monsters = {
					0,
					2,
				},
				witches = {
					0,
					1,
				},
			},
			boss_patrols = {
				breed_lists = {
					renegade = BossPatrols.expedition_renegade_boss_patrols,
					cultist = BossPatrols.expedition_renegade_boss_patrols,
				},
				sound_events = {
					renegade = {
						start = "wwise/events/minions/play_minion_group_sfx_elite_patrole_traitor",
						stop = "wwise/events/minions/stop_minion_group_sfx_elite_patrole_traitor",
					},
					cultist = {
						start = "wwise/events/minions/play_minion_group_sfx_elite_patrole_cultist",
						stop = "wwise/events/minions/stop_minion_group_sfx_elite_patrole_cultist",
					},
				},
				num_boss_patrols_range = {
					1,
					2,
				},
			},
			breed_names = {
				monsters = {
					"chaos_beast_of_nurgle",
					"chaos_spawn",
					"chaos_ogryn_houndmaster",
					"chaos_ogryn_houndmaster",
					"chaos_ogryn_houndmaster",
				},
				witches = {
					"chaos_daemonhost",
				},
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed,
				chaos_beast_of_nurgle = AggroStates.passive,
				chaos_spawn = AggroStates.passive,
				chaos_ogryn_houndmaster = AggroStates.passive,
			},
			pause_pacing_on_spawn = {},
			despawn_distance_when_passive = {
				chaos_daemonhost = 65,
			},
			spawn_stingers = SPAWN_STINGERS,
		},
		{
			allow_witches_spawned_with_monsters = true,
			pacing_type = "timer_based",
			spawn_with_loot = true,
			max_allowed_by_heat = MAX_ALLOWED_BY_HEAT,
			monster_timer_range = {
				120,
				130,
			},
			num_spawns = {
				monsters = {
					1,
					2,
				},
				witches = {
					0,
					2,
				},
			},
			boss_patrols = {
				breed_lists = {
					renegade = BossPatrols.expedition_renegade_boss_patrols,
					cultist = BossPatrols.expedition_renegade_boss_patrols,
				},
				sound_events = {
					renegade = {
						start = "wwise/events/minions/play_minion_group_sfx_elite_patrole_traitor",
						stop = "wwise/events/minions/stop_minion_group_sfx_elite_patrole_traitor",
					},
					cultist = {
						start = "wwise/events/minions/play_minion_group_sfx_elite_patrole_cultist",
						stop = "wwise/events/minions/stop_minion_group_sfx_elite_patrole_cultist",
					},
				},
				num_boss_patrols_range = {
					1,
					2,
				},
			},
			breed_names = {
				monsters = {
					"chaos_beast_of_nurgle",
					"chaos_spawn",
					"chaos_ogryn_houndmaster",
					"chaos_ogryn_houndmaster",
					"chaos_ogryn_houndmaster",
				},
				witches = {
					"chaos_daemonhost",
				},
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed,
				chaos_beast_of_nurgle = AggroStates.passive,
				chaos_spawn = AggroStates.passive,
				chaos_ogryn_houndmaster = AggroStates.passive,
			},
			pause_pacing_on_spawn = {},
			despawn_distance_when_passive = {
				chaos_daemonhost = 65,
			},
			spawn_stingers = SPAWN_STINGERS,
		},
		{
			allow_witches_spawned_with_monsters = true,
			pacing_type = "timer_based",
			spawn_with_loot = true,
			max_allowed_by_heat = MAX_ALLOWED_BY_HEAT,
			monster_timer_range = {
				120,
				130,
			},
			boss_patrols = {
				breed_lists = {
					renegade = BossPatrols.expedition_renegade_boss_patrols,
					cultist = BossPatrols.expedition_renegade_boss_patrols,
				},
				sound_events = {
					renegade = {
						start = "wwise/events/minions/play_minion_group_sfx_elite_patrole_traitor",
						stop = "wwise/events/minions/stop_minion_group_sfx_elite_patrole_traitor",
					},
					cultist = {
						start = "wwise/events/minions/play_minion_group_sfx_elite_patrole_cultist",
						stop = "wwise/events/minions/stop_minion_group_sfx_elite_patrole_cultist",
					},
				},
				num_boss_patrols_range = {
					1,
					3,
				},
			},
			breed_names = {
				monsters = {
					"chaos_beast_of_nurgle",
					"chaos_spawn",
					"chaos_ogryn_houndmaster",
					"chaos_ogryn_houndmaster",
					"chaos_ogryn_houndmaster",
				},
				witches = {
					"chaos_daemonhost",
				},
			},
			aggro_states = {
				chaos_plague_ogryn = AggroStates.aggroed,
				chaos_beast_of_nurgle = AggroStates.passive,
				chaos_spawn = AggroStates.passive,
				chaos_ogryn_houndmaster = AggroStates.passive,
			},
			pause_pacing_on_spawn = {},
			despawn_distance_when_passive = {
				chaos_daemonhost = 65,
			},
			spawn_stingers = SPAWN_STINGERS,
		},
	},
}

return monster_pacing_template
