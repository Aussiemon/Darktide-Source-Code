local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {},
	events = {
		km_station_kill_target = {
			{
				"spawn_by_points",
				attack_selection_template_tag = "ranged",
				limit_spawners = 1,
				max_breed_amount = 1,
				spawner_group = "spawner_platform_target",
				points = 10,
				breed_tags = {
					{
						"captain"
					}
				}
			},
			{
				"debug_print",
				text = "Kill event: Target spawned",
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
				text = "Kill event: Target dead",
				duration = 3
			},
			{
				"flow_event",
				flow_event_name = "platform_kill_target_dead"
			}
		},
		km_station_kill_target_guards = {
			{
				"spawn_by_points",
				spawner_group = "spawner_platform_guards",
				limit_spawners = 2,
				points = 12,
				breed_tags = {
					{
						"elite"
					}
				}
			},
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
		km_station_kill_target_reinforcements = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_platform_reinforcements",
				limit_spawners = 8,
				points = 10,
				breed_tags = {
					{
						"roamer"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_platform_reinforcements",
				limit_spawners = 8,
				points = 10,
				breed_tags = {
					{
						"horde"
					}
				}
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
				flow_event_name = "platform_reinforcements_dead"
			}
		}
	}
}

return template
