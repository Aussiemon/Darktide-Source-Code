-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_op_train.lua

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
		event_stop_trickle = {
			{
				"stop_terror_trickle"
			}
		},
		event_trickle = {
			{
				"start_terror_trickle",
				delay = 8,
				proximity_spawners = true,
				spawner_group = "trickle_spawner",
				template_name = "high_mixed"
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				proximity_spawners = true,
				spawner_group = "trickle_spawner",
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
				duration = 4
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
				"continue_when",
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end
			},
			{
				"flow_event",
				flow_event_name = "trickle_end_first"
			}
		},
		trickle_ship_1_test = {
			{
				"spawn_by_points",
				spawner_group = "event_ship_1",
				limit_spawners = 3,
				points = 15,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "trickle_spawner",
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
				"delay",
				duration = 5
			},
			{
				"try_inject_special_minion",
				points = 12,
				max_breed_amount = 1,
				spawner_group = "trickle_spawner",
				breed_tags = {
					{
						"special"
					}
				}
			},
			{
				"spawn_by_points",
				spawner_group = "event_ship_1",
				limit_spawners = 3,
				points = 15,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"start_terror_trickle",
				spawner_group = "trickle_spawner",
				proximity_spawners = true,
				template_name = "standard_melee",
				delay = 8,
				limit_spawners = 2
			},
			{
				"delay",
				duration = 36
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
				"start_terror_event",
				start_event_name = "trickle_ship_1_test"
			}
		},
		trickle_ship_2_test = {
			{
				"spawn_by_points",
				spawner_group = "event_ship_1",
				limit_spawners = 2,
				points = 12,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
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
				"start_terror_event",
				start_event_name = "trickle_ship_2_test"
			}
		},
		locomotive_kill_target = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "cultist_captain",
				mission_objective_id = "objective_flash_train_eliminate_target",
				spawner_group = "spawner_boss",
				limit_spawners = 1
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
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end
			},
			{
				"flow_event",
				flow_event_name = "platform_kill_target_dead"
			}
		},
		trickle_end = {
			{
				"spawn_by_points",
				spawner_group = "spawner_end_platform",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"melee",
						"horde"
					}
				}
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"spawn_by_points",
				spawner_group = "spawner_end_ranged",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end
			},
			{
				"flow_event",
				flow_event_name = "trickle_end_complete"
			}
		},
		last_trickle = {
			{
				"spawn_by_points",
				spawner_group = "spawner_end_ranged",
				limit_spawners = 2,
				points = 8,
				breed_tags = {
					{
						"far",
						"roamer"
					}
				}
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() < 1
				end
			},
			{
				"flow_event",
				flow_event_name = "extract"
			}
		}
	}
}

return template
