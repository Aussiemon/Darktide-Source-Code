-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_test.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		spawn_random_difficulty = {
			"spawn_easy",
			1,
			"spawn_medium",
			1,
			"spawn_hard",
			1
		}
	},
	events = {
		spawn_easy = {
			{
				"debug_print",
				text = "Prepare for Easy Wave 1/1 (horde/melee, 2 points)...",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "left_gate",
				points = 6,
				breed_tags = {
					{
						"horde"
					},
					{
						"melee"
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
				"debug_print",
				text = "Easy Wave 1/1 completed",
				duration = 3
			}
		},
		spawn_medium = {
			{
				"debug_print",
				text = "Prepare for Medium Wave 1/2 (horde/melee, 6 points)...",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "all_gates",
				points = 6,
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
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"debug_print",
				text = "Medium Wave 1/2 completed",
				duration = 3
			},
			{
				"debug_print",
				text = "Prepare for Medium Wave 2/2 (melee, 10 points)...",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "all_gates",
				points = 10,
				breed_tags = {
					{
						"melee"
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
				"debug_print",
				text = "Medium Wave 2/2 completed",
				duration = 3
			}
		},
		spawn_hard = {
			{
				"debug_print",
				text = "Prepare for Hard Wave 1/2 (elite, 6 points)...",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "all_gates",
				points = 6,
				breed_tags = {
					{
						"elite"
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
				"debug_print",
				text = "Hard Wave 1/2 completed",
				duration = 3
			},
			{
				"debug_print",
				text = "Prepare for Hard Wave 2/2 (elite, 12 points)...",
				duration = 3
			},
			{
				"spawn_by_points",
				spawner_group = "all_gates",
				points = 12,
				breed_tags = {
					{
						"elite"
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
				"debug_print",
				text = "Hard Wave 2/2 completed",
				duration = 3
			}
		},
		test_all_functions = {
			{
				"debug_print",
				text = "delay 3 sec...",
				duration = 3
			},
			{
				"delay",
				duration = 3
			},
			{
				"debug_print",
				text = "delay done",
				duration = 3
			},
			{
				"debug_print",
				text = "continue_when (Press C within 10 sec)...",
				duration = 3
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return Keyboard.button(Keyboard.button_index("c")) > 0
				end
			},
			{
				"debug_print",
				text = "continue_when done",
				duration = 3
			},
			{
				"debug_print",
				text = "continue_when (Press C within 10 sec)...",
				duration = 3
			},
			{
				"continue_when",
				duration = 10,
				condition = function ()
					return Keyboard.button(Keyboard.button_index("c")) > 0
				end
			},
			{
				"debug_print",
				text = "continue_when done",
				duration = 3
			},
			{
				"debug_print",
				text = "start_terror_event...",
				duration = 3
			},
			{
				"start_terror_event",
				start_event_name = "test_nested_terror_event"
			},
			{
				"debug_print",
				text = "start_terror_event done",
				duration = 3
			},
			{
				"debug_print",
				text = "stop_terror_event...",
				duration = 3
			},
			{
				"stop_terror_event",
				stop_event_name = "test_nested_terror_event"
			},
			{
				"debug_print",
				text = "stop_terror_event done",
				duration = 3
			},
			{
				"debug_print",
				text = "flow_event...",
				duration = 3
			},
			{
				"flow_event",
				flow_event_name = "terror_event_test_flow_event"
			},
			{
				"debug_print",
				text = "flow_event done",
				duration = 3
			},
			{
				"debug_print",
				text = "play_2d_sound...",
				duration = 3
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_signal_horde_poxwalkers_2d"
			},
			{
				"debug_print",
				text = "play_2d_sound done",
				duration = 3
			}
		},
		test_nested_terror_event = {
			{
				"debug_print",
				text = "running nested event 1",
				duration = 1
			},
			{
				"debug_print",
				text = "running nested event 2",
				duration = 1
			},
			{
				"debug_print",
				text = "running nested event 3",
				duration = 1
			},
			{
				"debug_print",
				text = "running nested event 4",
				duration = 1
			},
			{
				"debug_print",
				text = "running nested event 5",
				duration = 1
			},
			{
				"debug_print",
				text = "running nested event 6",
				duration = 1
			},
			{
				"debug_print",
				text = "running nested event 7",
				duration = 1
			},
			{
				"debug_print",
				text = "running nested event 8",
				duration = 1
			},
			{
				"debug_print",
				text = "running nested event 9",
				duration = 1
			},
			{
				"debug_print",
				text = "running nested event 10",
				duration = 1
			}
		}
	}
}

return template
