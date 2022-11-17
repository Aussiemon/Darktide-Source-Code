local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		fm_resurgence_wave_1 = {
			"event_luggable_resurgence_a",
			1,
			"event_luggable_resurgence_b",
			1
		},
		fm_resurgence_wave_2 = {
			"event_luggable_resurgence_c",
			1,
			"event_luggable_resurgence_d",
			1
		},
		fm_resurgence_wave_3 = {
			"event_luggable_resurgence_e",
			1,
			"event_luggable_resurgence_f",
			1
		},
		fm_resurgence_fort_wave_1 = {
			"event_fort_resurgence_a",
			1,
			"event_fort_resurgence_b",
			1
		},
		fm_resurgence_fort_wave_2 = {
			"event_fort_resurgence_c",
			1,
			"event_fort_resurgence_d",
			1
		},
		fm_resurgence_fort_wave_3 = {
			"event_fort_resurgence_e",
			1,
			"event_fort_resurgence_f",
			1
		}
	},
	events = {
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
		event_stop_trickle = {
			{
				"stop_terror_trickle"
			}
		},
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
		event_luggable_resurgence_a = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_right",
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
				spawner_group = "spawner_resurgence_upper",
				limit_spawners = 2,
				points = 6,
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
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_resurgence_right",
				template_name = "standard_melee"
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
				start_event_name = "event_luggable_resurgence_a"
			}
		},
		event_luggable_resurgence_b = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_left",
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
				spawner_group = "spawner_resurgence_upper",
				limit_spawners = 2,
				points = 6,
				breed_tags = {
					{
						"far",
						"roamer"
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_resurgence_left",
				template_name = "standard_melee"
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
				start_event_name = "event_luggable_resurgence_b"
			}
		},
		event_luggable_resurgence_c = {
			{
				"spawn_by_points",
				spawner_group = "spawner_resurgence_upper",
				limit_spawners = 1,
				points = 10,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_right",
				limit_spawners = 1,
				points = 6,
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
				"spawn_by_points",
				spawner_group = "spawner_resurgence_right",
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_resurgence_upper",
				template_name = "low_melee"
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
				start_event_name = "event_luggable_resurgence_c"
			}
		},
		event_luggable_resurgence_d = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_left",
				limit_spawners = 1,
				points = 10,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_resurgence_left",
				limit_spawners = 1,
				points = 6,
				breed_tags = {
					{
						"far",
						"roamer"
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
				"spawn_by_points",
				spawner_group = "spawner_resurgence_upper",
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_resurgence_upper",
				template_name = "low_melee"
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
				start_event_name = "event_luggable_resurgence_d"
			}
		},
		event_luggable_resurgence_e = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_right",
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
				spawner_group = "spawner_resurgence_left",
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
				spawner_group = "spawner_resurgence_right",
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_resurgence_upper",
				template_name = "low_melee"
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
				start_event_name = "event_luggable_resurgence_e"
			}
		},
		event_luggable_resurgence_f = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_resurgence_left",
				limit_spawners = 2,
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
				spawner_group = "spawner_resurgence_left",
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
				spawner_group = "spawner_resurgence_right",
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_resurgence_upper",
				template_name = "low_melee"
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
				start_event_name = "event_luggable_resurgence_f"
			}
		},
		event_luggable_finale = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_resurgence_left",
				limit_spawners = 1,
				points = 10,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_resurgence_right",
				limit_spawners = 1,
				points = 10,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 7
			}
		},
		event_bridge_reinforcements = {
			{
				"spawn_by_points",
				spawner_group = "spawner_resurgence_bridge_left",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"roamer",
						"close"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_resurgence_bridge_right",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"roamer",
						"far"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_resurgence_bridge",
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
		event_traitor_base_guards = {
			{
				"spawn_by_points",
				passive = true,
				max_breed_amount = 25,
				spawner_group = "traitor_base_guards",
				limit_spawners = 25,
				points = 8,
				breed_tags = {
					{
						"roamer",
						"far"
					}
				}
			}
		},
		event_fort_resurgence_a = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_wall",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_right",
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
				start_event_name = "event_fort_resurgence_a"
			}
		},
		event_fort_resurgence_b = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_wall",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_left",
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
				start_event_name = "event_fort_resurgence_b"
			}
		},
		event_fort_resurgence_c = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_upper",
				limit_spawners = 1,
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
				spawner_group = "spawner_fort_event_wall",
				limit_spawners = 1,
				points = 6,
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
				spawner_group = "spawner_fort_event_wall",
				template_name = "standard_melee"
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
				start_event_name = "event_fort_resurgence_c"
			}
		},
		event_fort_resurgence_d = {
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_upper",
				limit_spawners = 1,
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
				spawner_group = "spawner_fort_event_wall",
				limit_spawners = 1,
				points = 6,
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
				"spawn_by_points",
				spawner_group = "spawner_fort_event_wall",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_right",
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
				delay = 8,
				spawner_group = "spawner_fort_event_wall",
				template_name = "standard_melee"
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
				start_event_name = "event_fort_resurgence_d"
			}
		},
		event_fort_resurgence_e = {
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_wall",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_left",
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
				duration = 7
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_left",
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
				"spawn_by_points",
				spawner_group = "spawner_fort_event_upper",
				limit_spawners = 1,
				points = 12,
				breed_tags = {
					{
						"close",
						"roamer"
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
				start_event_name = "event_fort_resurgence_e"
			}
		},
		event_fort_resurgence_f = {
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_wall",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_right",
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
				duration = 7
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_right",
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
				"spawn_by_points",
				spawner_group = "spawner_fort_event_upper",
				limit_spawners = 1,
				points = 12,
				breed_tags = {
					{
						"far",
						"roamer"
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
				start_event_name = "event_fort_resurgence_f"
			}
		},
		event_fort_finale = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_right",
				limit_spawners = 1,
				points = 8,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_left",
				limit_spawners = 1,
				points = 8,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_wall",
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
				flow_event_name = "event_fort_finale_completed"
			}
		}
	}
}

return template
