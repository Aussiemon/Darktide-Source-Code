-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_combat.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {},
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
		event_combat_test_01 = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawners_01_far",
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
				start_event_name = "kill_target_wave"
			},
			{
				"delay",
				duration = 5
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawners_01_far",
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
				flow_event_name = "event_combat_test_01_completed"
			}
		},
		kill_target_wave = {
			{
				"debug_print",
				text = "event_reactor_cooling_a",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawners_01_far",
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
				spawner_group = "spawners_01_far",
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
				spawner_group = "spawners_01_far",
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
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
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
				spawner_group = "spawners_01_far",
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
				spawner_group = "spawners_01_far",
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
				"start_terror_event",
				start_event_name = "kill_target_wave"
			}
		},
		test_hatchet_spawners = {
			{
				"spawn_by_points",
				limit_spawners = 10,
				max_breed_amount = 20,
				spawner_group = "spawners_hatchet",
				spawn_delay = 0.5,
				points = 20,
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
