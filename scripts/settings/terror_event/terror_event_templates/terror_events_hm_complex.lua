-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_hm_complex.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		hm_complex_wave_1 = {
			"event_elevator_complex_horde_right",
			1,
			"event_elevator_complex_horde_left",
			1
		},
		hm_complex_wave_2 = {
			"event_elevator_complex_close_right",
			1,
			"event_elevator_complex_ranged_left",
			1,
			"event_elevator_complex_close_left",
			1,
			"event_elevator_complex_ranged_right",
			1
		},
		hm_complex_hacking_wave_1 = {
			"event_hacking_complex_a",
			1,
			"event_hacking_complex_b",
			1,
			"event_hacking_complex_c",
			1,
			"event_hacking_complex_d",
			1,
			"event_hacking_complex_e",
			1,
			"event_hacking_complex_f",
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
					"trickle_hordes"
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
		event_complex_midevent_guard = {
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 7,
				max_breed_amount = 7,
				spawner_group = "spawner_complex_midevent_guard",
				points = 14,
				breed_tags = {
					{
						"roamer"
					}
				}
			}
		},
		event_elevator_complex_horde_right = {
			{
				"delay",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_complex_upper_right",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 25,
				breed_tags = {
					{
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_complex_elevator_right",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_complex_close_right",
				template_name = "standard_melee"
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_complex_horde_completed"
			}
		},
		event_elevator_complex_horde_left = {
			{
				"delay",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_complex_upper_left",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				points = 25,
				breed_tags = {
					{
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_complex_close_right",
				template_name = "standard_melee"
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_complex_horde_completed"
			}
		},
		event_elevator_complex_close_right = {
			{
				"delay",
				duration = 5
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_complex_elevator_right",
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
				"spawn_by_points",
				spawner_group = "spawner_complex_far_right",
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
				"delay",
				duration = 7
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_complex_special_far",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
						"sniper"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_complex_close_right",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_complex_mid_completed"
			}
		},
		event_elevator_complex_close_left = {
			{
				"delay",
				duration = 5
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_complex_elevator_left",
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
				"spawn_by_points",
				spawner_group = "spawner_complex_far_left",
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
				"delay",
				duration = 7
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_complex_special_far",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
						"sniper"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_complex_close_left",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_complex_mid_completed"
			}
		},
		event_elevator_complex_ranged_right = {
			{
				"delay",
				duration = 5
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_complex_upper_right",
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
				spawner_group = "spawner_complex_far_right",
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
				spawner_group = "spawner_complex_special_close",
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
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_complex_elevator_right",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_complex_mid_completed"
			}
		},
		event_elevator_complex_ranged_left = {
			{
				"delay",
				duration = 5
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_complex_upper_left",
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
				spawner_group = "spawner_complex_far_left",
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
				spawner_group = "spawner_complex_special_close",
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
				duration = 7
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_complex_elevator_left",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_complex_mid_completed"
			}
		},
		event_complex_endevent_guard = {
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 7,
				max_breed_amount = 7,
				spawner_group = "spawner_complex_endevent_guard",
				points = 14,
				breed_tags = {
					{
						"roamer"
					}
				}
			}
		},
		event_hacking_complex_a = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_event_middle",
				limit_spawners = 3,
				points = 22,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_event_middle",
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
				"delay",
				duration = 8
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_hacking_event_right",
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
				spawner_group = "spawner_hacking_event_middle",
				limit_spawners = 3,
				points = 16,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 2,
				proximity_spawners = true,
				spawner_group = "spawner_hacking_event_middle",
				template_name = "low_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_complex_a_completed"
			}
		},
		event_hacking_complex_b = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_event_right",
				limit_spawners = 3,
				points = 22,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_event_right",
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
				"delay",
				duration = 8
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_hacking_event_left",
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
				"spawn_by_points",
				spawner_group = "spawner_hacking_event_right",
				limit_spawners = 3,
				points = 16,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 2,
				proximity_spawners = true,
				spawner_group = "spawner_hacking_event_right",
				template_name = "low_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_complex_b_completed"
			}
		},
		event_hacking_complex_c = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_event_left",
				limit_spawners = 3,
				points = 22,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_event_left",
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
				"delay",
				duration = 8
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_hacking_event_right",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
						"sniper"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_event_left",
				limit_spawners = 3,
				points = 16,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 2,
				proximity_spawners = true,
				spawner_group = "spawner_hacking_event_left",
				template_name = "low_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_complex_c_completed"
			}
		},
		event_hacking_complex_d = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_event_middle",
				limit_spawners = 3,
				points = 22,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_event_left",
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
				duration = 8
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_hacking_event_right",
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
				spawner_group = "spawner_hacking_event_middle",
				limit_spawners = 3,
				points = 16,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 2,
				proximity_spawners = true,
				spawner_group = "spawner_hacking_event_middle",
				template_name = "low_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_complex_d_completed"
			}
		},
		event_hacking_complex_e = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_event_left",
				limit_spawners = 3,
				points = 22,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_event_left",
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
				duration = 8
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_hacking_event_right",
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
				"spawn_by_points",
				spawner_group = "spawner_hacking_event_left",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"far"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_event_left",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"roamer"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 2,
				proximity_spawners = true,
				spawner_group = "spawner_hacking_event_middle",
				template_name = "low_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_complex_e_completed"
			}
		},
		event_hacking_complex_f = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_hacking_event_right",
				limit_spawners = 3,
				points = 22,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_event_left",
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
				duration = 8
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_hacking_event_left",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
						"sniper"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_event_right",
				limit_spawners = 3,
				points = 10,
				breed_tags = {
					{
						"far"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_hacking_event_right",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"roamer"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 2,
				proximity_spawners = true,
				spawner_group = "spawner_hacking_event_middle",
				template_name = "low_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_hacking_complex_f_completed"
			}
		}
	}
}

return template
