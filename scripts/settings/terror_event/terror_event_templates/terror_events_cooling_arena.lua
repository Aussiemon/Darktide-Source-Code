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
					"trickle_hordes",
					"monsters"
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
					"trickle_hordes",
					"monsters"
				}
			}
		},
		event_cooling_arena_a = {
			{
				"debug_print",
				text = "event_cooling_a",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal"
			},
			{
				"spawn_bot_character",
				profile_name = "darktide_seven_01"
			},
			{
				"spawn_bot_character",
				profile_name = "darktide_seven_02"
			},
			{
				"spawn_bot_character",
				profile_name = "darktide_seven_03"
			},
			{
				"start_terror_event",
				start_event_name = "steady_horde"
			}
		},
		steady_horde = {
			{
				"spawn_by_points",
				debug_spawners_in_range = 30,
				points = 3,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions_in_level() <= 100
				end
			},
			{
				"start_terror_event",
				start_event_name = "steady_horde_again"
			}
		},
		steady_horde_again = {
			{
				"spawn_by_points",
				debug_spawners_in_range = 30,
				points = 3,
				breed_tags = {
					{
						"horde",
						"melee"
					}
				}
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions_in_level() <= 100
				end
			},
			{
				"start_terror_event",
				start_event_name = "steady_horde"
			}
		}
	}
}

return template
