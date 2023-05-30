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
		},
		trickle_m2_test = {
			{
				"delay",
				duration = 1.5
			},
			{
				"spawn_by_points",
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_m2_endevent",
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
				"try_inject_special_minion",
				proximity_spawners = true,
				max_breed_amount = 1,
				spawner_group = "spawner_m2_endevent",
				points = 6,
				breed_tags = {
					{
						"special",
						"scrambler"
					}
				}
			},
			{
				"start_terror_trickle",
				spawner_group = "spawner_m2_endevent",
				proximity_spawners = true,
				template_name = "standard_melee",
				delay = 8,
				limit_spawners = 2
			},
			{
				"delay",
				duration = 32
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"continue_when",
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end
			},
			{
				"flow_event",
				flow_event_name = "trickle_m2_test_completed"
			}
		}
	}
}

return template
