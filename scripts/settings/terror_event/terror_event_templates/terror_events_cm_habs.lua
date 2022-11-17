local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		cm_habs_scan_1 = {
			"event_scan_habs_a",
			1,
			"event_scan_habs_b",
			1,
			"event_scan_habs_c",
			1,
			"event_scan_habs_d",
			1
		},
		cm_habs_scan_2 = {
			"event_scan_habs_e",
			1,
			"event_scan_habs_f",
			1,
			"event_scan_habs_g",
			1,
			"event_scan_habs_h",
			1,
			"event_scan_habs_i",
			1
		},
		cm_habs_hab_lobby_surprise = {
			"event_hab_lobby_a",
			1,
			"event_hab_lobby_b",
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
			},
			{
				"start_terror_event",
				start_event_name = "event_stop_scan_loop_hab_a"
			},
			{
				"start_terror_event",
				start_event_name = "event_stop_scan_loop_hab_b"
			}
		},
		event_stop_trickle = {
			{
				"stop_terror_trickle"
			},
			{
				"start_terror_event",
				start_event_name = "event_stop_scan_loop_hab_a"
			},
			{
				"start_terror_event",
				start_event_name = "event_stop_scan_loop_hab_b"
			}
		},
		event_stop_scan_loop_hab_a = {
			{
				"stop_terror_event",
				stop_event_name = "event_scan_habs_a"
			},
			{
				"stop_terror_event",
				stop_event_name = "event_scan_habs_b"
			},
			{
				"stop_terror_event",
				stop_event_name = "event_scan_habs_c"
			},
			{
				"stop_terror_event",
				stop_event_name = "event_scan_habs_d"
			}
		},
		event_stop_scan_loop_hab_b = {
			{
				"stop_terror_event",
				stop_event_name = "event_scan_habs_e"
			},
			{
				"stop_terror_event",
				stop_event_name = "event_scan_habs_f"
			},
			{
				"stop_terror_event",
				stop_event_name = "event_scan_habs_g"
			},
			{
				"stop_terror_event",
				stop_event_name = "event_scan_habs_h"
			},
			{
				"stop_terror_event",
				stop_event_name = "event_scan_habs_i"
			}
		},
		event_scan_habs_a = {
			{
				"freeze_specials_pacing",
				enabled = true
			},
			{
				"delay",
				duration = 8
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_habs_close",
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
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
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
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"freeze_specials_pacing",
				enabled = false
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_habs_scan_1"
			}
		},
		event_scan_habs_b = {
			{
				"freeze_specials_pacing",
				enabled = true
			},
			{
				"delay",
				duration = 8
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_habs_close",
				limit_spawners = 3,
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
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_habs_close",
				limit_spawners = 3,
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
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_habs_close",
				limit_spawners = 3,
				points = 5,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				max_breed_amount = 1,
				spawner_group = "spawner_habs_close",
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
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 7
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
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"freeze_specials_pacing",
				enabled = false
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_habs_scan_1"
			}
		},
		event_scan_habs_c = {
			{
				"freeze_specials_pacing",
				enabled = true
			},
			{
				"delay",
				duration = 8
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_habs_far",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_habs_far",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_habs_far",
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
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 7
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
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"freeze_specials_pacing",
				enabled = false
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_habs_scan_1"
			}
		},
		event_scan_habs_d = {
			{
				"freeze_specials_pacing",
				enabled = true
			},
			{
				"delay",
				duration = 8
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
				duration = 8
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
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_habs_far",
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
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"freeze_specials_pacing",
				enabled = false
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_habs_scan_1"
			}
		},
		event_scan_habs_e = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_habs_end_west",
				limit_spawners = 3,
				points = 26,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 6
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_habs_end",
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_habs_end",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 23
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_habs_scan_2"
			}
		},
		event_scan_habs_f = {
			{
				"spawn_by_points",
				spawner_group = "spawner_habs_end_east",
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
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_habs_end_east",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"delay",
				duration = 8
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_habs_end",
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_habs_end",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 23
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_habs_scan_2"
			}
		},
		event_scan_habs_g = {
			{
				"spawn_by_points",
				spawner_group = "spawner_habs_end_south",
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
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_habs_end_south",
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
				"delay",
				duration = 6
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_habs_end",
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_habs_end",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 23
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_habs_scan_2"
			}
		},
		event_scan_habs_h = {
			{
				"delay",
				duration = 3
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_habs_end",
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
				duration = 3
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_habs_end_east",
				limit_spawners = 3,
				points = 22,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_habs_end",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 17
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_habs_scan_2"
			}
		},
		event_scan_habs_i = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_habs_end_west",
				limit_spawners = 3,
				points = 26,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 6
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_habs_pipes_sniper",
				max_breed_amount = 1,
				points = 8,
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
				spawner_group = "spawner_habs_end",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 23
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "cm_habs_scan_2"
			}
		},
		event_hab_lobby_a = {
			{
				"debug_print",
				text = "event_hab_lobby_a",
				duration = 3
			},
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hab_lobby",
				limit_spawners = 1,
				points = 10,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			}
		},
		event_hab_lobby_b = {
			{
				"debug_print",
				text = "event_hab_lobby_b",
				duration = 3
			},
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hab_lobby",
				limit_spawners = 1,
				points = 12,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			}
		},
		event_habs_escape = {
			{
				"continue_when",
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 22
				end
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_habs_escape_chasers",
				limit_spawners = 2,
				points = 13,
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
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_habs_escape_completed"
			}
		},
		event_habs_escape_stoppers = {
			{
				"spawn_by_points",
				spawner_group = "spawner_habs_escape_stoppers",
				limit_spawners = 2,
				points = 7,
				breed_tags = {
					{
						"melee",
						"roamer"
					},
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"delay",
				duration = 6
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end
			},
			{
				"flow_event",
				flow_event_name = "event_habs_escape_stoppers_completed"
			}
		},
		event_habs_escape_guard = {
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_habs_escape_guard",
				points = 6,
				breed_tags = {
					{
						"elite",
						"melee"
					}
				}
			},
			{
				"delay",
				duration = 6
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
		}
	}
}

return template
