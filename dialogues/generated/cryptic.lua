-- chunkname: @dialogues/generated/cryptic.lua

return function ()
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "adamant_seen_killstreak_cryptic",
		response = "adamant_seen_killstreak_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15,
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"adamant",
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 2,
				max_failed_tries = 4,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "adamant_start_revive_cryptic",
		response = "adamant_start_revive_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo",
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
				},
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive",
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "cryptic",
		name = "binharic_long_aggressive",
		response = "binharic_long_aggressive",
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
				"binharic_long_aggressive",
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_binharic",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "cryptic",
		name = "binharic_long_hurt",
		response = "binharic_long_hurt",
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
				"binharic_long_hurt",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "cryptic",
		name = "binharic_medium_aggressive",
		response = "binharic_medium_aggressive",
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
				"binharic_medium_aggressive",
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_binharic",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "cryptic",
		name = "binharic_medium_hurt",
		response = "binharic_medium_hurt",
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
				"binharic_medium_hurt",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "cryptic",
		name = "binharic_short_aggressive",
		response = "binharic_short_aggressive",
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
				"binharic_short_aggressive",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "cryptic",
		name = "binharic_short_hurt",
		response = "binharic_short_hurt",
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
				"binharic_short_hurt",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "broker_seen_killstreak_cryptic",
		response = "broker_seen_killstreak_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15,
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"broker",
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"broker_seen_killstreak_cryptic",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 2,
				max_failed_tries = 4,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "broker_start_revive_cryptic",
		response = "broker_start_revive_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo",
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"broker",
				},
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive",
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "cryptic_ability_01_a",
		response = "cryptic_ability_01_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"combat_ability",
			},
			{
				"query_context",
				"ability_name",
				OP.EQ,
				"cryptic_ability_01_a",
			},
			{
				"user_context",
				"enemies_distant",
				OP.GT,
				0,
			},
		},
		on_done = {},
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
		category = "player_prio_1",
		database = "cryptic",
		name = "cryptic_ability_02_a",
		response = "cryptic_ability_02_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"combat_ability",
			},
			{
				"query_context",
				"ability_name",
				OP.EQ,
				"cryptic_ability_02_a",
			},
			{
				"user_context",
				"enemies_distant",
				OP.GT,
				0,
			},
			{
				"user_memory",
				"cryptic_ability_02_a",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_ability_02_a",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "cryptic_ability_03_a",
		response = "cryptic_ability_03_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"combat_ability",
			},
			{
				"query_context",
				"ability_name",
				OP.EQ,
				"cryptic_ability_03_a",
			},
			{
				"user_context",
				"enemies_distant",
				OP.GT,
				0,
			},
			{
				"user_memory",
				"cryptic_ability_03_a",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_ability_03_a",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_post_rule_execution = {
			reject_events = {
				duration = 0.1,
			},
		},
	})
	define_rule({
		category = "player_ability_vo",
		database = "cryptic",
		name = "cryptic_blitz_01_a",
		response = "cryptic_blitz_01_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"combat_ability",
			},
			{
				"query_context",
				"ability_name",
				OP.EQ,
				"cryptic_blitz_01_a",
			},
			{
				"user_memory",
				"cryptic_blitz_01_a",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_blitz_01_a",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "cryptic_blitz_02_a",
		response = "cryptic_blitz_02_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"throwing_item",
			},
			{
				"query_context",
				"item",
				OP.SET_INCLUDES,
				args = {
					"arc_grenade",
				},
			},
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_ability_vo",
		database = "cryptic",
		name = "cryptic_blitz_03_a",
		response = "cryptic_blitz_03_a",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"combat_ability",
			},
			{
				"query_context",
				"ability_name",
				OP.EQ,
				"cryptic_blitz_03_a",
			},
			{
				"user_memory",
				"cryptic_blitz_03_a",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"cryptic_blitz_03_a",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "cryptic_seen_killstreak_acryptic",
		response = "cryptic_seen_killstreak_acryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak",
			},
			{
				"query_context",
				"killer_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15,
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"cryptic",
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 2,
				max_failed_tries = 4,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "cryptic_seen_killstreak_cryptic",
		response = "cryptic_seen_killstreak_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15,
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"cryptic",
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 2,
				max_failed_tries = 4,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "cryptic_start_revive_acryptic",
		response = "cryptic_start_revive_acryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo",
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_NOT_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive",
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "cryptic_start_revive_cryptic",
		response = "cryptic_start_revive_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo",
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive",
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "deployed_ammo_crate_acryptic_low_on_ammo",
		response = "deployed_ammo_crate_acryptic_low_on_ammo",
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
				"deployed_ammo_crate",
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.LT,
				0.5,
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
					"adamant",
					"broker",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "deployed_ammo_crate_cryptic_low_on_ammo",
		response = "deployed_ammo_crate_cryptic_low_on_ammo",
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
				"deployed_ammo_crate",
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.LT,
				0.5,
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "found_ammo_acryptic_low_on_ammo",
		response = "found_ammo_acryptic_low_on_ammo",
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
				"ammo",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				6,
			},
			{
				"query_context",
				"distance",
				OP.LT,
				20,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30,
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.LT,
				0.5,
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
				},
			},
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMESET,
			},
			{
				"user_memory",
				"found_ammo_acryptic_low_on_ammo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "found_ammo_cryptic_low_on_ammo",
		response = "found_ammo_cryptic_low_on_ammo",
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
				"ammo",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				6,
			},
			{
				"query_context",
				"distance",
				OP.LT,
				20,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30,
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.LT,
				0.5,
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_NOT_INCLUDES,
				args = {
					"temp",
				},
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
				},
			},
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "cryptic",
		name = "found_health_booster_acryptic_low_on_health",
		response = "found_health_booster_acryptic_low_on_health",
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
				"found_health_booster_low_on_health",
			},
			{
				"faction_context",
				"health",
				OP.LT,
				0.3,
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMESET,
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
		database = "cryptic",
		name = "found_health_booster_cryptic_low_on_health",
		response = "found_health_booster_cryptic_low_on_health",
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
				"found_health_booster_low_on_health",
			},
			{
				"faction_context",
				"health",
				OP.LT,
				0.3,
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_NOT_INCLUDES,
				args = {
					"temp",
				},
			},
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "found_health_station_acryptic_low_on_health",
		response = "found_health_station_acryptic_low_on_health",
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
				"charged_health_station",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1,
			},
			{
				"query_context",
				"distance",
				OP.LT,
				25,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5,
			},
			{
				"faction_context",
				"health",
				OP.LT,
				0.5,
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "found_health_station_cryptic_low_on_health",
		response = "found_health_station_cryptic_low_on_health",
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
				"charged_health_station",
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1,
			},
			{
				"query_context",
				"distance",
				OP.LT,
				25,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5,
			},
			{
				"faction_context",
				"health",
				OP.LT,
				0.5,
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_NOT_INCLUDES,
				args = {
					"temp",
				},
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "friendly_fire_from_acryptic_to_cryptic",
		response = "friendly_fire_from_acryptic_to_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire",
			},
			{
				"query_context",
				"attacking_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"query_context",
				"attacked_class",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5,
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "friendly_fire_from_cryptic_to_adamant",
		response = "friendly_fire_from_cryptic_to_adamant",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire",
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"adamant",
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5,
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "friendly_fire_from_cryptic_to_broker",
		response = "friendly_fire_from_cryptic_to_broker",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire",
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"broker",
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5,
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "friendly_fire_from_cryptic_to_cryptic",
		response = "friendly_fire_from_cryptic_to_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire",
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"cryptic",
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5,
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "friendly_fire_from_cryptic_to_ogryn",
		response = "friendly_fire_from_cryptic_to_ogryn",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire",
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"ogryn",
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5,
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "friendly_fire_from_cryptic_to_psyker",
		response = "friendly_fire_from_cryptic_to_psyker",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire",
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"psyker",
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5,
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "friendly_fire_from_cryptic_to_veteran",
		response = "friendly_fire_from_cryptic_to_veteran",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire",
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"veteran",
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5,
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "friendly_fire_from_cryptic_to_zealot",
		response = "friendly_fire_from_cryptic_to_zealot",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire",
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"zealot",
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
				},
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5,
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "knocked_down_multiple_times_acryptic",
		response = "knocked_down_multiple_times_acryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"knocked_down_multiple_times",
			},
			{
				"query_context",
				"player_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"faction_memory",
				"time_since_knocked_down_multiple_times",
				OP.TIMEDIFF,
				OP.GT,
				300,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_knocked_down_multiple_times",
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
		category = "player_prio_1",
		database = "cryptic",
		name = "knocked_down_multiple_times_cryptic",
		response = "knocked_down_multiple_times_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"knocked_down_multiple_times",
			},
			{
				"query_context",
				"player_class",
				OP.EQ,
				"cryptic",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"faction_memory",
				"time_since_knocked_down_multiple_times",
				OP.TIMEDIFF,
				OP.GT,
				300,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_knocked_down_multiple_times",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "ogryn_seen_killstreak_cryptic",
		response = "ogryn_seen_killstreak_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15,
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn",
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 2,
				max_failed_tries = 4,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "ogryn_start_revive_cryptic",
		response = "ogryn_start_revive_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo",
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"ogryn",
				},
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive",
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "cryptic",
		name = "player_death_acryptic",
		response = "player_death_acryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"player_death",
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30,
			},
			{
				"query_context",
				"died_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"query_context",
				"current_mission",
				OP.NEQ,
				"prologue",
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_player_death",
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
		category = "player_prio_0",
		database = "cryptic",
		name = "player_death_cryptic",
		response = "player_death_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"player_death",
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30,
			},
			{
				"query_context",
				"died_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"current_mission",
				OP.NEQ,
				"prologue",
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_player_death",
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
		category = "player_prio_1",
		database = "cryptic",
		name = "psyker_seen_killstreak_cryptic",
		response = "psyker_seen_killstreak_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15,
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker",
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"psyker_seen_killstreak_cryptic",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 2,
				max_failed_tries = 4,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "psyker_start_revive_cryptic",
		response = "psyker_start_revive_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo",
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"psyker",
				},
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive",
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "cryptic",
		name = "response_for_acryptic_cover_me",
		response = "response_for_acryptic_cover_me",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cover_me",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"faction_memory",
				"response_for_acryptic_cover_me",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_acryptic_cover_me",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_acryptic_critical_health",
		response = "response_for_acryptic_critical_health",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				10,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"critical_health",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.LT,
				180,
			},
		},
		on_done = {
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_acryptic_disabled_by_chaos_hound",
		response = "response_for_acryptic_disabled_by_chaos_hound",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"disabled_by_chaos_hound",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"faction_memory",
				"response_for_acryptic_disabled_by_chaos_hound",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_acryptic_disabled_by_chaos_hound",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_acryptic_disabled_by_enemy",
		response = "response_for_acryptic_disabled_by_enemy",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				10,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"disabled_by_enemy",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_acryptic_enemy_kill_monster",
		response = "response_for_acryptic_enemy_kill_monster",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_kill_monster",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"faction_memory",
				"response_for_acryptic_enemy_kill_monster",
				OP.TIMEDIFF,
				OP.GT,
				240,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_acryptic_enemy_kill_monster",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_acryptic_knocked_down_3",
		response = "response_for_acryptic_knocked_down_3",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"knocked_down_3",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"faction_memory",
				"response_for_acryptic_knocked_down_3",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_acryptic_knocked_down_3",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_acryptic_ledge_hanging",
		response = "response_for_acryptic_ledge_hanging",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ledge_hanging",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"faction_memory",
				"response_for_acryptic_ledge_hanging",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_acryptic_ledge_hanging",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_acryptic_seen_killstreak_cryptic",
		response = "response_for_acryptic_seen_killstreak_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_seen_killstreak_cryptic",
					"broker_seen_killstreak_cryptic",
					"ogryn_seen_killstreak_cryptic",
					"psyker_seen_killstreak_cryptic",
					"veteran_seen_killstreak_cryptic",
					"zealot_seen_killstreak_cryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_acryptic_start_revive_cryptic",
		response = "response_for_acryptic_start_revive_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.LTEQ,
				7,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"adamant_start_revive_cryptic",
					"broker_start_revive_cryptic",
					"ogryn_start_revive_cryptic",
					"psyker_start_revive_cryptic",
					"veteran_start_revive_cryptic",
					"zealot_start_revive_cryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
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
		category = "conversations_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_cover_me",
		response = "response_for_cryptic_cover_me",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cover_me",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"faction_memory",
				"response_for_cryptic_cover_me",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_cryptic_cover_me",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_critical_health",
		response = "response_for_cryptic_critical_health",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				10,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"critical_health",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.LT,
				180,
			},
		},
		on_done = {
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMESET,
			},
			{
				"user_memory",
				"rapid_loosing_health_response_cryptic",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_disabled_by_chaos_hound",
		response = "response_for_cryptic_disabled_by_chaos_hound",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"disabled_by_chaos_hound",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"faction_memory",
				"response_for_cryptic_disabled_by_chaos_hound",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_cryptic_disabled_by_chaos_hound",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_disabled_by_enemy",
		response = "response_for_cryptic_disabled_by_enemy",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				10,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"disabled_by_enemy",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
		},
		on_done = {},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_enemy_kill_monster",
		response = "response_for_cryptic_enemy_kill_monster",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_kill_monster",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"faction_memory",
				"response_for_cryptic_enemy_kill_monster",
				OP.TIMEDIFF,
				OP.GT,
				240,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_cryptic_enemy_kill_monster",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_knocked_down_3",
		response = "response_for_cryptic_knocked_down_3",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"knocked_down_3",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"faction_memory",
				"response_for_cryptic_knocked_down_3",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_cryptic_knocked_down_3",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_ledge_hanging",
		response = "response_for_cryptic_ledge_hanging",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ledge_hanging",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"faction_memory",
				"response_for_cryptic_ledge_hanging",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_cryptic_ledge_hanging",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_seen_killstreak_adamant",
		response = "response_for_cryptic_seen_killstreak_adamant",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_seen_killstreak_acryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"adamant",
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"cryptic_seen_killstreak_adamant",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_seen_killstreak_broker",
		response = "response_for_cryptic_seen_killstreak_broker",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_seen_killstreak_acryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"broker",
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"cryptic_seen_killstreak_broker",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_seen_killstreak_cryptic",
		response = "response_for_cryptic_seen_killstreak_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_seen_killstreak_cryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"cryptic",
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_seen_killstreak_ogryn",
		response = "response_for_cryptic_seen_killstreak_ogryn",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_seen_killstreak_acryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn",
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"cryptic_seen_killstreak_ogryn",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_seen_killstreak_psyker",
		response = "response_for_cryptic_seen_killstreak_psyker",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_seen_killstreak_acryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker",
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"cryptic_seen_killstreak_psyker",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_seen_killstreak_veteran",
		response = "response_for_cryptic_seen_killstreak_veteran",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_seen_killstreak_acryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran",
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_seen_killstreak_zealot",
		response = "response_for_cryptic_seen_killstreak_zealot",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_seen_killstreak_acryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot",
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"cryptic_seen_killstreak_zealot",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_start_revive_adamant",
		response = "response_for_cryptic_start_revive_adamant",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.LTEQ,
				7,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_start_revive_acryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"adamant",
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_start_revive_broker",
		response = "response_for_cryptic_start_revive_broker",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.LTEQ,
				7,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_start_revive_acryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"broker",
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_start_revive_cryptic",
		response = "response_for_cryptic_start_revive_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.LTEQ,
				7,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_start_revive_cryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"cryptic",
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_start_revive_ogryn",
		response = "response_for_cryptic_start_revive_ogryn",
		wwise_route = 0,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.LTEQ,
				7,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_start_revive_acryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn",
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_start_revive_psyker",
		response = "response_for_cryptic_start_revive_psyker",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.LTEQ,
				7,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_start_revive_acryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker",
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_start_revive_veteran",
		response = "response_for_cryptic_start_revive_veteran",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.LTEQ,
				7,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_start_revive_acryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran",
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_cryptic_start_revive_zealot",
		response = "response_for_cryptic_start_revive_zealot",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.LTEQ,
				7,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic_start_revive_acryptic",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot",
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_friendly_fire_from_adamant_to_cryptic",
		response = "response_for_friendly_fire_from_adamant_to_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				5,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_acryptic_to_cryptic",
				},
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"adamant",
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60",
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_friendly_fire_from_broker_to_cryptic",
		response = "response_for_friendly_fire_from_broker_to_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				5,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_acryptic_to_cryptic",
				},
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"broker",
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60",
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_friendly_fire_from_cryptic_to_acryptic",
		response = "response_for_friendly_fire_from_cryptic_to_acryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_cryptic_to_adamant",
					"friendly_fire_from_cryptic_to_broker",
					"friendly_fire_from_cryptic_to_ogryn",
					"friendly_fire_from_cryptic_to_psyker",
					"friendly_fire_from_cryptic_to_veteran",
					"friendly_fire_from_cryptic_to_zealot",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_friendly_fire_from_cryptic_to_cryptic",
		response = "response_for_friendly_fire_from_cryptic_to_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				5,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_cryptic_to_cryptic",
				},
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"cryptic",
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60",
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_friendly_fire_from_ogryn_to_cryptic",
		response = "response_for_friendly_fire_from_ogryn_to_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				5,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_acryptic_to_cryptic",
				},
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn",
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60",
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_friendly_fire_from_psyker_to_cryptic",
		response = "response_for_friendly_fire_from_psyker_to_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				5,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_acryptic_to_cryptic",
				},
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker",
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60",
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_friendly_fire_from_veteran_to_cryptic",
		response = "response_for_friendly_fire_from_veteran_to_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				5,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_acryptic_to_cryptic",
				},
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran",
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60",
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_friendly_fire_from_zealot_to_cryptic",
		response = "response_for_friendly_fire_from_zealot_to_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				5,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_acryptic_to_cryptic",
				},
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot",
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60",
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1,
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_pinned_by_enemies_acryptic",
		response = "response_for_pinned_by_enemies_acryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"pinned_by_enemies",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.SET_INCLUDES,
				args = {
					"adamant",
					"broker",
					"ogryn",
					"psyker",
					"veteran",
					"zealot",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"faction_memory",
				"response_for_pinned_by_enemies_acryptic",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_pinned_by_enemies_acryptic",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "response_for_pinned_by_enemies_cryptic",
		response = "response_for_pinned_by_enemies_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
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
				OP.GTEQ,
				0,
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"pinned_by_enemies",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"cryptic",
			},
			{
				"faction_memory",
				"response_for_pinned_by_enemies_cryptic",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_pinned_by_enemies_cryptic",
				OP.TIMESET,
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
		category = "player_prio_1",
		database = "cryptic",
		name = "veteran_seen_killstreak_cryptic",
		response = "veteran_seen_killstreak_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15,
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran",
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 2,
				max_failed_tries = 4,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "veteran_start_revive_cryptic",
		response = "veteran_start_revive_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo",
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"veteran",
				},
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive",
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "zealot_seen_killstreak_cryptic",
		response = "zealot_seen_killstreak_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"cryptic",
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15,
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot",
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 2,
				max_failed_tries = 4,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "cryptic",
		name = "zealot_start_revive_cryptic",
		response = "zealot_start_revive_cryptic",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo",
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"zealot",
				},
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"cryptic",
				},
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive",
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
end
