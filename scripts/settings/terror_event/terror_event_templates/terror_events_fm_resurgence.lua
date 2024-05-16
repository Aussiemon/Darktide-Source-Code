-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_fm_resurgence.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		fm_resurgence_wave_1 = {
			"event_luggable_resurgence_a",
			1,
			"event_luggable_resurgence_b",
			1,
		},
		fm_resurgence_wave_2 = {
			"event_luggable_resurgence_c",
			1,
			"event_luggable_resurgence_d",
			1,
		},
		fm_resurgence_wave_3 = {
			"event_luggable_resurgence_e",
			1,
			"event_luggable_resurgence_f",
			1,
		},
		fm_resurgence_fort_wave_1 = {
			"event_fort_resurgence_a",
			1,
			"event_fort_resurgence_b",
			1,
		},
		fm_resurgence_fort_wave_2 = {
			"event_fort_resurgence_c",
			1,
			"event_fort_resurgence_d",
			1,
		},
		fm_resurgence_fort_wave_3 = {
			"event_fort_resurgence_e",
			1,
			"event_fort_resurgence_f",
			1,
		},
		fm_resurgence_fort_flush = {
			"event_fort_upper_flush",
			1,
			"event_fort_upper_flush_2",
			1,
			"event_fort_upper_flush_3",
			1,
		},
		fm_resurgence_fort_ranged_flush = {
			"event_fort_ranged_flush_1",
			1,
			"event_fort_ranged_flush_2",
			1,
		},
	},
	events = {
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
		event_luggable_resurgence_a = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_right",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 6,
				spawner_group = "spawner_resurgence_right",
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
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_resurgence_right",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_wave_1",
			},
		},
		event_luggable_resurgence_b = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_left",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_right",
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
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_resurgence_left",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_wave_1",
			},
		},
		event_luggable_resurgence_c = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 12,
				spawner_group = "spawner_resurgence_upper",
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
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_upper",
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
					},
				},
			},
			{
				"delay",
				duration = 7,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 20,
				spawner_group = "spawner_resurgence_right",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_resurgence_upper",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_wave_2",
			},
		},
		event_luggable_resurgence_d = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 10,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_left",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 6,
				spawner_group = "spawner_resurgence_left",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
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
				"delay",
				duration = 7,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 20,
				spawner_group = "spawner_resurgence_upper",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_resurgence_upper",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_wave_2",
			},
		},
		event_luggable_resurgence_e = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_right",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 6,
				spawner_group = "spawner_resurgence_right",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 6,
				spawner_group = "spawner_resurgence_right",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_resurgence_upper",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_wave_3",
			},
		},
		event_luggable_resurgence_f = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_left",
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
				points = 6,
				spawner_group = "spawner_resurgence_left",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 6,
				spawner_group = "spawner_resurgence_left",
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
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_resurgence_upper",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_wave_3",
			},
		},
		event_luggable_finale = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 15,
				spawner_group = "spawner_resurgence_left",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 15,
				spawner_group = "spawner_resurgence_right",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 7,
			},
		},
		event_bridge_reinforcements = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				spawner_group = "spawner_resurgence_bridge_left",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				spawner_group = "spawner_resurgence_bridge_right",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 6,
				spawner_group = "spawner_resurgence_bridge",
				breed_tags = {
					{
						"melee",
						"elite",
					},
					{
						"far",
						"elite",
					},
				},
			},
		},
		event_traitor_base_guards = {
			{
				"spawn_by_points",
				limit_spawners = 8,
				max_breed_amount = 8,
				passive = true,
				points = 8,
				spawner_group = "traitor_base_guards",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
		},
		event_fort_resurgence_a = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				spawner_group = "spawner_fort_event_wall",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 14,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_right",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_ranged_flush",
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
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 6,
				spawner_group = "spawner_fort_event_right",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_wave_2",
			},
		},
		event_fort_resurgence_b = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				spawner_group = "spawner_fort_event_wall",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 14,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_left",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_ranged_flush",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 6,
				spawner_group = "spawner_fort_event_left",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_wave_2",
			},
		},
		event_fort_resurgence_c = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_wall",
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
				points = 10,
				spawner_group = "spawner_fort_event_wall",
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
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"delay",
				duration = 7,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_wall",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_fort_event_wall",
				template_name = "standard_melee",
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_flush",
			},
			{
				"delay",
				duration = 7,
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 12,
				spawner_group = "spawner_fort_event_wall",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_wave_3",
			},
		},
		event_fort_resurgence_d = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 14,
				spawner_group = "spawner_fort_event_upper",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 10,
				spawner_group = "spawner_fort_event_upper",
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
				points = 8,
				spawner_group = "spawner_fort_event_wall",
				breed_tags = {
					{
						"special",
						"sniper",
					},
				},
			},
			{
				"delay",
				duration = 7,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				spawner_group = "spawner_fort_event_wall",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 14,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_right",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_fort_event_wall",
				template_name = "standard_melee",
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
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 14,
				spawner_group = "spawner_fort_event_upper",
				breed_tags = {
					{
						"ogryn",
						"elite",
					},
				},
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_flush",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_wave_3",
			},
		},
		event_fort_resurgence_e = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 6,
				spawner_group = "spawner_fort_event_wall",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_left",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 7,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_ranged_flush",
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 6,
				spawner_group = "spawner_fort_event_left",
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
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_flush",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 14,
				spawner_group = "spawner_fort_event_left",
				breed_tags = {
					{
						"ogryn",
						"elite",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"try_inject_special_minion",
				limit_spawners = 1,
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_fort_event_upper",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 12,
				spawner_group = "spawner_fort_event_upper",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
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
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_wave_2",
			},
		},
		event_fort_resurgence_f = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 10,
				spawner_group = "spawner_fort_event_wall",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_right",
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
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_flush",
			},
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 8,
				spawner_group = "spawner_fort_event_right",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_ranged_flush",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
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
				"delay",
				duration = 7,
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 12,
				spawner_group = "spawner_fort_event_upper",
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
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_resurgence_fort_wave_2",
			},
		},
		event_fort_upper_flush = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 14,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "traitor_base_upper_flush",
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
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 6,
				spawner_group = "traitor_base_side_flush",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
		},
		event_fort_upper_flush_2 = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "traitor_base_side_flush",
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
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 6,
				spawner_group = "traitor_base_side_flush",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
		},
		event_fort_upper_flush_3 = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "traitor_base_side_flush",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 6,
				proximity_spawners = true,
				spawner_group = "traitor_base_upper_flush",
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
		},
		event_fort_ranged_flush_1 = {
			{
				"spawn_by_points",
				inverse_proximity_spawners = true,
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "traitor_base_side_flush",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_points",
				inverse_proximity_spawners = true,
				limit_spawners = 3,
				points = 8,
				spawner_group = "traitor_base_side_flush",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
		},
		event_fort_ranged_flush_2 = {
			{
				"spawn_by_points",
				inverse_proximity_spawners = true,
				limit_spawners = 3,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "traitor_base_side_flush",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"try_inject_special_minion",
				inverse_proximity_spawners = true,
				limit_spawners = 1,
				max_breed_amount = 1,
				points = 6,
				spawner_group = "traitor_base_side_flush",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
		},
		event_fort_finale = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 15,
				spawner_group = "spawner_fort_event_right",
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
				"spawn_by_points",
				limit_spawners = 1,
				points = 15,
				spawner_group = "spawner_fort_event_left",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 6,
				spawner_group = "spawner_fort_event_wall",
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
				"continue_when",
				duration = 110,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_fort_finale_completed",
			},
		},
	},
}

return template
