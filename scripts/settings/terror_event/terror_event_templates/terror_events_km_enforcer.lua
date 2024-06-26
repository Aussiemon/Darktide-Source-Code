-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_km_enforcer.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		km_enforcer_wave_1 = {
			"event_ascender_trickle_a",
			1,
			"event_ascender_trickle_b",
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
		event_only_specials_enabled = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
				},
			},
		},
		event_only_specials_disabled = {
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
					"roamers",
					"trickle_hordes",
					"monsters",
				},
			},
		},
		event_pacing_on_stop_trickle = {
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
					"monsters",
				},
			},
			{
				"stop_terror_trickle",
			},
		},
		event_pacing_on_no_hordes = {
			{
				"set_pacing_enabled",
				enabled = true,
			},
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"roamers",
					"monsters",
					"specials",
				},
			},
			{
				"stop_terror_trickle",
			},
		},
		event_pacing_enable_hordes = {
			{
				"set_pacing_enabled",
				enabled = true,
			},
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
					"trickle_hordes",
				},
			},
		},
		event_ascender_trickle_a = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "spawner_ascender_trickle_a",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "spawner_ascender_trickle_b",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_ascender_trickle_a",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				spawner_group = "spawner_ascender_trickle_c",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"try_inject_special_minion",
				"spawner_ascender_trickle_c",
				max_breed_amount = 1,
				points = 12,
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_ascender_trickle_a",
				template_name = "standard_melee",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_ascender_trickle_a",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_ascender_trickle_b",
				breed_tags = {
					{
						"melee",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_ascender_trickle_b",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_ascender_trickle_a",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_ascender_trickle_b",
				template_name = "standard_melee",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_ascender_trickle_c",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_ascender_trickle_b",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "km_enforcer_wave_1",
			},
		},
		event_ascender_trickle_b = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "spawner_ascender_trickle_b",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "spawner_ascender_trickle_a",
				breed_tags = {
					{
						"close",
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_ascender_trickle_b",
				breed_tags = {
					{
						"far",
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 10,
				spawner_group = "spawner_ascender_trickle_c",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_ascender_trickle_c",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_terror_trickle",
				spawner_group = "spawner_ascender_trickle_b",
				template_name = "standard_melee",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_ascender_trickle_b",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 50,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 6
				end,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 30,
				spawner_group = "spawner_ascender_trickle_c",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 8,
				spawner_group = "spawner_ascender_trickle_b",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_ascender_trickle_b",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_ascender_trickle_a",
				template_name = "standard_melee",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 20,
				spawner_group = "spawner_ascender_trickle_b",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"continue_when",
				duration = 35,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 4
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "km_enforcer_wave_1",
			},
		},
		event_ascender_trickle_c = {
			{
				"debug_print",
				duration = 3,
				text = "event_ascender_trickle_c",
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 1,
			},
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_ascender_trickle_c",
				template_name = "low_melee",
			},
		},
		km_enforcer_kill_target = {
			{
				"spawn_by_points",
				limit_spawners = 1,
				max_breed_amount = 1,
				mission_objective_id = "objective_km_enforcer_eliminate_target",
				points = 10,
				spawner_group = "spawner_enforcer_command_target",
				breed_tags = {
					{
						"captain",
					},
				},
				attack_selection_template_tag = {
					"default",
				},
			},
			{
				"debug_print",
				duration = 3,
				text = "Kill event: Target spawned",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_terror_event",
				start_event_name = "km_enforcer_kill_target_wave",
			},
			{
				"delay",
				duration = 5,
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_enforcer_command_middle",
				template_name = "low_melee",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"stop_terror_trickle",
			},
			{
				"debug_print",
				duration = 3,
				text = "Kill event: Target dead",
			},
			{
				"flow_event",
				flow_event_name = "platform_kill_target_dead",
			},
		},
		km_enforcer_kill_target_wave = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_enforcer_command_middle",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_enforcer_command_right_back",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_enforcer_command_left_back",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_enforcer_command_right",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 6,
				spawner_group = "spawner_enforcer_command_left",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 25,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_enforcer_command_right",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "spawner_enforcer_command_left_back",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 18,
				spawner_group = "spawner_enforcer_command_left",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 25,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_enforcer_command_middle",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 12,
				spawner_group = "spawner_enforcer_command_right_back",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				spawner_group = "spawner_enforcer_command_right",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 25,
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"spawn_by_points",
				limit_spawners = 3,
				points = 14,
				spawner_group = "spawner_enforcer_command_right",
				breed_tags = {
					{
						"melee",
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				points = 12,
				spawner_group = "spawner_enforcer_command_right_back",
				breed_tags = {
					{
						"special",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_points",
				max_breed_amount = 1,
				points = 16,
				spawner_group = "spawner_enforcer_command_middle",
				breed_tags = {
					{
						"far",
						"roamer",
					},
				},
			},
			{
				"continue_when",
				duration = 40,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 10
				end,
			},
			{
				"start_terror_event",
				start_event_name = "km_enforcer_kill_target_wave",
			},
		},
		km_enforcer_kill_target_guards = {
			{
				"debug_print",
				duration = 3,
				text = "Kill event: Guards spawned",
			},
			{
				"continue_when",
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"debug_print",
				duration = 3,
				text = "Kill event: Guards dead",
			},
			{
				"flow_event",
				flow_event_name = "platform_guards_dead",
			},
		},
		km_enforcer_kill_target_reinforcements = {
			{
				"delay",
				duration = 5,
			},
		},
		km_enforcer_end_event = {
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "kill_event_finished",
			},
		},
	},
}

return template
