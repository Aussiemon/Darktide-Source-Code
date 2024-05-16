-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_dm_propaganda.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		dm_propaganda_wave_1 = {
			"event_dunes_trickle_a",
			1,
			"event_dunes_trickle_b",
			1,
			"event_dunes_trickle_c",
			1,
			"event_dunes_trickle_d",
			1,
		},
		dm_propaganda_demo_wave_1 = {
			"event_demo_a",
			1,
			"event_demo_b",
			1,
			"event_demo_c",
			1,
		},
		event_dunes_start = {
			"event_dunes_a",
			1,
		},
		event_dunes_wave_1 = {
			"event_dunes_a",
			1,
			"event_dunes_b",
			1,
			"event_dunes_c",
			1,
		},
		event_dunes_wave_2 = {
			"event_dunes_d",
			1,
			"event_dunes_e",
			1,
			"event_dunes_f",
			1,
		},
		dm_propaganda_demo_wave_2 = {
			"event_demo_d",
			1,
			"event_demo_e",
			1,
			"event_demo_f",
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
		event_hordes_on = {
			{
				"control_pacing_spawns",
				enabled = true,
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
		event_stop_trickle = {
			{
				"stop_terror_trickle",
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
		event_dunes_trickle_a = {
			{
				"debug_print",
				duration = 3,
				text = "event_dunes_trickle_a",
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_event_dunes_trickle_a",
				template_name = "standard_melee",
			},
		},
		event_dunes_trickle_b = {
			{
				"debug_print",
				duration = 3,
				text = "event_dunes_trickle_b",
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_event_dunes_trickle_b",
				template_name = "standard_melee",
			},
		},
		event_dunes_trickle_c = {
			{
				"debug_print",
				duration = 3,
				text = "event_dunes_trickle_c",
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_event_dunes_trickle_c",
				template_name = "standard_melee",
			},
		},
		event_dunes_trickle_d = {
			{
				"debug_print",
				duration = 3,
				text = "event_dunes_trickle_d",
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_event_dunes_trickle_d",
				template_name = "standard_melee",
			},
		},
		event_dunes_a = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 10
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_dunes_west",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_dunes_north",
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
					return TerrorEventQueries.num_aggroed_minions_in_level() < 7
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 7,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_dunes_south",
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
				limit_spawners = 3,
				points = 7,
				spawner_group = "spawner_dunes_south",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_dunes_trickle",
				template_name = "standard_melee",
			},
		},
		event_dunes_b = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 10
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_dunes_north",
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
				spawner_group = "spawner_dunes_north",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 7
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_dunes_north",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_dunes_north",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_dunes_trickle",
				template_name = "standard_melee",
			},
		},
		event_dunes_c = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 10
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_dunes_east",
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
				spawner_group = "spawner_dunes_east",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 7
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 20,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_dunes_west",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_dunes_west",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_dunes_trickle",
				template_name = "standard_melee",
			},
		},
		event_dunes_d = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 10
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_dunes_south",
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
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_dunes_south",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_dunes_south",
				breed_tags = {
					{
						"melee",
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
				points = 12,
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
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_dunes_north",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_dunes_trickle",
				template_name = "standard_melee",
			},
		},
		event_dunes_e = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 10
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_dunes_south",
				breed_tags = {
					{
						"melee",
						"horde",
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
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 7
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_dunes_east",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_dunes_trickle",
				template_name = "standard_melee",
			},
		},
		event_dunes_f = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 10
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_dunes_south",
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
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_dunes_south",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 8,
				spawner_group = "spawner_dunes_east",
				breed_tags = {
					{
						"special",
						"sniper",
					},
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 7
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_dunes_west",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 8,
				spawner_group = "spawner_dunes_west",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_dunes_trickle",
				template_name = "standard_melee",
			},
		},
		event_demo_a = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 5,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_demo_floor_2",
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
				points = 5,
				spawner_group = "spawner_demo_floor_2",
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
				points = 5,
				spawner_group = "spawner_demo_floor_2",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_demo_floor_2",
				template_name = "standard_melee",
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 20,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_demo_floor_2",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"delay",
				duration = 6,
			},
			{
				"flow_event",
				flow_event_name = "event_demo_a_completed",
			},
		},
		event_demo_b = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 20,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_demo_floor_2",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_demo_floor_2",
				template_name = "standard_melee",
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 16,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_demo_floor_2",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"delay",
				duration = 6,
			},
			{
				"flow_event",
				flow_event_name = "event_demo_c_completed",
			},
		},
		event_demo_c = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 20,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_demo_floor_2",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 3,
				spawner_group = "spawner_demo_floor_2",
				template_name = "standard_melee",
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 12,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_demo_floor_2",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 8,
				proximity_spawners = true,
				spawner_group = "spawner_demo_floor_2",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"delay",
				duration = 6,
			},
			{
				"flow_event",
				flow_event_name = "event_demo_c_completed",
			},
		},
		event_demo_mid_horde = {
			{
				"start_terror_trickle",
				limit_spawners = 5,
				proximity_spawners = true,
				spawner_group = "spawner_demo_floor_3",
				template_name = "flood_melee",
			},
			{
				"delay",
				duration = 3,
			},
		},
		event_demo_d = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 5,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_demo_floor_3",
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
				points = 5,
				spawner_group = "spawner_demo_floor_3",
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
				points = 5,
				spawner_group = "spawner_demo_floor_3",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_demo_floor_3",
				template_name = "standard_melee",
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 12,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_demo_floor_3",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 8,
				proximity_spawners = true,
				spawner_group = "spawner_demo_floor_3",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"delay",
				duration = 6,
			},
			{
				"flow_event",
				flow_event_name = "event_demo_c_completed",
			},
		},
		event_demo_e = {
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_demo_floor_3",
				template_name = "standard_melee",
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 16,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_demo_floor_3",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"delay",
				duration = 6,
			},
			{
				"flow_event",
				flow_event_name = "event_demo_e_completed",
			},
		},
		event_demo_f = {
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_demo_floor_3",
				template_name = "standard_melee",
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 20,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_demo_floor_3",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"delay",
				duration = 6,
			},
			{
				"flow_event",
				flow_event_name = "event_demo_f_completed",
			},
		},
		event_demo_final = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_demo_north",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_demo_north",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_demo_floor_4",
				template_name = "medium_melee",
			},
			{
				"delay",
				duration = 8,
			},
		},
		event_demo_final_continued = {
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_demo_floor_4",
				template_name = "standard_melee",
			},
			{
				"debug_print",
				duration = 3,
				text = "event_demo_finale",
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 13,
				spawner_group = "spawner_demo_south",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 13,
				spawner_group = "spawner_demo_east",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"stop_terror_trickle",
			},
			{
				"continue_when",
				duration = 180,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() <= 20
				end,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"continue_when",
				duration = 180,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() <= 6
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 10,
				spawner_group = "spawner_demo_south",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 10,
				spawner_group = "spawner_demo_east",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 10,
				spawner_group = "spawner_demo_north",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"continue_when",
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() <= 10
				end,
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_demo_floor_4",
				template_name = "standard_melee",
			},
			{
				"delay",
				duration = 10,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 7,
				spawner_group = "spawner_demo_north",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 7,
				spawner_group = "spawner_demo_south",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 7,
				spawner_group = "spawner_demo_south",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "event_demo_final_continued_completed",
			},
		},
	},
}

return template
