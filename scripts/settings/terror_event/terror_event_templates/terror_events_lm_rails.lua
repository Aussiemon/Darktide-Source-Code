local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		lm_rails_hacking_trickle_a = {
			"hack_trickle_a_1",
			1,
			"hack_trickle_a_2",
			1
		},
		lm_rails_hacking_trickle_b = {
			"hack_trickle_b_1",
			1,
			"hack_trickle_b_2",
			1
		},
		lm_rails_hacking_trickle_c = {
			"hack_trickle_c_1",
			1,
			"hack_trickle_c_2",
			1
		},
		lm_rails_luggable_wave_1 = {
			"event_luggable_rails_start_wave",
			1
		},
		lm_rails_luggable_wave_looping = {
			"event_luggable_rails_looping_a",
			1,
			"event_luggable_rails_looping_b",
			1,
			"event_luggable_rails_looping_c",
			1,
			"event_luggable_rails_looping_d",
			1
		},
		lm_rails_luggable_wave_2 = {
			"event_luggable_rails_d",
			1,
			"event_luggable_rails_e",
			1,
			"event_luggable_rails_f",
			1
		},
		lm_rails_luggable_wave_3 = {
			"event_luggable_rails_g",
			1,
			"event_luggable_rails_h",
			1,
			"event_luggable_rails_i",
			1
		},
		lm_rails_luggable_null = {
			"event_rails_luggable_null",
			1
		},
		lm_rails_outside_guards = {
			"event_luggable_rails_outside_guards",
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
					"trickle_hordes",
					"monsters"
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
					"trickle_hordes",
					"monsters"
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
		hack_trickle_a_1 = {
			{
				"debug_print",
				text = "event_hacking_a",
				duration = 1.5
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_elevator_shaft_a",
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
				duration = 5
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_elevator_shaft_a",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_elevator_shaft_b",
				limit_spawners = 3,
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
				spawner_group = "spawner_elevator_shaft_b",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"close",
						"elite"
					}
				}
			}
		},
		hack_trickle_a_2 = {
			{
				"debug_print",
				text = "event_hacking_a",
				duration = 1.5
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_elevator_shaft_a",
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
				duration = 5
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_elevator_shaft_a",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_elevator_shaft_b",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_elevator_shaft_b",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			}
		},
		hack_trickle_b_1 = {
			{
				"debug_print",
				text = "event_hacking_b",
				duration = 3
			},
			{
				"continue_when",
				duration = 80,
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
				spawner_group = "spawner_elevator_shaft_a",
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_elevator_shaft_a",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_elevator_shaft_b",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			}
		},
		hack_trickle_b_2 = {
			{
				"debug_print",
				text = "event_hacking_b",
				duration = 3
			},
			{
				"continue_when",
				duration = 80,
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
				spawner_group = "spawner_elevator_shaft_b",
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_elevator_shaft_b",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_elevator_shaft_b",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"close",
						"elite"
					}
				}
			}
		},
		hack_trickle_c_1 = {
			{
				"debug_print",
				text = "event_hacking_c",
				duration = 1
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_elevator_shaft_a",
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
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			}
		},
		hack_trickle_c_2 = {
			{
				"debug_print",
				text = "event_hacking_c",
				duration = 1
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_elevator_shaft_b",
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
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
						"disabler"
					}
				}
			}
		},
		event_luggable_rails_guard_left = {
			{
				"spawn_by_points",
				passive = true,
				max_breed_amount = 1,
				spawner_group = "spawner_rails_guard_left",
				limit_spawners = 1,
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
				passive = true,
				max_breed_amount = 1,
				spawner_group = "spawner_rails_guard_left_back",
				limit_spawners = 1,
				points = 6,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			}
		},
		event_luggable_rails_guard_right = {
			{
				"spawn_by_points",
				passive = true,
				max_breed_amount = 1,
				spawner_group = "spawner_rails_guard_right",
				limit_spawners = 1,
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
				passive = true,
				max_breed_amount = 1,
				spawner_group = "spawner_rails_guard_right_back",
				limit_spawners = 1,
				points = 6,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			}
		},
		event_luggable_rails_start_wave = {
			{
				"delay",
				duration = 0.5
			},
			{
				"start_random_terror_event",
				start_event_name = "lm_rails_outside_guards"
			},
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_rails_west",
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
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_rails_east",
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
				"try_inject_special_minion",
				points = 6,
				max_breed_amount = 1,
				spawner_group = "spawner_rails_trickle",
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			},
			{
				"start_terror_trickle",
				spawner_group = "spawner_rails_trickle",
				proximity_spawners = true,
				template_name = "standard_melee",
				delay = 8,
				limit_spawners = 2
			},
			{
				"delay",
				duration = 32
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
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "lm_rails_luggable_wave_looping"
			}
		},
		event_luggable_rails_outside_guards = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				passive = true,
				max_breed_amount = 14,
				spawner_group = "spawner_rails_guard_outside",
				limit_spawners = 14,
				points = 20,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 5
			}
		},
		event_luggable_rails_looping_a = {
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_rails_control",
				limit_spawners = 3,
				points = 24,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"try_inject_special_minion",
				points = 6,
				max_breed_amount = 1,
				spawner_group = "spawner_rails_trickle",
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			},
			{
				"start_terror_trickle",
				spawner_group = "spawner_rails_trickle",
				proximity_spawners = true,
				template_name = "standard_melee",
				delay = 8,
				limit_spawners = 2
			},
			{
				"delay",
				duration = 32
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
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "lm_rails_luggable_wave_looping"
			}
		},
		event_luggable_rails_looping_b = {
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_rails_west",
				limit_spawners = 3,
				points = 24,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"try_inject_special_minion",
				points = 6,
				max_breed_amount = 1,
				spawner_group = "spawner_rails_trickle",
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			},
			{
				"start_terror_trickle",
				spawner_group = "spawner_rails_trickle",
				proximity_spawners = true,
				template_name = "standard_melee",
				delay = 8,
				limit_spawners = 2
			},
			{
				"delay",
				duration = 32
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
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "lm_rails_luggable_wave_looping"
			}
		},
		event_luggable_rails_looping_c = {
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_rails_east",
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
				"try_inject_special_minion",
				points = 12,
				max_breed_amount = 1,
				spawner_group = "spawner_rails_trickle",
				breed_tags = {
					{
						"special",
						"disabler"
					}
				}
			},
			{
				"start_terror_trickle",
				spawner_group = "spawner_rails_trickle",
				proximity_spawners = true,
				template_name = "standard_melee",
				delay = 8,
				limit_spawners = 2
			},
			{
				"delay",
				duration = 32
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
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "lm_rails_luggable_wave_looping"
			}
		},
		event_luggable_rails_looping_d = {
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_rails_west",
				limit_spawners = 3,
				points = 24,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_west",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"close",
						"elite"
					}
				}
			},
			{
				"start_terror_trickle",
				spawner_group = "spawner_rails_trickle",
				proximity_spawners = true,
				template_name = "standard_melee",
				delay = 8,
				limit_spawners = 2
			},
			{
				"delay",
				duration = 32
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
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "lm_rails_luggable_wave_looping"
			}
		},
		event_luggable_rails_d = {
			{
				"debug_print",
				text = "event_luggable_rails_d",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_far",
				limit_spawners = 3,
				points = 24,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_far",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			}
		},
		event_luggable_rails_e = {
			{
				"debug_print",
				text = "event_luggable_rails_e",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_far",
				limit_spawners = 3,
				points = 24,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_far",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			}
		},
		event_luggable_rails_f = {
			{
				"debug_print",
				text = "event_luggable_rails_f",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_far",
				limit_spawners = 3,
				points = 24,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_far",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			}
		},
		event_luggable_rails_g = {
			{
				"debug_print",
				text = "event_luggable_rails_g",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_close",
				limit_spawners = 3,
				points = 35,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_far",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			}
		},
		event_luggable_rails_h = {
			{
				"debug_print",
				text = "event_luggable_rails_h",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_close",
				limit_spawners = 3,
				points = 35,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_far",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			}
		},
		event_luggable_rails_i = {
			{
				"debug_print",
				text = "event_luggable_rails_h",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_close",
				limit_spawners = 3,
				points = 35,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_rails_far",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			}
		},
		event_rails_luggable_null = {
			{
				"debug_print",
				text = "lm_rails_luggable_null",
				duration = 3
			}
		}
	}
}

return template
