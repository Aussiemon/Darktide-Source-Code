﻿-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_hm_cartel.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		hm_cartel_scanning = {
			"event_scan_bazaar_a",
			1,
			"event_scan_bazaar_b",
			1,
			"event_scan_bazaar_c",
			1,
		},
		hm_cartel_hacking_first_protocol = {
			"event_hack_data_center_a",
			1,
			"event_hack_data_center_b",
			1,
			"event_hack_data_center_c",
			1,
		},
		hm_cartel_hacking_second_protocol = {
			"event_hack_data_center_d",
			1,
			"event_hack_data_center_e",
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
		event_scan_bazaar_a = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 20,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cartel_scanning_west",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 1,
				proximity_spawners = true,
				spawner_group = "spawner_cartel_scanning_east",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_cartel_scanning_east",
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
				spawner_group = "spawner_cartel_scanning_east",
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
				spawner_group = "spawner_cartel_scanning_east",
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
				points = 16,
				spawner_group = "spawner_cartel_scanning_close",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"flow_event",
				flow_event_name = "event_scan_bazaar_a_completed",
			},
		},
		event_scan_bazaar_b = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cartel_scanning_east",
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
				spawner_group = "spawner_cartel_scanning_east",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_cartel_scanning_east",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_cartel_scanning_close",
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
				points = 12,
				spawner_group = "spawner_cartel_scanning_close",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"flow_event",
				flow_event_name = "event_scan_bazaar_b_completed",
			},
		},
		event_scan_bazaar_c = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cartel_scanning_west",
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
				spawner_group = "spawner_cartel_scanning_west",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 1,
				proximity_spawners = true,
				spawner_group = "spawner_cartel_scanning_west",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_cartel_scanning_close",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end,
			},
			{
				"delay",
				duration = 5,
			},
			{
				"flow_event",
				flow_event_name = "event_scan_bazaar_c_completed",
			},
		},
		event_scanning_elevator_ambush = {
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 12,
				spawner_group = "spawner_cartel_ambush",
				breed_tags = {
					{
						"elite",
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
				points = 8,
				spawner_group = "spawner_cartel_ambush",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_cartel_scanning_east",
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
				spawner_group = "spawner_cartel_ambush_reinforcements",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 10,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cartel_scanning_west",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 27,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end,
			},
			{
				"delay",
				duration = 1,
			},
			{
				"flow_event",
				flow_event_name = "event_scanning_elevator_ambush_completed",
			},
		},
		event_data_center_outside_guards = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				limit_spawners = 6,
				max_breed_amount = 3,
				passive = true,
				points = 18,
				spawner_group = "spawner_data_center_guards",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
		},
		event_data_center_reinforcements = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				max_breed_amount = 14,
				passive = false,
				points = 16,
				spawner_group = "spawner_data_center_reinforcements",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
		},
		event_hack_data_center_a = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_data_center_north",
				breed_tags = {
					{
						"roamer",
						"melee",
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
				spawner_group = "spawner_data_center_north",
				breed_tags = {
					{
						"roamer",
						"melee",
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
				spawner_group = "spawner_data_center_north",
				breed_tags = {
					{
						"far",
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
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 8,
				proximity_spawners = true,
				spawner_group = "spawner_data_center_reinforcements",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_data_center_west",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"delay",
				duration = 2,
			},
			{
				"flow_event",
				flow_event_name = "event_hack_data_center_a_completed",
			},
		},
		event_hack_data_center_b = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				spawner_group = "spawner_data_center_west",
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
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_terror_trickle",
				delay = 8,
				proximity_spawners = true,
				spawner_group = "spawner_data_center_reinforcements",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_data_center_east",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"delay",
				duration = 2,
			},
			{
				"flow_event",
				flow_event_name = "event_hack_data_center_b_completed",
			},
		},
		event_hack_data_center_c = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_data_center_north",
				breed_tags = {
					{
						"roamer",
						"melee",
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
				spawner_group = "spawner_data_center_north",
				breed_tags = {
					{
						"roamer",
						"far",
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
				spawner_group = "spawner_data_center_north",
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
				proximity_spawners = true,
				spawner_group = "spawner_data_center_reinforcements",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_data_center_west",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"delay",
				duration = 2,
			},
			{
				"flow_event",
				flow_event_name = "event_hack_data_center_c_completed",
			},
		},
		event_hack_data_center_d = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				spawner_group = "spawner_data_center_left",
				breed_tags = {
					{
						"close",
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
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_data_center_escape",
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
				proximity_spawners = true,
				spawner_group = "spawner_data_center_right",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 25,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_data_center_right",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end,
			},
			{
				"delay",
				duration = 2,
			},
			{
				"flow_event",
				flow_event_name = "event_hack_data_center_d_completed",
			},
		},
		event_hack_data_center_e = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_data_center_right",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_data_center_north",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_data_center_escape",
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
				proximity_spawners = true,
				spawner_group = "spawner_data_center_left",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_data_center_right",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"delay",
				duration = 2,
			},
			{
				"flow_event",
				flow_event_name = "event_hack_data_center_e_completed",
			},
		},
		event_data_center_escape = {
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_data_center_escape",
				breed_tags = {
					{
						"melee",
						"elite",
					},
					{
						"close",
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				spawner_group = "spawner_data_center_reinforcements",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
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
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_data_center_escape_completed",
			},
		},
	},
}

return template
