local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		hm_strain_survival_left = {
			"event_survival_strain_a",
			1,
			"event_survival_strain_b",
			1
		},
		hm_strain_survival_right = {
			"event_survival_strain_c",
			1,
			"event_survival_strain_d",
			1
		},
		hm_strain_hacking_1 = {
			"event_hack_fuel_depot_a",
			1,
			"event_hack_fuel_depot_b",
			1
		},
		hm_strain_hacking_2 = {
			"event_hack_fuel_depot_c",
			1,
			"event_hack_fuel_depot_d",
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
		event_stop_trickle = {
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
		event_surveillance_guards = {
			{
				"spawn_by_points",
				passive = true,
				max_breed_amount = 25,
				spawner_group = "spawner_surveillance_guards",
				limit_spawners = 25,
				points = 20,
				breed_tags = {
					{
						"roamer",
						"far"
					}
				}
			}
		},
		event_survival_strain_a = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_surveillance_left",
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
				"delay",
				duration = 3
			},
			{
				"try_inject_special_minion",
				points = 12,
				max_breed_amount = 1,
				spawner_group = "spawner_surveillance_trickle",
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 8,
				limit_spawners = 2,
				spawner_group = "spawner_surveillance_far_left",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 32
			},
			{
				"continue_when",
				duration = 65,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"flow_event",
				flow_event_name = "event_survival_strain_a_completed"
			}
		},
		event_survival_strain_b = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_surveillance_left",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_surveillance_left",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_surveillance_left",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_surveillance_left",
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
				"try_inject_special_minion",
				points = 12,
				max_breed_amount = 1,
				spawner_group = "spawner_surveillance_trickle",
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 8,
				limit_spawners = 2,
				spawner_group = "spawner_surveillance_far_left",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 32
			},
			{
				"continue_when",
				duration = 65,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"flow_event",
				flow_event_name = "event_survival_strain_b_completed"
			}
		},
		event_survival_strain_c = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_surveillance_right",
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
				spawner_group = "spawner_surveillance_right",
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
				points = 12,
				max_breed_amount = 1,
				spawner_group = "spawner_surveillance_trickle",
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 8,
				limit_spawners = 2,
				spawner_group = "spawner_surveillance_far_right",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 32
			},
			{
				"continue_when",
				duration = 65,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"flow_event",
				flow_event_name = "event_survival_strain_c_completed"
			}
		},
		event_survival_strain_d = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_surveillance_right",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_surveillance_right",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_surveillance_right",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_surveillance_right",
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
				"try_inject_special_minion",
				points = 12,
				max_breed_amount = 1,
				spawner_group = "spawner_surveillance_trickle",
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 8,
				limit_spawners = 2,
				spawner_group = "spawner_surveillance_far_right",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 32
			},
			{
				"continue_when",
				duration = 65,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"flow_event",
				flow_event_name = "event_survival_strain_d_completed"
			}
		},
		event_survival_surveillance_elevator = {
			{
				"spawn_by_points",
				spawner_group = "spawner_surveillance_left",
				limit_spawners = 3,
				points = 15,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_surveillance_right",
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
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"start_terror_event",
				start_event_name = "event_survival_surveillance_elevator"
			}
		},
		event_fuel_depot_outside_guards = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				passive = true,
				max_breed_amount = 14,
				spawner_group = "spawner_fuel_depot_guards",
				limit_spawners = 14,
				points = 20,
				breed_tags = {
					{
						"roamer",
						"far"
					}
				}
			}
		},
		event_hack_fuel_depot_a = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fuel_depot_center",
				limit_spawners = 3,
				points = 5,
				breed_tags = {
					{
						"roamer",
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
				spawner_group = "spawner_fuel_depot_center",
				limit_spawners = 3,
				points = 5,
				breed_tags = {
					{
						"roamer",
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
				spawner_group = "spawner_fuel_depot_center",
				limit_spawners = 3,
				points = 5,
				breed_tags = {
					{
						"roamer",
						"melee"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 8,
				proximity_spawners = true,
				spawner_group = "spawner_fuel_depot_center",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fuel_depot_center",
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
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hack_fuel_depot_a_completed"
			}
		},
		event_hack_fuel_depot_b = {
			{
				"spawn_by_points",
				spawner_group = "spawner_fuel_depot_left",
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
				proximity_spawners = true,
				spawner_group = "spawner_fuel_depot_left",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fuel_depot_left",
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
				spawner_group = "spawner_fuel_depot_left",
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
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hack_fuel_depot_b_completed"
			}
		},
		event_hack_fuel_depot_c = {
			{
				"spawn_by_points",
				spawner_group = "spawner_fuel_depot_right",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"horde",
						"melee"
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
				proximity_spawners = true,
				spawner_group = "spawner_fuel_depot_right",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fuel_depot_right",
				limit_spawners = 3,
				points = 14,
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
				spawner_group = "spawner_fuel_depot_right",
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
				spawner_group = "spawner_fuel_depot_right",
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
				spawner_group = "spawner_fuel_depot_right",
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
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hack_fuel_depot_c_completed"
			}
		},
		event_hack_fuel_depot_d = {
			{
				"spawn_by_points",
				spawner_group = "spawner_fuel_depot_back",
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
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fuel_depot_back",
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
				"start_terror_trickle",
				delay = 8,
				proximity_spawners = true,
				spawner_group = "spawner_fuel_depot_back",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fuel_depot_back",
				limit_spawners = 3,
				points = 18,
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
				spawner_group = "spawner_fuel_depot_back",
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
				spawner_group = "spawner_fuel_depot_back",
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
				spawner_group = "spawner_fuel_depot_back",
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
				"continue_when",
				duration = 70,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"flow_event",
				flow_event_name = "event_hack_fuel_depot_d_completed"
			}
		},
		event_fuel_depot_escape = {
			{
				"delay",
				duration = 0.5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fuel_depot_escape",
				limit_spawners = 3,
				points = 6,
				breed_tags = {
					{
						"melee",
						"elite"
					},
					{
						"close",
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fuel_depot_escape",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"melee",
						"roamer"
					},
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
					return TerrorEventQueries.num_alive_minions() < 2
				end
			},
			{
				"flow_event",
				flow_event_name = "event_fuel_depot_escape_completed"
			}
		}
	}
}

return template
