-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins.lua

return function ()
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_km_enforcer_twins",
		name = "enemy_kill_monster_twins",
		response = "enemy_kill_monster_twins",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"last_twin_killed",
			},
			{
				"faction_memory",
				"enemy_kill_monster_twins",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"enemy_kill_monster_twins",
				OP.ADD,
				1,
			},
			{
				"user_memory",
				"enemy_kill_monster_twins_user",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "level_event",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2.5,
			},
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "gas_cloud_a",
		response = "gas_cloud_a",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"gas_cloud",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain",
					"renegade_twin_captain_two",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "long_death_twin",
		response = "long_death_twin",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"long_death_disabled",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain",
					"renegade_twin_captain_two",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twin_elevator_a",
		response = "mission_twin_elevator_a",
		wwise_route = 39,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_twin_elevator_a",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_twin_captain_two",
			},
			{
				"faction_memory",
				"mission_twin_elevator_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twin_elevator_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_01_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_twins_aftermath_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_mission_half_health_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 4,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_01_b",
		response = "mission_twins_aftermath_01_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_aftermath_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_01_c",
		response = "mission_twins_aftermath_01_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_aftermath_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_01_d",
		post_wwise_event = "play_radio_static_end",
		response = "mission_twins_aftermath_01_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_aftermath_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_02_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_twins_aftermath_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_mission_half_health_02_a_disabled",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 4,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_02_b",
		response = "mission_twins_aftermath_02_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_aftermath_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_02_c",
		post_wwise_event = "play_radio_static_end",
		response = "mission_twins_aftermath_02_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_aftermath_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_03_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_twins_aftermath_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_mission_half_health_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 12,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_03_b",
		response = "mission_twins_aftermath_03_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_aftermath_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_03_c",
		response = "mission_twins_aftermath_03_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_aftermath_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_03_d",
		response = "mission_twins_aftermath_03_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_aftermath_03_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_03_e",
		response = "mission_twins_aftermath_03_e",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_aftermath_03_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_03_f",
		response = "mission_twins_aftermath_03_f",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_aftermath_03_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_aftermath_03_g",
		post_wwise_event = "play_radio_static_end",
		response = "mission_twins_aftermath_03_g",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_aftermath_03_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_arrival_01_a",
		response = "mission_twins_arrival_01_a",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"taunt",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_twin_captain_two",
			},
			{
				"faction_memory",
				"mission_twins_arrival_stage",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_arrival_stage",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.8,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_arrival_01_b",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_twins_arrival_01_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_arrival_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_giver_default",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_arrival_01_c",
		post_wwise_event = "play_radio_static_end",
		response = "mission_twins_arrival_01_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_arrival_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_arrival_02_a",
		response = "mission_twins_arrival_02_a",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"taunt",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_twin_captain",
			},
			{
				"faction_memory",
				"mission_twins_arrival_stage",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_arrival_stage",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.8,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_arrival_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_twins_arrival_02_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_arrival_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_arrival_03_a",
		response = "mission_twins_arrival_03_a",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"taunt",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_twin_captain_two",
			},
			{
				"faction_memory",
				"mission_twins_arrival_stage",
				OP.EQ,
				2,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_arrival_stage",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.8,
			},
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_arrival_05_a",
		response = "mission_twins_arrival_05_a",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"taunt",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_twin_captain",
			},
			{
				"faction_memory",
				"mission_twins_arrival_stage",
				OP.EQ,
				3,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_arrival_stage",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "all",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.8,
			},
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_arrival_05_b",
		response = "mission_twins_arrival_05_b",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"captain_twin_female",
				},
			},
			{
				"query_context",
				"dialogue_name",
				OP.EQ,
				"mission_twins_arrival_05_a",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "all",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_arrival_05_c",
		response = "mission_twins_arrival_05_c",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"captain_twin_male",
				},
			},
			{
				"query_context",
				"dialogue_name",
				OP.EQ,
				"mission_twins_arrival_05_b",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "cutscene",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_cutscene_a",
		response = "mission_twins_cutscene_a",
		wwise_route = 5,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"cutscene_vo_line",
			},
			{
				"query_context",
				"vo_line_id",
				OP.EQ,
				"mission_twins_cutscene_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"captain_twin_female",
				},
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_arrival_stage",
				OP.ADD,
				6,
			},
		},
	})
	define_rule({
		category = "cutscene",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_cutscene_b",
		response = "mission_twins_cutscene_b",
		wwise_route = 5,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"cutscene_vo_line",
			},
			{
				"query_context",
				"vo_line_id",
				OP.EQ,
				"mission_twins_cutscene_b",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"captain_twin_male",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "cutscene",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_cutscene_c",
		response = "mission_twins_cutscene_c",
		wwise_route = 5,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"cutscene_vo_line",
			},
			{
				"query_context",
				"vo_line_id",
				OP.EQ,
				"mission_twins_cutscene_c",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"captain_twin_female",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_death_twin_female_a",
		response = "mission_twins_death_twin_female_a",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"twin_dead",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_twin_captain",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.5,
			},
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_death_twin_male_a",
		response = "mission_twins_death_twin_male_a",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"twin_dead",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_twin_captain_two",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.5,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_end_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_twins_end_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_twins_end_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_twins_end_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_end_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_end_b",
		post_wwise_event = "play_radio_static_end",
		response = "mission_twins_end_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_end_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_01_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_twins_exchange_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_twins_exchange_01_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_twins_exchange_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_exchange_01_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_01_b",
		response = "mission_twins_exchange_01_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_01_c",
		response = "mission_twins_exchange_01_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_01_d",
		response = "mission_twins_exchange_01_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_01_e",
		response = "mission_twins_exchange_01_e",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_01_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_01_f",
		post_wwise_event = "play_radio_static_end",
		response = "mission_twins_exchange_01_f",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_01_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_02_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_twins_exchange_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_mission_half_health_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 8,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_02_b",
		response = "mission_twins_exchange_02_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_02_a_",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_02_c",
		response = "mission_twins_exchange_02_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_02_b_",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_02_d",
		response = "mission_twins_exchange_02_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_02_e",
		response = "mission_twins_exchange_02_e",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_02_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_02_f",
		response = "mission_twins_exchange_02_f",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_02_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_02_g",
		response = "mission_twins_exchange_02_g",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_02_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_02_h",
		response = "mission_twins_exchange_02_h",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_02_g",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_02_i",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_end",
		response = "mission_twins_exchange_02_i",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_02_h",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_03_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_twins_exchange_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_twins_exchange_03_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_twins_exchange_03_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_exchange_03_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 10,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_03_b",
		response = "mission_twins_exchange_03_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_exchange_03_c",
		post_wwise_event = "play_radio_static_end",
		response = "mission_twins_exchange_03_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_exchange_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_go_around",
		response = "mission_twins_go_around",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at",
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"mission_twins_go_around",
			},
			{
				"query_context",
				"distance",
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"distance",
				OP.LTEQ,
				30,
			},
			{
				"faction_memory",
				"mission_twins_go_around",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_go_around",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_mission_half_health_01_a",
		response = "mission_twins_mission_half_health_01_a",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"escape",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_twin_captain_two",
			},
			{
				"faction_memory",
				"mission_twins_escape_stage",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_escape_stage",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_mission_half_health_02_a",
		response = "mission_twins_mission_half_health_02_a",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"escape",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_twin_captain",
			},
			{
				"faction_memory",
				"mission_twins_escape_stage",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_escape_stage",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_mission_half_health_03_a",
		response = "mission_twins_mission_half_health_03_a",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"escape",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_twin_captain_two",
			},
			{
				"faction_memory",
				"mission_twins_escape_stage",
				OP.EQ,
				2,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_escape_stage",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_mission_half_health_04_a",
		response = "mission_twins_mission_half_health_04_a",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"escape",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_twin_captain",
			},
			{
				"faction_memory",
				"mission_twins_escape_stage",
				OP.EQ,
				3,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_escape_stage",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_mission_start_a",
		pre_wwise_event = "play_radio_static_start",
		response = "mission_twins_mission_start_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_twins_mission_start_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"mission_twins_mission_start_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"mission_twins_mission_start_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_mission_start_b",
		response = "mission_twins_mission_start_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_mission_start_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_mission_start_c",
		response = "mission_twins_mission_start_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_mission_start_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_mission_start_d",
		response = "mission_twins_mission_start_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_mission_start_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_km_enforcer_twins",
		name = "mission_twins_mission_start_e",
		post_wwise_event = "play_radio_static_end",
		response = "mission_twins_mission_start_e",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_twins_mission_start_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.7,
			},
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "reinforcements_poxwalkers_a",
		response = "reinforcements_poxwalkers_a",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"reinforcements_poxwalkers",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain",
					"renegade_twin_captain_two",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_km_enforcer_twins",
		name = "response_for_enemy_kill_monster_twins",
		response = "response_for_enemy_kill_monster_twins",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"response_for_enemy_kill_monster_twins",
			},
			{
				"faction_memory",
				"response_for_enemy_kill_monster_twins",
				OP.EQ,
				0,
			},
			{
				"user_memory",
				"enemy_kill_monster_twins_user",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_enemy_kill_monster_twins",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "level_event",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "taunt_combat_twin",
		response = "taunt_combat_twin",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"taunt_shield",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain",
					"renegade_twin_captain_two",
				},
			},
			{
				"faction_memory",
				"taunt_combat_twin",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
		},
		on_done = {
			{
				"faction_memory",
				"taunt_combat_twin",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "mission_vo_km_enforcer_twins",
		name = "taunt_twin",
		response = "taunt_twin",
		wwise_route = 51,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"taunt",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain",
					"renegade_twin_captain_two",
				},
			},
			{
				"faction_memory",
				"mission_twins_arrival_stage",
				OP.GTEQ,
				6,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
end
