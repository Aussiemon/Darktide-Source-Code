return function ()
	define_rule({
		name = "ability_biomancer_high",
		category = "player_prio_1",
		wwise_route = 30,
		response = "ability_biomancer_high",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"combat_ability"
			},
			{
				"query_context",
				"ability_name",
				OP.EQ,
				"ability_biomancer_high"
			},
			{
				"user_context",
				"enemies_distant",
				OP.GT,
				0
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "ability_biomancer_low",
		category = "player_prio_1",
		wwise_route = 31,
		response = "ability_biomancer_low",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"combat_ability"
			},
			{
				"query_context",
				"ability_name",
				OP.EQ,
				"ability_biomancer_low"
			},
			{
				"user_context",
				"enemies_distant",
				OP.GT,
				0
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "ability_bonebreaker",
		category = "player_prio_1",
		wwise_route = 30,
		response = "ability_bonebreaker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"combat_ability"
			},
			{
				"query_context",
				"ability_name",
				OP.EQ,
				"ability_bonebreaker"
			},
			{
				"user_context",
				"enemies_close",
				OP.GT,
				0
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "ability_maniac",
		category = "player_prio_1",
		wwise_route = 29,
		response = "ability_maniac",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"combat_ability"
			},
			{
				"query_context",
				"ability_name",
				OP.EQ,
				"ability_maniac"
			},
			{
				"user_context",
				"enemies_distant",
				OP.GT,
				0
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "ability_ranger",
		category = "player_prio_1",
		wwise_route = 24,
		response = "ability_ranger",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"combat_ability"
			},
			{
				"query_context",
				"ability_name",
				OP.EQ,
				"ability_ranger"
			},
			{
				"user_context",
				"enemies_distant",
				OP.GT,
				0
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "ability_venting",
		category = "player_prio_1",
		wwise_route = 0,
		response = "ability_venting",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"combat_ability"
			},
			{
				"query_context",
				"ability_name",
				OP.EQ,
				"ability_venting"
			},
			{
				"user_context",
				"enemies_close",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"time_since_ability_venting",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_ability_venting",
				OP.TIMESET,
				0
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "ammo_hog_a",
		wwise_route = 0,
		response = "ammo_hog_a",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"ammo_hog"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium"
				}
			},
			{
				"user_context",
				"total_ammo_percentage",
				OP.LTEQ,
				0.5
			},
			{
				"faction_memory",
				"last_ammo_hog",
				OP.TIMEDIFF,
				OP.GT,
				600
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_ammo_hog",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "ammo_hog_b",
		wwise_route = 0,
		response = "ammo_hog_b",
		database = "gameplay_vo",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ammo_hog_a"
				}
			},
			{
				"user_memory",
				"last_ammo_hogger",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_ammo_hogger",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "away_from_squad",
		category = "player_prio_1",
		wwise_route = 0,
		response = "away_from_squad",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friends_distant"
			},
			{
				"user_context",
				"friends_close",
				OP.EQ,
				0
			},
			{
				"user_context",
				"friends_distant",
				OP.GTEQ,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				15
			},
			{
				"faction_memory",
				"last_friends_distant",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_friends_distant",
				OP.TIMESET
			},
			{
				"user_memory",
				"away_from_squad_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "blitz_brainburst_chain_a",
		wwise_route = 0,
		response = "blitz_brainburst_chain_a",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"multiple_head_pops"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"psyker"
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				10
			},
			{
				"user_memory",
				"blitz_brainburst_chain_a",
				OP.TIMEDIFF,
				OP.GT,
				120
			},
			{
				"user_memory",
				"repeated_psykinetic_head_pop_a",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"blitz_brainburst_chain_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			},
			random_ignore_vo = {
				chance = 0.15,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "blitz_flame_grenade_a",
		category = "player_prio_1",
		wwise_route = 0,
		response = "blitz_flame_grenade_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"throwing_item"
			},
			{
				"query_context",
				"item",
				OP.SET_INCLUDES,
				args = {
					"fire_grenade"
				}
			},
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "blitz_grenade_box_a",
		category = "player_prio_1",
		wwise_route = 0,
		response = "blitz_grenade_box_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"throwing_item"
			},
			{
				"query_context",
				"item",
				OP.SET_INCLUDES,
				args = {
					"ogryn_grenade_box",
					"ogryn_grenade_box_cluster"
				}
			},
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMESET
			},
			{
				"faction_memory",
				"thrown_grenades",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "blitz_krak_grenade_a",
		category = "player_prio_1",
		wwise_route = 0,
		response = "blitz_krak_grenade_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"throwing_item"
			},
			{
				"query_context",
				"item",
				OP.SET_INCLUDES,
				args = {
					"krak_grenade"
				}
			},
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "blitz_rock_a",
		category = "player_prio_1",
		wwise_route = 0,
		response = "blitz_rock_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"throwing_item"
			},
			{
				"query_context",
				"item",
				OP.SET_INCLUDES,
				args = {
					"ogryn_grenade_friend_rock"
				}
			},
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMEDIFF,
				OP.GT,
				15
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "blitz_shards_chain_a",
		category = "player_prio_1",
		wwise_route = 0,
		response = "blitz_shards_chain_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"kill_spree_self"
			},
			{
				"user_context",
				"weapon_type",
				OP.SET_INCLUDES,
				args = {
					"psyker_throwing_knives"
				}
			},
			{
				"user_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				3
			},
			{
				"user_memory",
				"last_kill_spree",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"user_memory",
				"last_kill_spree",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "blitz_smite_chain_a",
		category = "player_prio_1",
		wwise_route = 0,
		response = "blitz_smite_chain_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"kill_spree_self"
			},
			{
				"user_context",
				"weapon_type",
				OP.SET_INCLUDES,
				args = {
					"psyker_chain_lightning"
				}
			},
			{
				"user_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				3
			},
			{
				"user_memory",
				"last_kill_spree",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"user_memory",
				"last_kill_spree",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "blitz_smoke_grenade_a",
		category = "player_prio_1",
		wwise_route = 0,
		response = "blitz_smoke_grenade_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"throwing_item"
			},
			{
				"query_context",
				"item",
				OP.SET_INCLUDES,
				args = {
					"smoke_grenade"
				}
			},
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "calling_for_help",
		wwise_route = 0,
		response = "calling_for_help",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"rapid_loosing_health"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GT,
				10
			},
			{
				"user_memory",
				"last_calling_for_help",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"user_memory",
				"last_calling_for_help",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "chaos_daemonhost_aggroed",
		category = "enemy_alerts_prio_0",
		wwise_route = 0,
		response = "chaos_daemonhost_aggroed",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"player_enemy_alert"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"aggroed"
			}
		},
		on_done = {
			{
				"faction_memory",
				"lore_daemons_one_a",
				OP.ADD,
				1
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.25
			}
		}
	})
	define_rule({
		name = "chaos_daemonhost_alerted",
		wwise_route = 0,
		response = "chaos_daemonhost_alerted",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"player_enemy_alert"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"alerted"
			},
			{
				"faction_memory",
				"chaos_daemonhost_alerted",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"faction_memory",
				"chaos_daemonhost_alerted",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "chaos_daemonhost_combo_attack",
		category = "enemy_alerts_prio_0",
		wwise_route = 0,
		response = "chaos_daemonhost_combo_attack",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"player_enemy_alert"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"combo_attack"
			},
			{
				"faction_memory",
				"time_since_chaos_daemonhost_aggroed",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"chaos_daemonhost_combo_attack",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_chaos_daemonhost_combo_attack",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "come_back_to_squad",
		category = "player_prio_1",
		wwise_route = 0,
		response = "come_back_to_squad",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				15
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"away_from_squad"
				}
			}
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "cover_me",
		category = "player_prio_1",
		wwise_route = 0,
		response = "cover_me",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.SET_INCLUDES,
				args = {
					"cover_me"
				}
			},
			{
				"user_context",
				"friends_close",
				OP.LTEQ,
				3
			},
			{
				"user_context",
				"enemies_close",
				OP.GT,
				3
			},
			{
				"faction_memory",
				"cover_me",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"cover_me",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "critical_health",
		wwise_route = 0,
		response = "critical_health",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"rapid_loosing_health"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GT,
				0
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "deployed_ammo_crate",
		wwise_route = 0,
		response = "deployed_ammo_crate",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"deployed_ammo_crate"
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.GT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn",
					"psyker",
					"veteran",
					"zealot"
				}
			},
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "deployed_ammo_crate_ogryn_low_on_ammo",
		wwise_route = 0,
		response = "deployed_ammo_crate_ogryn_low_on_ammo",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"deployed_ammo_crate"
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.LT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "deployed_ammo_crate_psyker_low_on_ammo",
		wwise_route = 0,
		response = "deployed_ammo_crate_psyker_low_on_ammo",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"deployed_ammo_crate"
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.LT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "deployed_ammo_crate_veteran_low_on_ammo",
		wwise_route = 0,
		response = "deployed_ammo_crate_veteran_low_on_ammo",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"deployed_ammo_crate"
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.LT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "deployed_ammo_crate_zealot_low_on_ammo",
		wwise_route = 0,
		response = "deployed_ammo_crate_zealot_low_on_ammo",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"deployed_ammo_crate"
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.LT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_deployed_ammo_crate",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "disabled_by_chaos_hound",
		category = "player_prio_0",
		wwise_route = 0,
		response = "disabled_by_chaos_hound",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"pounced_by_special_attack"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_hound"
			},
			{
				"faction_memory",
				"disabled_by_chaos_hound",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"faction_memory",
				"disabled_by_chaos_hound",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "disabled_by_enemy",
		category = "player_prio_0",
		wwise_route = 0,
		response = "disabled_by_enemy",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"pounced_by_special_attack"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_netgunner"
			},
			{
				"faction_memory",
				"last_pounced_by_special_attack",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_pounced_by_special_attack",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "enemy_kill_berserker",
		wwise_route = 0,
		response = "enemy_kill_berserker",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"cultist_berzerker"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"time_since_enemy_kill_berserker",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"enemy_berserker",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_enemy_kill_berserker",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_berserker_quick_agnostic",
		wwise_route = 0,
		response = "enemy_kill_berserker_quick_agnostic",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.SET_INCLUDES,
				args = {
					"cultist_berzerker"
				}
			},
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"enemy_berserker",
				OP.TIMEDIFF,
				OP.LT,
				3
			},
			{
				"faction_memory",
				"enemy_berserker",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_chaos_hound",
		wwise_route = 0,
		response = "enemy_kill_chaos_hound",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"chaos_hound"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"time_since_enemy_kill_chaos_hound",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"enemy_chaos_hound",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_enemy_kill_chaos_hound",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_chaos_hound_quick_agnostic",
		wwise_route = 0,
		response = "enemy_kill_chaos_hound_quick_agnostic",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.SET_INCLUDES,
				args = {
					"chaos_hound"
				}
			},
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"enemy_chaos_hound",
				OP.TIMEDIFF,
				OP.LT,
				3
			},
			{
				"faction_memory",
				"enemy_chaos_hound",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_cultist_grenadier",
		wwise_route = 0,
		response = "enemy_kill_cultist_grenadier",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"cultist_grenadier"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"time_since_enemy_kill_grenadier",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"enemy_grenadier",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_enemy_kill_grenadier",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_cultist_mutant",
		wwise_route = 0,
		response = "enemy_kill_cultist_mutant",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"cultist_mutant"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"time_since_enemy_kill_cultist_mutant",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"enemy_cultist_mutant",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_enemy_kill_cultist_mutant",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_cultist_mutant_quick_agnostic",
		wwise_route = 0,
		response = "enemy_kill_cultist_mutant_quick_agnostic",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.SET_INCLUDES,
				args = {
					"cultist_mutant"
				}
			},
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"enemy_cultist_mutant",
				OP.TIMEDIFF,
				OP.LT,
				3
			},
			{
				"faction_memory",
				"enemy_cultist_mutant",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_daemonhost",
		wwise_route = 0,
		response = "enemy_kill_daemonhost",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"chaos_daemonhost"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"time_since_enemy_kill_daemonhost",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"enemy_chaos_daemonhost",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_enemy_kill_daemonhost",
				OP.TIMESET
			},
			{
				"faction_memory",
				"lore_daemons_one_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 3
			}
		}
	})
	define_rule({
		name = "enemy_kill_grenadier",
		wwise_route = 0,
		response = "enemy_kill_grenadier",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"renegade_grenadier"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"time_since_enemy_kill_grenadier",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"enemy_grenadier",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_enemy_kill_grenadier",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_grenadier_quick_agnostic",
		wwise_route = 0,
		response = "enemy_kill_grenadier_quick_agnostic",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.SET_INCLUDES,
				args = {
					"renegade_grenadier",
					"cultist_grenadier"
				}
			},
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"enemy_grenadier",
				OP.TIMEDIFF,
				OP.LT,
				3
			},
			{
				"faction_memory",
				"enemy_grenadier",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_monster",
		wwise_route = 0,
		response = "enemy_kill_monster",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"monster"
			},
			{
				"user_memory",
				"enemy_kill_monster",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_kill_monster",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 3
			}
		}
	})
	define_rule({
		name = "enemy_kill_netgunner",
		wwise_route = 0,
		response = "enemy_kill_netgunner",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"renegade_netgunner"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"time_since_enemy_kill_netgunner",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"enemy_renegade_netgunner",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_enemy_kill_netgunner",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_netgunner_quick_agnostic",
		wwise_route = 0,
		response = "enemy_kill_netgunner_quick_agnostic",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.SET_INCLUDES,
				args = {
					"renegade_netgunner"
				}
			},
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"enemy_renegade_netgunner",
				OP.TIMEDIFF,
				OP.LT,
				3
			},
			{
				"faction_memory",
				"enemy_renegade_netgunner",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_poxwalker_bomber",
		wwise_route = 0,
		response = "enemy_kill_poxwalker_bomber",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"chaos_poxwalker_bomber"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"time_since_enemy_kill_poxwalker_bomber",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"chaos_poxwalker_bomber",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_enemy_kill_poxwalker_bomber",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_poxwalker_bomber_quick_agnostic",
		wwise_route = 0,
		response = "enemy_kill_poxwalker_bomber_quick_agnostic",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.SET_INCLUDES,
				args = {
					"chaos_poxwalker_bomber"
				}
			},
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"enemy_chaos_poxwalker_bomber",
				OP.TIMEDIFF,
				OP.LT,
				3
			},
			{
				"faction_memory",
				"enemy_chaos_poxwalker_bomber",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_renegade_berserker",
		wwise_route = 0,
		response = "enemy_kill_renegade_berserker",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"renegade_berzerker"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"time_since_enemy_kill_berserker",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"enemy_berserker",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_enemy_kill_berserker",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_renegade_berserker_quick_agnostic",
		wwise_route = 0,
		response = "enemy_kill_renegade_berserker_quick_agnostic",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.SET_INCLUDES,
				args = {
					"renegade_berzerker"
				}
			},
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"enemy_berserker",
				OP.TIMEDIFF,
				OP.LT,
				3
			},
			{
				"faction_memory",
				"enemy_berserker",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_scab_flamer",
		wwise_route = 0,
		response = "enemy_kill_scab_flamer",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"renegade_flamer"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"time_since_enemy_kill_renegade_flamer",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"enemy_renegade_flamer",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_enemy_kill_renegade_flamer",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_scab_flamer_quick_agnostic",
		wwise_route = 0,
		response = "enemy_kill_scab_flamer_quick_agnostic",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.SET_INCLUDES,
				args = {
					"renegade_flamer"
				}
			},
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"enemy_renegade_flamer",
				OP.TIMEDIFF,
				OP.LT,
				3
			},
			{
				"faction_memory",
				"enemy_renegade_flamer",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_sniper",
		wwise_route = 0,
		response = "enemy_kill_sniper",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"renegade_sniper"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"time_since_enemy_kill_renegade_flamer",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"enemy_renegade_sniper",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_enemy_kill_renegade_flamer",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_sniper_quick_agnostic",
		wwise_route = 0,
		response = "enemy_kill_sniper_quick_agnostic",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.SET_INCLUDES,
				args = {
					"renegade_sniper"
				}
			},
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"enemy_renegade_sniper",
				OP.TIMEDIFF,
				OP.LT,
				3
			},
			{
				"faction_memory",
				"enemy_renegade_sniper",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_tox_flamer",
		wwise_route = 0,
		response = "enemy_kill_tox_flamer",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.EQ,
				"cultist_flamer"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"time_since_enemy_kill_tox_flamer",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"enemy_cultist_flamer",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_enemy_kill_tox_flamer",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_kill_tox_flamer_quick_agnostic",
		wwise_route = 0,
		response = "enemy_kill_tox_flamer_quick_agnostic",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_kill"
			},
			{
				"query_context",
				"killed_type",
				OP.SET_INCLUDES,
				args = {
					"cultist_flamer"
				}
			},
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"enemy_cultist_flamer",
				OP.TIMEDIFF,
				OP.LT,
				3
			},
			{
				"faction_memory",
				"enemy_cultist_flamer",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"quick_agnostic_enemy_kill_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "enemy_near_death_monster",
		category = "enemy_alerts_prio_0",
		wwise_route = 0,
		response = "enemy_near_death_monster",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"enemy_near_death_monster"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			},
			{
				"faction_memory",
				"enemy_near_death_monster",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_near_death_monster",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "event_one_down",
		category = "player_prio_1",
		wwise_route = 0,
		response = "event_one_down",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"event_one_down"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "found_ammo_low_on_ammo",
		category = "player_prio_1",
		wwise_route = 0,
		response = "found_ammo_low_on_ammo",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"ammo"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				0
			},
			{
				"query_context",
				"distance",
				OP.LT,
				20
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30
			},
			{
				"user_context",
				"total_ammo_percentage",
				OP.LTEQ,
				0.5
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium"
				}
			},
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "found_ammo_ogryn_low_on_ammo",
		category = "player_prio_1",
		wwise_route = 0,
		response = "found_ammo_ogryn_low_on_ammo",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"ammo"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				6
			},
			{
				"query_context",
				"distance",
				OP.LT,
				20
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.LT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium"
				}
			},
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "found_ammo_psyker_low_on_ammo",
		category = "player_prio_1",
		wwise_route = 0,
		response = "found_ammo_psyker_low_on_ammo",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"ammo"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				6
			},
			{
				"query_context",
				"distance",
				OP.LT,
				20
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.LT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium"
				}
			},
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "found_ammo_veteran_low_on_ammo",
		category = "player_prio_1",
		wwise_route = 0,
		response = "found_ammo_veteran_low_on_ammo",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"ammo"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				6
			},
			{
				"query_context",
				"distance",
				OP.LT,
				20
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.LT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium"
				}
			},
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "found_ammo_zealot_low_on_ammo",
		category = "player_prio_1",
		wwise_route = 0,
		response = "found_ammo_zealot_low_on_ammo",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"ammo"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				6
			},
			{
				"query_context",
				"distance",
				OP.LT,
				20
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30
			},
			{
				"faction_context",
				"total_ammo_percentage",
				OP.LT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium"
				}
			},
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "found_health_booster",
		category = "player_prio_0",
		wwise_route = 0,
		response = "found_health_booster",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"found_health_booster_low_on_health"
			},
			{
				"user_context",
				"health",
				OP.GTEQ,
				0.3
			},
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "found_health_booster_low_on_health",
		category = "player_prio_0",
		wwise_route = 0,
		response = "found_health_booster_low_on_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"found_health_booster_low_on_health"
			},
			{
				"user_context",
				"health",
				OP.LT,
				0.3
			},
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "found_health_booster_ogryn_low_on_health",
		category = "player_prio_0",
		wwise_route = 0,
		response = "found_health_booster_ogryn_low_on_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"found_health_booster_low_on_health"
			},
			{
				"faction_context",
				"health",
				OP.LT,
				0.3
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "found_health_booster_psyker_low_on_health",
		category = "player_prio_0",
		wwise_route = 0,
		response = "found_health_booster_psyker_low_on_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"found_health_booster_low_on_health"
			},
			{
				"faction_context",
				"health",
				OP.LT,
				0.3
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "found_health_booster_veteran_low_on_health",
		category = "player_prio_0",
		wwise_route = 0,
		response = "found_health_booster_veteran_low_on_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"found_health_booster_low_on_health"
			},
			{
				"faction_context",
				"health",
				OP.LT,
				0.3
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "found_health_booster_zealot_low_on_health",
		category = "player_prio_0",
		wwise_route = 0,
		response = "found_health_booster_zealot_low_on_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"found_health_booster_low_on_health"
			},
			{
				"faction_context",
				"health",
				OP.LT,
				0.3
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"deployed_medical_crate",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "found_health_station_ogryn_low_on_health",
		category = "player_prio_1",
		wwise_route = 0,
		response = "found_health_station_ogryn_low_on_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"charged_health_station"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				25
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_context",
				"health",
				OP.LT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		name = "found_health_station_psyker_low_on_health",
		category = "player_prio_1",
		wwise_route = 0,
		response = "found_health_station_psyker_low_on_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"charged_health_station"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				25
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_context",
				"health",
				OP.LT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "found_health_station_veteran_low_on_health",
		category = "player_prio_1",
		wwise_route = 0,
		response = "found_health_station_veteran_low_on_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"charged_health_station"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				25
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_context",
				"health",
				OP.LT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		name = "found_health_station_zealot_low_on_health",
		category = "player_prio_1",
		wwise_route = 0,
		response = "found_health_station_zealot_low_on_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"charged_health_station"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				25
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_context",
				"health",
				OP.LT,
				0.5
			},
			{
				"faction_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		name = "friendly_fire_from_ogryn_to_ogryn",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_ogryn_to_ogryn",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"ogryn"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_ogryn_to_psyker",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_ogryn_to_psyker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"psyker"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_ogryn_to_veteran",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_ogryn_to_veteran",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"veteran"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_ogryn_to_zealot",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_ogryn_to_zealot",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"zealot"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_psyker_to_ogryn",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_psyker_to_ogryn",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"ogryn"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_psyker_to_psyker",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_psyker_to_psyker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"psyker"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_psyker_to_veteran",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_psyker_to_veteran",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"veteran"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			},
			{
				"faction_memory",
				"friendly_fire_from_psyker_to_veteran",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_friendly_fire_from_psyker_to_veteran",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_psyker_to_zealot",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_psyker_to_zealot",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"zealot"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_veteran_to_ogryn",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_veteran_to_ogryn",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"ogryn"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_veteran_to_psyker",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_veteran_to_psyker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"psyker"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_veteran_to_veteran",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_veteran_to_veteran",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"veteran"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_veteran_to_zealot",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_veteran_to_zealot",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"zealot"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_zealot_to_ogryn",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_zealot_to_ogryn",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"ogryn"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_zealot_to_psyker",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_zealot_to_psyker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"psyker"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_zealot_to_veteran",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_zealot_to_veteran",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"veteran"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "friendly_fire_from_zealot_to_zealot",
		category = "player_prio_1",
		wwise_route = 0,
		response = "friendly_fire_from_zealot_to_zealot",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"attacking_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"attacked_class",
				OP.EQ,
				"zealot"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				45
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_friendly_fire_global",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "head_shot",
		wwise_route = 0,
		response = "head_shot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"head_shot"
			},
			{
				"faction_memory",
				"time_since_head_shot",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_head_shot",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "heal_start",
		category = "player_prio_1",
		wwise_route = 0,
		response = "heal_start",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heal_start"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GT,
				4
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"medium",
					"high"
				}
			},
			{
				"user_context",
				"health",
				OP.LTEQ,
				0.8
			},
			{
				"user_memory",
				"last_heal_start",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"heal_start_faction",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"last_heal_start",
				OP.TIMESET
			},
			{
				"faction_memory",
				"heal_start_faction",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "health_hog_a",
		wwise_route = 0,
		response = "health_hog_a",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"health_hog"
			},
			{
				"user_context",
				"health",
				OP.LT,
				0.5
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium"
				}
			},
			{
				"faction_memory",
				"health_hog",
				OP.TIMEDIFF,
				OP.GT,
				600
			}
		},
		on_done = {
			{
				"faction_memory",
				"health_hog",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "health_hog_b",
		wwise_route = 0,
		response = "health_hog_b",
		database = "gameplay_vo",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"health_hog_a"
				}
			},
			{
				"user_memory",
				"last_health_hogger",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_health_hogger",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "heard_enemy_chaos_hound",
		category = "enemy_alerts_prio_0",
		wwise_route = 0,
		response = "heard_enemy_chaos_hound",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_hound"
			},
			{
				"query_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"faction_memory",
				"enemy_chaos_hound",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_chaos_hound",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "heard_enemy_chaos_spawn",
		wwise_route = 0,
		response = "heard_enemy_chaos_spawn",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_spawn"
			},
			{
				"faction_memory",
				"heard_enemy_chaos_spawn",
				OP.TIMEDIFF,
				OP.GT,
				340
			}
		},
		on_done = {
			{
				"faction_memory",
				"heard_enemy_chaos_spawn",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "heard_enemy_daemonhost",
		wwise_route = 0,
		response = "heard_enemy_daemonhost",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost"
			},
			{
				"faction_memory",
				"enemy_chaos_daemonhost",
				OP.TIMEDIFF,
				OP.GT,
				340
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_chaos_daemonhost",
				OP.TIMESET
			},
			{
				"faction_memory",
				"lore_daemons_one_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "heard_enemy_monster_generic",
		category = "enemy_alerts_prio_0",
		wwise_route = 0,
		response = "heard_enemy_monster_generic",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"monster"
			},
			{
				"query_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"faction_memory",
				"heard_enemy_monster_generic",
				OP.TIMEDIFF,
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"heard_enemy_monster_generic",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "heard_enemy_plague_ogryn",
		wwise_route = 0,
		response = "heard_enemy_plague_ogryn",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_plague_ogryn"
			},
			{
				"faction_memory",
				"heard_enemy_plague_ogryn",
				OP.TIMEDIFF,
				OP.GT,
				340
			}
		},
		on_done = {
			{
				"faction_memory",
				"heard_enemy_plague_ogryn",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "heard_horde_ambush",
		wwise_route = 0,
		response = "heard_horde_ambush",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_horde"
			},
			{
				"query_context",
				"horde_type",
				OP.EQ,
				"ambush"
			},
			{
				"faction_memory",
				"last_heard_horde",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_heard_horde",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 5
			}
		}
	})
	define_rule({
		name = "heard_horde_vector",
		wwise_route = 0,
		response = "heard_horde_vector",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_horde"
			},
			{
				"query_context",
				"horde_type",
				OP.EQ,
				"vector"
			},
			{
				"faction_memory",
				"last_heard_horde",
				OP.TIMEDIFF,
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_heard_horde",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 3
			}
		}
	})
	define_rule({
		name = "higher_elite_threat",
		category = "enemy_alerts_prio_0",
		wwise_route = 0,
		response = "higher_elite_threat",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"higher_elite_threat"
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "info_door_open",
		category = "player_prio_0",
		wwise_route = 0,
		response = "info_door_open",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"info_door_open"
			},
			{
				"faction_memory",
				"info_door_open",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_door_open",
				OP.TIMESET,
				0
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "info_event_almost_done",
		category = "player_prio_0",
		wwise_route = 0,
		response = "info_event_almost_done",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"info_event_almost_done"
			},
			{
				"faction_memory",
				"info_event_almost_done",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_event_almost_done",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "info_event_det_pack_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "info_event_det_pack_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"info_event_det_pack_a"
			},
			{
				"user_memory",
				"info_event_det_pack_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"info_event_det_pack_a",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "info_event_det_pack_b",
		wwise_route = 0,
		response = "info_event_det_pack_b",
		database = "gameplay_vo",
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"info_event_det_pack_a"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			},
			random_ignore_vo = {
				chance = 0.15,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "knocked_down_1",
		wwise_route = 0,
		response = "knocked_down_1",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"knocked_down"
			},
			{
				"query_context",
				"sequence_no",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.2
			}
		}
	})
	define_rule({
		name = "knocked_down_2",
		category = "player_prio_1",
		wwise_route = 0,
		response = "knocked_down_2",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"knocked_down"
			},
			{
				"query_context",
				"sequence_no",
				OP.EQ,
				2
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "knocked_down_3",
		category = "player_prio_1",
		wwise_route = 0,
		response = "knocked_down_3",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"knocked_down"
			},
			{
				"query_context",
				"sequence_no",
				OP.EQ,
				3
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "knocked_down_multiple_times_ogryn",
		category = "player_prio_1",
		wwise_route = 0,
		response = "knocked_down_multiple_times_ogryn",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"knocked_down_multiple_times"
			},
			{
				"query_context",
				"player_class",
				OP.EQ,
				"ogryn"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"faction_memory",
				"time_since_knocked_down_multiple_times",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_knocked_down_multiple_times",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "knocked_down_multiple_times_psyker",
		category = "player_prio_1",
		wwise_route = 0,
		response = "knocked_down_multiple_times_psyker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"knocked_down_multiple_times"
			},
			{
				"query_context",
				"player_class",
				OP.EQ,
				"psyker"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"faction_memory",
				"time_since_knocked_down_multiple_times",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_knocked_down_multiple_times",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "knocked_down_multiple_times_veteran",
		category = "player_prio_1",
		wwise_route = 0,
		response = "knocked_down_multiple_times_veteran",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"knocked_down_multiple_times"
			},
			{
				"query_context",
				"player_class",
				OP.EQ,
				"veteran"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"faction_memory",
				"time_since_knocked_down_multiple_times",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_knocked_down_multiple_times",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "knocked_down_multiple_times_zealot",
		category = "player_prio_1",
		wwise_route = 0,
		response = "knocked_down_multiple_times_zealot",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"knocked_down_multiple_times"
			},
			{
				"query_context",
				"player_class",
				OP.EQ,
				"zealot"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"faction_memory",
				"time_since_knocked_down_multiple_times",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_knocked_down_multiple_times",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "ledge_hanging",
		wwise_route = 0,
		response = "ledge_hanging",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"ledge_hanging"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 3
			}
		}
	})
	define_rule({
		name = "look_at_grenade",
		category = "player_prio_1",
		wwise_route = 0,
		response = "look_at_grenade",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.SET_INCLUDES,
				args = {
					"grenade"
				}
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				17
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_context",
				"total_ammo_percentage",
				OP.LTEQ,
				1
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium"
				}
			},
			{
				"user_memory",
				"last_saw_grenade",
				OP.TIMEDIFF,
				OP.GT,
				60
			},
			{
				"faction_memory",
				"look_at_grenade",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"thrown_grenades",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"last_saw_grenade",
				OP.TIMESET
			},
			{
				"faction_memory",
				"look_at_grenade",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "look_at_health_station_chargeable",
		category = "player_prio_1",
		wwise_route = 0,
		response = "look_at_health_station_chargeable",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"chargeable_health_station"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				25
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_context",
				"health",
				OP.LTEQ,
				1
			},
			{
				"user_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"user_memory",
				"last_saw_health",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "look_at_healthstation",
		category = "player_prio_1",
		wwise_route = 0,
		response = "look_at_healthstation",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"charged_health_station"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				25
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_context",
				"health",
				OP.LTEQ,
				0.9
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "visible_npcs"
		}
	})
	define_rule({
		name = "look_at_healthstation_personal",
		category = "player_prio_1",
		wwise_route = 0,
		response = "look_at_healthstation_personal",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"look_at"
			},
			{
				"query_context",
				"look_at_tag",
				OP.EQ,
				"charged_health_station"
			},
			{
				"query_context",
				"distance",
				OP.GT,
				1
			},
			{
				"query_context",
				"distance",
				OP.LT,
				25
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"user_context",
				"health",
				OP.LT,
				0.9
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "visible_npcs"
		}
	})
	define_rule({
		name = "martyr_skull_pickup",
		wwise_route = 52,
		response = "martyr_skull_pickup",
		database = "gameplay_vo",
		category = "npc_prio_0",
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"martyr_skull_pickup"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"warp_echo"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.8
			}
		}
	})
	define_rule({
		name = "medicae_servitor_idle_empty_a",
		category = "npc_prio_1",
		wwise_route = 45,
		response = "medicae_servitor_idle_empty_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"medicae_servitor_idle_empty_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"medicae_servitor"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "medicae_servitor_idle_full_a",
		wwise_route = 45,
		response = "medicae_servitor_idle_full_a",
		database = "gameplay_vo",
		category = "npc_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"look_at_healthstation",
					"found_health_station_zealot_low_on_health",
					"found_health_station_veteran_low_on_health",
					"found_health_station_psyker_low_on_health",
					"found_health_station_ogryn_low_on_health",
					"look_at_healthstation_personal"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"medicae_servitor"
				}
			},
			{
				"user_memory",
				"medicae_servitor_idle_full_a",
				OP.EQ,
				OP.GT,
				0
			},
			{
				"user_memory",
				"has_been_seen_time",
				OP.GT,
				1
			},
			{
				"user_memory",
				"has_been_seen_time",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"medicae_servitor_idle_full_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "medicae_servitor_recharge_a",
		category = "npc_prio_1",
		wwise_route = 45,
		response = "medicae_servitor_recharge_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"medicae_servitor_recharge_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"medicae_servitor"
				}
			},
			{
				"user_memory",
				"medicae_servitor_recharge_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"medicae_servitor_recharge_a",
				OP.TIMESET
			},
			{
				"user_memory",
				"medicae_servitor_idle_full_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "medicae_servitor_working_a",
		category = "npc_prio_1",
		wwise_route = 45,
		response = "medicae_servitor_working_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"medicae_servitor_working_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"medicae_servitor"
				}
			},
			{
				"user_memory",
				"medicae_servitor_working_a",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"medicae_servitor_working_a",
				OP.TIMESET
			},
			{
				"user_memory",
				"medicae_servitor_idle_full_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_archives_activate_from_hibernation_a",
		category = "npc_prio_0",
		wwise_route = 50,
		response = "mission_archives_activate_from_hibernation_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_archives_activate_from_hibernation_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"archive_servitor"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "mission_archives_task_complete_a",
		category = "npc_prio_0",
		wwise_route = 50,
		response = "mission_archives_task_complete_a",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"mission_archives_task_complete_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"archive_servitor"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "monster_fight_start_reaction",
		category = "enemy_alerts_prio_0",
		wwise_route = 0,
		response = "monster_fight_start_reaction",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"chaos_plague_ogryn",
					"chaos_beast_of_nurgle",
					"chaos_spawn"
				}
			},
			{
				"faction_memory",
				"monster_fight_start_reaction",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"faction_memory",
				"monster_fight_start_reaction",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "need_rescue",
		category = "player_prio_1",
		wwise_route = 0,
		response = "need_rescue",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"friends_close"
			},
			{
				"user_context",
				"is_hogtied",
				OP.EQ,
				"true"
			},
			{
				"faction_memory",
				"last_need_rescue",
				OP.TIMEDIFF,
				OP.GT,
				15
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_need_rescue",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "ogryn_seen_killstreak_ogryn",
		wwise_route = 0,
		response = "ogryn_seen_killstreak_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_ogryn"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "ogryn_seen_killstreak_psyker",
		wwise_route = 0,
		response = "ogryn_seen_killstreak_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_psyker"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			},
			{
				"user_memory",
				"ogryn_seen_killstreak_psyker_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "ogryn_seen_killstreak_veteran",
		wwise_route = 0,
		response = "ogryn_seen_killstreak_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_veteran"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "ogryn_seen_killstreak_zealot",
		wwise_route = 0,
		response = "ogryn_seen_killstreak_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_zealot"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "ogryn_start_revive_ogryn",
		category = "player_prio_1",
		wwise_route = 0,
		response = "ogryn_start_revive_ogryn",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "ogryn_start_revive_psyker",
		category = "player_prio_1",
		wwise_route = 0,
		response = "ogryn_start_revive_psyker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "ogryn_start_revive_veteran",
		category = "player_prio_1",
		wwise_route = 0,
		response = "ogryn_start_revive_veteran",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "ogryn_start_revive_zealot",
		category = "player_prio_1",
		wwise_route = 0,
		response = "ogryn_start_revive_zealot",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "pinned_by_enemies",
		category = "player_prio_1",
		wwise_route = 0,
		response = "pinned_by_enemies",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"pinned_by_enemies"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"user_memory",
				"pinned_by_enemies",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"user_memory",
				"pinned_by_enemies",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "plasma_vent_a",
		wwise_route = 0,
		response = "plasma_vent_a",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"reloading"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium"
				}
			},
			{
				"user_context",
				"weapon_type",
				OP.SET_INCLUDES,
				args = {
					"plasmagun_p1_m1"
				}
			},
			{
				"faction_memory",
				"plasma_vent_a",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"faction_memory",
				"plasma_vent_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2.7
			},
			random_ignore_vo = {
				chance = 0.2,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "player_death_ogryn",
		wwise_route = 0,
		response = "player_death_ogryn",
		database = "gameplay_vo",
		category = "player_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"player_death"
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30
			},
			{
				"query_context",
				"died_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"current_mission",
				OP.NEQ,
				"prologue"
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_player_death",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "player_death_psyker",
		wwise_route = 0,
		response = "player_death_psyker",
		database = "gameplay_vo",
		category = "player_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"player_death"
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30
			},
			{
				"query_context",
				"died_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"current_mission",
				OP.NEQ,
				"prologue"
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_player_death",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "player_death_veteran",
		wwise_route = 0,
		response = "player_death_veteran",
		database = "gameplay_vo",
		category = "player_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"player_death"
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30
			},
			{
				"query_context",
				"died_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"current_mission",
				OP.NEQ,
				"prologue"
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_player_death",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "player_death_zealot",
		wwise_route = 0,
		response = "player_death_zealot",
		database = "gameplay_vo",
		category = "player_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"player_death"
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30
			},
			{
				"query_context",
				"died_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"current_mission",
				OP.NEQ,
				"prologue"
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_player_death",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "player_tip_armor_hit_generic",
		category = "player_prio_1",
		wwise_route = 0,
		response = "player_tip_armor_hit_generic",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"player_tip_armor_hit"
			},
			{
				"query_context",
				"player_class",
				OP.SET_INCLUDES,
				args = {
					"ogryn",
					"psyker",
					"veteran",
					"zealot"
				}
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GT,
				0
			},
			{
				"faction_memory",
				"last_armor_hit_tip",
				OP.TIMEDIFF,
				OP.GT,
				90
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_armor_hit_tip",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3
			}
		}
	})
	define_rule({
		name = "psyker_seen_killstreak_ogryn",
		wwise_route = 0,
		response = "psyker_seen_killstreak_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_ogryn"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_psyker_seen_killstreak_ogryn_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "psyker_seen_killstreak_psyker",
		wwise_route = 0,
		response = "psyker_seen_killstreak_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_psyker"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "psyker_seen_killstreak_veteran",
		wwise_route = 0,
		response = "psyker_seen_killstreak_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_veteran"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "psyker_seen_killstreak_zealot",
		wwise_route = 0,
		response = "psyker_seen_killstreak_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_zealot"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "psyker_start_revive_ogryn",
		category = "player_prio_1",
		wwise_route = 0,
		response = "psyker_start_revive_ogryn",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "psyker_start_revive_psyker",
		category = "player_prio_1",
		wwise_route = 0,
		response = "psyker_start_revive_psyker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "psyker_start_revive_veteran",
		category = "player_prio_1",
		wwise_route = 0,
		response = "psyker_start_revive_veteran",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "psyker_start_revive_zealot",
		category = "player_prio_1",
		wwise_route = 0,
		response = "psyker_start_revive_zealot",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "reload_failed_out_of_ammo",
		category = "player_prio_1",
		wwise_route = 0,
		response = "reload_failed_out_of_ammo",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"reload_failed"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"fail_reason",
				OP.EQ,
				"out_of_ammo"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_memory",
				"reload_failed_out_of_ammo",
				OP.TIMEDIFF,
				OP.GT,
				15
			}
		},
		on_done = {
			{
				"user_memory",
				"reload_failed_out_of_ammo",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "reloading",
		wwise_route = 0,
		response = "reloading",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"reloading"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GT,
				3
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"medium"
				}
			},
			{
				"user_memory",
				"reloading",
				OP.TIMEDIFF,
				OP.GT,
				90
			},
			{
				"faction_memory",
				"last_reloading",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"reloading",
				OP.TIMESET
			},
			{
				"faction_memory",
				"last_reloading",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "reloading_empty",
		wwise_route = 0,
		response = "reloading_empty",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"reloading"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GT,
				2
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_context",
				"total_ammo_percentage",
				OP.LT,
				0.15
			},
			{
				"user_memory",
				"reloading",
				OP.TIMEDIFF,
				OP.GT,
				90
			},
			{
				"faction_memory",
				"last_reloading",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"reloading",
				OP.TIMESET
			},
			{
				"faction_memory",
				"last_reloading",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "response_for_calling_for_help",
		wwise_route = 0,
		response = "response_for_calling_for_help",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				10
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"calling_for_help"
				}
			},
			{
				"user_memory",
				"calling_for_help_response",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"user_memory",
				"calling_for_help_response",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_cover_me",
		wwise_route = 0,
		response = "response_for_cover_me",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cover_me_disabled_in_favor_of_class_specific"
				}
			},
			{
				"user_memory",
				"response_for_cover_me",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_cover_me",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_critical_health",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_critical_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				10
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"critical_health"
				}
			},
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMEDIFF,
				OP.GT,
				180
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.LT,
				180
			}
		},
		on_done = {
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_enemy_kill_monster",
		wwise_route = 0,
		response = "response_for_enemy_kill_monster",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_kill_monster_disabled"
				}
			},
			{
				"user_memory",
				"response_for_enemy_kill_monster",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_enemy_kill_monster",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_ogryn_to_ogryn",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_ogryn_to_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_ogryn_to_ogryn"
				}
			},
			{
				"user_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_ogryn_to_psyker",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_ogryn_to_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_ogryn_to_psyker"
				}
			},
			{
				"user_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_ogryn_to_veteran",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_ogryn_to_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_ogryn_to_veteran"
				}
			},
			{
				"user_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_ogryn_to_zealot",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_ogryn_to_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_ogryn_to_zealot"
				}
			},
			{
				"user_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_psyker_to_ogryn",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_psyker_to_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_psyker_to_ogryn"
				}
			},
			{
				"user_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			},
			{
				"user_memory",
				"time_since_friendly_fire_ps_og",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_psyker_to_psyker",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_psyker_to_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_psyker_to_psyker"
				}
			},
			{
				"user_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_psyker_to_veteran",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_psyker_to_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_psyker_to_veteran"
				}
			},
			{
				"user_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_psyker_to_zealot",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_psyker_to_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_psyker_to_zealot"
				}
			},
			{
				"user_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_veteran_to_ogryn",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_veteran_to_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_veteran_to_ogryn"
				}
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			},
			{
				"user_memory",
				"time_since_friendly_fire_vt_og",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_veteran_to_psyker",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_veteran_to_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_veteran_to_psyker"
				}
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_shot_psyker_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_veteran_to_veteran",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_veteran_to_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_veteran_to_veteran"
				}
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_veteran_to_zealot",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_veteran_to_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_veteran_to_zealot"
				}
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_zealot_to_ogryn",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_zealot_to_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_zealot_to_ogryn"
				}
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_zealot_to_psyker",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_zealot_to_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_zealot_to_psyker"
				}
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_zealot_to_veteran",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_zealot_to_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_zealot_to_veteran"
				}
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_friendly_fire_from_zealot_to_zealot",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_friendly_fire_from_zealot_to_zealot",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"friendly_fire_from_zealot_to_zealot"
				}
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				"60"
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_shot_friend",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_friendly_fire",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_heard_horde_vector",
		wwise_route = 0,
		response = "response_for_heard_horde_vector",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"heard_horde_vector"
				}
			},
			{
				"user_memory",
				"response_for_heard_horde_vector",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_heard_horde_vector",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		},
		on_post_rule_execution = {
			reject_events = {
				duration = 3
			}
		}
	})
	define_rule({
		name = "response_for_info_incoming_enemies",
		category = "player_prio_0",
		wwise_route = 0,
		response = "response_for_info_incoming_enemies",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"info_incoming_enemies"
				}
			},
			{
				"user_memory",
				"response_for_info_incoming_enemies",
				OP.TIMEDIFF,
				OP.GT,
				180
			}
		},
		on_done = {
			{
				"user_memory",
				"response_for_info_incoming_enemies",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_cover_me",
		wwise_route = 0,
		response = "response_for_ogryn_cover_me",
		database = "gameplay_vo",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cover_me"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"faction_memory",
				"response_for_ogryn_cover_me",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_ogryn_cover_me",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_critical_health",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_ogryn_critical_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				10
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"critical_health"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.LT,
				180
			}
		},
		on_done = {
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMESET
			},
			{
				"user_memory",
				"rapid_loosing_health_response_ogryn",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_disabled_by_chaos_hound",
		wwise_route = 0,
		response = "response_for_ogryn_disabled_by_chaos_hound",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"disabled_by_chaos_hound"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"faction_memory",
				"response_for_ogryn_disabled_by_chaos_hound",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_ogryn_disabled_by_chaos_hound",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_disabled_by_enemy",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_ogryn_disabled_by_enemy",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				10
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"disabled_by_enemy"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			}
		},
		on_done = {}
	})
	define_rule({
		name = "response_for_ogryn_enemy_kill_monster",
		wwise_route = 0,
		response = "response_for_ogryn_enemy_kill_monster",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_kill_monster"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"faction_memory",
				"",
				OP.TIMEDIFF,
				OP.GT,
				240
			}
		},
		on_done = {
			{
				"faction_memory",
				"",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_knocked_down_3",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_ogryn_knocked_down_3",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"knocked_down_3"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"faction_memory",
				"response_for_ogryn_knocked_down_3",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_ogryn_knocked_down_3",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_ledge_hanging",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_ogryn_ledge_hanging",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ledge_hanging"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"faction_memory",
				"response_for_ogryn_ledge_hanging",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_ogryn_ledge_hanging",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_seen_killstreak_ogryn",
		wwise_route = 0,
		response = "response_for_ogryn_seen_killstreak_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn_seen_killstreak_ogryn"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_seen_killstreak_psyker",
		wwise_route = 0,
		response = "response_for_ogryn_seen_killstreak_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn_seen_killstreak_psyker"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_seen_killstreak_veteran",
		wwise_route = 0,
		response = "response_for_ogryn_seen_killstreak_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn_seen_killstreak_veteran"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_seen_killstreak_zealot",
		wwise_route = 0,
		response = "response_for_ogryn_seen_killstreak_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn_seen_killstreak_zealot"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_start_revive_ogryn",
		wwise_route = 0,
		response = "response_for_ogryn_start_revive_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn_start_revive_ogryn"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_start_revive_psyker",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_ogryn_start_revive_psyker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn_start_revive_psyker"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_start_revive_veteran",
		wwise_route = 0,
		response = "response_for_ogryn_start_revive_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn_start_revive_veteran"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_ogryn_start_revive_zealot",
		wwise_route = 0,
		response = "response_for_ogryn_start_revive_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn_start_revive_zealot"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_pinned_by_enemies_ogryn",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_pinned_by_enemies_ogryn",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"pinned_by_enemies"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"ogryn"
			},
			{
				"faction_memory",
				"response_for_pinned_by_enemies_ogryn",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_pinned_by_enemies_ogryn",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_pinned_by_enemies_psyker",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_pinned_by_enemies_psyker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"pinned_by_enemies"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"faction_memory",
				"response_for_pinned_by_enemies_psyker",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_pinned_by_enemies_psyker",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_pinned_by_enemies_veteran",
		wwise_route = 0,
		response = "response_for_pinned_by_enemies_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"pinned_by_enemies"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"faction_memory",
				"response_for_pinned_by_enemies_veteran",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_pinned_by_enemies_veteran",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_pinned_by_enemies_zealot",
		wwise_route = 0,
		response = "response_for_pinned_by_enemies_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"pinned_by_enemies"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"faction_memory",
				"response_for_pinned_by_enemies_zealot",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_pinned_by_enemies_zealot",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_cover_me",
		wwise_route = 0,
		response = "response_for_psyker_cover_me",
		database = "gameplay_vo",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cover_me"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"faction_memory",
				"response_for_psyker_cover_me",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_psyker_cover_me",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_critical_health",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_psyker_critical_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				10
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"critical_health"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.LT,
				180
			}
		},
		on_done = {
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMESET
			},
			{
				"user_memory",
				"rapid_loosing_health_response_psyker",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_disabled_by_chaos_hound",
		wwise_route = 0,
		response = "response_for_psyker_disabled_by_chaos_hound",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"disabled_by_chaos_hound"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"faction_memory",
				"response_for_psyker_disabled_by_chaos_hound",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_psyker_disabled_by_chaos_hound",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_disabled_by_enemy",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_psyker_disabled_by_enemy",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				10
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"disabled_by_enemy"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			}
		},
		on_done = {}
	})
	define_rule({
		name = "response_for_psyker_enemy_kill_monster",
		wwise_route = 0,
		response = "response_for_psyker_enemy_kill_monster",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_kill_monster"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"faction_memory",
				"response_for_psyker_enemy_kill_monster",
				OP.TIMEDIFF,
				OP.GT,
				240
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_psyker_enemy_kill_monster",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_knocked_down_3",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_psyker_knocked_down_3",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"knocked_down_3"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"faction_memory",
				"response_for_psyker_knocked_down_3",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_psyker_knocked_down_3",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_ledge_hanging",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_psyker_ledge_hanging",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ledge_hanging"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"faction_memory",
				"response_for_psyker_ledge_hanging",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_psyker_ledge_hanging",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_seen_killstreak_ogryn",
		wwise_route = 0,
		response = "response_for_psyker_seen_killstreak_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_seen_killstreak_ogryn"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_seen_killstreak_psyker",
		wwise_route = 0,
		response = "response_for_psyker_seen_killstreak_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_seen_killstreak_psyker"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_seen_killstreak_veteran",
		wwise_route = 0,
		response = "response_for_psyker_seen_killstreak_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_seen_killstreak_veteran"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_seen_killstreak_zealot",
		wwise_route = 0,
		response = "response_for_psyker_seen_killstreak_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_seen_killstreak_zealot"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_start_revive_ogryn",
		wwise_route = 0,
		response = "response_for_psyker_start_revive_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_start_revive_ogryn"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_revived_by_psyker",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_start_revive_psyker",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_psyker_start_revive_psyker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_start_revive_psyker"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_start_revive_veteran",
		wwise_route = 0,
		response = "response_for_psyker_start_revive_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_start_revive_veteran"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_psyker_start_revive_zealot",
		wwise_route = 0,
		response = "response_for_psyker_start_revive_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"psyker_start_revive_zealot"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_cover_me",
		wwise_route = 0,
		response = "response_for_veteran_cover_me",
		database = "gameplay_vo",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cover_me"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"faction_memory",
				"response_for_veteran_cover_me",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_veteran_cover_me",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_critical_health",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_veteran_critical_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				10
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"critical_health"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.LT,
				180
			}
		},
		on_done = {
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_disabled_by_chaos_hound",
		wwise_route = 0,
		response = "response_for_veteran_disabled_by_chaos_hound",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"disabled_by_chaos_hound"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"faction_memory",
				"response_for_veteran_disabled_by_chaos_hound",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_veteran_disabled_by_chaos_hound",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_disabled_by_enemy",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_veteran_disabled_by_enemy",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				10
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"disabled_by_enemy"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			}
		},
		on_done = {}
	})
	define_rule({
		name = "response_for_veteran_enemy_kill_monster",
		wwise_route = 0,
		response = "response_for_veteran_enemy_kill_monster",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_kill_monster"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"faction_memory",
				"response_for_veteran_enemy_kill_monster",
				OP.TIMEDIFF,
				OP.GT,
				240
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_veteran_enemy_kill_monster",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_knocked_down_3",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_veteran_knocked_down_3",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"knocked_down_3"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"faction_memory",
				"response_for_veteran_knocked_down_3",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_veteran_knocked_down_3",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_ledge_hanging",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_veteran_ledge_hanging",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ledge_hanging"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"faction_memory",
				"response_for_veteran_ledge_hanging",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_veteran_ledge_hanging",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_seen_killstreak_ogryn",
		wwise_route = 0,
		response = "response_for_veteran_seen_killstreak_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"veteran_seen_killstreak_ogryn"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_seen_killstreak_psyker",
		wwise_route = 0,
		response = "response_for_veteran_seen_killstreak_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"veteran_seen_killstreak_psyker"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_seen_killstreak_veteran",
		wwise_route = 0,
		response = "response_for_veteran_seen_killstreak_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"veteran_seen_killstreak_veteran"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_seen_killstreak_zealot",
		wwise_route = 0,
		response = "response_for_veteran_seen_killstreak_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"veteran_seen_killstreak_zealot"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_start_revive_ogryn",
		wwise_route = 0,
		response = "response_for_veteran_start_revive_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"veteran_start_revive_ogryn"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_start_revive_psyker",
		wwise_route = 0,
		response = "response_for_veteran_start_revive_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"veteran_start_revive_psyker"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_start_revive_veteran",
		wwise_route = 0,
		response = "response_for_veteran_start_revive_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"veteran_start_revive_veteran"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_veteran_start_revive_zealot",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_veteran_start_revive_zealot",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"veteran_start_revive_zealot"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_cover_me",
		wwise_route = 0,
		response = "response_for_zealot_cover_me",
		database = "gameplay_vo",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"cover_me"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"faction_memory",
				"response_for_zealot_cover_me",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_zealot_cover_me",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_critical_health",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_zealot_critical_health",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				10
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"critical_health"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.LT,
				180
			}
		},
		on_done = {
			{
				"user_memory",
				"rapid_loosing_health_response",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_disabled_by_chaos_hound",
		wwise_route = 0,
		response = "response_for_zealot_disabled_by_chaos_hound",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				30
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"disabled_by_chaos_hound"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"faction_memory",
				"response_for_zealot_disabled_by_chaos_hound",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_zealot_disabled_by_chaos_hound",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_disabled_by_enemy",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_zealot_disabled_by_enemy",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				10
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"disabled_by_enemy"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			}
		},
		on_done = {}
	})
	define_rule({
		name = "response_for_zealot_enemy_kill_monster",
		wwise_route = 0,
		response = "response_for_zealot_enemy_kill_monster",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"enemy_kill_monster"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"faction_memory",
				"response_for_zealot_enemy_kill_monster",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_zealot_enemy_kill_monster",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_knocked_down_3",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_zealot_knocked_down_3",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"knocked_down_3"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"faction_memory",
				"response_for_zealot_knocked_down_3",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_zealot_knocked_down_3",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_ledge_hanging",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_zealot_ledge_hanging",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ledge_hanging"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"faction_memory",
				"response_for_zealot_ledge_hanging",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"response_for_zealot_ledge_hanging",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_seen_killstreak_ogryn",
		wwise_route = 0,
		response = "response_for_zealot_seen_killstreak_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"zealot_seen_killstreak_ogryn"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_seen_killstreak_psyker",
		wwise_route = 0,
		response = "response_for_zealot_seen_killstreak_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"zealot_seen_killstreak_psyker"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_seen_killstreak_veteran",
		wwise_route = 0,
		response = "response_for_zealot_seen_killstreak_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"zealot_seen_killstreak_veteran"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_seen_killstreak_zealot",
		wwise_route = 0,
		response = "response_for_zealot_seen_killstreak_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"zealot_seen_killstreak_zealot"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_killstreak",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_start_revive_ogryn",
		wwise_route = 0,
		response = "response_for_zealot_start_revive_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"zealot_start_revive_ogryn"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"ogryn"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_start_revive_psyker",
		wwise_route = 0,
		response = "response_for_zealot_start_revive_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"zealot_start_revive_psyker"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"psyker"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_start_revive_veteran",
		category = "player_prio_1",
		wwise_route = 0,
		response = "response_for_zealot_start_revive_veteran",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"zealot_start_revive_veteran"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "response_for_zealot_start_revive_zealot",
		wwise_route = 0,
		response = "response_for_zealot_start_revive_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LTEQ,
				7
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"zealot_start_revive_zealot"
				}
			},
			{
				"query_context",
				"speaker_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"user_memory",
				"last_revivee",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_revivee",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "seen_barrel_exploded_a",
		wwise_route = 0,
		response = "seen_barrel_exploded_a",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"seen_barrel_exploded_a"
			},
			{
				"user_context",
				"friends_close",
				OP.GTEQ,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				10
			},
			{
				"user_memory",
				"seen_barrel_exploded_a",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"user_memory",
				"seen_barrel_exploded_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.3,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "seen_enemy_beast_of_nurgle",
		category = "enemy_alerts_prio_0",
		wwise_route = 0,
		response = "seen_enemy_beast_of_nurgle",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_beast_of_nurgle"
			},
			{
				"faction_memory",
				"enemy_chaos_beast_of_nurgle",
				OP.TIMEDIFF,
				OP.GT,
				480
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_chaos_beast_of_nurgle",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_berserker",
		wwise_route = 0,
		response = "seen_enemy_berserker",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_berzerker"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_berserker",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_berserker",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_bulwark_custom",
		wwise_route = 0,
		response = "seen_enemy_bulwark_custom",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_bulwark"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_chaos_ogryn_bulwark",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_chaos_ogryn_bulwark",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_cultist_grenadier",
		wwise_route = 0,
		response = "seen_enemy_cultist_grenadier",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_grenadier"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_grenadier",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_grenadier",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_cultist_heavy_gunner",
		wwise_route = 0,
		response = "seen_enemy_cultist_heavy_gunner",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_gunner"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_cultist_gunner",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_cultist_gunner",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_cultist_shocktrooper",
		wwise_route = 0,
		response = "seen_enemy_cultist_shocktrooper",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_shocktrooper"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_cultist_shocktrooper",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_cultist_shocktrooper",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_daemonhost",
		wwise_route = 0,
		response = "seen_enemy_daemonhost",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost"
			},
			{
				"faction_memory",
				"enemy_chaos_daemonhost",
				OP.TIMEDIFF,
				OP.GT,
				480
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_chaos_daemonhost",
				OP.TIMESET
			},
			{
				"faction_memory",
				"lore_daemons_one_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_executor",
		wwise_route = 0,
		response = "seen_enemy_executor",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_executor"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_renegade_executor",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_renegade_executor",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_grenadier",
		wwise_route = 0,
		response = "seen_enemy_grenadier",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_grenadier"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_grenadier",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_grenadier",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_group_assaulting",
		category = "player_prio_1",
		wwise_route = 0,
		response = "seen_enemy_group_assaulting",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				5
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"chaos_newly_infected_assault",
					"traitor_trenchfighter_assault",
					"cultist_melee_fighter_assault"
				}
			},
			{
				"faction_memory",
				"assault",
				OP.TIMEDIFF,
				OP.GT,
				180
			},
			{
				"user_memory",
				"assault_user",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"faction_memory",
				"assault",
				OP.TIMESET
			},
			{
				"user_memory",
				"assault_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "seen_enemy_group_far_range_shooting_behind_cover",
		category = "player_prio_0",
		wwise_route = 0,
		response = "seen_enemy_group_far_range_shooting_behind_cover",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy_group_far_range_shooting_behind_cover"
			},
			{
				"user_context",
				"pacing_state",
				OP.SET_INCLUDES,
				args = {
					"sustain_tension_peak",
					"build_up_tension_no_trickle",
					"build_up_tension"
				}
			},
			{
				"faction_memory",
				"seen_enemy_group_far_range_shooting_behind_cover",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"seen_enemy_group_far_range_shooting_behind_cover",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "seen_enemy_mutant_charger",
		wwise_route = 0,
		response = "seen_enemy_mutant_charger",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_mutant"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_cultist_mutant",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_cultist_mutant",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_netgunner",
		wwise_route = 0,
		response = "seen_enemy_netgunner",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_netgunner"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_renegade_netgunner",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_renegade_netgunner",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_ogryn_heavy_gunner",
		wwise_route = 0,
		response = "seen_enemy_ogryn_heavy_gunner",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_gunner"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_chaos_ogryn_gunner",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_chaos_ogryn_gunner",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_poxwalker_bomber",
		wwise_route = 0,
		response = "seen_enemy_poxwalker_bomber",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_poxwalker_bomber"
			},
			{
				"query_context",
				"enemies_close",
				OP.LTEQ,
				50
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_chaos_poxwalker_bomber",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_chaos_poxwalker_bomber",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_renegade_berserker",
		wwise_route = 0,
		response = "seen_enemy_renegade_berserker",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_berzerker"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_berserker",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_berserker",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_renegade_shocktrooper",
		wwise_route = 0,
		response = "seen_enemy_renegade_shocktrooper",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_renegade_shocktrooper",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_renegade_shocktrooper",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_scab_flamer",
		wwise_route = 0,
		response = "seen_enemy_scab_flamer",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_flamer"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_renegade_flamer",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_renegade_flamer",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_sniper",
		wwise_route = 0,
		response = "seen_enemy_sniper",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"player_enemy_alert"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_sniper"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"sniper_aiming"
			},
			{
				"faction_memory",
				"enemy_renegade_sniper",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_renegade_sniper",
				OP.TIMESET
			},
			{
				"faction_memory",
				"snipers_spotted",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1
			}
		}
	})
	define_rule({
		name = "seen_enemy_tox_flamer",
		wwise_route = 0,
		response = "seen_enemy_tox_flamer",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_flamer"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_cultist_flamer",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_cultist_flamer",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_enemy_traitor_heavy_gunner",
		wwise_route = 0,
		response = "seen_enemy_traitor_heavy_gunner",
		database = "gameplay_vo",
		category = "enemy_alerts_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_enemy"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_gunner"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"faction_memory",
				"enemy_renegade_gunner",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"enemy_renegade_gunner",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "seen_horde_static",
		category = "enemy_alerts_prio_0",
		wwise_route = 0,
		response = "seen_horde_static",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_horde"
			},
			{
				"query_context",
				"horde_type",
				OP.EQ,
				"static"
			},
			{
				"faction_memory",
				"last_seen_horde",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_horde",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "seen_kill_streak_prayer_c",
		wwise_route = 0,
		response = "seen_kill_streak_prayer_c",
		database = "gameplay_vo",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"response_for_ogryn_seen_killstreak_ogryn",
					"response_for_ogryn_seen_killstreak_psyker",
					"response_for_ogryn_seen_killstreak_veteran",
					"response_for_ogryn_seen_killstreak_zealot",
					"response_for_psyker_seen_killstreak_ogryn",
					"response_for_psyker_seen_killstreak_psyker",
					"response_for_psyker_seen_killstreak_veteran",
					"response_for_psyker_seen_killstreak_zealot",
					"response_for_veteran_seen_killstreak_ogryn",
					"response_for_veteran_seen_killstreak_psyker",
					"response_for_veteran_seen_killstreak_veteran",
					"response_for_veteran_seen_killstreak_zealot",
					"response_for_zealot_seen_killstreak_ogryn",
					"response_for_zealot_seen_killstreak_psyker",
					"response_for_zealot_seen_killstreak_veteran",
					"response_for_zealot_seen_killstreak_zealot"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"seen_kill_streak_prayer_c",
				OP.TIMEDIFF,
				OP.GT,
				300
			}
		},
		on_done = {
			{
				"user_memory",
				"seen_kill_streak_prayer_c",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			},
			random_ignore_vo = {
				chance = 0.15,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "seen_psychic_power_ultimate_a",
		wwise_route = 0,
		response = "seen_psychic_power_ultimate_a",
		database = "gameplay_vo",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"ability_biomancer_high"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c"
				}
			},
			{
				"user_memory",
				"seen_psychic_power_ultimate_a",
				OP.TIMEDIFF,
				OP.GT,
				420
			}
		},
		on_done = {
			{
				"user_memory",
				"seen_psychic_power_ultimate_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			},
			random_ignore_vo = {
				chance = 0.15,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "surrounded",
		wwise_route = 0,
		response = "surrounded",
		database = "gameplay_vo",
		category = "player_prio_1",
		speaker_routing = {
			target = "all"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_mission_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"surrounded"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GT,
				15
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"medium"
				}
			},
			{
				"faction_memory",
				"last_surrounded_vo",
				OP.TIMEDIFF,
				OP.GT,
				240
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_surrounded_vo",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "surrounded_response",
		wwise_route = 0,
		response = "surrounded_response",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.GTEQ,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"surrounded"
				}
			},
			{
				"user_memory",
				"surrounded_response",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"surrounded_response",
				OP.TIMESET,
				"30"
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "throwing_grenade",
		category = "player_prio_1",
		wwise_route = 0,
		response = "throwing_grenade",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"throwing_item"
			},
			{
				"query_context",
				"item",
				OP.SET_INCLUDES,
				args = {
					"frag_grenade",
					"ogryn_grenade_frag",
					"shock_grenade"
				}
			},
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_throw_item",
				OP.TIMESET
			},
			{
				"faction_memory",
				"thrown_grenades",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "twin_laugh_a_response",
		wwise_route = 0,
		response = "twin_laugh_a_response",
		database = "gameplay_vo",
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"twin_spawn_laugh_a"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "veteran_seen_killstreak_ogryn",
		wwise_route = 0,
		response = "veteran_seen_killstreak_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_ogryn"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "veteran_seen_killstreak_psyker",
		wwise_route = 0,
		response = "veteran_seen_killstreak_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_psyker"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"time_since_veteran_seen_killstreak_psyker",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "veteran_seen_killstreak_veteran",
		wwise_route = 0,
		response = "veteran_seen_killstreak_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_veteran"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "veteran_seen_killstreak_zealot",
		wwise_route = 0,
		response = "veteran_seen_killstreak_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_zealot"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"veteran"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_veteran_seen_killstreak_zealot_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "veteran_start_revive_ogryn",
		category = "player_prio_1",
		wwise_route = 0,
		response = "veteran_start_revive_ogryn",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "veteran_start_revive_psyker",
		category = "player_prio_1",
		wwise_route = 0,
		response = "veteran_start_revive_psyker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "veteran_start_revive_veteran",
		category = "player_prio_1",
		wwise_route = 0,
		response = "veteran_start_revive_veteran",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "veteran_start_revive_zealot",
		category = "player_prio_1",
		wwise_route = 0,
		response = "veteran_start_revive_zealot",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "warning_exploding_barrel",
		category = "player_prio_0",
		wwise_route = 0,
		response = "warning_exploding_barrel",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"warning"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"exploding_barrel"
			},
			{
				"user_memory",
				"exploding_barrel",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"exploding_barrel",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "zealot_seen_killstreak_ogryn",
		wwise_route = 0,
		response = "zealot_seen_killstreak_ogryn",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_ogryn"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"ogryn"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			},
			{
				"user_memory",
				"time_since_zealot_seen_killstreak_ogryn",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "zealot_seen_killstreak_psyker",
		wwise_route = 0,
		response = "zealot_seen_killstreak_psyker",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_psyker"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"psyker"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			},
			{
				"user_memory",
				"time_since_zealot_seen_killstreak_psyker",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "zealot_seen_killstreak_veteran",
		wwise_route = 0,
		response = "zealot_seen_killstreak_veteran",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_veteran"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"veteran"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_zealot_seen_killstreak_veteran_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "zealot_seen_killstreak_zealot",
		wwise_route = 0,
		response = "zealot_seen_killstreak_zealot",
		database = "gameplay_vo",
		category = "player_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"seen_killstreak_zealot"
			},
			{
				"query_context",
				"killer_class",
				OP.EQ,
				"zealot"
			},
			{
				"query_context",
				"number_of_kills",
				OP.GTEQ,
				15
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"zealot"
			},
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMEDIFF,
				OP.GT,
				25
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_killstreak",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				max_failed_tries = 4,
				hold_for = 2
			}
		}
	})
	define_rule({
		name = "zealot_start_revive_ogryn",
		category = "player_prio_1",
		wwise_route = 0,
		response = "zealot_start_revive_ogryn",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"ogryn"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "zealot_start_revive_psyker",
		category = "player_prio_1",
		wwise_route = 0,
		response = "zealot_start_revive_psyker",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"psyker"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "zealot_start_revive_veteran",
		category = "player_prio_1",
		wwise_route = 0,
		response = "zealot_start_revive_veteran",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"veteran"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "zealot_start_revive_zealot",
		category = "player_prio_1",
		wwise_route = 0,
		response = "zealot_start_revive_zealot",
		database = "gameplay_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"interaction_vo"
			},
			{
				"user_context",
				"interactor_class",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"user_context",
				"interactee_class",
				OP.SET_INCLUDES,
				args = {
					"zealot"
				}
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_revive"
			},
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_revived_friendly",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
end
