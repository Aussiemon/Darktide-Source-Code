-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_dm_rise.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		dm_rise_lugging_a = {
			"lugging_trickle_a_1",
			1,
			"lugging_trickle_a_2",
			1,
			"lugging_trickle_b_1",
			1,
			"lugging_trickle_b_2",
			1,
		},
		dm_rise_hacking_a = {
			"hack_trickle_a_1",
			1,
			"hack_trickle_a_2",
			1,
		},
		dm_rise_hacking_b = {
			"hack_trickle_b_1",
			1,
			"hack_trickle_b_2",
			1,
		},
		dm_rise_demo_survival_a = {
			"demo_survival_a_1",
			1,
			"demo_survival_a_2",
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
		event_set_specials_pacing_spawner_groups = {
			{
				"delay",
				duration = 2,
			},
			{
				"set_specials_pacing_spawner_groups",
				spawner_groups = {
					"shaft_start_side_up",
					"shaft_survival_trickle",
					"shaft_end_side_up",
				},
			},
		},
		event_reset_specials_pacing_spawner_groups = {
			{
				"delay",
				duration = 2,
			},
			{
				"reset_specials_pacing_spawner_groups",
			},
		},
		lugging_trickle_a_1 = {
			{
				"delay",
				duration = 2,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "lockdown_train",
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
				duration = 12,
			},
			{
				"start_terror_trickle",
				delay = 3,
				spawner_group = "lockdown_trickle",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "lockdown_side",
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
				spawner_group = "lockdown_train",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end,
			},
			{
				"flow_event",
				flow_event_name = "dm_rise_lugging_a_completed",
			},
		},
		lugging_trickle_a_2 = {
			{
				"delay",
				duration = 2,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "lockdown_train",
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
				duration = 12,
			},
			{
				"start_terror_trickle",
				delay = 3,
				spawner_group = "lockdown_trickle",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				spawner_group = "lockdown_train",
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
				spawner_group = "lockdown_trickle",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end,
			},
			{
				"flow_event",
				flow_event_name = "dm_rise_lugging_b_completed",
			},
		},
		mid_only_trickle = {
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "lockdown_trickle",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end,
			},
		},
		lugging_trickle_b_1 = {
			{
				"delay",
				duration = 2,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				spawner_group = "lockdown_train",
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
						"scrambler",
					},
				},
			},
			{
				"delay",
				duration = 12,
			},
			{
				"start_terror_trickle",
				delay = 3,
				spawner_group = "lockdown_trickle",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "lockdown_side",
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
				spawner_group = "lockdown_train_two",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 9
				end,
			},
			{
				"flow_event",
				flow_event_name = "dm_rise_lugging_c_completed",
			},
		},
		lugging_trickle_b_2 = {
			{
				"delay",
				duration = 2,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				spawner_group = "lockdown_train",
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
				duration = 12,
			},
			{
				"start_terror_trickle",
				delay = 3,
				spawner_group = "lockdown_trickle",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 16,
				spawner_group = "lockdown_train_two",
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
				spawner_group = "lockdown_trickle",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 9
				end,
			},
			{
				"flow_event",
				flow_event_name = "dm_rise_lugging_d_completed",
			},
		},
		hack_trickle_a_1 = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				spawner_group = "lockdown_side",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "lockdown_backside",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 22,
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
				delay = 3,
				limit_spawners = 2,
				proximity_spawners = true,
				spawner_group = "lockdown_trickle",
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
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"flow_event",
				flow_event_name = "dm_rise_hacking_a_completed",
			},
		},
		hack_trickle_a_2 = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "lockdown_side",
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
				points = 6,
				spawner_group = "lockdown_side",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "lockdown_backside",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 22,
			},
			{
				"start_terror_trickle",
				delay = 3,
				limit_spawners = 2,
				proximity_spawners = true,
				spawner_group = "lockdown_trickle",
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
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"flow_event",
				flow_event_name = "dm_rise_hacking_b_completed",
			},
		},
		hack_trickle_b_1 = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "lockdown_trickle",
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
				points = 6,
				spawner_group = "lockdown_side",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "lockdown_backside",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 22,
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
				delay = 3,
				limit_spawners = 2,
				proximity_spawners = true,
				spawner_group = "lockdown_side_two",
				template_name = "standard_melee",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 16,
				spawner_group = "lockdown_backside",
				breed_tags = {
					{
						"melee",
						"horde",
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
				"flow_event",
				flow_event_name = "dm_rise_hacking_c_completed",
			},
		},
		hack_trickle_b_2 = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "lockdown_side",
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
				points = 8,
				spawner_group = "lockdown_backside",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 22,
			},
			{
				"start_terror_trickle",
				delay = 3,
				limit_spawners = 2,
				proximity_spawners = true,
				spawner_group = "lockdown_backside",
				template_name = "standard_melee",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 16,
				spawner_group = "lockdown_side",
				breed_tags = {
					{
						"far",
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
				"flow_event",
				flow_event_name = "dm_rise_hacking_d_completed",
			},
		},
		demo_survival_a_1 = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "shaft_start_side_up",
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
				points = 12,
				spawner_group = "shaft_start_side_down",
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
				spawner_group = "shaft_survival_trickle",
				template_name = "standard_melee",
			},
			{
				"delay",
				duration = 6,
			},
			{
				"continue_when",
				duration = 15,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				spawner_group = "spawner_hatch_start_side",
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
				spawner_group = "spawner_hatch_start_side",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"delay",
				duration = 25,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "shaft_start_side_up",
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
				points = 12,
				spawner_group = "shaft_start_side_up",
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
				spawner_group = "shaft_start_side_down",
				breed_tags = {
					{
						"roamer",
						"far",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "event_survive_trickle_a_1_completed",
			},
		},
		demo_survival_a_2 = {
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "shaft_end_side_up",
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
				spawner_group = "shaft_end_side_down",
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
				spawner_group = "shaft_survival_trickle",
				template_name = "standard_melee",
			},
			{
				"delay",
				duration = 6,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "shaft_start_side_up",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 15,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 8,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hatch_end_side",
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
				spawner_group = "spawner_hatch_end_side",
				breed_tags = {
					{
						"horde",
						"melee",
					},
				},
			},
			{
				"delay",
				duration = 25,
			},
			{
				"spawn_by_points",
				limit_spawners = 2,
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "shaft_start_side_up",
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
				spawner_group = "shaft_start_side_down",
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
				spawner_group = "shaft_start_side_up",
				breed_tags = {
					{
						"roamer",
						"close",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "event_survive_trickle_a_2_completed",
			},
		},
		demo_trickle_start_side_a = {
			{
				"delay",
				duration = 2,
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "shaft_survival_trickle",
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
				spawner_group = "shaft_start_side_up",
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
				points = 14,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "demo_start_side_a",
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
				flow_event_name = "event_corruptor_start_a_completed",
			},
		},
		demo_trickle_start_side_b = {
			{
				"delay",
				duration = 2,
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "shaft_survival_trickle",
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
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "demo_start_side_b",
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
				flow_event_name = "event_corruptor_start_b_completed",
			},
		},
		demo_trickle_end_side_a = {
			{
				"delay",
				duration = 2,
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "shaft_survival_trickle",
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
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "demo_end_side_a",
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
				spawner_group = "shaft_start_side_down",
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
				flow_event_name = "event_corruptor_end_a_completed",
			},
		},
		demo_trickle_end_side_b = {
			{
				"delay",
				duration = 2,
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "shaft_survival_trickle",
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
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "demo_end_side_b",
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
				flow_event_name = "event_corruptor_end_b_completed",
			},
		},
		escape_trickle_a_1 = {
			{
				"delay",
				duration = 5,
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "escape_shaft",
				template_name = "standard_melee",
			},
		},
		escape_trickle_a_2 = {
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "escape_shaft",
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
				spawner_group = "escape_shaft",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
		},
	},
}

return template
