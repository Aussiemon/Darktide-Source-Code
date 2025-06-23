-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_core_research.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		core_research_mid_event_1 = {
			"core_research_mid_event_a",
			1,
			"core_research_mid_event_b",
			1,
			"core_research_mid_event_c",
			1
		},
		core_research_mid_event_2 = {
			"core_research_mid_event_d",
			1,
			"core_research_mid_event_e",
			1,
			"core_research_mid_event_f",
			1
		},
		core_research_ice_event = {
			"core_research_ice_event_1",
			1,
			"core_research_ice_event_2",
			1
		},
		core_research_end_event_1 = {
			"core_research_end_event_a",
			1,
			"core_research_end_event_b",
			1,
			"core_research_end_event_c",
			1
		},
		core_research_end_event_2 = {
			"core_research_end_event_d",
			1,
			"core_research_end_event_e",
			1,
			"core_research_end_event_f",
			1
		},
		core_research_end_event_aux_gen = {
			"core_research_end_event_aux_gen_1",
			1,
			"core_research_end_event_aux_gen_2",
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
				"freeze_specials_pacing",
				enabled = false
			}
		},
		core_research_mid_event_a = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_mid_west",
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
				"spawn_by_points",
				spawner_group = "spawner_mid_west",
				limit_spawners = 2,
				points = 7,
				breed_tags = {
					{
						"far",
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
				spawner_group = "spawner_mid",
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
				spawner_group = "spawner_mid_west",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 26
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_mid",
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
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"start_random_terror_event",
				start_event_name = "core_research_mid_event_2"
			}
		},
		core_research_mid_event_b = {
			{
				"spawn_by_points",
				spawner_group = "spawner_mid_north",
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
				spawner_group = "spawner_mid_north",
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
				spawner_group = "spawner_mid_north",
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
				spawner_group = "spawner_mid_north",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 26
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"start_random_terror_event",
				start_event_name = "core_research_mid_event_2"
			}
		},
		core_research_mid_event_c = {
			{
				"spawn_by_points",
				spawner_group = "spawner_mid_south",
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
				spawner_group = "spawner_mid_south",
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
				spawner_group = "spawner_mid",
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
				spawner_group = "spawner_mid_south",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 26
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_mid",
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
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"start_random_terror_event",
				start_event_name = "core_research_mid_event_2"
			}
		},
		core_research_mid_event_d = {
			{
				"delay",
				duration = 3
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_mid",
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
				spawner_group = "spawner_mid_east",
				limit_spawners = 2,
				points = 7,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_mid_east",
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
				spawner_group = "spawner_mid_east",
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
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"start_random_terror_event",
				start_event_name = "core_research_mid_event_1"
			}
		},
		core_research_mid_event_e = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_mid_west",
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
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_mid_west",
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
				duration = 6
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_mid_east",
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
				spawner_group = "spawner_mid_west",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 26
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_mid",
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
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"start_random_terror_event",
				start_event_name = "core_research_mid_event_1"
			}
		},
		core_research_mid_event_f = {
			{
				"spawn_by_points",
				spawner_group = "spawner_mid_south",
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
				spawner_group = "spawner_mid_south",
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
				duration = 6
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_mid",
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
				spawner_group = "spawner_mid_south",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 26
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_mid",
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
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"start_random_terror_event",
				start_event_name = "core_research_mid_event_1"
			}
		},
		event_research_stop_mid_event = {
			{
				"stop_terror_event",
				stop_event_name = "core_research_mid_event_a"
			},
			{
				"stop_terror_event",
				stop_event_name = "core_research_mid_event_b"
			},
			{
				"stop_terror_event",
				stop_event_name = "core_research_mid_event_c"
			},
			{
				"stop_terror_event",
				stop_event_name = "core_research_mid_event_d"
			},
			{
				"stop_terror_event",
				stop_event_name = "core_research_mid_event_e"
			},
			{
				"stop_terror_event",
				stop_event_name = "core_research_mid_event_f"
			},
			{
				"stop_terror_trickle"
			}
		},
		core_research_ice_event_1 = {
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_ice_special",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_ice_east",
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
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ice_east",
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
				duration = 5
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_ice_special",
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
				duration = 7
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ice_west",
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
				duration = 20
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_terror_event",
				start_event_name = "core_research_ice_event_2"
			}
		},
		core_research_ice_event_2 = {
			{
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_ice_special",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_ice_west",
				limit_spawners = 1,
				points = 12,
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
				spawner_group = "spawner_ice_west",
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
				duration = 5
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_ice_special",
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
				duration = 7
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ice_east",
				limit_spawners = 1,
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
				duration = 20
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_terror_event",
				start_event_name = "core_research_ice_event_1"
			}
		},
		core_research_ice_guards = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"trickle_hordes"
				}
			},
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_ice_guard_1",
				points = 20,
				breed_tags = {
					{
						"ogryn"
					}
				}
			},
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_ice_guard_2",
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
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_ice_guard_3",
				points = 15,
				breed_tags = {
					{
						"elite"
					}
				}
			},
			{
				"delay",
				duration = 3
			}
		},
		core_research_ice_guards_side = {
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 2,
				max_breed_amount = 2,
				spawner_group = "spawner_ice_guard_1_side",
				points = 15,
				breed_tags = {
					{
						"elite",
						"melee"
					}
				}
			},
			{
				"delay",
				duration = 3
			}
		},
		core_research_stop_ice_event = {
			{
				"stop_terror_event",
				stop_event_name = "core_research_ice_event_1"
			},
			{
				"stop_terror_event",
				stop_event_name = "core_research_ice_event_2"
			},
			{
				"stop_terror_trickle"
			}
		},
		core_research_end_event_a = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "machine_excavation_side",
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
				"spawn_by_points",
				spawner_group = "machine_excavation_side",
				limit_spawners = 2,
				points = 7,
				breed_tags = {
					{
						"far",
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
				spawner_group = "machine_excavation_elevator",
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
				spawner_group = "machine_excavation_side",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 26
			},
			{
				"try_inject_special_minion",
				spawner_group = "machine_excavation_side",
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
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"start_random_terror_event",
				start_event_name = "core_research_end_event_2"
			}
		},
		core_research_end_event_b = {
			{
				"spawn_by_points",
				spawner_group = "machine_excavation_side",
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
				spawner_group = "machine_excavation_side",
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
				spawner_group = "machine_excavation_elevator",
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
				spawner_group = "machine_excavation_side",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 26
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"start_random_terror_event",
				start_event_name = "core_research_end_event_2"
			}
		},
		core_research_end_event_c = {
			{
				"spawn_by_points",
				spawner_group = "machine_excavation_side",
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
				spawner_group = "machine_excavation_side",
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
				spawner_group = "machine_excavation_elevator",
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
				spawner_group = "machine_excavation_side",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 26
			},
			{
				"try_inject_special_minion",
				spawner_group = "machine_excavation_side",
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
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"start_random_terror_event",
				start_event_name = "core_research_end_event_2"
			}
		},
		core_research_end_event_d = {
			{
				"delay",
				duration = 3
			},
			{
				"try_inject_special_minion",
				spawner_group = "machine_excavation_side",
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
				spawner_group = "machine_excavation_side",
				limit_spawners = 2,
				points = 7,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "machine_excavation_side",
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
				spawner_group = "machine_excavation_side",
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
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"start_random_terror_event",
				start_event_name = "core_research_end_event_1"
			}
		},
		core_research_end_event_e = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "machine_excavation_side",
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
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "machine_excavation_side",
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
				duration = 6
			},
			{
				"try_inject_special_minion",
				spawner_group = "machine_excavation_elevator",
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
				spawner_group = "machine_excavation_side",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 26
			},
			{
				"try_inject_special_minion",
				spawner_group = "machine_excavation_side",
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
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"start_random_terror_event",
				start_event_name = "core_research_end_event_1"
			}
		},
		core_research_end_event_f = {
			{
				"spawn_by_points",
				spawner_group = "machine_excavation_side",
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
				spawner_group = "machine_excavation_side",
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
				duration = 6
			},
			{
				"try_inject_special_minion",
				spawner_group = "machine_excavation_elevator",
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
				spawner_group = "machine_excavation_side",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 26
			},
			{
				"try_inject_special_minion",
				spawner_group = "machine_excavation_side",
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
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 8
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end
			},
			{
				"delay",
				duration = 7
			},
			{
				"start_random_terror_event",
				start_event_name = "core_research_end_event_1"
			}
		},
		core_research_end_event_aux_gen_1 = {
			{
				"try_inject_special_minion",
				max_breed_amount = 4,
				points = 30,
				breed_tags = {
					{
						"special"
					}
				}
			}
		},
		core_research_end_event_aux_gen_2 = {
			{
				"try_inject_special_minion",
				max_breed_amount = 2,
				points = 20,
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "machine_excavation_side",
				limit_spawners = 2,
				points = 20,
				breed_tags = {
					{
						"sniper"
					}
				}
			}
		},
		event_research_stop_end_event = {
			{
				"stop_terror_event",
				stop_event_name = "core_research_end_event_a"
			},
			{
				"stop_terror_event",
				stop_event_name = "core_research_end_event_b"
			},
			{
				"stop_terror_event",
				stop_event_name = "core_research_end_event_c"
			},
			{
				"stop_terror_event",
				stop_event_name = "core_research_end_event_d"
			},
			{
				"stop_terror_event",
				stop_event_name = "core_research_end_event_e"
			},
			{
				"stop_terror_event",
				stop_event_name = "core_research_end_event_f"
			},
			{
				"stop_terror_trickle"
			}
		}
	}
}

return template
