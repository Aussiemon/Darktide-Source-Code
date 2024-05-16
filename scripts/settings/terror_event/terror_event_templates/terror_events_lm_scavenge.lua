-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_lm_scavenge.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		lm_scavenge_hacking_wave_1 = {
			"event_hacking_scavenge_a",
			1,
			"event_hacking_scavenge_b",
			1,
			"event_hacking_scavenge_c",
			1,
		},
		lm_scavenge_hacking_wave_2 = {
			"event_hacking_scavenge_d",
			1,
			"event_hacking_scavenge_e",
			1,
			"event_hacking_scavenge_f",
			1,
		},
		lm_scavenge_luggable_wave_1 = {
			"event_luggable_scavenge_a",
			1,
			"event_luggable_scavenge_b",
			1,
			"event_luggable_scavenge_c",
			1,
			"event_luggable_scavenge_d",
			1,
			"event_luggable_scavenge_e",
			1,
			"event_luggable_scavenge_f",
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
		event_elevator_scavenge = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 16,
				spawner_group = "scavenge_port_elevator_1",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"try_inject_special_minion",
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"debug_print",
				duration = 30,
				text = "event_elevator_scavenge",
			},
		},
		event_hacking_scavenge_a = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 30,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_security_office_west",
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
				"delay",
				duration = 3,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 8,
				spawner_group = "spawner_security_office_north",
				breed_tags = {
					{
						"special",
						"sniper",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_security_office_far",
				template_name = "standard_melee",
			},
		},
		event_hacking_scavenge_b = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
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
				spawner_group = "spawner_security_office_north",
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
				points = 8,
				spawner_group = "spawner_security_office_north",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_security_office_far",
				template_name = "standard_melee",
			},
		},
		event_hacking_scavenge_c = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
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
				spawner_group = "spawner_security_office_east",
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
				spawner_group = "spawner_security_office_east",
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
				points = 10,
				spawner_group = "spawner_security_office_east",
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
				spawner_group = "spawner_security_office_close",
				template_name = "standard_melee",
			},
		},
		event_hacking_scavenge_d = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
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
				spawner_group = "spawner_security_office_east",
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
				spawner_group = "spawner_security_office_east",
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
				duration = 3,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 8,
				spawner_group = "spawner_security_office_west",
				breed_tags = {
					{
						"special",
						"sniper",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_security_office_close",
				template_name = "standard_melee",
			},
		},
		event_hacking_scavenge_e = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
				end,
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 30,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_security_office_south",
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
						"disabler",
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
				spawner_group = "spawner_security_office_close",
				template_name = "standard_melee",
			},
		},
		event_hacking_scavenge_f = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
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
				spawner_group = "spawner_security_office_east",
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
				spawner_group = "spawner_security_office_east",
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
				points = 10,
				spawner_group = "spawner_security_office_east",
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
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 8,
				spawner_group = "spawner_security_office_east",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_security_office_far",
				template_name = "standard_melee",
			},
		},
		lm_scavenge_luggable_wave_1 = {
			{
				"start_random_terror_event",
				start_event_name = "lm_scavenge_luggable_wave_1",
			},
		},
		lm_scavenge_luggable_guards = {
			{
				"spawn_by_points",
				limit_spawners = 9,
				max_breed_amount = 9,
				passive = true,
				points = 29,
				spawner_group = "spawner_vaults_guard_door",
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
		lm_scavenge_luggable_guards_middle = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				max_breed_amount = 3,
				passive = true,
				points = 15,
				spawner_group = "spawner_vaults_guard_center_elite",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 6,
				max_breed_amount = 6,
				passive = true,
				points = 24,
				spawner_group = "spawner_vaults_guard_center",
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
		event_luggable_scavenge_a = {
			{
				"delay",
				duration = 17,
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 20
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 25,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_vaults_north",
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
				limit_spawners = 2,
				proximity_spawners = true,
				spawner_group = "spawner_vaults_trickle",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				duration = 100,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "lm_scavenge_luggable_wave_1",
			},
		},
		event_luggable_scavenge_b = {
			{
				"delay",
				duration = 17,
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 20
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_vaults_east",
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
				spawner_group = "spawner_vaults_east",
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
				spawner_group = "spawner_vaults_east",
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
				points = 12,
				spawner_group = "spawner_vaults_trickle",
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
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 6,
				spawner_group = "spawner_vaults_trickle",
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
				limit_spawners = 2,
				proximity_spawners = true,
				spawner_group = "spawner_vaults_trickle",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				duration = 100,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "lm_scavenge_luggable_wave_1",
			},
		},
		event_luggable_scavenge_c = {
			{
				"delay",
				duration = 17,
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 20
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 25,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_vaults_south",
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
				spawner_group = "spawner_vaults_trickle",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				limit_spawners = 2,
				proximity_spawners = true,
				spawner_group = "spawner_vaults_trickle",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				duration = 100,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "lm_scavenge_luggable_wave_1",
			},
		},
		event_luggable_scavenge_d = {
			{
				"delay",
				duration = 17,
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 20
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_vaults_west",
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
				points = 12,
				spawner_group = "spawner_vaults_trickle",
				breed_tags = {
					{
						"special",
						"disabler",
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
				points = 6,
				spawner_group = "spawner_vaults_trickle",
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
				limit_spawners = 2,
				proximity_spawners = true,
				spawner_group = "spawner_vaults_trickle",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				duration = 100,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "lm_scavenge_luggable_wave_1",
			},
		},
		event_luggable_scavenge_e = {
			{
				"delay",
				duration = 17,
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 20
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_vaults_north",
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
				spawner_group = "spawner_vaults_north",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				limit_spawners = 2,
				proximity_spawners = true,
				spawner_group = "spawner_vaults_trickle",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				duration = 100,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "lm_scavenge_luggable_wave_1",
			},
		},
		event_luggable_scavenge_f = {
			{
				"delay",
				duration = 17,
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 20
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_vaults_south",
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
				spawner_group = "spawner_vaults_south",
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
				points = 8,
				spawner_group = "spawner_vaults_west",
				breed_tags = {
					{
						"special",
						"sniper",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				limit_spawners = 2,
				proximity_spawners = true,
				spawner_group = "spawner_vaults_trickle",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				duration = 100,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "lm_scavenge_luggable_wave_1",
			},
		},
		event_luggable_monster_1 = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				points = 6,
				spawner_group = "event_luggable_monster_1",
				breed_tags = {
					{
						"monster",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_luggable_monster_dead",
			},
		},
		event_luggable_monster_2 = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				points = 6,
				spawner_group = "event_luggable_monster_2",
				breed_tags = {
					{
						"monster",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_luggable_monster_dead",
			},
		},
		event_luggable_monster_3 = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				points = 6,
				spawner_group = "event_luggable_monster_3",
				breed_tags = {
					{
						"monster",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_luggable_monster_dead",
			},
		},
		event_luggable_monster_4 = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				points = 6,
				spawner_group = "event_luggable_monster_4",
				breed_tags = {
					{
						"monster",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_luggable_monster_dead",
			},
		},
		event_luggable_monster_5 = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				points = 6,
				spawner_group = "event_luggable_monster_5",
				breed_tags = {
					{
						"monster",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_luggable_monster_dead",
			},
		},
		event_luggable_monster_6 = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				points = 6,
				spawner_group = "event_luggable_monster_6",
				breed_tags = {
					{
						"monster",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_luggable_monster_dead",
			},
		},
		event_luggable_monster_7 = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				points = 6,
				spawner_group = "event_luggable_monster_7",
				breed_tags = {
					{
						"monster",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_luggable_monster_dead",
			},
		},
		event_luggable_monster_8 = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				points = 6,
				spawner_group = "event_luggable_monster_8",
				breed_tags = {
					{
						"monster",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_luggable_monster_dead",
			},
		},
		event_scavenge_escape_1 = {
			{
				"spawn_by_points",
				points = 14,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "scavenge_escape_a",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "scavenge_escape_b",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 3,
				limit_spawners = 2,
				spawner_group = "scavenge_escape_trickle",
				template_name = "standard_melee",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 8,
				spawner_group = "scavenge_escape_special",
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
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end,
			},
			{
				"delay",
				duration = 10,
			},
			{
				"start_terror_event",
				start_event_name = "event_scavenge_escape_1",
			},
		},
		event_scavenge_escape_2 = {
			{
				"spawn_by_points",
				points = 5,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "scavenge_escape_d",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				points = 5,
				spawner_group = "scavenge_escape_c",
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
				points = 4,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "scavenge_escape_d",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
			},
		},
	},
}

return template
