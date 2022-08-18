local template = {
	events = {
		kill_event_template_target = {
			{
				"spawn_by_points",
				mission_objective_id = "captain_kill_target",
				spawner_group = "spawner_kill_event_target",
				limit_spawners = 1,
				points = 5,
				breed_tags = {
					{
						"far"
					}
				}
			},
			{
				"debug_print",
				text = "Kill event: Target spawned",
				duration = 3
			}
		},
		kill_event_mission_objectives = {
			{
				"spawn_by_points",
				mission_objective_id = "kill_objective",
				spawner_group = "spawner_kill_event_target",
				limit_spawners = 1,
				points = 1,
				breed_tags = {
					{
						"melee"
					}
				}
			},
			{
				"debug_print",
				text = "Kill event: Target spawned",
				duration = 3
			}
		}
	}
}

return template
