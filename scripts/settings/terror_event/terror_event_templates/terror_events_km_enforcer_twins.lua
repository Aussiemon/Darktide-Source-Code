-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_km_enforcer_twins.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {},
	events = {
		event_pacing_off = {
			{
				"delay",
				duration = 5,
			},
		},
		event_twins_dead = {
			{
				"set_pacing_enabled",
				enabled = false,
			},
			{
				"stop_terror_trickle",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_gas_phase_west",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_gas_phase_north",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_gas_phase_east",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_gas_phase_middle",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_gas_phase_2_west",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_gas_phase_2_north",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_gas_phase_2_east",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_gas_phase_2_middle",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_gas_phase_3_west",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_gas_phase_3_north",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_gas_phase_3_east",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_gas_phase_3_middle",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_elite_trickle_1",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_elite_trickle_2",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_elite_trickle_3",
			},
			{
				"stop_terror_event",
				stop_event_name = "km_enforcer_twins_last_phase_trickle",
			},
		},
		event_pacing_on = {
			{
				"set_pacing_enabled",
				enabled = true,
			},
		},
		no_special_19s = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"specials",
				},
			},
			{
				"delay",
				duration = 19,
			},
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"specials",
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
		event_only_specials_disabled = {
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
					"monsters",
				},
			},
		},
		event_pacing_on_stop_trickle = {
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
					"monsters",
				},
			},
			{
				"stop_terror_trickle",
			},
		},
		event_pacing_on_no_hordes = {
			{
				"set_pacing_enabled",
				enabled = true,
			},
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"roamers",
					"monsters",
					"specials",
				},
			},
			{
				"stop_terror_trickle",
			},
		},
		event_pacing_enable_hordes = {
			{
				"set_pacing_enabled",
				enabled = true,
			},
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
					"trickle_hordes",
				},
			},
		},
		event_not_even_specials_on = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
					"monsters",
					"specials",
				},
			},
		},
		event_not_even_specials_off = {
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
					"monsters",
					"specials",
				},
			},
		},
		km_enforcer_twins_gas_tutorial = {
			{
				"delay",
				duration = 4.5,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 15,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "gas_tutorial_horde",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_netgunner",
				limit_spawners = 3,
				spawner_group = "gas_tutorial",
			},
			{
				"flow_event",
				flow_event_name = "gas_extra_enemies",
			},
			{
				"delay",
				duration = 10,
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 5
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_netgunner",
				limit_spawners = 3,
				spawner_group = "gas_tutorial",
			},
			{
				"flow_event",
				flow_event_name = "enforcer_gas_extra_enemies",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 15,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "gas_tutorial_horde",
			},
		},
		km_enforcer_twins_gas_extra_enemies_3 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_executor",
				limit_spawners = 1,
				spawner_group = "gas_tutorial_horde",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_netgunner",
				limit_spawners = 3,
				spawner_group = "gas_tutorial",
			},
		},
		km_enforcer_twins_gas_extra_enemies_4 = {
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_executor",
				limit_spawners = 2,
				spawner_group = "gas_tutorial_horde",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_netgunner",
				limit_spawners = 3,
				spawner_group = "gas_tutorial",
			},
		},
		km_enforcer_twins_gas_extra_enemies_5 = {
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_executor",
				limit_spawners = 2,
				spawner_group = "gas_tutorial_horde",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_netgunner",
				limit_spawners = 3,
				spawner_group = "gas_tutorial",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_berzerker",
				limit_spawners = 1,
				spawner_group = "gas_tutorial_horde",
			},
		},
		km_enforcer_twins_gas_tutorial_door_man = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_ogryn_executor",
				limit_spawners = 1,
				spawner_group = "gas_tutorial_door_man",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "enforcer_gas_tutorial_completed",
			},
		},
		km_enforcer_twins_gas_tutorial_door_man_3 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_executor",
				limit_spawners = 1,
				spawner_group = "gas_tutorial_door_man_behind_1",
			},
			{
				"delay",
				duration = 5,
			},
		},
		km_enforcer_twins_gas_tutorial_door_man_4 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_ogryn_executor",
				limit_spawners = 1,
				spawner_group = "gas_tutorial_door_man_behind_1",
			},
			{
				"delay",
				duration = 5,
			},
		},
		km_enforcer_twins_gas_tutorial_door_man_5 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_ogryn_executor",
				limit_spawners = 1,
				spawner_group = "gas_tutorial_door_man_behind_1",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_ogryn_executor",
				limit_spawners = 1,
				spawner_group = "gas_tutorial_door_man_behind_2",
			},
			{
				"delay",
				duration = 5,
			},
		},
		km_enforcer_kill_target = {
			{
				"delay",
				duration = 1.2,
			},
			{
				"start_twin_fight",
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_enforcer_station_north",
				template_name = "low_twin_melee",
			},
		},
		activate_hard_mode = {
			{
				"delay",
				duration = 1,
			},
			{
				"activate_hard_mode",
			},
		},
		hard_mode_terror_trickle = {
			{
				"delay",
				duration = 1,
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_enforcer_station_east",
				template_name = "hard_mode_twins_elites",
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_enforcer_station_west",
				template_name = "hard_mode_twins_elites",
			},
		},
		km_enforcer_twins_gas_phase_west = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_west",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_west",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_west",
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
		},
		km_enforcer_twins_gas_phase_north = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_north",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_north",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_north",
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
		},
		km_enforcer_twins_gas_phase_east = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_east",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_east",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_east",
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
		},
		km_enforcer_twins_gas_phase_middle = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_middle",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_middle",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_middle",
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
		},
		km_enforcer_twins_gas_phase_2_west = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_west",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_west",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_west",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_enforcer_station_west",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
		},
		km_enforcer_twins_gas_phase_2_north = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_north",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_north",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_north",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_enforcer_station_north",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
		},
		km_enforcer_twins_gas_phase_2_east = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_east",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_east",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_east",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_enforcer_station_east",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
		},
		km_enforcer_twins_gas_phase_2_middle = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_middle",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_middle",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_middle",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_enforcer_station_east",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
		},
		km_enforcer_twins_gas_phase_3_west = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_west",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_west",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_west",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_enforcer_station_west",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_west",
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
		},
		km_enforcer_twins_gas_phase_3_north = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_north",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_north",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_north",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_enforcer_station_north",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_north",
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
		},
		km_enforcer_twins_gas_phase_3_east = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_east",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_east",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_east",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_enforcer_station_east",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_east",
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
		},
		km_enforcer_twins_gas_phase_3_middle = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_middle",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_middle",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_middle",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_enforcer_station_east",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_poxwalker",
				limit_spawners = 5,
				spawner_group = "spawner_enforcer_station_middle",
			},
			{
				"delay",
				duration = 20,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
		},
		km_enforcer_twins_elite_trickle_1 = {
			{
				"delay",
				duration = 10,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 16,
				spawner_group = "spawner_enforcer_station_east",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
		},
		km_enforcer_twins_elite_trickle_2 = {
			{
				"delay",
				duration = 10,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 16,
				spawner_group = "spawner_enforcer_station_west",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
		},
		km_enforcer_twins_elite_trickle_3 = {
			{
				"delay",
				duration = 10,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 16,
				spawner_group = "spawner_enforcer_station_north",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
		},
		km_enforcer_twins_last_phase_trickle = {
			{
				"delay",
				duration = 10,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				points = 12,
				spawner_group = "spawner_enforcer_station_east",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_points",
				points = 12,
				spawner_group = "spawner_enforcer_station_west",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_points",
				points = 12,
				spawner_group = "spawner_enforcer_station_north",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
		},
	},
}

return template
