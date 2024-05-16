-- chunkname: @dialogues/generated/mission_vo_prologue.lua

return function ()
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_prologue",
		name = "melee_gameplay_01",
		post_wwise_event = "play_radio_static_end",
		response = "melee_gameplay_01",
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
				"melee_gameplay_01",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"melee_gameplay_01",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"melee_gameplay_01",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_prologue",
		name = "melee_gameplay_02",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "melee_gameplay_02",
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
					"prologue_monologue_05",
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
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_prologue",
		name = "melee_gameplay_03",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "melee_gameplay_03",
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
					"prologue_combat_04",
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
			target = "players",
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
		database = "mission_vo_prologue",
		name = "melee_gameplay_04",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "melee_gameplay_04",
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
				"melee_gameplay_04",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"melee_gameplay_04",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"melee_gameplay_04",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_combat_01",
		response = "prologue_combat_01",
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
				"prologue_combat_01",
			},
			{
				"faction_memory",
				"prologue_combat_01",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_combat_01",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_combat_02",
		response = "prologue_combat_02",
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
				"prologue_combat_02",
			},
			{
				"faction_memory",
				"prologue_combat_02",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_combat_02",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_combat_03",
		response = "prologue_combat_03",
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
				"prologue_combat_03",
			},
			{
				"faction_memory",
				"prologue_combat_03",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_combat_03",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_combat_04",
		response = "prologue_combat_04",
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
				"prologue_combat_04",
			},
			{
				"faction_memory",
				"prologue_combat_04",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_combat_04",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_combat_05",
		response = "prologue_combat_05",
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
				"prologue_combat_05",
			},
			{
				"user_context",
				"enemies_close",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"prologue_combat_05",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_combat_05",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_end_event_01",
		response = "prologue_end_event_01",
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
				"prologue_end_event_01",
			},
			{
				"faction_memory",
				"prologue_end_event_01",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_end_event_01",
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
		database = "mission_vo_prologue",
		name = "prologue_end_event_02",
		response = "prologue_end_event_02",
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
				"prologue_end_event_02",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"prologue_end_event_02",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_end_event_02",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_end_event_03",
		response = "prologue_end_event_03",
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
				"prologue_end_event_03",
			},
			{
				"faction_memory",
				"prologue_end_event_03",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_end_event_03",
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
		database = "mission_vo_prologue",
		name = "prologue_end_event_04",
		response = "prologue_end_event_04",
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
				"prologue_end_event_04",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"prologue_end_event_04",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_end_event_04",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_end_event_conversation_a",
		response = "prologue_end_event_conversation_a",
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
				"prologue_end_event_conversation_a",
			},
			{
				"faction_memory",
				"prologue_end_event_conversation_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_end_event_conversation_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_end_event_conversation_b",
		response = "prologue_end_event_conversation_b",
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
				"prologue_end_event_conversation_b",
			},
			{
				"faction_memory",
				"prologue_end_event_conversation_b",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_end_event_conversation_b",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_firefight_conversation_a",
		response = "prologue_firefight_conversation_a",
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
				"prologue_firefight_conversation_a",
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"prologue",
			},
			{
				"faction_memory",
				"prologue_firefight_conversation_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_firefight_conversation_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_firefight_conversation_b",
		response = "prologue_firefight_conversation_b",
		wwise_route = 0,
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
					"prologue_firefight_conversation_a",
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
		category = "conversations_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_monologue_01",
		response = "prologue_monologue_01",
		wwise_route = 0,
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
					"melee_gameplay_01",
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
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_monologue_02",
		response = "prologue_monologue_02",
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
				"prologue_monologue_02",
			},
			{
				"faction_memory",
				"prologue_monologue_02",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_02",
				OP.ADD,
				1,
			},
		},
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
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_monologue_03",
		response = "prologue_monologue_03",
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
				"prologue_monologue_03",
			},
			{
				"faction_memory",
				"prologue_monologue_03",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_03",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_monologue_04",
		response = "prologue_monologue_04",
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
				"prologue_monologue_04",
			},
			{
				"faction_memory",
				"prologue_monologue_04",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_04",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_monologue_05",
		response = "prologue_monologue_05",
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
				"prologue_monologue_05",
			},
			{
				"faction_memory",
				"prologue_monologue_05",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_05",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_monologue_06",
		response = "prologue_monologue_06",
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
				"prologue_monologue_06",
			},
			{
				"faction_memory",
				"prologue_monologue_06",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_06",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_monologue_07",
		response = "prologue_monologue_07",
		wwise_route = 0,
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
					"",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3,
			},
		},
	})
	define_rule({
		category = "enemy_alerts_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_monologue_08",
		response = "prologue_monologue_08",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_executor",
			},
			{
				"faction_memory",
				"renegade_executor",
				OP.EQ,
				OP.GT,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"renegade_executor",
				OP.ADD,
				"1",
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5,
			},
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_monologue_09",
		response = "prologue_monologue_09",
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
				"prologue_monologue_09",
			},
			{
				"faction_memory",
				"prologue_monologue_09",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_09",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "prologue_monologue_10",
		response = "prologue_monologue_10",
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
				"prologue_monologue_10",
			},
			{
				"faction_memory",
				"prologue_monologue_10",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_monologue_10",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "ranged_gameplay_01",
		response = "ranged_gameplay_01",
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
				"ranged_gameplay_01",
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"prologue",
			},
			{
				"faction_memory",
				"ranged_gameplay_01",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"ranged_gameplay_01",
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
		database = "mission_vo_prologue",
		name = "ranged_gameplay_02",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "ranged_gameplay_02",
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
					"ranged_gameplay_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "mission_vo_prologue",
		name = "ranged_gameplay_03",
		response = "ranged_gameplay_03",
		wwise_route = 0,
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
					"ranged_gameplay_02",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"explicator_a",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "mission_vo_prologue",
		name = "ranged_gameplay_04",
		response = "ranged_gameplay_04",
		wwise_route = 0,
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
					"ranged_gameplay_03",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_prologue",
		name = "ranged_gameplay_05",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "ranged_gameplay_05",
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
				"ranged_gameplay_05",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "mission_vo_prologue",
		name = "ranged_gameplay_06",
		response = "ranged_gameplay_06",
		wwise_route = 0,
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
					"ranged_gameplay_05",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"explicator_a",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "mission_vo_prologue",
		name = "ranged_gameplay_07",
		response = "ranged_gameplay_07",
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
				"ranged_gameplay_07",
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"prologue",
			},
			{
				"faction_memory",
				"ranged_gameplay_07",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"ranged_gameplay_07",
				OP.ADD,
				1,
			},
		},
	})
end
