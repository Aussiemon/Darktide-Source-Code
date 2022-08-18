local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		dm_forge_workers_hub_ranged = {
			"event_workers_hub_a",
			1,
			"event_workers_hub_b",
			1
		},
		dm_forge_survive_trickle = {
			"event_survive_trickle_a",
			1,
			"event_survive_trickle_b",
			1
		},
		dm_forge_demolition_corruptor_a = {
			"event_corruptor_a_1",
			1,
			"event_corruptor_a_2",
			1
		},
		dm_forge_demolition_corruptor_b = {
			"event_corruptor_b_1",
			1,
			"event_corruptor_b_2",
			1
		},
		dm_forge_demolition_corruptor_c = {
			"event_corruptor_c_1",
			1,
			"event_corruptor_c_2",
			1
		},
		dm_forge_demolition_corruptor_d = {
			"event_corruptor_d_1",
			1,
			"event_corruptor_d_2",
			1
		},
		dm_forge_demolition_trickle = {
			"event_demolition_trickle_a",
			1,
			"event_demolition_trickle_b",
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
		event_workers_hub_a = {
			{
				"debug_print",
				text = "event_workers_hub_a",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "workers_hub_a",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 15
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
				flow_event_name = "event_workers_hub_a_completed"
			}
		},
		event_workers_hub_b = {
			{
				"debug_print",
				text = "event_workers_hub_b",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "workers_hub_b",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 15
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
				flow_event_name = "event_workers_hub_b_completed"
			}
		},
		event_survive_trickle_a = {
			{
				"debug_print",
				text = "event_survive_trickle_a",
				duration = 3
			},
			{
				"freeze_specials_pacing",
				enabled = true
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_workers_far_cover",
				limit_spawners = 3,
				points = 14,
				breed_tags = {
					{
						"roamer",
						"far"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_workers_far_cover",
				limit_spawners = 3,
				points = 6,
				breed_tags = {
					{
						"elite",
						"far"
					}
				}
			},
			{
				"delay",
				duration = 22
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_workers_near",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_workers_near",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"elite",
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
				delay = 1,
				spawner_group = "spawner_workers_near",
				template_name = "low_melee"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_workers_near",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"elite",
						"melee"
					}
				}
			},
			{
				"continue_when",
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"try_inject_special_minion",
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
				spawner_group = "spawner_workers_far_cover",
				limit_spawners = 3,
				points = 14,
				breed_tags = {
					{
						"roamer",
						"far"
					}
				}
			},
			{
				"freeze_specials_pacing",
				enabled = false
			}
		},
		event_survive_trickle_b = {
			{
				"debug_print",
				text = "event_survive_trickle_b",
				duration = 3
			},
			{
				"freeze_specials_pacing",
				enabled = true
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_workers_far",
				limit_spawners = 3,
				points = 14,
				breed_tags = {
					{
						"roamer",
						"close"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_workers_far",
				limit_spawners = 3,
				points = 8,
				breed_tags = {
					{
						"elite",
						"close"
					}
				}
			},
			{
				"delay",
				duration = 22
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_workers_near",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_workers_near",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"elite",
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
				delay = 1,
				spawner_group = "spawner_workers_near",
				template_name = "low_melee"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_workers_near",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"elite",
						"melee"
					}
				}
			},
			{
				"continue_when",
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"try_inject_special_minion",
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
				spawner_group = "spawner_workers_far",
				limit_spawners = 3,
				points = 14,
				breed_tags = {
					{
						"roamer",
						"close"
					}
				}
			},
			{
				"freeze_specials_pacing",
				enabled = false
			}
		},
		event_corruptor_a_1 = {
			{
				"debug_print",
				text = "event_corruptor_a_1",
				duration = 3
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_corruptor_a",
				template_name = "low_melee"
			},
			{
				"try_inject_special_minion",
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
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_corruptor_a",
				limit_spawners = 2,
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
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_a_1_completed"
			}
		},
		event_corruptor_a_2 = {
			{
				"debug_print",
				text = "event_corruptor_a_2",
				duration = 3
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_corruptor_a",
				template_name = "low_melee"
			},
			{
				"try_inject_special_minion",
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
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_corruptor_a",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_a_2_completed"
			}
		},
		event_corruptor_b_1 = {
			{
				"debug_print",
				text = "event_corruptor_b_1",
				duration = 3
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_corruptor_b",
				template_name = "low_melee"
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"try_inject_special_minion",
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
				spawner_group = "spawner_corruptor_a",
				limit_spawners = 2,
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
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_b_1_completed"
			}
		},
		event_corruptor_b_2 = {
			{
				"debug_print",
				text = "event_corruptor_b_2",
				duration = 3
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_corruptor_b",
				template_name = "low_melee"
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
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
				spawner_group = "spawner_corruptor_b",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_b_2_completed"
			}
		},
		event_corruptor_c_1 = {
			{
				"debug_print",
				text = "event_corruptor_c_1",
				duration = 3
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_corruptor_c",
				template_name = "low_melee"
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"try_inject_special_minion",
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
				spawner_group = "spawner_corruptor_c",
				limit_spawners = 2,
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
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_c_1_completed"
			}
		},
		event_corruptor_c_2 = {
			{
				"debug_print",
				text = "event_corruptor_c_2",
				duration = 3
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_corruptor_c",
				template_name = "low_melee"
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
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_corruptor_c",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_c_2_completed"
			}
		},
		event_corruptor_d_1 = {
			{
				"debug_print",
				text = "event_corruptor_d_1",
				duration = 3
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_corruptor_d",
				template_name = "low_melee"
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_corruptor_d",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"horde",
						"melee"
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
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_d_1_completed"
			}
		},
		event_corruptor_d_2 = {
			{
				"debug_print",
				text = "event_corruptor_d_2",
				duration = 3
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_corruptor_d",
				template_name = "low_melee"
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_corruptor_d",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"try_inject_special_minion",
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
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_d_2_completed"
			}
		},
		event_demolition_trickle_a = {
			{
				"debug_print",
				text = "event_demolition_trickle_a",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_foundry_near",
				template_name = "low_melee"
			}
		},
		event_demolition_trickle_b = {
			{
				"debug_print",
				text = "event_demolition_trickle_a",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_foundry_far",
				template_name = "low_melee"
			}
		},
		event_demolition_trickle_hold = {
			{
				"debug_print",
				text = "event_demolition_trickle_hold",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_foundry_far",
				template_name = "low_melee"
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 12
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_foundry_far",
				limit_spawners = 2,
				points = 18,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_foundry_far",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"elite",
						"melee"
					}
				}
			}
		},
		event_foundry_finale = {
			{
				"debug_print",
				text = "event_foundry_finale",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"try_inject_special_minion",
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
				spawner_group = "spawner_foundry_near",
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
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_foundry_near",
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
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_foundry_near",
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
				flow_event_name = "event_foundry_finale_completed"
			}
		}
	}
}

return template
