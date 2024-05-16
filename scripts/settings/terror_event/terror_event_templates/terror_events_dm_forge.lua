-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_dm_forge.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		dm_forge_workers_hub_ranged = {
			"event_workers_hub_a",
			1,
			"event_workers_hub_b",
			1,
		},
		dm_forge_survive_trickle = {
			"event_survive_trickle_a",
			1,
			"event_survive_trickle_b",
			1,
			"event_survive_trickle_c",
			1,
			"event_survive_trickle_d",
			1,
		},
		dm_forge_demolition_corruptor_a = {
			"event_corruptor_a_1",
			1,
			"event_corruptor_a_2",
			1,
		},
		dm_forge_demolition_corruptor_b = {
			"event_corruptor_b_1",
			1,
			"event_corruptor_b_2",
			1,
		},
		dm_forge_demolition_corruptor_c = {
			"event_corruptor_c_1",
			1,
			"event_corruptor_c_2",
			1,
		},
		dm_forge_demolition_corruptor_d = {
			"event_corruptor_d_1",
			1,
			"event_corruptor_d_2",
			1,
		},
		dm_forge_demolition_trickle = {
			"event_demolition_trickle_a",
			1,
			"event_demolition_trickle_b",
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
		event_workers_hub_guards = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				limit_spawners = 7,
				max_breed_amount = 7,
				passive = true,
				points = 14,
				spawner_group = "workers_hub_guards",
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
		},
		event_workers_hub_a = {
			{
				"debug_print",
				duration = 3,
				text = "event_workers_hub_a",
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 10,
				spawner_group = "workers_hub_a",
				breed_tags = {
					{
						"roamer",
						"close",
					},
				},
			},
			{
				"delay",
				duration = 15,
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_workers_hub_a_completed",
			},
		},
		event_workers_hub_b = {
			{
				"debug_print",
				duration = 3,
				text = "event_workers_hub_b",
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				spawner_group = "workers_hub_b",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"delay",
				duration = 15,
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_workers_hub_b_completed",
			},
		},
		event_mid_event_guards = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				limit_spawners = 7,
				max_breed_amount = 7,
				passive = true,
				points = 14,
				spawner_group = "mid_event_guards",
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
		},
		event_survive_trickle_a = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far_cover",
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
				spawner_group = "spawner_workers_far_cover",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_workers_near",
				template_name = "standard_melee",
			},
			{
				"delay",
				duration = 22,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 16,
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
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
				limit_spawners = 2,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_near",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				spawner_group = "spawner_workers_near",
				breed_tags = {
					{
						"roamer",
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
				limit_spawners = 2,
				points = 8,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_near",
				breed_tags = {
					{
						"elite",
						"melee",
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
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 16,
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far_cover",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "event_survive_trickle_completed",
			},
		},
		event_survive_trickle_b = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far",
				breed_tags = {
					{
						"roamer",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_workers_far",
				breed_tags = {
					{
						"elite",
						"close",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_workers_near",
				template_name = "standard_melee",
			},
			{
				"delay",
				duration = 22,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 16,
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
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
				limit_spawners = 2,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_near",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				spawner_group = "spawner_workers_near",
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
				points = 8,
				spawner_group = "spawner_workers_near",
				breed_tags = {
					{
						"roamer",
						"far",
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
				points = 14,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far",
				breed_tags = {
					{
						"roamer",
						"close",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "event_survive_trickle_completed",
			},
		},
		event_survive_trickle_c = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far_cover",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_workers_near",
				template_name = "standard_melee",
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 16,
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"delay",
				duration = 22,
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
				limit_spawners = 2,
				points = 16,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_near",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				spawner_group = "spawner_workers_far_cover",
				breed_tags = {
					{
						"roamer",
						"close",
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
				points = 8,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_near",
				breed_tags = {
					{
						"elite",
						"close",
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
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 16,
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far_cover",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "event_survive_trickle_completed",
			},
		},
		event_survive_trickle_d = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far",
				breed_tags = {
					{
						"roamer",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_workers_far",
				breed_tags = {
					{
						"elite",
						"close",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_workers_near",
				template_name = "standard_melee",
			},
			{
				"delay",
				duration = 22,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 16,
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
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
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far_cover",
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
				spawner_group = "spawner_workers_far_cover",
				breed_tags = {
					{
						"roamer",
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
				limit_spawners = 2,
				points = 8,
				spawner_group = "spawner_workers_near",
				breed_tags = {
					{
						"roamer",
						"far",
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
				points = 14,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "event_survive_trickle_completed",
			},
		},
		event_corruptor_a_1 = {
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_corruptor_a",
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
				spawner_group = "spawner_corruptor_a",
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
				flow_event_name = "event_corruptor_a_1_completed",
			},
		},
		event_corruptor_a_2 = {
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_corruptor_a",
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
				spawner_group = "spawner_corruptor_a",
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
				flow_event_name = "event_corruptor_a_2_completed",
			},
		},
		event_corruptor_b_1 = {
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_corruptor_b",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
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
				points = 16,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_corruptor_a",
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
				flow_event_name = "event_corruptor_b_1_completed",
			},
		},
		event_corruptor_b_2 = {
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_corruptor_b",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 150,
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
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 16,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_corruptor_b",
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
				flow_event_name = "event_corruptor_b_2_completed",
			},
		},
		event_corruptor_c_1 = {
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_corruptor_c",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
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
				points = 16,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_corruptor_c",
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
				flow_event_name = "event_corruptor_c_1_completed",
			},
		},
		event_corruptor_c_2 = {
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_corruptor_c",
				template_name = "standard_melee",
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
				spawner_group = "spawner_corruptor_c",
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
				flow_event_name = "event_corruptor_c_2_completed",
			},
		},
		event_corruptor_d_1 = {
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_corruptor_d",
				template_name = "standard_melee",
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
				spawner_group = "spawner_corruptor_d",
				breed_tags = {
					{
						"horde",
						"melee",
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
				flow_event_name = "event_corruptor_d_1_completed",
			},
		},
		event_corruptor_d_2 = {
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_corruptor_d",
				template_name = "standard_melee",
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
				spawner_group = "spawner_corruptor_d",
				breed_tags = {
					{
						"horde",
						"melee",
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
				flow_event_name = "event_corruptor_d_2_completed",
			},
		},
		event_demolition_trickle_a = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"start_terror_trickle",
				delay = 0,
				limit_spawners = 2,
				proximity_spawners = true,
				spawner_group = "spawner_foundry_trickle",
				template_name = "standard_melee",
			},
		},
		event_demolition_trickle_b = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"start_terror_trickle",
				delay = 0,
				limit_spawners = 2,
				proximity_spawners = true,
				spawner_group = "spawner_foundry_trickle",
				template_name = "standard_melee",
			},
		},
		event_demolition_trickle_hold = {
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_foundry_trickle",
				template_name = "standard_melee",
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
				points = 14,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_trickle",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				spawner_group = "spawner_foundry_trickle",
				breed_tags = {
					{
						"melee",
					},
				},
			},
		},
		event_foundry_finale = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 13,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_north",
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
				limit_spawners = 3,
				points = 13,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_west",
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
				duration = 180,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() <= 50
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 13,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_east",
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
				limit_spawners = 3,
				points = 13,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_south",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 180,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() <= 10
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 6,
				spawner_group = "spawner_foundry_north",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_north",
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
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_west",
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
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_east",
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
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_south",
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
				"continue_when",
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_foundry_north",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_foundry_trickle",
				template_name = "flood_melee",
			},
			{
				"flow_event",
				flow_event_name = "event_foundry_finale_completed",
			},
		},
	},
}

return template
