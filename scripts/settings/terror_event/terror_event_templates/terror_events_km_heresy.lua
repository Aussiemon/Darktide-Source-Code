-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_km_heresy.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		km_heresy_survive = {
			"event_survive_heresy_trickle_a",
			1,
			"event_survive_heresy_trickle_b",
			1
		},
		fm_heresy_fort_wave_1 = {
			"event_fort_heresy_a",
			1,
			"event_fort_heresy_b",
			1
		},
		fm_heresy_fort_wave_2 = {
			"event_fort_heresy_c",
			1,
			"event_fort_heresy_d",
			1
		},
		fm_heresy_fort_wave_3 = {
			"event_fort_heresy_e",
			1,
			"event_fort_heresy_f",
			1
		},
		km_heresy_kill_target_shield_down = {
			"km_heresy_kill_target_shield_down_1",
			1,
			"km_heresy_kill_target_shield_down_2",
			1,
			"km_heresy_kill_target_shield_down_3",
			1,
			"km_heresy_kill_target_shield_down_4",
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
		event_only_specials_disable = {
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
					"monsters"
				}
			}
		},
		event_survive_heresy_trickle_a = {
			{
				"debug_print",
				text = "event_survive_heresy_trickle_a",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_survive_heresy_trickle_a",
				template_name = "low_mixed"
			}
		},
		event_survive_heresy_trickle_b = {
			{
				"debug_print",
				text = "event_survive_heresy_trickle_b",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"start_terror_trickle",
				delay = 0,
				spawner_group = "spawner_survive_heresy_trickle_b",
				template_name = "low_melee "
			}
		},
		event_fort_heresy_a = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_top_right",
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
				spawner_group = "spawner_fort_event_top_left",
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
				"delay",
				duration = 3
			},
			{
				"try_inject_special_minion",
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_fort_event_top",
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
				spawner_group = "spawner_fort_event_bottom",
				limit_spawners = 4,
				points = 6,
				breed_tags = {
					{
						"melee",
						"roamer"
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
				"start_random_terror_event",
				start_event_name = "fm_heresy_fort_wave_2"
			}
		},
		event_fort_heresy_b = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_top",
				limit_spawners = 2,
				points = 10,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_bottom_far",
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
				"delay",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_bottom",
				limit_spawners = 4,
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
				spawner_group = "spawner_fort_event_all",
				limit_spawners = 6,
				points = 6,
				breed_tags = {
					{
						"far",
						"roamer"
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
				"start_random_terror_event",
				start_event_name = "fm_heresy_fort_wave_2"
			}
		},
		event_fort_heresy_c = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_all",
				limit_spawners = 4,
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
				spawner_group = "spawner_fort_event_all",
				limit_spawners = 4,
				points = 10,
				breed_tags = {
					{
						"close",
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
						"scrambler",
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
				spawner_group = "spawner_fort_event_top",
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
				spawner_group = "spawner_fort_event_all",
				template_name = "standard_melee"
			},
			{
				"delay",
				duration = 7
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_bottom",
				limit_spawners = 1,
				points = 12,
				breed_tags = {
					{
						"elite"
					}
				}
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_heresy_fort_wave_3"
			}
		},
		event_fort_heresy_d = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_all",
				limit_spawners = 4,
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
				spawner_group = "spawner_fort_event_bottom",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"far",
						"elite"
					}
				}
			},
			{
				"delay",
				duration = 7
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_top",
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
				spawner_group = "spawner_fort_event_bottom",
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
				"start_terror_trickle",
				delay = 8,
				spawner_group = "spawner_fort_event_all",
				template_name = "standard_melee"
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"disabler",
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
				spawner_group = "spawner_fort_event_all",
				limit_spawners = 1,
				points = 12,
				breed_tags = {
					{
						"ogryn",
						"elite"
					}
				}
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "fm_heresy_fort_wave_3"
			}
		},
		event_fort_heresy_e = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_all",
				limit_spawners = 6,
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
				duration = 7
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_all",
				limit_spawners = 2,
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
				duration = 7
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_bottom",
				limit_spawners = 1,
				points = 14,
				breed_tags = {
					{
						"ogryn",
						"elite"
					}
				}
			},
			{
				"continue_when",
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
						"special"
					}
				}
			},
			{
				"delay",
				duration = 5
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_all",
				limit_spawners = 4,
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
				duration = 45,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"start_terror_event",
				start_event_name = "event_fort_heresy_final"
			}
		},
		event_fort_heresy_f = {
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_fort_event_all",
				limit_spawners = 2,
				points = 14,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_bottom",
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
						"scrambler",
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
				spawner_group = "spawner_fort_event_all",
				limit_spawners = 6,
				points = 8,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"continue_when",
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
				spawner_group = "spawner_fort_event_all",
				limit_spawners = 4,
				points = 6,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_fort_event_bottom_close",
				limit_spawners = 1,
				points = 6,
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
				duration = 45,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"delay",
				duration = 10
			},
			{
				"start_terror_event",
				start_event_name = "event_fort_heresy_final"
			}
		},
		event_fort_heresy_final = {
			{
				"flow_event",
				flow_event_name = "mid_event_target_spawned"
			},
			{
				"delay",
				duration = 6
			},
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_mid_event_monster",
				points = 6,
				breed_tags = {
					{
						"monster"
					}
				}
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"delay",
				duration = 1.5
			},
			{
				"flow_event",
				flow_event_name = "mid_event_target_dead"
			}
		},
		km_heresy_passive_guards = {
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 30,
				max_breed_amount = 30,
				spawner_group = "spawner_passive_guards",
				points = 40,
				breed_tags = {
					{
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 6,
				max_breed_amount = 6,
				spawner_group = "spawner_passive_heavies",
				points = 20,
				breed_tags = {
					{
						"ogryn",
						"melee"
					}
				}
			},
			{
				"spawn_by_points",
				passive = true,
				limit_spawners = 6,
				max_breed_amount = 6,
				spawner_group = "spawner_passive_heavies_2",
				points = 20,
				breed_tags = {
					{
						"ogryn",
						"melee"
					}
				}
			},
			{
				"delay",
				duration = 10
			},
			{
				"start_terror_event",
				start_event_name = "km_heresy_ritualists"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions_in_level("ritualist") < 16
				end
			},
			{
				"flow_event",
				flow_event_name = "heresy_event_start"
			},
			{
				"flow_event",
				flow_event_name = "end_event_guards_dead"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions_in_level("ritualist") < 11
				end
			},
			{
				"flow_event",
				flow_event_name = "end_event_shield_1"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions_in_level("ritualist") < 6
				end
			},
			{
				"flow_event",
				flow_event_name = "end_event_shield_2"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions_in_level("ritualist") < 1
				end
			},
			{
				"flow_event",
				flow_event_name = "end_event_shield_3"
			}
		},
		km_heresy_ritualists = {
			{
				"spawn_by_breed_name",
				breed_amount = 16,
				breed_name = "cultist_ritualist",
				limit_spawners = 16,
				spawner_group = "spawner_passive_ritualist"
			}
		},
		km_heresy_kill_target_wave = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_cathedral",
				template_name = "low_melee"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cathedral",
				limit_spawners = 3,
				points = 30,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 40
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 3
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 10
				end
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
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
				spawner_group = "spawner_cathedral",
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
				"spawn_by_points",
				spawner_group = "spawner_cathedral",
				limit_spawners = 3,
				points = 32,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 40
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 3
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 10
				end
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"disabler",
						"special"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_cathedral",
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
				"spawn_by_points",
				spawner_group = "spawner_cathedral",
				limit_spawners = 3,
				points = 20,
				breed_tags = {
					{
						"close",
						"roamer"
					}
				}
			},
			{
				"delay",
				duration = 40
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 3
				end
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 10
				end
			},
			{
				"start_terror_event",
				start_event_name = "km_heresy_kill_target_wave"
			}
		},
		km_heresy_kill_target_shield_down_1 = {
			{
				"spawn_by_points",
				spawner_group = "spawner_cathedral",
				limit_spawners = 2,
				points = 10,
				breed_tags = {
					{
						"ogryn",
						"far"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cathedral",
				limit_spawners = 1,
				points = 10,
				breed_tags = {
					{
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 5
			}
		},
		km_heresy_kill_target_shield_down_2 = {
			{
				"spawn_by_points",
				spawner_group = "spawner_cathedral",
				limit_spawners = 2,
				points = 10,
				breed_tags = {
					{
						"elite",
						"close"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cathedral",
				limit_spawners = 1,
				points = 10,
				breed_tags = {
					{
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 5
			}
		},
		km_heresy_kill_target_shield_down_3 = {
			{
				"spawn_by_points",
				spawner_group = "spawner_cathedral",
				limit_spawners = 2,
				points = 10,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cathedral",
				limit_spawners = 1,
				points = 10,
				breed_tags = {
					{
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 5
			}
		},
		km_heresy_kill_target_shield_down_4 = {
			{
				"spawn_by_points",
				spawner_group = "spawner_cathedral",
				limit_spawners = 2,
				points = 10,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"spawn_by_points",
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_cathedral",
				limit_spawners = 1,
				points = 10,
				breed_tags = {
					{
						"horde"
					}
				}
			},
			{
				"delay",
				duration = 5
			}
		},
		km_heresy_kill_target_guards = {
			{
				"debug_print",
				text = "Kill event: Guards spawned",
				duration = 3
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"debug_print",
				text = "Kill event: Guards dead",
				duration = 3
			},
			{
				"flow_event",
				flow_event_name = "cathedral_guards_dead"
			}
		},
		km_heresy_kill_target_reinforcements = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"debug_print",
				text = "Kill event: Reinforcements spawned",
				duration = 3
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"debug_print",
				text = "Kill event: Reinforcements dead",
				duration = 3
			},
			{
				"flow_event",
				flow_event_name = "cathedral_reinforcements_dead"
			}
		},
		km_heresy_end_event = {
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "kill_event_finished"
			}
		},
		km_heresy_kill_target = {
			{
				"debug_print",
				text = "Kill event: Target spawned",
				duration = 3
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_terror_event",
				start_event_name = "km_heresy_kill_target_wave"
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_cathedral",
				template_name = "low_melee"
			},
			{
				"delay",
				duration = 60
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"stop_terror_trickle"
			},
			{
				"debug_print",
				text = "Kill event: Target dead",
				duration = 3
			},
			{
				"flow_event",
				flow_event_name = "cathedral_kill_target_dead"
			}
		},
		km_heresy_spawn_sniper = {
			{
				"try_inject_special_minion",
				limit_spawners = 1,
				max_breed_amount = 2,
				spawner_group = "spawner_sniper",
				points = 8,
				breed_tags = {
					{
						"special",
						"sniper"
					}
				}
			}
		}
	}
}

return template
