-- chunkname: @dialogues/generated/adamant.lua

return function ()
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "ability_charge_a",
		response = "ability_charge_a",
		wwise_route = 29,
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
				"ability_charge_a",
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
	})
	define_rule({
		category = "player_ability_vo",
		database = "adamant",
		name = "ability_howl_a",
		response = "ability_howl_a",
		wwise_route = 30,
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
				"ability_howl_a",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "ability_stance_a",
		response = "ability_stance_a",
		wwise_route = 24,
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
				"ability_stance_a",
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
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "adamant_seen_killstreak_adamant",
		response = "adamant_seen_killstreak_adamant",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_adamant",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"adamant",
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
		database = "adamant",
		name = "adamant_seen_killstreak_ogryn",
		response = "adamant_seen_killstreak_ogryn",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_ogryn",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"ogryn",
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
			{
				"user_memory",
				"last_seen_killstreak_user",
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
		database = "adamant",
		name = "adamant_seen_killstreak_psyker",
		response = "adamant_seen_killstreak_psyker",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_psyker",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"psyker",
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
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_adamant_seen_killstreak_psyker_user",
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
		database = "adamant",
		name = "adamant_seen_killstreak_veteran",
		response = "adamant_seen_killstreak_veteran",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_veteran",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"veteran",
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
		database = "adamant",
		name = "adamant_seen_killstreak_zealot",
		response = "adamant_seen_killstreak_zealot",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_zealot",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"zealot",
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
		database = "adamant",
		name = "adamant_start_revive_adamant",
		response = "adamant_start_revive_adamant",
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
					"adamant",
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
		database = "adamant",
		name = "adamant_start_revive_ogryn",
		response = "adamant_start_revive_ogryn",
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
					"ogryn",
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
		database = "adamant",
		name = "adamant_start_revive_psyker",
		response = "adamant_start_revive_psyker",
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
					"psyker",
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
		database = "adamant",
		name = "adamant_start_revive_veteran",
		response = "adamant_start_revive_veteran",
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
					"veteran",
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
		database = "adamant",
		name = "adamant_start_revive_zealot",
		response = "adamant_start_revive_zealot",
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
					"zealot",
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
		database = "adamant",
		name = "blitz_grenade_a",
		response = "blitz_grenade_a",
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
					"adamant_grenade",
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
			target = "players",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "blitz_kill_attack_a",
		response = "blitz_kill_attack_a",
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
				"ability_targeting_a",
			},
			{
				"user_context",
				"enemies_distant",
				OP.GTEQ,
				0,
			},
			{
				"user_memory",
				"ability_targeting_a",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"ability_targeting_a",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "blitz_kill_attack_a_heard_tag",
		response = "blitz_kill_attack_a_heard_tag",
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
					"smart_tag_vo_enemy_berserker",
					"smart_tag_vo_enemy_captain",
					"smart_tag_vo_enemy_chaos_hound",
					"smart_tag_vo_enemy_chaos_mutant_charger",
					"smart_tag_vo_enemy_chaos_ogryn_armored_executor",
					"smart_tag_vo_enemy_chaos_ogryn_bulwark",
					"smart_tag_vo_enemy_chaos_ogryn_heavy_gunner",
					"smart_tag_vo_enemy_chaos_poxwalker_bomber",
					"smart_tag_vo_enemy_chaos_spawn",
					"smart_tag_vo_enemy_cultist_flamer",
					"smart_tag_vo_enemy_cultist_grenadier",
					"smart_tag_vo_enemy_cultist_holy_stubber_gunner",
					"smart_tag_vo_enemy_cultist_shocktrooper",
					"smart_tag_vo_enemy_daemonhost_witch",
					"smart_tag_vo_enemy_daemonhost_witch_not_alerted",
					"smart_tag_vo_enemy_netgunner",
					"smart_tag_vo_enemy_plague_ogryn",
					"smart_tag_vo_enemy_renegade_berserker",
					"smart_tag_vo_enemy_scab_flamer",
					"smart_tag_vo_enemy_traitor_executor",
					"smart_tag_vo_enemy_traitor_grenadier",
					"smart_tag_vo_enemy_traitor_gunner",
					"smart_tag_vo_enemy_traitor_scout_shocktrooper",
					"smart_tag_vo_enemy_traitor_sniper",
				},
			},
			{
				"user_memory",
				"ability_targeting_a",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
			{
				"user_memory",
				"command_triggered",
				OP.TIMEDIFF,
				OP.LT,
				5,
			},
			{
				"user_memory",
				"ability_targeting_a",
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"ability_targeting_a",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.1,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "blitz_mine_a",
		response = "blitz_mine_a",
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
					"shock_mine",
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
			target = "players",
		},
	})
	define_rule({
		category = "player_ability_vo",
		database = "adamant",
		name = "blitz_nuncio_a",
		response = "blitz_nuncio_a",
		wwise_route = 30,
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
				"blitz_nuncio_a",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "deployed_ammo_crate_adamant_low_on_ammo",
		response = "deployed_ammo_crate_adamant_low_on_ammo",
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
					"adamant",
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
		database = "adamant",
		name = "found_ammo_adamant_low_on_ammo",
		response = "found_ammo_adamant_low_on_ammo",
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
		database = "adamant",
		name = "found_health_booster_adamant_low_on_health",
		response = "found_health_booster_adamant_low_on_health",
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
		database = "adamant",
		name = "found_health_station_adamant_low_on_health",
		response = "found_health_station_adamant_low_on_health",
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
			target = "all",
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "friendly_fire_from_adamant_to_adamant",
		response = "friendly_fire_from_adamant_to_adamant",
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
				"adamant",
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
		database = "adamant",
		name = "friendly_fire_from_adamant_to_ogryn",
		response = "friendly_fire_from_adamant_to_ogryn",
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
				"adamant",
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
		database = "adamant",
		name = "friendly_fire_from_adamant_to_psyker",
		response = "friendly_fire_from_adamant_to_psyker",
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
				"adamant",
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
		database = "adamant",
		name = "friendly_fire_from_adamant_to_veteran",
		response = "friendly_fire_from_adamant_to_veteran",
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
				"adamant",
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
		database = "adamant",
		name = "friendly_fire_from_adamant_to_zealot",
		response = "friendly_fire_from_adamant_to_zealot",
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
				"adamant",
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
		database = "adamant",
		name = "friendly_fire_from_ogryn_to_adamant",
		response = "friendly_fire_from_ogryn_to_adamant",
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
				"ogryn",
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
		database = "adamant",
		name = "friendly_fire_from_psyker_to_adamant",
		response = "friendly_fire_from_psyker_to_adamant",
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
				"psyker",
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
		database = "adamant",
		name = "friendly_fire_from_veteran_to_adamant",
		response = "friendly_fire_from_veteran_to_adamant",
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
				"veteran",
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
		database = "adamant",
		name = "friendly_fire_from_zealot_to_adamant",
		response = "friendly_fire_from_zealot_to_adamant",
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
				"zealot",
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
		database = "adamant",
		name = "knocked_down_multiple_times_adamant",
		response = "knocked_down_multiple_times_adamant",
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
				"adamant",
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
		database = "adamant",
		name = "ogryn_seen_killstreak_adamant",
		response = "ogryn_seen_killstreak_adamant",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_adamant",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"adamant",
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
			{
				"user_memory",
				"last_seen_killstreak_user",
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
		database = "adamant",
		name = "ogryn_start_revive_adamant",
		response = "ogryn_start_revive_adamant",
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
					"adamant",
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
		database = "adamant",
		name = "player_death_adamant",
		response = "player_death_adamant",
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
				"adamant",
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
		database = "adamant",
		name = "psyker_seen_killstreak_adamant",
		response = "psyker_seen_killstreak_adamant",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_adamant",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"adamant",
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
				"user_memory",
				"last_seen_killstreak_user",
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
		database = "adamant",
		name = "psyker_start_revive_adamant",
		response = "psyker_start_revive_adamant",
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
					"adamant",
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
		database = "adamant",
		name = "response_for_adamant_cover_me",
		response = "response_for_adamant_cover_me",
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
				"adamant",
			},
			{
				"faction_memory",
				"response_for_adamant_cover_me",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_adamant_cover_me",
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
		database = "adamant",
		name = "response_for_adamant_critical_health",
		response = "response_for_adamant_critical_health",
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
				"adamant",
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
				"rapid_loosing_health_response_adamant",
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
		database = "adamant",
		name = "response_for_adamant_disabled_by_chaos_hound",
		response = "response_for_adamant_disabled_by_chaos_hound",
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
				"adamant",
			},
			{
				"faction_memory",
				"response_for_adamant_disabled_by_chaos_hound",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_adamant_disabled_by_chaos_hound",
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
		database = "adamant",
		name = "response_for_adamant_disabled_by_enemy",
		response = "response_for_adamant_disabled_by_enemy",
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
				"adamant",
			},
		},
		on_done = {},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "response_for_adamant_enemy_kill_monster",
		response = "response_for_adamant_enemy_kill_monster",
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
				"adamant",
			},
			{
				"faction_memory",
				"",
				OP.TIMEDIFF,
				OP.GT,
				240,
			},
		},
		on_done = {
			{
				"faction_memory",
				"",
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
		database = "adamant",
		name = "response_for_adamant_knocked_down_3",
		response = "response_for_adamant_knocked_down_3",
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
				"adamant",
			},
			{
				"faction_memory",
				"response_for_adamant_knocked_down_3",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_adamant_knocked_down_3",
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
		database = "adamant",
		name = "response_for_adamant_ledge_hanging",
		response = "response_for_adamant_ledge_hanging",
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
				"adamant",
			},
			{
				"faction_memory",
				"response_for_adamant_ledge_hanging",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_adamant_ledge_hanging",
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
		database = "adamant",
		name = "response_for_adamant_seen_killstreak_adamant",
		response = "response_for_adamant_seen_killstreak_adamant",
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
					"adamant_seen_killstreak_adamant",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"adamant",
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
		database = "adamant",
		name = "response_for_adamant_seen_killstreak_ogryn",
		response = "response_for_adamant_seen_killstreak_ogryn",
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
					"adamant_seen_killstreak_ogryn",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"adamant",
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
		database = "adamant",
		name = "response_for_adamant_seen_killstreak_psyker",
		response = "response_for_adamant_seen_killstreak_psyker",
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
					"adamant_seen_killstreak_psyker",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"adamant",
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
		database = "adamant",
		name = "response_for_adamant_seen_killstreak_veteran",
		response = "response_for_adamant_seen_killstreak_veteran",
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
					"adamant_seen_killstreak_veteran",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"adamant",
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
		database = "adamant",
		name = "response_for_adamant_seen_killstreak_zealot",
		response = "response_for_adamant_seen_killstreak_zealot",
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
					"adamant_seen_killstreak_zealot",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"adamant",
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
		database = "adamant",
		name = "response_for_adamant_start_revive_adamant",
		response = "response_for_adamant_start_revive_adamant",
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
					"adamant_start_revive_adamant",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"adamant",
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
		database = "adamant",
		name = "response_for_adamant_start_revive_ogryn",
		response = "response_for_adamant_start_revive_ogryn",
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
					"adamant_start_revive_ogryn",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"adamant",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "response_for_adamant_start_revive_psyker",
		response = "response_for_adamant_start_revive_psyker",
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
					"adamant_start_revive_psyker",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"adamant",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "response_for_adamant_start_revive_veteran",
		response = "response_for_adamant_start_revive_veteran",
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
					"adamant_start_revive_veteran",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"adamant",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "response_for_adamant_start_revive_zealot",
		response = "response_for_adamant_start_revive_zealot",
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
					"adamant_start_revive_zealot",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"adamant",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "response_for_friendly_fire_from_adamant_to_adamant",
		response = "response_for_friendly_fire_from_adamant_to_adamant",
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
					"friendly_fire_from_adamant_to_adamant",
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
		database = "adamant",
		name = "response_for_friendly_fire_from_adamant_to_ogryn",
		response = "response_for_friendly_fire_from_adamant_to_ogryn",
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
					"friendly_fire_from_adamant_to_ogryn",
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
		database = "adamant",
		name = "response_for_friendly_fire_from_adamant_to_psyker",
		response = "response_for_friendly_fire_from_adamant_to_psyker",
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
					"friendly_fire_from_adamant_to_psyker",
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
		database = "adamant",
		name = "response_for_friendly_fire_from_adamant_to_veteran",
		response = "response_for_friendly_fire_from_adamant_to_veteran",
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
					"friendly_fire_from_adamant_to_veteran",
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
		database = "adamant",
		name = "response_for_friendly_fire_from_adamant_to_zealot",
		response = "response_for_friendly_fire_from_adamant_to_zealot",
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
					"friendly_fire_from_adamant_to_zealot",
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
		database = "adamant",
		name = "response_for_friendly_fire_from_ogryn_to_adamant",
		response = "response_for_friendly_fire_from_ogryn_to_adamant",
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
					"friendly_fire_from_ogryn_to_adamant",
				},
			},
			{
				"user_context",
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
		database = "adamant",
		name = "response_for_friendly_fire_from_psyker_to_adamant",
		response = "response_for_friendly_fire_from_psyker_to_adamant",
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
					"friendly_fire_from_psyker_to_adamant",
				},
			},
			{
				"user_context",
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
			{
				"user_memory",
				"time_since_friendly_fire_ps_og",
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
		database = "adamant",
		name = "response_for_friendly_fire_from_veteran_to_adamant",
		response = "response_for_friendly_fire_from_veteran_to_adamant",
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
					"friendly_fire_from_veteran_to_adamant",
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
			{
				"user_memory",
				"time_since_friendly_fire_vt_og",
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
		database = "adamant",
		name = "response_for_friendly_fire_from_zealot_to_adamant",
		response = "response_for_friendly_fire_from_zealot_to_adamant",
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
					"friendly_fire_from_zealot_to_adamant",
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
		database = "adamant",
		name = "response_for_ogryn_seen_killstreak_adamant",
		response = "response_for_ogryn_seen_killstreak_adamant",
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
				OP.GTEQ,
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
					"ogryn_seen_killstreak_adamant",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn",
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
		database = "adamant",
		name = "response_for_ogryn_start_revive_adamant",
		response = "response_for_ogryn_start_revive_adamant",
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
					"ogryn_start_revive_adamant",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "response_for_pinned_by_enemies_adamant",
		response = "response_for_pinned_by_enemies_adamant",
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
				"adamant",
			},
			{
				"faction_memory",
				"response_for_pinned_by_enemies_adamant",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"response_for_pinned_by_enemies_adamant",
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
		database = "adamant",
		name = "response_for_psyker_seen_killstreak_adamant",
		response = "response_for_psyker_seen_killstreak_adamant",
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
					"psyker_seen_killstreak_adamant",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker",
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
		database = "adamant",
		name = "response_for_psyker_start_revive_adamant",
		response = "response_for_psyker_start_revive_adamant",
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
					"psyker_start_revive_adamant",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "response_for_veteran_seen_killstreak_adamant",
		response = "response_for_veteran_seen_killstreak_adamant",
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
					"veteran_seen_killstreak_adamant",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran",
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
		database = "adamant",
		name = "response_for_veteran_start_revive_adamant",
		response = "response_for_veteran_start_revive_adamant",
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
					"veteran_start_revive_adamant",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "response_for_zealot_seen_killstreak_adamant",
		response = "response_for_zealot_seen_killstreak_adamant",
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
					"zealot_seen_killstreak_adamant",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot",
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
		database = "adamant",
		name = "response_for_zealot_start_revive_adamant",
		response = "response_for_zealot_start_revive_adamant",
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
					"zealot_start_revive_adamant",
				},
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot",
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
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "adamant",
		name = "veteran_seen_killstreak_adamant",
		response = "veteran_seen_killstreak_adamant",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_adamant",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"adamant",
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
			{
				"user_memory",
				"last_seen_killstreak_user",
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
		database = "adamant",
		name = "veteran_start_revive_adamant",
		response = "veteran_start_revive_adamant",
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
					"adamant",
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
		database = "adamant",
		name = "zealot_seen_killstreak_adamant",
		response = "zealot_seen_killstreak_adamant",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_adamant",
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"adamant",
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
			{
				"user_memory",
				"last_seen_killstreak_user",
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
		database = "adamant",
		name = "zealot_start_revive_adamant",
		response = "zealot_start_revive_adamant",
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
					"adamant",
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
