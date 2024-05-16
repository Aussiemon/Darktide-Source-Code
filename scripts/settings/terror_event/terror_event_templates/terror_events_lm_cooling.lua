-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_lm_cooling.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		lm_cooling_wave_1 = {
			"event_hacking_cooling_a",
			1,
			"event_hacking_cooling_b",
			1,
		},
		lm_cooling_wave_2 = {
			"event_hacking_cooling_c",
			1,
			"event_hacking_cooling_d",
			1,
		},
		lm_cooling_wave_3 = {
			"event_hacking_cooling_e",
			1,
			"event_hacking_cooling_f",
			1,
		},
		lm_cooling_reactor_1 = {
			"event_reactor_cooling_a",
			1,
		},
		lm_cooling_reactor_2 = {
			"event_reactor_cooling_b",
			1,
			"event_reactor_cooling_c",
			1,
		},
		lm_cooling_reactor_3 = {
			"event_reactor_cooling_d",
			1,
			"event_reactor_cooling_e",
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
		event_pacing_on_specials_only = {
			{
				"set_pacing_enabled",
				enabled = true,
			},
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
		event_hacking_cooling_outside_guards = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				limit_spawners = 25,
				max_breed_amount = 25,
				passive = true,
				points = 8,
				spawner_group = "spawner_control_room_guards",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
			},
		},
		event_hacking_cooling_a = {
			{
				"debug_print",
				duration = 3,
				text = "event_hacking_cooling_a",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 24,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cooling_hacking_close",
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
				spawner_group = "spawner_cooling_hacking_close",
				template_name = "standard_melee",
			},
		},
		event_hacking_cooling_b = {
			{
				"debug_print",
				duration = 3,
				text = "event_hacking_cooling_b",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 24,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cooling_hacking_close",
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
				spawner_group = "spawner_cooling_hacking_close",
				template_name = "low_ranged",
			},
		},
		event_hacking_cooling_c = {
			{
				"debug_print",
				duration = 3,
				text = "event_hacking_cooling_c",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cooling_hacking_far",
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
				points = 10,
				spawner_group = "spawner_cooling_hacking_far",
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
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"delay",
				duration = 7,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cooling_hacking_close",
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
				spawner_group = "spawner_cooling_hacking_far",
				template_name = "standard_melee",
			},
		},
		event_hacking_cooling_d = {
			{
				"debug_print",
				duration = 3,
				text = "event_hacking_cooling_d",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cooling_hacking_far",
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
				points = 10,
				spawner_group = "spawner_cooling_hacking_far",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 7,
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
				limit_spawners = 3,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cooling_hacking_close",
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
				spawner_group = "spawner_cooling_hacking_far",
				template_name = "low_ranged",
			},
		},
		event_hacking_cooling_e = {
			{
				"debug_print",
				duration = 3,
				text = "event_hacking_cooling_e",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 30,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cooling_hacking_close",
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
				points = 6,
				spawner_group = "spawner_cooling_hacking_close",
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_cooling_hacking_far",
				template_name = "low_ranged",
			},
		},
		event_hacking_cooling_f = {
			{
				"debug_print",
				duration = 3,
				text = "event_hacking_cooling_f",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 30,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cooling_hacking_close",
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
				points = 6,
				spawner_group = "spawner_cooling_hacking_close",
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_cooling_hacking_close",
				template_name = "standard_melee",
			},
		},
		event_reactor_outside_guards = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				limit_spawners = 25,
				max_breed_amount = 25,
				passive = true,
				points = 8,
				spawner_group = "spawner_reactor_guards",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
			},
		},
		event_reactor_cooling_a = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "spawner_cooling_reactor_1",
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
				points = 10,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 18,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 18,
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
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 18,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 18,
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
				"start_terror_event",
				start_event_name = "event_reactor_cooling_a",
			},
		},
		event_reactor_cooling_b = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 7,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cooling_reactor_1",
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
				points = 12,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"delay",
				duration = 9,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
		},
		event_reactor_cooling_c = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 7,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cooling_reactor_1",
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
				points = 12,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 9,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
		},
		event_reactor_cooling_d = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 7,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cooling_reactor_1",
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
				points = 12,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"delay",
				duration = 9,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
		},
		event_reactor_cooling_e = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 7,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cooling_reactor_1",
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
				points = 12,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 9,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
		},
		event_reactor_finale = {
			{
				"debug_print",
				duration = 3,
				text = "event_reactor_finale",
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 30,
				spawner_group = "spawner_cooling_reactor_1",
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
				spawner_group = "spawner_cooling_reactor_1",
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
				"try_inject_special_minion",
				points = 6,
				spawner_group = "spawner_cooling_reactor_1",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 300,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_reactor_finale_completed",
			},
		},
		event_cooling_end = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				points = 12,
				spawner_group = "spawner_cooling_end",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"debug_print",
				duration = 3,
				text = "event_cooling_end",
			},
		},
	},
}

return template
