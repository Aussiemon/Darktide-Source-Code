-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_dm_forge.lua

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
			1,
			"event_survive_trickle_c",
			1,
			"event_survive_trickle_d",
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
		event_workers_hub_guards = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				passive = true,
				max_breed_amount = 7,
				spawner_group = "workers_hub_guards",
				limit_spawners = 7,
				points = 14,
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
				points = 10,
				breed_tags = {
					{
						"roamer",
						"close"
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
						"roamer",
						"far"
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
		event_mid_event_guards = {
			{
				"delay",
				duration = 1
			},
			{
				"spawn_by_points",
				passive = true,
				max_breed_amount = 7,
				spawner_group = "mid_event_guards",
				limit_spawners = 7,
				points = 14,
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
		event_survive_trickle_a = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
						"roamer",
						"melee"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_workers_near",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 22
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 16,
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
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
						"roamer",
						"melee"
					}
				}
			},
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				max_breed_amount = 1,
				points = 16,
				breed_tags = {
					{
						"special",
						"disabler"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				"flow_event",
				flow_event_name = "event_survive_trickle_completed"
			}
		},
		event_survive_trickle_b = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far",
				limit_spawners = 3,
				points = 12,
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
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_workers_near",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 22
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 16,
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
						"roamer",
						"far"
					}
				}
			},
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_workers_near",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"roamer",
						"far"
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
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				"flow_event",
				flow_event_name = "event_survive_trickle_completed"
			}
		},
		event_survive_trickle_c = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far_cover",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"roamer",
						"melee"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_workers_near",
				template_name = "standard_melee"
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 16,
				breed_tags = {
					{
						"special",
						"scrambler"
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
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				spawner_group = "spawner_workers_far_cover",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"roamer",
						"close"
					}
				}
			},
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_near",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"elite",
						"close"
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
				max_breed_amount = 1,
				points = 16,
				breed_tags = {
					{
						"special",
						"disabler"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far_cover",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"roamer",
						"far"
					}
				}
			},
			{
				"flow_event",
				flow_event_name = "event_survive_trickle_completed"
			}
		},
		event_survive_trickle_d = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far",
				limit_spawners = 3,
				points = 12,
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
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_workers_near",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 22
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 16,
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
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far_cover",
				limit_spawners = 3,
				points = 12,
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
						"roamer",
						"melee"
					}
				}
			},
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_workers_near",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"roamer",
						"far"
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
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_workers_far",
				limit_spawners = 3,
				points = 14,
				breed_tags = {
					{
						"roamer",
						"melee"
					}
				}
			},
			{
				"flow_event",
				flow_event_name = "event_survive_trickle_completed"
			}
		},
		event_corruptor_a_1 = {
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_corruptor_a",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_trickle",
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
				spawner_group = "spawner_corruptor_a",
				limit_spawners = 2,
				points = 14,
				breed_tags = {
					{
						"roamer",
						"far"
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
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"spawn_by_points",
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				"delay",
				duration = 6
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_a_1_completed"
			}
		},
		event_corruptor_a_2 = {
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_corruptor_a",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				"spawn_by_points",
				spawner_group = "spawner_foundry_trickle",
				limit_spawners = 2,
				points = 14,
				breed_tags = {
					{
						"roamer",
						"far"
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
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"spawn_by_points",
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				"delay",
				duration = 6
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_a_2_completed"
			}
		},
		event_corruptor_b_1 = {
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_corruptor_b",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_trickle",
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
				spawner_group = "spawner_corruptor_b",
				limit_spawners = 2,
				points = 14,
				breed_tags = {
					{
						"roamer",
						"far"
					}
				}
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
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
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_corruptor_b",
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
				"delay",
				duration = 6
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_b_1_completed"
			}
		},
		event_corruptor_b_2 = {
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_corruptor_b",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_corruptor_b",
				limit_spawners = 2,
				points = 14,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_foundry_trickle",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"roamer",
						"far"
					}
				}
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
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
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				"delay",
				duration = 6
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_b_2_completed"
			}
		},
		event_corruptor_c_1 = {
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_corruptor_c",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_trickle",
				limit_spawners = 2,
				points = 14,
				breed_tags = {
					{
						"horde",
						"melee"
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
						"roamer",
						"far"
					}
				}
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
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
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				"delay",
				duration = 6
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_c_1_completed"
			}
		},
		event_corruptor_c_2 = {
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_corruptor_c",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				"spawn_by_points",
				spawner_group = "spawner_foundry_trickle",
				limit_spawners = 2,
				points = 14,
				breed_tags = {
					{
						"roamer",
						"far"
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
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"spawn_by_points",
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				"delay",
				duration = 6
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_c_2_completed"
			}
		},
		event_corruptor_d_1 = {
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_corruptor_d",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_trickle",
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
				spawner_group = "spawner_corruptor_d",
				limit_spawners = 2,
				points = 14,
				breed_tags = {
					{
						"roamer",
						"far"
					}
				}
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"spawn_by_points",
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				"delay",
				duration = 6
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_d_1_completed"
			}
		},
		event_corruptor_d_2 = {
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_corruptor_d",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_corruptor_d",
				limit_spawners = 2,
				points = 14,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_foundry_trickle",
				limit_spawners = 2,
				points = 16,
				breed_tags = {
					{
						"roamer",
						"far"
					}
				}
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"spawn_by_points",
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
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
				"delay",
				duration = 6
			},
			{
				"flow_event",
				flow_event_name = "event_corruptor_d_2_completed"
			}
		},
		event_demolition_trickle_a = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"start_terror_trickle",
				spawner_group = "spawner_foundry_trickle",
				proximity_spawners = true,
				template_name = "standard_melee",
				delay = 0,
				limit_spawners = 2
			}
		},
		event_demolition_trickle_b = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"start_terror_trickle",
				spawner_group = "spawner_foundry_trickle",
				proximity_spawners = true,
				template_name = "standard_melee",
				delay = 0,
				limit_spawners = 2
			}
		},
		event_demolition_trickle_hold = {
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_foundry_trickle",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_trickle",
				limit_spawners = 2,
				points = 14,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_foundry_trickle",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"melee"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_foundry_trickle",
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
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			}
		},
		event_foundry_finale = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_north",
				limit_spawners = 3,
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
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_trickle",
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
				duration = 2
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
				duration = 180,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() <= 50
				end
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_east",
				limit_spawners = 3,
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
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_south",
				limit_spawners = 3,
				points = 13,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_foundry_trickle",
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
				"continue_when",
				duration = 180,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() <= 10
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_foundry_north",
				limit_spawners = 2,
				points = 12,
				breed_tags = {
					{
						"elite",
						"melee"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_trickle",
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
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_foundry_trickle",
				limit_spawners = 3,
				points = 10,
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
				"continue_when",
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() <= 10
				end
			},
			{
				"continue_when",
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_foundry_north",
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
				spawner_group = "spawner_foundry_trickle",
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
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_foundry_trickle",
				template_name = "flood_melee"
			},
			{
				"flow_event",
				flow_event_name = "event_foundry_finale_completed"
			}
		},
		event_foundry_extract = {
			{
				"spawn_by_points",
				spawner_group = "foundry_extract",
				limit_spawners = 2,
				points = 10,
				breed_tags = {
					{
						"roamer",
						"close"
					}
				}
			}
		}
	}
}

return template
