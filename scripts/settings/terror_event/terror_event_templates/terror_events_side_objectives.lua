local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		spawn_so_dem_guards = {
			"spawn_so_dem_guards_1",
			1,
			"spawn_so_dem_guards_2",
			1,
			"spawn_so_dem_guards_3",
			1
		},
		so_dem_destroyed = {
			"so_dem_specials_1",
			1,
			"so_dem_specials_2",
			1,
			"so_dem_specials_3",
			1
		}
	},
	events = {
		spawn_so_dem_guards_1 = {
			{
				"spawn_by_points",
				spawner_group = "spawner_so_dem_guards",
				limit_spawners = 3,
				points = 6,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"debug_print",
				text = "spawn_so_dem_guards_1",
				duration = 1
			},
			{
				"flow_event",
				flow_event_name = "spawn_so_dem_guards_1_completed"
			}
		},
		spawn_so_dem_guards_2 = {
			{
				"spawn_by_points",
				spawner_group = "spawner_so_dem_guards",
				limit_spawners = 3,
				points = 9,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"debug_print",
				text = "spawn_so_dem_guards_2",
				duration = 1
			},
			{
				"flow_event",
				flow_event_name = "spawn_so_dem_guards_2_completed"
			}
		},
		spawn_so_dem_guards_3 = {
			{
				"spawn_by_points",
				spawner_group = "spawner_so_dem_guards",
				limit_spawners = 4,
				points = 15,
				breed_tags = {
					{
						"melee",
						"elite"
					}
				}
			},
			{
				"debug_print",
				text = "spawn_so_dem_guards_3",
				duration = 1
			},
			{
				"flow_event",
				flow_event_name = "spawn_so_dem_guards_3_completed"
			}
		},
		so_dem_specials_1 = {
			{
				"spawn_by_points",
				spawner_group = "spawner_dem_specials",
				limit_spawners = 1,
				points = 6,
				breed_tags = {
					{
						"monster"
					}
				}
			},
			{
				"flow_event",
				flow_event_name = "so_dem_specials_1_completed"
			}
		},
		so_dem_specials_2 = {
			{
				"spawn_by_points",
				spawner_group = "spawner_dem_specials",
				limit_spawners = 1,
				points = 6,
				breed_tags = {
					{
						"bomber"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_dem_specials",
				limit_spawners = 1,
				points = 12,
				breed_tags = {
					{
						"sniper"
					}
				}
			},
			{
				"flow_event",
				flow_event_name = "so_dem_specials_2_completed"
			}
		},
		so_dem_specials_3 = {
			{
				"try_inject_special_minion",
				points = 12,
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"flow_event",
				flow_event_name = "so_dem_specials_3_completed"
			}
		}
	}
}

return template
