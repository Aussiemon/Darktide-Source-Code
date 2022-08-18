local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	events = {
		test_event_1 = {
			{
				"spawn_by_points",
				spawner_group = "back",
				limit_spawners = 2,
				points = 10,
				breed_tags = {
					{
						"roamer",
						"melee"
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
				flow_event_name = "kill_event_guards_dead"
			}
		},
		test_event_2 = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_by_points",
				spawner_group = "hidden_spawner",
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
				flow_event_name = "kill_event_reinforcements_dead"
			}
		}
	}
}

return template
