-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_fm_cargo.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		fm_cargo_hacking_wave_1 = {
			"event_hacking_cargo_a",
			1,
			"event_hacking_cargo_c",
			1,
		},
		fm_cargo_hacking_wave_2 = {
			"event_hacking_cargo_b",
			1,
			"event_hacking_cargo_d",
			1,
		},
		fm_cargo_fortification_wave_1 = {
			"event_fortification_a",
			1,
			"event_fortification_b",
			1,
			"event_fortification_c",
			1,
			"event_fortification_d",
			1,
		},
		fm_cargo_fortification_monsters = {
			"event_fortification_spawn_cs",
			1,
			"event_fortification_spawn_po",
			1,
		},
	},
	events = {
		event_pacing_off = {
			{
				"set_pacing_enabled",
				enabled = false,
			},
		},
		event_pacing_on = {
			{
				"set_pacing_enabled",
				enabled = true,
			},
		},
		event_hordes_off = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
				},
			},
		},
		event_only_roamers_specials_enabled = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"trickle_hordes",
				},
			},
		},
		event_only_specials_enabled = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
				},
			},
		},
		event_pacing_on_stop_trickle = {
			{
				"stop_terror_trickle",
			},
			{
				"set_pacing_enabled",
				enabled = true,
			},
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
					"specials",
					"monsters",
				},
			},
		},
		event_set_specials_pacing_spawner_groups = {
			{
				"set_specials_pacing_spawner_groups",
				spawner_groups = {
					"spawner_fortification_cargo_south_a",
					"spawner_fortification_cargo_south_b",
					"spawner_fortification_cargo_north_a",
					"spawner_fortification_cargo_north_b",
				},
			},
		},
		event_reset_specials_pacing_spawner_groups = {
			{
				"reset_specials_pacing_spawner_groups",
			},
		},
		event_stop_trickle = {
			{
				"stop_terror_trickle",
			},
		},
		event_hacking_cargo_a = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
				end,
			},
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_a",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_hacking_cargo_a",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"delay",
				duration = 8,
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_hacking_cargo_a",
				template_name = "standard_melee",
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_hacking_cargo_special_1",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 8
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 25,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_b",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 10,
			},
		},
		event_hacking_cargo_b = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
				end,
			},
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 25,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_b",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 8,
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_hacking_cargo_b",
				template_name = "standard_melee",
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 6,
				spawner_group = "spawner_hacking_cargo_special_3",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 8
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_d",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 10,
			},
		},
		event_hacking_cargo_c = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
				end,
			},
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_c",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				spawner_group = "spawner_hacking_cargo_c",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 8,
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_hacking_cargo_c",
				template_name = "standard_melee",
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 6,
				spawner_group = "spawner_hacking_cargo_special_1",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 8
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_c",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
		},
		event_hacking_cargo_d = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
				end,
			},
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_a",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				spawner_group = "spawner_hacking_cargo_a",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 8,
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_hacking_cargo_d",
				template_name = "standard_melee",
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_hacking_cargo_special_2",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 8
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				spawner_group = "spawner_hacking_cargo_d",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
		},
		event_hacking_transit_guard = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				max_breed_amount = 3,
				passive = true,
				points = 15,
				spawner_group = "spawner_station_hacking_elite",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 12,
				max_breed_amount = 9,
				passive = true,
				points = 12,
				spawner_group = "spawner_station_hacking_guard",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
		},
		event_fortification_guard_a = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				max_breed_amount = 3,
				passive = true,
				points = 22,
				spawner_group = "spawner_fortification_guard_elite_a",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
		},
		event_fortification_guard_b = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				max_breed_amount = 3,
				passive = true,
				points = 22,
				spawner_group = "spawner_fortification_guard_elite_b",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
		},
		event_fortification_guard_c = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				max_breed_amount = 3,
				passive = true,
				points = 22,
				spawner_group = "spawner_fortification_guard_elite_c",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
		},
		event_fortification_guard_d = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				max_breed_amount = 3,
				passive = true,
				points = 22,
				spawner_group = "spawner_fortification_guard_elite_d",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
		},
		event_fortification_horde_a = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 30,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_horde_a",
				breed_tags = {
					{
						"horde",
					},
				},
			},
		},
		event_fortification_horde_b = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 30,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_horde_b",
				breed_tags = {
					{
						"horde",
					},
				},
			},
		},
		event_fortification_horde_c = {
			{
				"spawn_by_points",
				points = 30,
				spawner_group = "spawner_fortification_horde_a",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 300,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 2
				end,
			},
		},
		event_fortification_elite_a = {
			{
				"spawn_by_points",
				limit_spawners = 4,
				points = 16,
				proximity_spawners = true,
				spawner_group = "spawner_fortification_cargo_hatches",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 10,
			},
			{
				"spawn_by_points",
				points = 10,
				spawner_group = "spawner_fortification_elite_a",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 15,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end,
			},
			{
				"delay",
				duration = 10,
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_final_wave",
			},
		},
		event_fortification_spawn_cs = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_fortification_monster_cs",
			},
			{
				"play_3d_sound_from_spawners",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm_monster_01",
				spawner_group = "spawner_fortification_monster_cs",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_spawned_cs",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_monster_dead",
			},
		},
		event_fortification_spawn_po = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_fortification_monster_po",
			},
			{
				"play_3d_sound_from_spawners",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm_monster_01",
				spawner_group = "spawner_fortification_monster_cs",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_spawned_po",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_monster_dead",
			},
		},
		event_fortification_a = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_cargo_south_a",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				spawner_group = "spawner_fortification_cargo_south_a",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 4,
				points = 15,
				proximity_spawners = true,
				spawner_group = "spawner_fortification_cargo_hatches",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_fortification_cargo_special_1",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 4,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 8,
				spawner_group = "spawner_fortification_cargo_sniper_1",
				breed_tags = {
					{
						"special",
						"sniper",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_fortification_cargo_south_a",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 6
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_wave_dead",
			},
		},
		event_fortification_b = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_cargo_north_a",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				spawner_group = "spawner_fortification_cargo_north_b",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_fortification_cargo_special_2",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				limit_spawners = 4,
				points = 15,
				proximity_spawners = true,
				spawner_group = "spawner_fortification_cargo_hatches",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 8,
				spawner_group = "spawner_fortification_cargo_sniper_2",
				breed_tags = {
					{
						"special",
						"sniper",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_fortification_cargo_north_c",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 6
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_wave_dead",
			},
		},
		event_fortification_c = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_cargo_north_a",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				spawner_group = "spawner_fortification_cargo_north_b",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_fortification_cargo_special_2",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				limit_spawners = 4,
				points = 15,
				proximity_spawners = true,
				spawner_group = "spawner_fortification_cargo_hatches",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 8,
				spawner_group = "spawner_fortification_cargo_sniper_2",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_fortification_cargo_north_a",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 6
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_wave_dead",
			},
		},
		event_fortification_d = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 30,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_horde_b",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_fortification_cargo_special_1",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				limit_spawners = 4,
				points = 15,
				proximity_spawners = true,
				spawner_group = "spawner_fortification_cargo_hatches",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 8,
				spawner_group = "spawner_fortification_cargo_special_1",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_fortification_cargo_south_a",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 6
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_wave_dead",
			},
		},
		event_fortification_final_timer = {
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 7
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_spawn_final",
			},
		},
	},
}

return template
