﻿-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_psykhanium.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		psykhanium_horde_random_waves_1 = {
			"horde_wave_1_a",
			1,
			"horde_wave_1_b",
			1,
			"horde_wave_1_c",
			1,
		},
		psykhanium_horde_random_waves_2 = {
			"horde_wave_2_a",
			1,
			"horde_wave_2_b",
			1,
			"horde_wave_2_c",
			1,
		},
		psykhanium_horde_random_waves_3 = {
			"horde_wave_3_a",
			1,
			"horde_wave_3_b",
			1,
			"horde_wave_3_c",
			1,
		},
		psykhanium_horde_random_waves_4 = {
			"horde_wave_4_a",
			1,
			"horde_wave_4_b",
			1,
			"horde_wave_4_c",
			1,
		},
		psykhanium_horde_random_waves_5 = {
			"horde_wave_5_a",
			1,
			"horde_wave_5_b",
			1,
			"horde_wave_5_c",
			1,
		},
		psykhanium_horde_random_waves_6 = {
			"horde_wave_6_a",
			1,
			"horde_wave_6_b",
			1,
			"horde_wave_6_c",
			1,
		},
		psykhanium_horde_random_waves_7 = {
			"horde_wave_7_a",
			1,
			"horde_wave_7_b",
			1,
			"horde_wave_7_c",
			1,
		},
		psykhanium_horde_random_waves_8 = {
			"horde_wave_8_a",
			1,
			"horde_wave_8_b",
			1,
			"horde_wave_8_c",
			1,
		},
		psykhanium_horde_random_waves_9 = {
			"horde_wave_9_a",
			1,
			"horde_wave_9_b",
			1,
			"horde_wave_9_c",
			1,
		},
		psykhanium_horde_random_waves_10 = {
			"horde_wave_10_a",
			1,
			"horde_wave_10_b",
			1,
			"horde_wave_10_c",
			1,
		},
		psykhanium_horde_random_waves_11 = {
			"horde_wave_11_a",
			1,
			"horde_wave_11_b",
			1,
			"horde_wave_11_c",
			1,
		},
		psykhanium_horde_random_waves_12 = {
			"horde_wave_12_a",
			1,
			"horde_wave_12_b",
			1,
			"horde_wave_12_c",
			1,
		},
		psykhanium_horde_random_waves_1_alt = {
			"horde_wave_1_a_alt",
			1,
			"horde_wave_1_b_alt",
			1,
			"horde_wave_1_c_alt",
			1,
		},
		psykhanium_horde_random_waves_2_alt = {
			"horde_wave_2_a_alt",
			1,
			"horde_wave_2_b_alt",
			1,
			"horde_wave_2_c_alt",
			1,
		},
		psykhanium_horde_random_waves_3_alt = {
			"horde_wave_3_a_alt",
			1,
			"horde_wave_3_b_alt",
			1,
			"horde_wave_3_c_alt",
			1,
		},
		psykhanium_horde_random_waves_4_alt = {
			"horde_wave_4_a_alt",
			1,
			"horde_wave_4_b_alt",
			1,
			"horde_wave_4_c_alt",
			1,
		},
		psykhanium_horde_random_waves_5_alt = {
			"horde_wave_5_a_alt",
			1,
			"horde_wave_5_b_alt",
			1,
			"horde_wave_5_c_alt",
			1,
		},
		psykhanium_horde_random_waves_6_alt = {
			"horde_wave_6_a_alt",
			1,
			"horde_wave_6_b_alt",
			1,
			"horde_wave_6_c_alt",
			1,
		},
		psykhanium_horde_random_waves_7_alt = {
			"horde_wave_7_a_alt",
			1,
			"horde_wave_7_b_alt",
			1,
			"horde_wave_7_c_alt",
			1,
		},
		psykhanium_horde_random_waves_8_alt = {
			"horde_wave_8_a_alt",
			1,
			"horde_wave_8_b_alt",
			1,
			"horde_wave_8_c_alt",
			1,
		},
		psykhanium_horde_random_waves_9_alt = {
			"horde_wave_9_a_alt",
			1,
			"horde_wave_9_b_alt",
			1,
			"horde_wave_9_c_alt",
			1,
		},
		psykhanium_horde_random_waves_10_alt = {
			"horde_wave_10_a_alt",
			1,
			"horde_wave_10_b_alt",
			1,
			"horde_wave_10_c_alt",
			1,
		},
		psykhanium_horde_random_waves_11_alt = {
			"horde_wave_11_a_alt",
			1,
			"horde_wave_11_b_alt",
			1,
			"horde_wave_11_c_alt",
			1,
		},
		psykhanium_horde_random_waves_12_alt = {
			"horde_wave_12_a_alt",
			1,
			"horde_wave_12_b_alt",
			1,
			"horde_wave_12_c_alt",
			1,
		},
		psykhanium_horde_random_waves_rooftops_1 = {
			"horde_wave_rooftops_1_a",
			1,
			"horde_wave_rooftops_1_b",
			1,
			"horde_wave_rooftops_1_c",
			1,
		},
		psykhanium_horde_random_waves_rooftops_2 = {
			"horde_wave_rooftops_2_a",
			1,
			"horde_wave_rooftops_2_b",
			1,
			"horde_wave_rooftops_2_c",
			1,
		},
		psykhanium_horde_random_waves_rooftops_3 = {
			"horde_wave_rooftops_3_a",
			1,
			"horde_wave_rooftops_3_b",
			1,
			"horde_wave_rooftops_3_c",
			1,
		},
		psykhanium_horde_random_waves_rooftops_4 = {
			"horde_wave_rooftops_4_a",
			1,
			"horde_wave_rooftops_4_b",
			1,
			"horde_wave_rooftops_4_c",
			1,
		},
		psykhanium_horde_random_waves_rooftops_5 = {
			"horde_wave_rooftops_5_a",
			1,
			"horde_wave_rooftops_5_b",
			1,
			"horde_wave_rooftops_5_c",
			1,
		},
		psykhanium_horde_random_waves_rooftops_6 = {
			"horde_wave_rooftops_6_a",
			1,
			"horde_wave_rooftops_6_b",
			1,
			"horde_wave_rooftops_6_c",
			1,
		},
		psykhanium_horde_random_waves_rooftops_7 = {
			"horde_wave_rooftops_7_a",
			1,
			"horde_wave_rooftops_7_b",
			1,
			"horde_wave_rooftops_7_c",
			1,
		},
		psykhanium_horde_random_waves_rooftops_8 = {
			"horde_wave_rooftops_8_a",
			1,
			"horde_wave_rooftops_8_b",
			1,
			"horde_wave_rooftops_8_c",
			1,
		},
		psykhanium_horde_random_waves_rooftops_9 = {
			"horde_wave_rooftops_9_a",
			1,
			"horde_wave_rooftops_9_b",
			1,
			"horde_wave_rooftops_9_c",
			1,
		},
		psykhanium_horde_random_waves_rooftops_10 = {
			"horde_wave_rooftops_10_a",
			1,
			"horde_wave_rooftops_10_b",
			1,
			"horde_wave_rooftops_10_c",
			1,
		},
		psykhanium_horde_random_waves_rooftops_11 = {
			"horde_wave_rooftops_11_a",
			1,
			"horde_wave_rooftops_11_b",
			1,
			"horde_wave_rooftops_11_c",
			1,
		},
		psykhanium_horde_random_waves_rooftops_12 = {
			"horde_wave_rooftops_12_a",
			1,
			"horde_wave_rooftops_12_b",
			1,
			"horde_wave_rooftops_12_c",
			1,
		},
		psykhanium_horde_random_waves_rooftops_1_alt = {
			"horde_wave_rooftops_1_a_alt",
			1,
			"horde_wave_rooftops_1_b_alt",
			1,
			"horde_wave_rooftops_1_c_alt",
			1,
		},
		psykhanium_horde_random_waves_rooftops_2_alt = {
			"horde_wave_rooftops_2_a_alt",
			1,
			"horde_wave_rooftops_2_b_alt",
			1,
			"horde_wave_rooftops_2_c_alt",
			1,
		},
		psykhanium_horde_random_waves_rooftops_3_alt = {
			"horde_wave_rooftops_3_a_alt",
			1,
			"horde_wave_rooftops_3_b_alt",
			1,
			"horde_wave_rooftops_3_c_alt",
			1,
		},
		psykhanium_horde_random_waves_rooftops_4_alt = {
			"horde_wave_rooftops_4_a_alt",
			1,
			"horde_wave_rooftops_4_b_alt",
			1,
			"horde_wave_rooftops_4_c_alt",
			1,
		},
		psykhanium_horde_random_waves_rooftops_5_alt = {
			"horde_wave_rooftops_5_a_alt",
			1,
			"horde_wave_rooftops_5_b_alt",
			1,
			"horde_wave_rooftops_5_c_alt",
			1,
		},
		psykhanium_horde_random_waves_rooftops_6_alt = {
			"horde_wave_rooftops_6_a_alt",
			1,
			"horde_wave_rooftops_6_b_alt",
			1,
			"horde_wave_rooftops_6_c_alt",
			1,
		},
		psykhanium_horde_random_waves_rooftops_7_alt = {
			"horde_wave_rooftops_7_a_alt",
			1,
			"horde_wave_rooftops_7_b_alt",
			1,
			"horde_wave_rooftops_7_c_alt",
			1,
		},
		psykhanium_horde_random_waves_rooftops_8_alt = {
			"horde_wave_rooftops_8_a_alt",
			1,
			"horde_wave_rooftops_8_b_alt",
			1,
			"horde_wave_rooftops_8_c_alt",
			1,
		},
		psykhanium_horde_random_waves_rooftops_9_alt = {
			"horde_wave_rooftops_9_a_alt",
			1,
			"horde_wave_rooftops_9_b_alt",
			1,
			"horde_wave_rooftops_9_c_alt",
			1,
		},
		psykhanium_horde_random_waves_rooftops_10_alt = {
			"horde_wave_rooftops_10_a_alt",
			1,
			"horde_wave_rooftops_10_b_alt",
			1,
			"horde_wave_rooftops_10_c_alt",
			1,
		},
		psykhanium_horde_random_waves_rooftops_11_alt = {
			"horde_wave_rooftops_11_a_alt",
			1,
			"horde_wave_rooftops_11_b_alt",
			1,
			"horde_wave_rooftops_11_c_alt",
			1,
		},
		psykhanium_horde_random_waves_rooftops_12_alt = {
			"horde_wave_rooftops_12_a_alt",
			1,
			"horde_wave_rooftops_12_b_alt",
			1,
			"horde_wave_rooftops_12_c_alt",
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
		horde_wave_1_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 4,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() <= 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_1_complete",
			},
		},
		horde_wave_1_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 50,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_1_complete",
			},
		},
		horde_wave_1_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 8,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 15,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 3,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_1_complete",
			},
		},
		horde_wave_2_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 25,
				limit_spawners = 4,
				max_breed_amount = 60,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 15,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 3,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_2_complete",
			},
		},
		horde_wave_2_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 18,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 6,
				limit_spawners = 4,
				max_breed_amount = 12,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				points = 6,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"monster",
					},
				},
				excluded_breed_tags = {
					"witch",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 8,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_2_complete",
			},
		},
		horde_wave_2_c_alt = {
			{
				"flow_event",
				flow_event_name = "chaos_hound_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				limit_spawners = 4,
				max_breed_amount = 7,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 7,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 6,
				limit_spawners = 4,
				max_breed_amount = 12,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"close",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 7,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_2_complete",
			},
		},
		horde_wave_3_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "chaos_ogryn_gunner",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 3,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(3)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_3_complete",
			},
		},
		horde_wave_3_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_plague_ogryn",
				max_breed_amount = 2,
				spawner_group = "spawner_wave_horde",
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(3)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_3_complete",
			},
		},
		horde_wave_3_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(3)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_3_complete",
			},
		},
		horde_wave_4_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				max_breed_amount = 1,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 8,
				limit_spawners = 4,
				max_breed_amount = 35,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 4,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 4,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_ogryn_gunner",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "chaos_ogryn_executor",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_4_complete",
			},
		},
		horde_wave_4_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "cultist_berzerker",
				max_breed_amount = 10,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_rifleman",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 12,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 12,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "renegade_rifleman",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "cultist_berzerker",
				max_breed_amount = 5,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_4_complete",
			},
		},
		horde_wave_4_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_poxwalker_bomber",
				max_breed_amount = 3,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 40,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_poxwalker_bomber",
				max_breed_amount = 4,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "cultist_mutant",
				max_breed_amount = 6,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 12,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_4_complete",
			},
		},
		horde_wave_5_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 20,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 20,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_beast_of_nurgle",
				max_breed_amount = 2,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 20,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_5_complete",
			},
		},
		horde_wave_5_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 35,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				max_breed_amount = 2,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_5_complete",
			},
		},
		horde_wave_5_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 35,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"flow_event",
				flow_event_name = "cultist_mutant_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				max_breed_amount = 1,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_5_complete",
			},
		},
		horde_wave_6_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 30,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_gunner",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 4,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 35,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 50,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "renegade_gunner",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_horde",
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 4,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(6)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_6_complete",
			},
		},
		horde_wave_6_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "renegade_gunner",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(6)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_6_complete",
			},
		},
		horde_wave_6_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "chaos_ogryn_gunner",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_ogryn_bulwark",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_ogryn_executor",
				spawner_group = "spawner_wave_horde",
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(6)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_6_complete",
			},
		},
		horde_wave_7_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_ogryn_bulwark",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "renegade_rifleman",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_7_complete",
			},
		},
		horde_wave_7_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 35,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "cultist_grenadier",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				limit_spawners = 4,
				max_breed_amount = 40,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "cultist_grenadier",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_7_complete",
			},
		},
		horde_wave_7_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 13,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "chaos_poxwalker_bomber_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 18,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 13,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_7_complete",
			},
		},
		horde_wave_8_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "renegade_netgunner",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "cultist_assault",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_8_complete",
			},
		},
		horde_wave_8_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 40,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "renegade_rifleman",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "chaos_ogryn_bulwark",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_8_complete",
			},
		},
		horde_wave_8_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "flamer_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "cultist_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "cultist_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_8_complete",
			},
		},
		horde_wave_9_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 6,
				max_breed_amount = 14,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "cultist_grenadier",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				limit_spawners = 4,
				max_breed_amount = 8,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 8,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(9)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_9_complete",
			},
		},
		horde_wave_9_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 7,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				limit_spawners = 4,
				max_breed_amount = 10,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 8,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(9)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_9_complete",
			},
		},
		horde_wave_9_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 12,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 12,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 23,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 12,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 23,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 9,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(9)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_9_complete",
			},
		},
		horde_wave_10_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 7,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 7,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 250,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_10_complete",
			},
		},
		horde_wave_10_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 20,
				breed_name = "chaos_mutated_poxwalker",
				max_breed_amount = 50,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 35,
				breed_name = "chaos_mutated_poxwalker",
				max_breed_amount = 100,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 12,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_10_complete",
			},
		},
		horde_wave_10_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_netgunner",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 8,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "renegade_netgunner",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 8,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 15,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "renegade_netgunner",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 8,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_10_complete",
			},
		},
		horde_wave_11_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 30,
				limit_spawners = 4,
				max_breed_amount = 50,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 120,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 8,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_daemonhost",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_ogryn_executor",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_11_complete",
			},
		},
		horde_wave_11_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 25,
				limit_spawners = 4,
				max_breed_amount = 40,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 85,
				max_breed_amount = 120,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_11_complete",
			},
		},
		horde_wave_11_c_alt = {
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_11_complete",
			},
		},
		horde_wave_12_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 45,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 10,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				limit_spawners = 4,
				max_breed_amount = 10,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_daemonhost",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_12_complete",
			},
		},
		horde_wave_12_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 30,
				limit_spawners = 4,
				max_breed_amount = 55,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 6,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 80,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 60,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_12_complete",
			},
		},
		horde_wave_12_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 45,
				limit_spawners = 4,
				max_breed_amount = 70,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 10,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				max_breed_amount = 3,
				points = 10,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"captain",
					},
				},
				attack_selection_template_tag = {
					"default",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				limit_spawners = 4,
				max_breed_amount = 50,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_12_complete",
			},
		},
		horde_wave_1_a = {
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "cultist_berzerker",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() <= 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_1_complete",
			},
		},
		horde_wave_1_b = {
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_1_complete",
			},
		},
		horde_wave_1_c = {
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 15,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_1_complete",
			},
		},
		horde_wave_2_a = {
			{
				"spawn_by_points",
				breed_amount = 25,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 1,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_2_complete",
			},
		},
		horde_wave_2_b = {
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 18,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 6,
				limit_spawners = 4,
				max_breed_amount = 12,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				points = 6,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"monster",
					},
				},
				excluded_breed_tags = {
					"witch",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 8,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_2_complete",
			},
		},
		horde_wave_2_c = {
			{
				"flow_event",
				flow_event_name = "chaos_hound_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				limit_spawners = 4,
				max_breed_amount = 7,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 7,
				max_breed_amount = 16,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 6,
				limit_spawners = 4,
				max_breed_amount = 12,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"close",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 7,
				max_breed_amount = 16,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 12,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_2_complete",
			},
		},
		horde_wave_3_a = {
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 1,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(3)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_3_complete",
			},
		},
		horde_wave_3_b = {
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(3)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_3_complete",
			},
		},
		horde_wave_3_c = {
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 4,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(3)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_3_complete",
			},
		},
		horde_wave_4_a = {
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 8,
				limit_spawners = 4,
				max_breed_amount = 35,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 4,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 2,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "chaos_ogryn_gunner",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_4_complete",
			},
		},
		horde_wave_4_b = {
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 12,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "cultist_berzerker",
				max_breed_amount = 5,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_4_complete",
			},
		},
		horde_wave_4_c = {
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				max_breed_amount = 1,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "cultist_mutant",
				max_breed_amount = 6,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_4_complete",
			},
		},
		horde_wave_5_a = {
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_plague_ogryn",
				max_breed_amount = 2,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_5_complete",
			},
		},
		horde_wave_5_b = {
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				max_breed_amount = 2,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_5_complete",
			},
		},
		horde_wave_5_c = {
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "cultist_mutant_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 18,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 18,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 18,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_5_complete",
			},
		},
		horde_wave_6_a = {
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 20,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 18,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 35,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 18,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 45,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_horde",
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 4,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(6)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_6_complete",
			},
		},
		horde_wave_6_b = {
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "renegade_gunner",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 7,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(6)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_6_complete",
			},
		},
		horde_wave_6_c = {
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 4,
				breed_name = "chaos_ogryn_bulwark",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_ogryn_executor",
				spawner_group = "spawner_wave_horde",
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(6)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_6_complete",
			},
		},
		horde_wave_7_a = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "renegade_rifleman",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_7_complete",
			},
		},
		horde_wave_7_b = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 35,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				limit_spawners = 4,
				max_breed_amount = 40,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "cultist_grenadier",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_7_complete",
			},
		},
		horde_wave_7_c = {
			{
				"spawn_by_points",
				breed_amount = 13,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "chaos_poxwalker_bomber_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 18,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 13,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_7_complete",
			},
		},
		horde_wave_8_a = {
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "renegade_netgunner",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "cultist_assault",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_8_complete",
			},
		},
		horde_wave_8_b = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 40,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "renegade_rifleman",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_8_complete",
			},
		},
		horde_wave_8_c = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "flamer_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "cultist_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_8_complete",
			},
		},
		horde_wave_9_a = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 6,
				max_breed_amount = 14,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				limit_spawners = 4,
				max_breed_amount = 8,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 8,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(9)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_9_complete",
			},
		},
		horde_wave_9_b = {
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				limit_spawners = 4,
				max_breed_amount = 5,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 8,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(9)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_9_complete",
			},
		},
		horde_wave_9_c = {
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 12,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 12,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 23,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 12,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 23,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_horde",
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 9,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(9)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_9_complete",
			},
		},
		horde_wave_10_a = {
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 250,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_10_complete",
			},
		},
		horde_wave_10_b = {
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 20,
				breed_name = "chaos_mutated_poxwalker",
				max_breed_amount = 30,
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 35,
				breed_name = "chaos_mutated_poxwalker",
				max_breed_amount = 50,
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 8,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_10_complete",
			},
		},
		horde_wave_10_c = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_netgunner",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "renegade_netgunner",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 15,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "renegade_netgunner",
				spawner_group = "spawner_wave_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_10_complete",
			},
		},
		horde_wave_11_a = {
			{
				"spawn_by_points",
				breed_amount = 30,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 85,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 8,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_11_complete",
			},
		},
		horde_wave_11_b = {
			{
				"spawn_by_points",
				breed_amount = 25,
				limit_spawners = 4,
				max_breed_amount = 40,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 85,
				max_breed_amount = 85,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 12,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_11_complete",
			},
		},
		horde_wave_11_c = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_11_complete",
			},
		},
		horde_wave_12_a = {
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 45,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 4,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				limit_spawners = 4,
				max_breed_amount = 10,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_daemonhost",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_12_complete",
			},
		},
		horde_wave_12_b = {
			{
				"spawn_by_points",
				breed_amount = 30,
				limit_spawners = 4,
				max_breed_amount = 55,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 6,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 80,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 40,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_12_complete",
			},
		},
		horde_wave_12_c = {
			{
				"spawn_by_points",
				breed_amount = 45,
				limit_spawners = 4,
				max_breed_amount = 55,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 5,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				max_breed_amount = 1,
				points = 10,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"captain",
					},
				},
				attack_selection_template_tag = {
					"default",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"elite",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				limit_spawners = 4,
				max_breed_amount = 50,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_12_complete",
			},
		},
		horde_wave_rooftops_1_a = {
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 15,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 2,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "cultist_berzerker",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_1_rooftops_complete",
			},
		},
		horde_wave_rooftops_1_b = {
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "renegade_rifleman",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_1_rooftops_complete",
			},
		},
		horde_wave_rooftops_1_c = {
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_1_rooftops_complete",
			},
		},
		horde_wave_rooftops_2_a = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 12,
				limit_spawners = 4,
				max_breed_amount = 12,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_2_rooftops_complete",
			},
		},
		horde_wave_rooftops_2_b = {
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 15,
				breed_name = "renegade_melee",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "cultist_assault",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_ogryn_executor",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_2_rooftops_complete",
			},
		},
		horde_wave_rooftops_2_c = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_grenadier",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_2_rooftops_complete",
			},
		},
		horde_wave_rooftops_3_a = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 2,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 3,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 3,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 4,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(3)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 300,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_3_rooftops_complete",
			},
		},
		horde_wave_rooftops_3_b = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(3)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 300,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_3_rooftops_complete",
			},
		},
		horde_wave_rooftops_3_c = {
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(3)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 300,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_3_rooftops_complete",
			},
		},
		horde_wave_rooftops_4_a = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 15,
				breed_name = "renegade_melee",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 2,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_4_rooftops_complete",
			},
		},
		horde_wave_rooftops_4_b = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "cultist_flamer",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 6,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_4_rooftops_complete",
			},
		},
		horde_wave_rooftops_4_c = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				limit_spawners = 4,
				max_breed_amount = 35,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 2,
				points = 6,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"monster",
					},
				},
				excluded_breed_tags = {
					"witch",
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_4_rooftops_complete",
			},
		},
		horde_wave_rooftops_5_a = {
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 4,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 4,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 8,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_5_rooftops_complete",
			},
		},
		horde_wave_rooftops_5_b = {
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				limit_spawners = 4,
				max_breed_amount = 3,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 15,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"ogryn",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_5_rooftops_complete",
			},
		},
		horde_wave_rooftops_5_c = {
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "cultist_mutant_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 18,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 18,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 18,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_5_rooftops_complete",
			},
		},
		horde_wave_rooftops_6_a = {
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 35,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 4,
				breed_name = "chaos_ogryn_gunner",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 4,
				breed_name = "chaos_ogryn_bulwark",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 260,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 4,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(6)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_6_rooftops_complete",
			},
		},
		horde_wave_rooftops_6_b = {
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_ogryn_bulwark",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 160,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(6)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_6_rooftops_complete",
			},
		},
		horde_wave_rooftops_6_c = {
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 45,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 50,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(6)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_6_rooftops_complete",
			},
		},
		horde_wave_rooftops_7_a = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "renegade_rifleman",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_7_rooftops_complete",
			},
		},
		horde_wave_rooftops_7_b = {
			{
				"spawn_by_points",
				breed_amount = 13,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "chaos_poxwalker_bomber_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 18,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 12,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_7_rooftops_complete",
			},
		},
		horde_wave_rooftops_7_c = {
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 12,
				breed_name = "renegade_rifleman",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_7_rooftops_complete",
			},
		},
		horde_wave_rooftops_8_a = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_8_rooftops_complete",
			},
		},
		horde_wave_rooftops_8_b = {
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "flamer_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "cultist_flamer",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_8_rooftops_complete",
			},
		},
		horde_wave_rooftops_8_c = {
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				limit_spawners = 4,
				max_breed_amount = 40,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				limit_spawners = 4,
				max_breed_amount = 40,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_8_rooftops_complete",
			},
		},
		horde_wave_rooftops_9_a = {
			{
				"spawn_by_points",
				breed_amount = 55,
				limit_spawners = 4,
				max_breed_amount = 65,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 29,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				limit_spawners = 4,
				max_breed_amount = 3,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(9)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_9_rooftops_complete",
			},
		},
		horde_wave_rooftops_9_b = {
			{
				"spawn_by_points",
				breed_amount = 25,
				limit_spawners = 4,
				max_breed_amount = 35,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(9)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_9_rooftops_complete",
			},
		},
		horde_wave_rooftops_9_c = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(9)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_9_rooftops_complete",
			},
		},
		horde_wave_rooftops_10_a = {
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 75,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "renegade_netgunner",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 75,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 75,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 75,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 12,
				breed_name = "cultist_assault",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_10_rooftops_complete",
			},
		},
		horde_wave_rooftops_10_b = {
			{
				"spawn_by_points",
				breed_amount = 45,
				limit_spawners = 4,
				max_breed_amount = 45,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 6,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 80,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				max_breed_amount = 1,
				points = 10,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"captain",
					},
				},
				attack_selection_template_tag = {
					"default",
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_10_rooftops_complete",
			},
		},
		horde_wave_rooftops_10_c = {
			{
				"spawn_by_points",
				breed_amount = 45,
				limit_spawners = 4,
				max_breed_amount = 45,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 75,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 6,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_10_rooftops_complete",
			},
		},
		horde_wave_rooftops_11_a = {
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 3,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
				excluded_breed_tags = {
					"renegade_radio_operator",
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_11_rooftops_complete",
			},
		},
		horde_wave_rooftops_11_b = {
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 55,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 85,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 7,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_11_rooftops_complete",
			},
		},
		horde_wave_rooftops_11_c = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_11_rooftops_complete",
			},
		},
		horde_wave_rooftops_12_a = {
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "cultist_berzerker",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 7,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_daemonhost",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_12_rooftops_complete",
			},
		},
		horde_wave_rooftops_12_b = {
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 100,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_12_rooftops_complete",
			},
		},
		horde_wave_rooftops_12_c = {
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_twin_captain",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_twin_captain_two",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 35,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_12_rooftops_complete",
			},
		},
		horde_wave_rooftops_1_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 4,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "cultist_berzerker",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "cultist_shocktrooper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_1_rooftops_complete",
			},
		},
		horde_wave_rooftops_1_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 4,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "renegade_rifleman",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_ogryn_executor",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "cultist_shocktrooper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_1_rooftops_complete",
			},
		},
		horde_wave_rooftops_1_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				limit_spawners = 4,
				max_breed_amount = 20,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "cultist_shocktrooper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_1_rooftops_complete",
			},
		},
		horde_wave_rooftops_2_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 12,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_2_rooftops_complete",
			},
		},
		horde_wave_rooftops_2_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 25,
				breed_name = "renegade_melee",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "cultist_assault",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 1,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "chaos_ogryn_executor",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_2_rooftops_complete",
			},
		},
		horde_wave_rooftops_2_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 4,
				breed_name = "renegade_grenadier",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_ogryn_bulwark",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_2_rooftops_complete",
			},
		},
		horde_wave_rooftops_3_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 4,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 5,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 5,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 4,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(3)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 300,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_3_rooftops_complete",
			},
		},
		horde_wave_rooftops_3_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_netgunner",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(3)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 300,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_3_rooftops_complete",
			},
		},
		horde_wave_rooftops_3_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 50,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_mutated_poxwalker",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(3)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 300,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_3_rooftops_complete",
			},
		},
		horde_wave_rooftops_4_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 15,
				breed_name = "renegade_melee",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 6,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_4_rooftops_complete",
			},
		},
		horde_wave_rooftops_4_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				limit_spawners = 4,
				max_breed_amount = 25,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "cultist_flamer",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 9,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 15,
				breed_name = "chaos_hound_mutator",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_4_rooftops_complete",
			},
		},
		horde_wave_rooftops_4_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				limit_spawners = 4,
				max_breed_amount = 35,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 2,
				points = 6,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"monster",
					},
				},
				excluded_breed_tags = {
					"witch",
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_4_rooftops_complete",
			},
		},
		horde_wave_rooftops_5_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 10,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "cultist_captain",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_5_rooftops_complete",
			},
		},
		horde_wave_rooftops_5_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				limit_spawners = 4,
				max_breed_amount = 5,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 9,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"ogryn",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_5_rooftops_complete",
			},
		},
		horde_wave_rooftops_5_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "cultist_mutant_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_5_rooftops_complete",
			},
		},
		horde_wave_rooftops_6_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 50,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "chaos_ogryn_gunner",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_ogryn_bulwark",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 260,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 4,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(6)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_6_rooftops_complete",
			},
		},
		horde_wave_rooftops_6_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_ogryn_bulwark",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "chaos_ogryn_executor",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 160,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(6)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_6_rooftops_complete",
			},
		},
		horde_wave_rooftops_6_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 50,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 35,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 65,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 40,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 65,
				breed_name = "chaos_armored_infected",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_netgunner",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(6)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_6_rooftops_complete",
			},
		},
		horde_wave_rooftops_7_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 35,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 14,
				breed_name = "renegade_rifleman",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 50,
				breed_name = "chaos_newly_infected",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_7_rooftops_complete",
			},
		},
		horde_wave_rooftops_7_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "chaos_poxwalker_bomber_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 18,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 12,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_7_rooftops_complete",
			},
		},
		horde_wave_rooftops_7_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 30,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 16,
				breed_name = "renegade_rifleman",
				limit_spawners = 4,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				limit_spawners = 4,
				max_breed_amount = 15,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 12,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_7_rooftops_complete",
			},
		},
		horde_wave_rooftops_8_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "cultist_grenadier",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_ogryn_executor",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_8_rooftops_complete",
			},
		},
		horde_wave_rooftops_8_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "flamer_wave",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "cultist_shocktrooper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 6,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "cultist_shocktrooper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 9,
				breed_name = "cultist_flamer",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "cultist_shocktrooper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "renegade_flamer",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_8_rooftops_complete",
			},
		},
		horde_wave_rooftops_8_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				limit_spawners = 4,
				max_breed_amount = 40,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 13,
				limit_spawners = 4,
				max_breed_amount = 40,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 15,
				breed_name = "renegade_sniper",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_poxwalker_bomber",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_8_rooftops_complete",
			},
		},
		horde_wave_rooftops_9_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 55,
				limit_spawners = 4,
				max_breed_amount = 100,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				limit_spawners = 4,
				max_breed_amount = 6,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(9)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_9_rooftops_complete",
			},
		},
		horde_wave_rooftops_9_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 25,
				limit_spawners = 4,
				max_breed_amount = 50,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_ogryn_gunner",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 15,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(9)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_9_rooftops_complete",
			},
		},
		horde_wave_rooftops_9_c_alt = {
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_ogryn_gunner",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 2,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"restart_when",
				duration = 500,
				target_step_index = 1,
				condition = function ()
					local game_mode_manager = Managers.state.game_mode
					local game_mode = game_mode_manager:game_mode()

					return not game_mode:is_objective_completed_for_wave(9)
				end,
				early_exit_condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_9_rooftops_complete",
			},
		},
		horde_wave_rooftops_10_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 7,
				breed_name = "renegade_netgunner",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 15,
				breed_name = "chaos_hound",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 15,
				breed_name = "cultist_mutant",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 16,
				breed_name = "cultist_assault",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_10_rooftops_complete",
			},
		},
		horde_wave_rooftops_10_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 45,
				limit_spawners = 4,
				max_breed_amount = 55,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 12,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 80,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_twin_captain",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_twin_captain_two",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_10_rooftops_complete",
			},
		},
		horde_wave_rooftops_10_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 45,
				limit_spawners = 4,
				max_breed_amount = 65,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 65,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 8,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 10,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 12,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "cultist_grenadier",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 3,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_10_rooftops_complete",
			},
		},
		horde_wave_rooftops_11_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 30,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 100,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 13,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 13,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				limit_spawners = 4,
				max_breed_amount = 50,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
				excluded_breed_tags = {
					"renegade_radio_operator",
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_11_rooftops_complete",
			},
		},
		horde_wave_rooftops_11_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 50,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 25,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"ogryn",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 4,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				limit_spawners = 4,
				max_breed_amount = 10,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_11_rooftops_complete",
			},
		},
		horde_wave_rooftops_11_c_alt = {
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"spawn_by_breed_name",
				breed_amount = 4,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_11_rooftops_complete",
			},
		},
		horde_wave_rooftops_12_a_alt = {
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 8,
				breed_name = "cultist_berzerker",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 7,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_daemonhost",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 5,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 20,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_daemonhost",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 30,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_12_rooftops_complete",
			},
		},
		horde_wave_rooftops_12_b_alt = {
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 60,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"sniper",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 15,
				limit_spawners = 4,
				max_breed_amount = 100,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 4,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_12_rooftops_complete",
			},
		},
		horde_wave_rooftops_12_c_alt = {
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 50,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 25,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"melee",
					},
				},
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_twin_captain",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_twin_captain_two",
				spawner_group = "spawner_wave_rooftops_horde",
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				limit_spawners = 4,
				max_breed_amount = 35,
				points = 1000,
				proximity_spawners = true,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 10,
				max_breed_amount = 70,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 45,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 40,
				max_breed_amount = 100,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 20,
				max_breed_amount = 45,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"melee",
					},
				},
				excluded_breed_tags = {
					"elite",
				},
			},
			{
				"spawn_by_points",
				breed_amount = 3,
				max_breed_amount = 6,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 2,
				max_breed_amount = 4,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 5,
				max_breed_amount = 10,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"close",
					},
				},
			},
			{
				"spawn_by_points",
				breed_amount = 1,
				max_breed_amount = 3,
				points = 1000,
				spawner_group = "spawner_wave_rooftops_horde",
				breed_tags = {
					{
						"elite",
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end,
			},
			{
				"lua_event",
				target_event = "event_surival_mode_tag_remaining_enemies",
			},
			{
				"continue_when",
				duration = 200,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"flow_event",
				flow_event_name = "wave_12_rooftops_complete",
			},
		},
	},
}

return template
