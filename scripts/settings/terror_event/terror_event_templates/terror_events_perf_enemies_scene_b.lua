local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {},
	events = {
		pacing_off = {
			{
				"set_pacing_enabled",
				enabled = false
			}
		},
		spawn_enemies_group_1 = {
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_newly_infected",
				limit_spawners = 10,
				spawner_group = "spawner_row_1"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_1"
			}
		},
		spawn_enemies_group_2 = {
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_newly_infected",
				limit_spawners = 10,
				spawner_group = "spawner_row_2"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_2"
			}
		},
		spawn_enemies_group_3 = {
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_newly_infected",
				limit_spawners = 10,
				spawner_group = "spawner_row_3"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_3"
			}
		},
		spawn_enemies_group_4 = {
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_poxwalker",
				limit_spawners = 10,
				spawner_group = "spawner_row_4"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_4"
			}
		},
		spawn_enemies_group_5 = {
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_poxwalker",
				limit_spawners = 10,
				spawner_group = "spawner_row_5"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_5"
			}
		},
		spawn_enemies_group_6 = {
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_newly_infected",
				limit_spawners = 10,
				spawner_group = "spawner_row_6"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_6"
			}
		},
		spawn_enemies_group_7 = {
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_poxwalker",
				limit_spawners = 10,
				spawner_group = "spawner_row_7"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_7"
			}
		},
		spawn_enemies_group_8 = {
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_poxwalker",
				limit_spawners = 10,
				spawner_group = "spawner_row_8"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_8"
			}
		},
		spawn_enemies_group_9 = {
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "renegade_rifleman",
				limit_spawners = 10,
				spawner_group = "spawner_row_9"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_9"
			}
		},
		spawn_enemies_group_10 = {
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_rifleman",
				limit_spawners = 5,
				spawner_group = "spawner_row_10"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_10"
			}
		},
		spawn_enemies_group_11 = {
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_gunner",
				limit_spawners = 2,
				spawner_group = "spawner_row_10"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_11"
			}
		},
		spawn_enemies_group_12 = {
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "cultist_gunner",
				limit_spawners = 2,
				spawner_group = "spawner_row_10"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_12"
			}
		},
		spawn_enemies_group_13 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_ogryn_gunner",
				limit_spawners = 1,
				spawner_group = "spawner_row_10"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_13"
			}
		},
		spawn_enemies_group_14 = {
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "renegade_melee",
				limit_spawners = 10,
				spawner_group = "spawner_row_11"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_14"
			}
		},
		spawn_enemies_group_15 = {
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_melee",
				limit_spawners = 5,
				spawner_group = "spawner_row_12"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_15"
			}
		},
		spawn_enemies_group_16 = {
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_gunner",
				limit_spawners = 2,
				spawner_group = "spawner_row_12"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_16"
			}
		},
		spawn_enemies_group_17 = {
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "cultist_gunner",
				limit_spawners = 2,
				spawner_group = "spawner_row_12"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_17"
			}
		},
		spawn_enemies_group_18 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_ogryn_gunner",
				limit_spawners = 1,
				spawner_group = "spawner_row_12"
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"start_terror_event",
				start_event_name = "spawn_enemies_group_18"
			}
		},
		spawn_bots = {
			{
				"spawn_bot_character",
				profile_name = "bot_1"
			},
			{
				"spawn_bot_character",
				profile_name = "bot_2"
			},
			{
				"spawn_bot_character",
				profile_name = "bot_3"
			}
		}
	}
}

return template
