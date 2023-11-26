-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_dm_stockpile.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		dm_stockpile_demo_wave_1 = {
			"event_demo_stockpile_a",
			1,
			"event_demo_stockpile_b",
			1,
			"event_demo_stockpile_c",
			1
		},
		dm_stockpile_demo_wave_2 = {
			"event_demo_stockpile_d",
			1,
			"event_demo_stockpile_e",
			1,
			"event_demo_stockpile_f",
			1
		},
		dm_stockpile_mid_event_1 = {
			"event_mid_stockpile_a",
			1,
			"event_mid_stockpile_b",
			1
		},
		dm_stockpile_mid_event_2 = {
			"event_mid_stockpile_c",
			1,
			"event_mid_stockpile_d",
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
					"monsters",
					"specials"
				}
			},
			{
				"stop_terror_trickle"
			}
		},
		event_mid_stockpile_a = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_stockpile_elevator_far",
				limit_spawners = 3,
				points = 14,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_stockpile_elevator_far",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_stockpile_elevator_far",
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
				"delay",
				duration = 6
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_stockpile_elevator_close_special",
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
				delay = 4,
				spawner_group = "spawner_stockpile_elevator_far",
				template_name = "low_melee"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end
			},
			{
				"delay",
				duration = 6
			},
			{
				"start_random_terror_event",
				start_event_name = "dm_stockpile_mid_event_1"
			}
		},
		event_mid_stockpile_b = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_stockpile_elevator_far",
				limit_spawners = 3,
				points = 20,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_stockpile_elevator_far",
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
				duration = 6
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_stockpile_elevator_far",
				limit_spawners = 3,
				points = 15,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_stockpile_elevator_close_special",
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
				delay = 4,
				spawner_group = "spawner_stockpile_elevator_far",
				template_name = "low_melee"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end
			},
			{
				"delay",
				duration = 6
			},
			{
				"start_random_terror_event",
				start_event_name = "dm_stockpile_mid_event_1"
			}
		},
		event_mid_stockpile_c = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_stockpile_elevator_far",
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
				spawner_group = "spawner_stockpile_elevator_far",
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
				spawner_group = "spawner_stockpile_elevator_close_special",
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
				delay = 4,
				spawner_group = "spawner_stockpile_elevator_close",
				template_name = "low_melee"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end
			},
			{
				"delay",
				duration = 6
			},
			{
				"start_random_terror_event",
				start_event_name = "dm_stockpile_mid_event_2"
			}
		},
		event_mid_stockpile_d = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_stockpile_elevator_close",
				limit_spawners = 3,
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
				spawner_group = "spawner_stockpile_elevator_close",
				limit_spawners = 3,
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
				spawner_group = "spawner_stockpile_elevator_close",
				limit_spawners = 3,
				points = 6,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_stockpile_elevator_close",
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
				"delay",
				duration = 6
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_stockpile_elevator_far",
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
				delay = 4,
				spawner_group = "spawner_stockpile_elevator_close",
				template_name = "low_melee"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end
			},
			{
				"delay",
				duration = 6
			},
			{
				"start_random_terror_event",
				start_event_name = "dm_stockpile_mid_event_2"
			}
		},
		event_demo_stockpile_a = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_stockpile_left",
				limit_spawners = 3,
				points = 7,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_stockpile_left",
				limit_spawners = 3,
				points = 7,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_stockpile_left",
				limit_spawners = 3,
				points = 7,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_stockpile_left",
				limit_spawners = 3,
				points = 6,
				breed_tags = {
					{
						"melee"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_stockpile_left",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end
			},
			{
				"delay",
				duration = 8
			},
			{
				"start_random_terror_event",
				start_event_name = "dm_stockpile_demo_wave_1"
			}
		},
		event_demo_stockpile_b = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_stockpile_forward",
				limit_spawners = 3,
				points = 20,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_stockpile_left",
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
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_stockpile_forward",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end
			},
			{
				"delay",
				duration = 8
			},
			{
				"start_random_terror_event",
				start_event_name = "dm_stockpile_demo_wave_1"
			}
		},
		event_demo_stockpile_c = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_stockpile_right",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_stockpile_right",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_stockpile_right",
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
				spawner_group = "spawner_stockpile_forward",
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
				duration = 6
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_stockpile_right",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end
			},
			{
				"delay",
				duration = 8
			},
			{
				"start_random_terror_event",
				start_event_name = "dm_stockpile_demo_wave_1"
			}
		},
		event_demo_stockpile_d = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_stockpile_left",
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
				spawner_group = "spawner_stockpile_right",
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
				"try_inject_special_minion",
				spawner_group = "spawner_stockpile_forward",
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
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_stockpile_left",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end
			},
			{
				"delay",
				duration = 8
			},
			{
				"start_random_terror_event",
				start_event_name = "dm_stockpile_demo_wave_2"
			}
		},
		event_demo_stockpile_e = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_stockpile_forward",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_stockpile_forward",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_stockpile_forward",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_stockpile_forward",
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
				duration = 1
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_stockpile_left",
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
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_stockpile_forward",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end
			},
			{
				"delay",
				duration = 8
			},
			{
				"start_random_terror_event",
				start_event_name = "dm_stockpile_demo_wave_2"
			}
		},
		event_demo_stockpile_f = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_stockpile_right",
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
				spawner_group = "spawner_stockpile_right",
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
				duration = 4
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_stockpile_right",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 4
				end
			},
			{
				"delay",
				duration = 8
			},
			{
				"start_random_terror_event",
				start_event_name = "dm_stockpile_demo_wave_2"
			}
		},
		event_demo_stockpile_horde_escape = {
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_stockpile_forward",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 15,
				breed_tags = {
					{
						"horde"
					}
				}
			}
		}
	}
}

return template
