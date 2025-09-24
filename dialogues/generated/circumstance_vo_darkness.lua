-- chunkname: @dialogues/generated/circumstance_vo_darkness.lua

return function ()
	define_rule({
		category = "conversations_prio_1",
		database = "circumstance_vo_darkness",
		name = "combat_pause_circumstance_unnatural_dark_lights_a",
		response = "combat_pause_circumstance_unnatural_dark_lights_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"psyker_female_b",
					"psyker_male_b",
					"veteran_female_a",
					"veteran_male_a",
					"zealot_female_a",
					"zealot_male_a",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_male_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_unnatural_dark_lights_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_unnatural_dark_lights_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "circumstance_vo_darkness",
		name = "combat_pause_circumstance_unnatural_dark_lights_b",
		response = "combat_pause_circumstance_unnatural_dark_lights_b",
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
					"combat_pause_circumstance_unnatural_dark_lights_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_male_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"combat_pause_circumstance_unnatural_dark",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"combat_pause_circumstance_unnatural_dark",
				OP.ADD,
				1,
			},
		},
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
		category = "conversations_prio_1",
		database = "circumstance_vo_darkness",
		name = "combat_pause_circumstance_unnatural_dark_lurks_a",
		response = "combat_pause_circumstance_unnatural_dark_lurks_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_darkness",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90,
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_male_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"faction_memory",
				"combat_pause_circumstance_unnatural_dark_lurks_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				100,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"combat_pause_circumstance_unnatural_dark_lurks_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0",
			},
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "circumstance_vo_darkness",
		name = "combat_pause_circumstance_unnatural_dark_lurks_b",
		response = "combat_pause_circumstance_unnatural_dark_lurks_b",
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
					"combat_pause_circumstance_unnatural_dark_lurks_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_male_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"combat_pause_circumstance_unnatural_dark",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"combat_pause_circumstance_unnatural_dark",
				OP.ADD,
				1,
			},
		},
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
		category = "enemy_story_vo",
		database = "circumstance_vo_darkness",
		name = "cult_downed_player_a",
		response = "cult_downed_player_a",
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
				"killed_player",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain_two",
				},
			},
			{
				"global_context",
				"current_mission",
				OP.NEQ,
				"km_enforcer_twins",
			},
			{
				"user_memory",
				"cult_downed_player_a",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"cult_downed_player_a",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "circumstance_vo_darkness",
		name = "cult_gas_cloud_a",
		response = "cult_gas_cloud_a",
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
				"cult_gas_cloud_a",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain_two",
				},
			},
			{
				"global_context",
				"current_mission",
				OP.NEQ,
				"km_enforcer_twins",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "circumstance_vo_darkness",
		name = "cult_horde_announcement_a",
		response = "cult_horde_announcement_a",
		wwise_route = 1,
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
				"cult_horde_announcement_a",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain_two",
				},
			},
			{
				"global_context",
				"current_mission",
				OP.NEQ,
				"km_enforcer_twins",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "circumstance_vo_darkness",
		name = "cult_hurt_player_a",
		response = "cult_hurt_player_a",
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
				"downed_player",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain_two",
				},
			},
			{
				"global_context",
				"current_mission",
				OP.NEQ,
				"km_enforcer_twins",
			},
			{
				"user_memory",
				"cult_hurt_player_a",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"cult_hurt_player_a",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "circumstance_vo_darkness",
		name = "cult_monster_announcement_a",
		response = "cult_monster_announcement_a",
		wwise_route = 1,
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
				"cult_monster_announcement_a",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain_two",
				},
			},
			{
				"global_context",
				"current_mission",
				OP.NEQ,
				"km_enforcer_twins",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "circumstance_vo_darkness",
		name = "cult_pre_ambush_a",
		response = "cult_pre_ambush_a",
		wwise_route = 1,
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
				"cult_pre_ambush_a",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain_two",
				},
			},
			{
				"global_context",
				"current_mission",
				OP.NEQ,
				"km_enforcer_twins",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "circumstance_vo_darkness",
		name = "cult_retreat_a",
		response = "cult_retreat_a",
		wwise_route = 1,
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
				"cult_retreat_a",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain_two",
				},
			},
			{
				"global_context",
				"current_mission",
				OP.NEQ,
				"km_enforcer_twins",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 5,
			},
		},
	})
	define_rule({
		category = "enemy_story_vo",
		database = "circumstance_vo_darkness",
		name = "cult_switch_focus_a",
		response = "cult_switch_focus_a",
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
				"cult_switch_focus_a",
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain_two",
				},
			},
			{
				"global_context",
				"current_mission",
				OP.NEQ,
				"km_enforcer_twins",
			},
			{
				"user_memory",
				"cult_switch_focus_a",
				OP.TIMEDIFF,
				OP.GT,
				7,
			},
		},
		on_done = {
			{
				"user_memory",
				"cult_switch_focus_a",
				OP.TIMESET,
			},
		},
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
		category = "enemy_story_vo",
		database = "circumstance_vo_darkness",
		name = "cult_taunt_twin_a",
		response = "cult_taunt_twin_a",
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
					"renegade_twin_captain_two",
				},
			},
			{
				"global_context",
				"current_mission",
				OP.NEQ,
				"km_enforcer_twins",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.7,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "circumstance_vo_darkness",
		name = "kalyx_darkness_circumstance_invader_defeated_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "kalyx_darkness_circumstance_invader_defeated_a",
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
					"cult_retreat_a",
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
			{
				"faction_memory",
				"kalyx_darkness_circumstance_invader_defeated_a",
				OP.EQ,
				"0",
			},
		},
		on_done = {
			{
				"faction_memory",
				"kalyx_darkness_circumstance_invader_defeated_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5,
			},
			random_ignore_vo = {
				chance = 0.4,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "circumstance_vo_darkness",
		name = "kalyx_darkness_circumstance_invader_sighted_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "kalyx_darkness_circumstance_invader_sighted_a",
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
					"cult_taunt_twin_a",
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
			{
				"faction_memory",
				"kalyx_darkness_circumstance_invader_sighted_a",
				OP.EQ,
				"0",
			},
		},
		on_done = {
			{
				"faction_memory",
				"kalyx_darkness_circumstance_invader_sighted_a",
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
			random_ignore_vo = {
				chance = 0.4,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "circumstance_vo_darkness",
		name = "kalyx_darkness_circumstance_start_a",
		pre_wwise_event = "play_radio_static_start",
		response = "kalyx_darkness_circumstance_start_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.EQ,
				"circumstance_vo_darkness_twin",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"power_circumstance_start_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector",
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
		database = "circumstance_vo_darkness",
		name = "kalyx_darkness_circumstance_start_b",
		post_wwise_event = "play_radio_static_end",
		response = "kalyx_darkness_circumstance_start_b",
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
					"kalyx_darkness_circumstance_start_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"dreg_lector",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "circumstance_vo_darkness",
		name = "pimlico_bonding_conversation_burn_a",
		response = "pimlico_bonding_conversation_burn_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1,
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0,
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_female_b",
				},
			},
			{
				"faction_memory",
				"pimlico_bonding_conversation_burn_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220,
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"pimlico_bonding_conversation_burn_a_user",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"pimlico_bonding_conversation_burn_a",
				OP.ADD,
				1,
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "circumstance_vo_darkness",
		name = "pimlico_bonding_conversation_burn_b",
		response = "pimlico_bonding_conversation_burn_b",
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
					"pimlico_bonding_conversation_burn_a",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"pimlico_bonding_conversation_burn_b_user",
				OP.ADD,
				1,
			},
		},
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
		category = "conversations_prio_1",
		database = "circumstance_vo_darkness",
		name = "pimlico_bonding_conversation_burn_c",
		response = "pimlico_bonding_conversation_burn_c",
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
					"pimlico_bonding_conversation_burn_b",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"pimlico_bonding_conversation_burn_a_user",
				OP.EQ,
				1,
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
		category = "conversations_prio_1",
		database = "circumstance_vo_darkness",
		name = "pimlico_bonding_conversation_burn_d",
		response = "pimlico_bonding_conversation_burn_d",
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
					"pimlico_bonding_conversation_burn_c",
				},
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b",
				},
			},
			{
				"user_memory",
				"pimlico_bonding_conversation_burn_b_user",
				OP.EQ,
				1,
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
		database = "circumstance_vo_darkness",
		name = "power_circumstance_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "power_circumstance_start_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"global_context",
				"circumstance_vo_id",
				OP.SET_INCLUDES,
				args = {
					"circumstance_vo_darkness",
					"circumstance_vo_darkness_twin",
				},
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"mission_cooling_heat_response_two",
					"mission_cartel_mudlark",
					"mission_scavenge_daylight_response_b",
					"mission_station_tanks",
					"mission_cargo_start_banter_d",
					"mission_forge_strategic_asset",
					"mission_propaganda_short_elevator_conversation_one_b",
					"mission_propaganda_short_elevator_conversation_two_b",
					"mission_propaganda_short_elevator_conversation_three_b",
					"mission_habs_redux_start_zone_response",
					"mission_archives_start_banter_c",
					"mission_complex_start_banter_c",
					"mission_enforcer_start_banter_c",
					"mission_rails_start_banter_c",
					"mission_resurgence_start_banter_c",
					"mission_stockpile_start_banter_c",
					"mission_strain_start_banter_c",
					"mission_armoury_rooftops_c",
					"mission_raid_safe_zone_e",
					"mission_rise_first_objective_response",
					"mission_core_safe_zone_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot",
					"sergeant",
					"tech_priest",
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
		database = "circumstance_vo_darkness",
		name = "power_circumstance_start_b",
		response = "power_circumstance_start_b",
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
					"power_circumstance_start_a",
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
end
