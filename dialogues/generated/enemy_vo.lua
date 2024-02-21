return function ()
	define_rule({
		name = "chaos_daemonhost_aggro",
		category = "enemy_vo_prio_0",
		wwise_route = 15,
		response = "chaos_daemonhost_aggro",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"chaos_daemonhost_aggro"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost"
			},
			{
				"user_memory",
				"enemy_memory_chaos_daemonhost_aggro",
				OP.TIMEDIFF,
				OP.GT,
				0
			},
			{
				"faction_memory",
				"faction_memory_chaos_daemonhost_aggro",
				OP.TIMEDIFF,
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_chaos_daemonhost_aggro",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_chaos_daemonhost_aggro",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "chaos_daemonhost_death_long",
		category = "enemy_vo_prio_0",
		wwise_route = 15,
		response = "chaos_daemonhost_death_long",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"chaos_daemonhost_death_long"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost"
			},
			{
				"user_memory",
				"enemy_memory_daemonhost_death_long",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_daemonhost_death_long",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_daemonhost_death_long",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_daemonhost_death_long",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "chaos_daemonhost_mantra_high",
		category = "enemy_vo_prio_0",
		wwise_route = 15,
		response = "chaos_daemonhost_mantra_high",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"chaos_daemonhost_mantra_high"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost"
			},
			{
				"user_memory",
				"enemy_memory_daemonhost_mantra_high",
				OP.TIMEDIFF,
				OP.GT,
				1
			},
			{
				"faction_memory",
				"faction_memory_daemonhost_mantra_high",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_daemonhost_mantra_high",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_daemonhost_mantra_high",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "chaos_daemonhost_mantra_low",
		category = "enemy_vo_prio_0",
		wwise_route = 15,
		response = "chaos_daemonhost_mantra_low",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"chaos_daemonhost_mantra_low"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost"
			},
			{
				"user_memory",
				"enemy_memory_daemonhost_mantra_low",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_daemonhost_mantra_low",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "chaos_daemonhost_mantra_medium",
		category = "enemy_vo_prio_0",
		wwise_route = 15,
		response = "chaos_daemonhost_mantra_medium",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"chaos_daemonhost_mantra_medium"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost"
			},
			{
				"user_memory",
				"enemy_memory_daemonhost_mantra_medium",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_daemonhost_mantra_medium",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "chaos_daemonhost_warp_grab",
		category = "enemy_vo_prio_0",
		wwise_route = 32,
		response = "chaos_daemonhost_warp_grab",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"chaos_daemonhost_warp_grab"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost"
			},
			{
				"user_memory",
				"enemy_memory_daemonhost_warp_grab",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_daemonhost_warp_grab",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_daemonhost_warp_grab",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_daemonhost_warp_grab",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "chaos_newly_infected_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 20,
		response = "chaos_newly_infected_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_newly_infected"
			},
			{
				"user_memory",
				"enemy_memory_ni_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_ni_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_ni_alerted_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_ni_alerted_idle",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "chaos_newly_infected_assault",
		category = "enemy_vo_prio_1",
		wwise_route = 43,
		response = "chaos_newly_infected_assault",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"assault"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_newly_infected"
			},
			{
				"user_memory",
				"enemy_memory_ni_assault",
				OP.TIMEDIFF,
				OP.GT,
				8
			},
			{
				"faction_memory",
				"faction_memory_ni_assault",
				OP.TIMEDIFF,
				OP.GT,
				4
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_ni_assault",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_ni_assault",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "chaos_newly_infected_melee_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 20,
		response = "chaos_newly_infected_melee_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"melee_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_newly_infected"
			},
			{
				"user_memory",
				"enemy_memory_ni_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_ni_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_ni_melee_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_ni_melee_idle",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "chaos_ogryn_bulwark_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 9,
		response = "chaos_ogryn_bulwark_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_bulwark"
			},
			{
				"user_memory",
				"enemy_memory_chaos_ogryn_bulwark_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_chaos_ogryn_bulwark_alerted_idle",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "chaos_ogryn_bulwark_assault",
		category = "enemy_vo_prio_0",
		wwise_route = 9,
		response = "chaos_ogryn_bulwark_assault",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"assault"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_bulwark"
			},
			{
				"user_memory",
				"chaos_ogryn_bulwark_assault",
				OP.TIMEDIFF,
				OP.GT,
				6
			},
			{
				"faction_memory",
				"faction_memory_chaos_ogryn_bulwark_assault",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"chaos_ogryn_bulwark_assault",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_chaos_ogryn_bulwark_assault",
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
		name = "chaos_ogryn_executor_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 6,
		response = "chaos_ogryn_executor_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_executor"
			},
			{
				"user_memory",
				"enemy_memory_chaos_ogryn_executor_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				2
			},
			{
				"faction_memory",
				"",
				OP.TIMEDIFF,
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_chaos_ogryn_executor_alerted_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "chaos_ogryn_executor_assault",
		category = "enemy_vo_prio_0",
		wwise_route = 6,
		response = "chaos_ogryn_executor_assault",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"assault"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_executor"
			},
			{
				"user_memory",
				"chaos_ogryn_executor_assault",
				OP.TIMEDIFF,
				OP.GT,
				7
			},
			{
				"faction_memory",
				"",
				OP.TIMEDIFF,
				OP.GT,
				0
			},
			{
				"faction_memory",
				"faction_chaos_ogryn_executor_assault",
				OP.TIMEDIFF,
				OP.GT,
				6
			}
		},
		on_done = {
			{
				"user_memory",
				"chaos_ogryn_executor_assault",
				OP.TIMESET
			},
			{
				"faction_memory",
				"",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_chaos_ogryn_executor_assault",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "chaos_ogryn_executor_no_damage",
		wwise_route = 6,
		response = "chaos_ogryn_executor_no_damage",
		database = "enemy_vo",
		category = "enemy_vo_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"no_damage_taunt"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_executor"
			},
			{
				"user_memory",
				"enemy_memory_no_damage_taunt",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"faction_memory_no_damage_taunt",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_no_damage_taunt",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_no_damage_taunt",
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
		name = "chaos_ogryn_heavy_gunner_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 8,
		response = "chaos_ogryn_heavy_gunner_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_gunner"
			},
			{
				"user_memory",
				"enemy_memory_ogryn_gunner_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				6
			},
			{
				"faction_memory",
				"faction_memory_ogryn_gunner_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_ogryn_gunner_alerted_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_ogryn_gunner_alerted_idle",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "chaos_ogryn_heavy_gunner_shooting",
		category = "enemy_vo_prio_1",
		wwise_route = 8,
		response = "chaos_ogryn_heavy_gunner_shooting",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_shooting"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_gunner"
			},
			{
				"user_memory",
				"enemy_memory_ogryn_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				3
			},
			{
				"faction_memory",
				"faction_memory_ogryn_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_ogryn_start_shooting",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_ogryn_start_shooting",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "cultist_flamer_spawned",
		category = "enemy_vo_prio_0",
		wwise_route = 23,
		response = "cultist_flamer_spawned",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"spawned"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_flamer"
			},
			{
				"faction_memory",
				"faction_memory_cultist_flamer_spawned",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_cultist_flamer_spawned",
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
		name = "cultist_flamer_start_shooting",
		category = "enemy_vo_prio_0",
		wwise_route = 23,
		response = "cultist_flamer_start_shooting",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_shooting"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_flamer"
			},
			{
				"user_memory",
				"enemy_memory_cf_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				4
			},
			{
				"faction_memory",
				"faction_memory_cf_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cf_start_shooting",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_cf_start_shooting",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.5
			}
		}
	})
	define_rule({
		name = "cultist_grenadier_skulking",
		category = "enemy_vo_prio_0",
		wwise_route = 25,
		response = "cultist_grenadier_skulking",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"skulking"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_grenadier"
			},
			{
				"user_memory",
				"enemy_memory_cultist_grenadier_skulking",
				OP.TIMEDIFF,
				OP.GT,
				15
			},
			{
				"faction_memory",
				"faction_enemy_memory_cultist_grenadier_skulking",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_grenadier_skulking",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_enemy_memory_cultist_grenadier_skulking",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "cultist_grenadier_spawned",
		category = "enemy_vo_prio_0",
		wwise_route = 25,
		response = "cultist_grenadier_spawned",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"spawned"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_grenadier"
			},
			{
				"faction_memory",
				"faction_memory_cultist_grenadier_spawned",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_cultist_grenadier_spawned",
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
		name = "cultist_grenadier_throwing_grenade",
		category = "enemy_vo_prio_1",
		wwise_route = 25,
		response = "cultist_grenadier_throwing_grenade",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"throwing_grenade"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_grenadier"
			},
			{
				"user_memory",
				"cultist_grenadier_throwing_grenade",
				OP.TIMEDIFF,
				OP.GT,
				9
			}
		},
		on_done = {
			{
				"user_memory",
				"cultist_grenadier_throwing_grenade",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "cultist_gunner_friendly_fire",
		category = "enemy_vo_prio_1",
		wwise_route = 26,
		response = "cultist_gunner_friendly_fire",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"friendly_fire"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_gunner"
			},
			{
				"user_memory",
				"enemy_memory_cultist_gunner_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				15
			},
			{
				"faction_memory",
				"faction_memory_cultist_gunner_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_gunner_friendly_fire",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_cultist_gunner_friendly_fire",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "cultist_gunner_reloading",
		category = "enemy_vo_prio_1",
		wwise_route = 26,
		response = "cultist_gunner_reloading",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"reloading"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_gunner"
			},
			{
				"user_memory",
				"enemy_memory_cultist_gunner_reloading",
				OP.TIMEDIFF,
				OP.GT,
				3
			},
			{
				"faction_memory",
				"faction_memory_cultist_gunner_reloading",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_gunner_reloading",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_cultist_gunner_reloading",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "cultist_gunner_start_shooting",
		category = "enemy_vo_prio_1",
		wwise_route = 26,
		response = "cultist_gunner_start_shooting",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_shooting"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_gunner"
			},
			{
				"user_memory",
				"memory_cultist_gunner_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				3
			},
			{
				"faction_memory",
				"faction_memory_cultist_gunner_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"memory_cultist_gunner_start_shooting",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_cultist_gunner_start_shooting",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "cultist_melee_fighter_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 34,
		response = "cultist_melee_fighter_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_melee"
			},
			{
				"user_memory",
				"cultist_melee_fighter_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_cultist_melee_fighter_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"cultist_melee_fighter_alerted_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_cultist_melee_fighter_alerted_idle",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "cultist_melee_fighter_assault",
		category = "enemy_vo_prio_1",
		wwise_route = 34,
		response = "cultist_melee_fighter_assault",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"assault"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_melee"
			},
			{
				"user_memory",
				"cultist_melee_fighter_assault",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_cultist_melee_fighter_assault",
				OP.TIMEDIFF,
				OP.GT,
				4
			}
		},
		on_done = {
			{
				"user_memory",
				"cultist_melee_fighter_assault",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_cultist_melee_fighter_assault",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "cultist_melee_fighter_long_death",
		category = "enemy_vo_prio_1",
		wwise_route = 34,
		response = "cultist_melee_fighter_long_death",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"long_death"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_melee"
			},
			{
				"user_memory",
				"enemy_memory_long_death",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"faction_memory_long_death",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_long_death",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_long_death",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "cultist_melee_fighter_melee_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 34,
		response = "cultist_melee_fighter_melee_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"melee_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_melee"
			},
			{
				"user_memory",
				"cultist_melee_fighter_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"faction_memory_cultist_melee_fighter_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"cultist_melee_fighter_melee_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_cultist_melee_fighter_melee_idle",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "cultist_rusher_switch_to_melee",
		category = "enemy_vo_prio_1",
		wwise_route = 33,
		response = "cultist_rusher_switch_to_melee",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"switch_to_melee"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_assault"
			},
			{
				"user_memory",
				"cultist_rusher_switch_to_melee",
				OP.TIMEDIFF,
				OP.GT,
				8
			},
			{
				"faction_memory",
				"faction_memory_cultist_rusher_switch_to_melee",
				OP.TIMEDIFF,
				OP.GT,
				4
			}
		},
		on_done = {
			{
				"user_memory",
				"cultist_rusher_switch_to_melee",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_cultist_rusher_switch_to_melee",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "cultist_rusher_take_cover",
		wwise_route = 33,
		response = "cultist_rusher_take_cover",
		database = "enemy_vo",
		category = "enemy_vo_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"take_cover"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_assault"
			},
			{
				"user_memory",
				"cultist_assault_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"faction_memory_cultist_assault_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				8
			}
		},
		on_done = {
			{
				"user_memory",
				"cultist_assault_take_cover",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_cultist_assault_take_cover",
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
		name = "cultist_shocktrooper_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 27,
		response = "cultist_shocktrooper_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_shocktrooper"
			},
			{
				"user_memory",
				"enemy_memory_cultist_shocktrooper",
				OP.TIMEDIFF,
				OP.GT,
				6
			},
			{
				"faction_memory",
				"faction_memory_cultist_shocktrooper",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_shocktrooper",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_cultist_shocktrooper",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "cultist_shocktrooper_shooting",
		category = "enemy_vo_prio_1",
		wwise_route = 27,
		response = "cultist_shocktrooper_shooting",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_shooting"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_shocktrooper"
			},
			{
				"user_memory",
				"enemy_memory_cultist_shocktrooper_shooting",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"faction_memory_cultist_shocktrooper_shooting",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_shocktrooper_shooting",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_cultist_shocktrooper_shooting",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "enemy_cultist_berzerker_assault",
		category = "enemy_vo_prio_0",
		wwise_route = 46,
		response = "enemy_cultist_berzerker_assault",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"assault"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_berzerker"
			},
			{
				"user_memory",
				"cultist_berzerker_assault",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"faction_cultist_berzerker_assault",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"user_memory",
				"cultist_berzerker_assault",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_traitor_berzerker_assault",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "enemy_cultist_rusher_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 33,
		response = "enemy_cultist_rusher_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_assault"
			},
			{
				"user_memory",
				"cultist_assault_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_cultist_assault_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"cultist_assault_alerted_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_cultist_assault_alerted_idle",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "enemy_cultist_rusher_assault",
		category = "enemy_vo_prio_1",
		wwise_route = 33,
		response = "enemy_cultist_rusher_assault",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"assault"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_assault"
			},
			{
				"user_memory",
				"cultist_rusher_assault",
				OP.TIMEDIFF,
				OP.GT,
				8
			},
			{
				"faction_memory",
				"faction_memory_rusher_assault",
				OP.TIMEDIFF,
				OP.GT,
				4
			}
		},
		on_done = {
			{
				"user_memory",
				"cultist_rusher_assault",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_rusher_assault",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "ranged_idle_player_low_on_health",
		category = "enemy_vo_prio_1",
		wwise_route = 2,
		response = "ranged_idle_player_low_on_health",
		database = "enemy_vo",
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
					"response_for_ogryn_critical_health",
					"response_for_psyker_critical_health",
					"response_for_veteran_critical_health",
					"response_for_zealot_critical_health"
				}
			},
			{
				"user_memory",
				"ranged_idle_player_low_on_health",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"ranged_idle_player_low_on_health",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "ranged_idle_player_out_of_ammo",
		category = "enemy_vo_prio_1",
		wwise_route = 2,
		response = "ranged_idle_player_out_of_ammo",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"ranged_idle_player_out_of_ammo"
			},
			{
				"user_memory",
				"ranged_idle_player_out_of_ammo",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"ranged_idle_player_out_of_ammo",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "renegade_captain_long_death",
		category = "enemy_vo_prio_0",
		wwise_route = 7,
		response = "renegade_captain_long_death",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"long_death"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_captain"
			},
			{
				"user_memory",
				"enemy_memory_renegade_captain_long_death",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_renegade_captain_long_death",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "renegade_captain_reinforcements",
		category = "enemy_vo_prio_0",
		wwise_route = 7,
		response = "renegade_captain_reinforcements",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"reinforcements"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_captain"
			},
			{
				"user_memory",
				"enemy_memory_renegade_captain_reinforcements",
				OP.TIMEDIFF,
				OP.GT,
				25
			},
			{
				"user_memory",
				"enemy_memory_renegade_captain_taunt_combat",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_renegade_captain_reinforcements",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "renegade_captain_taunt",
		wwise_route = 39,
		response = "renegade_captain_taunt",
		database = "enemy_vo",
		category = "enemy_vo_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"taunt"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_captain"
			},
			{
				"user_memory",
				"enemy_memory_renegade_captain_taunt",
				OP.GTEQ,
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_renegade_captain_taunt",
				OP.ADD,
				"1"
			}
		},
		heard_speak_routing = {
			target = "mission_giver_default_class"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5
			}
		}
	})
	define_rule({
		name = "renegade_captain_taunt_combat",
		category = "enemy_vo_prio_0",
		wwise_route = 7,
		response = "renegade_captain_taunt_combat",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"taunt_combat"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_captain"
			},
			{
				"user_memory",
				"enemy_memory_renegade_captain_taunt_combat",
				OP.TIMEDIFF,
				OP.GT,
				35
			},
			{
				"user_memory",
				"enemy_memory_renegade_captain_taunt",
				OP.GT,
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_renegade_captain_taunt_combat",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		name = "renegade_grenadier_skulking",
		category = "enemy_vo_prio_0",
		wwise_route = 13,
		response = "renegade_grenadier_skulking",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"skulking"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_grenadier"
			},
			{
				"user_memory",
				"enemy_memory_renegade_grenadier_skulking",
				OP.TIMEDIFF,
				OP.GT,
				15
			},
			{
				"faction_memory",
				"faction_memory_renegade_grenadier_skulking",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_renegade_grenadier_skulking",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_renegade_grenadier_skulking",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_berzerker_assault",
		category = "enemy_vo_prio_0",
		wwise_route = 48,
		response = "traitor_berzerker_assault",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"assault"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_berzerker"
			},
			{
				"user_memory",
				"traitor_berzerker_assault",
				OP.TIMEDIFF,
				OP.GT,
				5
			},
			{
				"faction_memory",
				"faction_traitor_berzerker_assault",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_berzerker_assault",
				OP.TIMESET
			},
			{
				"faction_memory",
				"",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_enforcer_executor_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 10,
		response = "traitor_enforcer_executor_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_executor"
			},
			{
				"user_memory",
				"enemy_memory_traitor_enforcer_executor_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				2
			},
			{
				"faction_memory",
				"",
				OP.TIMEDIFF,
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_traitor_enforcer_executor_alerted_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "traitor_enforcer_executor_executor_assault",
		wwise_route = 10,
		response = "traitor_enforcer_executor_executor_assault",
		database = "enemy_vo",
		category = "enemy_vo_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"assault"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_executor"
			},
			{
				"user_memory",
				"renegade_executor_assault",
				OP.TIMEDIFF,
				OP.GT,
				6
			},
			{
				"faction_memory",
				"faction_memory_renegade_executor_assault",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"renegade_executor_assault",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_renegade_executor_assault",
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
		name = "traitor_enforcer_executor_executor_melee_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 10,
		response = "traitor_enforcer_executor_executor_melee_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"melee_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_executor"
			},
			{
				"user_memory",
				"melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"user_memory",
				"melee_idle",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_enforcer_executor_special_attack",
		wwise_route = 10,
		response = "traitor_enforcer_executor_special_attack",
		database = "enemy_vo",
		category = "enemy_vo_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"special_attack"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_executor"
			},
			{
				"user_memory",
				"special_attack",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"special_attack",
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
		name = "traitor_grenadier_spawned",
		category = "enemy_vo_prio_0",
		wwise_route = 13,
		response = "traitor_grenadier_spawned",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"spawned"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_grenadier"
			},
			{
				"faction_memory",
				"faction_memory_traitor_grenadier_spawned",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_traitor_grenadier_spawned",
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
		name = "traitor_grenadier_throwing_grenade",
		category = "enemy_vo_prio_1",
		wwise_route = 13,
		response = "traitor_grenadier_throwing_grenade",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"throwing_grenade"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_grenadier"
			},
			{
				"user_memory",
				"throwing_grenade",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"throwing_grenade",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_guard_flamer_spawned",
		category = "enemy_vo_prio_0",
		wwise_route = 44,
		response = "traitor_guard_flamer_spawned",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"spawned"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_flamer"
			},
			{
				"faction_memory",
				"faction_memory_traitor_flamer_spawned",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_traitor_flamer_spawned",
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
		name = "traitor_guard_flamer_start_shooting",
		category = "enemy_vo_prio_0",
		wwise_route = 44,
		response = "traitor_guard_flamer_start_shooting",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_shooting"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_flamer"
			},
			{
				"faction_memory",
				"faction_memory_traitor_flamer_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				2
			},
			{
				"user_memory",
				"enemy_memory_traitor_flamer_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				4
			}
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_traitor_flamer_start_shooting",
				OP.TIMESET
			},
			{
				"user_memory",
				"enemy_memory_traitor_flamer_start_shooting",
				OP.TIMESET
			}
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.5
			}
		}
	})
	define_rule({
		name = "traitor_guard_rifleman_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 18,
		response = "traitor_guard_rifleman_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_rifleman"
			},
			{
				"user_memory",
				"traitor_guard_rifleman_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_guard_rifleman_alerted_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_alerted_idle",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "traitor_guard_rifleman_ranged_idle",
		wwise_route = 18,
		response = "traitor_guard_rifleman_ranged_idle",
		database = "enemy_vo",
		category = "enemy_vo_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"ranged_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_rifleman"
			},
			{
				"user_memory",
				"traitor_guard_rifleman_ranged_idle",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_ranged_idle",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_guard_rifleman_ranged_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_ranged_idle",
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
		name = "traitor_guard_rifleman_ranged_idle_player_low_on_ammo",
		category = "enemy_vo_prio_1",
		wwise_route = 18,
		response = "traitor_guard_rifleman_ranged_idle_player_low_on_ammo",
		database = "enemy_vo",
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
				OP.EQ,
				"reload_failed_out_of_ammo"
			},
			{
				"user_memory",
				"last_replied",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_replied",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_guard_rifleman_take_cover",
		wwise_route = 18,
		response = "traitor_guard_rifleman_take_cover",
		database = "enemy_vo",
		category = "enemy_vo_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"take_cover"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_rifleman"
			},
			{
				"user_memory",
				"traitor_guard_rifleman_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				8
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_guard_rifleman_take_cover",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_take_cover",
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
		name = "traitor_guard_rifleman_take_position",
		category = "enemy_vo_prio_1",
		wwise_route = 18,
		response = "traitor_guard_rifleman_take_position",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"take_position"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_rifleman"
			},
			{
				"user_memory",
				"traitor_guard_rifleman_take_position",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_take_position",
				OP.TIMEDIFF,
				OP.GT,
				8
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_guard_rifleman_take_position",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_take_position",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "traitor_guard_smg_rusher_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 18,
		response = "traitor_guard_smg_rusher_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_assault"
			},
			{
				"user_memory",
				"traitor_guard_smg_rusher_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_smg_rusher_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_guard_smg_rusher_alerted_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_smg_rusher_alerted_idle",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "traitor_guard_smg_rusher_ranged_idle",
		wwise_route = 18,
		response = "traitor_guard_smg_rusher_ranged_idle",
		database = "enemy_vo",
		category = "enemy_vo_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"ranged_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_assault"
			},
			{
				"user_memory",
				"traitor_guard_smg_rusher_ranged_idle",
				OP.TIMEDIFF,
				OP.GT,
				8
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_smg_rusher_ranged_idle",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_guard_smg_rusher_ranged_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_smg_rusher_ranged_idle",
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
		name = "traitor_guard_smg_rusher_ranged_idle_player_low_on_ammo",
		category = "enemy_vo_prio_1",
		wwise_route = 18,
		response = "traitor_guard_smg_rusher_ranged_idle_player_low_on_ammo",
		database = "enemy_vo",
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
				OP.EQ,
				"reload_failed_out_of_ammo"
			},
			{
				"user_memory",
				"last_replied",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_replied",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_guard_smg_rusher_ranged_idle_player_low_on_health",
		category = "enemy_vo_prio_1",
		wwise_route = 18,
		response = "traitor_guard_smg_rusher_ranged_idle_player_low_on_health",
		database = "enemy_vo",
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
				OP.EQ,
				"critical_health"
			},
			{
				"user_memory",
				"last_replied",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_replied",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_guard_smg_rusher_take_cover",
		wwise_route = 18,
		response = "traitor_guard_smg_rusher_take_cover",
		database = "enemy_vo",
		category = "enemy_vo_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"take_cover"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_assault"
			},
			{
				"user_memory",
				"enemy_memory_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_take_cover",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_take_cover",
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
		name = "traitor_guard_smg_rusher_take_position",
		category = "enemy_vo_prio_1",
		wwise_route = 18,
		response = "traitor_guard_smg_rusher_take_position",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"take_position"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_assault"
			},
			{
				"user_memory",
				"enemy_memory_take_position",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_take_position",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_take_position",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_take_position",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "traitor_gunner_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 11,
		response = "traitor_gunner_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_gunner"
			},
			{
				"user_memory",
				"enemy_memory_traitor_gunner_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				6
			},
			{
				"faction_memory",
				"faction_memory_traitor_gunner_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_traitor_gunner_alerted_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_gunner_alerted_idle",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_gunner_ranged_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 11,
		response = "traitor_gunner_ranged_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"ranged_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_gunner"
			},
			{
				"user_memory",
				"enemy_memory_traitor_gunner_ranged_idle",
				OP.TIMEDIFF,
				OP.GT,
				40
			},
			{
				"faction_memory",
				"faction_memory_traitor_gunner_ranged_idle",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_traitor_gunner_ranged_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_gunner_ranged_idle",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_gunner_ranged_idle_player_low_on_ammo",
		category = "enemy_vo_prio_1",
		wwise_route = 18,
		response = "traitor_gunner_ranged_idle_player_low_on_ammo",
		database = "enemy_vo",
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
				OP.EQ,
				"reload_failed_out_of_ammo"
			},
			{
				"user_memory",
				"last_replied",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_replied",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_gunner_ranged_idle_player_low_on_health",
		category = "enemy_vo_prio_1",
		wwise_route = 18,
		response = "traitor_gunner_ranged_idle_player_low_on_health",
		database = "enemy_vo",
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
				OP.EQ,
				"critical_health"
			},
			{
				"user_memory",
				"last_replied",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_replied",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_gunner_start_shooting",
		category = "enemy_vo_prio_1",
		wwise_route = 11,
		response = "traitor_gunner_start_shooting",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_shooting"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_gunner"
			},
			{
				"user_memory",
				"enemy_memory_traitor_gunner_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				3
			},
			{
				"faction_memory",
				"faction_memory_traitor_gunner_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_traitor_gunner_start_shooting",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_gunner_start_shooting",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_gunner_take_cover",
		category = "enemy_vo_prio_1",
		wwise_route = 11,
		response = "traitor_gunner_take_cover",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"take_cover"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_gunner"
			},
			{
				"user_memory",
				"enemy_memory_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"faction_memory_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_take_cover",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_take_cover",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_gunner_take_position",
		category = "enemy_vo_prio_1",
		wwise_route = 11,
		response = "traitor_gunner_take_position",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"take_position"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_gunner"
			},
			{
				"user_memory",
				"enemy_memory_take_position",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"faction_memory_take_position",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_take_position",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_take_position",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_netgunner_assault",
		category = "enemy_vo_prio_0",
		wwise_route = 14,
		response = "traitor_netgunner_assault",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"assault"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_netgunner"
			},
			{
				"faction_memory",
				"faction_traitor_netgunner_assault",
				OP.TIMEDIFF,
				OP.GT,
				2
			},
			{
				"user_memory",
				"user_traitor_netgunner_assault",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"faction_memory",
				"faction_traitor_netgunner_assault",
				OP.TIMESET
			},
			{
				"user_memory",
				"user_traitor_netgunner_assault",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "traitor_netgunner_catching_net",
		wwise_route = 14,
		response = "traitor_netgunner_catching_net",
		database = "enemy_vo",
		category = "enemy_vo_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"catching_net"
			},
			{
				"user_memory",
				"traitor_netgunner_catching_net",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_netgunner_catching_net",
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
		name = "traitor_netgunner_spawned",
		wwise_route = 14,
		response = "traitor_netgunner_spawned",
		database = "enemy_vo",
		category = "enemy_vo_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"spawned"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_netgunner"
			},
			{
				"faction_memory",
				"faction_memory_traitor_netgunner_spawned",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_traitor_netgunner_spawned",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 3
			}
		}
	})
	define_rule({
		name = "traitor_netgunner_throwing_net",
		category = "enemy_vo_prio_0",
		wwise_route = 14,
		response = "traitor_netgunner_throwing_net",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"throwing_net"
			},
			{
				"user_memory",
				"traitor_net_gunner_throwing_net",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_net_gunner_throwing_net",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "traitor_scout_shocktrooper_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 12,
		response = "traitor_scout_shocktrooper_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper"
			},
			{
				"user_memory",
				"enemy_memory_traitor_scout_shocktrooper_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				6
			},
			{
				"faction_memory",
				"faction_memory_traitor_scout_shocktrooper_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				3
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_traitor_scout_shocktrooper_alerted_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_scout_shocktrooper_alerted_idle",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "traitor_scout_shocktrooper_melee_idle",
		wwise_route = 12,
		response = "traitor_scout_shocktrooper_melee_idle",
		database = "enemy_vo",
		category = "enemy_vo_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"melee_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper"
			},
			{
				"user_memory",
				"traitor_scout_shocktrooper_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				15
			},
			{
				"faction_memory",
				"faction_memory_traitor_scout_shocktrooper_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_scout_shocktrooper_melee_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_scout_shocktrooper_melee_idle",
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
		name = "traitor_scout_shocktrooper_no_damage",
		wwise_route = 12,
		response = "traitor_scout_shocktrooper_no_damage",
		database = "enemy_vo",
		category = "enemy_vo_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"no_damage_taunt"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper"
			},
			{
				"user_memory",
				"enemy_memory_no_damage_taunt",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_no_damage_taunt",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_no_damage_taunt",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_no_damage_taunt",
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
		name = "traitor_scout_shocktrooper_take_cover",
		category = "enemy_vo_prio_1",
		wwise_route = 12,
		response = "traitor_scout_shocktrooper_take_cover",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"take_cover"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper"
			},
			{
				"user_memory",
				"enemy_memory_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"faction_memory_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_take_cover",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_take_cover",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_scout_shocktrooper_take_position",
		category = "enemy_vo_prio_1",
		wwise_route = 12,
		response = "traitor_scout_shocktrooper_take_position",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"take_position"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper"
			},
			{
				"user_memory",
				"traitor_scout_shocktrooper_take_position",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"faction_memory_traitor_scout_shocktrooper_take_position",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_scout_shocktrooper_take_position",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_scout_shocktrooper_take_position",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_shocktrooper_start_shooting",
		category = "enemy_vo_prio_1",
		wwise_route = 12,
		response = "traitor_shocktrooper_start_shooting",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"start_shooting"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper"
			},
			{
				"faction_memory",
				"faction_memory_shocktrooper_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_shocktrooper_start_shooting",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_trenchfighter_alerted_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 16,
		response = "traitor_trenchfighter_alerted_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"alerted_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_melee"
			},
			{
				"user_memory",
				"traitor_trenchfighter_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10
			},
			{
				"faction_memory",
				"faction_memory_traitor_trenchfighter_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_trenchfighter_alerted_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_trenchfighter_alerted_idle",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_trenchfighter_assault",
		category = "enemy_vo_prio_1",
		wwise_route = 16,
		response = "traitor_trenchfighter_assault",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"assault"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_melee"
			},
			{
				"user_memory",
				"traitor_trenchfighter_assault",
				OP.TIMEDIFF,
				OP.GT,
				6
			},
			{
				"faction_memory",
				"faction_trenchfighter_assault",
				OP.TIMEDIFF,
				OP.GT,
				2
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_trenchfighter_assault",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_trenchfighter_assault",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "traitor_trenchfighter_melee_idle",
		category = "enemy_vo_prio_1",
		wwise_route = 16,
		response = "traitor_trenchfighter_melee_idle",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"melee_idle"
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_melee"
			},
			{
				"user_memory",
				"traitor_trenchfighter_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				8
			},
			{
				"faction_memory",
				"faction_memory_traitor_trenchfighter_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				4
			}
		},
		on_done = {
			{
				"user_memory",
				"traitor_trenchfighter_melee_idle",
				OP.TIMESET
			},
			{
				"faction_memory",
				"faction_memory_traitor_trenchfighter_melee_idle",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "twin_spawn_laugh_a",
		category = "enemy_vo_prio_0",
		wwise_route = 51,
		response = "twin_spawn_laugh_a",
		database = "enemy_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_enemy_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"taunt"
			},
			{
				"query_context",
				"enemy_tag",
				OP.SET_INCLUDES,
				args = {
					"renegade_twin_captain",
					"renegade_twin_captain_two"
				}
			},
			{
				"global_context",
				"current_mission",
				OP.NEQ,
				"km_enforcer_twins"
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		}
	})
end
