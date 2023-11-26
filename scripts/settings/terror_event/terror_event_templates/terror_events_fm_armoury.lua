-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_fm_armoury.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		fm_armoury_gauntlet_wave_main = {
			"event_gauntlet_armoury_main_wave_a",
			1,
			"event_gauntlet_armoury_main_wave_b",
			1,
			"event_gauntlet_armoury_main_wave_c",
			1
		},
		fm_armoury_gauntlet_wave_final = {
			"event_gauntlet_armoury_final_wave_a",
			1,
			"event_gauntlet_armoury_final_wave_b",
			1,
			"event_gauntlet_armoury_final_wave_c",
			1
		},
		fm_armoury_fortification_wave_1 = {
			"event_fortification_armoury_wave1_a",
			1,
			"event_fortification_armoury_wave1_b",
			1,
			"event_fortification_armoury_wave1_c",
			1
		},
		fm_armoury_fortification_wave_final = {
			"event_fortification_final_a",
			1,
			"event_fortification_final_b",
			1,
			"event_fortification_final_c",
			1
		},
		fm_armoury_fortification_extra_right = {
			"fm_armoury_fortification_extra_right_a",
			1,
			"fm_armoury_fortification_extra_right_b",
			1
		},
		fm_armoury_fortification_extra_left = {
			"fm_armoury_fortification_extra_left_a",
			1,
			"fm_armoury_fortification_extra_left_b",
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
		event_setup_off = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
					"specials",
					"monsters"
				}
			}
		},
		event_only_roamers_specials_enabled = {
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"roamers",
					"specials"
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
		event_gauntlet_armoury_main_wave_a = {
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_gauntlet_armoury_stoppers",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_gauntlet_armoury_stoppers",
				limit_spawners = 3,
				points = 11,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_gauntlet_armoury_stoppers",
				limit_spawners = 3,
				points = 14,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_armoury_gauntlet_wave_main"
			}
		},
		event_gauntlet_armoury_main_wave_b = {
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_gauntlet_armoury_stoppers",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_gauntlet_armoury_stoppers",
				limit_spawners = 3,
				points = 14,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_gauntlet_armoury_stoppers",
				limit_spawners = 3,
				points = 11,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_armoury_gauntlet_wave_main"
			}
		},
		event_gauntlet_armoury_main_wave_c = {
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_gauntlet_armoury_stoppers",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_gauntlet_armoury_stoppers",
				limit_spawners = 3,
				points = 14,
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
				spawner_group = "spawner_gauntlet_armoury_stoppers",
				limit_spawners = 3,
				points = 11,
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
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_armoury_gauntlet_wave_main"
			}
		},
		event_gauntlet_armoury_final_wave_a = {
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_gauntlet_armoury_final_left",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_gauntlet_armoury_final_left",
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
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_gauntlet_armoury_final_left",
				limit_spawners = 3,
				points = 16,
				breed_tags = {
					{
						"melee",
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
				"spawn_by_points",
				spawner_group = "spawner_gauntlet_armoury_final_left",
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
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_armoury_gauntlet_wave_final"
			}
		},
		event_gauntlet_armoury_final_wave_b = {
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_gauntlet_armoury_final_right",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_gauntlet_armoury_final_right",
				limit_spawners = 3,
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
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_gauntlet_armoury_final_right",
				limit_spawners = 3,
				points = 9,
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
				spawner_group = "spawner_gauntlet_armoury_final_right",
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
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_armoury_gauntlet_wave_final"
			}
		},
		event_gauntlet_armoury_final_wave_c = {
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_gauntlet_armoury_final_front",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_gauntlet_armoury_final_front",
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
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_gauntlet_armoury_final_front",
				limit_spawners = 3,
				points = 9,
				breed_tags = {
					{
						"close",
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
				"spawn_by_points",
				spawner_group = "spawner_gauntlet_armoury_final_front",
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
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_armoury_gauntlet_wave_final"
			}
		},
		event_gauntlet_armoury_guard = {
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 3,
				max_breed_amount = 3,
				spawner_group = "spawner_gauntlet_passive_elite",
				points = 12,
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
				limit_spawners = 10,
				max_breed_amount = 10,
				spawner_group = "spawner_gauntlet_passive_guards",
				points = 16,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			}
		},
		fm_armoury_passive_guards = {
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 10,
				max_breed_amount = 3,
				spawner_group = "spawner_passive_guards",
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
				duration = 3
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			}
		},
		event_fortification_armoury_sniper_balcony = {
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_armoury_sniper_balcony",
				max_breed_amount = 2,
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
				duration = 3
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			}
		},
		event_fortification_armoury_wave1_a = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_armoury_right",
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
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_right",
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
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_right",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_armoury_right",
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
				duration = 4
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_armoury_sniper_1",
				max_breed_amount = 2,
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
				delay = 4,
				spawner_group = "spawner_fortification_armoury_right",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 6
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_armoury_fortification_wave_1"
			}
		},
		event_fortification_armoury_wave1_b = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_armoury_left",
				limit_spawners = 3,
				points = 16,
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
				spawner_group = "spawner_fortification_armoury_left",
				limit_spawners = 3,
				points = 16,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_left",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_armoury_left",
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
				duration = 4
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_armoury_sniper_2",
				max_breed_amount = 2,
				points = 8,
				breed_tags = {
					{
						"special",
						"sniper"
					}
				}
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_fortification_armoury_left",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 6
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_armoury_fortification_wave_1"
			}
		},
		event_fortification_armoury_wave1_c = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_armoury_stage",
				limit_spawners = 3,
				points = 16,
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
				spawner_group = "spawner_fortification_armoury_stage",
				limit_spawners = 3,
				points = 16,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"delay",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_stage",
				limit_spawners = 3,
				points = 18,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_armoury_stage",
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
				"delay",
				duration = 4
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_armoury_stage",
				max_breed_amount = 2,
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
				spawner_group = "spawner_fortification_armoury_stage",
				template_name = "standard_melee"
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 6
				end
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_armoury_fortification_wave_1"
			}
		},
		fm_armoury_fortification_extra_left_a = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_left_bottom",
				limit_spawners = 3,
				points = 2,
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
				"start_random_terror_event",
				start_event_name = "fm_armoury_fortification_extra_left"
			}
		},
		fm_armoury_fortification_extra_left_b = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_left_bottom",
				limit_spawners = 3,
				points = 2,
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
				"start_random_terror_event",
				start_event_name = "fm_armoury_fortification_extra_left"
			}
		},
		fm_armoury_fortification_extra_right_a = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_right_bottom",
				limit_spawners = 3,
				points = 2,
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
				"start_random_terror_event",
				start_event_name = "fm_armoury_fortification_extra_right"
			}
		},
		fm_armoury_fortification_extra_right_b = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_right_bottom",
				limit_spawners = 3,
				points = 2,
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
				"start_random_terror_event",
				start_event_name = "fm_armoury_fortification_extra_right"
			}
		},
		event_fortification_final_a = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_armoury_left",
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
				"delay",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_left",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_left",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_armoury_left",
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
				duration = 4
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_armoury_left",
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
				duration = 100,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 5
				end
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_armoury_final_completed"
			}
		},
		event_fortification_final_b = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_armoury_right",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_right",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_right",
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
				spawner_group = "spawner_fortification_armoury_right",
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
				"delay",
				duration = 4
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_armoury_right",
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
				duration = 100,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 5
				end
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_armoury_final_completed"
			}
		},
		event_fortification_final_c = {
			{
				"delay",
				duration = 2
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fortification_armoury_right",
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
				"delay",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_left",
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
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fortification_armoury_right",
				limit_spawners = 3,
				points = 12,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_armoury_left",
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
				"delay",
				duration = 4
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_fortification_armoury_left",
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
				duration = 100,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 5
				end
			},
			{
				"flow_event",
				flow_event_name = "event_fortification_armoury_final_completed"
			}
		}
	}
}

return template
