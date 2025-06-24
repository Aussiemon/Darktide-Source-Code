﻿-- chunkname: @dialogues/generated/mission_vo_om_hub_01.lua

return function ()
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_om_hub_01",
		name = "hub_onboarding_02_a",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_onboarding_02_a",
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
				"hub_onboarding_02_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_officer",
				},
			},
			{
				"faction_memory",
				"prologue_hub_mourningstar_intro",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_hub_mourningstar_intro",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_om_hub_01",
		name = "hub_onboarding_02_b",
		response = "hub_onboarding_02_b",
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
					"hub_onboarding_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_officer",
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
		database = "mission_vo_om_hub_01",
		name = "hub_onboarding_02_c",
		response = "hub_onboarding_02_c",
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
					"hub_onboarding_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_officer",
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
		database = "mission_vo_om_hub_01",
		name = "hub_onboarding_02_d",
		response = "hub_onboarding_02_d",
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
					"hub_onboarding_02_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_officer",
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
		database = "mission_vo_om_hub_01",
		name = "hub_onboarding_02_e",
		response = "hub_onboarding_02_e",
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
					"hub_onboarding_02_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_officer",
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
		database = "mission_vo_om_hub_01",
		name = "hub_onboarding_02_f",
		response = "hub_onboarding_02_f",
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
					"hub_onboarding_02_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_officer",
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
		database = "mission_vo_om_hub_01",
		name = "hub_onboarding_02_g",
		post_wwise_event = "play_radio_static_end",
		response = "hub_onboarding_02_g",
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
					"hub_onboarding_02_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_officer",
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
		database = "mission_vo_om_hub_01",
		name = "npc_first_interaction_training_ground_psyker_a",
		response = "npc_first_interaction_training_ground_psyker_a",
		wwise_route = 42,
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
					"prologue_hub_go_training_grounds_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2.5,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_om_hub_01",
		name = "npc_first_interaction_training_ground_psyker_b",
		response = "npc_first_interaction_training_ground_psyker_b",
		wwise_route = 42,
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
					"npc_first_interaction_training_ground_psyker_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
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
		database = "mission_vo_om_hub_01",
		name = "npc_first_interaction_training_ground_psyker_c",
		response = "npc_first_interaction_training_ground_psyker_c",
		wwise_route = 42,
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
					"npc_first_interaction_training_ground_psyker_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
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
		database = "mission_vo_om_hub_01",
		name = "npc_first_interaction_training_ground_psyker_d",
		response = "npc_first_interaction_training_ground_psyker_d",
		wwise_route = 42,
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
					"npc_first_interaction_training_ground_psyker_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
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
		database = "mission_vo_om_hub_01",
		name = "npc_first_interaction_training_ground_psyker_e",
		response = "npc_first_interaction_training_ground_psyker_e",
		wwise_route = 42,
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
					"npc_first_interaction_training_ground_psyker_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
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
		database = "mission_vo_om_hub_01",
		name = "prologue_hub_go_training_grounds_a",
		pre_wwise_event = "play_radio_static_start",
		response = "prologue_hub_go_training_grounds_a",
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
				"prologue_hub_go_training_grounds",
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
				"prologue_hub_go_training_grounds",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_hub_go_training_grounds",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_om_hub_01",
		name = "prologue_hub_go_training_grounds_b",
		post_wwise_event = "play_radio_static_end",
		response = "prologue_hub_go_training_grounds_b",
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
					"prologue_hub_go_training_grounds_a",
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
		database = "mission_vo_om_hub_01",
		name = "prologue_hub_mourningstar_intro_a",
		pre_wwise_event = "play_radio_static_start",
		response = "prologue_hub_mourningstar_intro_a",
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
				"prologue_hub_mourningstar_intro",
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
				"prologue_hub_mourningstar_intro",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_hub_mourningstar_intro",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_om_hub_01",
		name = "prologue_hub_mourningstar_intro_b",
		response = "prologue_hub_mourningstar_intro_b",
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
					"prologue_hub_mourningstar_intro_a",
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
		database = "mission_vo_om_hub_01",
		name = "prologue_hub_mourningstar_intro_c",
		post_wwise_event = "play_radio_static_end",
		response = "prologue_hub_mourningstar_intro_c",
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
					"prologue_hub_mourningstar_intro_b",
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
end
