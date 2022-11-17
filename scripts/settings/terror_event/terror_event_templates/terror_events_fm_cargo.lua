local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		fm_cargo_hacking_wave_1 = {
			"event_hacking_cargo_a",
			1,
			"event_hacking_cargo_c",
			1
		},
		fm_cargo_hacking_wave_2 = {
			"event_hacking_cargo_b",
			1,
			"event_hacking_cargo_d",
			1
		},
		fm_cargo_fortification_wave_1 = {
			"event_fortification_a",
			1,
			"event_fortification_b",
			1,
			"event_fortification_c",
			1,
			"event_fortification_d",
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
				"set_pacing_enabled",
				enabled = true
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
		event_hacking_cargo_a = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
				end
			},
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_a",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_cargo_a",
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
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			},
			{
				"delay",
				duration = 8
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_hacking_cargo_a",
				template_name = "standard_melee"
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_hacking_cargo_special_1",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 8
				end
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_b",
				limit_spawners = 3,
				points = 25,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 10
			}
		},
		event_hacking_cargo_b = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
				end
			},
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_b",
				limit_spawners = 3,
				points = 25,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 8
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_hacking_cargo_b",
				template_name = "standard_melee"
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_hacking_cargo_special_3",
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
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 8
				end
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_d",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 10
			}
		},
		event_hacking_cargo_c = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
				end
			},
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_c",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_cargo_c",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			},
			{
				"delay",
				duration = 8
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_hacking_cargo_c",
				template_name = "standard_melee"
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_hacking_cargo_special_1",
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
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 8
				end
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_c",
				limit_spawners = 3,
				points = 14,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			}
		},
		event_hacking_cargo_d = {
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 15
				end
			},
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_cargo_a",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_cargo_a",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			},
			{
				"delay",
				duration = 8
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_hacking_cargo_d",
				template_name = "standard_melee"
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_hacking_cargo_special_2",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 8
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_cargo_d",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
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
		event_fortification_guard_a = {
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_fortification_guard_elite_a",
				points = 6,
				breed_tags = {
					{
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 2,
				max_breed_amount = 2,
				spawner_group = "spawner_fortification_guard_a",
				points = 3,
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
		event_fortification_guard_b = {
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_fortification_guard_elite_b",
				points = 6,
				breed_tags = {
					{
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 2,
				max_breed_amount = 2,
				spawner_group = "spawner_fortification_guard_b",
				points = 3,
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
		event_fortification_guard_c = {
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_fortification_guard_elite_c",
				points = 6,
				breed_tags = {
					{
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 2,
				max_breed_amount = 2,
				spawner_group = "spawner_fortification_guard_c",
				points = 3,
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
		event_fortification_guard_d = {
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_fortification_guard_elite_d",
				points = 6,
				breed_tags = {
					{
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 2,
				max_breed_amount = 2,
				spawner_group = "spawner_fortification_guard_d",
				points = 3,
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
		event_fortification_horde_a = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_horde_a",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 30,
				breed_tags = {
					{
						"horde"
					}
				}
			}
		},
		event_fortification_horde_b = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_horde_b",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 30,
				breed_tags = {
					{
						"horde"
					}
				}
			}
		},
		event_fortification_horde_c = {
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_horde_a",
				points = 30,
				breed_tags = {
					{
						"horde"
					}
				}
			},
			{
				"continue_when",
				duration = 300,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 2
				end
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_final_completed"
			}
		},
		event_fortification_elite_a = {
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_elite_a",
				max_breed_amount = 3,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 26,
				breed_tags = {
					{
						"elite"
					}
				}
			},
			{
				"continue_when",
				duration = 300,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 2
				end
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_final_completed"
			}
		},
		event_fortification_a = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_cargo_south_a",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_cargo_south_a",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_cargo_south_a",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_cargo_special_1",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"delay",
				duration = 4
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_cargo_sniper_1",
				max_breed_amount = 1,
				points = 8,
				breed_tags = {
					{
						"special",
						"sniper"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_fortification_cargo_south_a",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 6
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_cargo_fortification_wave_1"
			}
		},
		event_fortification_b = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_cargo_north_a",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_cargo_north_b",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_cargo_special_2",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"delay",
				duration = 4
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_cargo_sniper_2",
				max_breed_amount = 1,
				points = 8,
				breed_tags = {
					{
						"special",
						"sniper"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_fortification_cargo_north_c",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 6
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_cargo_fortification_wave_1"
			}
		},
		event_fortification_c = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_cargo_north_a",
				limit_spawners = 3,
				points = 16,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_cargo_north_b",
				limit_spawners = 3,
				points = 14,
				breed_tags = {
					{
						"close",
						"elite"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_cargo_special_2",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"delay",
				duration = 4
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_cargo_sniper_2",
				max_breed_amount = 1,
				points = 8,
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_fortification_cargo_north_a",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 6
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_cargo_fortification_wave_1"
			}
		},
		event_fortification_d = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_horde_b",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 30,
				breed_tags = {
					{
						"horde"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_cargo_special_1",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			},
			{
				"delay",
				duration = 4
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_cargo_special_1",
				max_breed_amount = 1,
				points = 8,
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_fortification_cargo_south_a",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 6
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_cargo_fortification_wave_1"
			}
		}
	}
}

return template
