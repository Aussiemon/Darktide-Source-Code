local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		km_station_hacking_wave_1 = {
			"event_hacking_a_1",
			1,
			"event_hacking_a_2",
			1,
			"event_hacking_a_3",
			1
		},
		km_station_hacking_wave_2 = {
			"event_hacking_b_1",
			1,
			"event_hacking_b_2",
			1,
			"event_hacking_b_3",
			1
		},
		km_station_hacking_wave_3 = {
			"event_hacking_c_1",
			1,
			"event_hacking_c_2",
			1,
			"event_hacking_c_3",
			1
		},
		km_station_kill_target_wave = {
			"km_station_kill_target_wave_1",
			1,
			"km_station_kill_target_wave_2",
			1,
			"km_station_kill_target_wave_3",
			1
		}
	},
	events = {
		event_pacing_off = {
			{
				"set_pacing_enabled",
				enabled = false
			}
		},
		event_pacing_on = {
			{
				"set_pacing_enabled",
				enabled = true
			}
		},
		event_hordes_off = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes"
				}
			}
		},
		event_hordes_on = {
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes"
				}
			}
		},
		event_only_roamers_specials_enabled = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"trickle_hordes"
				}
			}
		},
		event_only_specials_enabled = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes"
				}
			}
		},
		event_pacing_on_stop_trickle = {
			{
				"stop_terror_trickle"
			},
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
					"specials",
					"monsters"
				}
			}
		},
		event_hacking_a_1 = {
			{
				"delay",
				duration = 2
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_market_far",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end
			},
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_a_1_completed"
			}
		},
		event_hacking_a_2 = {
			{
				"delay",
				duration = 2
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_market_far",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_market_close_right",
				limit_spawners = 2,
				points = 12,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_right",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"close",
						"elite"
					}
				}
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_right",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_a_2_completed"
			}
		},
		event_hacking_a_3 = {
			{
				"delay",
				duration = 2
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_market_far",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 12,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 5,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 4
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 5,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 4
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 5,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 4
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_a_3_completed"
			}
		},
		event_hacking_b_1 = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 6,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 4
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 6,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 4
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 6,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 4
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_market_far",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 7
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 6,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_b_1_completed"
			}
		},
		event_hacking_b_2 = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_market_far",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 7
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"close",
						"elite"
					}
				}
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_b_2_completed"
			}
		},
		event_hacking_b_3 = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_market_close_right",
				limit_spawners = 2,
				points = 12,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_right",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"close",
						"elite"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_market_far",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 7
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_right",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
						"disabler"
					}
				}
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_b_3_completed"
			}
		},
		event_hacking_c_1 = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 20,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_market_far",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 7
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
						"disabler"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 12,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_c_1_completed"
			}
		},
		event_hacking_c_2 = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_market_close_right",
				limit_spawners = 2,
				points = 10,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_left",
				limit_spawners = 2,
				points = 12,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 4
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_market_far",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_right",
				limit_spawners = 3,
				points = 6,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_c_2_completed"
			}
		},
		event_hacking_c_3 = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_market_close_right",
				limit_spawners = 2,
				points = 12,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_right",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"close",
						"elite"
					}
				}
			},
			{
				"delay",
				duration = 4
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_market_far",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
						"disabler"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_market_close_right",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_c_3_completed"
			}
		},
		event_hacking_transit_guard = {
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 3,
				max_breed_amount = 3,
				spawner_group = "spawner_station_hacking_elite",
				points = 15,
				breed_tags = {
					{
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 12,
				max_breed_amount = 9,
				spawner_group = "spawner_station_hacking_guard",
				points = 12,
				breed_tags = {
					{
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 3
			}
		},
		km_station_kill_target = {
			{
				"spawn_by_points",
				mission_objective_id = "objective_km_station_eliminate_target",
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_platform_target",
				points = 10,
				breed_tags = {
					{
						"captain"
					}
				},
				attack_selection_template_tag = {
					"default"
				}
			},
			{
				"debug_print",
				text = "Kill event: Target spawned",
				duration = 3
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_random_terror_event",
				start_event_name = "km_station_kill_target_wave"
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_platform_reinforcements_middle",
				template_name = "low_melee"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"stop_terror_trickle"
			},
			{
				"flow_event",
				flow_event_name = "platform_kill_target_dead"
			}
		},
		km_station_kill_target_wave_1 = {
			{
				"debug_print",
				text = "event_kill_target_wave",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_platform_reinforcements_middle",
				limit_spawners = 3,
				points = 20,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_platform_reinforcements_left",
				limit_spawners = 3,
				points = 15,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_random_terror_event",
				start_event_name = "km_station_kill_target_wave"
			}
		},
		km_station_kill_target_wave_2 = {
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_platform_reinforcements_left",
				limit_spawners = 3,
				points = 6,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_platform_reinforcements_right",
				limit_spawners = 3,
				points = 16,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_platform_reinforcements_left",
				limit_spawners = 3,
				points = 16,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_random_terror_event",
				start_event_name = "km_station_kill_target_wave"
			}
		},
		km_station_kill_target_wave_3 = {
			{
				"spawn_by_points",
				spawner_group = "spawner_platform_reinforcements_right",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"close",
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_platform_reinforcements_right",
				limit_spawners = 3,
				points = 14,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
						"disabler"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_platform_reinforcements_middle",
				limit_spawners = 3,
				points = 16,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_random_terror_event",
				start_event_name = "km_station_kill_target_wave"
			}
		},
		km_station_kill_target_reinforcements = {
			{
				"delay",
				duration = 5
			}
		},
		km_station_kill_target_guards = {
			{
				"delay",
				duration = 5
			}
		},
		km_station_end_event = {
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "kill_event_finished"
			}
		}
	}
}

return template
