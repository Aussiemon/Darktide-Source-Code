-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_cm_archives.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		cm_archives_basement_wave_1 = {
			"event_archives_basement_a",
			1,
			"event_archives_basement_b",
			1,
		},
		cm_archives_basement_wave_2 = {
			"event_archives_basement_c",
			1,
			"event_archives_basement_d",
			1,
		},
		cm_archives_basement_wave_3 = {
			"event_archives_basement_e",
			1,
			"event_archives_basement_f",
			1,
		},
		cm_archives_absconditum_wave_1 = {
			"event_scan_absconditum_a",
			1,
			"event_scan_absconditum_b",
			1,
			"event_scan_absconditum_c",
			1,
			"event_scan_absconditum_d",
			1,
		},
		cm_archives_absconditum_wave_2 = {
			"event_scan_absconditum_final_a",
			1,
			"event_scan_absconditum_final_b",
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
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
				},
			},
			{
				"set_pacing_enabled",
				enabled = true,
			},
			{
				"stop_terror_trickle",
			},
		},
		event_archives_basement_guards_a = {
			{
				"spawn_by_points",
				limit_spawners = 16,
				max_breed_amount = 16,
				passive = true,
				points = 16,
				spawner_group = "spawner_archives_basement_guards_a",
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
				max_breed_amount = 2,
				passive = true,
				points = 6,
				spawner_group = "spawner_archives_basement_elite_a",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
		},
		event_archives_basement_guards_b = {
			{
				"spawn_by_points",
				limit_spawners = 16,
				max_breed_amount = 16,
				passive = true,
				points = 16,
				spawner_group = "spawner_archives_basement_guards_b",
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
				max_breed_amount = 3,
				passive = true,
				points = 12,
				spawner_group = "spawner_archives_basement_elite_b",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
		},
		event_archives_basement_guards_c = {
			{
				"spawn_by_points",
				limit_spawners = 24,
				max_breed_amount = 24,
				passive = true,
				points = 24,
				spawner_group = "spawner_archives_basement_guards_c",
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
				max_breed_amount = 3,
				passive = true,
				points = 18,
				spawner_group = "spawner_archives_basement_elite_c",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
		},
		event_archives_basement_a = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_basement_first_segment",
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
				spawner_group = "spawner_basement_first_segment",
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
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_basement_first_segment",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 5
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_archives_basement_wave_1",
			},
		},
		event_archives_basement_b = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_basement_first_segment",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "spawner_absconditum_west",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 4,
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_basement_first_segment",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 5
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_archives_basement_wave_1",
			},
		},
		event_archives_basement_c = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_basement_second_segment",
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
				spawner_group = "spawner_basement_second_segment",
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
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_basement_second_segment",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 5
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_archives_basement_wave_2",
			},
		},
		event_archives_basement_d = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_basement_second_segment",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "spawner_absconditum_west",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 4,
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_basement_second_segment",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 5
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_archives_basement_wave_2",
			},
		},
		event_archives_basement_e = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_basement_third_segment",
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
				spawner_group = "spawner_basement_third_segment",
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
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_basement_third_segment",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 5
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_archives_basement_wave_3",
			},
		},
		event_archives_basement_f = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_basement_third_segment",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "spawner_absconditum_west",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 4,
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_basement_third_segment",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 5
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_archives_basement_wave_3",
			},
		},
		event_scan_absconditum_a = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_absconditum_west",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_absconditum_west",
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
				spawner_group = "spawner_absconditum_north",
				breed_tags = {
					{
						"special",
						"sniper",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_absconditum_west",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"delay",
				duration = 12,
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_archives_absconditum_wave_1",
			},
		},
		event_scan_absconditum_b = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_absconditum_east",
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
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_absconditum_east",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_absconditum_north",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_absconditum_east",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"delay",
				duration = 12,
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_archives_absconditum_wave_1",
			},
		},
		event_scan_absconditum_c = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_absconditum_west",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_absconditum_west",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_absconditum_north",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_absconditum_west",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"delay",
				duration = 12,
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_archives_absconditum_wave_1",
			},
		},
		event_scan_absconditum_d = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_absconditum_east",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_absconditum_east",
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
				spawner_group = "spawner_absconditum_north",
				breed_tags = {
					{
						"special",
						"sniper",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_absconditum_east",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"delay",
				duration = 12,
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_archives_absconditum_wave_1",
			},
		},
		event_scan_absconditum_final_a = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_absconditum_west",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_absconditum_west",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_absconditum_north",
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
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_absconditum_west",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"delay",
				duration = 10,
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_archives_absconditum_wave_2",
			},
		},
		event_scan_absconditum_final_b = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_absconditum_east",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_absconditum_east",
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
				spawner_group = "spawner_absconditum_north",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"delay",
				duration = 4,
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_absconditum_east",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"delay",
				duration = 10,
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_archives_absconditum_wave_2",
			},
		},
		event_scan_absconditum_final_escape = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_absconditum_escape",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_absconditum_east",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 8,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "spawner_absconditum_escape",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_absconditum_escape",
				template_name = "standard_melee",
			},
		},
	},
}

return template
