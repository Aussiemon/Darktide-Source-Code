-- chunkname: @scripts/settings/terror_event/terror_event_templates/terror_events_spillway.lua

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local template = {
	random_events = {
		spillway_midevent_wave = {
			"event_spillway_midevent_wave_01",
			1,
			"event_spillway_midevent_wave_02",
			1,
		},
		spillway_first_trap_a = {
			"event_spillway_gas_trap_a_1",
			1,
			"event_spillway_gas_trap_a_2",
			1,
		},
		spillway_first_trap_b = {
			"event_spillway_gas_trap_b_1",
			1,
			"event_spillway_gas_trap_b_2",
			1,
		},
		spillway_first_trap_monster_a = {
			"event_spillway_gas_trap_monster_a_1",
			1,
			"event_spillway_gas_trap_monster_a_2",
			1,
			"event_spillway_gas_trap_monster_a_3",
			1,
		},
		spillway_first_trap_monster_b = {
			"event_spillway_gas_trap_monster_b_1",
			1,
			"event_spillway_gas_trap_monster_b_2",
			1,
			"event_spillway_gas_trap_monster_b_3",
			1,
		},
		spillway_second_trap_a = {
			"event_spillway_second_gas_trap_a_1",
			1,
			"event_spillway_second_gas_trap_a_2",
			1,
		},
		spillway_second_trap_b = {
			"event_spillway_second_gas_trap_b_1",
			1,
			"event_spillway_second_gas_trap_b_2",
			1,
		},
		spillway_second_trap_c = {
			"event_spillway_second_gas_trap_c_1",
			1,
			"event_spillway_second_gas_trap_c_2",
			1,
		},
		spillway_wizard_trickle_tier_1 = {
			"spillway_wizard_elite_trickle_1",
			1,
			"spillway_wizard_elite_trickle_2",
			1,
			"spillway_wizard_elite_trickle_3",
			1,
		},
		spillway_wizard_trickle_tier_2 = {
			"spillway_wizard_elite_trickle_phase_2_1",
			1,
			"spillway_wizard_elite_trickle_phase_2_2",
			1,
			"spillway_wizard_elite_trickle_phase_2_3",
			1,
			"spillway_wizard_elite_trickle_phase_2_1_close",
			1,
			"spillway_wizard_elite_trickle_phase_2_2_close",
			1,
			"spillway_wizard_elite_trickle_phase_2_3_close",
			1,
		},
		spillway_wizard_trickle_tier_3 = {
			"spillway_wizard_elite_trickle_phase_3_1",
			1,
			"spillway_wizard_elite_trickle_phase_3_2",
			1,
			"spillway_wizard_elite_trickle_phase_3_3",
			1,
		},
		spillway_wizard_trickle_final = {
			"spillway_wizard_elite_trickle_final",
			1,
		},
		spillway_wizard_trickle_elite_ogryn_melee = {
			"spillway_wizard_trickle_west_elite_ogryn_melee_only",
			1,
			"spillway_wizard_trickle_east_elite_ogryn_melee_only",
			1,
			"spillway_wizard_trickle_south_elite_ogryn_melee_only",
			1,
		},
		spillway_wizard_retreat_burst = {
			"spillway_wizard_retreat_burst_west",
			1,
			"spillway_wizard_retreat_burst_east",
			1,
			"spillway_wizard_retreat_burst_south",
			1,
		},
		spillway_wizard_retreat_burst_elite = {
			"spillway_wizard_retreat_burst_west_elite",
			1,
			"spillway_wizard_retreat_burst_east_elite",
			1,
			"spillway_wizard_retreat_burst_south_elite",
			1,
		},
		spillway_wizard_retreat_burst_elite_ogryn_mixed = {
			"spillway_wizard_retreat_burst_west_elite_ogryn_mixed",
			1,
			"spillway_wizard_retreat_burst_east_elite_ogryn_mixed",
			1,
			"spillway_wizard_retreat_burst_south_elite_ogryn_mixed",
			1,
		},
		spillway_wizard_retreat_burst_elite_ogryn_melee = {
			"spillway_wizard_retreat_burst_west_elite_ogryn_melee_only",
			1,
			"spillway_wizard_retreat_burst_east_elite_ogryn_melee_only",
			1,
			"spillway_wizard_retreat_burst_south_elite_ogryn_melee_only",
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
		event_hordes_on = {
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
				},
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
		event_hordes_specials_off = {
			{
				"control_pacing_spawns",
				enabled = false,
				spawn_types = {
					"hordes",
					"specials",
				},
			},
		},
		event_hordes_specials_on = {
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"hordes",
					"specials",
				},
			},
		},
		event_pacing_on_stop_trickle = {
			{
				"stop_terror_trickle",
			},
		},
		event_spillway_midevent_trickle = {
			{
				"start_terror_trickle",
				delay = 4,
				spawner_group = "spawner_spillway_midevent",
				template_name = "standard_melee",
			},
		},
		event_spillway_midevent_guards = {
			{
				"spawn_by_points",
				limit_spawners = 19,
				max_breed_amount = 15,
				passive = true,
				points = 38,
				spawner_group = "spawner_spillway_midevent_guards",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"spawn_by_points",
				limit_spawners = 15,
				max_breed_amount = 15,
				passive = true,
				points = 30,
				spawner_group = "spawner_spillway_midevent_guards_elite",
				breed_tags = {
					{
						"elite",
					},
				},
			},
		},
		event_spillway_midevent_wave_01 = {
			{
				"spawn_by_points",
				passive = false,
				points = 10,
				spawner_group = "spawner_spillway_midevent",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_midevent",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_midevent_special",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 2,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_midevent_wave",
			},
		},
		event_spillway_midevent_wave_02 = {
			{
				"spawn_by_points",
				passive = false,
				points = 10,
				spawner_group = "spawner_spillway_midevent",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 16,
				spawner_group = "spawner_spillway_midevent",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 3,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_midevent_special",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"continue_when",
				duration = 30,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 2,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_midevent_wave",
			},
		},
		event_spillway_midevent_kill_target = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "renegade_captain",
				limit_spawners = 1,
				mission_objective_id = "objective_spillway_midevent_eliminate_target",
				spawner_group = "spawner_spillway_midevent_boss",
			},
			{
				"continue_when",
				duration = 150,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "spillway_midevent_kill_target_dead",
			},
		},
		event_spillway_post_midevent_horde = {
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_post_midevent_wave",
				breed_tags = {
					{
						"horde",
					},
				},
			},
		},
		event_spillway_gas_trap_a_1 = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_spillway_gas_trap_back_a",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 8,
				spawner_group = "spawner_spillway_gas_trap_front_a",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_gas_trap_front_a",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_gas_trap_special_a",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_gas_trap_sniper_a",
				breed_tags = {
					{
						"special",
						"sniper",
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
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_gas_trap_special_a",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_gas_trap_front_a",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_spillway_gas_trap_a",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_first_trap_a",
			},
		},
		event_spillway_gas_trap_a_2 = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_spillway_gas_trap_back_a",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_gas_trap_front_a",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 10,
				spawner_group = "spawner_spillway_gas_trap_front_a",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_gas_trap_special_a",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_gas_trap_sniper_a",
				breed_tags = {
					{
						"special",
						"sniper",
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
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_gas_trap_special_a",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_gas_trap_front_a",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_spillway_gas_trap_a",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_first_trap_a",
			},
		},
		event_spillway_gas_trap_b_1 = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_spillway_gas_trap_back_b",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 8,
				spawner_group = "spawner_spillway_gas_trap_front_b",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_gas_trap_front_b",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_gas_trap_special_b",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_gas_trap_sniper_b",
				breed_tags = {
					{
						"special",
						"sniper",
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
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_gas_trap_special_b",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_gas_trap_front_b",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_spillway_gas_trap_b",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_first_trap_b",
			},
		},
		event_spillway_gas_trap_b_2 = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_spillway_gas_trap_back_b",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_gas_trap_front_b",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 10,
				spawner_group = "spawner_spillway_gas_trap_front_b",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_gas_trap_special_b",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_gas_trap_sniper_b",
				breed_tags = {
					{
						"special",
						"sniper",
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
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_gas_trap_special_b",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_gas_trap_front_b",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_spillway_gas_trap_b",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_first_trap_b",
			},
		},
		event_spillway_gas_trap_monster_a_1 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				spawner_group = "spillway_gas_trap_monster_a",
			},
		},
		event_spillway_gas_trap_monster_a_2 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spillway_gas_trap_monster_a",
			},
		},
		event_spillway_gas_trap_monster_a_3 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spillway_gas_trap_monster_a",
			},
		},
		event_spillway_gas_trap_monster_b_1 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_spawn",
				spawner_group = "spillway_gas_trap_monster_b",
			},
		},
		event_spillway_gas_trap_monster_b_2 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_plague_ogryn",
				spawner_group = "spillway_gas_trap_monster_b",
			},
		},
		event_spillway_gas_trap_monster_b_3 = {
			{
				"spawn_by_breed_name",
				breed_amount = 1,
				breed_name = "chaos_beast_of_nurgle",
				spawner_group = "spillway_gas_trap_monster_b",
			},
		},
		event_spillway_second_gas_trap_a_1 = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_spillway_second_gas_trap_back_a",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 8,
				spawner_group = "spawner_spillway_second_gas_trap_front_a",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_second_gas_trap_front_a",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_a",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_a",
				breed_tags = {
					{
						"special",
						"disabler",
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
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_a",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_second_gas_trap_a",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_spillway_second_gas_trap_a",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_second_trap_a",
			},
		},
		event_spillway_second_gas_trap_a_2 = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_spillway_second_gas_trap_back_a",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_second_gas_trap_front_a",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 10,
				spawner_group = "spawner_spillway_second_gas_trap_front_a",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_a",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_a",
				breed_tags = {
					{
						"special",
						"scrambler",
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
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_a",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_second_gas_trap_a",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_spillway_second_gas_trap_a",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_second_trap_a",
			},
		},
		event_spillway_second_gas_trap_b_1 = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_spillway_second_gas_trap_back_b",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 8,
				spawner_group = "spawner_spillway_second_gas_trap_front_b",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_second_gas_trap_front_b",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_b",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_b",
				breed_tags = {
					{
						"special",
						"disabler",
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
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_b",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_second_gas_trap_b",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_spillway_second_gas_trap_b",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_second_trap_b",
			},
		},
		event_spillway_second_gas_trap_b_2 = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_spillway_second_gas_trap_back_b",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_second_gas_trap_front_b",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 10,
				spawner_group = "spawner_spillway_second_gas_trap_front_b",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_b",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_b",
				breed_tags = {
					{
						"special",
						"scrambler",
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
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_b",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_second_gas_trap_b",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_spillway_second_gas_trap_b",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_second_trap_b",
			},
		},
		event_spillway_second_gas_trap_c_1 = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_spillway_second_gas_trap_back_c",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 8,
				spawner_group = "spawner_spillway_second_gas_trap_front_c",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_second_gas_trap_front_c",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_c",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_c",
				breed_tags = {
					{
						"special",
						"disabler",
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
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_c",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_second_gas_trap_c",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_spillway_second_gas_trap_c",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_second_trap_c",
			},
		},
		event_spillway_second_gas_trap_c_2 = {
			{
				"delay",
				duration = 1,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				sound_event_name = "wwise/events/minions/play_terror_event_alarm",
				spawner_group = "spawner_spillway_second_gas_trap_back_c",
				breed_tags = {
					{
						"horde",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_second_gas_trap_front_c",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				passive = false,
				points = 10,
				spawner_group = "spawner_spillway_second_gas_trap_front_c",
				breed_tags = {
					{
						"roamer",
					},
				},
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_c",
				breed_tags = {
					{
						"special",
						"disabler",
					},
				},
			},
			{
				"delay",
				duration = 2,
			},
			{
				"try_inject_special_minion",
				max_breed_amount = 1,
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_c",
				breed_tags = {
					{
						"special",
						"scrambler",
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
				passive = false,
				points = 12,
				spawner_group = "spawner_spillway_second_gas_trap_special_c",
				breed_tags = {
					{
						"special",
						"scrambler",
					},
				},
			},
			{
				"spawn_by_points",
				passive = false,
				points = 6,
				spawner_group = "spawner_spillway_second_gas_trap_c",
				breed_tags = {
					{
						"far",
					},
				},
			},
			{
				"start_terror_trickle",
				delay = 2,
				spawner_group = "spawner_spillway_second_gas_trap_c",
				template_name = "standard_melee",
			},
			{
				"continue_when",
				duration = 20,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_second_trap_c",
			},
		},
		event_spillway_boss_end_level = {
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "boss_event_finished",
			},
		},
		spillway_wizard_fight_start = {
			{
				"control_pacing_spawns",
				enabled = true,
				spawn_types = {
					"special",
				},
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_spillway_boss_event_all",
				template_name = "flood_melee",
			},
		},
		spillway_wizard_shockwave_trickle = {
			{
				"stop_terror_trickle",
			},
			{
				"start_terror_trickle",
				delay = 1,
				spawner_group = "spawner_spillway_boss_event_all",
				template_name = "flood_melee",
			},
		},
		spillway_wizard_hard_mode_trickle = {
			{
				"delay",
				duration = 1,
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_spillway_boss_event_east",
				template_name = "hard_mode_twins_elites",
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_spillway_boss_event_west",
				template_name = "hard_mode_twins_elites",
			},
		},
		spillway_wizard_boss_dead = {
			{
				"set_pacing_enabled",
				enabled = false,
			},
			{
				"stop_terror_trickle",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_wave_phase_1_west",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_wave_phase_1_east",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_wave_phase_1_south",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_wave_phase_2_west",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_wave_phase_2_east",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_wave_phase_2_south",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_wave_phase_3_west",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_wave_phase_3_east",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_wave_phase_3_south",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_1",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_2",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_3",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_2_1",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_2_2",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_2_3",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_2_1_close",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_2_2_close",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_2_3_close",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_3_1",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_3_2",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_3_3",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_final",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_repeatable_wave_01",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_hard_mode_trickle",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_poxwalker_fillers_west",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_poxwalker_fillers_east",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_poxwalker_fillers_south",
			},
		},
		spillway_wizard_boss_end_level = {
			{
				"continue_when",
				duration = 25,
				condition = function ()
					return TerrorEventQueries.num_aggroed_minions_in_level() == 0
				end,
			},
			{
				"flow_event",
				flow_event_name = "boss_event_finished",
			},
		},
		spillway_wizard_stop_introduction_trickle = {
			{
				"stop_terror_trickle",
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_spillway_boss_event_all",
				template_name = "standard_melee",
			},
		},
		spillway_wizard_stop_trickle_tier_1 = {
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_1",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_2",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_3",
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_spillway_boss_event_all",
				template_name = "standard_melee",
			},
		},
		spillway_wizard_stop_trickle_tier_2 = {
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_2_1",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_2_2",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_2_3",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_2_1_close",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_2_2_close",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_2_3_close",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_trickle_west_elite_ogryn_melee_only",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_trickle_east_elite_ogryn_melee_only",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_trickle_south_elite_ogryn_melee_only",
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_spillway_boss_event_all",
				template_name = "standard_melee",
			},
		},
		spillway_wizard_stop_trickle_tier_3 = {
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_3_1",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_3_2",
			},
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_phase_3_3",
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_spillway_boss_event_all",
				template_name = "standard_melee",
			},
		},
		spillway_wizard_elite_trickle_1 = {
			{
				"delay",
				duration = 10,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_spillway_boss_event_east",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_west",
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_south",
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 20,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_tier_1",
			},
		},
		spillway_wizard_elite_trickle_2 = {
			{
				"delay",
				duration = 10,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_spillway_boss_event_west",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_east",
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_south",
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 20,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_tier_1",
			},
		},
		spillway_wizard_elite_trickle_3 = {
			{
				"delay",
				duration = 10,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_spillway_boss_event_south",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_east",
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_west",
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 20,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_tier_1",
			},
		},
		spillway_wizard_elite_trickle_phase_2_1 = {
			{
				"delay",
				duration = 8,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 7,
				spawner_group = "spawner_spillway_boss_event_east",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_west",
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_south",
			},
			{
				"continue_when",
				duration = 65,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 15,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_tier_2",
			},
		},
		spillway_wizard_elite_trickle_phase_2_2 = {
			{
				"delay",
				duration = 8,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 7,
				spawner_group = "spawner_spillway_boss_event_west",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_east",
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_south",
			},
			{
				"continue_when",
				duration = 65,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 15,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_tier_2",
			},
		},
		spillway_wizard_elite_trickle_phase_2_3 = {
			{
				"delay",
				duration = 8,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 7,
				spawner_group = "spawner_spillway_boss_event_south",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_east",
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_west",
			},
			{
				"continue_when",
				duration = 65,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 15,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_tier_2",
			},
		},
		spillway_wizard_elite_trickle_phase_2_1_close = {
			{
				"delay",
				duration = 8,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 7,
				spawner_group = "spawner_spillway_boss_event_east",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_west",
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_south",
			},
			{
				"continue_when",
				duration = 65,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 15,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_tier_2",
			},
		},
		spillway_wizard_elite_trickle_phase_2_2_close = {
			{
				"delay",
				duration = 8,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 7,
				spawner_group = "spawner_spillway_boss_event_west",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_east",
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_south",
			},
			{
				"continue_when",
				duration = 65,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 15,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_tier_2",
			},
		},
		spillway_wizard_elite_trickle_phase_2_3_close = {
			{
				"delay",
				duration = 8,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 7,
				spawner_group = "spawner_spillway_boss_event_south",
				breed_tags = {
					{
						"close",
						"elite",
					},
				},
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_east",
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_west",
			},
			{
				"continue_when",
				duration = 65,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 15,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_tier_2",
			},
		},
		spillway_wizard_elite_trickle_phase_3_1 = {
			{
				"delay",
				duration = 6,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 8,
				spawner_group = "spawner_spillway_boss_event_east",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_west",
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_south",
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 15,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_tier_3",
			},
		},
		spillway_wizard_elite_trickle_phase_3_2 = {
			{
				"delay",
				duration = 6,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 8,
				spawner_group = "spawner_spillway_boss_event_west",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_east",
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_south",
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 15,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_tier_3",
			},
		},
		spillway_wizard_elite_trickle_phase_3_3 = {
			{
				"delay",
				duration = 6,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 2,
			},
			{
				"spawn_by_points",
				points = 8,
				spawner_group = "spawner_spillway_boss_event_south",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_east",
			},
			{
				"start_terror_event",
				start_event_name = "spillway_wizard_poxwalker_fillers_west",
			},
			{
				"continue_when",
				duration = 80,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 2
				end,
			},
			{
				"delay",
				duration = 15,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_tier_3",
			},
		},
		spillway_wizard_elite_trickle_final = {
			{
				"delay",
				duration = 10,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_spillway_boss_event_east",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_spillway_boss_event_west",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_spillway_boss_event_south",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
			{
				"delay",
				duration = 5,
			},
			{
				"continue_when",
				duration = 120,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 3
				end,
			},
			{
				"delay",
				duration = 15,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_trickle_final",
			},
		},
		spillway_wizard_retreat_burst_west_elite = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_spillway_boss_event_west",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
		},
		spillway_wizard_retreat_burst_east_elite = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_spillway_boss_event_east",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
		},
		spillway_wizard_retreat_burst_south_elite = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 6,
				spawner_group = "spawner_spillway_boss_event_south",
				breed_tags = {
					{
						"melee",
						"elite",
					},
				},
			},
		},
		spillway_wizard_retreat_burst_west_elite_ogryn_melee_only = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				max_breed_amount = 4,
				points = 15,
				spawner_group = "spawner_spillway_boss_event_west",
				breed_tags = {
					{
						"ogryn",
						"melee",
					},
				},
			},
		},
		spillway_wizard_retreat_burst_east_elite_ogryn_melee_only = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				max_breed_amount = 4,
				points = 15,
				spawner_group = "spawner_spillway_boss_event_east",
				breed_tags = {
					{
						"ogryn",
						"melee",
					},
				},
			},
		},
		spillway_wizard_retreat_burst_south_elite_ogryn_melee_only = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				max_breed_amount = 4,
				points = 15,
				spawner_group = "spawner_spillway_boss_event_south",
				breed_tags = {
					{
						"ogryn",
						"melee",
					},
				},
			},
		},
		spillway_wizard_retreat_burst_west_elite_ogryn_mixed = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 15,
				spawner_group = "spawner_spillway_boss_event_west",
				breed_tags = {
					{
						"ogryn",
						"melee",
					},
				},
			},
		},
		spillway_wizard_retreat_burst_east_elite_ogryn_mixed = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 15,
				spawner_group = "spawner_spillway_boss_event_east",
				breed_tags = {
					{
						"ogryn",
						"melee",
					},
				},
			},
		},
		spillway_wizard_retreat_burst_south_elite_ogryn_mixed = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 15,
				spawner_group = "spawner_spillway_boss_event_south",
				breed_tags = {
					{
						"ogryn",
						"melee",
					},
				},
			},
		},
		spillway_wizard_trickle_west_elite_ogryn_melee_only = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				max_breed_amount = 3,
				points = 15,
				spawner_group = "spawner_spillway_boss_event_west",
				breed_tags = {
					{
						"ogryn",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 90,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_retreat_burst_elite_ogryn_mixed",
			},
		},
		spillway_wizard_trickle_east_elite_ogryn_melee_only = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				max_breed_amount = 3,
				points = 15,
				spawner_group = "spawner_spillway_boss_event_east",
				breed_tags = {
					{
						"ogryn",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 90,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_retreat_burst_elite_ogryn_mixed",
			},
		},
		spillway_wizard_trickle_south_elite_ogryn_melee_only = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				max_breed_amount = 3,
				points = 15,
				spawner_group = "spawner_spillway_boss_event_south",
				breed_tags = {
					{
						"ogryn",
						"melee",
					},
				},
			},
			{
				"continue_when",
				duration = 90,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() < 1
				end,
			},
			{
				"start_random_terror_event",
				start_event_name = "spillway_wizard_retreat_burst_elite_ogryn_mixed",
			},
		},
		spillway_wizard_retreat_burst_west = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 3,
				spawner_group = "spawner_spillway_boss_event_west",
				breed_tags = {
					{
						"poxwalker",
					},
				},
			},
		},
		spillway_wizard_retreat_burst_east = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 3,
				spawner_group = "spawner_spillway_boss_event_east",
				breed_tags = {
					{
						"poxwalker",
					},
				},
			},
		},
		spillway_wizard_retreat_burst_south = {
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"delay",
				duration = 3,
			},
			{
				"spawn_by_points",
				points = 3,
				spawner_group = "spawner_spillway_boss_event_south",
				breed_tags = {
					{
						"poxwalker",
					},
				},
			},
		},
		spillway_wizard_finite_tracked_wave = {
			{
				"delay",
				duration = 5,
			},
			{
				"play_2d_sound",
				sound_event_name = "wwise/events/minions/play_mid_event_horde_signal",
			},
			{
				"spawn_by_points",
				points = 8,
				spawner_group = "spawner_spillway_boss_event_east",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"spawn_by_points",
				points = 8,
				spawner_group = "spawner_spillway_boss_event_west",
				breed_tags = {
					{
						"elite",
					},
				},
			},
			{
				"continue_when",
				duration = 60,
				condition = function ()
					return TerrorEventQueries.num_alive_minions() == 0
				end,
			},
			{
				"lua_event",
				target_event = "catch_terror_event_done",
			},
		},
		spillway_wizard_poxwalker_fillers_west = {
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				limit_spawners = 5,
				points = 3,
				spawner_group = "spawner_spillway_boss_event_west",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
			},
		},
		spillway_wizard_poxwalker_fillers_east = {
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				limit_spawners = 5,
				points = 3,
				spawner_group = "spawner_spillway_boss_event_east",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
			},
		},
		spillway_wizard_poxwalker_fillers_south = {
			{
				"delay",
				duration = 4,
			},
			{
				"spawn_by_points",
				limit_spawners = 5,
				points = 3,
				spawner_group = "spawner_spillway_boss_event_south",
				breed_tags = {
					{
						"roamer",
						"melee",
					},
				},
			},
		},
		spillway_wizard_stop_trickle_final = {
			{
				"stop_terror_event",
				stop_event_name = "spillway_wizard_elite_trickle_final",
			},
			{
				"start_terror_trickle",
				delay = 5,
				spawner_group = "spawner_spillway_boss_event_all",
				template_name = "flood_melee",
			},
		},
	},
}

return template
