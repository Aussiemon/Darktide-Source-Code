local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {},
	events = {
		event_kill_monster_one = {
			{
				"spawn_by_points",
				spawner_group = "monster_spawner_one",
				limit_spawners = 1,
				points = 6,
				breed_tags = {
					{
						"monster"
					}
				}
			},
			{
				"debug_print",
				text = "Kill event: Monster spawned",
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
				text = "Kill event: Monster dead",
				duration = 3
			},
			{
				"flow_event",
				flow_event_name = "kill_monster_dead"
			}
		},
		event_kill_monster_two = {
			{
				"spawn_by_points",
				spawner_group = "monster_spawner_two",
				limit_spawners = 1,
				points = 6,
				breed_tags = {
					{
						"monster"
					}
				}
			},
			{
				"debug_print",
				text = "Kill event: Monster spawned",
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
				text = "Kill event: Monster dead",
				duration = 3
			},
			{
				"flow_event",
				flow_event_name = "kill_monster_dead"
			}
		}
	}
}

return template
