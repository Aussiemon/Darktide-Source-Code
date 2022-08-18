local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
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
		event_sewers_horde = {
			{
				"debug_print",
				text = "horde_incoming!",
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
				"spawn_by_points",
				spawner_group = "horde_spawner_sewers",
				limit_spawners = 1,
				points = 16,
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
