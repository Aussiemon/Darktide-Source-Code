local template = {
	random_events = {},
	events = {
		spawn_enemies = {
			{
				"set_pacing_enabled",
				enabled = false
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_newly_infected",
				limit_spawners = 10,
				spawner_group = "spawner_row_1"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_newly_infected",
				limit_spawners = 10,
				spawner_group = "spawner_row_2"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_newly_infected",
				limit_spawners = 10,
				spawner_group = "spawner_row_3"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_poxwalker",
				limit_spawners = 10,
				spawner_group = "spawner_row_4"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_poxwalker",
				limit_spawners = 10,
				spawner_group = "spawner_row_5"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_newly_infected",
				limit_spawners = 10,
				spawner_group = "spawner_row_6"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_poxwalker",
				limit_spawners = 10,
				spawner_group = "spawner_row_7"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "chaos_poxwalker",
				limit_spawners = 10,
				spawner_group = "spawner_row_8"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "renegade_rifleman",
				limit_spawners = 10,
				spawner_group = "spawner_row_9"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_rifleman",
				limit_spawners = 5,
				spawner_group = "spawner_row_10"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_gunner",
				limit_spawners = 2,
				spawner_group = "spawner_row_10"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "cultist_gunner",
				limit_spawners = 2,
				spawner_group = "spawner_row_10"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_ogryn_gunner",
				limit_spawners = 1,
				spawner_group = "spawner_row_10"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 10,
				breed_name = "renegade_melee",
				limit_spawners = 10,
				spawner_group = "spawner_row_11"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 5,
				breed_name = "renegade_melee",
				limit_spawners = 5,
				spawner_group = "spawner_row_12"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "renegade_gunner",
				limit_spawners = 2,
				spawner_group = "spawner_row_12"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 2,
				breed_name = "cultist_gunner",
				limit_spawners = 2,
				spawner_group = "spawner_row_12"
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_ogryn_gunner",
				limit_spawners = 1,
				spawner_group = "spawner_row_12"
			}
		},
		spawn_bots = {}
	}
}

return template
