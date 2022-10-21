local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		lm_cooling_wave_1 = {
			"event_hacking_cooling_a",
			1,
			"event_hacking_cooling_b",
			1
		},
		lm_cooling_wave_2 = {
			"event_hacking_cooling_c",
			1,
			"event_hacking_cooling_d",
			1
		},
		lm_cooling_wave_3 = {
			"event_hacking_cooling_e",
			1,
			"event_hacking_cooling_f",
			1
		},
		lm_cooling_reactor_1 = {
			"event_reactor_cooling_a",
			1
		},
		lm_cooling_reactor_2 = {
			"event_reactor_cooling_b",
			1
		},
		lm_cooling_reactor_3 = {
			"event_reactor_cooling_c",
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
		event_only_specials_enabled = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
					"monsters"
				}
			}
		},
		event_stop_trickle = {
			{
				"stop_terror_trickle"
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
		event_hacking_cooling_outside_guards = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				passive = true,
				max_breed_amount = 25,
				spawner_group = "spawner_control_room_guards",
				limit_spawners = 25,
				points = 8,
				breed_tags = {
					{
						"roamer",
						"melee"
					}
				}
			}
		},
		event_hacking_cooling_a = {
			{
				"debug_print",
				text = "event_hacking_cooling_a",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_close",
				limit_spawners = 3,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 24,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_cooling_hacking_close",
				template_name = "standard_melee"
			}
		},
		event_hacking_cooling_b = {
			{
				"debug_print",
				text = "event_hacking_cooling_b",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_close",
				limit_spawners = 3,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 24,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_cooling_hacking_close",
				template_name = "low_ranged"
			}
		},
		event_hacking_cooling_c = {
			{
				"debug_print",
				text = "event_hacking_cooling_c",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_far",
				limit_spawners = 3,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 20,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_far",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"far",
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
						"disabler"
					}
				}
			},
			{
				"delay",
				duration = 7
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_close",
				limit_spawners = 3,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				delay = 8,
				spawner_group = "spawner_cooling_hacking_far",
				template_name = "standard_melee"
			}
		},
		event_hacking_cooling_d = {
			{
				"debug_print",
				text = "event_hacking_cooling_d",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_far",
				limit_spawners = 3,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 20,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_far",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			},
			{
				"delay",
				duration = 7
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
				spawner_group = "spawner_cooling_hacking_close",
				limit_spawners = 3,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				delay = 8,
				spawner_group = "spawner_cooling_hacking_far",
				template_name = "low_ranged"
			}
		},
		event_hacking_cooling_e = {
			{
				"debug_print",
				text = "event_hacking_cooling_e",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_close",
				limit_spawners = 3,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 30,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_close",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_close",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"melee",
						"elite"
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
				"delay",
				duration = 7
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_cooling_hacking_far",
				template_name = "low_ranged"
			}
		},
		event_hacking_cooling_f = {
			{
				"debug_print",
				text = "event_hacking_cooling_f",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_close",
				limit_spawners = 3,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 30,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_close",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_hacking_close",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"melee",
						"elite"
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
				"delay",
				duration = 7
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_cooling_hacking_close",
				template_name = "standard_melee"
			}
		},
		event_reactor_outside_guards = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				passive = true,
				max_breed_amount = 25,
				spawner_group = "spawner_reactor_guards",
				limit_spawners = 25,
				points = 8,
				breed_tags = {
					{
						"roamer",
						"melee"
					}
				}
			}
		},
		event_reactor_cooling_a = {
			{
				"debug_print",
				text = "event_reactor_cooling_a",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_reactor_1",
				limit_spawners = 3,
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
				spawner_group = "spawner_cooling_reactor_1",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 12
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_cooling_reactor_1",
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
				duration = 12
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_reactor_1",
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
				duration = 12
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_cooling_reactor_1",
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
				duration = 12
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"start_terror_event",
				start_event_name = "event_reactor_cooling_a"
			}
		},
		event_reactor_cooling_b = {
			{
				"debug_print",
				text = "event_reactor_cooling_b",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_reactor_1",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_cooling_reactor_1",
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
				duration = 7
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_reactor_1",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_cooling_reactor_1",
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			}
		},
		event_reactor_cooling_c = {
			{
				"debug_print",
				text = "event_reactor_cooling_c",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_reactor_1",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_cooling_reactor_1",
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
				duration = 7
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_reactor_1",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_cooling_reactor_1",
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			}
		},
		event_reactor_finale = {
			{
				"debug_print",
				text = "event_reactor_finale",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_reactor_1",
				limit_spawners = 3,
				points = 24,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_reactor_1",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"delay",
				duration = 5
			},
			{
				"continue_when",
				duration = 300,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "event_reactor_finale_completed"
			}
		},
		event_cooling_end = {
			{
				"spawn_by_points",
				spawner_group = "spawner_cooling_end",
				limit_spawners = 1,
				points = 12,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"debug_print",
				text = "event_cooling_end",
				duration = 3
			}
		}
	}
}

return template
