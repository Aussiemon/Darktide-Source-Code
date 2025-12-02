-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_op_no_mans_land.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		op_no_mans_land_trenches_random_a = {
			"event_no_mans_land_trenches_a",
			1,
			"event_no_mans_land_trenches_b",
			1,
		},
		op_no_mans_land_trenches_random_b = {
			"event_no_mans_land_trenches_c",
			1,
			"event_no_mans_land_trenches_d",
			1,
		},
		op_no_mans_land_trenches_random_c = {
			"event_no_mans_land_trenches_e",
			1,
			"event_no_mans_land_trenches_f",
			1,
		},
		op_no_mans_land_dead_zone_random = {
			"event_no_mans_land_bastion_dead_zone_01",
			1,
			"event_no_mans_land_bastion_dead_zone_02",
			1,
		},
		op_no_mans_land_bastion_monster_random = {
			"event_no_mans_land_bastion_spawn_cs",
			1,
			"event_no_mans_land_bastion_spawn_po",
			1,
		},
	},
	events = {
		event_pacing_off = {
			{
				"set_pacing_enabled",
				enabled = false,
			},
		},
		event_pacing_on = {
			{
				"set_pacing_enabled",
				enabled = true,
			},
		},
		event_hordes_off = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
				},
			},
		},
		event_hordes_on = {
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
				},
			},
		},
		event_only_roamers_specials_enabled = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"trickle_hordes",
				},
			},
		},
		event_only_roamers_enabled = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"trickle_hordes",
					"specials",
					"monsters",
				},
			},
		},
		event_only_specials_enabled = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
					"monsters",
				},
			},
		},
		event_turn_all_on = {
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
					"specials",
					"monsters",
				},
			},
		},
		event_pacing_on_stop_trickle = {
			{
				"stop_terror_trickle",
			},
			{
				"set_pacing_enabled",
				enabled = true,
			},
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
					"specials",
					"monsters",
				},
			},
		},
		event_no_mans_land_trenches_first = {
			{
				"spawn_by_points",
				passive = false,
				points = 8,
				spawner_group = "spawner_no_mans_land_trenches_first",
				breed_tags = {
					{
						"horde",
					},
				},
			},
		},
		event_no_mans_land_trenches_a = {
			{
				"spawn_by_points",
				passive = false,
				points = 12,
				spawner_group = "spawner_no_mans_land_trenches_a",
				breed_tags = {
					{
						"far",
					},
				},
			},
		},
		event_no_mans_land_trenches_b = {
			{
				"spawn_by_points",
				passive = false,
				points = 14,
				spawner_group = "spawner_no_mans_land_trenches_b",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
		},
		event_no_mans_land_trenches_c = {
			{
				"spawn_by_points",
				passive = false,
				points = 10,
				spawner_group = "spawner_no_mans_land_trenches_c",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
		},
		event_no_mans_land_trenches_d = {
			{
				"spawn_by_points",
				passive = false,
				points = 14,
				spawner_group = "spawner_no_mans_land_trenches_d",
				breed_tags = {
					{
						"horde",
					},
				},
			},
		},
		event_no_mans_land_trenches_e = {
			{
				"spawn_by_points",
				passive = false,
				points = 16,
				spawner_group = "spawner_no_mans_land_trenches_e",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
		},
		event_no_mans_land_trenches_f = {
			{
				"spawn_by_points",
				passive = false,
				points = 20,
				spawner_group = "spawner_no_mans_land_trenches_f",
				breed_tags = {
					{
						"horde",
					},
				},
			},
		},
		event_no_mans_land_ruined_archway_a = {
			{
				"spawn_by_points",
				passive = false,
				points = 18,
				spawner_group = "spawner_no_mans_land_ruined_archway_a",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
		},
		event_no_mans_land_ruined_archway_b = {
			{
				"spawn_by_points",
				passive = false,
				points = 18,
				spawner_group = "spawner_no_mans_land_ruined_archway_b",
				breed_tags = {
					{
						"far",
					},
				},
			},
		},
		event_no_mans_land_bastion_dead_zone_01 = {
			{
				"spawn_by_points",
				passive = false,
				points = 16,
				spawner_group = "spawner_bastion_dead_zone",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
		},
		event_no_mans_land_bastion_dead_zone_02 = {
			{
				"spawn_by_points",
				passive = false,
				points = 24,
				spawner_group = "spawner_bastion_dead_zone",
				breed_tags = {
					{
						"horde",
					},
				},
			},
		},
		event_no_mans_land_bastion_pre_event = {
			{
				"spawn_by_points",
				passive = false,
				points = 20,
				spawner_group = "spawner_bastion_pre_event",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 12,
				spawner_group = "spawner_bastion_pre_event",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 10,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 14,
				spawner_group = "spawner_bastion_pre_event_b",
				breed_tags = {
					{
						"horde",
					},
				},
			},
		},
		event_no_mans_land_ruined_archway_bridge_elite = {
			{
				"spawn_by_points",
				passive = false,
				points = 8,
				spawner_group = "spawner_no_mans_land_elite_bridge",
				breed_tags = {
					{
						"elite",
					},
				},
			},
		},
		event_no_mans_land_ruined_archway_bridge_trickle = {
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_no_mans_land_trickle_bridge",
				template_name = "standard_melee",
			},
		},
		event_no_mans_land_bastion_trickle = {
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_bastion_trickle",
				template_name = "standard_melee",
			},
		},
		event_no_mans_land_bastion_stop_trickle = {
			{
				"stop_terror_trickle",
			},
		},
		event_no_mans_land_bastion_west_guard = {
			{
				"spawn_by_points",
				limit_spawners = 20,
				max_breed_amount = 20,
				passive = true,
				points = 25,
				spawner_group = "spawner_bastion_west_guard",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_almost_dead",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_dead",
			},
		},
		event_no_mans_land_bastion_west_elite = {
			{
				"spawn_by_points",
				limit_spawners = 8,
				max_breed_amount = 8,
				passive = true,
				points = 14,
				spawner_group = "spawner_bastion_west_elite",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_almost_dead",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_dead",
			},
		},
		event_no_mans_land_bastion_west_ranged = {
			{
				"spawn_by_points",
				limit_spawners = 5,
				max_breed_amount = 5,
				passive = true,
				points = 8,
				spawner_group = "spawner_bastion_west_ranged",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_almost_dead",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_dead",
			},
		},
		event_no_mans_land_bastion_west_ranged_elite = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				max_breed_amount = 3,
				passive = true,
				points = 6,
				spawner_group = "spawner_bastion_west_ranged_elite",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_almost_dead",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_dead",
			},
		},
		event_no_mans_land_bastion_center_guard = {
			{
				"spawn_by_points",
				limit_spawners = 9,
				max_breed_amount = 9,
				passive = true,
				points = 12,
				spawner_group = "spawner_bastion_center_guard",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_almost_dead",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_dead",
			},
		},
		event_no_mans_land_bastion_center_elite = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				max_breed_amount = 3,
				passive = true,
				points = 6,
				spawner_group = "spawner_bastion_center_elite",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_almost_dead",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_dead",
			},
		},
		event_no_mans_land_bastion_east_guard = {
			{
				"spawn_by_points",
				limit_spawners = 16,
				max_breed_amount = 16,
				passive = true,
				points = 20,
				spawner_group = "spawner_bastion_east_guard",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_almost_dead",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_dead",
			},
		},
		event_no_mans_land_bastion_east_elite = {
			{
				"spawn_by_points",
				limit_spawners = 12,
				max_breed_amount = 12,
				passive = true,
				points = 20,
				spawner_group = "spawner_bastion_east_elite",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_almost_dead",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_dead",
			},
		},
		event_no_mans_land_tag_remaining_enemies = {
			{
				"lua_event",
				target_event = "event_tag_remaining_enemies",
			},
		},
		event_no_mans_land_bastion_basement_01 = {
			{
				"spawn_by_points",
				passive = false,
				points = 18,
				spawner_group = "spawner_bastion_basement_01",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				max_breed_amount = 3,
				passive = false,
				points = 14,
				spawner_group = "spawner_bastion_basement_01",
				breed_tags = {
					{
						"elite",
					},
				},
			},
		},
		event_no_mans_land_bastion_basement_02 = {
			{
				"spawn_by_points",
				limit_spawners = 5,
				max_breed_amount = 5,
				passive = true,
				points = 10,
				spawner_group = "spawner_bastion_basement_02_elite",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 10,
				max_breed_amount = 10,
				passive = true,
				points = 14,
				spawner_group = "spawner_bastion_basement_02_roamer",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_guards_dead",
			},
		},
		event_no_mans_land_bastion_basement_trickle = {
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_bastion_basement_trickle",
				template_name = "standard_melee",
			},
		},
		event_no_mans_land_bastion_pre_monster = {
			{
				"spawn_by_points",
				passive = false,
				points = 20,
				spawner_group = "spawner_bastion_pre_monster",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 18,
				spawner_group = "spawner_bastion_pre_monster",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_bastion_pre_monster",
				breed_tags = {
					{
						"elite",
					},
				},
			},
		},
		event_no_mans_land_bastion_spawn_cs = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				spawner_group = "spawner_fortification_monster_cs",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_fortification_monster_po",
				entry_condition_function = function ()
					return TerrorEventQueries.is_in_target_difficulty(4)
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_monster_dead",
			},
		},
		event_no_mans_land_bastion_spawn_po = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spawner_fortification_monster_po",
			},
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spawner_fortification_monster_cs",
				entry_condition_function = function ()
					return TerrorEventQueries.is_in_target_difficulty(4)
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "event_bastion_monster_dead",
			},
		},
		event_no_mans_land_bastion_end_spawn = {
			{
				"spawn_by_points",
				limit_spawners = 6,
				passive = false,
				points = 18,
				spawner_group = "spawner_bastion_end_spawn",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 6,
				passive = false,
				points = 8,
				spawner_group = "spawner_bastion_end_spawn",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 6,
				passive = false,
				points = 8,
				spawner_group = "spawner_bastion_end_spawn",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
		},
	},
}

return template
