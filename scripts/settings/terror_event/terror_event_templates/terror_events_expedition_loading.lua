-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_expedition_loading.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
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
		disable_monster_pacing = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"monsters",
				},
			},
		},
		location_trickle_01 = {
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_location_01",
				template_name = "low_melee",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_location_01",
				breed_tags = {
					{
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				points = 8,
				spawner_group = "spawner_location_01",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 3,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_location_01",
				breed_tags = {
					{
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				points = 8,
				spawner_group = "spawner_location_01",
				breed_tags = {
					{
						"far",
					},
				},
			},
		},
		location_extraction_01 = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 26,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_location_01",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 10,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 3,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				spawner_group = "spawner_location_01",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"flow_event",
				flow_event_name = "location_extraction_01_completed",
			},
		},
		opportunity_debug_heist_64_trickle_01 = {
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_debug_heist_64_trickle_01",
				template_name = "low_melee",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_debug_heist_64_trickle_01",
				breed_tags = {
					{
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				points = 8,
				spawner_group = "spawner_debug_heist_64_trickle_01",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 5
				end,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 3,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_debug_heist_64_trickle_01",
				breed_tags = {
					{
						"melee",
					},
				},
			},
			{
				"spawn_by_points",
				points = 8,
				spawner_group = "spawner_debug_heist_64_trickle_01",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"flow_event",
				flow_event_name = "debug_heist_64_trickle_done",
			},
		},
		opportunity_debug_trickle_extraction_01 = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 26,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_debug_extraction_01",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 10,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 3,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				spawner_group = "spawner_debug_extraction_01",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"flow_event",
				flow_event_name = "location_extraction_01_completed",
			},
		},
		location_debug_test_proximity = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 26,
				proximity_spawners = true,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_proximity",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 10,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 3,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				proximity_spawners = true,
				spawner_group = "spawner_proximity",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"start_terror_event",
				start_event_name = "location_debug_test_proximity",
			},
		},
		opportunity_debug_test_hatch_01 = {
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 26,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_debug_hatch_01",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 10,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 3,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				spawner_group = "spawner_debug_hatch_01",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 6,
			},
			{
				"flow_event",
				flow_event_name = "location_extraction_01_completed",
			},
		},
		opportunity_64m_kill_target_001 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "cultist_captain",
				limit_spawners = 1,
				mission_objective_id = "objective_flash_train_eliminate_target",
				spawner_group = "spawner_boss",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "kill_target_dead",
			},
		},
	},
}

return template
