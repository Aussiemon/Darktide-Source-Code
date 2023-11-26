-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_km_enforcer.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		km_enforcer_wave_1 = {
			"event_ascender_trickle_a",
			1,
			"event_ascender_trickle_b",
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
		event_only_specials_disabled = {
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
					"monsters"
				}
			},
			{
				"stop_terror_trickle"
			}
		},
		event_pacing_on_no_hordes = {
			{
				"set_pacing_enabled",
				enabled = true
			},
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"roamers",
					"monsters",
					"specials"
				}
			},
			{
				"stop_terror_trickle"
			}
		},
		event_pacing_enable_hordes = {
			{
				"set_pacing_enabled",
				enabled = true
			},
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
					"trickle_hordes"
				}
			}
		},
		event_ascender_trickle_a = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ascender_trickle_a",
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
				"spawn_by_points",
				spawner_group = "spawner_ascender_trickle_a",
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
				duration = 8
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_ascender_trickle_a",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ascender_trickle_a",
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
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ascender_trickle_b",
				limit_spawners = 3,
				points = 20,
				breed_tags = {
					{
						"melee",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ascender_trickle_b",
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
				"try_inject_special_minion",
				spawner_group = "spawner_ascender_trickle_a",
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
				duration = 6
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_ascender_trickle_b",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ascender_trickle_c",
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
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "km_enforcer_wave_1"
			}
		},
		event_ascender_trickle_b = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ascender_trickle_b",
				limit_spawners = 3,
				points = 20,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ascender_trickle_b",
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
				"spawn_by_points",
				spawner_group = "spawner_ascender_trickle_b",
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
				"try_inject_special_minion",
				spawner_group = "spawner_ascender_trickle_c",
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
				duration = 8
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_ascender_trickle_b",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ascender_trickle_b",
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
				"continue_when",
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ascender_trickle_c",
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
				"try_inject_special_minion",
				spawner_group = "spawner_ascender_trickle_b",
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
				duration = 6
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_ascender_trickle_a",
				template_name = "standard_melee"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_ascender_trickle_b",
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
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end
			},
			{
				"start_random_terror_event",
				start_event_name = "km_enforcer_wave_1"
			}
		},
		event_ascender_trickle_c = {
			{
				"debug_print",
				text = "event_ascender_trickle_c",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"delay",
				duration = 1
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_ascender_trickle_c",
				template_name = "low_melee"
			}
		},
		km_enforcer_kill_target = {
			{
				"spawn_by_points",
				mission_objective_id = "objective_km_enforcer_eliminate_target",
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_enforcer_command_target",
				points = 10,
				breed_tags = {
					{
						"captain"
					}
				},
				attack_selection_template_tag = {
					"default"
				}
			},
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
				start_event_name = "km_enforcer_kill_target_wave"
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_enforcer_command_middle",
				template_name = "low_melee"
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
				flow_event_name = "platform_kill_target_dead"
			}
		},
		km_enforcer_kill_target_wave = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_enforcer_command_middle",
				limit_spawners = 3,
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
				duration = 40
			},
			{
				"continue_when",
				duration = 40,
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
				"try_inject_special_minion",
				spawner_group = "spawner_enforcer_command_right",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_enforcer_command_left",
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
				spawner_group = "spawner_enforcer_command_left",
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
				duration = 40
			},
			{
				"continue_when",
				duration = 40,
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
				"try_inject_special_minion",
				spawner_group = "spawner_enforcer_command_middle",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_enforcer_command_right",
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
				spawner_group = "spawner_enforcer_command_right",
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
				"delay",
				duration = 40
			},
			{
				"continue_when",
				duration = 40,
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
				"spawn_by_points",
				spawner_group = "spawner_enforcer_command_middle",
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
				"delay",
				duration = 5
			},
			{
				"try_inject_special_minion",
				spawner_group = "spawner_enforcer_command_right",
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
				"try_inject_special_minion",
				spawner_group = "spawner_enforcer_command_middle",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special"
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
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"start_terror_event",
				start_event_name = "km_enforcer_kill_target_wave"
			}
		},
		km_enforcer_kill_target_guards = {
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
				flow_event_name = "platform_guards_dead"
			}
		},
		km_enforcer_kill_target_reinforcements = {
			{
				"delay",
				duration = 5
			}
		},
		km_enforcer_end_event = {
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
		}
	}
}

return template
